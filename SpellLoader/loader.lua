log = io.open("loaderLog.log", "w+")

BUTTON_POS_X = {}

BUTTON_POS_X["HERO_FIRST"] = 0
BUTTON_POS_X["HERO_SECOND"] = 1
BUTTON_POS_X["ARTIFACT"] = 2
BUTTON_POS_X["ELEMENTAL"] = 3
BUTTON_POS_X["HERO_ULTIMATE"] = 1
BUTTON_POS_X["HERO_ULTIMATE_EX"] = 2
BUTTON_POS_X["NORMAL"] = 0

BUTTON_POS_Y = {}

BUTTON_POS_Y["HERO_FIRST"] = 2
BUTTON_POS_Y["HERO_SECOND"] = 2
BUTTON_POS_Y["ARTIFACT"] = 2
BUTTON_POS_Y["ELEMENTAL"] = 2
BUTTON_POS_Y["HERO_ULTIMATE"] = 1
BUTTON_POS_Y["HERO_ULTIMATE_EX"] = 1
BUTTON_POS_Y["NORMAL"] = 2

HOTKEY = {}

HOTKEY["HERO_FIRST"] = "Q"
HOTKEY["HERO_SECOND"] = "W"
HOTKEY["ARTIFACT"] = "E"
HOTKEY["ELEMENTAL"] = "R"
HOTKEY["HERO_ULTIMATE"] = "F"
HOTKEY["HERO_ULTIMATE_EX"] = "T"
HOTKEY["NORMAL"] = "Q"

IS_HERO_SPELL = {}

IS_HERO_SPELL["HERO_FIRST"] = true
IS_HERO_SPELL["HERO_SECOND"] = true
IS_HERO_SPELL["ELEMENTAL"] = true
IS_HERO_SPELL["HERO_ULTIMATE"] = true
IS_HERO_SPELL["HERO_ULTIMATE_EX"] = true

LEARN_BUTTON_POS_X = {}

LEARN_BUTTON_POS_X["HERO_FIRST"] = 0
LEARN_BUTTON_POS_X["HERO_SECOND"] = 1
LEARN_BUTTON_POS_X["ELEMENTAL"] = 3
LEARN_BUTTON_POS_X["HERO_ULTIMATE"] = 0
LEARN_BUTTON_POS_X["HERO_ULTIMATE_EX"] = 1

LEARN_BUTTON_POS_Y = {}

LEARN_BUTTON_POS_Y["HERO_FIRST"] = 0
LEARN_BUTTON_POS_Y["HERO_SECOND"] = 0
LEARN_BUTTON_POS_Y["ELEMENTAL"] = 0
LEARN_BUTTON_POS_Y["HERO_ULTIMATE"] = 1
LEARN_BUTTON_POS_Y["HERO_ULTIMATE_EX"] = 1

LEARN_HOTKEY = {}

LEARN_HOTKEY["HERO_FIRST"] = "Q"
LEARN_HOTKEY["HERO_SECOND"] = "W"
LEARN_HOTKEY["ELEMENTAL"] = "R"
LEARN_HOTKEY["HERO_ULTIMATE"] = "F"
LEARN_HOTKEY["HERO_ULTIMATE_EX"] = "T"

LEARN_SLOT = {}

LEARN_SLOT["HERO_FIRST"] = 0
LEARN_SLOT["HERO_SECOND"] = 1
LEARN_SLOT["ELEMENTAL"] = 4
LEARN_SLOT["HERO_ULTIMATE"] = 2
LEARN_SLOT["HERO_ULTIMATE_EX"] = 3

LEVELS_AMOUNT = {}

LEVELS_AMOUNT["HERO_FIRST"] = 6
LEVELS_AMOUNT["HERO_SECOND"] = 6
LEVELS_AMOUNT["ARTIFACT"] = 6
LEVELS_AMOUNT["ELEMENTAL"] = 6
LEVELS_AMOUNT["HERO_ULTIMATE"] = 3
LEVELS_AMOUNT["HERO_ULTIMATE_EX"] = 3
LEVELS_AMOUNT["ITEM"] = 1
LEVELS_AMOUNT["NORMAL"] = 1

