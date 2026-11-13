# BLACK PC

**Español** · [English](#english)

Port nativo para PC de **BLACK (2006, Xbox original)** mediante recompilación estática del `default.xbe`. Es una build comunitaria no oficial que **une dos proyectos**: el port de [TGP482](https://github.com/TGP482/BLACK-XBERecomp) (base, con gyro, compilador integrado, texture dumper, etc.) y el fork de [soldieg](https://github.com/soldieg/BLACK-XBERecomp) (subtítulos, idiomas, armas F10, gameplay V2.0, guardado propio, pack HD). Los dos se apoyan en el SDK [XboxXBE-Recomp](https://github.com/TGP482/XboxXBE-Recomp).

> Este proyecto **no incluye el juego**. Necesitas tu propia copia (ISO o archivos extraídos, edición USA o Europa).

## Jugar (release)

**Con instalador (recomendado):** descarga `BLACK-PC-Setup.exe` de *Releases*, ejecútalo y elige el `.iso` de tu copia (USA o Europa). Extrae el juego, construye lo necesario y limpia; ver [docs/INSTALLER.md](docs/INSTALLER.md).

**Sin instalador:**

1. Descarga `BLACK-PC.zip` de *Releases*.
2. Extrae `BLACK-PC.zip` en una carpeta y pon el `.iso` de tu copia (USA o Europa) junto a `BLACK.exe`. Como alternativa, los archivos extraídos del juego también funcionan.
3. Texturas: el pack HD del fork **no se distribuye** (pesaba demasiado); el reemplazo de texturas sigue disponible con tus propias texturas (ver [docs/TEXTURES-AND-LANGUAGES.md](docs/TEXTURES-AND-LANGUAGES.md)).
4. Ejecuta `BLACK.exe`. La primera vez compila el código del juego para tu PC (una sola vez). Los ajustes se abren con **F10**.
5. No copies el `black.toml`, `logs` ni los guardados de otra instalación.

Si Windows Defender pone en cuarentena `BLACK.exe` (ejecutable sin firma digital, detección heurística), excluye la carpeta de instalación.

## Documentación

| Documento | Contenido |
|---|---|
| [docs/BUILDING.md](docs/BUILDING.md) | Cómo compilar paso a paso (incluye ISO Europa) |
| [docs/CHANGES.md](docs/CHANGES.md) | Qué se hizo y cómo se fusionaron los dos proyectos base |
| [docs/COMPARISON.md](docs/COMPARISON.md) | Comparación con los dos repositorios base, función por función |
| [docs/TEXTURES-AND-LANGUAGES.md](docs/TEXTURES-AND-LANGUAGES.md) | Texturas HD, idiomas y subtítulos |
| [docs/INSTALLER.md](docs/INSTALLER.md) | El instalador: uso y funcionamiento |
| [docs/RELEASING.md](docs/RELEASING.md) | GitHub Actions y publicación de releases |
| [CLAUDE.md](CLAUDE.md) | Instrucciones para seguir desarrollando con un asistente de IA (y `.claude/commands/`: `/release`, `/build`, `/refresh-prebuilt`) |

## Contenido del repositorio

`src/` código del port · `config/game.toml` símbolos y hooks del `default.xbe` · `prebuilt/` mapa de funciones para compilar sin el juego · `tools/` scripts · `tests/` pruebas · `.github/workflows/` CI y release.

## Licencias

- El SDK [XboxXBE-Recomp](https://github.com/TGP482/XboxXBE-Recomp) es MIT (`LICENSE-SDK-MIT.txt`); las bibliotecas que enlaza el ejecutable (toml++, Dear ImGui, SDL…) están en `THIRD_PARTY.txt`. Ambos van en el paquete.
- Los dos repositorios de los que parte este proyecto (TGP482 y soldieg) **no publican licencia**: el código del port pertenece a sus autores y este repositorio no le añade ninguna. Antes de redistribuir fuera de pruebas, conviene pedirles permiso o una licencia.
- BLACK es de EA/Criterion; el juego no se incluye ni se redistribuye.

## Créditos

BLACK PC existe gracias al trabajo de otros, y este repositorio parte de él:

- **[TGP482](https://github.com/TGP482)**: el port original [BLACK-XBERecomp](https://github.com/TGP482/BLACK-XBERecomp) y el SDK [XboxXBE-Recomp](https://github.com/TGP482/XboxXBE-Recomp), con sus colaboradores (ver [contributors](https://github.com/TGP482/BLACK-XBERecomp/graphs/contributors)).
- **[soldieg](https://github.com/soldieg)**: el fork [BLACK-XBERecomp](https://github.com/soldieg/BLACK-XBERecomp) (idiomas, subtítulos, guardado, armas F10, cargador de texturas) y los paquetes de [BLACK-SUBTITLES](https://github.com/soldieg/BLACK-SUBTITLES), con sus colaboradores.
- BLACK es de Criterion Games / Electronic Arts. Este proyecto no está afiliado a ellos y no incluye el juego.

Los commits de este repositorio se reunieron en uno solo; la autoría del código anterior sigue siendo de quienes lo escribieron, en los enlaces de arriba.

---

<a name="english"></a>

# English

A native PC port of **BLACK (2006, original Xbox)** by static recompilation of `default.xbe`. This unofficial community build **merges two projects**: [TGP482's port](https://github.com/TGP482/BLACK-XBERecomp) (the base: gyro, built-in code compiler, texture dumper…) and [soldieg's fork](https://github.com/soldieg/BLACK-XBERecomp) (subtitles, languages, F10 weapons, V2.0 gameplay, own save handling, HD pack). Both build on the [XboxXBE-Recomp](https://github.com/TGP482/XboxXBE-Recomp) SDK.

> This project **does not include the game**. You need your own copy (ISO or extracted files, USA or Europe release).

## Playing (release)

**With the installer (recommended):** download `BLACK-PC-Setup.exe` from *Releases*, run it and pick your copy's `.iso` (USA or Europe). It extracts the game, builds what it needs and cleans up; see [docs/INSTALLER.md](docs/INSTALLER.md).

**Without it:**

1. From *Releases* download `BLACK-PC.zip`.
2. Extract `BLACK-PC.zip` to a folder and put your copy's `.iso` (USA or Europe) beside `BLACK.exe`. The game's extracted files work too.
3. Textures: the fork's HD pack is **not distributed** (too large); texture replacement still works with your own textures (see [docs/TEXTURES-AND-LANGUAGES.md](docs/TEXTURES-AND-LANGUAGES.md)).
4. Run `BLACK.exe`. The first start compiles the game's code for your PC (once). Settings open with **F10**.
5. Do not copy another installation's `black.toml`, `logs` or saves.

If Windows Defender quarantines `BLACK.exe` (unsigned executable, heuristic detection), exclude the install folder.

## Documentation

See the table above: [BUILDING](docs/BUILDING.md) · [CHANGES](docs/CHANGES.md) · [COMPARISON](docs/COMPARISON.md) · [INSTALLER](docs/INSTALLER.md) · [TEXTURES-AND-LANGUAGES](docs/TEXTURES-AND-LANGUAGES.md) · [RELEASING](docs/RELEASING.md).

## Licences

- The [XboxXBE-Recomp](https://github.com/TGP482/XboxXBE-Recomp) SDK is MIT (`LICENSE-SDK-MIT.txt`); the libraries the executable links (toml++, Dear ImGui, SDL…) are in `THIRD_PARTY.txt`. Both ship in the package.
- The two repositories this project comes from (TGP482 and soldieg) **publish no licence**: the port's code belongs to its authors and this repository adds none. Before redistributing beyond testing, ask them for permission or a licence.
- BLACK belongs to EA/Criterion; the game is not included or redistributed.

## Credits

BLACK PC exists thanks to the work of others, and this repository starts from it:

- **[TGP482](https://github.com/TGP482)**: the original port [BLACK-XBERecomp](https://github.com/TGP482/BLACK-XBERecomp) and the [XboxXBE-Recomp](https://github.com/TGP482/XboxXBE-Recomp) SDK, with their contributors ([contributors](https://github.com/TGP482/BLACK-XBERecomp/graphs/contributors)).
- **[soldieg](https://github.com/soldieg)**: the [BLACK-XBERecomp](https://github.com/soldieg/BLACK-XBERecomp) fork (languages, subtitles, saves, F10 weapons, texture loader) and the [BLACK-SUBTITLES](https://github.com/soldieg/BLACK-SUBTITLES) packages, with their contributors.
- BLACK belongs to Criterion Games / Electronic Arts. This project is not affiliated with them and does not include the game.

This repository's commits were gathered into one; the authorship of the earlier code remains with the people who wrote it, at the links above.
