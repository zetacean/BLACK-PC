---
description: Regenera prebuilt/ desde el ISO del usuario (solo tras cambiar config/game.toml o hooks X86_FUNC)
argument-hint: "<ruta al .iso o default.xbe>"
---

Úsalo **solo** si cambiaron `config/game.toml` o se añadieron/quitaron funciones `X86_FUNC` en `src/`. Si no, `prebuilt/` ya es correcto y no hace falta el ISO.

1. Necesitas la ruta al juego del usuario: `$ARGUMENTS`. Si falta, pídela. Nunca copies el ISO ni sus archivos al repo.
2. `python tools/refresh_prebuilt.py "$ARGUMENTS"` (hace la recompilación completa: varios minutos; usa `assets\` y `generated\` temporalmente y los borra al terminar).
3. `git diff --stat prebuilt`. Si no hay cambios, tu cambio no afectaba al mapa. Si los hay, revisa que sean los esperados y commitea `prebuilt/` aparte, con un mensaje que diga por qué.
4. Comprueba que no quedan `assets\` ni `generated\`.
