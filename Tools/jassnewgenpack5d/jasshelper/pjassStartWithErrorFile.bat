cd /d %~dp0

JassParserCLI.exe common.j blizzard.j %1 > pjassErrors.txt

start pjassErrors.txt