ORDER = {}

ORDER["NORMAL"] = "channel"
ORDER["PARALLEL_IMMEDIATE"] = "berserk"
ORDER["AUTOCAST_IMMEDIATE"] = "frenzy"

AUTOCAST_ORDER_OFF = {}
AUTOCAST_ORDER_ON = {}

AUTOCAST_ORDER_OFF["AUTOCAST_IMMEDIATE"] = 852563
AUTOCAST_ORDER_ON["AUTOCAST_IMMEDIATE"] = 852562

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
require "fileLibEx"

slkData = {}

function updateFile(path, isMod)
	local file = nil
	local fileName = getFileName(path)
	local folder = getFolder(path)

	local extension = fileName:sub(fileName:find(".wc3", 1, true) + 1)

	fileName = fileName:sub(1, fileName:find(".wc3", 1, true) - 1)

	local refPath = getRefPath(folder)..fileName

	if extension then
		refPath = refPath.."."..extension
	end

	require "wc3objLib"

	log:write("load "..fileName.." at "..folder.."\n")
	local data = wc3objLib.create(path)

	local arrayFields = data.arrayFields

	local jassIdentCol = data.jassIdentCol

	local function getVal(field, level)
		local t = data.levelVals[field]

		if (t == nil) then
			return
		end

		if level then
			if t[level] then
				return t[level]
			end

			return nil
		end

		return t
	end

	--default fields used for native object construction etc.
	local isDefaultField = {}

	local function setDefaultValue(field, val)
		isDefaultField[field] = true
		if ((data.levelVals[field] == nil) or (data.levelVals[field][1] == nil)) then
			data.levelVals[field] = {}

			data.levelVals[field][1] = val
		end
	end

	setDefaultValue("base", nil)
	setDefaultValue("classes", nil)
	setDefaultValue("field", nil)
	setDefaultValue("levelsAmount", nil)
	setDefaultValue("name", nil)
	setDefaultValue("profileIdent", nil)
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
		setDefaultValue("jassVar", fileName)

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
		setDefaultValue("order", ORDER[getVal("base", 1)])

		setDefaultValue("autoCastOrderOff", AUTOCAST_ORDER_OFF[getVal("base", 1)])
		setDefaultValue("autoCastOrderOn", AUTOCAST_ORDER_ON[getVal("base", 1)])
		setDefaultValue("target", TARGET[getVal("base", 1)])

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
		if (getVal("base", 1) == "PASSIVE") then
			setDefaultValue("hotkey", nil)
		else
			setDefaultValue("hotkey", HOTKEY[class])
		end
		setDefaultValue("icon", nil)
		if (getVal("base", 1) == "AUTOCAST_IMMEDIATE") then
			setDefaultValue("iconDisabled", getVal("icon", 1))
		end
		setDefaultValue("lore", nil)
		setDefaultValue("tooltip", nil)
		setDefaultValue("uberTooltip", nil)

		--if hero then
	        	setDefaultValue("learnButtonPosX", LEARN_BUTTON_POS_X[class])
			setDefaultValue("learnButtonPosY", LEARN_BUTTON_POS_Y[class])
			setDefaultValue("learnHotkey", HOTKEY[class])
			setDefaultValue("learnIcon", getVal("icon")[1])

			local raw = getVal("raw", 1)
			local learnRaw

			if raw then
				--learnRaw = raw:sub(2, 3)
			end

			setDefaultValue("learnRaw", learnRaw)
			setDefaultValue("learnSlot", LEARN_SLOT[class])
			setDefaultValue("learnTooltip", nil)
			setDefaultValue("learnUberTooltip", nil)
			setDefaultValue("learnUberTooltipUpgrades", nil)
		--end

		setDefaultValue("sourceRaw", nil)
		setDefaultValue("targetRaw", nil)
	elseif (extension == "wc3buff") then
		setDefaultValue("jassVar", fileName)

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

		setDefaultValue("sfxSound", nil)
		setDefaultValue("sfxSoundLoop", nil)

		setDefaultValue("unitMod", nil)
		setDefaultValue("unitModVal", nil)
	elseif (extension == "wc3item") then
		setDefaultValue("jassVar", fileName)

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
		setDefaultValue("jassVar", fileName)

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
		setDefaultValue("jassVar", fileName)

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
		setDefaultValue("jassVar", fileName)

		if (getVal("raw")[1] and (getVal("raw")[1]:len() == 3)) then
			if dummy then
				getVal("raw")[1] = "d"..getVal("raw")[1]
			else
				getVal("raw")[1] = "D"..getVal("raw")[1]
			end
		end
	elseif (extension == "wc3imp") then
		setDefaultValue("src", nil)
		setDefaultValue("target", nil)
		setDefaultValue("type", nil)

		local valType = getVal("type", 1)

		if (valType == "icon") then
			setDefaultValue("iconDisabledSrc", nil)
			setDefaultValue("iconDisabledTarget", nil)

			local src = getVal("src", 1)

			if ((getVal("target", 1) == nil) and src) then
				getVal("target")[1] = [[ReplaceableTextures\CommandButtons\]]..src
			end

			local disabledSrc = getVal("iconDisabledSrc", 1)

			if ((getVal("iconDisabledTarget", 1) == nil) and src and disabledSrc) then
				getVal("iconDisabledTarget")[1] = [[ReplaceableTextures\CommandButtonsDisabled\DIS]]..src
			end
		else
			local src = getVal("src", 1)

			if ((getVal("target", 1) == nil) and src) then
				getVal("target")[1] = getFolder(refPath):gsub("%.", "_")..src
			end
		end
	elseif (extension == "wc3bolt") then
		setDefaultValue("jassVar", fileName)

		if (getVal("raw")[1] and (getVal("raw")[1]:len() == 3)) then
			if dummy then
				getVal("raw")[1] = "o"..getVal("raw")[1]
			else
				getVal("raw")[1] = "O"..getVal("raw")[1]
			end
		end

		setDefaultValue("texPath", nil)
		setDefaultValue("avgSegLen", nil)
		setDefaultValue("width", nil)
		setDefaultValue("red", nil)
		setDefaultValue("green", nil)
		setDefaultValue("blue", nil)
		setDefaultValue("alpha", nil)
		setDefaultValue("noiseScale", nil)
		setDefaultValue("texCoordScale", nil)
		setDefaultValue("duration", nil)
	elseif (extension == "wc3weather") then
		setDefaultValue("jassVar", fileName)

		if (getVal("raw")[1] and (getVal("raw")[1]:len() == 3)) then
			if dummy then
				getVal("raw")[1] = "w"..getVal("raw")[1]
			else
				getVal("raw")[1] = "W"..getVal("raw")[1]
			end
		end

		setDefaultValue("texPath", nil)
		setDefaultValue("alphaMode", nil)
		setDefaultValue("useFog", nil)
		setDefaultValue("height", nil)
		setDefaultValue("angleX", nil)
		setDefaultValue("angleY", nil)
		setDefaultValue("emissionRate", nil)
		setDefaultValue("lifespan", nil)
		setDefaultValue("particles", nil)
		setDefaultValue("speed", nil)
		setDefaultValue("accel", nil)
		setDefaultValue("variance", nil)
		setDefaultValue("texR", nil)
		setDefaultValue("texC", nil)
		setDefaultValue("head", nil)
		setDefaultValue("tail", nil)
		setDefaultValue("tailLength", nil)
		setDefaultValue("latitude", nil)
		setDefaultValue("longitude", nil)
		setDefaultValue("midTime", nil)
		setDefaultValue("sound", nil)

		setDefaultValue("redStart", nil)
		setDefaultValue("greenStart", nil)
		setDefaultValue("blueStart", nil)
		setDefaultValue("alphaStart", nil)

		setDefaultValue("redMid", nil)
		setDefaultValue("greenMid", nil)
		setDefaultValue("blueMid", nil)
		setDefaultValue("alphaMid", nil)

		setDefaultValue("redEnd", nil)
		setDefaultValue("greenEnd", nil)
		setDefaultValue("blueEnd", nil)
		setDefaultValue("alphaEnd", nil)

		setDefaultValue("scaleStart", nil)
		setDefaultValue("scaleMid", nil)
		setDefaultValue("scaleEnd", nil)

		setDefaultValue("hUVStart", nil)
		setDefaultValue("hUVMid", nil)
		setDefaultValue("hUVEnd", nil)

		setDefaultValue("tUVStart", nil)
		setDefaultValue("tUVMid", nil)
		setDefaultValue("tUVEnd", nil)
	elseif (extension == "wc3ubersplat") then
		setDefaultValue("jassVar", fileName)

		if (getVal("raw")[1] and (getVal("raw")[1]:len() == 3)) then
			if dummy then
				getVal("raw")[1] = "P"..getVal("raw")[1]
			else
				getVal("raw")[1] = "p"..getVal("raw")[1]
			end
		end

		setDefaultValue("texPath", nil)
		setDefaultValue("blendMode", nil)
		setDefaultValue("scale", nil)
		setDefaultValue("birthTime", nil)
		setDefaultValue("pauseTime", nil)
		setDefaultValue("decay", nil)

		setDefaultValue("redStart", nil)
		setDefaultValue("greenStart", nil)
		setDefaultValue("blueStart", nil)
		setDefaultValue("alphaStart", nil)

		setDefaultValue("redMid", nil)
		setDefaultValue("greenMid", nil)
		setDefaultValue("blueMid", nil)
		setDefaultValue("alphaMid", nil)

		setDefaultValue("redEnd", nil)
		setDefaultValue("greenEnd", nil)
		setDefaultValue("blueEnd", nil)
		setDefaultValue("alphaEnd", nil)

		setDefaultValue("sound", nil)
	elseif (extension == "wc3tile") then
		setDefaultValue("jassVar", fileName)

		if (getVal("raw")[1] and (getVal("raw")[1]:len() == 3)) then
			if dummy then
				getVal("raw")[1] = "T"..getVal("raw")[1]
			else
				getVal("raw")[1] = "t"..getVal("raw")[1]
			end
		end

		setDefaultValue("texPath", nil)
		setDefaultValue("cliffSet", nil)

		setDefaultValue("walkable", nil)
		setDefaultValue("flyable", nil)
		setDefaultValue("buildable", nil)

		setDefaultValue("footprints", nil)
		setDefaultValue("blightPriority", nil)
	elseif (extension == "wc3sound") then
		setDefaultValue("jassVar", fileName)

		if (getVal("raw")[1] and (getVal("raw")[1]:len() == 3)) then
			if dummy then
				getVal("raw")[1] = "S"..getVal("raw")[1]
			else
				getVal("raw")[1] = "s"..getVal("raw")[1]
			end
		end

		setDefaultValue("filePath", nil)

		setDefaultValue("channel", nil)
		setDefaultValue("eax", nil)
		setDefaultValue("pitch", nil)
		setDefaultValue("pitchVariance", nil)
		setDefaultValue("priority", nil)
		setDefaultValue("volume", nil)

		setDefaultValue("fadeInRate", nil)
		setDefaultValue("fadeOutRate", nil)
		setDefaultValue("looping", nil)
		setDefaultValue("stopping", nil)

		setDefaultValue("is3d", nil)
		setDefaultValue("minDist", 0)
		setDefaultValue("maxDist", 100000)
		setDefaultValue("cutoffDist", 100000)

		setDefaultValue("insideAngle", nil)
		setDefaultValue("outsideAngle", nil)
		setDefaultValue("outsideVolume", nil)
		setDefaultValue("orientationX", nil)
		setDefaultValue("orientationY", nil)
		setDefaultValue("orientationZ", nil)
	end

	if (getVal("levelsAmount")[1] == nil) then
		getVal("levelsAmount")[1] = data.levelsAmount
	end

	--every non-defaulting field is a custom field which gets its own var in the constructed .j
	local customFields = {}

	for field, val in pairs(data.levelVals) do
		for level = 1, data.levelsAmount, 1 do
			if (type(val[level - 1]) ~= nil) then
				if ((type(val[level]) == "string") and (type(val[level - 1]) == "string")) then
					local t = val[level]:split(";")

					for c in pairs(t) do
						if ((t[c] == nil) or (t[c] == "")) then
							t[c] = val[level - 1]:split(";")[c]
						end

						c = c + 1
					end

					val[level] = table.concat(t, ";")
				else
					if (val[level] == nil) then
						val[level] = val[level - 1]
					end
				end
			end
		end

		if (isDefaultField[field] ~= true) then
			customFields[field] = field
		end
	end

	local isTableValue = {}

	--[[for field, val in pairs(data.levelVals) do
		isTableValue[field] = {}

		for level = 0, data.levelsAmount, 1 do
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
	t[3] = "jassVar"

	for k, v in pairs(t) do
		for level = 0, data.levelsAmount, 1 do
			if (getVal(v) and (type(getVal(v)[level]) == "string")) then
				getVal(v)[level] = getVal(v)[level]:dequote()
			end
		end
	end

	local function buildObjectBuilderInput()
        	local file = objBuilderFile

		if (objBuilderFirstLine == nil) then
			objBuilderFirstLine = true
		end

		file:write("--from "..path.."\n")

		file:write("\nlevelVals = {}")

--		if jassIdentCol then
			file:write("\njassIdents = {}")
--		end

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

		        file:write([[defObject(]]..path:doubleBackslashes():quote()..[[, ]]..extension:quote()..[[, levelVals, jassIdents)]])

			file:write("\n--[[]]\n\n")

		        file:close()

			return
		end

		file:write("\n"..[[levelVals["arrayFields"] = ]]..tableToString(arrayFields):quote())
		file:write("\n"..[[levelVals["customFields"] = ]]..tableToString(customFields):quote())

		if dummy then
			file:write("\n"..[[levelVals["dummy"] = true]])
		end

		for field, val in pairs(data.levelVals) do
			if (jassIdentCol and data.vals[field] and data.vals[field][jassIdentCol] and (data.vals[field][jassIdentCol] ~= "")) then
				file:write("\njassIdents["..field:quote().."] = "..data.vals[field][jassIdentCol]:quote())
			elseif field:lower():find("attachPoint", 1, true) then
				file:write("\n"..[[jassIdents[]]..field:quote()..[[] = "string"]])
			elseif field:lower():find("effectlevel", 1, true) then
				file:write("\n"..[[jassIdents[]]..field:quote()..[[] = "integer"]])
			end
			file:write("\nlevelVals["..field:quote().."] = {}")

			for level = 0, data.levelsAmount, 1 do
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

	        file:write([[defObject(]]..path:doubleBackslashes():quote()..[[, ]]..extension:quote()..[[, ]]..refPath:doubleBackslashes():quote()..[[, levelVals, jassIdents)]])

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

		local function addExtension(val)
			local files = getFiles("..\\Scripts", "*."..val)

			for _, line in pairs(files) do
				if (line:find("obj") == 1) then
					print("wrong extension "..line)
				else
					--if (line:find(".pack", 1, true) == nil) then
						updateFile(line)
					--end
				end
			end
		end

		addExtension("wc3spell")
		addExtension("wc3buff")
		addExtension("wc3item")
		addExtension("wc3unit")
		addExtension("wc3dest")
		addExtension("wc3dood")
		addExtension("wc3upgr")
		addExtension("wc3obj")
		addExtension("wc3skin")
		addExtension("wc3imp")
		addExtension("wc3bolt")
		addExtension("wc3weather")
		addExtension("wc3ubersplat")
		addExtension("wc3tile")
		addExtension("wc3sound")

		for line in io.popen([[dir "..\Tools\ObjectMorpher\Output\" /b /s]]):lines() do
			if line:find(".wc3", 1, true) then
				--updateFile(line, true)
			end
		end

		local files = getFiles("..\\Scripts", "*.wc3objLua")

		for _, line in pairs(files) do
			objBuilderFile:write("\n")
			objBuilderFile:write("--from "..line.."\n")
			objBuilderFile:write([[local f = loadfile(]]..string.format("%q", line)..[[)]])
			objBuilderFile:write([[f(]]..string.format("%q", line)..[[)]])
			objBuilderFile:write("\n")
		end

		objBuilderFile:close()
	end

	eraseUnfoldPackages()

	local f = io.open("D:\\success.txt", "w+")

	f:close()
end

start()

log:close()