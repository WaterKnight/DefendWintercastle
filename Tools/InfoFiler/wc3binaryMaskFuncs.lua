--wc3binaryMaskFuncs.lua

--format 25
function infoFileMaskFunc(data)
	data.add("formatVersion", "int")
	data.add("savesAmount", "int")
	data.add("editorVersion", "int")
	data.add("mapName", "string")
	data.add("mapAuthor", "string")
	data.add("mapDescription", "string")
	data.add("playersRecommendedAmount", "string")
	for i = 1, 8, 1 do
		data.add("cameraBounds"..i, "real")
	end
	data.add("boundaryMarginLeft", "int")
	data.add("boundaryMarginRight", "int")
	data.add("boundaryMarginBottom", "int")
	data.add("boundaryMarginTop", "int")
	data.add("mapWidthWithoutBoundaries", "int")
	data.add("mapHeightWithoutBoundaries", "int")
	data.add("flags", "intflags")

	data.addIntFlag("flags", "hideMinimap")
	data.addIntFlag("flags", "modifyAllyPriorities")
	data.addIntFlag("flags", "meleeMap")
	data.addIntFlag("flags", "initialMapSizeLargeNeverModified")
	data.addIntFlag("flags", "maskedAreasPartiallyVisible")
	data.addIntFlag("flags", "fixedPlayerForceSetting")
	data.addIntFlag("flags", "useCustomForces")
	data.addIntFlag("flags", "useCustomTechtree")
	data.addIntFlag("flags", "useCustomAbilities")
	data.addIntFlag("flags", "useCustomUpgrades")
	data.addIntFlag("flags", "mapPropertiesWindowOpenedBefore")
	data.addIntFlag("flags", "showWaterWavesOnCliffShores")
	data.addIntFlag("flags", "showWaterWavesOnRollingShores")

	data.add("tileset", "char")
	data.add("loadingScreenIndex", "int")
	data.add("loadingScreenModelPath", "string")
	data.add("loadingScreenText", "string")
	data.add("loadingScreenTitle", "string")
	data.add("loadingScreenSubtitle", "string")
	data.add("gameData", "int")
	data.add("prologueScreenPath", "string")
	data.add("prologueScreenText", "string")
	data.add("prologueScreenTitle", "string")
	data.add("prologueScreenSubtitle", "string")
	data.add("terrainFogType", "int")
	data.add("terrainFogStartZHeight", "real")
	data.add("terrainFogEndZHeight", "real")
	data.add("terrainFogDensity", "real")
	data.add("terrainFogBlue", "byte")
	data.add("terrainFogGreen", "byte")
	data.add("terrainFogRed", "byte")
	data.add("terrainFogAlpha", "byte")
	data.add("globalWeatherId", "id")
	data.add("soundEnvironment", "string")
	data.add("tilesetLightEnvironment", "char")
	data.add("waterBlue", "byte")
	data.add("waterGreen", "byte")
	data.add("waterRed", "byte")
	data.add("waterAlpha", "byte")
	data.add("maxPlayers", "int")

	for i = 1, data.getVal("maxPlayers"), 1 do
		data.add("player"..i.."Num", "int")
		data.add("player"..i.."Type", "int")
		data.add("player"..i.."Race", "int")
		data.add("player"..i.."StartLocation", "int")
		data.add("player"..i.."Name", "string")
		data.add("player"..i.."StartLocationX", "real")
		data.add("player"..i.."StartLocationY", "real")
		data.add("player"..i.."AllyLowPriorityFlags", "intflags")
		data.add("player"..i.."AllyHighPriorityFlags", "intflags")

		for j = 1, data.getVal("maxPlayers"), 1 do
			data.addIntFlag("player"..i.."AllyLowPriorityFlags", "player"..j)
			data.addIntFlag("player"..i.."AllyHighPriorityFlags", "player"..j)
		end
	end

	data.add("maxForces", "int")

	for i = 1, data.getVal("maxForces"), 1 do
		data.add("force"..i.."Flags", "intflags")

		data.addIntFlag("force"..i.."Flags", "allied")
		data.addIntFlag("force"..i.."Flags", "alliedVictory")
		data.addIntFlag("force"..i.."Flags", "sharedVision")
		data.addIntFlag("force"..i.."Flags", "shareUnitControl")
		data.addIntFlag("force"..i.."Flags", "shareUnitControlAdvanced")

		data.add("force"..i.."Players", "intflags")

		for j = 1, data.getVal("maxPlayers"), 1 do
			data.addIntFlag("force"..i.."Players", "player"..j)
		end

		data.add("force"..i.."Name", "string")
	end

	data.add("upgradeModsAmount", "int")

	for i = 1, data.getVal("upgradeModsAmount"), 1 do
		data.add("upgrade"..i.."Players", "intflags")

		for j = 1, data.getVal("maxPlayers"), 1 do
			data.addIntFlag("upgrade"..i.."Players", "player"..j)
		end

		data.add("upgrade"..i.."Id", "id")
		data.add("upgrade"..i.."Level", "int")
		data.add("upgrade"..i.."Availability", "int")
	end

	data.add("techModsAmount", "int")

	for i = 1, data.getVal("techModsAmount"), 1 do
		data.add("tech"..i.."Players", "intflags")

		for j = 1, data.getVal("maxPlayers"), 1 do
			data.addIntFlag("tech"..i.."Players", "player"..j)
		end

		data.add("tech"..i.."Id", "id")
	end

	data.add("unitTablesAmount", "int")

	for i = 1, data.getVal("unitTablesAmount"), 1 do
		data.add("unitTable"..i.."Index", "int")
		data.add("unitTable"..i.."Name", "string")
		data.add("unitTable"..i.."PositionsAmount", "int")

		for j = 1, data.getVal("unitTable"..i.."PositionsAmount"), 1 do
			data.add("unitTable"..i.."Position"..j.."Type", "int")

			data.add("unitTable"..i.."Position"..j.."ItemsAmount", "int")

			for k = 1, data.getVal("unitTable"..i.."Position"..j.."ItemsAmount"), 1 do
				data.add("unitTable"..i.."Position"..j.."Item"..k.."Chance", "int")
				data.add("unitTable"..i.."Position"..j.."Item"..k.."Id", "id")
			end
		end
	end

	data.add("itemTablesAmount", "int")

	for i = 1, data.getVal("itemTablesAmount"), 1 do
		data.add("itemTable"..i.."Index", "int")
		data.add("itemTable"..i.."Name", "string")
		data.add("itemTable"..i.."SetsAmount", "int")

		for j = 1, data.getVal("itemTable"..i.."SetsAmount"), 1 do
			data.add("itemTable"..i.."Set"..j.."ItemsAmount", "int")

			for k = 1, data.getVal("itemTable"..i.."Set"..j.."ItemsAmount"), 1 do
				data.add("itemTable"..i.."Set"..j.."Item"..k.."Chance", "int")
				data.add("itemTable"..i.."Set"..j.."Item"..k.."Id", "id")
			end
		end
	end
