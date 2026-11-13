# prebuilt/

**Qué es.** Un mapa de las funciones del `default.xbe` de BLACK (nombres y direcciones), sin ninguna instrucción ni dato del juego: `image_symbols.h`, `hook_exports.h`, `x86_recomp_shared.h`, `imports.def` y el SHA-1 del xbe USA.

**Para qué sirve.** El ejecutable (`BLACK.exe`) necesita ese mapa para enlazar con el código del juego que genera cada jugador en su primer arranque. Gracias a que está aquí, el ejecutable se compila **sin el juego**: es lo que permite que GitHub Actions publique el release y que cualquiera compile con `build.bat`.

**Cuándo se regenera.** Solo si cambian `config/game.toml` o los hooks `X86_FUNC` de `src/`. Con tu copia del juego:

```
python tools/refresh_prebuilt.py "C:\ruta\juego.iso"
```

---

**What it is.** A map of the functions in BLACK's `default.xbe` (names and addresses), with no instructions or game data: `image_symbols.h`, `hook_exports.h`, `x86_recomp_shared.h`, `imports.def` and the USA xbe's SHA-1.

**What it is for.** `BLACK.exe` needs this map to link against the game code each player generates on the first start. Because it is here, the executable builds **without the game**, which is what lets GitHub Actions publish the release and anyone build with `build.bat`.

**When to regenerate it.** Only when `config/game.toml` or the `X86_FUNC` hooks in `src/` change: `python tools/refresh_prebuilt.py "C:\path\game.iso"` with your copy of the game.
