require "stringLib"

local params = {...}

local rootPath = params[1]
local buildPath = params[2]
local skins = params[3]

print("skinEditor")

local success, moreInfo = pcall(loadfile([[skinEditor.lua]]), rootPath, buildPath, skins)

if success then
	print("success", moreInfo)
	print("buildPath=", buildPath)

	if buildPath then
		os.execute([[copy >NUL ]]..[[ output.txt ]]..(buildPath..[[\war3mapSkin.txt]]):quote())
	end
else
	print("fail", moreInfo)
end