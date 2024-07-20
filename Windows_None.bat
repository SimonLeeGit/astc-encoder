@ECHO OFF

REM Copyright Epic Games, Inc. All Rights Reserved.

setlocal

set PATH_TO_CMAKE_FILE="%CD%"
echo PATH_TO_CMAKE_FILE=%PATH_TO_CMAKE_FILE%

REM Temporary build directories (used as working directories when running CMake)
set UE_BUILD_PATH="%CD%\Build_Win64"
echo UE_BUILD_PATH=%UE_BUILD_PATH%

REM MSBuild Directory
for /f "delims=" %%V in ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -property installationPath') do SET _vsinstall=%%V
if errorlevel 1 goto VStudioMissing
SET _msbuild=%_vsinstall%\MSBuild\Current\Bin\
if not exist "%_msbuild%msbuild.exe" goto MSBuildMissing

REM Build for 64-bit
echo Generating solution (64-bit)...
if exist "%UE_BUILD_PATH%" (rmdir "%UE_BUILD_PATH%" /s/q)
mkdir "%UE_BUILD_PATH%"
cd "%UE_BUILD_PATH%"
"%_vsinstall%\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" -G "Visual Studio 16 2019" -A x64 -DASTCENC_ISA_NONE=ON -DCLI=ON "%PATH_TO_CMAKE_FILE%"

echo Building astcenc solution for (64-bit, Release)...
"%_msbuild%msbuild.exe" Source/ALL_BUILD.vcxproj /t:build /p:Configuration=Release
echo Building astcenc solution for (64-bit, Debug)...
"%_msbuild%msbuild.exe" Source/ALL_BUILD.vcxproj /t:build /p:Configuration=Debug
cd "%PATH_TO_CMAKE_FILE%"
xcopy /y/s/i "%UE_BUILD_PATH%\Source\Release" bin\Win64\Release
xcopy /y/s/i "%UE_BUILD_PATH%\Source\Debug" bin\Win64\Debug
rmdir "%UE_BUILD_PATH%" /s/q
exit /b 0

:VStudioMissing
echo Visual Studio not found. Please check your Visual Studio install and try again.
goto Exit

:MSBuildMissing
echo MSBuild not found. Please check your Visual Studio install and try again.
goto Exit

:Exit
endlocal
exit /b 1