@echo off
cls
SET VIMDIR=%USERPROFILE%\vimfiles

echo Deleting generated vimfiles . . .
RMDIR %VIMDIR% /s /q
IF EXIST %CD%\oldvimfiles (
  echo Retrieving old vimfiles folder . . .
  MOVE oldvimfiles %VIMDIR% >NUL
) ELSE (echo Unable to find old vimfiles.)
echo Done.
@echo off
PAUSE


