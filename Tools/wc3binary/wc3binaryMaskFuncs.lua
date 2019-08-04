--wc3binaryMaskFuncs.lua

--format 25
function infoFileMaskFunc(data)
	data:add("formatVersion", "int")
	data:add("savesAmount", "int")
	data:add("editorVersion", "int")
	data:add("mapName", "string")
	data:add("mapAuthor", "string")
	data:add("mapDescription", "string")
	data:add("playersRecommendedAmount", "string")
	for i = 1, 8, 1 do
		data:add("cameraBounds"..i, "real")
	end
	data:add("boundaryMarginLeft", "int")
	data:add("boundaryMarginRight", "int")
	data:add("boundaryMarginBottom", "int")
	data:add("boundaryMarginTop", "int")
	data:add("mapWidthWithoutBoundaries", "int")
	data:add("mapHeightWithoutBoundaries", "int")
	data:add("flags", "int", {"hideMinimap", "modifyAllyPriorities", "meleeMap", 
				"initialMapSizeLargeNeverModified", "maskedAreasPartiallyVisible", 
				"fixedPlayerForceSetting", "useCustomForces", "useCustomTechtree", 
				"useCustomAbilities", "useCustomUpgrades", "mapPropertiesWindowOpenedBefore", 
				"showWaterWavesOnCliffShores", "showWaterWavesOnRollingShores"})

	data:add("tileset", "char")
	data:add("loadingScreenIndex", "int")
	data:add("loadingScreenModelPath", "string")
	data:add("loadingScreenText", "string")
	data:add("loadingScreenTitle", "string")
	data:add("loadingScreenSubtitle", "string")
	data:add("gameData", "int")
	data:add("prologueScreenPath", "string")
	data:add("prologueScreenText", "string")
	data:add("prologueScreenTitle", "string")
	data:add("prologueScreenSubtitle", "string")
	data:add("terrainFogType", "int")
	data:add("terrainFogStartZHeight", "real")
	data:add("terrainFogEndZHeight", "real")
	data:add("terrainFogDensity", "real")
	data:add("terrainFogBlue", "byte")
	data:add("terrainFogGreen", "byte")
	data:add("terrainFogRed", "byte")
	data:add("terrainFogAlpha", "byte")
	data:add("globalWeatherId", "id")
	data:add("soundEnvironment", "string")
	data:add("tilesetLightEnvironment", "char")
	data:add("waterBlue", "byte")
	data:add("waterGreen", "byte")
	data:add("waterRed", "byte")
	data:add("waterAlpha", "byte")

	data:add("maxPlayers", "int")

	for i = 1, data:getVal("maxPlayers"), 1 do
		local p = data:add("player"..i, "struct")

		p:add("num", "int")
		p:add("type", "int")
		p:add("race", "int")
		p:add("startLocation", "int")
		p:add("name", "string")
		p:add("startLocationX", "real")
		p:add("startLocationY", "real")

		local t = {}

		for j = 1, data:getVal("maxPlayers"), 1 do
			t[j] = "player"..j
		end

		p:add("allyLowPriorityFlags", "int", t)
		p:add("allyHighPriorityFlags", "int", t)
	end

	data:add("maxForces", "int")

	for i = 1, data:getVal("maxForces"), 1 do
		local f = data:add("force"..i, "struct")

		f:add("flags", "int", {"allied", "alliedVictory", "sharedVision", "shareUnitControl", "shareUnitControlAdvanced"})

		local t = {}

		for j = 1, data:getVal("maxPlayers"), 1 do
			t[j] = "player"..j
		end

		f:add("players", "int", t)

		f:add("name", "string")
	end

	data:add("upgradeModsAmount", "int")

	for i = 1, data:getVal("upgradeModsAmount"), 1 do
		local u = data:add("upgrade"..i, "struct")

		local t = {}

		for j = 1, data:getVal("maxPlayers"), 1 do
			t[j] = "player"..j
		end

		u:add("players", "int", t)
		u:add("id", "id")
		u:add("level", "int")
		u:add("availability", "int")
	end

	data:add("techModsAmount", "int")

	for i = 1, data:getVal("techModsAmount"), 1 do
		local tech = data:add("tech"..i, "struct")

		local t = {}

		for j = 1, data:getVal("maxPlayers"), 1 do
			t[j] = "player"..j
		end

		tech:add("players", "int", t)

		tech:add("id", "id")
	end

	data:add("unitTablesAmount", "int")

	for i = 1, data:getVal("unitTablesAmount"), 1 do
		local u = data:add("unitTable"..i, "struct")

		u:add("index", "int")
		u:add("name", "string")
		u:add("positionsAmount", "int")

		for j = 1, u:getVal("positionsAmount"), 1 do
			local p = u:add("position"..j, "struct")

			p:add("type", "int")

			p:add("itemsAmount", "int")

			for k = 1, p:getVal("itemsAmount"), 1 do
				local i = p:add("item"..k, "struct")

				i:add("chance", "int")
				i:add("id", "id")
			end
		end
	end

	data:add("itemTablesAmount", "int")

	for i = 1, data:getVal("itemTablesAmount"), 1 do
		local i = data:add("itemTable"..i, "struct")

		i:add("index", "int")
		i:add("name", "string")
		i:add("setsAmount", "int")

		for j = 1, i:getVal("setsAmount"), 1 do
			local s = i:add("set"..j, "struct")

			s:add("itemsAmount", "int")

			for k = 1, s:getVal("itemsAmount"), 1 do
				local i = s:add("item"..k, "struct")

				i:add("chance", "int")
				i:add("id", "id")
			end
		end
	end
