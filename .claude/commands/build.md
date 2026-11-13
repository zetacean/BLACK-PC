---
description: Compila BLACK.exe y ejecuta las pruebas unitarias
---

1. Compila: `cmd.exe //c ".\\build.bat"` desde la raíz del repo (lleva unos minutos; la primera vez más). Si no hay terminal interactiva, `build.bat` termina preguntando "Play now?": es normal, ignóralo o define `CI=1`.
2. Pruebas: `cmake -S tests -B out\tests -G Ninja -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release`, `cmake --build out\tests`, `ctest --test-dir out\tests --output-on-failure`. Para ejecutarlas desde Git Bash hace falta el entorno de Visual Studio y `C:\Program Files\LLVM\bin` en el PATH (mira cómo lo hace `build.bat`).
3. Informa del resultado con las líneas de error reales, no con un resumen. Si algo falla con "símbolos sin resolver", puede ser que `prebuilt/` esté desactualizado (`/refresh-prebuilt`).
4. Recuerda decir que compilar y arrancar no prueba menús ni jugabilidad: eso lo valida el usuario.
