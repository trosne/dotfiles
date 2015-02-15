@echo off
SET VIMDIR=%USERPROFILE%\vimfiles
SET CURRDIR=%CD%

cls

IF EXIST %VIMDIR% (
    echo Vim directory already exists, moving it to a temporary location.
    MOVE %VIMDIR% %CURRDIR%\oldvimfiles >NUL
)

echo Making directories...
MKDIR %VIMDIR%
MKDIR "%VIMDIR%\autoload"

echo Linking vimfiles...
MKLINK /H "%VIMDIR%\.vimrc" .vimrc >NUL
MKLINK /H "%VIMDIR%\autoload\pathogen.vim" "%CD%\vim-pathogen\autoload\pathogen.vim" >NUL

REM fontinstall.vbs


cd %VIMDIR%

MKDIR bundles
cd bundles
echo Cloning repos...
call %CURRDIR%\clonegh.bat tpope vim-fugitive
call %CURRDIR%\clonegh.bat bling vim-airline
call %CURRDIR%\clonegh.bat altercation vim-colors-solarized
echo Install complete.
cd %CURRDIR%

@echo off
PAUSE