end

--format 1
function objMaskFunc(data)
	data:add("fileVersion", "int")

	local function addObjs(prefix)
		data:add(prefix.."ObjsAmount", "int")
		for i = 1, data:getVal(prefix.."ObjsAmount"), 1 do
			data:add(prefix.."Obj"..i.."base", "id")
			data:add(prefix.."Obj"..i.."id", "id")
			data:add(prefix.."Obj"..i.."modsAmount", "int")

			for i2 = 1, data:getVal(prefix.."Obj"..i.."modsAmount"), 1 do
				data:add(prefix.."Obj"..i.."mod"..i2.."id", "id")
				data:add(prefix.."Obj"..i.."mod"..i2.."varType", "int")

				local t = {}

				t[0] = "int"
				t[1] = "real"
				t[2] = "unreal"
				t[3] = "string"

				data:add(prefix.."Obj"..i.."mod"..i2.."value", t[data:getVal(prefix.."Obj"..i.."mod"..i2.."varType")])
				data:add(prefix.."Obj"..i.."mod"..i2.."endMarker", "int")
			end
		end
	end

	addObjs("orig")
	addObjs("custom")
end

--format 1
function objExMaskFunc(data)
	data:add("fileVersion", "int")

	local function addObjs(prefix)
		data:add(prefix.."ObjsAmount", "int")
		for i = 1, data:getVal(prefix.."ObjsAmount"), 1 do
			data:add(prefix.."Obj"..i.."base", "id")
			data:add(prefix.."Obj"..i.."id", "id")
			data:add(prefix.."Obj"..i.."modsAmount", "int")

			for i2 = 1, data:getVal(prefix.."Obj"..i.."modsAmount"), 1 do
				data:add(prefix.."Obj"..i.."mod"..i2.."id", "id")
				data:add(prefix.."Obj"..i.."mod"..i2.."varType", "int")
				data:add(prefix.."Obj"..i.."mod"..i2.."variation", "int")
				data:add(prefix.."Obj"..i.."mod"..i2.."dataPointer", "int")

				local t = {}

				t[0] = "int"
				t[1] = "real"
				t[2] = "unreal"
				t[3] = "string"

				data:add(prefix.."Obj"..i.."mod"..i2.."value", t[data:getVal(prefix.."Obj"..i.."mod"..i2.."varType")])
				data:add(prefix.."Obj"..i.."mod"..i2.."endMarker", "int")
			end
		end
	end

	addObjs("orig")
	addObjs("custom")
end

--format 11
function groundHeightToFinalHeight(basicHeight, cliffLevel)
	return (basicHeight - 0x2000 + (cliffLevel - 2) * 0x0200) / 4
end

function environmentMaskFunc(data)
	data:add("startToken", "id")
	data:add("formatVersion", "int")
	data:add("mainTileset", "char")
	data:add("customTilesetsFlag", "int")

	data:add("groundTilesetsUsed", "int")

	for i = 1, data:getVal("groundTilesetsUsed"), 1 do
		data:add("groundTileset"..i.."id", "id")
	end

	data:add("cliffTilesetsUsed", "int")
	for i = 1, data:getVal("cliffTilesetsUsed"), 1 do
		data:add("cliffTileset"..i.."id", "id")
	end

	data:add("width", "int")
	data:add("height", "int")
	data:add("centerX", "real")
	data:add("centerY", "real")

	c = 0

	flagsTable = {"tex", "tex2", "tex3", "tex4", "ramp", "blight", "water", "boundary2"}
	cliffFlagsTable = {"layer1", "layer2", "layer3", "layer4", "cliff1", "cliff2", "cliff3", "cliff4"}
	waterLevelFlagsTable = {}
	waterLevelFlagsTable[16] = "boundary"

	for i = 1, data:getVal("height") * data:getVal("width"), 1 do
		local tile = "tile"..c

		data:add(tile.."groundHeight", "short")
		data:add(tile.."waterLevel", "short", waterLevelFlagsTable)
		data:add(tile.."flags", "byte", flagsTable)
		data:add(tile.."textureDetails", "byte")
		local cliff = data:add(tile.."cliffFlags", "byte", cliffFlagsTable)

		c = c + 1
	end
