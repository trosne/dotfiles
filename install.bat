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
MKDIR old

echo Fetching submodules...
git submodule update

IF EXIST "%VIMDIR%" (
    echo Vim directory already exists, moving it to a temporary location.
    MOVE "%VIMDIR%" "%CURRDIR%\old\vimfiles" >NUL
    MKDIR "%VIMDIR%"
)
IF EXIST %VIMDIR%\..\.vimrc (MOVE "%VIMDIR%\..\.vimrc" "%CURRDIR%\old\.vimrc" >NUL )

echo Making directories...
IF NOT EXIST "%VIMDIR%" (MKDIR "%VIMDIR%")
IF NOT EXIST "%VIMDIR%\autoload" (MKDIR "%VIMDIR%\autoload")

echo Linking vimfiles...
MKLINK /H "%VIMDIR%\..\.vimrc" .vimrc >NUL
IF NOT EXIST "%VIMDIR%\autoload\pathogen.vim" (MKLINK /H "%VIMDIR%\autoload\pathogen.vim" "%CURRDIR%\vim-pathogen\autoload\pathogen.vim" >NUL )

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
echo Install complete.
cd %CURRDIR%

@echo off
PAUSE
