# BLACK PC — instrucciones para el asistente de IA

Port nativo a PC de **BLACK (Xbox, 2006)** por recompilación estática de `default.xbe`. Une dos proyectos (TGP482 y soldieg) y añade instalador, release automático y documentación. El usuario habla español: responde en español salvo que pida otra cosa. La documentación del repo es bilingüe (ES/EN).

## Reglas que no se negocian

- **El juego nunca entra al repo ni a los paquetes** (ni `default.xbe`, `GlobData.bin`, `.iso`, ni código del juego ya compilado). El workflow de release falla si aparecen.
- **No afirmes funciones que no están en el código.** El README del fork de soldieg anunciaba cosas que no existen; ya nos pasó. Antes de documentar una función, búscala en `src/`. Si cambias lo que el juego hace, actualiza `docs/COMPARISON.md` y `docs/CHANGES.md`.
- **Pide confirmación antes de lo que sale del equipo:** `git push`, crear/mover etiquetas, publicar un release, borrar un release. Nunca `--force` ni `git push --tags` (hay etiquetas heredadas de los repos base: `V1..V3`, `v2.0.0`, `Community-Build*`; se sube una etiqueta por su nombre).
- **`origin` puede apuntar a un repo ajeno** (soldieg) en un clon antiguo. Comprueba `git remote -v` antes de empujar; el destino es el repo del usuario.
- **Privacidad:** no escribas el correo ni datos personales del usuario en archivos, commits ni peticiones a servicios externos.
- No reintroduzcas lo que se quitó a propósito: carpeta `assets` en el repo, pack de texturas HD (1,2 GB), DLLs de DLSS/FSR, retrocompatibilidad con `assets\`.
- Los commits llevan el pie `Co-Authored-By` que indique el entorno.

## Estructura

| Ruta | Qué es |
|---|---|
| `src/game/` | Código que se engancha al juego: hooks `X86_FUNC(sub_XXXXXXXX)`, menú de opciones, armas F10, HUD, ratón, idioma |
| `src/common/` | Opciones, menú F10, subtítulos, descarga de idiomas, guardados, `game_files.cpp` (busca el juego y `--setup`), gyro |
| `src/app/game_code.cpp` | Primer arranque: construye `Black.dll` del xbe del jugador; modo `--setup` del instalador |
| `src/d3d/`, `src/sound/`, `src/audio/` | Backend D3D12, texturas, audio |
| `config/game.toml` | Símbolos y hooks del `default.xbe` |
| `prebuilt/` | Mapa de funciones del xbe (sin código del juego) para compilar sin el juego |
| `installer/BLACK.iss` | Instalador Inno Setup (7 idiomas; el del instalador es el del juego) |
| `tools/` | `refresh_prebuilt.py` (regenera `prebuilt/` desde el ISO), `europe_patch.py` (genera `src/common/europe.patch`), `build_info.cmake` |
| `tests/` | Pruebas unitarias (subtítulos y almacenamiento de guardados) |
| `docs/` | BUILDING, CHANGES, COMPARISON, INSTALLER, RELEASING, TEXTURES-AND-LANGUAGES, `release-notes/` |
| `.github/workflows/` | `tests.yml` y `release.yml` (runners de GitHub) |

El SDK vive **fuera** del repo, en `..\XboxXBE-Recomp`, fijado al commit `91146ff` (CMake lo descarga si falta). CMake **parchea archivos del SDK in situ**: que el SDK aparezca "modificado" es normal. Si cambias el texto de un parche en `CMakeLists.txt`, restaura el SDK primero (`git -C ..\XboxXBE-Recomp checkout -- runtime`) o el parche viejo se queda.

## Comandos habituales (Windows)

- Compilar: `.\build.bat` (solo el ejecutable, desde `prebuilt/`; no necesita el juego). Salida: `out\build\release\BLACK.exe`.
- Pruebas: `cmake -S tests -B out\tests -G Ninja -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release`, `cmake --build out\tests`, `ctest --test-dir out\tests --output-on-failure`.
- Paquetes: `.\release.bat` → `BLACK-PC.zip` y `BLACK-PC-Setup.exe` (necesita 7-Zip e Inno Setup 6).
- Probar con el juego: `out\build\release\BLACK.exe --setup "<iso>"` extrae el disco junto al exe, construye `Black.dll` y borra `compiler\`.
- Regenerar `prebuilt/`: `python tools/refresh_prebuilt.py "<iso>"`. **Solo** si cambias `config/game.toml` o añades/quitas hooks `X86_FUNC`; necesita el ISO del usuario. Si el enlace falla con símbolos sin resolver, `prebuilt/` está desactualizado.
- Instalación silenciosa de prueba: `BLACK-PC-Setup.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LANG=fr /DIR="<carpeta>" /ISO="<iso>"`.

Trampas de entorno ya vistas: en Git Bash pon `MSYS_NO_PATHCONV=1` para pasar `/LANG=...` a instaladores; lanza `.bat` con `cmd.exe //c ".\\archivo.bat"`; en scripts Python con rutas de Windows usa cadenas crudas o un archivo `.py` (los `\` en heredocs rompen); `clang` está en `C:\Program Files\LLVM\bin`. El primer ejecutable nuevo puede tardar minutos en abrir por el antivirus. Lo que compilas en local y lo que compila GitHub **no son iguales** (zona horaria de las fechas de los archivos, LLVM del runner): tras publicar, prueba el instalador descargado.

