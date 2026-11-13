@echo off
rem Builds the release packages from out\build\release (running build.bat first when there is no BLACK.exe):
rem   BLACK-PC.zip           BLACK.exe, the compiler folder, and the runtimes it needs
cd /d "%~dp0"
set "OUT=out\build\release"
set "STAGE=%OUT%\package"
set "D3DCOMPILER=%ProgramFiles(x86)%\Windows Kits\10\Redist\D3D\x64\d3dcompiler_47.dll"
if not exist "%D3DCOMPILER%" (echo d3dcompiler_47.dll not found: install the Windows SDK from the Visual Studio Installer & exit /b 1)
rem the Visual C++ runtime beside the executable, so a fresh Windows install needs nothing more
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -property installationPath`) do set "VSDIR=%%i"
for /d %%v in ("%VSDIR%\VC\Redist\MSVC\1*") do for /d %%c in ("%%v\x64\Microsoft.VC*.CRT") do set "VCRUNTIME=%%c"
if not exist "%VCRUNTIME%\vcruntime140.dll" (echo Visual C++ runtime not found: install Visual Studio with the C++ workload & exit /b 1)
where 7z >nul 2>nul || (echo 7z not found: install 7-Zip and put it on the PATH & exit /b 1)
if not exist "%OUT%\BLACK.exe" call build.bat || exit /b 1

rem One name for every release, so releases/latest/download/BLACK-PC.zip stays a working link
set "ZIP=BLACK-PC.zip"
del /q "%ZIP%" 2>nul

rem only the runtime DLLs the executable imports; xbe_recomp.exe needs its own copy, Windows only looks beside the
rem exe it starts
del /q "%OUT%\compiler\*.dll" 2>nul
for %%f in (msvcp140 vcruntime140) do copy /y "%VCRUNTIME%\%%f.dll" "%OUT%\compiler\" >nul

rem the package is staged so the zip holds BLACK.exe and the folders at its top, not the path they build in
rd /s /q "%STAGE%" 2>nul
mkdir "%STAGE%" || exit /b 1
copy /y "%OUT%\BLACK.exe" "%STAGE%\" >nul || exit /b 1
copy /y "%D3DCOMPILER%" "%STAGE%\" >nul
for %%f in (msvcp140 vcruntime140 vcruntime140_1) do copy /y "%VCRUNTIME%\%%f.dll" "%STAGE%\" >nul
rem the compiler folder without its work folder: no game code goes in the zip, the first start builds it
robocopy "%OUT%\compiler" "%STAGE%\compiler" /E /XD work /NFL /NDL /NJH /NJS /NP >nul
if errorlevel 8 (echo copying the compiler folder failed & exit /b 1)
copy /y README.md "%STAGE%\" >nul
copy /y LICENSE* "%STAGE%\" >nul 2>nul
copy /y THIRD_PARTY.txt "%STAGE%\" >nul 2>nul

pushd "%STAGE%"
7z a -tzip -mx=5 "%~dp0%ZIP%" * || (popd & exit /b 1)
popd
rem the installer (Inno Setup) from the same staged files, when ISCC is installed: BLACK-PC-Setup.exe
set "INSTALLER="
where ISCC >nul 2>nul && set "INSTALLER=ISCC"
if not defined INSTALLER if exist "%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe" set "INSTALLER=%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
if not defined INSTALLER if exist "%LocalAppData%\Programs\Inno Setup 6\ISCC.exe" set "INSTALLER=%LocalAppData%\Programs\Inno Setup 6\ISCC.exe"
if not defined VERSION set "VERSION=dev"
del /q BLACK-PC-Setup.exe 2>nul
if defined INSTALLER "%INSTALLER%" /Q "/DStage=%CD%\%STAGE%" "/DVersion=%VERSION%" installer\BLACK.iss || exit /b 1
if not defined INSTALLER echo   Inno Setup not found: only the zip was made
rd /s /q "%STAGE%" 2>nul
echo.
echo   %ZIP% written (and BLACK-PC-Setup.exe when Inno Setup is installed)
exit /b 0
