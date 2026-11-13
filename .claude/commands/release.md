---
description: Prepara y publica un release de BLACK PC (notas, pruebas, etiqueta, seguimiento del workflow)
argument-hint: "[versión, p. ej. v1.0.0]"
---

Publica un release de BLACK PC siguiendo estos pasos, en orden. Versión pedida: `$ARGUMENTS` (si está vacía, propón la siguiente según SemVer y confírmala con el usuario).

Antes de **cada** paso que sale del equipo (push, etiqueta, publicar, borrar) pide confirmación al usuario. Nunca `--force` ni `git push --tags`.

## 0. Condiciones previas

1. `gh auth status` debe estar autenticado. Si no, dile al usuario que ejecute `gh auth login` (es interactivo; tú no puedes) y para.
2. `git remote -v`: `origin` tiene que ser el repo **del usuario**, no `soldieg/` ni `TGP482/`. Si no, para y pregunta.
3. `git status --short` limpio y rama `main`. Si hay cambios sin commit, pregunta qué hacer.
4. Versión: `gh release list --limit 5`. Si no hay ninguno, la primera es `v1.0.0`. Ignora las etiquetas heredadas de los repos base (`V1..V3`, `v2.0.0`, `Community-Build*`). Formato `vMAJOR.MINOR.PATCH`; el workflow solo publica etiquetas `v*`.

## 1. Reunir los cambios

- Última versión publicada `PREV` (paso 0.4). Si existe: `git log PREV..HEAD --no-merges --format='%h %s'` y `git diff --stat PREV..HEAD`. Si es el primer release, resume lo que hay en `docs/CHANGES.md`.
- Clasifica en: Novedades, Correcciones, Cambios internos, Limitaciones conocidas. Describe lo que **el jugador nota**; no copies mensajes de commit sin más. No afirmes nada que no esté en el código (revisa `src/`).

## 2. Escribir las notas

Crea `docs/release-notes/<etiqueta>.md` (plantilla en `docs/release-notes/README.md`): primero en español, luego en inglés. Incluye siempre: cómo instalar (`BLACK-PC-Setup.exe`, ISO USA o Europa), qué no está incluido (el juego), limitaciones conocidas y lo que no se validó. El workflow publica ese archivo como cuerpo del release.

Si cambió algo que el jugador ve, actualiza también `docs/CHANGES.md` y `docs/COMPARISON.md`.

## 3. Verificar antes de etiquetar

1. Pruebas: `cmake -S tests -B out\tests -G Ninja -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release` + `cmake --build out\tests` + `ctest --test-dir out\tests --output-on-failure`. Todas deben pasar.
2. Si tocaste `config/game.toml` o hooks `X86_FUNC`: `python tools/refresh_prebuilt.py "<iso del usuario>"` y commitea `prebuilt/`.
3. `.\build.bat` y `.\release.bat` (con `VERSION=<sin la v>`). Comprueba que `BLACK-PC.zip` no contiene `default.xbe`, `GlobData.bin` ni `.iso` (`7z l BLACK-PC.zip`).
4. Prueba de instalación silenciosa en una carpeta temporal (ver `CLAUDE.md`). Pide al usuario que pruebe el instalador a mano si hubo cambios de instalador, idioma o menús: tú no ves el juego.
5. Borra `BLACK-PC.zip`, `BLACK-PC-Setup.exe` y `out\` de pruebas.

## 4. Publicar

1. Commit de las notas: `git add docs && git commit -m "Release notes <etiqueta>"` (con el pie `Co-Authored-By` del entorno).
2. **Confirmar**, luego `git push origin main`.
3. Ensayo opcional sin publicar: `gh workflow run release.yml` (sin marcar publish) y `gh run watch`; el zip y el instalador quedan como artefacto 14 días.
4. **Confirmar**, luego `git tag -a <etiqueta> -m "BLACK PC <etiqueta>"` y `git push origin <etiqueta>` (solo esa etiqueta).

## 5. Seguir el workflow

- `gh run list --workflow release.yml --limit 3` y `gh run watch <id>`.
- Si falla: `gh run view <id> --log-failed`, corrige, y repite. Si hace falta rehacer la etiqueta, eso es destructivo (`git push origin :refs/tags/<etiqueta>` y `gh release delete <etiqueta>`): pide confirmación explícita.
- Al terminar: `gh release view <etiqueta> --json assets,url`. Deben estar `BLACK-PC-Setup.exe` y `BLACK-PC.zip`.
- **Prueba lo publicado, no lo local:** descarga `BLACK-PC-Setup.exe` del release (`gh release download <etiqueta> -p BLACK-PC-Setup.exe`), instálalo en silencio en una carpeta temporal con el ISO del usuario y arranca `BLACK.exe` ~20 s: no debe salir ningún diálogo ni "Game code: building" en `logs\black.log`. El ejecutable de CI lleva fechas de otra zona horaria; en v1.0.0 eso rompió el arranque y solo se vio al probar el instalador descargado.

## 6. Informar al usuario

Enlace del release, qué se publicó, qué se probó y qué **no** (gyro, partida completa, instalador a mano, workflow si es el primero). Si el workflow nunca se había ejecutado en GitHub, dilo.
