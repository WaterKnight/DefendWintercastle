BUTTON_POS_X = {}

BUTTON_POS_X["ARTIFACT"] = 1
BUTTON_POS_X["HERO_FIRST"] = 0
BUTTON_POS_X["HERO_SECOND"] = 1
BUTTON_POS_X["HERO_ULTIMATE"] = 2
BUTTON_POS_X["HERO_ULTIMATE_EX"] = 3
BUTTON_POS_X["NORMAL"] = 0
BUTTON_POS_X["PURCHASABLE"] = 2

BUTTON_POS_Y = {}

BUTTON_POS_Y["ARTIFACT"] = 1
BUTTON_POS_Y["HERO_FIRST"] = 2
BUTTON_POS_Y["HERO_SECOND"] = 2
BUTTON_POS_Y["HERO_ULTIMATE"] = 2
BUTTON_POS_Y["HERO_ULTIMATE_EX"] = 2
BUTTON_POS_Y["NORMAL"] = 2
BUTTON_POS_Y["PURCHASABLE"] = 1

HOTKEY = {}

HOTKEY["ARTIFACT"] = "F"
HOTKEY["HERO_FIRST"] = "Q"
HOTKEY["HERO_SECOND"] = "W"
HOTKEY["HERO_ULTIMATE"] = "E"
HOTKEY["HERO_ULTIMATE_EX"] = "R"
HOTKEY["NORMAL"] = "Q"
HOTKEY["PURCHASABLE"] = "T"

IS_HERO_SPELL = {}

IS_HERO_SPELL["ARTIFACT"] = true
IS_HERO_SPELL["HERO_FIRST"] = true
IS_HERO_SPELL["HERO_SECOND"] = true
IS_HERO_SPELL["HERO_ULTIMATE"] = true
IS_HERO_SPELL["HERO_ULTIMATE_EX"] = true

LEARN_BUTTON_POS_X = {}

LEARN_BUTTON_POS_X["ARTIFACT"] = 0
LEARN_BUTTON_POS_X["HERO_FIRST"] = 0
LEARN_BUTTON_POS_X["HERO_SECOND"] = 1
LEARN_BUTTON_POS_X["HERO_ULTIMATE"] = 2
LEARN_BUTTON_POS_X["HERO_ULTIMATE_EX"] = 3

LEARN_BUTTON_POS_Y = {}

LEARN_BUTTON_POS_Y["ARTIFACT"] = 1
LEARN_BUTTON_POS_Y["HERO_FIRST"] = 0
LEARN_BUTTON_POS_Y["HERO_SECOND"] = 0
LEARN_BUTTON_POS_Y["HERO_ULTIMATE"] = 0
LEARN_BUTTON_POS_Y["HERO_ULTIMATE_EX"] = 0

LEARN_HOTKEY = {}

LEARN_HOTKEY["ARTIFACT"] = "F"
LEARN_HOTKEY["HERO_FIRST"] = "Q"
LEARN_HOTKEY["HERO_SECOND"] = "W"
LEARN_HOTKEY["HERO_ULTIMATE"] = "E"
LEARN_HOTKEY["HERO_ULTIMATE_EX"] = "R"

LEARN_SLOT = {}

LEARN_SLOT["ARTIFACT"] = 4
LEARN_SLOT["HERO_FIRST"] = 0
LEARN_SLOT["HERO_SECOND"] = 1
LEARN_SLOT["HERO_ULTIMATE"] = 2
LEARN_SLOT["HERO_ULTIMATE_EX"] = 3

LEVELS_AMOUNT = {}

LEVELS_AMOUNT["ARTIFACT"] = 5
LEVELS_AMOUNT["HERO_FIRST"] = 5
LEVELS_AMOUNT["HERO_SECOND"] = 5
LEVELS_AMOUNT["HERO_ULTIMATE"] = 3
LEVELS_AMOUNT["HERO_ULTIMATE_EX"] = 2
LEVELS_AMOUNT["ITEM"] = 1
LEVELS_AMOUNT["NORMAL"] = 1
LEVELS_AMOUNT["PURCHASABLE"] = 5

ORDER = {}

