"""Refreshes prebuilt/ from your own copy of the game. Maintainers only: nobody who plays or builds the release needs this.

    python tools/refresh_prebuilt.py <game.iso | default.xbe>

When it is needed: only after config/game.toml or the X86_FUNC hooks in src/ change (see prebuilt/README.md).

What it does, in order:
  1. takes default.xbe from the disc image (USA or Europe) or from the file given;
  2. turns the Europe xbe into the USA one with src/common/europe.patch (the patch BLACK.exe applies at run time);
  3. puts it at assets/default.xbe, the path the SDK build expects, and runs build.bat, which recompiles the game;
  4. copies what the executable links against into prebuilt/ and deletes assets/ and the recompiled code again.
"""
import hashlib
import os
import pathlib
import shutil
import struct
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
EUROPE_SHA1 = "796ad8369354e48aa15644d4707dd70bd3bc3b4c"
US_SHA1 = "c5bfed25449c8212d7a976f15246e87ead57713f"
# where the game partition starts in a disc dump: a bare xiso, then the Xbox 1 / 360 layouts
PARTITIONS = [0, 0x18300000, 0xFD90000, 0x2080000]
PREBUILT = ["image_symbols.h", "hook_exports.h", "x86_recomp_shared.h", "imports.def"]


def xbe_from_disc(path):
    with open(path, "rb") as f:
        for base in PARTITIONS:
            f.seek(base + 0x10000)
            head = f.read(0x20)
            if head[:20] != b"MICROSOFT*XBOX*MEDIA":
                continue
            root_sector, root_size = struct.unpack_from("<II", head, 0x14)

            def read(offset, size):
                f.seek(base + offset)
                return f.read(size)

            table = read(root_sector * 2048, root_size)
            todo, seen = [0], set()
            while todo:
                at = todo.pop()
                if at in seen or at + 14 > len(table):
                    continue
                seen.add(at)
                left, right, sector, size, _attrs, length = struct.unpack_from("<HHIIBB", table, at)
                if left == 0xFFFF and right == 0xFFFF and sector == 0xFFFFFFFF:
                    continue
                name = table[at + 14:at + 14 + length].decode("latin-1")
                if name.lower() == "default.xbe":
                    return read(sector * 2048, size)
                todo += [left * 4, right * 4]
    sys.exit(f"{path}: no Xbox disc image with a default.xbe in it")


def to_us(xbe):
    sha = hashlib.sha1(xbe).hexdigest()
    if sha == US_SHA1:
        return xbe
    if sha != EUROPE_SHA1:
        sys.exit(f"default.xbe sha1 {sha} is neither the USA nor the Europe release")
    patch = (ROOT / "src" / "common" / "europe.patch").read_bytes()
    at = 0

    def number():
        nonlocal at
        n = 0
        for shift in range(0, 64, 7):
            b = patch[at]
            at += 1
            n |= (b & 0x7F) << shift
            if b < 0x80:
                return n
        sys.exit("bad europe.patch")

    out, read = bytearray(), 0
    while at < len(patch):
        copy = number()
        start = len(out)
        out += xbe[read:read + copy]
        pos = 0
        for _ in range(number()):
            pos += number()
            out[start + pos] = (out[start + pos] + patch[at]) & 0xFF
            at += 1
            pos += 1
        added = number()
        out += patch[at:at + added]
        at += added
        move = number()
        end = read + copy
        read = end + (move >> 1) if not move & 1 else end - (move >> 1) - 1
    if hashlib.sha1(out).hexdigest() != US_SHA1:
        sys.exit("the converted xbe is not the USA release: europe.patch does not fit")
    return bytes(out)


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    source = pathlib.Path(sys.argv[1])
    xbe = source.read_bytes() if source.suffix.lower() == ".xbe" else xbe_from_disc(source)
    xbe = to_us(xbe)
    assets = ROOT / "assets"
    if assets.exists():
        sys.exit("assets/ already exists: remove it (or finish what you were doing) first")
    assets.mkdir()
    (assets / "default.xbe").write_bytes(xbe)
    try:
        env = dict(os.environ, CI="1")  # build.bat asks nothing under CI
        if subprocess.run(["cmd", "/c", str(ROOT / "build.bat")], cwd=ROOT, env=env).returncode:
            sys.exit("build.bat failed")
        gen = ROOT / "generated" / "game"
        out = ROOT / "prebuilt"
        out.mkdir(exist_ok=True)
        for name in PREBUILT:
            shutil.copyfile(gen / name, out / name)
        (out / "default.xbe.sha1").write_text(US_SHA1 + "\n")
    finally:
        shutil.rmtree(assets, ignore_errors=True)
        shutil.rmtree(ROOT / "generated", ignore_errors=True)
    print("prebuilt/ refreshed: git diff prebuilt shows what changed")


main()
