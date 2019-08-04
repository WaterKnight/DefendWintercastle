require "binaryFile"

params = {...}

buildPath = params[1]

dataByName = {}
dataPatterns = {}

f = io.open(buildPath..[[\war3map.w3i]], "r")

curPos = 1
data = f:read("*a")

function getVal(name)
	return dataByName[name].val
end

function addDataPattern(name, type)
	local d = {}

	dataPatterns[#dataPatterns + 1] = d

	d.name = name
	d.type = type

	dataByName[name] = d

	local val

	if (type == "int") then
		val = readInt()
	elseif (type == "intflags") then
		val = readInt()
	elseif (type == "real") then
		val = readReal()
	elseif (type == "unreal") then
		val = readUnreal()
	elseif (type == "byte") then
		val = readByte()
	elseif (type == "char") then
		val = readChar()
	elseif (type == "string") then
		val = readString()
	elseif (type == "id") then
		val = readId()
	end

	d.val = val

	if (type == "intflags") then
		d.flags = {}
	end
end

function addIntFlag(parentName, subName)
	local parent = dataByName[parentName]
	local sub = {}

	sub.name = subName
	sub.val = readBit(parent.val, #parent.flags + 1)

	parent.flags[#parent.flags + 1] = sub
end

addDataPattern("formatVersion", "int")
addDataPattern("savesAmount", "int")
addDataPattern("editorVersion", "int")
addDataPattern("mapName", "string")
addDataPattern("mapAuthor", "string")
addDataPattern("mapDescription", "string")
addDataPattern("playersRecommendedAmount", "string")
for i = 1, 8, 1 do
	addDataPattern("cameraBounds"..i, "real")
end
addDataPattern("boundaryMarginLeft", "int")
addDataPattern("boundaryMarginRight", "int")
addDataPattern("boundaryMarginBottom", "int")
addDataPattern("boundaryMarginTop", "int")
addDataPattern("mapWidthWithoutBoundaries", "int")
addDataPattern("mapHeightWithoutBoundaries", "int")
addDataPattern("flags", "intflags")

addIntFlag("flags", "hideMinimap")
addIntFlag("flags", "modifyAllyPriorities")
addIntFlag("flags", "meleeMap")
addIntFlag("flags", "initialMapSizeLargeNeverModified")
addIntFlag("flags", "maskedAreasPartiallyVisible")
addIntFlag("flags", "fixedPlayerForceSetting")
addIntFlag("flags", "useCustomForces")
addIntFlag("flags", "useCustomTechtree")
addIntFlag("flags", "useCustomAbilities")
addIntFlag("flags", "useCustomUpgrades")
addIntFlag("flags", "mapPropertiesWindowOpenedBefore")
addIntFlag("flags", "showWaterWavesOnCliffShores")
addIntFlag("flags", "showWaterWavesOnRollingShores")

addDataPattern("tileset", "char")
addDataPattern("loadingScreenIndex", "int")
addDataPattern("loadingScreenModelPath", "string")
addDataPattern("loadingScreenText", "string")
addDataPattern("loadingScreenTitle", "string")
addDataPattern("loadingScreenSubtitle", "string")
addDataPattern("gameData", "int")
addDataPattern("prologueScreenPath", "string")
addDataPattern("prologueScreenText", "string")
addDataPattern("prologueScreenTitle", "string")
addDataPattern("prologueScreenSubtitle", "string")
addDataPattern("terrainFogType", "int")
addDataPattern("terrainFogStartZHeight", "real")
addDataPattern("terrainFogEndZHeight", "real")
addDataPattern("terrainFogDensity", "real")
addDataPattern("terrainFogBlue", "byte")
addDataPattern("terrainFogGreen", "byte")
addDataPattern("terrainFogRed", "byte")
addDataPattern("terrainFogAlpha", "byte")
print("fogalpha "..getVal("terrainFogAlpha"))
addDataPattern("globalWeatherId", "id")
print(getVal("globalWeatherId"))
addDataPattern("soundEnvironment", "string")
addDataPattern("tilesetLightEnvironment", "char")
addDataPattern("waterBlue", "byte")
addDataPattern("waterGreen", "byte")
addDataPattern("waterRed", "byte")
addDataPattern("waterAlpha", "byte")
print("---")
addDataPattern("maxPlayers", "int")
os.execute("pause")

print("---")

for i = 1, getVal("maxPlayers"), 1 do
	addDataPattern("playerNum"..i, "int")
	addDataPattern("playerType"..i, "int")
	addDataPattern("playerRace"..i, "int")
	addDataPattern("playerStartLocation"..i, "int")
	addDataPattern("playerName"..i, "string")
	addDataPattern("playerStartLocationX"..i, "real")
	addDataPattern("playerStartLocationY"..i, "real")
	addDataPattern("playerAllyLowPriorityFlags"..i, "intflags")
	addDataPattern("playerAllyHighPriorityFlags"..i, "intflags")

	for j = 1, getVal("maxPlayers"), 1 do
		addIntFlag("playerAllyLowPriorityFlags"..i, "player"..j)
	end
end
print("---")
addDataPattern("maxForces", "int")
print("---")
for i = 1, getVal("maxForces"), 1 do
print(getVal("maxForces"))
	addDataPattern("forcesFlags"..i, "intflags")

	addIntFlag("forcesFlags"..i, "allied")
	addIntFlag("forcesFlags"..i, "alliedVictory")
	addIntFlag("forcesFlags"..i, "sharedVision")
	addIntFlag("forcesFlags"..i, "shareUnitControl")
	addIntFlag("forcesFlags"..i, "shareUnitControlAdvanced")

	addDataPattern("forcesPlayers"..i, "intflags")

	for j = 1, getVal("maxPlayers"), 1 do
		addIntFlag("forcesPlayers"..i, "player"..j)
	end

	addDataPattern("forcesName"..i, "string")
end

addDataPattern("upgradeModsAmount", "int")

for i = 1, getVal("upgradeModsAmount"), 1 do
	addDataPattern("upgradePlayers"..i, "intflags")

	for j = 1, getVal("maxPlayers"), 1 do
		addIntFlag("upgradePlayers"..i, "player"..j)
	end

	addDataPattern("upgradeId"..i, "id")
	addDataPattern("upgradeLevel"..i, "int")
	addDataPattern("upgradeAvailability"..i, "int")
end

addDataPattern("techModsAmount", "int")

for i = 1, getVal("techModsAmount"), 1 do
	addDataPattern("techPlayers"..i, "intflags")

	for j = 1, getVal("maxPlayers"), 1 do
		addIntFlag("techPlayers"..i, "player"..j)
	end

	addDataPattern("techId"..i, "id")
end

addDataPattern("unitTablesAmount", "int")

for i = 1, getVal("unitTablesAmount"), 1 do
	addDataPattern("unitTable"..i.."Index", "int")
	addDataPattern("unitTable"..i.."Name", "string")
	addDataPattern("unitTable"..i.."PositionsAmount", "int")

	for j = 1, getVal("unitTable"..i.."PositionsAmount"), 1 do
		addDataPattern("unitTable"..i.."Position"..j.."Type", "int")

		addDataPattern("unitTable"..i.."Position"..j.."ItemsAmount", "int")

		for k = 1, getVal("unitTable"..i.."Position"..j.."ItemsAmount"), 1 do
			addDataPattern("unitTable"..i.."Position"..j.."Item"..k.."Chance", "int")
			addDataPattern("unitTable"..i.."Position"..j.."Item"..k.."Id", "id")
		end
	end
end

addDataPattern("itemTablesAmount", "int")

for i = 1, getVal("itemTablesAmount"), 1 do
	addDataPattern("itemTable"..i.."Index", "int")
	addDataPattern("itemTable"..i.."Name", "string")
	addDataPattern("itemTable"..i.."SetsAmount", "int")

	for j = 1, getVal("itemTable"..i.."SetsAmount"), 1 do
		addDataPattern("itemTable"..i.."Set"..j.."ItemsAmount", "int")

		for k = 1, getVal("itemTable"..i.."Set"..j.."ItemsAmount"), 1 do
			addDataPattern("itemTable"..i.."Set"..j.."Item"..k.."Chance", "int")
			addDataPattern("itemTable"..i.."Set"..j.."Item"..k.."Id", "id")
		end
	end
end

c = 1

while dataPatterns[c] do
	local d = dataPatterns[c]

	if (d.type == "intflags") then
		for c2 = 1, #d.flags, 1 do
			local sub = d.flags[c2]

			print("\t"..sub.name.." --> "..sub.val)
		end
	else
		print(d.name.." --> "..d.val)
	end

	c = c + 1
end

os.execute("pause")
os.execute("pause")

f = io.open(buildPath..[[\war3map.w3i]], "w+")

if f then
	print("setInfoFile")

	for i = 1, #dataPatterns, 1 do
		local d = dataPatterns[i]

		local type = d.type

		if (type == "int") then
			writeInt(d.val)
		elseif (type == "intflags") then
			local flags = d.flags
			local val = 0

			for bit = 1, #flags, 1 do
				val = val + flags[bit].val * math.pow(2, bit - 1)
			end

			writeInt(val)
		elseif (type == "real") then
			writeReal(d.val)
		elseif (type == "unreal") then
			writeUnreal(d.val)
		elseif (type == "byte") then
			writeByte(d.val)
		elseif (type == "char") then
			writeChar(d.val)
		elseif (type == "string") then
			writeString(d.val)
		elseif (type == "id") then
			writeId(d.val)
		end
	end

	f:close()
else
	print("setInfoFile - could not create file")
end