ORDER["NORMAL"] = "channel"
ORDER["PARALLEL_IMMEDIATE"] = "berserk"

TARGET = {}

TARGET["PARALLEL_IMMEDIATE"] = "IMMEDIATE"

--table
function tableContains(t, e)
	if (t == nil) then
		return false
	end

	for k, v in pairs(t) do
		if (v == e) then
			return true
		end
	end

	return false
end

require "stringLib"
require "fileLib"

slkData = {}

function updateFile(path, isMod)
	local file = nil
	local fileName = getFileName(path)
	local folder = getFolder(path)

	local extension = fileName:sub(fileName:find(".wc3", 1, true) + 1)

	fileName = fileName:sub(1, fileName:find(".wc3", 1, true) - 1)

	refPath = getRefPath(folder)..fileName

	if extension then
		refPath = refPath.."."..extension
	end

	local maxX = nil
	local maxY = nil
	local table = {}

	local function loadWc3Obj(path)
		local file = io.open(path, "r")

		local curY = 0

		for line in file:lines() do
			if line then
				local curX = 0
				curY = curY + 1

				table[curY] = {}

				for i, s in pairs(line:split("\t")) do
					curX = curX + 1

					if ((maxX == nil) or (curX > maxX)) then
						maxX = curX
					end

	                		if tonumber(s) then
						if ((table[curY][1] == "raw") or (table[curY][1] == "baseRaw")) then
							table[curY][curX] = s
						else
							table[curY][curX] = tonumber(s)
						end
					elseif (tobool(s) ~= nil) then
						table[curY][curX] = tobool(s)
					else
						table[curY][curX] = s
					end
				end
			end
		end

		file:close()
		maxY = curY
	end

	print("load "..fileName.." at "..folder)
	loadWc3Obj(path)

	--fetch values from grid
	local jassIdentCol

	for x = 1, maxX, 1 do
		if (table[1][x] == "jass ident") then
			jassIdentCol = x
		end
	end

	local levelVals = {}
	local vals = {}

	local arrayFields = {}
	local levelsAmount = 0

	for y = 1, maxY, 1 do
		local field = table[y][1]

		if (field and (field ~= "") and (field ~= "field") and (field:find("//", 1, true) ~= 1)) then
			if vals[field] then
				for x = 1, maxX, 1 do
					level = table[1][x]
					if vals[field][x] then
						if table[y][x] then
							vals[field][x] = vals[field][x]..";"..table[y][x]
						else
							vals[field][x] = vals[field][x]..";"
						end
					else
						if table[y][x] then
							vals[field][x] = ";"..table[y][x]
						else
							vals[field][x] = ";"
						end
					end

					if (level == "value") then
						level = 1
					end

					if (type(level) == "number") then
						if levelVals[field][level] then
							if table[y][x] then
								levelVals[field][level] = levelVals[field][level]..";"..table[y][x]
							else
								levelVals[field][level] = levelVals[field][level]..";"
							end
						else
							if table[y][x] then
								levelVals[field][level] = ";"..table[y][x]
							else
								levelVals[field][level] = ";"
							end
						end
					end
				end
			else
				vals[field] = {}
				levelVals[field] = {}

				for x = 1, maxX, 1 do
					level = table[1][x]
					vals[field][x] = table[y][x]

					if (level == "value") then
						level = 1
					end

					if (type(level) == "number") then
						if (level > levelsAmount) then
							levelsAmount = level
						end

						levelVals[field][level] = table[y][x]
						if ((level ~= 0) and (level ~= 1) and table[y][x]) then
							arrayFields[field] = field
						end
					end
				end
			end
		end
	end

	local function getVal(field)
		return levelVals[field]
	end

	--default fields used for native object construction etc.
	local isDefaultField = {}

	local function setDefaultValue(field, val)
		isDefaultField[field] = true
		if ((levelVals[field] == nil) or (levelVals[field][1] == nil)) then
			levelVals[field] = {}

			levelVals[field][1] = val
		end
	end

	setDefaultValue("base", nil)
	setDefaultValue("classes", nil)
	setDefaultValue("field", nil)
	setDefaultValue("levelsAmount", nil)
	setDefaultValue("name", nil)
	setDefaultValue("raw", nil)
	setDefaultValue("sharedBuffs", nil)
	setDefaultValue("specials", nil)
	setDefaultValue("specialsTrue", nil)
	setDefaultValue("var", fileName)

	--treat raw as non-string
	if getVal("raw")[1] then
		getVal("raw")[1] = dequote(getVal("raw")[1])
	end

	local dummy
	local t = getVal("classes")

	if (t and t[1]) then
		if tableContains(t[1]:split(";"), "DUMMY") then
			dummy = true
		end
	end

	if (extension == "wc3spell") then
		if (getVal("raw")[1] and (getVal("raw")[1]:len() == 3)) then
			if dummy then
				getVal("raw")[1] = "a"..getVal("raw")[1]
			else
				getVal("raw")[1] = "A"..getVal("raw")[1]
			end
		end

		local class

		if (getVal("base")[1] == nil) then
			getVal("base")[1] = "NORMAL"
		end

		setDefaultValue("class", nil)

		class = getVal("class")[1]

		local hero = IS_HERO_SPELL[class]

		setDefaultValue("hero", hero)

		if class then
			if (getVal("levelsAmount")[1] == nil) then
				getVal("levelsAmount")[1] = LEVELS_AMOUNT[class]
			end
		end
		setDefaultValue("order", ORDER[getVal("base")])
		setDefaultValue("target", TARGET[getVal("base")])

		setDefaultValue("animation", "spell")
		setDefaultValue("areaRange", nil)
		setDefaultValue("areaRangeDisplay", false)
		setDefaultValue("castTime", nil)
		setDefaultValue("channelTime", nil)
		setDefaultValue("cooldown", nil)
		setDefaultValue("manaCost", nil)
		if class then
			setDefaultValue("range", 750)
		else
			setDefaultValue("range", nil)
		end
		setDefaultValue("targets", nil)

		setDefaultValue("buttonPosX", BUTTON_POS_X[class])
		setDefaultValue("buttonPosY", BUTTON_POS_Y[class])
		setDefaultValue("hotkey", HOTKEY[class])
		setDefaultValue("icon", nil)
		setDefaultValue("lore", nil)
		setDefaultValue("tooltip", nil)
		setDefaultValue("uberTooltip", nil)

		if hero then
	        	setDefaultValue("learnButtonPosX", LEARN_BUTTON_POS_X[class])
			setDefaultValue("learnButtonPosY", LEARN_BUTTON_POS_Y[class])
			setDefaultValue("learnHotkey", HOTKEY[class])
			setDefaultValue("learnIcon", getVal("icon")[1])
			setDefaultValue("learnRaw", string.sub(getVal("raw")[1], 2, 3))
			setDefaultValue("learnSlot", LEARN_SLOT[class])
			setDefaultValue("learnTooltip", nil)
			setDefaultValue("learnUberTooltip", nil)
		end
	elseif (extension == "wc3buff") then
		if (getVal("raw")[1] and (getVal("raw")[1]:len() == 3)) then
			if dummy then
				getVal("raw")[1] = "b"..getVal("raw")[1]
			else
				getVal("raw")[1] = "B"..getVal("raw")[1]
			end
		end

		setDefaultValue("class", nil)
		setDefaultValue("lostOn", nil)
		setDefaultValue("positive", nil)

		setDefaultValue("icon", nil)
		setDefaultValue("tooltip", nil)
		setDefaultValue("uberTooltip", nil)

		setDefaultValue("sfxPath", nil)
		setDefaultValue("sfxAttachPt", nil)
		setDefaultValue("sfxLevel", nil)
	elseif (extension == "wc3item") then
		if (getVal("raw")[1] and (getVal("raw")[1]:len() == 3)) then
			if dummy then
				getVal("raw")[1] = "i"..getVal("raw")[1]
			else
				getVal("raw")[1] = "I"..getVal("raw")[1]
			end
		end

		setDefaultValue("model", nil)
		setDefaultValue("scale", nil)
		setDefaultValue("vertexColorRed", nil)
		setDefaultValue("vertexColorGreen", nil)
		setDefaultValue("vertexColorBlue", nil)
		setDefaultValue("vertexColorAlpha", nil)

		setDefaultValue("description", nil)
		setDefaultValue("icon", nil)
		setDefaultValue("tooltip", nil)
		setDefaultValue("uberTooltip", nil)

		setDefaultValue("abilities", nil)
		setDefaultValue("armor", nil)
		setDefaultValue("chargesAmount", nil)
		setDefaultValue("cooldownGroup", nil)
		setDefaultValue("goldCost", nil)
		setDefaultValue("lumberCost", nil)

		setDefaultValue("usageGoldCost", nil)
	elseif (extension == "wc3unit") then
		if (getVal("raw")[1] and (getVal("raw")[1]:len() == 3)) then
			if dummy then
				if getVal("hero")[1] then
					getVal("raw")[1] = "Q"..getVal("raw")[1]
				else
					getVal("raw")[1] = "q"..getVal("raw")[1]
				end
			else
				if getVal("hero")[1] then
					getVal("raw")[1] = "U"..getVal("raw")[1]
				else
					getVal("raw")[1] = "u"..getVal("raw")[1]
				end
			end
		end

		setDefaultValue("hero", nil)
		setDefaultValue("structure", nil)
		setDefaultValue("team", nil)

		setDefaultValue("model", nil)
		setDefaultValue("modelAttachPts", nil)
		setDefaultValue("modelAnims", nil)
		setDefaultValue("modelAttachMods", nil)
		setDefaultValue("modelBones", nil)
		setDefaultValue("standardScale", nil)

		setDefaultValue("elevPts", nil)
		setDefaultValue("elevRad", nil)
		setDefaultValue("maxRoll", nil)
		setDefaultValue("maxPitch", nil)
		setDefaultValue("scale", nil)
		setDefaultValue("selScale", nil)
		setDefaultValue("vertexColorRed", nil)
		setDefaultValue("vertexColorGreen", nil)
		setDefaultValue("vertexColorBlue", nil)
		setDefaultValue("vertexColorAlpha", nil)

		setDefaultValue("impactZ", nil)
		setDefaultValue("outpactX", nil)
		setDefaultValue("outpactY", nil)
		setDefaultValue("outpactZ", nil)

		setDefaultValue("shadowPath", nil)
		setDefaultValue("shadowWidth", nil)
		setDefaultValue("shadowHeight", nil)
		setDefaultValue("shadowOffsetX", nil)
		setDefaultValue("shadowOffsetY", nil)

		setDefaultValue("attachments", nil)
		setDefaultValue("blood", nil)
		setDefaultValue("bloodExplosion", nil)
		setDefaultValue("icon", nil)
		setDefaultValue("soundset", nil)
		setDefaultValue("tooltip", nil)
		setDefaultValue("uberTooltip", nil)

		setDefaultValue("moveType", nil)
		setDefaultValue("moveSpeed", nil)
		setDefaultValue("turnRate", nil)
		setDefaultValue("height", nil)
		setDefaultValue("heightMin", nil)
		setDefaultValue("animWalk", nil)
		setDefaultValue("animRun", nil)
		setDefaultValue("moveInterp", nil)

		setDefaultValue("animBlend", nil)
		setDefaultValue("animCastWaitBefore", nil)
		setDefaultValue("animCastWaitAfter", nil)

		setDefaultValue("armorAmount", nil)
		setDefaultValue("armorSound", nil)
		setDefaultValue("armorType", nil)
		setDefaultValue("life", nil)
		setDefaultValue("lifeRegen", nil)
		setDefaultValue("mana", nil)
		setDefaultValue("manaRegen", nil)
		setDefaultValue("spellPower", nil)
		setDefaultValue("sightRange", nil)
		setDefaultValue("sightRangeNight", nil)

		setDefaultValue("attackType", nil)
		setDefaultValue("attackCooldown", nil)
		setDefaultValue("attackRange", nil)
		setDefaultValue("attackRangeAcq", nil)
		setDefaultValue("attackRangeBuffer", nil)
		setDefaultValue("attackTargetFlags", nil)
		setDefaultValue("attackWaitBefore", nil)
		setDefaultValue("attackWaitAfter", nil)
		setDefaultValue("attackSound", nil)
		setDefaultValue("attackMinRange", nil)

		setDefaultValue("attackMissileModel", nil)
		setDefaultValue("attackMissileSpeed", nil)
		setDefaultValue("attackMissileArc", nil)

		setDefaultValue("attackSplash", nil)
		setDefaultValue("attackSplashTargetFlags", nil)

		setDefaultValue("damageType", nil)
		setDefaultValue("damageAmount", 0)
		setDefaultValue("damageDices", 0)
		setDefaultValue("damageSides", 0)

		setDefaultValue("minDmg", getVal("damageAmount")[1] + getVal("damageDices")[1])
		setDefaultValue("maxDmg", getVal("damageAmount")[1] + getVal("damageDices")[1] * getVal("damageSides")[1])

		setDefaultValue("collisionSize", nil)
		setDefaultValue("combatFlags", nil)
		setDefaultValue("deathTime", nil)
		setDefaultValue("exp", nil)
		setDefaultValue("gold", nil)

		setDefaultValue("heroAbilities", nil)
		setDefaultValue("heroAttribute", nil)
		setDefaultValue("heroAgi", nil)
		setDefaultValue("heroAgiUp", nil)
		setDefaultValue("heroInt", nil)
		setDefaultValue("heroIntUp", nil)
		setDefaultValue("heroStr", nil)
		setDefaultValue("heroStrUp", nil)
		setDefaultValue("heroArmorUp", nil)
		setDefaultValue("heroNames", nil)

		setDefaultValue("structurePathTex", nil)
		setDefaultValue("structureSoldItems", nil)
		setDefaultValue("structureUbersplat", nil)
		setDefaultValue("structureUpgradeTo", nil)

		setDefaultValue("abilities", nil)
	elseif (extension == "wc3dest") then
		if (getVal("raw")[1] and (getVal("raw")[1]:len() == 3)) then
			if dummy then
				getVal("raw")[1] = "c"..getVal("raw")[1]
			else
				getVal("raw")[1] = "C"..getVal("raw")[1]
			end
		end

		setDefaultValue("model", nil)
		setDefaultValue("modelLightweight", nil)
		setDefaultValue("modelPortrait", nil)
		setDefaultValue("modelVariations", nil)

		setDefaultValue("flyHeight", nil)
		setDefaultValue("occluderHeight", nil)
		setDefaultValue("replaceableTex", nil)
		setDefaultValue("replaceableTexId", nil)
		setDefaultValue("selScale", nil)
		setDefaultValue("vertexColorRed", nil)
		setDefaultValue("vertexColorGreen", nil)
		setDefaultValue("vertexColorBlue", nil)

		setDefaultValue("elevRad", nil)
		setDefaultValue("maxRoll", nil)
		setDefaultValue("maxPitch", nil)

		setDefaultValue("minimapDisplay", nil)
		setDefaultValue("minimapRed", nil)
		setDefaultValue("minimapGreen", nil)
		setDefaultValue("minimapBlue", nil)

		setDefaultValue("deathSound", nil)
		setDefaultValue("shadow", nil)

		setDefaultValue("armor", nil)
		setDefaultValue("fatLOS", nil)
		setDefaultValue("fogRad", nil)
		setDefaultValue("fogVisibility", nil)
		setDefaultValue("life", nil)
		setDefaultValue("selectable", nil)

		setDefaultValue("pathTex", nil)
		setDefaultValue("pathTexDead", nil)
		setDefaultValue("combatFlags", nil)
		setDefaultValue("cliffLevel", nil)
		setDefaultValue("walkable", nil)
	elseif (extension == "wc3dood") then
		if (getVal("raw")[1] and (getVal("raw")[1]:len() == 3)) then
			if dummy then
				getVal("raw")[1] = "d"..getVal("raw")[1]
			else
				getVal("raw")[1] = "D"..getVal("raw")[1]
			end
		end
	end

	if (getVal("levelsAmount")[1] == nil) then
		getVal("levelsAmount")[1] = levelsAmount
	end

	--every non-defaulting field is a custom field which gets its own var in the constructed .j
	local customFields = {}

	for field, val in pairs(levelVals) do
		for level = 1, levelsAmount, 1 do
			if (val[level] == nil) then
				val[level] = val[level - 1]
			end
		end

		if (isDefaultField[field] ~= true) then
			customFields[field] = field
		end
	end

	local isTableValue = {}

	--[[for field, val in pairs(levelVals) do
		isTableValue[field] = {}

		for level = 0, levelsAmount, 1 do
			local s = getVal(field)[level]

			if (type(s) == "string") then
				if ((field == "specials") or (field == "specialsTrue")) then
					isTableValue[field][level] = true

					local c = 1
					local t = s:split(";")

					s = ""

					while t[c] do
						if t[c]:find("=") then
							local part1 = t[c]:sub(1, t[c]:find("=") - 1)
							local part2 = t[c]:sub(t[c]:find("=") + 1, t[c]:len())

							s = s..part1.."="

							if (tobool(part2) ~= nil) then
					        	elseif (((part1 ~= "iabi") and (part1 ~= "Emeu")) and isPlainText(part2)) then
						        	part2 = part2:doubleBackslashes()
						        	part2 = part2:quote()	
					        	end

							s = s..part2
						end

						c = c + 1

						if t[c] then
							s = s..";"
						end
					end

					getVal(field)[level] = s
				else
					if (field:find("tooltip") or field:find("uberTooltip")) then
						s = s:doubleBackslashes()
						s = s:quote()
					else
						local c = 1
						local t = s:split(";")

						s = ""

						while t[c] do
							if (isPlainText(t[c]) or field:find("Path", 1, true)) then
								t[c] = t[c]:doubleBackslashes()
								t[c] = t[c]:quote()	
							end

							s = s..t[c]

							c = c + 1

							if t[c] then
								s = s..";"
							end
						end

						if (c > 2) then
							isTableValue[field][level] = true
						end
					end

					getVal(field)[level] = s
				end
			end
		end
	end]]

	local t = {}

	t[0] = "raw"
	t[1] = "var"
	t[2] = "learnRaw"

	for k, v in pairs(t) do
		for level = 0, levelsAmount, 1 do
			if (getVal(v) and (type(getVal(v)[level]) == "string")) then
				getVal(v)[level] = getVal(v)[level]:dequote()
			end
		end
	end

	local function buildObjectBuilderInput()
        	local file = objBuilderFile

		if (objBuilderFirstLine == nil) then
			objBuilderFirstLine = true

			file:write([[
				require "objectBuilder"
			]])
		end

		file:write("--from "..path.."\n")

		file:write("\nlevelVals = {}")

		local function tableToString(t)
			local result

		    	for k, v in pairs(t) do
		    		if result then
	    				result = result..";"..v
	    			else
	    				result = v
		    		end
		    	end

			if (result == nil) then
				result = ""
			end

			return result
		end

		if isMod then
			local function printTable(name)
				file:write("\n"..[[levelVals[]]..name:quote()..[[] = {}]])

				local t = getVal(name)

				for level, val in pairs(t) do
					file:write("\n"..[[levelVals[]]..name:quote()..[[][]]..level..[[] = ]]..val:quote())
				end
			end

			file:write("\n"..[[levelVals["arrayFields"] = ]]..tableToString(arrayFields):quote())
			file:write("\n"..[[levelVals["customFields"] = ]]..tableToString(customFields):quote())
			printTable("name")
			printTable("raw")
			printTable("specials")
			printTable("specialsTrue")

		        file:write("\n")

		        file:write([[defObject(]]..path:doubleBackslashes():quote()..[[, ]]..extension:quote()..[[)]])

			file:write("\n--[[]]\n\n")

		        file:close()

			return
		end

		if jassIdentCol then
			file:write("\njassIdents = {}")
		end

		file:write("\n"..[[levelVals["arrayFields"] = ]]..tableToString(arrayFields):quote())
		file:write("\n"..[[levelVals["customFields"] = ]]..tableToString(customFields):quote())

		if dummy then
			file:write("\n"..[[levelVals["dummy"] = true]])
		end

		for field, val in pairs(levelVals) do
			if (jassIdentCol and vals[field] and vals[field][jassIdentCol] and (vals[field][jassIdentCol] ~= "")) then
				file:write("\njassIdents["..field:quote().."] = "..vals[field][jassIdentCol]:quote())
			elseif field:lower():find("attachPoint", 1, true) then
				file:write("\n"..[[jassIdents[]]..field:quote()..[[] = "string"]])
			end
			file:write("\nlevelVals["..field:quote().."] = {}")

			for level = 0, levelsAmount, 1 do
				local result = getVal(field)[level]

				if result then
					if (type(result) == "boolean") then
						result = boolToString(result)
					elseif (type(result) == "string") then
						--if isTableValue[field][level] then
							--result = result:gsub([["]], [[\"]])

							--result = result:quote()
						--else
							result = result:doubleBackslashes()

							if (result:len() > 1) then
								result = result:sub(1, 1)..result:sub(2, result:len() - 1):gsub([["]], [[\"]])..result:sub(result:len(), result:len())
							end

							if (result:sub(1, 1) ~= [["]] and result:sub(result:len(), result:len()) ~= [["]]) then
								result = result:quote()
							end
						--end
					end

					if result then
						file:write("\nlevelVals["..quote(field).."]["..level.."] = "..result)
					end
				end
			end
		end

	        file:write("\n")

	        file:write([[defObject(]]..path:doubleBackslashes():quote()..[[, ]]..extension:quote()..[[, ]]..refPath:doubleBackslashes():quote()..[[)]])

		file:write("\n--[[]]\n\n")

	        --file:close()
	end

	buildObjectBuilderInput()
end

function start()
	local function eraseUnfoldPackages()
		local path = [[..\Scripts\erasePacksFile.txt]]

		local eraseFile = io.open(path, "r")
	
		if eraseFile then
			for line in eraseFile:lines() do
				os.remove(line)
			end

			eraseFile:close()

			os.remove(path)
		end
	end

	eraseUnfoldPackages()

	local function unfoldPackages()
		eraseFile = io.open([[..\Scripts\erasePacksFile.txt]], "w+")
		unpackedFilePaths = {}

		for line in io.popen([[dir "..\Scripts\*.pack" /b /s]]):lines() do
			local folder = line:sub(1, lastFind(line, "\\"))

			local function searchDir(d)
				print("search in "..d)

				for source in io.popen([[dir "]]..d..[[\" /b /ad]]):lines() do
					source = d.."\\"..source

					if getFileName(source):find(".", 1, true) then
						local target = folder..getFileName(source)

						eraseFile:write("\n"..target)
						unpackedFilePaths[target] = target
--print("copy "..source.." --> "..target)
						copyDir(source, target)
					else
						searchDir(source)
					end
				end
				for source in io.popen([[dir "]]..d..[[\" /b /a-d]]):lines() do
					source = d.."\\"..source

					local target = folder..getFileName(source)

					unpackedFilePaths[target] = target

					eraseFile:write("\n"..target)
					copyFile(source, target)
				end
			end

			searchDir(line)
		end

		eraseFile:close()
	end

	--unfoldPackages()

	--update obj
	local doUpdates = true

	if doUpdates then
		objBuilderFile = io.open("ObjectBuilderInput.lua", "w+")

		for line in io.popen([[dir "..\Scripts\*.wc3*" /b /s]]):lines() do
			if (line:find("obj") == 1) then
				print("wrong extension "..line)
			else
				--if (line:find(".pack", 1, true) == nil) then
					updateFile(line)
				--end
			end
		end

		for line in io.popen([[dir "..\Tools\ObjectMorpher\Output\" /b /s]]):lines() do
			if line:find(".wc3", 1, true) then
				--updateFile(line, true)
			end
		end

		objBuilderFile:write([[
			finalize()
		]])
	
		objBuilderFile:close()
	end

	eraseUnfoldPackages()

	local f = io.open("D:\\success.txt", "w+")

	f:close()
end

start()