## Cómo enganchar y encontrar cosas en el juego

- No hay símbolos: hay que descubrirlos. Strings del XBE (`python` con `re` sobre `default.xbe`) y búsquedas en `generated\game\x86_recomp.*.cpp` (se crea al regenerar; está ignorado) dan direcciones. `layout.h` y `weapons.cpp` muestran el estilo de las constantes de offsets.
- Hooks: `X86_FUNC(sub_XXXXXXXX)` reemplaza una función; `R32/W32/G<T>` leen y escriben memoria del juego; `CallGuest` llama a una función del juego.
- **No puedes ver el juego.** Compilar y que arranque no prueba que un menú, una animación o una mecánica estén bien: pide al usuario que lo pruebe y di explícitamente qué no verificaste.

## Estado y límites conocidos

- Sin implementar: elegir qué arma reemplaza una nueva (se intentó en F10 por dos caminos y falló por la animación del arma en mano; la vía real es enganchar la recogida del suelo), munición infinita y modo Dios real (la salud infinita y la sin recarga sí están: salud `player+0x2F0`, float, 1200 al máximo; balas cargadas `cargador+0x18`, int; la munición ya tiene botón de rellenar), sprint (se midió: correr es 4,5 u/s y no hay campo de velocidad localizado; se descartó), silenciador, botón de idioma en el menú de pausa (otro clip Flash, sin poder ver el resultado), upscaling DLSS/FSR.
- Sin validar: gyro con mando real, una partida completa, el workflow de release en GitHub, el test con MSVC.
- Las traducciones del instalador (fr, de, it, pt-BR, ru) las hizo una IA: pendientes de revisión nativa.
- La licencia propia no existe: ninguno de los dos repos base publica una. Solo se incluye la MIT del SDK y los avisos de terceros.

## Sondear el juego sin compilar

Para encontrar campos del jugador no compiles: lee la memoria de `BLACK.exe` desde Python con `ReadProcessMemory`. La memoria del xbox está en `0x100000000 + dirección`; el mundo es `R32(0x2D45D4)` y el jugador `mundo + 0x30`. Toma una captura del objeto del jugador antes y después de un cambio (daño, correr) y compara. Así se halló la salud. Para probar un cambio de ejecutable sin recompilar `Black.dll`, actualiza `Black.stamp` (tamaño, FILETIME del exe, sha1).

## Releases

El procedimiento completo, para que lo ejecutes tú, está en `.claude/commands/release.md` (`/release`) y se resume en `docs/RELEASING.md`. Idea: notas en `docs/release-notes/<etiqueta>.md`, pruebas, push, **una** etiqueta `vX.Y.Z`, y el workflow `release.yml` compila y publica en GitHub. La CLI `gh` ya está instalada; el usuario debe haber hecho `gh auth login` una vez.
