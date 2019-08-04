del %2

REM "C:\Dokumente und Einstellungen\XP001\Eigene Dateien\Visual Studio 2010\Projects\ShellStarter\ShellStarter\bin\Release\ShellStarter.exe" "%~dp0VXJWTSOPT.exe"  --checkscriptstuff --tweak "%~dp0options.vxtweak" %1 --do %2 --exit
start /wait /min "" "%~dp0VXJWTSOPT.exe" --checkscriptstuff --tweak "%~dp0options.vxtweak" %1 --do %2 --exit

del %2.j

pause