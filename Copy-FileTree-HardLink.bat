:: Usage:
::    ThisProgram FOLDER
:: It copy the FOLDER's directory structure to a new folder, and create a
:: hardlink for each file in the corresponding position.

:: Originally, I wrote this script for calling it with Listary's "Favorite
:: Menus", that's why there are variables named LiXXX and positional parameters
:: other than %1 which are currently commented out.

@echo off
setlocal EnableDelayedExpansion
set "LiDir=%~1"
REM set "LiPath=%~2"
REM set "LiDirname=%~3"
set "Destination=%~1.[%~n0]"
dir /ad %1 1>nul 2>&1 || echo 错误：这不是文件夹。 && goto end
mkdir "%Destination%" || choice /M "仍要继续吗"
if errorlevel 2 goto end

:: 拷贝目录树到新的位置
echo 正在拷贝目录树，请耐心等待。

:: 方法1
for /f "delims=" %%D in ('dir /s /b /ad "%LiDir%"') do (
  set #Directory=%%D
  mkdir "!#Directory:%LiDir%=%Destination%!" 2>nul
)

:: 方法2
REM xcopy /T "%LiDir%" "%Destination%\"

:: 在新的位置建立硬链接
for /f "delims=" %%F in ('dir /s /b /a-d "%LiDir%"') do (
  set #File=%%F
  mklink /H "!#File:%LiDir%=%Destination%!" "%%F"
)

:end
endlocal
pause
exit /b
