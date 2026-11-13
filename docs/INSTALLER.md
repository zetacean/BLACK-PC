# Instalador / Installer

**Español** · [English](#english)

## Para el usuario

1. Descarga `BLACK-PC-Setup.exe` de *Releases* y ejecútalo (no pide permisos de administrador). Al principio elige **el idioma del instalador: ese será también el idioma del juego** (inglés, español, francés, alemán, italiano, portugués de Brasil o ruso). El indonesio no tiene traducción de instalador: se elige después en el juego (F10 > Language).
2. Elige la carpeta de instalación (por defecto `%LocalAppData%\Programs\BLACK PC`).
3. Elige **la imagen de disco (.iso) de tu copia de BLACK** para Xbox, edición USA o Europa. El juego no se incluye.
4. Espera. El instalador extrae los archivos del juego, y una ventana muestra la construcción del código del juego (unos minutos). Al terminar borra las herramientas que ya no necesita.
5. Marca *Iniciar BLACK ahora* o abre el acceso directo.

Del `.iso` solo se lee: no se copia y puedes moverlo o borrarlo después, porque el juego queda extraído en la propia carpeta de instalación, junto a `BLACK.exe`. Desinstalar borra todo lo que el juego crea junto al ejecutable. Los guardados van a una carpeta bajo `%LocalAppData%`, fuera de la instalación, y la desinstalación no los toca.

> El instalador no está firmado digitalmente: Windows SmartScreen o el antivirus pueden avisar. Es lo habitual en proyectos sin certificado.

## Cómo funciona

El instalador (`installer/BLACK.iss`, Inno Setup 6) copia el mismo contenido que el zip y luego ejecuta:

```
BLACK.exe --setup "<ruta del .iso>"
```

`--setup` hace tres cosas y termina sin abrir el juego:

1. **Extrae** el disco junto al ejecutable (`ExtractDisc`, `src/common/game_files.cpp`). Si es la edición Europa, convierte su `default.xbe` al USA con el mismo parche que usa el ejecutable al arrancar, y comprueba el SHA-1 de la build. Un disco de otra versión se rechaza con un mensaje.
2. **Construye** `Black.dll` a partir de ese xbe, con la ventana de progreso de siempre (`src/app/game_code.cpp`).
3. **Descarga el paquete de idioma** elegido (si hay conexión) y espera a que termine, para que el primer arranque ya esté en ese idioma, y **borra la carpeta `compiler\`** (≈300 MB), que solo hacía falta para construir.

Antes de ejecutarlo, el instalador escribe `language = '<código>'` en `black.toml` (`esp`, `fra`, `deu`, `ita`, `pt-BR`, `ru` o `int`). Si ya existe un `black.toml` (reinstalación), no lo toca. Para instalaciones silenciosas: `BLACK-PC-Setup.exe /VERYSILENT /LANG=fr /ISO="C:
uta\juego.iso"`.

Sin el instalador, el zip sigue funcionando como antes: descomprimir, poner el `.iso` (o los archivos del juego) junto a `BLACK.exe` y abrirlo.

## Crear el instalador

`release.bat` lo genera junto al zip si encuentra Inno Setup (`ISCC` en el PATH o instalado por usuario o en Program Files): `winget install JRSoftware.InnoSetup`. Resultado: `BLACK-PC-Setup.exe`. El workflow de release lo instala y lo publica; ver [RELEASING.md](RELEASING.md).

---

<a name="english"></a>

# English

## For the player

1. Download `BLACK-PC-Setup.exe` from *Releases* and run it (no administrator rights). First pick **the installer's language: it is also the game's language** (English, Spanish, French, German, Italian, Brazilian Portuguese or Russian). Indonesian has no installer translation: choose it in the game (F10 > Language).
2. Pick the install folder (default `%LocalAppData%\Programs\BLACK PC`).
3. Pick **the disc image (.iso) of your own copy of BLACK** for the Xbox, USA or Europe release. The game is not included.
4. Wait. The installer extracts the game's files, and a window shows the game's code being built (a few minutes). It then removes the tools it no longer needs.
5. Tick *Start BLACK now* or use the shortcut.

The `.iso` is only read: it is not copied and you can move or delete it afterwards, since the game is extracted into the install folder itself, beside `BLACK.exe`. Uninstalling removes everything the game makes beside the executable; saves live under `%LocalAppData%`, outside the install, and are left alone. The installer is not code-signed, so SmartScreen or an antivirus may warn.

## How it works

`installer/BLACK.iss` (Inno Setup 6) installs the zip's contents and then runs `BLACK.exe --setup "<iso>"`, which extracts the disc beside the executable (the Europe `default.xbe` converted to the USA one and checked against the build's SHA-1; another release is refused), builds `Black.dll` with the usual progress window, downloads the chosen language's package and waits for it, deletes the `compiler\` folder (≈300 MB) and exits without starting the game. Before that the installer writes `language = '<code>'` to `black.toml` (untouched if one exists). Silent install: `BLACK-PC-Setup.exe /VERYSILENT /LANG=fr /ISO="C:\path\game.iso"`. The zip still works as before.

## Building it

`release.bat` makes it next to the zip when Inno Setup is installed (`winget install JRSoftware.InnoSetup`). Output: `BLACK-PC-Setup.exe`. The release workflow installs Inno Setup and publishes it ([RELEASING.md](RELEASING.md)).

**Where the game is found:** `BLACK.exe` uses its own folder: the extracted game when `default.xbe` is there (the installer's layout), or an `.iso` beside it. In the install folder the game's own `language\` folder (`fonts`, `strings`) is separate from the downloaded packages, which live in `translations\` (`es`, `fr`…, `manifest.json`).