end

--format 7
function guiTrigMaskFunc(data)
	data:add("startToken", "id")
	data:add("format", "int")
	data:add("trigCategoriesAmount", "int")
	for i = 1, data:getVal("trigCategoriesAmount"), 1 do
		data:add("trigCategory"..i.."index", "int")
		data:add("trigCategory"..i.."name", "string")
		data:add("trigCategory"..i.."type", "int")
	end
	data:add("unknownNumB", "int")
	data:add("varAmount", "int")
	for i = 1, data:getVal("varAmount"), 1 do
		data:add("var"..i.."name", "string")
		data:add("var"..i.."type", "string")
		data:add("var"..i.."unknownNumE", "int")
		data:add("var"..i.."arrayFlag", "int")
		data:add("var"..i.."arraySize", "int")
		data:add("var"..i.."initFlag", "int")
		data:add("var"..i.."initVal", "string")
	end
	data:add("trigAmount", "int")
	for i = 1, data:getVal("trigAmount"), 1 do
		data:add("trig"..i.."name", "string")
		data:add("trig"..i.."description", "string")
		data:add("trig"..i.."comment", "int")
		data:add("trig"..i.."enabled", "int")
		data:add("trig"..i.."customTxtFlag", "int")
		data:add("trig"..i.."initFlag", "int")
		data:add("trig"..i.."runOnMapInit", "int")
		data:add("trig"..i.."categoryIndex", "int")
		data:add("trig"..i.."ECAAmount", "int")
		for i2 = 1, data:getVal("trig"..i.."ECAAmount"), 1 do
			local function addECAStruct(prefix)
print(prefix)
				data:add(prefix.."type", "int")
				data:add(prefix.."funcName", "string")
				data:add(prefix.."enabled", "int")

				local field = data:getVal(prefix.."funcName")
data:print()
print(string.byte(field))
os.execute("pause")
os.execute("cls")
data:print()
				for i3 = 1, #funcArgs[field], 1 do
					local function addParamsStruct(prefix)
						data:add(prefix.."type", "int")
						data:add(prefix.."val", "string")
						data:add(prefix.."beginFunc", "int")

						if (data:getVal(prefix.."beginFunc") == 1) then
							data:add(prefix.."beginFunc".."type", "int")
							data:add(prefix.."beginFunc".."val", "string")
							data:add(prefix.."beginFunc".."beginFunc", "int")

							local field = data:getVal(prefix.."beginFunc".."val")

							for i4 = 1, #funcArgs[field], 1 do
								addParamsStruct(prefix.."param"..i4)
							end

							data:add(prefix.."endFuncToken", "int")
						end					
					end

					addParamsStruct(prefix.."param"..i3)
				end

				data:add(prefix.."unknown", "int")
				data:add(prefix.."ECAAmount", "int")

				for i3 = 1, data:getVal(prefix.."ECAAmount"), 1 do
					addECAStruct(prefix.."ECA"..i3)
				end
			end

			addECAStruct("trig"..i.."ECA"..i2)
		end
	end
end

--format 8
function dooMaskFunc(data)
	data:add("startToken", "id")
	data:add("format", "int")
	data:add("formatSub", "int")

	data:add("treeCount", "int")

	for i = 1, data:getVal("treeCount"), 1 do
		data:add("tree"..i.."type", "id")
		data:add("tree"..i.."variation", "int")
		data:add("tree"..i.."x", "real")
		data:add("tree"..i.."y", "real")
		data:add("tree"..i.."z", "real")
		data:add("tree"..i.."angle", "real")
		data:add("tree"..i.."scaleX", "real")
		data:add("tree"..i.."scaleY", "real")
		data:add("tree"..i.."scaleZ", "real")
		data:add("tree"..i.."flags", "byte")
		data:add("tree"..i.."life", "byte")

		data:add("tree"..i.."itemTablePointer", "int")

		data:add("tree"..i.."itemsDroppedCount", "int")
--print(data:getVal("tree"..i.."itemsDroppedCount"))

		for i2 = 1, data:getVal("tree"..i.."itemsDroppedCount"), 1 do
			data:add("tree"..i.."itemsDrop"..i2.."itemCount", "int")

			for i3 = 1, data:getVal("tree"..i.."itemsDrop"..i2.."itemCount") do
			data:add("tree"..i.."itemsDrop"..i2.."item"..i3.."type", "id")
			data:add("tree"..i.."itemsDrop"..i2.."item"..i3.."chance", "int")
			end
		end

		data:add("tree"..i.."editorID", "int")
	end
end