// The game beside the executable: its files, or a disc image (.iso) with this executable's xbe on it. The xbe must be the one
// this executable was recompiled from; another release's would run its own data under this code. The Europe xbe is
// turned into the US one by europe.patch (tools/europe_patch.py); the rest of the Europe disc is the US files plus
// its languages.
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <windows.h>
#include <shellapi.h>

#include <algorithm>
#include <cstring>
#include <cwctype>
#include <fstream>
#include <functional>

#include "app/app.h"
#include "common/native_dialogs.h"
#include "core/log.h"
#include "image_symbols.h"
#include "kernel/crypto.h"
#include "kernel/disc.h"

extern const char kImageSha1[];  // the xbe recompiled into this executable, written by CMake

namespace app {

namespace {

namespace fs = std::filesystem;

}  // namespace

std::string Sha1(const std::vector<uint8_t>& data) {
    alignas(8) uint8_t ctx[128];
    uint8_t digest[20];
    crypto::ShaInit(ctx);
    crypto::ShaUpdate(ctx, data.data(), data.size());
    crypto::ShaFinal(ctx, digest);
    std::string hex;
    for (uint8_t b : digest) {
        hex += "0123456789abcdef"[b >> 4];
        hex += "0123456789abcdef"[b & 15];
    }
    return hex;
}

namespace {

bool ReadHostFile(const fs::path& path, std::vector<uint8_t>& out) {
    std::ifstream f(path, std::ios::binary);
    if (!f) return false;
    out.assign(std::istreambuf_iterator<char>(f), {});
    return true;
}

constexpr char kEuropeSha1[] = "796ad8369354e48aa15644d4707dd70bd3bc3b4c";

class PatchReader {
public:
    PatchReader(const uint8_t* data, size_t size) : at_(data), end_(data + size) {}
    bool Done() const { return at_ == end_; }
    bool Failed() const { return failed_; }

    uint8_t Byte() {
        if (at_ == end_) {
            failed_ = true;
            return 0;
        }
        return *at_++;
    }

    // 7 bits a byte, low first
    uint64_t Number() {
        uint64_t n = 0;
        for (int shift = 0; shift < 64; shift += 7) {
            uint8_t b = Byte();
            n |= uint64_t(b & 0x7F) << shift;
            if (b < 0x80) return n;
        }
        failed_ = true;
        return 0;
    }

private:
    const uint8_t* at_;
    const uint8_t* end_;
    bool failed_ = false;
};

// europe.patch applied to the Europe xbe, block by block
struct EuropePatch {
    const std::vector<uint8_t>& from;
    PatchReader patch;
    uint64_t read = 0;
    std::vector<uint8_t> out;

    // bytes copied from the Europe xbe with a few of them changed, new bytes, then a move of the read position
    bool ApplyBlock() {
        uint64_t copy = patch.Number();
        if (read > from.size() || copy > from.size() - read) return false;
        size_t start = out.size();
        out.insert(out.end(), from.begin() + read, from.begin() + read + copy);
        uint64_t changes = patch.Number();
        uint64_t at = 0;
        for (uint64_t i = 0; i < changes && !patch.Failed(); i++) {
            at += patch.Number();
            if (at >= copy) return false;
            out[start + at] += patch.Byte();
            at++;
        }
        uint64_t added = patch.Number();
        for (uint64_t i = 0; i < added && !patch.Failed(); i++) out.push_back(patch.Byte());
        return MoveRead(read + copy) && !patch.Failed();
    }

