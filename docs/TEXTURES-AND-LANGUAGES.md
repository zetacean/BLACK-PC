# Texturas, idiomas y subtítulos / Textures, languages and subtitles

**Español** · [English](#english)

## Texturas

Hay **dos sistemas de reemplazo**, los dos controlados por el mismo ajuste **Texture Replacement** (`custom_textures` en `black.toml`, **desactivado por defecto**). Está en F10 (o en el menú de opciones del juego) > RECOMP SETTINGS > Textures. También puede asignarse una tecla a *Toggle texture replacement* (sin asignar por defecto).

| | **Pack HD** (del fork de soldieg) | **Replacer/dumper** (de upstream, en el SDK) |
|---|---|---|
| Carpeta | `textures\<hash>.dds` | `textures\replacement\` (imágenes `.dds` o `.png`) |
| Origen | Un pack externo (**no incluido**; el del release `v2.0.0` de soldieg es compatible) | Las que crees tú a partir de `textures\dumps\` |
| Nombres | 16 dígitos hexadecimales: hash del tamaño, formato y píxeles (y paleta) de la textura original | Los que genera el volcado |
| Formatos | BC3 (DXT5) con mipmaps; BGRA8 de un solo nivel para bordes de fuentes | PNG o DDS (se elige el formato del volcado) |
| Si falta o es inválida | Se usa la original | Se usa la original |

- Este repositorio y sus releases **no incluyen el pack HD** (2020 archivos, ≈1.2 GB): pesaba demasiado. El código sigue ahí: si colocas un pack compatible en `textures\` junto al exe y activas el ajuste, se usa. `textures\` está en `.gitignore`.
- **Volcar texturas**: activa *Texture Dumping* y elige *Dump Format* (PNG o DDS); las texturas que use el juego se guardan en `textures\dumps\`. Edita una, guárdala en `textures\replacement\` y se aplica sin reiniciar.
- Las texturas ya cargadas **no se refrescan** al activar o desactivar el ajuste: entra de nuevo al nivel o reinicia.
- En el log (`logs\black.log`) las líneas `textures:` dicen si cada textura del pack se aplicó (`... -> 1024x1024`) o no (`no replacement`).

## Idiomas

Idiomas: inglés, francés, alemán, italiano, español, portugués de Brasil, indonesio y ruso (`language` = `int`, `fra`, `deu`, `ita`, `esp`, `pt-BR`, `id`, `ru`).

- **Dónde cambiarlo**: menú principal del juego > Opciones > **LANGUAGE** (botón sobre las opciones de siempre), o F10 > Language. *El menú de pausa no tiene botón de idioma.* Cambiar el idioma pide reiniciar (se muestra "RESTART").
- **Paquetes**: las traducciones, fuentes y subtítulos **no van en el exe**. Se descargan en segundo plano del repositorio [soldieg/BLACK-SUBTITLES](https://github.com/soldieg/BLACK-SUBTITLES) a `translations\<idioma>\` junto al exe. Cada archivo se comprueba con el `manifest.json` (tamaño y SHA-256) antes de instalarse. Hay una acción para actualizar las traducciones y una ventana con el estado de los archivos del paquete.
- **Primer arranque**: detecta el idioma de Windows; si es uno de los soportados, descarga su paquete y reinicia una vez para cargarlo. Si no es compatible, se queda en inglés y lo avisa una vez.
- **Sin conexión**: solo funcionan los paquetes ya descargados; sin ellos, el juego sigue en inglés.
- **Edición Europa**: sus idiomas del disco se usan para el audio/texto del juego; la capa de subtítulos de arriba es independiente.

## Subtítulos

Menú Opciones > LANGUAGE > *Subtitle settings* (o F10). Ajustes (`black.toml`):

| Ajuste | Valores |
|---|---|
| `subtitles_enabled` | sí / no |
| `subtitle_size` | 80–160 % (120 por defecto) |
| `subtitle_bold` | sí / no |
| `subtitle_color` | 0 blanco, 1 amarillo |
| `subtitle_shadow` | 0 sin sombra, 1 sutil, 2 fuerte |
| `subtitle_background` | caja oscura detrás, sí / no |

La página incluye una **vista previa** del texto con la fuente real del juego. El fork cubre además la compatibilidad de las fuentes para ã/Ã y õ/Õ. Los subtítulos son de **cinemáticas**; no hay subtítulos de diálogos en tiempo real.

---

<a name="english"></a>

# English

## Textures

Two replacement systems, both gated by **Texture Replacement** (`custom_textures` in `black.toml`, **off by default**), found in F10 (or the in-game options) > RECOMP SETTINGS > Textures; it can also be bound to a key (*Toggle texture replacement*, unbound by default).

| | **HD pack** (soldieg's fork) | **Replacer/dumper** (upstream, in the SDK) |
|---|---|---|
| Folder | `textures\<hash>.dds` | `textures\replacement\` (`.dds` or `.png`) |
| Source | an external pack (**not included**; soldieg's `v2.0.0` release one is compatible) | what you make from `textures\dumps\` |
| Names | 16 hex digits: hash of the original texture's size, format and pixels (and palette) | the dumper's names |
| Formats | BC3 (DXT5) with mip chains; single-level BGRA8 for font edges | PNG or DDS |
| Missing/invalid | original texture is used | original texture is used |

This repo and its releases **do not ship the HD pack** (2020 files, ≈1.2 GB): too large. The loader is still there: drop a compatible pack in `textures\` beside the exe and enable the setting (`textures\` is git-ignored). To dump: enable *Texture Dumping*, pick *Dump Format*, edit a file from `textures\dumps\`, save it to `textures\replacement\`. Textures already loaded are **not refreshed** when you flip the setting: re-enter the level or restart. `logs\black.log` lines starting `textures:` tell whether each pack texture applied.

## Languages

English, French, German, Italian, Spanish, Brazilian Portuguese, Indonesian, Russian (`language` = `int`, `fra`, `deu`, `ita`, `esp`, `pt-BR`, `id`, `ru`). Change it in the main menu > Options > **LANGUAGE**, or F10 > Language (the pause menu has no language button); a change asks for a restart. Translations, fonts and subtitles are **not in the exe**: they download in the background from [soldieg/BLACK-SUBTITLES](https://github.com/soldieg/BLACK-SUBTITLES) into `translations\<locale>\` beside the exe, each file checked against `manifest.json` (size and SHA-256). First start detects the Windows language and restarts once after downloading its package. Offline, only packages already downloaded work. A Europe disc's own languages are used for the game's text/audio; the subtitle layer is separate.

## Subtitles

Options > LANGUAGE > *Subtitle settings* (or F10): on/off, size 80–160 % (default 120), bold, colour (white/yellow), shadow (off/subtle/strong), background box, plus a **live preview**. They cover **cutscenes** only; there are no real-time gameplay dialogue subtitles.
