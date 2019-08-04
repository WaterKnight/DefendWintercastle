local params = {...}

local inputPath = params[1]
local buildNum = tonumber(params[2])

require "wc3binaryFile"
require "wc3binaryMaskFuncs"

data = wc3binaryFile.create()

data.readFromFile(inputPath, infoFileMaskFunc)

require "wc3objLib"

local obj = wc3objLib.create("mapInfo.wc3obj")

data.setVal("mapName", obj.levelVals["name"][1].." "..buildNum)
data.setVal("savesAmount", buildNum)
data.setVal("mapAuthor", obj.levelVals["author"][1])

data.setVal("loadingScreenIndex", obj.levelVals["loadingScreenIndex"][1])
data.setVal("loadingScreenModelPath", obj.levelVals["loadingScreenModelPath"][1])

data.writeToFile("output.w3i", infoFileMaskFunc)

os.exit(0)