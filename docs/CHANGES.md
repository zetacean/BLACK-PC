# Qué se hizo y en qué se diferencia / What was done and how it differs

**Español** · [English](#english)

## Los dos proyectos base

| | **A. TGP482/BLACK-XBERecomp** ("upstream") | **B. soldieg/BLACK-XBERecomp** (fork "Build V2.0") |
|---|---|---|
| Punto usado | `main` @ `10b8464` (2026-10-29) | `main` @ `8721350` (2026-10-22) |
| Ancestro común | `39ad697` (2026-10-15) | igual |
| Commits desde el ancestro | 47 | 48 |

Ambos son la capa específica del juego sobre el SDK **TGP482/XboxXBE-Recomp** (recompilador x86→C++ + runtime). Divergieron desde el mismo punto y cada uno añadió cosas distintas; el fork solo había integrado upstream hasta el 2026-10-18.

## Qué aporta cada base (y quedó en esta build)

**De A (upstream):**
- **Gyro** (`src/common/gyro.*`): apuntado con giroscopio (DualSense, DualShock 4, Switch Pro), eje, botón, recentrado y calibración.
- **Compilador integrado** (`src/app/game_code.cpp`): el release lleva `clang` + `lld-link`; la primera vez que arrancas compila el código del juego a `Black.dll` en tu equipo.
- **Texture dumper/replacer** (en el SDK): volcar texturas a `textures\dumps` y reemplazarlas desde `textures\replacement` (PNG/DDS).
- Colour Blind, sensibilidad por separado (vertical, apuntando, mando), invertir ejes, zona muerta, rango de sensibilidades ampliado.
- Mejoras de FOV alto (efectos, plano cercano del arma), filtro de voz, audio 5.1 y downmix como la consola, "PC" en lugar de "Xbox" en todos los idiomas, guardados compatibles entre idiomas, límite de refresco por defecto.

**De B (fork de soldieg):**
- **Idiomas y subtítulos** (`src/common/subtitles*`, `language_download.*`): 8 idiomas (inglés, francés, alemán, italiano, español, portugués de Brasil, indonesio, ruso); subtítulos en cinemáticas con tamaño, negrita, color, sombra y fondo, y vista previa.
- **Armas F10** (`src/game/weapons.*`): dar cualquier arma de la tabla del nivel, rellenar munición, **sin recarga** (casilla NO RELOAD: el cargador no se vacía) y **salud infinita** (casilla INFINITE HEALTH, solo en la sesión; no revive a un jugador muerto; el campo de salud se localizó leyendo la memoria del juego). *El README de B anuncia además munición infinita, armas plateadas, modo Dios y funciones de gameplay/HUD V2.0 (correr, recarga rápida, granadas cocinadas, botiquín automático, inclinación, mira extra, marcadores…): **ese código no está en el fuente de B** y no existe en esta build.*
- **Guardado propio** (`save_data.*`, `save_storage.*`): los datos del disco duro de Xbox van a un directorio de usuario estable, con importación segura de datos antiguos.
- **Pack de texturas HD** (`src/d3d/texture_pack.*`) y diálogos nativos de Windows.
- Pruebas unitarias y un workflow de tests.

## Qué se hizo en esta build

1. **Fusión de A en B** (rama de trabajo fusionada en `main`): 47 commits de upstream; 14 archivos con conflictos resueltos a mano, conservando ambos lados.
   - `options.h`, `menu.*`, `game_info.cpp`, `translations.cpp`: se unieron las opciones de ambos (idiomas y subtítulos de B con gyro, sensibilidades y zona muerta de A).
   - **Ratón/mando** (`mouse.cpp`): se tomó la versión de A (incluye gyro y sensibilidades de apuntado); se retiró el hook propio `MouseSway` de B, que A ya cubre.
   - **Plano cercano del arma con FOV alto**: se usó el enfoque de A (`NearDepth`); el parámetro `close_near` de B se mantiene como valor por defecto.
   - **Idioma por defecto**: `int` (inglés) como en B, porque el selector de B no tiene la fila "Automático" de A.
   - `d3d12.cpp`: conviven el pack HD de B y el replacer/dumper de A (ver abajo).
2. **Menú de opciones del juego**: A y B habían rediseñado `options_menu.cpp` de formas incompatibles. Se tomó el de A y se **volvió a montar encima** lo de B: botón **LANGUAGE** sobre las opciones del menú principal, página de idiomas, página de ajustes de subtítulos con vista previa en vivo y fila de vista previa fija con scroll. *El menú de pausa conserva el diseño de A y no tiene botón de idioma.*
3. **Arreglo de texturas**: el pack HD de B se activaba con solo existir la carpeta `textures\` e ignoraba el ajuste **Texture Replacement**. Ahora respeta el ajuste (por defecto está **desactivado**).
4. **SDK fijado** al commit `91146ff` (antes `main` móvil, que dejó de compilar).
5. **Empaquetado**: `release.bat` genera `BLACK-PC.zip`. El pack de texturas HD de B **no se incluye** (≈1.2 GB, aporta poco) y los runtimes DLSS/FSR de `Upscale\` (84 MB, sin código que los cargue) se retiraron; el código que carga el pack se conserva.
6. **GitHub Actions**: `tests.yml` y `release.yml`, los dos en runners de GitHub. El release compila sin el juego gracias a `prebuilt/` (mapa de funciones del xbe, sin código); ver [RELEASING.md](RELEASING.md).
7. **Herramienta nueva**: `tools/refresh_prebuilt.py`, que regenera `prebuilt/` desde el ISO del jugador (USA o Europa; incluye la conversión Europa → USA). El ejecutable también acepta el ISO junto a él y `--setup`.
8. **Documentación**: esta carpeta `docs/` y un README nuevo.
9. Las pruebas de guardado se integraron en `tests/CMakeLists.txt` (CTest).
10. **Instalador** (`installer/BLACK.iss`, Inno Setup): `BLACK.exe --setup "<iso>"` extrae el disco junto al ejecutable, construye el código del juego, descarga el paquete del idioma elegido y borra `compiler\`; el idioma del instalador es el del juego. Ver [INSTALLER.md](INSTALLER.md).
11. **`translations\`**: los paquetes de idioma descargados van aparte de la carpeta `language\` del propio juego.
12. **Licencias**: se incluyen la MIT del SDK y los avisos de terceros; el proyecto no añade licencia propia (ninguno de los dos repos base publica una).
13. Comparación con los dos repositorios base: [COMPARISON.md](COMPARISON.md).

Se compiló y arrancó en Windows 11 con una GPU Intel Arc, ISO Europa convertida. Se comprobó: arranque, cambio de idioma, F10 y texturas HD (con el pack externo, ya no incluido). **No** se validó: gyro con mando real, DLSS/FSR (no hay código que las cargue), ni una partida completa.

## Límites conocidos

- Sin recoloreado de sangre, mod loader, SSR ni sombras dinámicas.
- Las funciones de gameplay y HUD V2.0 que anuncia el README de B no están en su código fuente (ver arriba).
- Sin upscaling por IA (DLSS/FSR): el fork distribuía los runtimes, pero ningún código los cargaba, así que se retiraron.
- El elegir qué arma reemplazar al recoger otra del suelo **no está implementado** (F10 > Weapons siempre reemplaza el slot que no tienes en mano).
- Los paquetes de idioma se descargan en ejecución de `github.com/soldieg/BLACK-SUBTITLES`; sin conexión solo funcionan los ya descargados.

---

<a name="english"></a>

# English

## The two base projects

| | **A. TGP482/BLACK-XBERecomp** ("upstream") | **B. soldieg/BLACK-XBERecomp** ("Build V2.0" fork) |
|---|---|---|
| Used | `main` @ `10b8464` (2026-10-29) | `main` @ `8721350` (2026-10-22) |
| Common ancestor | `39ad697` (2026-10-15) | same |
| Commits since it | 47 | 48 |

Both are the game-specific layer over the **TGP482/XboxXBE-Recomp** SDK (x86→C++ recompiler + runtime). They diverged from the same point; the fork had only merged upstream up to 2026-10-18.

## What each base brings (all kept)

**From A:** gyro aiming (DualSense, DualShock 4, Switch Pro; axis, button, recenter, calibration) · the built-in code compiler (the release ships `clang` + `lld-link` and compiles the game code to `Black.dll` on first start) · texture dumper/replacer (`textures\dumps`, `textures\replacement`) · Colour Blind, separate vertical / aiming / pad sensitivities, axis inversion, dead zone · high-FOV fixes, voice filter, console-like 5.1/mono audio, "PC" wording in every language, saves compatible across languages, default refresh-rate cap.

**From B:** languages and subtitles (8 languages; cutscene subtitles with size, bold, colour, shadow, background and a preview; packages downloaded at run time) · F10 weapons (any weapon of the level's table, ammo refill; **no reload** and **infinite health** were added in this repo, a session-only checkbox found by probing the running game; B's README also advertises infinite ammo, silver weapons, God Mode and V2.0 gameplay/HUD features, but **that code is not in B's source** and is not in this build) · own save handling (stable per-user HDD directory with safe import) · HD texture pack and native dialogs · unit tests.

## What this build did

1. **Merged A into B**: 47 upstream commits; 14 conflicting files resolved by hand, keeping both sides (options, menus, game info, translations from both; mouse/pad code from A, dropping B's own `MouseSway` hook that A covers; A's `NearDepth` for the viewmodel at high FOV; default language `int` as in B).
2. **In-game options menu**: A and B had redesigned `options_menu.cpp` incompatibly. A's was taken and B's work **re-ported on top**: the **LANGUAGE** button above the main menu's options, the language page, the subtitle settings page with live preview. *The pause menu keeps A's layout and has no language button.*
3. **Texture fix**: B's HD pack turned on whenever the `textures\` folder existed and ignored **Texture Replacement**. It now follows the setting (**off** by default).
4. **SDK pinned** to commit `91146ff` (a moving `main` stopped compiling).
5. **Packaging**: `release.bat` writes `BLACK-PC.zip`. B's HD texture pack is **not shipped** (≈1.2 GB, little value) and the DLSS/FSR runtimes of `Upscale\` (84 MB, nothing loaded them) were removed; the code that loads the pack is kept.
6. **GitHub Actions**: `tests.yml` and `release.yml`, both on GitHub's hosted runners. The release builds without the game thanks to `prebuilt/` (the xbe's function map, no code); see [RELEASING.md](RELEASING.md).
7. New `tools/refresh_prebuilt.py` regenerates `prebuilt/` from the player's disc (USA or Europe, with the Europe → USA conversion); save tests wired into CTest; this `docs/` folder and a new README. The executable also accepts the disc beside it, and `--setup`.
8. **Installer** (`installer/BLACK.iss`, Inno Setup): `BLACK.exe --setup "<iso>"` extracts the disc beside the executable, builds the game's code, downloads the chosen language's package and removes `compiler\`; the installer's language is the game's ([INSTALLER.md](INSTALLER.md)).
9. **`translations\`**: downloaded language packages live apart from the game's own `language\` folder.
10. **Licences**: the SDK's MIT and third-party notices ship; the project adds no licence of its own (neither base repository publishes one).
11. Comparison with the two base repositories: [COMPARISON.md](COMPARISON.md).

Built and started on Windows 11 with an Intel Arc GPU from a converted Europe disc. Checked: start-up, language change, F10 and HD textures (with the external pack, no longer shipped). **Not** validated: gyro on a real pad, DLSS/FSR (no code loads them), a full playthrough.

## Known limits

No blood recolouring, mod loader, SSR or dynamic shadows · the V2.0 gameplay/HUD features of B's README are not in its source · no AI upscaling (DLSS/FSR): the fork shipped the runtimes but nothing loaded them, so they were removed · choosing which weapon a pickup replaces is **not implemented** (F10 > Weapons always replaces the slot not in hand) · language packages are fetched at run time from `github.com/soldieg/BLACK-SUBTITLES`; offline only already-downloaded ones work.