end

--format 1
function objMaskFunc(data)
	data.add("fileVersion", "int")

	local function addObjs(prefix)
		data.add(prefix.."ObjsAmount", "int")
		for i = 1, data.getVal(prefix.."ObjsAmount"), 1 do
			data.add(prefix.."Obj"..i.."base", "id")
			data.add(prefix.."Obj"..i.."id", "id")
			data.add(prefix.."Obj"..i.."modsAmount", "int")

			for i2 = 1, data.getVal(prefix.."Obj"..i.."modsAmount"), 1 do
				data.add(prefix.."Obj"..i.."mod"..i2.."id", "id")
				data.add(prefix.."Obj"..i.."mod"..i2.."varType", "int")

				local t = {}

				t[0] = "int"
				t[1] = "real"
				t[2] = "unreal"
				t[3] = "string"

				data.add(prefix.."Obj"..i.."mod"..i2.."value", t[data.getVal(prefix.."Obj"..i.."mod"..i2.."varType")])
				data.add(prefix.."Obj"..i.."mod"..i2.."endMarker", "int")
			end
		end
	end

	addObjs("orig")
	addObjs("custom")
end

--format 1
function objExMaskFunc(data)
	data.add("fileVersion", "int")

	local function addObjs(prefix)
		data.add(prefix.."ObjsAmount", "int")
		for i = 1, data.getVal(prefix.."ObjsAmount"), 1 do
			data.add(prefix.."Obj"..i.."base", "id")
			data.add(prefix.."Obj"..i.."id", "id")
			data.add(prefix.."Obj"..i.."modsAmount", "int")

			for i2 = 1, data.getVal(prefix.."Obj"..i.."modsAmount"), 1 do
				data.add(prefix.."Obj"..i.."mod"..i2.."id", "id")
				data.add(prefix.."Obj"..i.."mod"..i2.."varType", "int")
				data.add(prefix.."Obj"..i.."mod"..i2.."variation", "int")
				data.add(prefix.."Obj"..i.."mod"..i2.."dataPointer", "int")

				local t = {}

				t[0] = "int"
				t[1] = "real"
				t[2] = "unreal"
				t[3] = "string"

				data.add(prefix.."Obj"..i.."mod"..i2.."value", t[data.getVal(prefix.."Obj"..i.."mod"..i2.."varType")])
				data.add(prefix.."Obj"..i.."mod"..i2.."endMarker", "int")
			end
		end
	end

	addObjs("orig")
	addObjs("custom")
end