    // even moves forward by half, odd back by half plus one
    bool MoveRead(uint64_t from_end) {
        uint64_t move = patch.Number();
        uint64_t distance = move >> 1;
        if (distance > from.size()) return false;
        if (!(move & 1)) {
            read = from_end + distance;
            return true;
        }
        if (distance >= from_end) return false;
        read = from_end - distance - 1;
        return true;
    }
};

// europe.patch from the executable's resources
bool LoadEuropePatch(const uint8_t*& data, size_t& size) {
    HRSRC res = FindResourceW(nullptr, L"EUROPE", RT_RCDATA);
    if (!res) return false;
    data = static_cast<const uint8_t*>(LockResource(LoadResource(nullptr, res)));
    size = SizeofResource(nullptr, res);
    return data && size;
}

// the US xbe in place of the Europe one; false leaves it as it was
bool ConvertEurope(std::vector<uint8_t>& xbe) {
    const uint8_t* data = nullptr;
    size_t size = 0;
    if (!LoadEuropePatch(data, size)) return false;
    EuropePatch europe{xbe, PatchReader(data, size)};
    while (!europe.patch.Done())
        if (!europe.ApplyBlock()) return false;
    xbe = std::move(europe.out);
    return true;
}

// The installer's step: --setup "<disc image>" writes the disc's files beside the executable, with the Europe
// xbe as the US one, so the game runs from plain files and the image is not needed again. An error is returned as text.
bool ExtractDisc(const fs::path& iso, const fs::path& assets, std::wstring& error) {
    kernel::Disc disc;
    std::string reason;
    if (!disc.Open(iso, reason)) {
        error = L"This is not an Xbox disc image: " + iso.wstring();
        return false;
    }
    std::vector<uint8_t> xbe;
    if (!disc.Load(IMAGE_XBE, xbe)) {
        error = L"The disc image has no " + std::wstring(IMAGE_XBE, IMAGE_XBE + std::strlen(IMAGE_XBE)) + L".";
        return false;
    }
    std::string sha = Sha1(xbe);
    if (sha == kEuropeSha1 && !ConvertEurope(xbe)) {
        error = L"The Europe release could not be converted.";
        return false;
    }
    if (Sha1(xbe) != kImageSha1) {
        error = L"This is not the release of BLACK this build is made for (USA or Europe).";
        return false;
    }
    std::error_code ec;
    std::vector<uint8_t> buffer(1 << 20);
    std::function<bool(const std::string&, const kernel::Disc::Entry&)> copy = [&](const std::string& path, const kernel::Disc::Entry& e) {
        fs::path target = assets / fs::u8path(path);
        if (e.dir) {
            fs::create_directories(target, ec);
            for (const kernel::Disc::Entry& child : e.children)
                if (!copy(path.empty() ? child.name : path + "/" + child.name, child)) return false;
            return true;
        }
        fs::create_directories(target.parent_path(), ec);
        std::ofstream out(target, std::ios::binary | std::ios::trunc);
        if (path == IMAGE_XBE) {  // the US xbe, whichever release the disc is
            out.write(reinterpret_cast<const char*>(xbe.data()), std::streamsize(xbe.size()));
        } else {
            for (uint64_t pos = 0; pos < e.size;) {
                uint32_t got = disc.Read(e, pos, buffer.data(), uint32_t(buffer.size()));
                if (!got) break;
                out.write(reinterpret_cast<const char*>(buffer.data()), got);
                pos += got;
            }
        }
        out.close();
        if (!out) {
            error = L"Writing " + target.wstring() + L" failed: is there room on the disk?";
            return false;
        }
        return true;
    };
    const kernel::Disc::Entry* root = disc.Find("");
    LOGR("Setup: extracting %s to %s", iso.string().c_str(), assets.string().c_str());
    return root && copy("", *root);
}

// the path after --setup on the command line, empty without it
fs::path SetupDisc() {
    int count = 0;
    wchar_t** args = CommandLineToArgvW(GetCommandLineW(), &count);
    fs::path iso;
    for (int i = 0; args && i + 1 < count; i++)
        if (std::wstring(args[i]) == L"--setup") iso = args[i + 1];
    if (args) LocalFree(args);
    return iso;
}

}  // namespace

bool FindGame(GameFiles& game) {
    if (fs::path iso = SetupDisc(); !iso.empty()) {
        std::wstring error;
        if (!ExtractDisc(iso, ExeDir(), error)) {
            MessageBoxW(nullptr, error.c_str(), kGame.short_title, MB_ICONERROR);
            return false;
        }
    }
    const fs::path assets = ExeDir();  // the game's files, or a disc image, beside the executable
    std::vector<fs::path> isos;
    std::error_code ec;
    for (auto& e : fs::directory_iterator(assets, ec)) {
        std::wstring ext = e.path().extension().wstring();
        std::transform(ext.begin(), ext.end(), ext.begin(), [](wchar_t c) { return wchar_t(std::towlower(c)); });
        if (ext == L".iso" && e.is_regular_file(ec)) isos.push_back(e.path());
    }
    std::sort(isos.begin(), isos.end());

    // the first copy with this xbe wins, the extracted files before any image; another release is kept to offer
    GameFiles other;
    std::unique_ptr<kernel::Disc> other_disc;
    fs::path other_name;
    auto consider = [&](const fs::path& name, std::vector<uint8_t> xbe, std::unique_ptr<kernel::Disc> disc) {
        std::string sha = Sha1(xbe);
        bool europe = sha == kEuropeSha1;
        if (europe) europe = ConvertEurope(xbe);
        std::string image_sha = europe ? Sha1(xbe) : sha;
        bool match = image_sha == kImageSha1;
        const char* release = europe ? ", Europe release" : "";
        LOGR("Game: %s in %s, sha1 %s%s%s", IMAGE_XBE, name.string().c_str(), sha.c_str(), release,
             match ? "" : ", another release");
        if (match) {
            game = {assets, std::move(xbe)};
            kernel::MountDisc(std::move(disc));
            return true;
        }
        if (other_name.empty()) {
            other = {assets, std::move(xbe)};
            other_disc = std::move(disc);
            other_name = name;
        }
        return false;
    };

    std::vector<uint8_t> xbe;
    bool extracted = !assets.empty() && ReadHostFile(assets / IMAGE_XBE, xbe);
    if (extracted && consider(assets, std::move(xbe), nullptr)) return true;
    for (const fs::path& iso : isos) {
        auto disc = std::make_unique<kernel::Disc>();
        std::string error;
        if (!disc->Open(iso, error)) {
            LOGW("game: %s: %s", iso.string().c_str(), error.c_str());
            continue;
        }
        if (!disc->Load(IMAGE_XBE, xbe)) {
            LOGW("game: %s has no %s", iso.string().c_str(), IMAGE_XBE);
            continue;
        }
        if (consider(iso, std::move(xbe), std::move(disc))) return true;
    }

    if (other_name.empty()) {
        const std::wstring missing = native_dialogs::Text(native_dialogs::TextId::GameFilesMissing);
        MessageBoxW(nullptr, missing.c_str(), kGame.short_title, MB_ICONERROR);
        return false;
    }
    std::wstring text = native_dialogs::GameReleaseWarning(other_name.filename().wstring());
    int answer = MessageBoxW(nullptr, text.c_str(), kGame.short_title, MB_ICONWARNING | MB_YESNO | MB_DEFBUTTON2);
    if (answer != IDYES) return false;
    game = std::move(other);
    kernel::MountDisc(std::move(other_disc));
    return true;
}

}  // namespace app
