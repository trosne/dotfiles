@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
SET VIMDIR=%PROGRAMFILES(x86)%\vim\vimfiles

SET CURRDIR=%CD%

cls
SET OLDDIR=old_%date:~-4,4%%date:~-10,2%%date:~7,2%_%time:~0,2%%time:~3,2%
MKDIR %OLDDIR%

echo Fetching submodules...
git submodule update


IF EXIST "%VIMDIR%" IF NOT EXIST "%VIMDIR%\trond.txt" (
    echo Vim directory already exists, moving it to a temporary location.
    MOVE "%VIMDIR%" "%OLDDIR%\vimfiles" >NUL
    MKDIR "%VIMDIR%"
)
echo Trond was here. Last update: %date% %time% >"%VIMDIR%\trond.txt"
IF EXIST "%USERPROFILE%\.vimrc" (MOVE "%USERPROFILE%\.vimrc" "%OLDDIR%\.vimrc" >NUL )

IF NOT EXIST "%OLDDIR%\*" (DEL /F %OLDDIR% >NUL )

echo Making directories...
IF NOT EXIST "%VIMDIR%" (MKDIR "%VIMDIR%")
IF NOT EXIST "%VIMDIR%\autoload" (MKDIR "%VIMDIR%\autoload")

echo Linking vimfiles...
MKLINK /H "%USERPROFILE%\.vimrc" .vimrc >NUL
IF NOT EXIST "%VIMDIR%\autoload\pathogen.vim" (MKLINK /H "%VIMDIR%\autoload\pathogen.vim" "%CURRDIR%\vim-pathogen\autoload\pathogen.vim" >NUL )

echo Entering %VIMDIR%...
cd "%VIMDIR%"

IF NOT EXIST bundle (MKDIR bundle)
cd bundle
echo Cloning repos...
call %CURRDIR%\clonegh.bat tpope vim-fugitive
call %CURRDIR%\clonegh.bat bling vim-airline
call %CURRDIR%\clonegh.bat altercation vim-colors-solarized
call %CURRDIR%\clonegh.bat scrooloose syntastic
call %CURRDIR%\clonegh.bat xolox vim-easytags
call %CURRDIR%\clonegh.bat xolox vim-misc
call %CURRDIR%\clonegh.bat xolox vim-shell
call %CURRDIR%\clonegh.bat vim-scripts a.vim
echo Install complete.
cd %CURRDIR%

@echo off
PAUSE
