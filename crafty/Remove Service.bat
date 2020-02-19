@echo off
path %path%;"%CD%\NSSM\win64\"
"%CD%\NSSM\win64\nssm.exe" stop CraftyController
"%CD%\NSSM\win64\nssm.exe" remove CraftyController confirm
echo Removed!
pause