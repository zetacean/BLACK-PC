# Releases y GitHub Actions / Releases and GitHub Actions

**Español** · [English](#english)

## Los workflows

| Archivo | Cuándo | Dónde corre | Qué hace |
|---|---|---|---|
| `.github/workflows/tests.yml` | push / PR que toque subtítulos, guardado o `tests/` | runner de GitHub (`windows-latest`) | Compila con clang y ejecuta las pruebas (subtítulos y almacenamiento de guardados) |
| `.github/workflows/release.yml` | al subir una etiqueta `v*`, o a mano (*Run workflow*) | runner de GitHub (`windows-latest`) | Pruebas, compilación, `release.bat`, comprobación del paquete y publicación del release |

### Cómo compila sin el juego

El `default.xbe` **no puede estar en el repositorio**, y el ejecutable normal se enlaza con información de él. Para que GitHub pueda compilar, el repo incluye `prebuilt/`: solo **nombres y direcciones de las funciones del xbe**, sin código del juego (`image_symbols.h`, `hook_exports.h`, `x86_recomp_shared.h`, `imports.def`, y el SHA-1 del xbe USA en `default.xbe.sha1`).

- Al regenerar `prebuilt/`, `tools/refresh_prebuilt.py` pone el xbe un momento en `assets\default.xbe` (la ruta que exige el SDK) y CMake recompila el juego; luego lo borra. En el resto de casos `assets\` no existe.
- Sin él, CMake construye **solo el ejecutable** a partir de `prebuilt/`. Es el mismo ejecutable que lleva el release: no contiene el código del juego, que se compila en el primer arranque a partir del xbe del jugador (`Black.dll`).

Verificado: un ejecutable construido así con el xbe oculto arranca, reconoce el juego por SHA-1 y empieza a compilar `Black.dll`.

### Regenerar `prebuilt/`

Solo hace falta si cambian `config/game.toml` o los hooks (`X86_FUNC`) de `src/`. Con tu copia del juego (la herramienta hace la compilación completa y limpia después):

```
python tools/refresh_prebuilt.py "C:\ruta\juego.iso"
git add prebuilt && git commit -m "Refresh prebuilt"
```

Si el release falla al enlazar con símbolos sin resolver, es que `prebuilt/` quedó desactualizado.

> **Decisión sobre derechos:** `prebuilt/` es un mapa de funciones derivado del xbe (≈1.5 MB). No contiene instrucciones ni datos del juego, pero sí deriva de él; si prefieres no publicarlo, puedes quitarlo y volver a un runner propio con el juego.

## Publicar una versión

Con la IA (recomendado): `/release vX.Y.Z` en Claude Code ejecuta el procedimiento de `.claude/commands/release.md` y pide confirmación antes de empujar o etiquetar. Requiere `gh` autenticado (`gh auth login`, una vez).

A mano:

1. Escribe `docs/release-notes/vX.Y.Z.md` (plantilla en [release-notes/README.md](release-notes/README.md)): es el cuerpo del release.
2. Pruebas, `build.bat`, `release.bat` y una instalación de prueba.
3. `git push origin main`, luego `git tag -a vX.Y.Z -m "BLACK PC vX.Y.Z"` y `git push origin vX.Y.Z` (solo esa etiqueta, nunca `--tags`: el repo trae etiquetas heredadas de los proyectos base).
4. Seguimiento: `gh run watch`; resultado: `gh release view vX.Y.Z`.

El release incluye `BLACK-PC-Setup.exe` (el instalador, ver [INSTALLER.md](INSTALLER.md)) y `BLACK-PC.zip` (`BLACK.exe`, carpeta `compiler` con clang y lld, runtimes de Visual C++ y D3D, README, licencias). El workflow comprueba que el zip no contenga `default.xbe`, `GlobData.bin` ni `.iso`. Para ensayar sin publicar: `gh workflow run release.yml` (sin marcar *publish*); los archivos quedan 14 días como artefacto del run.

## Sin Actions (manual)

```
build.bat
release.bat
gh release create vX.Y.Z BLACK-PC-Setup.exe BLACK-PC.zip --title "BLACK PC vX.Y.Z" --notes-file docs/release-notes/vX.Y.Z.md
```

## Tamaño del repositorio

El pack de texturas HD **se retiró** del repositorio y de los releases por su tamaño (≈1.2 GB). Los runtimes DLSS/FSR también se quitaron.

---

<a name="english"></a>

# English

## The workflows

| File | When | Where | What |
|---|---|---|---|
| `tests.yml` | push / PR touching subtitles, saves or `tests/` | GitHub runner (`windows-latest`) | builds with clang and runs the subtitle and save-storage tests |
| `release.yml` | pushing a `v*` tag, or manually | GitHub runner (`windows-latest`) | tests, build, `release.bat`, package check, publishes the release |

**How it builds without the game:** `default.xbe` must not be in the repo and the normal executable links against information from it. So the repo holds `prebuilt/`: only the **names and addresses of the xbe's functions**, no game code (`image_symbols.h`, `hook_exports.h`, `x86_recomp_shared.h`, `imports.def`, plus the USA xbe's SHA-1). With `assets\default.xbe` present CMake recompiles the game as usual and ignores `prebuilt/`; without it, CMake builds **only the executable** from `prebuilt/`, the same executable a release ships (the game's code is built on the player's first start from their own xbe). Checked: an executable built this way with the xbe hidden starts, recognises the game by SHA-1 and begins compiling `Black.dll`.

**Refreshing `prebuilt/`:** only when `config/game.toml` or the `X86_FUNC` hooks in `src/` change. With your copy of the game: `python tools/refresh_prebuilt.py "C:\path\game.iso"` (it does the full build and cleans up), then commit. If the release fails linking with unresolved symbols, `prebuilt/` is stale.

> **Rights note:** `prebuilt/` is a function map derived from the xbe (≈1.5 MB). It holds no instructions or game data, but it derives from the game; if you prefer not to publish it, remove it and go back to a self-hosted runner that has the game.

**Publishing:** with the AI (recommended), `/release vX.Y.Z` in Claude Code runs `.claude/commands/release.md` and asks before pushing or tagging; it needs `gh` authenticated once (`gh auth login`). By hand: write `docs/release-notes/vX.Y.Z.md` (the release body, template in [release-notes/README.md](release-notes/README.md)); tests, `build.bat`, `release.bat` and a trial install; `git push origin main`; `git tag -a vX.Y.Z -m "BLACK PC vX.Y.Z"` and `git push origin vX.Y.Z` (only that tag, never `--tags`: the repo carries tags inherited from the base projects); then `gh run watch` and `gh release view vX.Y.Z`. The release has `BLACK-PC-Setup.exe` (the installer, see [INSTALLER.md](INSTALLER.md)) and `BLACK-PC.zip` (`BLACK.exe`, the `compiler` folder with clang and lld, VC/D3D runtimes, README, licences); the workflow fails if the zip holds `default.xbe`, `GlobData.bin` or an `.iso`. To rehearse without publishing: `gh workflow run release.yml` (leave *publish* unticked); the files stay 14 days as a run artifact.

**Manual:** `build.bat`, `release.bat`, then `gh release create vX.Y.Z BLACK-PC-Setup.exe BLACK-PC.zip --notes-file docs/release-notes/vX.Y.Z.md`.

**Repository size:** the HD texture pack (≈1.2 GB) and the DLSS/FSR runtimes were dropped.
