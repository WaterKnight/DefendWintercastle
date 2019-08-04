require "stringLib"

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

		targetFile = io.open(target, "w+b")
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

function getFolderType(path)
	if (path:sub(path:len() - 4, path:len()) == ".page") then
		return "page"
	elseif (path:sub(path:len() - 4, path:len()) == ".pack") then
		return "pack"
	elseif (path:sub(path:len() - 6, path:len()) == ".struct") then
		return "struct"
	end
end

function getRefPath(path)
	local pos, posEnd = path:find("Scripts\\")

	path = path:sub(posEnd + 1, path:len())

	local curScope
	local t = path:split("\\")

	path = nil

	for _, v in pairs(t) do
		if (v ~= "") then
			local include
			local type = getFolderType(v)

			if (type == "page") then
				include = true
			elseif ((curScope == "page") or (curScope == "struct")) then
				if (type == "pack") then
					curScope = type
				else
					include = true
				end
			end

			if include then
				if path then
					path = path..v.."\\"
				else
					path = v.."\\"
				end
			end

			if type then
				curScope = type
			end
		end
	end

	if (path == nil) then
		return ""
	end

	return path
end

function getScriptRallyPath(path)
	local t = path:split("\\")

	local c = 1
	local lastStruct

	for k, v in pairs(t) do
		if (v == "") then
			t[k] = nil
		end
	end

	while t[c] do
		if (getFolderType(t[c]) == "struct") then
			lastStruct = c
		end

		c = c + 1
	end

	if (lastStruct == nil) then
		return path
	end

	c = lastStruct + 1

	while (t[c] and (getFolderType(t[c]) == nil)) do
		c = c + 1
	end

	return table.concat(t, "\\", 1, c - 1).."\\"
end