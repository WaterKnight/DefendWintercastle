function getFileName(s, noExtension)
	while s:find("\\") do
		s = s:sub(s:find("\\") + 1)
	end

	if noExtension then
		if s:lastFind(".") then
			s = s:sub(1, s:lastFind(".") - 1)
		end
	end

	return s
end

function getFolder(s)
	res = ""

	while s:find("\\") do
		res = res..s:sub(1, s:find("\\"))

		s = s:sub(s:find("\\") + 1)
	end

	return res
end

function copyFile(source, target)
	local sourceFile = io.open(source, "rb")
	local targetFile = io.open(target, "w+b")

	if (targetFile == nil) then
		os.execute([[mkdir ]]..getFolder(target):quote())

		targetFile = io.open(target, "wb+")
	end

	targetFile:write(sourceFile:read("*a"))

	sourceFile:close()
	targetFile:close()
end

function copyDir(source, target)
	os.execute([[xcopy ]]..source:quote()..[[ ]]..target:quote()..[[ /e /i /y /q]])
end

function getFileTime()
	alien = require "alien"

	CreateFile = alien.kernel32.CreateFileA
	tmp = alien.buffer(4)
	FILETIME = alien.defstruct{{'dwLowDateTime', 'ulong'}, {'dwHighDateTime', 'ulong'}}
	GetFileTime = alien.kernel32.GetFileTime

	CreateFile:types{ret = "pointer", abi = 'stdcall', 'string', "int", "int", "pointer", "int", "int", "pointer"}
	GetFileTime:types{ret = 'int', abi = 'stdcall', "pointer", "pointer", "pointer", "pointer"}

	hFile = CreateFile(fileName..".slk", GENERIC_WRITE, 7, nil, OPEN_EXISTING, 0, nil)

	tmp:set(1, hFile, 'pointer')

	fT = FILETIME:new()

	GetFileTime(hFile, nil, nil, fT())

	print(fT)
end

require "stringLib"

function getFiles(dir, filePath)
	local c = 0
	local t = {}
print(dir..[[\]]..filePath)
	for line in io.popen([[dir ]]..(dir..[[\]]..filePath):quote()..[[ /b /s]]):lines() do
		c = c + 1
		t[c] = line
	end

	return t
end

function getWorkingDir()
	return io.popen([[cd]]):read("*l")
end

function getScriptDir()
	return getFolder(debug.getinfo(1).source:sub(1))
end

function changeWorkingDir(path)
	assert(path, "no path specified")

	os.execute([[cd /d ]]..path:quote())
end