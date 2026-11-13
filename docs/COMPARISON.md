# Comparación con los dos repositorios base / Comparison with the two base repositories

**Español** · [English](#english)

| | **A. TGP482/BLACK-XBERecomp** (*upstream*) | **B. soldieg/BLACK-XBERecomp** (*fork*) | **C. Este repositorio** |
|---|---|---|---|
| Punto usado | `main` @ `10b8464` (2026-10-29) | `main` @ `8721350` (2026-10-22) | fusión de A en B + trabajo propio |
| Desde el ancestro común `39ad697` | 47 commits, 38 archivos (+2478 / −341) | 48 commits, 51 archivos (+5181 / −370) | respecto a A: 42 archivos; respecto a B: 31 archivos |
| SDK | `XboxXBE-Recomp` en `main` (móvil) | igual | fijado al commit `91146ff` |

Leyenda: ✔ está en el código fuente · ✘ no está · ◐ solo lo anuncia el README, **no está en el código**. Cada ✔/✘ se comprobó buscando en el código de cada rama.

## Funciones del juego

| Función | A | B | C |
|---|:-:|:-:|:-:|
| Base del port: renderer D3D12, ratón y teclado, mando, ventana/pantalla completa, FOV, límite de FPS, HDR, MSAA, SMAA, oclusión ambiental, distancia de dibujo, escala de FMV | ✔ | ✔ | ✔ |
| Audio 5.1, downmix y cola de salida como la consola | ✔ | ✔ | ✔ |
| Apuntado con giroscopio (DualSense, DualShock 4, Switch Pro) | ✔ | ✘ | ✔ (sin validar con mando real) |
| Modo para daltónicos | ✔ | ✘ | ✔ |
| Sensibilidades por separado (vertical, apuntando, mando), zona muerta | ✔ | ✘ | ✔ |
| Filtro de voz | ✔ | ✘ | ✔ |
| Volcado y reemplazo de texturas (PNG/DDS) | ✔ | ✘ | ✔ |
| Cargador del pack de texturas HD (`textures\<hash>.dds`) | ✘ | ✔ | ✔ (el pack **no** se distribuye) |
| Menú de idiomas (8) con paquetes descargados en ejecución | ✘ | ✔ | ✔ |
| Subtítulos de cinemáticas con tamaño, color, sombra, fondo y vista previa | ✘ | ✔ | ✔ |
| Guardado propio (carpeta de usuario estable, importación segura) | ✘ | ✔ | ✔ |
| F10 > Weapons: dar cualquier arma del nivel y rellenar munición | ✘ | ✔ | ✔ |
| Munición infinita, armas plateadas, modo Dios, reposición de vida | ✘ | ◐ | ✘ |
| Correr ajustable, recarga rápida, granadas cocinadas, botiquín automático, inclinación táctica, multiplicador de daño | ✘ | ◐ | ✘ |
| HUD V2.0 (mira extra, % de vida, marcadores de impacto, aviso de granada, marcadores de enemigos) | ✘ | ◐ | ✘ |
| DLSS / FSR | ✘ | ◐ (solo las DLL, sin código que las cargue) | ✘ (las DLL se retiraron) |
| Elegir qué arma reemplaza una nueva | ✘ | ✘ | ✘ (se intentó en F10 y se descartó) |

> **Importante:** el README de B anuncia las funciones marcadas ◐ y distribuyó un ejecutable "Build V2.0". En ninguna rama del repositorio de B hay código fuente de esas funciones (se buscaron `sprint`, `cook`, `god`, `infinite`, `crosshair`, `dlss` en todas las ramas). Este repositorio **no las tiene** y no las promete.

## Compilación, empaquetado y distribución

| Aspecto | A | B | C |
|---|---|---|---|
| Compilador integrado: el release no lleva código del juego; el primer arranque lo compila del xbe del jugador | ✔ | ✘ | ✔ |
| ISO de Europa o USA (el ejecutable la lee) | ✔ | ✔ | ✔ |
| Herramienta que regenera `prebuilt/` desde el ISO (USA o Europa) | ✘ | ✘ (su README cita un script que no está en el repo) | ✔ |
| Instalador (Inno Setup, 7 idiomas): pide el ISO, extrae el juego junto al ejecutable, construye y borra el compilador; **el idioma del instalador es el del juego** | ✘ | ✘ | ✔ |
| Paquetes de idioma en `translations\`, separados de la carpeta `language\` del juego | — | — | ✔ |
| `release.bat` (zip) | ✔ | ✔ | ✔ (zip + instalador) |
| GitHub Actions: pruebas | ✘ | ✔ (solo subtítulos) | ✔ (subtítulos y guardado) |
| GitHub Actions: release que compila y publica | ✘ | ✘ | ✔ (sin el juego, gracias a `prebuilt/`) |
| Pruebas unitarias (subtítulos, almacenamiento de guardados) | ✘ | ✔ | ✔ |
| Licencia propia | ✘ | ✘ | ✘ (incluye la MIT del SDK y los avisos de terceros) |
| Documentación | README (EN) | README (PT/EN) | README y `docs/` (ES/EN) |

## Qué hace diferente a este repositorio

1. **Integra lo mejor de los dos**: A aporta el gyro, el compilador integrado, el replacer de texturas, daltonismo y sensibilidades; B aporta idiomas, subtítulos, guardado propio, armas F10 y el cargador de texturas HD. Hubo 14 archivos con conflictos resueltos a mano; el menú de opciones se rehízo sobre el de A. Detalle en [CHANGES.md](CHANGES.md).
2. **Es instalable por un usuario común**: un solo `Setup.exe`, sin ISO que mantener y con el idioma elegido. Ver [INSTALLER.md](INSTALLER.md).
3. **Se publica sin el juego**: el release se compila en GitHub gracias a `prebuilt/` (mapa de direcciones de funciones, sin código ni datos del juego). Ver [RELEASING.md](RELEASING.md).
4. **Dice lo que no hace**: no añade funciones de juego nuevas. Su aporte es integración, empaquetado, instalación y documentación veraz.

## Límites

No se validó: gyro con mando real, una partida completa, el workflow de release en GitHub ni el test con MSVC. Las traducciones del instalador (fr, de, it, pt-BR, ru) las hizo un asistente y conviene que las revise un hablante nativo.

---

<a name="english"></a>

# English

| | **A. TGP482/BLACK-XBERecomp** (*upstream*) | **B. soldieg/BLACK-XBERecomp** (*fork*) | **C. This repository** |
|---|---|---|---|
| Used | `main` @ `10b8464` (2026-10-29) | `main` @ `8721350` (2026-10-22) | A merged into B + own work |
| Since common ancestor `39ad697` | 47 commits, 38 files (+2478 / −341) | 48 commits, 51 files (+5181 / −370) | vs A: 42 files; vs B: 31 files |
| SDK | `XboxXBE-Recomp` `main` (moving) | same | pinned to commit `91146ff` |

Key: ✔ in the source · ✘ not there · ◐ only advertised in the README, **not in the code**. Every ✔/✘ was checked by searching each branch's code.

## Game features

| Feature | A | B | C |
|---|:-:|:-:|:-:|
| Port base: D3D12 renderer, mouse and keyboard, controller, display modes, FOV, FPS cap, HDR, MSAA, SMAA, ambient occlusion, draw distance, FMV scale | ✔ | ✔ | ✔ |
| 5.1 audio, console-like downmix and output queue | ✔ | ✔ | ✔ |
| Gyro aiming (DualSense, DualShock 4, Switch Pro) | ✔ | ✘ | ✔ (not validated on a real pad) |
| Colour-blind mode | ✔ | ✘ | ✔ |
| Separate sensitivities (vertical, aiming, pad), dead zone | ✔ | ✘ | ✔ |
| Voice filter | ✔ | ✘ | ✔ |
| Texture dump and replace (PNG/DDS) | ✔ | ✘ | ✔ |
| HD texture pack loader (`textures\<hash>.dds`) | ✘ | ✔ | ✔ (the pack is **not** shipped) |
| Language menu (8) with packages downloaded at run time | ✘ | ✔ | ✔ |
| Cutscene subtitles with size, colour, shadow, background and preview | ✘ | ✔ | ✔ |
| Own save handling (stable user folder, safe import) | ✘ | ✔ | ✔ |
| F10 > Weapons: give any weapon of the level, refill ammo | ✘ | ✔ | ✔ |
| Infinite ammo, silver weapons, God Mode, health refill | ✘ | ◐ | ✘ |
| Adjustable sprint, faster reload, grenade cooking, auto medkit, tactical lean, damage multiplier | ✘ | ◐ | ✘ |
| V2.0 HUD (extra crosshair, health %, hit markers, grenade warning, enemy markers) | ✘ | ◐ | ✘ |
| DLSS / FSR | ✘ | ◐ (DLLs only, no code loads them) | ✘ (DLLs removed) |
| Choosing which weapon a new one replaces | ✘ | ✘ | ✘ (tried in F10, dropped) |

> **Important:** B's README advertises the ◐ features and B shipped a "Build V2.0" binary. No branch of B's repository has source for them (`sprint`, `cook`, `god`, `infinite`, `crosshair`, `dlss` were searched in every branch). This repository **does not have them** and does not promise them.

## Build, packaging and distribution

| Aspect | A | B | C |
|---|---|---|---|
| Built-in compiler: the release carries no game code; the first start builds it from the player's xbe | ✔ | ✘ | ✔ |
| USA or Europe ISO (the executable reads it) | ✔ | ✔ | ✔ |
| Tool that regenerates `prebuilt/` from the disc (USA or Europe) | ✘ | ✘ (its README cites a script that is not in the repo) | ✔ |
| Installer (Inno Setup, 7 languages): asks for the ISO, extracts the game beside the executable, builds and removes the compiler; **the installer's language is the game's** | ✘ | ✘ | ✔ |
| Language packages in `translations\`, apart from the game's own `language\` | — | — | ✔ |
| `release.bat` (zip) | ✔ | ✔ | ✔ (zip + installer) |
| GitHub Actions: tests | ✘ | ✔ (subtitles only) | ✔ (subtitles and saves) |
| GitHub Actions: build and publish a release | ✘ | ✘ | ✔ (without the game, via `prebuilt/`) |
| Unit tests (subtitles, save storage) | ✘ | ✔ | ✔ |
| Own licence | ✘ | ✘ | ✘ (ships the SDK's MIT and third-party notices) |
| Documentation | README (EN) | README (PT/EN) | README and `docs/` (ES/EN) |

## What makes this repository different

1. **It merges both**: A brings gyro, the built-in compiler, the texture replacer, colour-blind mode and sensitivities; B brings languages, subtitles, own save handling, F10 weapons and the HD texture loader. 14 conflicting files were resolved by hand and the options menu was rebuilt on A's ([CHANGES.md](CHANGES.md)).
2. **A regular user can install it**: one `Setup.exe`, no ISO to keep, in the chosen language ([INSTALLER.md](INSTALLER.md)).
3. **It is published without the game**: the release builds on GitHub through `prebuilt/` (a function-address map, no game code or data) ([RELEASING.md](RELEASING.md)).
4. **It says what it does not do**: no new gameplay features. Its contribution is integration, packaging, installation and truthful documentation.

## Limits

Not validated: gyro on a real pad, a full playthrough, the release workflow on GitHub, the MSVC test build. The installer's fr, de, it, pt-BR and ru texts were written by an assistant and should be checked by a native speaker.
