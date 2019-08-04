local params = {...}

local rootPath = params[1]
local buildPath = params[2]
local input = "ObjectBuilderInput.lua"

print("objectBuilder:", "rootPath=", rootPath, "buildPath=", buildPath)

local clock = os.clock()

OUTPUT_PATH = [[GeneratedImports]]
local logFile = io.open("objectBuilderLog.log", "w+")
local log = {}

log.write = function(self, val)
	if (type(val) ~= "table") then
		logFile:write("\n"..val)
	end
end

--math.log10 = function(x)
--	return math.log(x, 10)
--end

require "mathEx"
require "slkLib"
require "stringLib"
require "tableLib"

require "fileLibEx"

function nilTo0(val)
	if (val == nil) then
		return 0
	end

	return val
end

function nilToString(val, inval)
	if (val == nil) then
		return inval
	end

	return val
end

os.execute([[del ]]..(OUTPUT_PATH:quote()..[[\*]]):quote()..[[ /q]])
os.execute([[rd ]]..OUTPUT_PATH:quote()..[[ /s /q]])
os.execute([[mkdir ]]..OUTPUT_PATH:quote())

objType = {}

function createObjType(name, exFilePath, exFileVersion, usesLevels)
	self = {}

	objType[name] = self

	self.name = name

	self.slks = {}

	if exFilePath then
		self.ex = {}

		self.ex.file = io.open(OUTPUT_PATH..[[\]]..exFilePath, "w+b")
		self.ex.fileVersion = exFileVersion
		self.ex.origObjs = {}
		self.ex.customObjs = {}
		self.ex.usesLevels = usesLevels
	end
end

createObjType("units", "war3map.w3u", 2)
createObjType("items", "war3map.w3t", 2)
createObjType("destructables", "war3map.w3b", 2)
createObjType("doodads", "war3map.w3d", 2, true)
createObjType("abilities", "war3map.w3a", 2, true)
createObjType("buffs", "war3map.w3h", 2)
createObjType("upgrades", "war3map.w3q", 2, true)

createObjType("lightnings", nil, nil)
createObjType("weathers", nil, nil)
createObjType("ubersplats", nil, nil)
createObjType("tiles", nil, nil)
createObjType("sounds", nil, nil)

local metaData = {}
local metaSlks = {}

function addMetaData(objType, metaPath)
	metaPath = [[MetaData\]]..metaPath

	if metaSlks[metaPath] then
		metaData[objType] = metaSlks[metaPath].objs
	else
		metaSlks[metaPath] = readSlk(metaPath)

		metaData[objType] = metaSlks[metaPath].objs
	end
end

addMetaData("abilities", "AbilityMetaData")
addMetaData("buffs", "AbilityBuffMetaData")
addMetaData("items", "UnitMetaData")
addMetaData("destructables", "DestructableMetaData")
addMetaData("units", "UnitMetaData")
addMetaData("doodads", "DoodadMetaData")
addMetaData("upgrades", "UpgradeMetaData")

local slkByName = {}
local slks = {}

function createObjSlk(name, folder)
	local slk = createSlk()

	slk.path = OUTPUT_PATH..[[\]]..folder..name

	slks[slk] = slk
	slkByName[name] = slk

	return slk
end

objTypeSlks = {}
objTypeSlksRawField = {}

function addObjTypeSlk(type, slk, rawField)
	local folder = ""

	while slk:find([[\]]) do
		folder = folder..slk:sub(1, slk:find([[\]]))

		slk = slk:sub(slk:find([[\]]) + 1, slk:len())
	end

	local slkName = slk

	if slkByName[slk] then
		slk = slkByName[slk]
	else
		slk = createObjSlk(slk, folder)
	end

	slk.headerData = readSlk([[HeaderData\]]..slkName, true)

	if rawField then
		slk.pivotField = rawField
		slkAddField(slk, rawField, rawField)
	end

	type = objType[type]

	type.slks[#type.slks + 1] = slk
end

addObjTypeSlk("abilities", [[Units\AbilityData]], "alias")
addObjTypeSlk("buffs", [[Units\AbilityBuffData]], "alias")
addObjTypeSlk("items", [[Units\ItemData]], "itemID")
addObjTypeSlk("units", [[Units\UnitData]], "unitID")
addObjTypeSlk("units", [[Units\UnitAbilities]], "unitAbilID")
addObjTypeSlk("units", [[Units\UnitBalance]], "unitBalanceID")
addObjTypeSlk("units", [[Units\UnitUI]], "unitUIID")
addObjTypeSlk("units", [[Units\UnitWeapons]], "unitWeapID")
addObjTypeSlk("destructables", [[Units\DestructableData]], "DestructableID")
addObjTypeSlk("doodads", [[Doodads\Doodads]], "doodID")
addObjTypeSlk("upgrades", [[Units\UpgradeData]], "upgradeid")

addObjTypeSlk("lightnings", [[Splats\LightningData]], "Name")
addObjTypeSlk("weathers", [[TerrainArt\Weather]], "effectID")
addObjTypeSlk("ubersplats", [[Splats\UberSplatData]], "Name")
addObjTypeSlk("tiles", [[TerrainArt\Terrain]], "tileID")
addObjTypeSlk("sounds", [[UI\SoundInfo\AbilitySounds]], "SoundName")

for slk, slkData in pairs(slks) do
	for field in pairs(slkData.headerData.fields) do
		slkAddField(slk, field)
	end
end

local dataMap = {}

dataMap[1] = "A"
dataMap[2] = "B"
dataMap[3] = "C"
dataMap[4] = "D"
dataMap[5] = "E"
dataMap[6] = "F"
dataMap[7] = "G"
dataMap[8] = "H"
dataMap[9] = "I"

for slk, slkData in pairs(metaSlks) do
	for obj, objData in pairs(slkData.objs) do
		local vals = objData.vals

		if (vals["slk"] == "DoodadData") then
			vals["slk"] = "Doodads"
		end

		local slk = vals["slk"]

		if (slk ~= "Profile") then
			if slkByName[slk] then
				slk = slkByName[slk]
			else
				print("missing slk "..slk)

				slk = createObjSlk(slk, "")
			end

			if (vals["field"] == "Data") then
				vals["field"] = vals["field"]..dataMap[vals["data"]]
			end

			if (vals["repeat"] and (vals["repeat"] > 0)) then
				for level = 1, vals["repeat"], 1 do
					slkAddField(slk, vals["field"]..string.rep("0", math.floor(math.log10(vals["repeat"])) - math.floor(math.log10(level)))..level)
				end
			else
				slkAddField(slk, vals["field"])
			end
		end
	end
end

function addSlkStaticField(slkName, field, defVal)
	local slk = slkByName[slkName]

	slkAddField(slk, field, defVal)
end

--addSlkStaticField("AbilityData", "checkDep", 1)
addSlkStaticField("AbilityData", "code", "")
addSlkStaticField("AbilityData", "sort", "unit")
addSlkStaticField("AbilityData", "useInEditor", 1)
addSlkStaticField("AbilityData", "version", 1)
addSlkStaticField("AbilityBuffData", "code", "")
addSlkStaticField("AbilityBuffData", "sort", "unit")
addSlkStaticField("AbilityBuffData", "useInEditor", 1)
addSlkStaticField("AbilityBuffData", "version", 1)
addSlkStaticField("ItemData", "version", 1)
addSlkStaticField("UnitAbilities", "auto", "_")  --prevent crash
addSlkStaticField("UnitBalance", "Primary", "_")  --prevent crash
addSlkStaticField("UnitData", "valid", 1)
addSlkStaticField("UnitData", "version", 1)
addSlkStaticField("UnitUI", "hiddenInEditor", 0)
addSlkStaticField("UnitUI", "unitClass", nil)
--addSlkStaticField("UnitUI", "sortUI", "a1")
--addSlkStaticField("UnitUI", "valid", 1)
--addSlkStaticField("UnitUI", "version", 1)
--addSlkStaticField("UnitWeapons", "sort2", "zz")
addSlkStaticField("DestructableData", "category", "D")
addSlkStaticField("DestructableData", "doodClass", "_")
addSlkStaticField("DestructableData", "fixedRot", "-1")
addSlkStaticField("DestructableData", "maxScale", "10")
addSlkStaticField("DestructableData", "version", 1)
addSlkStaticField("Doodads", "category", "E")
addSlkStaticField("Doodads", "defScale", "1")
addSlkStaticField("Doodads", "doodClass", "_")
addSlkStaticField("Doodads", "maxScale", "10")
addSlkStaticField("Doodads", "minScale", "0.1")
addSlkStaticField("Doodads", "tilesets", "*")
addSlkStaticField("Doodads", "UserList", 1)
addSlkStaticField("Doodads", "version", 1)
addSlkStaticField("UpgradeData", "sort", "_")
addSlkStaticField("UpgradeData", "used", 1)
addSlkStaticField("UpgradeData", "version", 0)

addSlkStaticField("LightningData", "version", 0)
addSlkStaticField("Weather", "AmbientSound", "-")
addSlkStaticField("Weather", "name", "lalala")
addSlkStaticField("Weather", "version", 0)
addSlkStaticField("AbilitySounds", "version", 1)
addSlkStaticField("AbilitySounds", "InBeta", 1)

function makechangeTrue(obj, field, level, val)
	obj.valsTrue[field] = val
end

function setTrue(field, val, default)
	if (val == nil) then
		makechangeTrue(curObj, field, nil, default)
	else
		makechangeTrue(curObj, field, nil, val)
	end
end

function headerDataContainsField(type, field, level)
	fieldData = metaData[type][field].vals

	if (fieldData["slk"] == "Profile") then
		return true
	end

	field = fieldData["field"]

	if level then
		field = field..string.rep("0", math.floor(math.log10(fieldData["repeat"])) - math.floor(math.log10(level)))..level
	end

	for _, slk in pairs(objType[type].slks) do
		if slk.headerData.fields[field] then
			return true
		end
	end

	return false
end

function makechange(obj, field, level, val)
	if (val == "\0") then
		val = 0
	elseif (val == "\1") then
		val = 1
	elseif (val == string.char(3)) then
		val = 3
	end

	if ((val == nil) and obj.vals[field]) then
		if level then
			if obj.vals[field][level] then
				return
			end
		else
			if obj.vals[field] then
				return
			end
		end
	end

	if level then
		if (obj.vals[field] == nil) then
			obj.vals[field] = {}
		end

		obj.vals[field][level] = val
	else
		obj.vals[field] = val
	end

	if (headerDataContainsField(obj.type, field, level) ~= true) then
		obj.requiresMods = true
	end
end

function set(field, value, default)
	if (value == nil) then
	    makechange(curObj, field, nil, default)
	else
	    makechange(curObj, field, nil, value)
	end
end

function setLv(field, level, value, default)
	if dummy then
		default = nil
	end

	if (value == nil) then
	    makechange(curObj, field, level, default)
	else
	    makechange(curObj, field, level, value)
	end
end

createdObjs = {}
objByRaw = {}

function createObj(raw, baseRaw, profileIdent, path)
	if (profileIdent == nil) then
		profileIdent = raw
	end

	local self = {}

	self.baseRaw = baseRaw
	self.path = path
	self.profileIdent = profileIdent
	self.raw = raw
	self.type = curObjType

	curObj = self
	if (self.vals == nil) then
		self.vals = {}
		self.valsTrue = {}
	end

	createdObjs[self] = self
	if raw then
		if objByRaw[raw] then
			log:write(path..": raw "..raw.." already declared at "..objByRaw[raw].path)
		end

		objByRaw[raw] = self
	end

	return self
end

function setObjType(val)
	curObjType = val
end

setObjType("abilities")

INVENTORY_SPELL_PATH = [[Header\Unit.page\Unit.struct\heroInventorySpell]]
LOCUST_SPELL_PATH = [[Header\Misc.page\DummyUnit.struct\locustSpell]]

allObjExtension = {}
allObjJassIdents = {}
allObjVals = {}

allObjsByName = {}

function getObjByName(extension, name)
	local result

	if allObjsByName[extension] then
		result = allObjsByName[extension][name]
	end

	if (result == nil) then
		for k, v in pairs(allObjsByName) do
			if allObjsByName[k][name] then
				result = allObjsByName[k][name]
			end
		end
	end

	if result then
		return result
	end

	log:write("getObjByName: obj "..name.." does not exist")

	return nil
end

function getVal(field, level)
	local t = levelVals[field]

	if level then
		if (type(t) ~= "table") then
			return t
		end

		return t[level]
	end

	return t
end

function reduceName(name)
	name = name:lower()
	name = name:gsub(" ", "")
	name = name:gsub("-", "")
	name = name:gsub("'", "")

	return name
end

pathMap = {}

function pathToFullPath(base, value, mainExtension)
	value = value:dequote()

	local name = value

	if ((value:find(".wc3", 1, true) == nil) and mainExtension) then
		value = value.."."..mainExtension
	end

	if pathMap[value] then
		return pathMap[value]
	end

	local result

	if base then
		result = getRefPath(getFolder(base))..value

		if pathMap[result] then
			return pathMap[result]
		end
	end

	result = [[D:\Warcraft III\Mapping\DWC\Scripts\]]..value

	if pathMap[result] then
		return pathMap[result]
	end

	result = getObjByName(mainExtension, reduceName(name))

	if pathMap[result] then
		return pathMap[result]
	end

	return nil
end

function getObjVal(obj, field, level)
	--obj = pathToFullPath(nil, obj)

	if (allObjVals[obj] == nil) then
		log:write("getObjVal: obj "..obj:quote().." does not exist")

		return nil
	end

	local t = allObjVals[obj][field]

	if level then
		if (type(t) ~= "table") then
			return t
		end

		return t[level]
	end

	return t
end

function getObjFromPath(path)
	--path = pathToFullPath(nil, path)

	if (allObjVals[path] == nil) then
		log:write("getObjVal: obj "..path:quote().." does not exist")

		return nil
	end

	return allObjVals[path]
end

function objPathsToRaw(basePath, t, mainExtension)
	local val

	for k, v in pairs(t) do
		v = pathToFullPath(basePath, v, mainExtension)
		if val then
			val = val..","..getObjVal(v, "raw")[1]
		else
			val = getObjVal(v, "raw")[1]
		end
	end

	return val
end

function doSpecials(obj)
	local specialsTrue = getVal("specialsTrue")

	if specialsTrue then
		for level, v in pairs(specialsTrue) do
			for field, val in pairs(v) do
				makechangeTrue(obj, field, nil, val)
			end
		end
	end

	local specials = getVal("specials")

	if specials then
		for level, v in pairs(specials) do
			for field, val in pairs(v) do
				if (metaData[obj.type][field].vals["repeat"] and (metaData[obj.type][field].vals["repeat"] > 0)) then
					setLv(field, level, val)
				else
					set(field, val)
				end
			end
		end
	end
end

--wc3spell
HIDE_PLACEHOLDER_PREFIX = "LP"
HIDE_REPLACER_PREFIX = "LR"

function getHidePlaceholderRaw(learnRaw)
	return HIDE_PLACEHOLDER_PREFIX..learnRaw
end

function getHideReplacerRaw(learnRaw)
	return HIDE_REPLACER_PREFIX..learnRaw
end

LEARN_PREFIX = {}

LEARN_PREFIX[0] = "F"
LEARN_PREFIX[1] = "G"
LEARN_PREFIX[2] = "H"
LEARN_PREFIX[3] = "J"
LEARN_PREFIX[4] = "K"

LEARN_REPLACER_PREFIX = {}

LEARN_REPLACER_PREFIX[0] = "V"
LEARN_REPLACER_PREFIX[1] = "W"
LEARN_REPLACER_PREFIX[2] = "X"
LEARN_REPLACER_PREFIX[3] = "Y"
LEARN_REPLACER_PREFIX[4] = "Z"

function createSpell(path)
	local base = getVal("base", 1)
	local channelBased
	local class = getVal("class", 1)
	local hero = getVal("hero", 1)
	
	setObjType("abilities")

	local obj = createObj(raw, nil, getVal("profileIdent", 1), path)

	local baseCode

	if (base == "NORMAL") then
		baseCode = "ANcl"
		channelBased = true
	elseif (base == "PARALLEL_IMMEDIATE") then
		baseCode = "Absk"
	elseif (base == "PASSIVE") then
		baseCode = "Agyb"
	elseif (base == "AUTOCAST_IMMEDIATE") then
		baseCode = "Afzy"
	elseif (string.sub(base, 1, 1 + 7 - 1) == "SPECIAL") then
		baseCode = string.sub(base, 1 + 7 + 1, string.len(base))
	end

	setTrue("code", baseCode)

	set("acap", "")
	set("acat", "")
	set("aeat", "")
	--set("aher", "\0")
	setTrue("hero", 0)
	set("ahky", "")
	if (class == "ITEM") then
		set("aite", 1)
	end
	set("anam", getVal("name", 1), "defaultName(spell) "..nilToString(raw, "NONE"))
	set("areq", "")
	set("ata0", "")
	set("atat", "")

	set("aani", getVal("animation", 1), "")
	set("aart", getVal("icon", 1), "")
	set("auar", getVal("iconDisabled", 1), nil)
	set("abpx", getVal("buttonPosX", 1), 0)
	set("abpy", getVal("buttonPosY", 1), 0)
	set("ahky", getVal("hotkey", 1), "")
	set("alev", levelsAmount)

	for level = 1, levelsAmount, 1 do
		if ((base == "PARALLEL_IMMEDIATE") or (base == "AUTOCAST_IMMEDIATE")) then
			setLv("abuf", level, getObjVal(pathToFullPath(path, [[Header\Spell.page\Spell.struct\parallelCastBuff]], "wc3buff"), "raw")[1], "")
		end
		if ((channelBased ~= true) or getVal("areaRangeDisplay", level)) then
			setLv("aare", level, getVal("areaRange", level), 0)
		end
		setLv("acas", level, getVal("castTime", level), 0)
		setLv("acdn", level, getVal("cooldown", level), 0)
		setLv("amcs", level, getVal("manaCost", level), 0)
		setLv("aran", level, getVal("range", level), 0)
		setLv("atar", level, getVal("targets", level), "")
		setLv("atp1", level, getVal("tooltip", level), "")
		setLv("aub1", level, getVal("uberTooltip", level), "")
	end

	doSpecials(obj)

	if channelBased then	
		for level = 1, levelsAmount, 1 do
			local target = getVal("target", level)

			setLv("Ncl1", level, 0)
			if (target == "IMMEDIATE") then
				setLv("Ncl2", level, 0)
			elseif (target == "POINT") then
				setLv("Ncl2", level, 2)
			elseif (target == "POINT_OR_UNIT") then
				setLv("Ncl2", level, 3)
			elseif (target == "UNIT") then
				setLv("Ncl2", level, 1)
			end
			if getVal("areaRangeDisplay", level) then
				setLv("Ncl3", level, 19)
			else
				setLv("Ncl3", level, 17)
			end
			setLv("Ncl4", level, 0)
			setLv("Ncl5", level, "\0")
			setLv("Ncl6", level, getVal("order", level), "")
		end
	end

	if hero then
		local learnRaw = getVal("learnRaw", 1)
		local learnSlot = getVal("learnSlot", 1)

		if (learnRaw and learnSlot) then
			local index = learnSlot
			local learnPrefix = LEARN_PREFIX[learnSlot]

			local hidePlaceholderRaw = getHidePlaceholderRaw(learnRaw)
			local hideReplacerRaw = getHideReplacerRaw(learnRaw)

			createObj(hidePlaceholderRaw, nil, nil, path)

			setTrue("code", "Agyb")

			createObj(hideReplacerRaw, nil, nil, path)

			setTrue("code", "ANeg")

			set("abpx", 0)
			set("abpy", 0)
			set("aher", "\0")
			set("ahky", "")
			set("alev", 1)
			set("anam", getVal("name", 1).." Hero Spell Replacer Hider")
			set("arac", "other")
			set("aret", "")
			set("arhk", "")
			set("arpx", 0)
			set("arut", "")

			setLv("abuf", 1, getObjVal(pathToFullPath(path, [[Header\Spell.page\HeroSpell.struct\spellReplacerBuff]], "wc3buff"), "raw")[1])
			setLv("atp1", 1, "")
			setLv("aub1", 1, "")
			setLv("Neg1", 1, 0)
			setLv("Neg2", 1, 0)
			setLv("Neg3", 1, raw..","..hidePlaceholderRaw)
			setLv("Neg4", 1, "")
			setLv("Neg5", 1, "")
			setLv("Neg6", 1, "")

			createObj("V"..learnRaw..index, nil, nil, path)

			setTrue("code", "ANeg")

			set("abpx", 0)
			set("abpy", 0)
			set("aher", "\1")
			set("ahky", "")
			set("alev", levelsAmount)
			set("anam", getVal("name", 1).." Hero Spell Replacer "..index)
			set("arac", "other")
			set("aret", "")
			set("arhk", "")
			set("arpx", 0)
			set("arut", "")

			for level = 1, levelsAmount, 1 do
				setLv("abuf", level, getObjVal(pathToFullPath(path, [[Header\Spell.page\HeroSpell.struct\spellReplacerBuff]], "wc3buff"), "raw")[1])
				setLv("atp1", level, "")
				setLv("aub1", level, "")
				setLv("Neg1", level, 0)
				setLv("Neg2", level, 0)
				if (level == 1) then
					setLv("Neg3", level, "AHS"..index..","..learnPrefix..learnRaw..(level - 1))
				else
					--setLv("Neg3", level, "AHS"..index..","..learnPrefix..learnRaw..(level - 1))
					setLv("Neg3", level, learnPrefix..learnRaw..(level - 2)..","..learnPrefix..learnRaw..(level - 1))
				end
				setLv("Neg4", level, "")
				setLv("Neg5", level, "")
				setLv("Neg6", level, "")
			end

			for level = 1, levelsAmount, 1 do
				createObj(learnPrefix..learnRaw..(level - 1), nil, nil, path)

				setTrue("code", "ANcl")

				set("aani", "")
				set("aart", "")
				set("abpx", 0)
				set("acap", "")
				set("acat", "")
				set("aeat", "")
				set("aher", "\1")
				set("ahky", "")
				set("alev", 1)
				set("anam", getVal("name", 1).." Hero Spell Learner "..learnSlot.." Level "..level)
				set("arac", "other")

				setLv("aran", 1, 0)
				set("arar", getVal("icon", level), "")
				set("ata0", "")
				set("atat", "")
				setLv("atp1", 1, "")
				setLv("aub1", 1, "")
				setLv("Ncl1", 1, 0)
				setLv("Ncl3", 1, 0)
				setLv("Ncl4", 1, 0)
				setLv("Ncl5", 1, "\0")
				setLv("Ncl6", 1, "wispharvest")

				set("aret", getVal("learnTooltip", level))
				set("arhk", getVal("learnHotkey", 1))
				set("arpx", getVal("learnButtonPosX", 1))
				set("arpy", getVal("learnButtonPosY", 1))
				set("arut", getVal("learnUberTooltip", level), "")
			end
		end
	end
end

function createBuff(path)
	setObjType("buffs")

	local obj = createObj(raw, nil, getVal("profileIdent", 1), path)

	setTrue("code", "Basl")

	set("fart", getVal("icon", 1), "")
	set("fnsf", "")
	set("ftat", "")
	set("fube", getVal("uberTooltip", 1), "")

	local tooltip = getVal("tooltip", 1)

	if (tooltip == nil) then
		if getVal("name", 1) then
			tooltip = getVal("name", 1)
		end
	end

	if getVal("positive", 1) then
		if tooltip then
			set("ftip", "|cff00ff00"..tooltip, "")
		end
	else
	    set("ftip", tooltip, "")
	end

	doSpecials(obj)

	if (dummy ~= true) then
		if raw then
			setObjType("abilities")

			createObj("b"..raw:sub(2, 4), nil, nil, path)

			setTrue("code", "Aasl")

			setLv("aare", 1, 0)
			for level = 1, levelsAmount, 1 do
			    setLv("abuf", level, raw)
			    setLv("atar", level, "invulnerable,self,vulnerable")
			    setLv("Slo1", level, 0)
			end
			set("alev", levelsAmount)
			set("anam", getVal("name", 1), "defaultName(buff) "..nilToString(raw, "NONE"))
			set("ansf", "(Buffer)")
			set("arac", "other")
		end
	end
end

function createItem(path)
	setObjType("items")
	
	local obj = createObj(raw, nil, getVal("profileIdent", 1), path)

	local abilities
	local cooldownGroup

	local function addAbility(value)
		if abilities then
			abilities = abilities..","..value
		else
			abilities = value
			if (cooldownGroup == nil) then
				cooldownGroup = value
			end
		end
	end

	--constant
	set("idro", 1)
	set("ihtp", 1)
	set("ipaw", 1)
	set("isel", 1)
	set("isto", 1)

	set("iarm", getVal("armor", 1), "")
	set("iclr", getVal("vertexColorRed", 1), 255)
	set("iclg", getVal("vertexColorGreen", 1), 255)
	set("iclb", getVal("vertexColorBlue", 1), 255)
	set("ides", getVal("description", 1), "")
	set("iico", getVal("icon", 1), "")
	set("ifil", getVal("model", 1), "")
	set("igol", getVal("goldCost", 1), 0)
	set("ilum", getVal("lumberCost", 1), 0)
	set("ipaw", "1")
	set("isca", getVal("scale", 1), 1)
	set("isel", "1")
	set("istr", 0)
	set("unam", getVal("name", 1), "defaultName(item) "..nilToString(raw, "NONE"))
	set("utip", getVal("tooltip", 1), "")
	set("utub", getVal("uberTooltip", 1), "")

	if getVal("abilities", 1) then
		local t = getVal("abilities", 1):split(";")

		for k, v in pairs(t) do
			if v:find("{", 1, true) then
				t[k] = v:sub(1, v:find("{", 1, true) - 1)
			end
		end

		t = objPathsToRaw(path, t, "wc3spell")

		if t then
			for k, v in pairs(t:split(",")) do
				addAbility(v)
			end
		end
	end

	local classes = string.split(getVal("classes", 1), ";")

	if classes then
    		if tableContains(classes, "POWER_UP") then
			addAbility(getObjVal(pathToFullPath(path, [[Header\Item.page\powerUpAbility]], "wc3spell"), "raw")[1])
		elseif tableContains(classes, "SCROLL") then
			addAbility(getObjVal(pathToFullPath(path, [[Header\Item.page\scrollAbility]], "wc3spell"), "raw")[1])
		end
	end

	if abilities then
	    set("iabi", abilities)
	    set("icid", cooldownGroup)
	    set("iusa", 1)
	end

	doSpecials(obj)
end

function createUnit(path)
	local abilities

	local function addAbility(value)
		if abilities then
			abilities = abilities..","..value
		else
			abilities = value
		end
	end

	setObjType("units")
	
	local obj = createObj(getVal("raw", 1), nil, getVal("profileIdent", 1), path)

	if getVal("standardScale", 1) then
		local scaleFactor = 1. / getVal("standardScale", 1)

		local t = {}

		t[0] = "selScale"
		t[1] = "impactZ"
		t[2] = "outpactX"
		t[3] = "outpactY"
		t[4] = "outpactZ"
		t[5] = "shadowWidth"
		t[6] = "shadowHeight"
		t[7] = "collisionSize"

		for k, v in pairs(t) do
			if getVal(v, 1) then
				getVal(v)[1] = getVal(v, 1) * scaleFactor
			end
		end
	end

	local scale = getVal("scale", 1)

	if (scale == nil) then
		scale = 1.
	end

	local classes = getVal("classes", 1)

	if classes then
		classes = classes:split(";")
	else
		classes = {}
	end

	--constant
	set("ucam", 0)
	set("ucar", 1) --cargo
	set("udea", string.char(3))
	set("ufle", 0)
	set("uine", 1)
	set("upri", 0)
	set("util", "*")
	set("uwu1", 1)

	if dummy then
		if (tableContains(classes, "NOT_LOCUST") ~= true) then
			addAbility(getObjVal(pathToFullPath(nil, LOCUST_SPELL_PATH, "wc3spell"), "raw")[1])
		end
		if tableContains(classes, "WARPER") then
			addAbility(getObjVal(pathToFullPath(nil, "Warp", "wc3spell"), "raw")[1])
		end

		if (getVal("name", 1) == nil) then
			set("unam", "Dummy "..nilToString(raw, "NONE"))
		end
	else
		set("unam", getVal("name", 1), "")
	end

	--classification

	local t = {}

	t["DEFENDER"] = "human"
	t["ATTACKER"] = "creeps"
	t["OTHER"] = "other"

	set("uhos", 0)
	set("urac", t[(getVal("team", 1))], "unknown")

	local utypT = {}

	if tableContains(classes, "WORKER") then
    		table.insert(utypT, "peon")
	end

	set("utyp", table.concat(utypT, ","))

	--model
	set("uaap", getVal("modelAttachMods", 1), "")
	set("ualp", getVal("modelAttachPts", 1), "")
	set("uani", getVal("modelAnims", 1), "")
	set("ubpr", getVal("modelBones", 1), "")
	set("umdl", getVal("model", 1), "")
	
	--modelMods
	set("uept", getVal("elevPts", 1), 0)
	set("uerd", getVal("elevRad", 1), 0)
	set("umxr", getVal("maxRoll", 1), 0)
	set("umxp", getVal("maxPitch", 1), 0)
	set("usca", getVal("scale", 1), 1)
	if getVal("selScale", 1) then
		getVal("selScale")[1] = getVal("selScale", 1) * 0.85
	end
	--set("ussc", nilTo0(getVal("selScale", 1)) * scale, 0)
	set("ussc", nilTo0(getVal("collisionSize", 1)) * scale * 3 / 100, 0)
	set("uclr", getVal("vertexColorRed", 1), 255)
	set("uclg", getVal("vertexColorGreen", 1), 255)
	set("uclb", getVal("vertexColorBlue", 1), 255)
	
	--missilePoints
	set("uimz", nilTo0(getVal("impactZ", 1)) * scale, 0)
	set("ulpx", nilTo0(getVal("outpactX", 1)) * scale, 0)
	set("ulpy", nilTo0(getVal("outpactY", 1)) * scale, 0)
	set("ulpz", nilTo0(getVal("outpactZ", 1)) * scale, 0)

	--shadow
	set("ushw", nilTo0(getVal("shadowWidth", 1)) * scale, 0)
	set("ushh", nilTo0(getVal("shadowHeight", 1)) * scale, 0)
	set("ushx", getVal("shadowOffsetX", 1), 0)
	set("ushy", getVal("shadowOffsetY", 1), 0)
	if (getVal("shadowPath", 1) == "NONE") then
		set("ushb", "")
		set("ushu", "")
	elseif (getVal("shadowPath", 1) == "NORMAL") then
		set("ushb", "")
		set("ushu", "Shadow")
	elseif (getVal("shadowPath", 1) == "FLY") then
		set("ushb", "")
		set("ushu", "ShadowFlyer")
	else
		set("ushb", getVal("shadowPath", 1), "")
		set("ushu", "")
	end
	
	--misc
	set("uico", getVal("icon", 1), "")
	--set("usnd", getVal("soundset", 1), "")
	set("utip", getVal("tooltip", 1), "")
	set("utub", getVal("uberTooltip", 1), "")

	--movement
	local t = {}

	t["NONE"] = ""
	t["FOOT"] = "foot"
	t["HORSE"] = "horse"
	t["FLY"] = "fly"
	t["HOVER"] = "hover"
	t["FLOAT"] = "float"
	t["AMPHIBIOUS"] = "amph"

	if getVal("moveType", 1) then
		set("umvt", t[(getVal("moveType", 1))], "")
	else
		set("umvt", "")
	end

	if (getVal("moveSpeed")[1] and (getVal("moveSpeed", 1) > 0)) then
		set("umvs", getVal("moveSpeed", 1))
		set("uprw", 60)
	elseif dummy then
		set("umvs", -1)
	else
		set("umvs", 0)
	end
	set("umvr", getVal("turnRate", 1), 0)
	set("umvh", getVal("height", 1), 0)
	set("umvf", getVal("heightMin", 1), 0)
	set("uwal", getVal("animWalk", 1), 0)
	set("urun", getVal("animRun", 1), 0)
	set("uori", getVal("moveInterp", 1), 0)

	--balance
	if getVal("armorAmount", 1) then
		set("udef", math.floor(getVal("armorAmount", 1)), 0)
	else
		set("udef", 0)
	end
	set("uarm", getVal("armorSound", 1), "")

	local t = {}

	t["LIGHT"] = "small"
	t["MEDIUM"] = "medium"
	t["LARGE"] = "large"
	t["FORT"] = "fort"
	t["HERO"] = "hero"
	t["UNARMORED"] = "none"
	t["DIVINE"] = "divine"

	if getVal("armorType", 1) then
		set("udty", t[(getVal("armorType", 1))], "divine")
	else
		set("udty", "divine")
	end

	if (getVal("life", 1) == "INFINITE") then
		set("uhpm", 150000)
	else
		set("uhpm", getVal("life", 1), 0)
	end
	set("umpm", getVal("mana", 1), 0)

	set("usid", getVal("sightRange", 1), 0)
	set("usin", getVal("sightRange", 1), 0)
	--set("usin", getVal("sightRangeNight", 1), 0)
	
		--attack
	set("ua1c", getVal("attackCooldown", 1), 0)
	set("ua1g", getVal("attackTargetFlags", 1), "")
	if getVal("attackRange", 1) then
		getVal("attackRange")[1] = getVal("attackRange", 1) * 1.2
	end
	set("ua1r", getVal("attackRange")[1], 0)

	if (getVal("attackType", 1) == "NORMAL") then
		set("ua1w", "normal")
	elseif (getVal("attackType", 1) == "MISSILE") then
		set("ua1w", "missile")
	elseif (getVal("attackType", 1) == "HOMING_MISSILE") then
		set("ua1w", "missile")
		set("umh1", 1)
	elseif (getVal("attackType", 1) == "ARTILLERY") then
		set("ua1f", 0.)
		set("ua1h", 0.)
		set("ua1p", "invulnerable")
		set("ua1q", 1000.)
		set("ua1w", "artillery")
		set("uqd1", -1)
	end

	set("uacq", getVal("attackRangeAcq", 1), 0)
	set("urb1", getVal("attackRangeBuffer", 1), 0)
	set("uaen", string.char(1))
	set("ubs1", getVal("attackWaitAfter", 1), 0)
	set("udp1", getVal("attackWaitBefore", 1), 0)
	set("ucs1", getVal("attackSound", 1), "")
	set("utc1", 1)
	set("uamn", getVal("attackMinRange", 1), 0)
	
	--attackMissile
	set("ua1m", getVal("attackMissileModel", 1), "")
	set("ua1z", getVal("attackMissileSpeed", 1), 0)
	set("uma1", getVal("attackMissileArc", 1), 0)
	
	--anim
	set("uble", getVal("animBlend", 1), 0)
	set("ucbs", getVal("animCastWaitAfter", 1), 0)
	set("ucpt", getVal("animCastWaitBefore", 1), 0)

	if classes then
		if tableContains(classes, "STRUCTURE") then
			isStructure = true
			set("ubdg", 1)
		elseif (getVal("structure", 1) == true) then
			set("ubdg", 1)
		end
		if tableContains(classes, "UPGRADED") then
	    		isUpgrade = true
		end
	end

	--damage
	local t = {}
	
	t["NORMAL"] = "normal"
	t["PIERCE"] = "pierce"
	t["SIEGE"] = "siege"
	t["MAGIC"] = "magic"
	t["CHAOS"] = "chaos"
	t["HERO"] = "hero"
	t["SPELLS"] = "spells"
	
	if getVal("damageType", 1) then
		set("ua1t", t[(getVal("damageType", 1))], "spells")
	else
		set("ua1t", "spells")
	end
	
	set("ua1b", getVal("damageAmount", 1), 0)
	set("ua1d", getVal("damageDices", 1), 0)
	set("ua1s", getVal("damageSides", 1), 0)
	
	--balanceMisc
	if getVal("collisionSize")[1] then
		--getVal("collisionSize", 1) = getVal("collisionSize", 1) * 0.85
	end
	--set("ucol", nilTo0(getVal("collisionSize", 1)) * scale, 0)
	set("ucol", 16, 0)
	set("utar", getVal("combatFlags", 1), "")
	set("udtm", getVal("deathTime", 1), 0)
	set("ubba", getVal("gold", 1), 0)

	--hero
	if (getVal("hero", 1) == true) then
		--constant
		addAbility(getObjVal(pathToFullPath(nil, INVENTORY_SPELL_PATH, "wc3spell"), "raw")[1])
		set("uhhd", "1")
		set("uhab", "AHS0,AHS1,AHS2,AHS3,AHS4")

		--misc
		local t = {}

		t["AGILITY"] = "AGI"
		t["INTELLIGENCE"] = "INT"
		t["STRENGTH"] = "STR"

		if (getVal("heroAttribute", 1) and t[(getVal("heroAttribute", 1))]) then
			set("upra", t[(getVal("heroAttribute", 1))])
		else
			set("upra", "_")
		end
		set("upro", getVal("heroNames", 1), "")
		set("upru", 1)
	end

	--structure
	if (getVal("structure", 1) == true) then
		set("upat", getVal("structurePathTex", 1), "")
		set("uubs", getVal("structureUbersplat", 1), "")
	end
	if getVal("structureSoldItems", 1) then
		addAbility(getObjVal(pathToFullPath(nil, [[Header\Unit.page\Unit.struct\purchaseItem]], "wc3spell"), "raw")[1])
		addAbility(getObjVal(pathToFullPath(nil, [[Header\Unit.page\Unit.struct\selectHero]], "wc3spell"), "raw")[1])
		set("usei", objPathsToRaw(path, getVal("structureSoldItems", 1):split(";"), "wc3item"), "")
	end
	if getVal("structureUpgradeTo", 1) then
		set("uupt", objPathsToRaw(path, getVal("structureUpgradeTo", 1):split(";"), "wc3unit"), "")
	end

	set("uabi", abilities)

	doSpecials(obj)
end

function createDest(path)
	local function boolToBitString(b)
		if b then
			return "\1"
		end

		return "\0"
	end

	setObjType("destructables")

	local obj = createObj(getVal("raw", 1), nil, getVal("profileIdent", 1), path)

	--constant
	set("bonc", 1)
	set("bonw", 1)
	set("btil", "*")
	set("buch", 1)

	set("bnam", getVal("name", 1), "")

	set("bfil", getVal("model", 1), "")
	set("blit", boolToBitString(getVal("modelLightweight", 1)), "\0")
	set("bgpm", getVal("modelPortrait", 1), "")
	set("bvar", getVal("modelVariations", 1), 1)

	set("bflh", getVal("flyHeight", 1), 0)
	set("boch", getVal("occluderHeight", 1), 0)
	set("btxf", getVal("replaceableTex", 1), "")
	set("btxi", getVal("replaceableTexId", 1), 0)
	set("bgsc", getVal("selScale", 1), 0)
	set("bvcr", getVal("vertexColorRed", 1), 255)
	set("bvcg", getVal("vertexColorGreen", 1), 255)
	set("bvcb", getVal("vertexColorBlue", 1), 255)

	set("brad", getVal("elevRad", 1), 0)
	set("bmar", getVal("maxRoll", 1), 0)
	set("bmap", getVal("maxPitch", 1), 0)

	set("bsmm", getVal("minimapDisplay", 1), "\0")
	if (getVal("minimapRed", 1) or getVal("minimapGreen", 1) or getVal("minimapBlue", 1)) then
		set("bmmr", getVal("minimapRed", 1), 0)
		set("bmmg", getVal("minimapGreen", 1), 0)
		set("bmmb", getVal("minimapBlue", 1), 0)
		set("bumm", "\1")
	else
		set("bumm", "\0")
	end

	set("bdsn", getVal("deathSound", 1), "")
	set("bshd", getVal("shadow", 1), "")

	set("barm", getVal("armor", 1), "")
	set("bflo", boolToBitString(getVal("fatLOS", 1)), "\0")
	set("bfra", getVal("fogRad", 1), 0)
	set("bfvi", getVal("fogVisibility", 1), "\0")
	set("bhps", getVal("life", 1), 1)
	set("bgse", getVal("selectable", 1), "\0")

	set("bptx", getVal("pathTex", 1), "")
	set("bptd", getVal("pathTexDead", 1), "")
	set("btar", getVal("combatFlags", 1), "")
	set("bclh", getVal("cliffLevel", 1), 0)
	if getVal("walkable", 1) then
		set("bwal", 1)
	else
		set("bwal", 0)
	end

	doSpecials(obj)
end

function createDoodad(path)
	setObjType("doodads")

	local obj = createObj(getVal("raw", 1), nil, getVal("profileIdent", 1), path)

	setTrue("Name", getVal("name", 1))

	local cat = getVal("category", 1)

	if (cat == "props") then
		setTrue("category", "O")
	elseif (cat == "structure") then
		setTrue("category", "S")
	elseif (cat == "terrain") then
		setTrue("category", "C")
	elseif (cat == "environment") then
		setTrue("category", "E")
	elseif (cat == "cinematic") then
		setTrue("category", "Z")
	elseif (cat == "water") then
		setTrue("category", "W")
	else
		setTrue("category", "O")
	end

	setTrue("tilesets", "*")
	setTrue("UserList", 1)
	setTrue("onCliffs", 1)
	setTrue("onWater", 1)
	setTrue("canPlaceRandScale", 0)
	setTrue("tilesetSpecific", 0)

	setTrue("selSize", getVal("selSize", 1), 0)
	setTrue("useClickHelper", getVal("useClickHelper", 1), 0)
	setTrue("ignoreModelClick", getVal("ignoreModelClicks", 1), 0)

	setTrue("file", getVal("model", 1), "none")
	setTrue("numVar", levelsAmount, 1)

	setTrue("minScale", getVal("minScale", 1), 0.8)
	setTrue("maxScale", getVal("maxScale", 1), 1.2)
	setTrue("defScale", getVal("defaultScale", 1), 1)
	setTrue("fixedRot", getVal("fixedRotation", 1), -1)

	setTrue("maxRoll", getVal("maxRoll", 1), 0)
	setTrue("maxPitch", getVal("maxPitch", 1), 0)

	for i = 1, 10, 1 do
		local suffix

		if (i < 10) then
			suffix = "0"..i
		else
			suffix = i
		end

		setTrue("vertR"..suffix, getVal("red", i), 255)
		setTrue("vertG"..suffix, getVal("green", i), 255)
		setTrue("vertB"..suffix, getVal("blue", i), 255)
	end

	setTrue("visRadius", getVal("visRange", 1), 50)
	setTrue("showInFog", getVal("showInFog", 1), 1)
	setTrue("animInFog", getVal("animInFog", 1), 0)
	setTrue("shadow", getVal("hasShadow", 1), 0)
	setTrue("floats", getVal("floats", 1), 1)
	setTrue("walkable", getVal("walkable", 1), 0)

	if (getVal("minimapRed", 1) or getVal("minimapGreen", 1) or getVal("minimapBlue", 1)) then
		setTrue("showInMM", 1)
		setTrue("useMMColor", 1)
	end
	setTrue("MMRed", getVal("minimapRed", 1), 255)
	setTrue("MMGreen", getVal("minimapGreen", 1), 255)
	setTrue("MMBlue", getVal("minimapBlue", 1), 255)

	setTrue("pathTex", getVal("pathTex", 1), "none")

	setTrue("soundLoop", getVal("sound", 1), "_")

	doSpecials(obj)
end

function createUpgrade(path)
	setObjType("upgrades")

	local obj = createObj(getVal("raw", 1), nil, getVal("profileIdent", 1), path)

	doSpecials(obj)
end

function createImport(path)
	local src = getVal("src", 1)
	local target = getVal("target", 1)

	if (src and target) then
		copyFile(getFolder(path)..src, OUTPUT_PATH..[[\]]..target)
	end

	local iconDisabledSrc = getVal("iconDisabledSrc", 1)
	local iconDisabledTarget = getVal("iconDisabledTarget", 1)

	if (iconDisabledSrc and iconDisabledTarget) then
		copyFile(getFolder(path)..iconDisabledSrc, OUTPUT_PATH..[[\]]..iconDisabledTarget)
	end
end

function createLightning(path)
	setObjType("lightnings")

	local obj = createObj(getVal("raw", 1), nil, getVal("profileIdent", 1), path)

	local texPath = getVal("texPath", 1)

	local folder = getFolder(texPath)

	if (folder:sub(folder:len(), folder:len()) == [[\]]) then
		folder = folder:sub(1, folder:len() - 1)
	end

	setTrue("Dir", folder, "")
	setTrue("file", getFileName(texPath), "")

	setTrue("AvgSegLen", getVal("avgSegLen", 1), 10)
	setTrue("Width", getVal("width", 1), 10)
	setTrue("R", getVal("red", 1), 1)
	setTrue("G", getVal("green", 1), 1)
	setTrue("B", getVal("blue", 1), 1)
	setTrue("A", getVal("alpha", 1), 1)
	setTrue("NoiseScale", getVal("noiseScale", 1), 0.001)
	setTrue("TexCoordScale", getVal("texCoordScale", 1), 0.001)

	assert((getVal("duration", 1) > 0), "lightning duration must be greater than 0", path)
	setTrue("Duration", getVal("duration", 1), 1)
end

function createWeather(path)
	setObjType("weathers")

	local obj = createObj(getVal("raw", 1), nil, getVal("profileIdent", 1), path)

	local texPath = getVal("texPath", 1)

	local folder = getFolder(texPath)

	if (folder:sub(folder:len(), folder:len()) == [[\]]) then
		folder = folder:sub(1, folder:len() - 1)
	end

	setTrue("texDir", folder, "")
	setTrue("texFile", getFileName(texPath, true), "")

	setTrue("alphaMode", getVal("alphaMode", 1), 1)
	setTrue("useFog", getVal("useFog", 1), 1)
	setTrue("height", getVal("height", 1), 100)
	setTrue("angx", getVal("angleX", 1), -50)
	setTrue("angy", getVal("angleY", 1), 50)
	setTrue("emrate", getVal("emissionRate", 1), 10)
	setTrue("lifespan", getVal("lifespan", 1), 5)
	setTrue("particles", getVal("particles", 1), 1000)
	setTrue("veloc", getVal("speed", 1), -100)
	setTrue("accel", getVal("accel", 1), 0)
	setTrue("var", getVal("variance", 1), 0.05)
	setTrue("texr", getVal("texR", 1), 10)
	setTrue("texc", getVal("texC", 1), 10)
	setTrue("head", getVal("head", 1), 1)
	setTrue("tail", getVal("tail", 1), 0)
	setTrue("taillen", getVal("tailLength", 1), 1)
	setTrue("lati", getVal("latitude", 1), 2.5)
	setTrue("long", getVal("longitude", 1), 180)

	setTrue("midTime", getVal("midTime", 1), 0.5)

	setTrue("redStart", getVal("redStart", 1), 255)
	setTrue("greenStart", getVal("greenStart", 1), 255)
	setTrue("blueStart", getVal("blueStart", 1), 255)
	setTrue("alphaStart", getVal("alphaStart", 1), 255)

	setTrue("redMid", getVal("redMid", 1), 127)
	setTrue("greenMid", getVal("greenMid", 1), 127)
	setTrue("blueMid", getVal("blueMid", 1), 127)
	setTrue("alphaMid", getVal("alphaMid", 1), 127)

	setTrue("redEnd", getVal("redEnd", 1), 0)
	setTrue("greenEnd", getVal("greenEnd", 1), 0)
	setTrue("blueEnd", getVal("blueEnd", 1), 0)
	setTrue("alphaEnd", getVal("alphaEnd", 1), 0)

	setTrue("scaleStart", getVal("scaleStart", 1), 100)
	setTrue("scaleMid", getVal("scaleMid", 1), 100)
	setTrue("scaleEnd", getVal("scaleEnd", 1), 100)

	setTrue("hUVStart", getVal("hUVStart", 1), 0)
	setTrue("hUVMid", getVal("hUVMid", 1), 0)
	setTrue("hUVEnd", getVal("hUVEnd", 1), 0)

	setTrue("tUVStart", getVal("tUVStart", 1), 0)
	setTrue("tUVMid", getVal("tUVMid", 1), 0)
	setTrue("tUVEnd", getVal("tUVEnd", 1), 0)

	setTrue("AmbientSound", getVal("sound", 1), "-")
end

function createUbersplat(path)
	setObjType("ubersplats")

	local obj = createObj(getVal("raw", 1), nil, getVal("profileIdent", 1), path)

	local texPath = getVal("texPath", 1)

	local folder = getFolder(texPath)

	if (folder:sub(folder:len(), folder:len()) == [[\]]) then
		folder = folder:sub(1, folder:len() - 1)
	end

	setTrue("Dir", folder, "")
	setTrue("file", getFileName(texPath, true), "")

	setTrue("BlendMode", getVal("blendMode", 1), 0)

	setTrue("Scale", getVal("scale", 1), 100)
	setTrue("BirthTime", getVal("birthTime", 1), 0)
	setTrue("PauseTime", getVal("pauseTime", 1), 0)
	setTrue("Decay", getVal("decay", 1), 0)

	setTrue("StartR", getVal("redStart", 1), 255)
	setTrue("StartG", getVal("greenStart", 1), 255)
	setTrue("StartB", getVal("blueStart", 1), 255)
	setTrue("StartA", getVal("alphaStart", 1), 255)

	setTrue("MiddleR", getVal("redMid", 1), 127)
	setTrue("MiddleG", getVal("greenMid", 1), 127)
	setTrue("MiddleB", getVal("blueMid", 1), 127)
	setTrue("MiddleA", getVal("alphaMid", 1), 127)

	setTrue("EndR", getVal("redEnd", 1), 0)
	setTrue("EndG", getVal("greenEnd", 1), 0)
	setTrue("EndB", getVal("blueEnd", 1), 0)
	setTrue("EndA", getVal("alphaEnd", 1), 0)

	setTrue("Sound", getVal("sound", 1), "NULL")
end

function createTile(path)
	setObjType("tiles")

	local obj = createObj(getVal("raw", 1), nil, getVal("profileIdent", 1), path)

	local texPath = getVal("texPath", 1)

	local folder = getFolder(texPath)

	if (folder:sub(folder:len(), folder:len()) == [[\]]) then
		folder = folder:sub(1, folder:len() - 1)
	end

	setTrue("dir", folder, "")
	setTrue("file", getFileName(texPath, true), "")

	setTrue("cliffSet", getVal("cliffSet", 1), -1)

	if (getVal("walkable", 1) == true) then
		setTrue("walkable", 1, 0)
	else
		setTrue("walkable", 0, 0)
	end
	if (getVal("flyable", 1) == true) then
		setTrue("flyable", 1, 0)
	else
		setTrue("flyable", 0, 0)
	end
	if (getVal("buildable", 1) == true) then
		setTrue("buildable", 1, 0)
	else
		setTrue("buildable", 0, 0)
	end

	if (getVal("footprints", 1) == true) then
		setTrue("footprints", 1, 0)
	else
		setTrue("footprints", 0, 0)
	end
	setTrue("blightPri", getVal("blightPriority", 1), 0)
end

function createSound(path)
	setObjType("sounds")

	if getVal("is3d", 1) then
		setTrue("MaxDistance", getVal("maxDist", 1), 0)
		setTrue("MinDistance", getVal("minDist", 1), 0)
		setTrue("DistanceCutoff", getVal("cutoffDist", 1), 0)

		setTrue("InsideAngle", getVal("insideAngle", 1), 0)
		setTrue("OutsideAngle", getVal("outsideAngle", 1), 0)
		setTrue("OutsideVolume", getVal("outsideVolume", 1), 0)
		setTrue("OrientationX", getVal("orientationX", 1), 0)
		setTrue("OrientationY", getVal("orientationY", 1), 0)
		setTrue("OrientationZ", getVal("orientationZ", 1), 0)
	end
end

arrayTable = {}
generatedJs = {}

function getJassFileName(path)
	return getFileName(path):gsub("%.", "_"):trim("["):trim("]")
end

function toJassValue(v, jassType)
	if (jassType == nil) then
		jassType = type(v)
	end

	if (jassType == "boolean") then
		return boolToString(v)
	end
	if (jassType == "string") then
		if isPlainText(v) then
			return v:doubleBackslashes():quote()
		end
	end

	return v
end

function buildJ(path, extension, targetPath, dummy)
	local fileName = getFileName(path, true)
	local folder = getFolder(path)

	local name = getVal("name", 1)
	local raw = getVal("raw", 1)
	local var = getVal("jassVar", 1)

	local varLines = {}
	local varLinesC = 0

	local function writeVarLine(s)
		varLinesC = varLinesC + 1
		varLines[varLinesC] = s
	end

	local lines = {}
	local linesC = 0

	local function writeLine(s)
		if ((string.find(s, "static") ~= 1) and (string.find(s, "end") ~= 1)) then
			s = "    "..s
		end

		linesC = linesC + 1
		lines[linesC] = s
	end

	local function toJassName(s)
		local result = ""

		for i = 1, s:len(), 1 do
			local c = s:sub(i, i)

			if ((c >= 'A') and (c <= 'Z') and (i > 1)) then
				result = result.."_"..c
			else
				result = result..c:upper()
			end
		end

		return result
	end

	local function toJassPath(base, a, mainExtension)
		s = pathToFullPath(base, a, mainExtension)

		assert(s, "toJassPath: no path".." ("..table.concat({tostring(base), tostring(a), tostring(mainExtension)}, ",")..")")

		local c = 1
		local startFrom
		local t = s:split([[\]])

		while t[c] do
			if t[c]:find(".struct", 1, true) then
				startFrom = c
			end

			c = c + 1
		end

		c = startFrom

		s = t[c]:sub(1, t[c]:find(".struct", 1, true) - 1).."(NULL)"

		c = c + 1

		while t[c + 1] do
			s = s.."."..t[c]

			c = c + 1
		end

		s = s.."."..toJassName(getFileName(t[c], true))

		return s
	end

	if var then
		var = toJassName(var)
	end

	local objJassType

	if var then
		if dummy then
			local t = {}

			t["wc3buff"] = "integer"
			t["wc3spell"] = "integer"
			t["wc3item"] = "integer"
			t["wc3unit"] = "integer"
			t["wc3dest"] = "integer"
			t["wc3upgr"] = "integer"
			t["wc3bolt"] = "string"
			t["wc3weather"] = "integer"
			t["wc3ubersplat"] = "string"
			t["wc3tile"] = "integer"
			t["wc3sound"] = "string"

			objJassType = t[extension]

			if var:find("[", 1, true) then
				var = var:sub(1, var:find("[", 1, true) - 1).."_ID"..var:sub(var:find("[", 1, true), var:len())
			else
				var = var.."_ID"
			end
		end

		if (objJassType == nil) then
			local t = {}

			t["wc3buff"]= "Buff"
			t["wc3spell"]= "Spell"
			t["wc3item"]= "ItemType"
			t["wc3unit"]= "UnitType"
			t["wc3dest"]= "DestructableType"
			t["wc3upgr"]= nil
			t["wc3bolt"]= "LightningType"
			t["wc3weather"]= "WeatherType"
			t["wc3ubersplat"]= "UbersplatType"
			t["wc3tile"]= "TileType"
			t["wc3sound"]= "SoundType"

			objJassType = t[extension]
		end

		if objJassType then
			local varDecLine

			if var:find("[", 1, true) then
			    	local var2 = var:sub(1, var:find("[", 1, true) - 1)

				if (arrayTable[folder] == nil) then
					arrayTable[folder] = {}
				end

				if (arrayTable[folder][var2] == nil) then
					arrayTable[folder][var2] = true
					varDecLine = "static "..objJassType.." array "..var2
				end
			elseif dummy then
				if raw then
					if (objJassType == "integer") then
						varDecLine = "static constant "..objJassType.." "..var.." = '"..raw.."'"
					else
						varDecLine = "static constant "..objJassType.." "..var.." = "..raw:quote()
					end
				end
			else
				varDecLine = "static "..objJassType.." "..var
			end

			if varDecLine then
				writeVarLine(varDecLine)
				writeVarLine("")
			end
		end
	end

	local constFields = {}

	if customFields then
		for field, val in pairs(customFields) do
			local jassType = type(getVal(val, 1))

			if (jassIdents and jassIdents[val]) then
				jassType = jassIdents[val]
			elseif (jassType == "boolean") then
			        jassType = "boolean"
			elseif (jassType == "number") then
				for level = 0, levelsAmount, 1 do
					if getVal(val, level) then
						if (math.floor(getVal(val, level)) ~= getVal(val, level)) then
							jassType = "real"
						end
					end
				end

				if (jassType == "number") then
					jassType = "integer"
				end
			else
				jassType = "string"
			end

			local varDecLine

			if fieldIsArray[val] then
				varDecLine = "static "..jassType.." array "..toJassName(val)
			else
				varDecLine = "static "..jassType.." "..toJassName(val)

				local t = {}

				t[0] = "boolean"
				t[1] = "integer"
				t[2] = "real"
				t[3] = "string"

				if tableContains(t, jassType) then
					local level = 0
	
					while ((getVal(val, level) == nil) and (level <= levelsAmount)) do
						level = level + 1
					end
	
					if (level <= levelsAmount) then
						constFields[val] = true
						varDecLine = varDecLine.." = "..toJassValue(getVal(val, level), jassType)
					end
				end
			end

			if (toJassName(val):find("//") == 1) then
				varDecLine = "//"..varDecLine
			end

			writeVarLine(varDecLine)
		end
	end

	local jassFileName = getJassFileName(path)

	if var then
		var = "thistype."..var
	end

	local isExtended

	if raw then
		isExtended = objByRaw[raw].requiresMods
	end

	if dummy then
		if raw then
			if var then
				if var:find("[", 1, true) then
					writeLine([[set ]]..var..[[ = ']]..raw..[[']])
				end
			end

			if (extension == "wc3spell") then
				if raw then
					writeLine([[call InitAbility(']]..raw..[[', ]]..boolToString(isExtended)..[[)]])
				end
			end
		end
	else
		if (extension == "wc3spell") then
			if raw then
				writeLine([[call InitAbility(']]..raw..[[', ]]..boolToString(false)..[[)]])
			end

			local hero = getVal("hero", 1)

			if (raw and raw ~= "") then
				writeLine([[set ]]..var..[[ = Spell.CreateFromSelf(']]..raw..[[')]])
			else
				writeLine([[set ]]..var..[[ = Spell.CreateHidden(thistype.NAME + ]]..toJassValue(" ("..fileName..")")..[[)]])
			end

			writeLine("")

			if getVal("class", 1) then
				writeLine([[call ]]..var..[[.SetClass(SpellClass.]]..getVal("class", 1)..[[)]])
			end
			if getVal("levelsAmount", 1) then
				writeLine([[call ]]..var..[[.SetLevelsAmount(]]..getVal("levelsAmount", 1)..[[)]])
			end
			if getVal("name", 1) then
				writeLine([[call ]]..var..[[.SetName(]]..toJassValue(getVal("name", 1))..[[)]])
			end
			if getVal("order", 1) then
				writeLine([[call ]]..var..[[.SetOrder(Order.GetFromSelf(OrderId(]]..toJassValue(getVal("order", 1))..[[)))]])
			end
			if getVal("autoCastOrderOff", 1) then
				writeLine([[call ]]..var..[[.SetAutoCastOrderOff(Order.GetFromSelf(]]..getVal("autoCastOrderOff", 1)..[[))]])
			end
			if getVal("autoCastOrderOn", 1) then
				writeLine([[call ]]..var..[[.SetAutoCastOrderOn(Order.GetFromSelf(]]..getVal("autoCastOrderOn", 1)..[[))]])
			end
			if getVal("target", 1) then
				writeLine([[call ]]..var..[[.SetTargetType(Spell.TARGET_TYPE_]]..getVal("target", 1)..[[)]])
			end

			if getVal("animation", 1) then
				writeLine([[call ]]..var..[[.SetAnimation(]]..toJassValue(getVal("animation", 1))..[[)]])
			end
			for level = 1, levelsAmount, 1 do
				if getVal("areaRange", level) then
					writeLine([[call ]]..var..[[.SetAreaRange(]]..level..[[, ]]..getVal("areaRange", level)..[[)]])
				end
				if getVal("castTime", level) then
					writeLine([[call ]]..var..[[.SetCastTime(]]..level..[[, ]]..getVal("castTime", level)..[[)]])
				end
				if getVal("channelTime", level) then
					writeLine([[call ]]..var..[[.SetChannelTime(]]..level..[[, ]]..getVal("channelTime", level)..[[)]])
				end
				if getVal("cooldown", level) then
					writeLine([[call ]]..var..[[.SetCooldown(]]..level..[[, ]]..getVal("cooldown", level)..[[)]])
				end
				if getVal("manaCost", level) then
					writeLine([[call ]]..var..[[.SetManaCost(]]..level..[[, ]]..getVal("manaCost", level)..[[)]])
				end
				if getVal("range", level) then
					writeLine([[call ]]..var..[[.SetRange(]]..level..[[, ]]..getVal("range", level)..[[)]])
				end
			end

			if getVal("icon", 1) then
				writeLine([[call ]]..var..[[.SetIcon(]]..toJassValue(getVal("icon", 1))..[[)]])
			end

			writeLine("")

			if hero then
				local learnRaw = getVal("learnRaw", 1)
				local learnSlot = getVal("learnSlot", 1)

				if (learnRaw and learnSlot) then
					writeLine([[call HeroSpell.InitSpell(]]..var..[[, 'F]]..learnRaw..[[0', ]]..levelsAmount..[[, 'V]]..learnRaw..[[0', ']]..getHidePlaceholderRaw(learnRaw)..[[', ']]..getHideReplacerRaw(learnRaw)..[[')]])
				end

				writeLine("")
			end
		elseif (extension == "wc3buff") then	
			if (name == nil) then
				name = "defaultName(buff)"

				if raw then
					name = name.." "..raw
				end
			end

			if raw then
				local bufferRaw = "b"..raw:sub(2, 4)

				writeLine([[set ]]..var..[[ = Buff.Create(']]..raw..[[', ]]..toJassValue(name)..[[, ']]..bufferRaw..[[')]])
		        else
				writeLine([[set ]]..var..[[ = Buff.CreateHidden(thistype.NAME + ]]..toJassValue(" ("..fileName..")")..[[)]])
			end

			if getVal("positive", 1) then
				writeLine([[call ]]..var..[[.SetPositive(]]..boolToString(getVal("positive", 1))..[[)]])
			end

			local t = string.split(getVal("lostOn", 1), ";")

			if t then
				if tableContains(t, "death") then
					writeLine("call "..var..".SetLostOnDeath(true)")
				end

				if tableContains(t, "dispel") then
					writeLine("call "..var..".SetLostOnDispel(true)")
				end
			end

			if getVal("icon", 1) then
		        	writeLine([[call ]]..var..[[.SetIcon(]]..toJassValue(getVal("icon", 1))..[[)]])
		        end

		        local sfxCount = 0
		        local sfxPaths = {}
	        	local sfxAttachPts = {}
		        local sfxLevels = {}

			local t = string.split(getVal("sfxPath", 1), ";")

			if t then
			        for k, v in pairs(t) do
			        	sfxCount = sfxCount + 1

			        	sfxPaths[sfxCount] = v
			        end
		        end

			sfxCount = 0
			t = string.split(getVal("sfxAttachPt", 1), ";")

			if t then
				for k, v in pairs(t) do
					sfxCount = sfxCount + 1

					sfxAttachPts[sfxCount] = v
				end
			end

			sfxCount = 0
			t = string.split(getVal("sfxLevel", 1), ";")

			if t then
				for k, v in pairs(t) do
					sfxCount = sfxCount + 1

					sfxLevels[sfxCount] = v
				end
			end

			for i = 1, sfxCount, 1 do
				if sfxPaths[i] and sfxAttachPts[i] and sfxLevels[i] then
					writeLine([[call ]]..var..[[.TargetEffects.Add(]]..toJassValue(sfxPaths[i])..[[, ]]..sfxAttachPts[i]..[[, ]]..sfxLevels[i]..[[)]])
				end
			end

			local t = string.split(getVal("sfxSoundLoop", 1), ";")

			if t then
				for i = 1, #t, 1 do
					local val = toJassName(getObjVal(pathToFullPath(path, t[i], "wc3sound"), "jassVar", 1))

					writeLine([[call ]]..var..[[.LoopSounds.Add(]]..val..[[)]])
				end
			end

			if getVal("unitMod") then
				local stateTable = {}

				stateTable["scaleBonus"] = [[UNIT.Scale.Bonus.STATE]]

				local t = {}
				stateTable["scaleBonusTimed"] = t
					t.jassPath = [[UNIT.Scale.Timed.STATE]]
					t.jassArgs = {{key = [[UNIT.Scale.Timed.STATE_SCALE_KEY]], typeName = [[Real]]}, {key = [[UNIT.Scale.Timed.STATE_DURATION_KEY]], typeName = [[Real]]}}
					t.type = "CustomMod"

				local t = {}
				stateTable["scaleBonusTimed"] = t
					t.jassLine = [[UNIT.Scale.Timed.CreateMod(%s)]]

				local t = {}
				stateTable["vertexColorBonus"] = t
					t.jassLine = [[UNIT.VertexColor.CreateMod(%s)]]

				local t = {}
				stateTable["vertexColorBonusTimed"] = t
					t.jassLine = [[UNIT.VertexColor.Timed.CreateMod(%s)]]

				stateTable["maxLifeBonus"] = [[UNIT.MaxLife.Bonus.STATE]]
				stateTable["maxManaBonus"] = [[UNIT.MaxMana.Bonus.STATE]]

				stateTable["lifeRegenBonus"] = [[UNIT.LifeRegeneration.Bonus.STATE]]
				stateTable["lifeRegenBonusRel"] = [[UNIT.LifeRegeneration.Relative.STATE]]
				stateTable["lifeRegenDisable"] = [[UNIT.LifeRegeneration.Disablement.STATE]]
				stateTable["manaRegenBonus"] = [[UNIT.ManaRegeneration.Bonus.STATE]]
				stateTable["manaRegenBonusRel"] = [[UNIT.ManaRegeneration.Relative.STATE]]
				stateTable["manaRegenDisable"] = [[UNIT.ManaRegeneration.Disablement.STATE]]
				stateTable["staminaRegenBonus"] = [[UNIT.StaminaRegeneration.Bonus.STATE]]

				stateTable["attackSpeedBonus"] = [[UNIT.Attack.Speed.BonusA.STATE]]
				stateTable["moveSpeedBonus"] = [[UNIT.Movement.Speed.BonusA.STATE]]
				stateTable["moveSpeedBonusRel"] = [[UNIT.Movement.Speed.RelativeA.STATE]]

				stateTable["critBonus"] = [[UNIT.CriticalChance.Bonus.STATE]]
				stateTable["evasionBonus"] = [[UNIT.EvasionChance.Bonus.STATE]]
				stateTable["evasionDefBonus"] = [[UNIT.EvasionChanceDefense.Bonus.STATE]]
				stateTable["missBonus"] = [[UNIT.EvasionChanceDefense.Bonus.STATE]]

				stateTable["dmgBonus"] = [[UNIT.Damage.Bonus.STATE]]
				stateTable["dmgBonusRel"] = [[UNIT.Damage.Relative.STATE]]
				stateTable["armorBonus"] = [[UNIT.Armor.Bonus.STATE]]
				stateTable["armorSpell"] = [[UNIT.Armor.Spell.STATE]]

				stateTable["lifeLeech"] = [[UNIT.LifeLeech.STATE]]
				stateTable["manaLeech"] = [[UNIT.ManaLeech.STATE]]

				stateTable["spellPowerBonus"] = [[UNIT.SpellPower.Bonus.STATE]]
				stateTable["spellPowerBonusRel"] = [[UNIT.SpellPower.Relative.STATE]]

				stateTable["healAbilityBonusRel"] = [[UNIT.HealAbility.BONUS_STATE]]
				stateTable["spellVampBonus"] = [[UNIT.SpellVamp.Bonus.STATE]]

				stateTable["resistanceBonus"] = [[UNIT.Armor.Resistance.STATE]]

				stateTable["attackDisable"] = [[UNIT.Attack.DISABLE_STATE]]
				stateTable["ghost"] = [[UNIT.Ghost.STATE]]
				stateTable["invul"] = [[UNIT.Invulnerability.STATE]]
				stateTable["magicImmunity"] = [[UNIT.MagicImmunity.STATE]]
				stateTable["moveDisable"] = [[UNIT.Movement.DISABLE_STATE]]
				stateTable["stun"] = [[UNIT.Stun.STATE]]

				stateTable["vigorBonusRel"] = [[UNIT.Strength.Relative.STATE]]
				stateTable["focusBonusRel"] = [[UNIT.Agility.Relative.STATE]]
				stateTable["animusBonusRel"] = [[UNIT.Intelligence.Relative.STATE]]

				for level = 1, levelsAmount, 1 do
					if getVal("unitMod", level) then
						local mods = string.split(getVal("unitMod", level), ";")
						local vals = string.split(getVal("unitModVal", level), ";")

						if mods and mods[1] and (mods[1] ~= "") then
							writeLine([[set UnitModSet.TEMP = UnitModSet.Create()]])

							for pos, mod in pairs(mods) do
								local state = stateTable[mod]
								local val = vals[pos]

								if (type(val) == "string") then
									if ((val:sub(1, 1) == "{") and (val:sub(val:len(), val:len()) == "}")) then
										val = val:sub(2, val:len() - 1):split(",")
									end
								end

								if state then
									if (type(val) == "table") then
										if (state.type == "CustomMod") then
											writeLine([[call ]]..[[UnitModSet.TEMP]]..[[.CustomMods.Add(]]..state.jassPath..[[)]])
											for k, v in pairs(val) do
												writeLine([[call ]]..[[UnitModSet.TEMP]]..[[.CustomMods.Add]]..state.jassArgs[k].typeName..[[(]]..state.jassPath..[[, ]]..state.jassArgs[k].key..[[, ]]..v..[[)]])
											end
										else
											writeLine([[call UnitModSet.TEMP.Mods.Add(]]..string.format(state.jassLine, table.concat(val, ","))..[[)]])
										end
									elseif tonumber(val) then
										writeLine([[call ]]..[[UnitModSet.TEMP]]..[[.RealMods.Add(]]..state..[[, ]]..val..[[)]])
									elseif ((tostring(val) == "true") or (tostring(val) == "false")) then
										writeLine([[call ]]..[[UnitModSet.TEMP]]..[[.BoolMods.Add(]]..state..[[, ]].."true"..[[)]])
									else
										log:write(path..': unitMod type unrecognized ('..mod..', '..tostring(val)..')')
									end
								end
							end

							writeLine([[call ]]..var..[[.UnitModSets.Add(]]..level..[[, ]]..[[UnitModSet.TEMP]]..[[)]])
						end
					end
				end
			end
		elseif (extension == "wc3item") then
			if raw then
				writeLine([[set ]]..var..[[ = ItemType.CreateFromSelf(']]..raw..[[')]])
			end

			local t = string.split(getVal("classes", 1), ";")

			if t then
				for k, class in pairs(t) do
					writeLine([[call ]]..var..[[.Classes.Add(ItemClass.]]..class..[[)]])
				end
			end

			if getVal("chargesAmount", 1) then
				writeLine([[call ]]..var..[[.ChargesAmount.Set(]]..getVal("chargesAmount", 1)..[[)]])
			end
			if getVal("icon", 1) then
				writeLine([[call ]]..var..[[.SetIcon(]]..toJassValue(getVal("icon", 1))..[[)]])
			end
			if getVal("usageGoldCost", 1) then
				writeLine([[call ]]..var..[[.UsageGoldCost.Set(]]..getVal("usageGoldCost", 1)..[[)]])
			end

			if getVal("abilities", 1) then
				local t = getVal("abilities", 1):split(";")

				for k, v in pairs(t) do
					v = v:dequote()

					if v:find("{", 1, true) then
						local val = v:sub(1, v:find("{", 1, true) - 1)
						local level = v:sub(v:find("{", 1, true) + 1, v:len())

						level = level:sub(1, level:find("}", 1, true) - 1)

						writeLine([[call ]]..var..[[.Abilities.AddWithLevel(]]..toJassPath(path, val, "wc3spell")..[[, ]]..level..[[)]])
					else
						writeLine([[call ]]..var..[[.Abilities.Add(]]..toJassPath(path, v, "wc3spell")..[[)]])
					end
				end
			end
		elseif (extension == "wc3unit") then
			local scaleFactor

			if getVal("standardScale", 1) then
				scaleFactor = 1. / getVal("standardScale", 1)
			else
				scaleFactor = 1.
			end

			--base
			if raw then
				writeLine([[set ]]..var..[[ = UnitType.Create(']]..raw..[[')]])
			else
				writeLine([[set ]]..var..[[ = UnitType.CreateHidden()]])
			end

			--classification
			local jassClasses = {}

			local function addClass(val)
				jassClasses[val] = val
			end

			if (getVal("hero", 1) == true) then
				writeLine([[call ]]..var..[[.Abilities.Add(']]..getObjVal(pathToFullPath(nil, INVENTORY_SPELL_PATH, "wc3spell"), "raw")[1]..[[')]])
				addClass("hero")
			end
			if (getVal("structure", 1) == true) then
				addClass("structure")
			end

			local t = string.split(getVal("classes", 1), ";")

			if t then
				for k, v in pairs(t) do
					addClass(v)
				end
			end

			local t = string.split(getVal("combatFlags", 1), ",")

			if t then
				for k, v in pairs(t) do
					addClass(v)
				end
			end

			if jassClasses then
				local t = {}

				t["air"] = "AIR"
				t["ground"] = "GROUND"
				t["hero"] = "HERO"
				t["mechanical"] = "MECHANICAL"
				t["structure"] = "STRUCTURE"

				for k, v in pairs(jassClasses) do
					if t[v] then
						writeLine([[call ]]..var..[[.Classes.Add(UnitClass.]]..t[v]..[[)]])
					end
				end
			end

			--modelMods
			if getVal("scale", 1) then
				writeLine([[call ]]..var..[[.Scale.Set(]]..getVal("scale", 1)..[[)]])
			end

			local colorMod
			local red
			local green
			local blue
			local alpha

			if getVal("vertexColorRed", 1) then
				colorMod = true
				red = getVal("vertexColorRed", 1)
			end
			if getVal("vertexColorGreen", 1) then
				colorMod = true
				green = getVal("vertexColorGreen", 1)
			end
			if getVal("vertexColorBlue", 1) then
				colorMod = true
				blue = getVal("vertexColorBlue", 1)
			end
			if getVal("vertexColorAlpha", 1) then
				colorMod = true
				alpha = getVal("vertexColorAlpha", 1)
			end

			if colorMod then
				if (red == nil) then
					red = 255
				end
				if (green == nil) then
					green = 255
				end
				if (blue == nil) then
					blue = 255
				end
				if (alpha == nil) then
					alpha = 255
				end

				writeLine([[call ]]..var..[[.VertexColor.Set(]]..red..[[, ]]..green..[[, ]]..blue..[[, ]]..alpha..[[)]])
			end

			--missilePoints
			if getVal("impactZ", 1) then
				writeLine([[call ]]..var..[[.Impact.Z.Set(]]..(getVal("impactZ", 1) * scaleFactor)..[[)]])
			end
			if getVal("outpactZ", 1) then
				writeLine([[call ]]..var..[[.Outpact.Z.Set(]]..(getVal("outpactZ", 1) * scaleFactor)..[[)]])
			end

			--misc
			if getVal("attachments", 1) then
				local c = 1
				local t = string.split(getVal("attachments", 1), ";")

				while (t[c] and t[c + 1] and t[c + 2]) do
					writeLine([[call ]]..var..[[.Attachments.Add(]]..toJassValue(t[c])..[[, AttachPoint.]]..t[c + 1]..[[, EffectLevel.]]..t[c + 2]..[[)]])

					c = c + 3
				end
			end
			if getVal("blood", 1) then
				writeLine([[call ]]..var..[[.Blood.Set(]]..toJassValue(getVal("blood", 1))..[[)]])
			end
			if getVal("bloodExplosion", 1) then
				writeLine([[call ]]..var..[[.BloodExplosion.Set(]]..toJassValue(getVal("bloodExplosion", 1))..[[)]])
			end

			--movement
			if getVal("moveSpeed", 1) then
				writeLine([[call ]]..var..[[.Speed.Set(]]..getVal("moveSpeed", 1)..[[)]])
			end

			--balance
			if getVal("armorAmount", 1) then
				writeLine([[call ]]..var..[[.Armor.Set(]]..getVal("armorAmount", 1)..[[)]])
			end
			if getVal("armorType", 1) then
				writeLine([[call ]]..var..[[.Armor.Type.Set(Attack.ARMOR_TYPE_]]..getVal("armorType", 1)..[[)]])
			end
			if getVal("life", 1) then
				if (getVal("life", 1) == "INFINITE") then
					writeLine([[call ]]..var..[[.Life.Set(]]..[[UNIT_TYPE.Life.INFINITE]]..[[)]])
					writeLine([[call ]]..var..[[.Life.SetBJ(]]..[[UNIT_TYPE.Life.INFINITE]]..[[)]])
				else
					writeLine([[call ]]..var..[[.Life.Set(]]..getVal("life", 1)..[[)]])
					writeLine([[call ]]..var..[[.Life.SetBJ(]]..getVal("life", 1)..[[)]])
				end
			end
			if getVal("lifeRegen", 1) then
				writeLine([[call ]]..var..[[.LifeRegeneration.Set(]]..(getVal("lifeRegen", 1) / 5)..[[)]])
			end

			if getVal("mana", 1) then
				writeLine([[call ]]..var..[[.Mana.Set(]]..getVal("mana", 1)..[[)]])
				writeLine([[call ]]..var..[[.Mana.SetBJ(]]..getVal("mana", 1)..[[)]])
			end
			if getVal("manaRegen", 1) then
				writeLine([[call ]]..var..[[.ManaRegeneration.Set(]]..(getVal("manaRegen", 1) / 5)..[[)]])
			end
			if getVal("sightRange", 1) then
				writeLine([[call ]]..var..[[.SightRange.Set(]]..getVal("sightRange", 1)..[[)]])
				writeLine([[call ]]..var..[[.SightRange.SetBJ(]]..getVal("sightRange", 1)..[[)]])
			end
			if getVal("spellPower", 1) then
				writeLine([[call ]]..var..[[.SpellPower.Set(]]..getVal("spellPower", 1)..[[)]])
			end

			--attack
			if getVal("attackType", 1) then
				writeLine([[call ]]..var..[[.Attack.Set(Attack.]]..getVal("attackType", 1)..[[)]])
			end
			if getVal("attackRange", 1) then
				writeLine([[call ]]..var..[[.Attack.Range.Set(]]..getVal("attackRange", 1)..[[)]])
			end
			if getVal("attackCooldown", 1) then
				writeLine([[call ]]..var..[[.Attack.Speed.SetByCooldown(]]..getVal("attackCooldown", 1)..[[)]])
			end
			if getVal("attackWaitBefore", 1) then
				writeLine([[call ]]..var..[[.Damage.Delay.Set(]]..getVal("attackWaitBefore", 1)..[[)]])
			end

			--attackMissile
			if getVal("attackMissileSpeed", 1) then
				writeLine([[call ]]..var..[[.Attack.Missile.Speed.Set(]]..getVal("attackMissileSpeed", 1)..[[)]])
			end

			--attackSplash
			if getVal("attackSplash", 1) then
				local c = 1
				local t = string.split(getVal("attackSplash", 1), ";")

				while t[c] and t[c + 1] do
					writeLine([[call ]]..var..[[.Attack.Splash.Add(]]..t[c]..[[, ]]..t[c + 1]..[[)]])

					c = c + 2
	    			end

				if getVal("attackSplashTargetFlags", 1) then
					local t = string.split(getVal("attackSplashTargetFlags", 1), ";")

					if t then
						for k,v in pairs(t) do
							writeLine([[call ]]..var..[[.Attack.Splash.TargetFlag.Add(TargetFlag.]]..v..[[)]])
						end
					end
				end
			end

			--damage
			if getVal("damageAmount", 1) then
				writeLine([[call ]]..var..[[.Damage.Set(]]..getVal("damageAmount", 1)..[[)]])
				writeLine([[call ]]..var..[[.Damage.SetBJ(]]..getVal("damageAmount", 1)..[[)]])
			end
			if getVal("damageDices", 1) then
				writeLine([[call ]]..var..[[.Damage.Dices.Set(]]..getVal("damageDices", 1)..[[)]])
			end
			if getVal("damageSides", 1) then
				writeLine([[call ]]..var..[[.Damage.Sides.Set(]]..getVal("damageSides", 1)..[[)]])
			end
			if getVal("damageType", 1) then
				writeLine([[call ]]..var..[[.Damage.Type.Set(Attack.DMG_TYPE_]]..getVal("damageType", 1)..[[)]])
			end

			--balanceMisc
			if getVal("collisionSize", 1) then
	    			writeLine([[call ]]..var..[[.CollisionSize.Set(]]..(getVal("collisionSize", 1) * scaleFactor)..[[)]])
			end
			if getVal("gold", 1) then
				writeLine([[call ]]..var..[[.Drop.Supply.Set(]]..getVal("gold", 1)..[[)]])
			end
			if getVal("exp", 1) then
				writeLine([[call ]]..var..[[.Drop.Exp.Set(]]..getVal("exp", 1)..[[)]])
			end

			--hero
			if getVal("heroAbilities", 1) then
				local t = getVal("heroAbilities", 1):split(";")

				for k, v in pairs(t) do
					v = v:dequote()

					if v:find("{", 1, true) then
						local val = v:sub(1, v:find("{", 1, true) - 1)
						local level = v:sub(v:find("{", 1, true) + 1, v:len())

						level = level:sub(1, level:find("}", 1, true) - 1)

						writeLine([[call ]]..var..[[.Abilities.Hero.AddWithLevel(]]..toJassPath(path, val, "wc3spell")..[[, ]]..level..[[)]])
					else
						writeLine([[call ]]..var..[[.Abilities.Hero.Add(]]..toJassPath(path, v, "wc3spell")..[[)]])
					end
				end
			end
			if getVal("heroAgi", 1) then
				writeLine([[call ]]..var..[[.Hero.Agility.Set(]]..getVal("heroAgi", 1)..[[)]])
			end
			if getVal("heroAgiUp", 1) then
				writeLine([[call ]]..var..[[.Hero.Agility.PerLevel.Set(]]..getVal("heroAgiUp", 1)..[[)]])
			end
			if getVal("heroArmorUp", 1) then
				writeLine([[call ]]..var..[[.Hero.ArmorPerLevel.Set(]]..getVal("heroArmorUp", 1)..[[)]])
			end
			if getVal("heroInt", 1) then
				writeLine([[call ]]..var..[[.Hero.Intelligence.Set(]]..getVal("heroInt", 1)..[[)]])
			end
			if getVal("heroIntUp", 1) then
				writeLine([[call ]]..var..[[.Hero.Intelligence.PerLevel.Set(]]..getVal("heroIntUp", 1)..[[)]])
			end
			if getVal("heroStr", 1) then
				writeLine([[call ]]..var..[[.Hero.Strength.Set(]]..getVal("heroStr", 1)..[[)]])
			end
			if getVal("heroStrUp", 1) then
				writeLine([[call ]]..var..[[.Hero.Strength.PerLevel.Set(]]..getVal("heroStrUp", 1)..[[)]])
			end

			if getVal("abilities", 1) then
				local t = getVal("abilities", 1):split(";")

				for k, v in pairs(t) do
					v = v:dequote()

					if v:find("{", 1, true) then
						local val = v:sub(1, v:find("{", 1, true) - 1)
						local level = v:sub(v:find("{", 1, true) + 1, v:len())

						level = level:sub(1, level:find("}", 1, true) - 1)

						writeLine([[call ]]..var..[[.Abilities.AddWithLevel(]]..toJassPath(path, val, "wc3spell")..[[, ]]..level..[[)]])
					else
						writeLine([[call ]]..var..[[.Abilities.Add(]]..toJassPath(path, v, "wc3spell")..[[)]])
					end
				end
			end
		elseif (extension == "wc3dest") then
			if raw then
				writeLine([[set ]]..var..[[ = DestructableType.Create(']]..raw..[[')]])
			end
		elseif (extension == "wc3dood") then
		elseif (extension == "wc3bolt") then
			if (raw and raw ~= "") then
				writeLine([[set ]]..var..[[ = LightningType.Create(]]..raw:quote()..[[)]])
			else
				writeLine([[set ]]..var..[[ = LightningType.Create(null)]])
			end
		elseif (extension == "wc3weather") then
			if (raw and raw ~= "") then
				writeLine([[set ]]..var..[[ = WeatherType.Create(']]..raw..[[')]])
			else
				writeLine([[set ]]..var..[[ = WeatherType.Create(0)]])
			end
		elseif (extension == "wc3ubersplat") then
			if (raw and raw ~= "") then
				writeLine([[set ]]..var..[[ = UbersplatType.Create(]]..raw:quote()..[[)]])
			else
				writeLine([[set ]]..var..[[ = UbersplatType.Create(null)]])
			end
		elseif (extension == "wc3tile") then
			if (raw and raw ~= "") then
				writeLine([[set ]]..var..[[ = TileType.CreateFromSelf(']]..raw..[[')]])
			else
				writeLine([[set ]]..var..[[ = TileType.CreateFromSelf(0)]])
			end
		elseif (extension == "wc3sound") then
			writeLine([[set ]]..var..[[ = SoundType.Create()]])

			if getVal("filePath", 1) then
				writeLine([[call ]]..var..[[.SetFilePath(]]..toJassValue(getVal("filePath", 1))..[[)]])
			end

			if getVal("channel", 1) then
				writeLine([[call ]]..var..[[.SetChannel(SoundChannel.]]..getVal("channel", 1)..[[)]])
			end
			if getVal("eax", 1) then
				writeLine([[call ]]..var..[[.SetEax(SoundEax.]]..getVal("eax", 1)..[[)]])
			end
			if getVal("pitch", 1) then
				writeLine([[call ]]..var..[[.SetPitch(]]..getVal("pitch", 1)..[[)]])
			end
			if getVal("pitchVariance", 1) then
				writeLine([[call ]]..var..[[.SetPitchVariance(]]..getVal("pitchVariance", 1)..[[)]])
			end
			if getVal("priority", 1) then
				writeLine([[call ]]..var..[[.SetPriority(]]..getVal("priority", 1)..[[)]])
			end
			if getVal("volume", 1) then
				writeLine([[call ]]..var..[[.SetVolume(]]..getVal("volume", 1)..[[)]])
			end

			if getVal("fadeInRate", 1) then
				writeLine([[call ]]..var..[[.SetFadeIn(]]..getVal("fadeInRate", 1)..[[)]])
			end
			if getVal("fadeOutRate", 1) then
				writeLine([[call ]]..var..[[.SetFadeOut(]]..getVal("fadeOutRate", 1)..[[)]])
			end
			if getVal("looping", 1) then
				writeLine([[call ]]..var..[[.SetLooping(]]..tostring(getVal("looping", 1))..[[)]])
			end
			if getVal("stopping", 1) then
				writeLine([[call ]]..var..[[.SetStopping(]]..tostring(getVal("stopping", 1))..[[)]])
			end

			if getVal("is3d", 1) then
				writeLine([[call ]]..var..[[.Set3D(]]..tostring(getVal("is3d", 1))..[[)]])

				if getVal("minDist", 1) then
					writeLine([[call ]]..var..[[.SetMinDist(]]..getVal("minDist", 1)..[[)]])
				end
				if getVal("maxDist", 1) then
					writeLine([[call ]]..var..[[.SetMaxDist(]]..getVal("maxDist", 1)..[[)]])
				end
				if getVal("cutoffDist", 1) then
					writeLine([[call ]]..var..[[.SetCutoffDist(]]..getVal("cutoffDist", 1)..[[)]])
				end
			end

			if getVal("insideAngle", 1) then
				writeLine([[call ]]..var..[[.SetInsideAngle(]]..getVal("insideAngle", 1)..[[)]])
			end
			if getVal("outsideAngle", 1) then
				writeLine([[call ]]..var..[[.SetOutsideAngle(]]..getVal("outsideAngle", 1)..[[)]])
			end
			if getVal("outsideVolume", 1) then
				writeLine([[call ]]..var..[[.SetOutsideVolume(]]..getVal("outsideVolume", 1)..[[)]])
			end
			if getVal("orientationX", 1) then
				writeLine([[call ]]..var..[[.SetOrientationX(]]..getVal("orientationX", 1)..[[)]])
			end
			if getVal("orientationY", 1) then
				writeLine([[call ]]..var..[[.SetOrientationY(]]..getVal("orientationY", 1)..[[)]])
			end
			if getVal("orientationZ", 1) then
				writeLine([[call ]]..var..[[.SetOrientationZ(]]..getVal("orientationZ", 1)..[[)]])
			end
		end
	end

	if customFields then
		for field, val in pairs(customFields) do
			local jassType

			if (jassIdents and jassIdents[val]) then
				jassType = jassIdents[val]
			end

			if constFields[val] then
			else
				if fieldIsArray[val] then
					for level = 0, levelsAmount, 1 do
						local result = getVal(val, level)

						if result then
							writeLine("set thistype."..toJassName(val).."["..level.."] = "..toJassValue(result, jassType))
						end
					end
				else
					local result = getVal(val, 1)

					if result then
						writeLine("set thistype."..toJassName(val).." = "..toJassValue(result, jassType))
					end
				end
			end
		end
	end

	if ((varLinesC > 0) or (linesC > 0)) then
		if (targetPath == nil) then
			targetPath = folder.."obj_"..getFileName(path):gsub("%.", "_")..".j"
		else
			targetPath = getFolder(targetPath).."obj_"..getFileName(targetPath, true):gsub("%.", "_")..".j"
		end

		local t

		if generatedJs[targetPath] then
			t = generatedJs[targetPath]

			t.defCount = t.defCount + 1

			for i = 1, #varLines, 1 do
				t.varLines[#t.varLines + 1] = varLines[i]
			end
			for i = 1, #lines, 1 do
				t.lines[#t.lines + 1] = lines[i]
			end
		else
			t = {}

			t.defCount = 1
			t.extension = extension
			t.fileName = jassFileName
			t.varLines = copyTable(varLines)
			t.lines = copyTable(lines)

			generatedJs[targetPath] = t
		end

	end
end

function clearJs()
	for line in io.popen([[dir "..\Scripts\*obj_*.j" /b /s]]):lines() do
	    os.remove(line)
	end
	
	for line in io.popen([[dir "..\Scripts\*obj.j" /b /s]]):lines() do
	    os.remove(line)
	end
end

function initJs()
	clearJs()
end

function finalizeJs()
	print("finalize js")

	--obj imports
	local folderImports = {}

	for path, jData in pairs(generatedJs) do
		local folder = getScriptRallyPath(getFolder(path))

		if (folderImports[folder] == nil) then
			folderImports[folder] = {}
		end

		folderImports[folder][path] = path

		--
		local varLines = jData.varLines
		local lines = jData.lines

		local varLinesC

		if varLines then
			varLinesC = #varLines
		else
			varLinesC = 0
		end

		local linesC

		if lines then
			linesC = #lines
		else
			linesC = 0
		end

		local file = io.open(path, "w+")

		local finalLines = {}
		local finalLinesC = 0

		local function writeLine(s)
			finalLinesC = finalLinesC + 1
			finalLines[finalLinesC] = s
		end

		for i = 1, varLinesC, 1 do
			writeLine(varLines[i])
		end

		if ((varLinesC > 0) and (linesC > 0)) then
			writeLine("")
		end

		if (linesC > 0) then
			jData.hasInitMethod = true

			writeLine([[static method Init_obj_]]..getFileName(path, true):gsub("%.", "_"):trim("["):trim("]")..[[ takes nothing returns boolean]])

			--writeLine([[	local ObjThread t = ObjThread.Create(]]..toJassValue(path)..[[)]])

			for i = 1, linesC, 1 do
				writeLine(lines[i])
			end

			--writeLine([[	call t.Destroy()]])

			writeLine([[	return true]])

			writeLine([[endmethod]])
		end

		file:write(table.concat(finalLines, "\n"))

		file:close()
	end

	for folder in pairs(folderImports) do
		local file = io.open(folder..[[obj.j]], "w+")

		for k, imp in pairs(folderImports[folder]) do
			local impFile = io.open(imp, "r")

			if impFile then
				file:write("//open obj "..imp.."\n")

				for impFileLine in impFile:lines() do
					file:write(impFileLine.."\n")
				end

				impFile:close()

				file:write("//close obj "..imp.."\n\n")
			end
		end

		file:write("\nstatic method objInits_autoRun takes nothing returns nothing")

		for k, imp in pairs(folderImports[folder]) do
			local jData = generatedJs[imp]

			local extension = jData.extension
			local hasInitMethod = jData.hasInitMethod

			if (hasInitMethod and extension) then
				local function toJassValue(v, jassType)
					if (jassType == nil) then
						jassType = type(v)
					end
			
					if (jassType == "boolean") then
						return boolToString(v)
					end
					if (jassType == "string") then
						if isPlainText(v) then
							return v:doubleBackslashes():quote()
						end
					end
			
					return v
				end

				local path = toJassValue(imp)

				imp = getFileName(imp, true):gsub("%.", "_"):trim("["):trim("]")

				local paramsLine = "function thistype.Init_obj_"..imp..", "..path

				if (extension == "wc3spell") then
					file:write("\n    call Spell.AddInit("..paramsLine..")")
				elseif (extension == "wc3buff") then
					file:write("\n    call Buff.AddInit("..paramsLine..")")
				elseif (extension == "wc3item") then
					file:write("\n    call ItemType.AddInit("..paramsLine..")")
				elseif (extension == "wc3unit") then
					file:write("\n    call UnitType.AddInit("..paramsLine..")")
				elseif (extension == "wc3dest") then
					file:write("\n    call DestructableType.AddInit("..paramsLine..")")
				elseif (extension == "wc3bolt") then
					file:write("\n    call LightningType.AddInit("..paramsLine..")")
				elseif (extension == "wc3weather") then
					file:write("\n    call WeatherType.AddInit("..paramsLine..")")
				elseif (extension == "wc3ubersplat") then
					file:write("\n    call UbersplatType.AddInit("..paramsLine..")")
				elseif (extension == "wc3tile") then
					file:write("\n    call TileType.AddInit("..paramsLine..")")
				elseif (extension == "wc3sound") then
					file:write("\n    call SoundType.AddInit("..paramsLine..")")
				else
					file:write("\n    call Trigger.AddObjectInitNormal("..paramsLine..")")
				end
			end
		end

		file:write("\nendmethod")

		file:close()
	end

	--write output
	outputFile = io.open(OUTPUT_PATH..[[\war3mapAdd.j]], "w+")
	outputFileAdded = {}

	local loadingParts = 0

	function addJToOutput(path)	
		if ((getFileName(path):find("obj", 1, true) ~= 1) and (outputFileAdded[path] == nil)) then
			file = io.open(path)

			if (file == nil) then
			    	log:write(path.." does not exist")
			end

			if file then
				outputFileAdded[path] = true
			    	outputFile:write("\n//file: "..path.."\n")

				local nestType = {}
			        local foundImp = {}
			        local nestDepth = 0
		        	local prefix = ""

				for line in file:lines() do
					line = line:gsub("allocate%(%)", "allocCustom()")
					line = line:gsub("deallocate%(%)", "deallocCustom()")

					line = line:gsub("Event%.Create%(", "Event.Create(thistype.NAME, ")
				    	line = line:gsub("Event%.CreateLimit%(", "Event.CreateLimit(thistype.NAME, ")
					line = line:gsub("UnitList%.Create%(%)", "UnitList.Create(thistype.NAME)")
				    	line = line:gsub(" %/ ", " *1. / ")
				    	line = line:gsub(" div ", " / ")

					if line:find("//! runtextmacro Load(", 1, true) then
						loadingParts = loadingParts + 1
					end

					local startOfEventMethod, posEnd = line:find(" *eventMethod ")

					if startOfEventMethod then
						line = "static method "..line:sub(posEnd + 1, line:len()).." takes nothing returns nothing"
					else
						startOfEventMethod = line:find(" *static method *Event")
					end

				    	outputFile:write(line.."\n")

                                        if startOfEventMethod then
					    	outputFile:write("local EventResponse params = EventResponse.GetTrigger()".."\n")
					end

					local function tryAddMethod(line, mFile)
						local methodStart, methodEnd = line:find("static method ", 1, true)

						if (methodStart and line:find("takes nothing", methodEnd, true)) then
							local function toJassName(s)
								local result = ""

								for i = 1, s:len(), 1 do
									local c = s:sub(i, i)

									if (c == ".") then
										result = result..c
									elseif ((c >= 'A') and (c <= 'Z') and (i > 1)) then
										result = result.."_"..c
									else
										result = result..c:upper()
									end
								end

								return result
							end

							local methodPrefix = prefix

							methodPrefix = methodPrefix:gsub("%.struct", "")
							--methodPrefix = methodPrefix:gsub("\\", ".")

							local c = 1
							local t = methodPrefix:split("\\")

							methodPrefix = ""

							while t[c] do
								if t[c + 2] then
									methodPrefix = methodPrefix.."Folder"..t[c].."_"
								elseif t[c + 1] then
									if (c > 1) then
										methodPrefix = methodPrefix.."Struct"..t[c].."."
									else
										methodPrefix = methodPrefix..t[c].."."
									end
								end

								c = c + 1
							end

							--[[if (methodPrefix:find(".", 1, true) and methodPrefix:sub(methodPrefix:find(".", 1, true) + 1, methodPrefix:len()):find(".", 1, true)) then
								methodPrefix = toJassName(methodPrefix:sub(1, methodPrefix:find(".", 1, true) - 1))..methodPrefix:sub(methodPrefix:find(".", 1, true), methodPrefix:len())
							end]]

							if methodPrefix:find(".", 1, true) then
								methodEnd = methodEnd + 1

								local methodName = line:sub(methodEnd, line:find(" ", methodEnd, true) - 1)

								if (methodName:find("$", 1, true) == nil) then
									methods[methodPrefix..methodName] = methodName
									mFile:write("\n"..methodPrefix..methodName)
								end
							end
						end
					end

				    	if ((line:find("//", 1, true) == nil) or (line:find("//!", 1, true) and (line:find("///", 1, true) == nil))) then
					        local isFolder = line:find("//! runtextmacro Folder", 1, true)
					        local isStructLine = (line:find("//! runtextmacro BaseStruct", 1, true) or line:find("//! runtextmacro Struct", 1, true) or line:find("//! runtextmacro StaticStruct", 1, true) or line:find("//! runtextmacro NamedStruct", 1, true))

				        	if (isFolder or isStructLine) then
						        nestDepth = nestDepth + 1

						        local structName

						        if isFolder then
								nestType[nestDepth] = "folder"
						                structName = line:sub(line:find("(".."\"", 1, true) + 2, line:find(")") - 2)
					                elseif line:find("//! runtextmacro BaseStruct") then
								nestType[nestDepth] = "struct"
						                structName = line:sub(line:find("(".."\"", 1, true) + 2, line:find(",") - 2)
				                	else
								nestType[nestDepth] = "struct"
					                	structName = line:sub(line:find("(".."\"", 1, true) + 2, line:find(")") - 2)
			            			end

				            		if (nestDepth == 1) then
				            			structName = structName..".struct"
						        end

			                		prefix = prefix..structName..[[\]]

						        if ((foundImp[prefix] == nil) and isStructLine) then
							        local impPath = getFolder(path)..prefix.."obj.j"

							        local imp = io.open(impPath, "r")
							        foundImp[prefix] = true

							        if imp then
					                		outputFile:write(string.rep(" ", nestDepth * 4).."//import: "..impPath.."\n")

							                for impLine in imp:lines() do
								                outputFile:write(string.rep(" ", nestDepth * 4)..impLine.."\n")

										tryAddMethod(impLine, objMethodsFile)
							                end

							                imp:close()

							                outputFile:write(string.rep(" ", nestDepth * 4).."//end of import: "..impPath.."\n")
							        end
							end
						elseif (line:find("endstruct") or line:find("endscope")) then
							nestDepth = nestDepth - 1

							string.backFind = function(s, search)
								s = s:reverse()

								if (s:find(search) == nil) then
									return nil
								end

								return (s:len() - s:find(search) + 1)
							end

							if prefix:backFind("\\") then
								prefix = prefix:sub(1, prefix:backFind("\\") - 1)

								if (prefix:backFind("\\") == nil) then
									prefix = ""
								else
									prefix = prefix:sub(1, prefix:backFind("\\"))
								end
							end
						end
					end

					if (nestType[nestDepth] == "struct") then
						tryAddMethod(line, methodsFile)
					end
				end

				file:close()

				outputFile:write("\n//end of file: "..path.."\n")
			end
		end
	end

	methods = {}
	methodsFile = io.open([[..\Scripts\methods.txt]], "w+")
	objMethodsFile = io.open([[..\Scripts\objMethods.txt]], "w+")
	pathsFile = io.open([[..\Scripts\paths.txt]], "r")

	if pathsFile then
		local curIndent = -1
		local curPath = ""
	
		line = pathsFile:read()
	
		while line do
			local indent = 0

			while line:find("\t", 1, true) do
				indent = indent + 1

				line = line:sub(line:find("\t", 1, true) + 1)
			end

			if (indent <= curIndent) then
				for i = 1, (curIndent - indent + 1), 1 do
					curPath = curPath:sub(1, curPath:len() - 1)

					if lastFind(curPath, [[\]]) then
						curPath = curPath:sub(1, lastFind(curPath, [[\]]))
					else
						curPath = ""
					end
				end
			end

			if line:find(".j", 1, true) then
				addJToOutput([[..\Scripts\]]..curPath..line)
			end

			curIndent = indent
			curPath = curPath..line..[[\]]

			line = pathsFile:read()
		end

		pathsFile:close()
	end

	for line in io.popen([[dir "..\Scripts\*.j" /b /s]]):lines() do
		line = ".."..line:sub(line:find([[\Scripts\]], 1, true), line:len())

		addJToOutput(line)
	end

	methodsFile:close()
	objMethodsFile:close()

	local function writeLine(s)
		outputFile:write("\n"..s)
	end

	--close
	outputFile:close()

	--clearJs()
end

local replaceErrors = io.open("objectBuilderReplaceErrors.txt", "w+")

function replaceStuff(path, extension)
	require "Buff"

	local sharedBuffs = {}

	for level = 0, levelsAmount, 1 do
		sharedBuffs[level] = {}

		local t = getVal("sharedBuffs", level)

		if (type(t) == "string") then
			t = t:split(";")

			if (type(t) == "table") then
				for k, v in pairs(t) do
					sharedBuffs[level][k] = v
				end
			end
		end
	end

	--loadfile("TagReplacement.lua")(replaceErrors)
	require "Color"

	function replace(a, sub, rep)
		if (rep == nil) then
			rep = ""
		end

		while a:find(sub, 1, true) do
			a = a:sub(1, a:find(sub, 1, true) - 1)..rep..a:sub(a:find(sub, 1, true) + rep:len() + 1, a:len())
		end

		return a
	end

	function replaceTags(sourceField, b, lv, doColor, sourcePath)
		if (sourcePath == nil) then
			sourcePath = path
		end

	local a=tostring(b)
		--a = a:gsub("<level>", lv)
		--a = a:gsub("<prevLevel>", lv - 1)
--print("before", a)
		while a:findInner("<", ">") do
			local tagStart, tagEnd = a:findInner("<", ">")

			local isOuter = (a:find("<") == tagStart)

			local subbedPart = a:sub(tagStart + 1, tagEnd - 1)

			local replaceVal

			local field = subbedPart
			local targetPath
--print(sourceField, lv, field)
			if field:find(":", 1, true) then
				targetPath = pathToFullPath(sourcePath, field:sub(1, field:find(":", 1, true) - 1), "wc3obj")

				field = field:sub(field:find(":", 1, true) + 1, field:len())
			else
				targetPath = path
			end

			local mods = {}

			if field:find(",", 1, true) then
				mods = field:sub(field:find(",", 1, true) + 1, field:len()):split(",")

				field = field:sub(1, field:find(",", 1, true) - 1)
			end

			local lastChar = field:sub(field:len(), field:len())
			local level
			local pos = 1

			while tonumber(lastChar) do
				if (level == nil) then
					level = 0
				end

				level = level + tonumber(lastChar) * pos

				field = field:sub(1, field:len() - 1)

				lastChar = field:sub(field:len(), field:len())
				pos = pos + 1
			end

			if (level == nil) then
				level = lv
			end

			local obj = allObjVals[targetPath]

			if obj then
				if (obj[field] and (obj[field][level] or obj[field][1])) then
					local val

					if obj[field][level] then
						val = obj[field][level]
					else
						val = obj[field][1]
					end

					if (type(val) == "string") then
						if val:find("<level>") or val:find("<prevLevel>") then
							val = val:gsub("<level>", "<level,"..(level - lv)..">")
							val = val:gsub("<prevLevel>", "<prevLevel,"..(level - lv)..">")
						end
					end

					replaceVal = val
				elseif (field == "level") then
					replaceVal = lv
				elseif (field == "prevLevel") then
					replaceVal = lv - 1
				else
					--replaceErrors:write("\n\nin '"..path.."'\n\t".."cannot find field '"..field.."' ("..level..") of '"..targetPath.."'")
				end
			else
				if (targetPath == nil) then
					targetPath = "no targetPath"
				end

				--replaceErrors:write("\n\nin '"..path.."'\n\t".."cannot find obj '"..targetPath.."'")
			end

			local s

			if replaceVal then
				if ((type(replaceVal) == "string") and replaceVal:find("<.*>")) then
					replaceVal = replaceTags(sourceField, replaceVal, lv, false, targetPath)
				end

				local val = replaceVal

				local c = 1

				while mods[c] do						
					if (mods[c] == "%") then
						if tonumber(val) then
							val = tostring(val * 100).."%"
						end
					elseif (mods[c] == "-") then							
						if tonumber(val) then
							val = tostring(-tonumber(val))
						end
					elseif (tonumber(val) and tonumber(mods[c])) then
						val = tostring(tonumber(val) + tonumber(mods[c]))
					elseif ((mods[c] == "asSecs") and tonumber(val)) then
						local num = tonumber(val)

						if ((num == 1) or (num == -1)) then
							val = tostring(val).." second"
						else
							val = tostring(val).." seconds"
						end
					else
						local ops = {}

						ops["+"] = "+"
						ops["-"] = "-"
						ops["*"] = "*"
						ops["/"] = "/" 

						local op = ops[mods[c]:sub(1, 1)]
						local num = mods[c]:sub(2, mods[c]:len())

						if (tonumber(val) and op and tonumber(num)) then
							if (op == "+") then
								val = tostring(tonumber(val) + tonumber(num))
							elseif (op == "-") then
								val = tostring(tonumber(val) - tonumber(num))
							elseif (op == "*") then
								val = tostring(tonumber(val) * tonumber(num))
							elseif (op == "/") then
								val = tostring(tonumber(val) / tonumber(num))
							end
						end
					end

					c = c + 1
				end

				replaceVal = val

				s = replaceVal

				if (doColor == true) and isOuter and (sourceField ~= field) then
					s = engold(s)
				end
			else
				s = "§"..subbedPart.."$"

				if isOuter then
					s = engold(s)
				end
			end

			a = a:sub(1, tagStart - 1)..s..a:sub(tagEnd + 1, a:len())
		end

		a = a:gsub("§", "<")
		a = a:gsub("%$", ">")

		--a = a:gsub("<", "$")
		--a = a:gsub(">", "$")

		if sharedBuffs then
			if sharedBuffs[lv] then
				for key, buff in pairs(sharedBuffs[lv]) do
					local searchStart = "<"..buff..">"
					local searchEnd = "</"..buff..">"

					while a:find(searchStart, 1, true) do
						local tagStart = a:find(searchStart, 1, true)

						local tagEnd = a:find(searchEnd, tagStart, true)

						if tagEnd then
							a = a:sub(1, tagStart - 1)..encolor(a:sub(tagStart + searchStart:len(), tagEnd - 1), BUFF_COLOR[buff])..a:sub(tagEnd + searchEnd:len(), a:len())
						else
							a = a:sub(1, tagStart - 1)..encolor(a:sub(tagStart + searchStart:len(), a:len()), BUFF_COLOR[buff])
						end
					end

					a = a:gsub(searchEnd, "")
				end
			end
		end

		string.findlast = function(s, target)
			local pos = 0
			local posEnd
			local cap

			while s:find(target, pos + 1) do
				pos, posEnd, cap = s:find(target, pos + 1)
			end

			if (pos == 0) then
				return nil
			end

			return pos, posEnd, cap
		end

		local openingTagStart, openingTagEnd, params = a:findlast("<color=([A-Za-z0-9_%,]+)>")

		while openingTagStart do
			params = params:split(",")

			local colStart = params[1]
			local colEnd = params[2]

			assert(colStart, "no color specified")

			colStart = Color[colStart]

			assert(colStart, "color "..colStart:quote().." does not exist")

			if colEnd then
				colEnd = Color[colEnd]

				assert(colEnd, "color "..colEnd:quote().." does not exist")
			end

			local closingTagStart, closingTagEnd = a:find("</color>", openingTagEnd + 1, true)

			if (closingTagStart == nil) then
				closingTagStart = a:len()
				closingTagEnd = a:len()
			end

			local function redLen(s)
				local i = 1
				local len = 0

				while (i <= s:len()) do
					if (s:sub(i, i + Color.START:len() - 1) == Color.START) then
						i = i + Color.START:len() + 4 * 2 - 1
					else
						len = len + 1
					end

					i = i + 1
				end

				return len
			end

			local function gradPos(s, colorStart, colorEnd, pos)
				if (pos == 1) then
					return colorStart
				end
				if (pos == redLen(s)) then
					return colorEnd
				end

				local alphaStart = hex2Dec(colorStart:sub(1, 2))
				local redStart = hex2Dec(colorStart:sub(3, 4))
				local greenStart = hex2Dec(colorStart:sub(5, 6))
				local blueStart = hex2Dec(colorStart:sub(7, 8))

				local alphaEnd = hex2Dec(colorEnd:sub(1, 2))
				local redEnd = hex2Dec(colorEnd:sub(3, 4))
				local greenEnd = hex2Dec(colorEnd:sub(5, 6))
				local blueEnd = hex2Dec(colorEnd:sub(7, 8))

				local len = redLen(s)

				local alphaAdd = math.floor((alphaEnd - alphaStart) / len)
				local redAdd = math.floor((redEnd - redStart) / len)
				local greenAdd = math.floor((greenEnd - greenStart) / len)
				local blueAdd = math.floor((blueEnd - blueStart) / len)

				pos = pos - 1

				return dec2Hex(alphaStart + pos * alphaAdd)..dec2Hex(redStart + pos * redAdd)..dec2Hex(greenStart + pos * greenAdd)..dec2Hex(blueStart + pos * blueAdd)
			end

			local inter = a:sub(openingTagEnd + 1, closingTagStart - 1)

			if colEnd then
				local pos, posEnd = inter:find(Color.RESET)

				while pos do
					posRed = redLen(inter:sub(1, pos - 1)) + 1

					inter = inter:sub(1, pos - 1)..Color.START..gradPos(inter, colStart, colEnd, posRed)..inter:sub(posEnd + 1, inter:len())

					pos, posEnd = inter:find(Color.RESET)
				end
			else
				inter = inter:gsub(Color.RESET, Color.START..colStart)
			end

			a = a:sub(1, openingTagEnd)..inter..a:sub(closingTagStart, a:len())

			closingTagStart, closingTagEnd = a:find("</color>", openingTagEnd + 1, true)

			if (closingTagStart == nil) then
				closingTagStart = a:len()
				closingTagEnd = a:len()
			end

			local function grad(s, colorStart, colorEnd)
				if (colorEnd == nil) then
					return Color.START..colorStart..s..Color.RESET
				end

				local alphaStart = hex2Dec(colorStart:sub(1, 2))
				local redStart = hex2Dec(colorStart:sub(3, 4))
				local greenStart = hex2Dec(colorStart:sub(5, 6))
				local blueStart = hex2Dec(colorStart:sub(7, 8))

				local alphaEnd = hex2Dec(colorEnd:sub(1, 2))
				local redEnd = hex2Dec(colorEnd:sub(3, 4))
				local greenEnd = hex2Dec(colorEnd:sub(5, 6))
				local blueEnd = hex2Dec(colorEnd:sub(7, 8))

				local len = redLen(s)

				local alphaAdd = math.floor((alphaEnd - alphaStart) / len)
				local redAdd = math.floor((redEnd - redStart) / len)
				local greenAdd = math.floor((greenEnd - greenStart) / len)
				local blueAdd = math.floor((blueEnd - blueStart) / len)

				local result = ""

				local openingInterStart, openingInterEnd = s:find(Color.START.."........")

				if (openingInterStart == nil) then
					openingInterStart = s:len() + 1
				end

				for i = 1, openingInterStart - 1, 1 do
					if (i == 1) then
						result = result..Color.START..colorStart
					elseif (i == s:len()) then
						result = result..Color.START..colorEnd
					else
						result = result..Color.START..dec2Hex(alphaStart + (i - 1) * alphaAdd)..dec2Hex(redStart + (i - 1) * redAdd)..dec2Hex(greenStart + (i - 1) * greenAdd)..dec2Hex(blueStart + (i - 1) * blueAdd)
					end

					result = result..s:sub(i, i)
				end

				local closingInterStart
				local closingInterEnd

				if (openingInterStart <= s:len()) then
					closingInterStart, closingInterEnd = s:findlast(Color.START.."........", openingInterEnd + 1)
				end

				result = result..s:sub(openingInterStart, closingInterEnd)

				if closingInterStart then
					for i = closingInterEnd + 1, s:len(), 1 do
						if (i == 1) then
							result = result..Color.START..colorStart
						elseif (i == s:len()) then
							result = result..Color.START..colorEnd
						else
							result = result..Color.START..dec2Hex(alphaEnd - (s:len() - i) * alphaAdd)..dec2Hex(redEnd - (s:len() - i) * redAdd)..dec2Hex(greenEnd - (s:len() - i) * greenAdd)..dec2Hex(blueEnd - (s:len() - i) * blueAdd)
						end

						result = result..s:sub(i, i)
					end
				end

				return result
			end

			local inter = a:sub(openingTagEnd + 1, closingTagStart - 1)

			a = a:sub(1, openingTagStart - 1)..grad(inter, colStart, colEnd)..a:sub(closingTagEnd + 1, a:len())

			openingTagStart, openingTagEnd, params = a:findlast("<color=([A-Za-z0-9_,]+)>")
		end

		a = a:gsub(Color.RESET..Color.RESET, Color.RESET)
		a = a:gsub(Color.RESET..Color.START, Color.START)
		a = a:gsub(Color.START.."........"..Color.START, Color.START)

		--[[for col in pairs(Color) do
			local openingTagStart, openingTagEnd = a:find("<color="..col..">", 1, true)

			if openingTagStart then
				local closingTagStart, closingTagEnd = a:find("</color>", openingTagStart + 1, true)

				while closingTagStart do
					a = a:sub(1, openingTagStart - 1)..Color[col]..a:sub(openingTagEnd + 1, closingTagStart - 1)..Color.RESET..a:sub(closingTagEnd + 1, a:len())

					openingTagStart, openingTagEnd = a:find("<color="..col..">", 1, true)

					if openingTagStart then
						closingTagStart, closingTagEnd = a:find("</color>", openingTagStart + 1, true)
					else
						closingTagStart = nil
					end
				end
			end
		end]]

		local pos, posEnd = a:findInner("<", ">")

		if pos then
			local t = {}

			while pos do
				local subbedPart = a:sub(pos + 1, posEnd - 1)

				t[#t + 1] = subbedPart

				a = a:sub(1, pos - 1).."$"..subbedPart.."$"..a:sub(posEnd + 1, a:len())
	
				pos, posEnd = a:findInner("<", ">")
			end

			replaceErrors:write("\n\npath="..tostring(path))
			replaceErrors:write("\nsourceField="..tostring(sourceField))
			replaceErrors:write("\nlevel="..tostring(lv))
			replaceErrors:write("\ndoColor="..tostring(doColor))

			replaceErrors:write("\nbefore: "..tostring(b))
			replaceErrors:write("\nafter: "..tostring(a))

			replaceErrors:write("\ncould not replace: "..table.concat(t, ","))
		end

		if a:find("<") then
			a = a:gsub("<", "$")

			replaceErrors:write("\n\npath="..tostring(path))
			replaceErrors:write("\nsourceField="..tostring(sourceField))
			replaceErrors:write("\nlevel="..tostring(lv))
			replaceErrors:write("\ndoColor="..tostring(doColor))

			replaceErrors:write("\nbefore: "..tostring(b))
			replaceErrors:write("\nafter: "..tostring(a))

			replaceErrors:write("\ncontains unclosed tags")
		end

		return a
	end

	for level = 1, levelsAmount, 1 do
		local specials = getVal("specials", level)

		if specials then
			for k, v in pairs(specials) do
				if (type(v) == 'string') then
					getVal("specials")[level][k] = replaceTags("specials", v, level, false)
				end
			end
		end
	end

	if (dummy ~= true) then
	if (extension == "wc3spell") then
		for level = 1, levelsAmount, 1 do
			if (getVal("tooltip", level) == nil) then
				if getVal("name", level) then
					getVal("tooltip")[level] = encolor(getVal("name")[level], Color.DWC)
				end
			end

			if getVal("hotkey", level) then
				if (getVal("tooltip")[level] == nil) then
					getVal("tooltip")[level] = "("..engold(getVal("hotkey")[level])..") "
				else
					getVal("tooltip")[level] = "("..engold(getVal("hotkey")[level])..") "..getVal("tooltip")[level]
				end
			end
			if (levelsAmount > 1) then
				if (getVal("tooltip")[level] == nil) then
					getVal("tooltip")[level] = " ["..engold("Level "..level).."]"
				else
					getVal("tooltip")[level] = getVal("tooltip")[level].." ["..engold("Level "..level).."]"
				end
			end

			if (getVal("uberTooltip")[level] == nil) then
				getVal("uberTooltip")[level] = nil
			end

			if getVal("uberTooltip")[level] then
				getVal("uberTooltip")[level] = replaceTags("uberTooltip", getVal("uberTooltip")[level], level, true)
			end

			for key, buff in pairs(sharedBuffs[level]) do
				if (getVal("uberTooltip")[level] == nil) then
					getVal("uberTooltip")[level] = BUFF_DESCRIPTION[buff]
				else
					getVal("uberTooltip")[level] = getVal("uberTooltip")[level].."|n|n"..BUFF_DESCRIPTION[buff]
				end
			end

			if getVal("lore")[level] then
				if (getVal("uberTooltip")[level] == nil) then
					getVal("uberTooltip")[level] = engold(getVal("lore")[level])
				else
					getVal("uberTooltip")[level] = getVal("uberTooltip")[level].."|n|n"..engold(getVal("lore")[level])
				end
			end

			if getVal("cooldown")[level] then
				if (getVal("cooldown")[level] > 0) then
					if (getVal("uberTooltip")[level] == nil) then
						getVal("uberTooltip")[level] = encolor("Cooldown: "..engold(getVal("cooldown")[level]).." seconds", Color.DWC)
					else
						getVal("uberTooltip")[level] = getVal("uberTooltip")[level].."|n|n"..encolor("Cooldown: "..engold(getVal("cooldown")[level]).." seconds", Color.DWC)
					end
				end
			end

			if getVal("hero")[1] then
				if (getVal("learnTooltip")[level] == nil) then
					if getVal("name")[level] then
						getVal("learnTooltip")[level] = encolor(getVal("name")[level], Color.DWC)
					end

					if getVal("hotkey")[level] then
						if (getVal("learnTooltip")[level] == nil) then
							getVal("learnTooltip")[level] = "("..engold(getVal("hotkey")[level])..") "
						else
							getVal("learnTooltip")[level] = "("..engold(getVal("hotkey")[level])..") "..getVal("learnTooltip")[level]
						end
					end
					if (levelsAmount > 1) then
						if (getVal("learnTooltip")[level] == nil) then
							getVal("learnTooltip")[level] = " ["..engold("Level "..level).."]"
						else
							getVal("learnTooltip")[level] = getVal("learnTooltip")[level].." ["..engold("Level "..level).."]"
						end
					end

					if getVal("learnTooltip")[level] then
						getVal("learnTooltip")[level] = "Learn "..getVal("learnTooltip")[level]
					end
				end

				if getVal("learnTooltip")[level] then
					getVal("learnTooltip")[level] = replaceTags("learnTooltip", getVal("learnTooltip")[level], level, true)
				end
				if getVal("learnUberTooltip")[level] then
					getVal("learnUberTooltip")[level] = replaceTags("learnUberTooltip", getVal("learnUberTooltip")[level], level, true)

					if (level > 0) then
						if getVal("learnUberTooltipUpgrades", level) then
							local upgrades = getVal("learnUberTooltipUpgrades", level):split(";")

							local function addField(name, alias)
								if getVal(field, level) then
									upgrades[#upgrades + 1] = "{"..name..","..alias.."}"
								end
							end

							addField("{Area range,<areaRange>}")
							addField("{Channel time,<channelTime>}")
							addField("{Mana cost,<manaCost>}")
							addField("{Cast range,<range>}")

							if (#upgrades > 0) then
								local upgradesString = ""

								local i = 1

								while upgrades[i] do
									upgrades[i] = upgrades[i]:debracket("{", "}")

									local vals = upgrades[i]:splitOuter(",", {{"<", ">"}, {"{", "}"}})

									local alias = vals[1]
									local field = vals[2]

									local prevVal
									if (level > 1) then
										prevVal = replaceTags("learnUberTooltipUpgrades", field, level - 1, true)
									end
									local newVal = replaceTags("learnUberTooltipUpgrades", field, level, true)

									if (level == 1) then
										upgradesString = upgradesString.."|n\t"..alias..": "..newVal
									else
										if (prevVal ~= newVal) then
											upgradesString = upgradesString.."|n\t"..alias..": "..prevVal.." --> "..newVal
										end
									end

									--[[upgrades[i] = upgrades[i]:debracket("{", "}")

									local vals = upgrades[i]:split(",")

									local field = vals[1]
									local alias = vals[2]
									local mods

									if (field:sub(1, 1) == "{") then
										field = field.debracket("{", "}")
									end

									local prevVal = replaceTags("learnUberTooltipUpgrades", "<"..field..">", level - 1, true)
									local newVal = replaceTags("learnUberTooltipUpgrades", "<"..field..">", level, true)

									if (prevVal ~= newVal) then
										upgradesString = upgradesString.."|n\t"..alias..": "..prevVal.." --> "..newVal
									end]]

									i = i + 1
								end

								if (upgradesString:len() > 0) then
									if (level == 1) then
										getVal("learnUberTooltip")[level] = getVal("learnUberTooltip", level).."|n|n"..engold("First level stats:")..upgradesString
									else
										getVal("learnUberTooltip")[level] = getVal("learnUberTooltip", level).."|n|n"..engold("Next level:")..upgradesString
									end
								else
									--print(path)
									--os.execute("pause")
								end
							end
						end
					end
				end
			end
		end
	elseif (extension == "wc3buff") then
		for level = 1, levelsAmount, 1 do
			if (getVal("tooltip")[level] == nil) then
				if getVal("name")[level] then
					getVal("tooltip")[level] = getVal("name")[level]
				end
			end

			if getVal("tooltip")[level] then
				getVal("tooltip")[level] = replaceTags("tooltip", getVal("tooltip")[level], level, true)
			end
			if getVal("uberTooltip")[level] then
				getVal("uberTooltip")[level] = replaceTags("uberTooltip", getVal("uberTooltip")[level], level, true)
			end
		end
	elseif (extension == "wc3item") then
		if (getVal("tooltip")[1] == nil) then
			if getVal("name")[1] then
				getVal("tooltip")[1] = "Purchase "..encolor(getVal("name")[1], Color.DWC)
			end
		end

		if getVal("tooltip")[1] then
			getVal("tooltip")[1] = replaceTags("tooltip", getVal("tooltip")[1], 1, true)
		end
		if getVal("uberTooltip")[1] then
			getVal("uberTooltip")[1] = replaceTags("uberTooltip", getVal("uberTooltip")[1], 1, true)

			if getVal("usageGoldCost")[1] then
				if (getVal("usageGoldCost")[1] > 0) then
			                getVal("uberTooltip")[1] = getVal("uberTooltip")[1].."|n|n"..encolor("Usage Gold Cost: "..engold(getVal("usageGoldCost")[1]), Color.DWC)
				end
			end
		end
	elseif (extension == "wc3unit") then
		if (getVal("standardScale")[1] == nil) then
			getVal("standardScale")[1] = 1
		end
		if (getVal("tooltip")[1] == nil) then
			if getVal("name")[1] then
				if getVal("structure")[1] then
					if getVal("classes")[1] then
						local t = string.split(getVal("classes")[1], ";")

						if (t and tableContains(t, "UPGRADED")) then
							getVal("tooltip")[1] = "Upgrade to "
						end
					end

					if (getVal("tooltip")[1] == nil) then
						getVal("tooltip")[1] = "Build "
					end
				else
					getVal("tooltip")[1] = "Train "
				end

				if getVal("tooltip")[1] then
					getVal("tooltip")[1] = getVal("tooltip")[1]..getVal("name")[1]
				end
			end
		end

		if getVal("tooltip")[1] then
			getVal("tooltip")[1] = replaceTags("tooltip", getVal("tooltip")[1], 1, true)
		end
		if getVal("uberTooltip")[1] then
			getVal("uberTooltip")[1] = replaceTags("uberTooltip", getVal("uberTooltip")[1], 1, true)
		end
	elseif (extension == "wc3dest") then
	elseif (extension == "wc3dood") then
	elseif (extension == "wc3upgr") then
	end
	end

	for field, fieldData in pairs(levelVals) do
		if (field ~= "learnUberTooltipUpgrades") then
			if (type(fieldData) == "table") then
				for level, levelData in pairs(fieldData) do
					if ((type(level) == "number") and (type(levelData) == "string")) then
						levelVals[field][level] = replaceTags(field, levelData, level)
					end
				end
			end
		end
	end
end

objQueue = {}
rawsDeclared = {}

function processObjs()
	print("process objs")

	initJs()

	local c = 1

	local skins = {}

	while objQueue[c] do
		local path = objQueue[c]

		local v = allObjVals[path]

		log:write("create "..path)
		print("build "..path)

		local extension = allObjExtension[path]

		jassIdents = copyTable(allObjJassIdents[path])
		levelVals = copyTable(v)

		fieldIsArray = {}

		arrayFields = levelVals["arrayFields"]

		if arrayFields then
			for k2, v2 in pairs(arrayFields) do
				fieldIsArray[v2] = true
			end
		end

		customFields = levelVals["customFields"]
		dummy = getVal("dummy")
		raw = getVal("raw", 1)
		levelsAmount = getVal("levelsAmount", 1)
		if (levelsAmount == nil) then
			levelsAmount = 1
		end
		--sharedBuffs = getVal("sharedBuffs")

		--if (dummy ~= true) then
			replaceStuff(path, extension)
		--end

		if raw then
			rawsDeclared[raw] = raw
		end

		if (extension == "wc3spell") then
	    		createSpell(path)
		elseif (extension == "wc3buff") then
			createBuff(path)
		elseif (extension == "wc3item") then
	        	createItem(path)
		elseif (extension == "wc3unit") then
    			createUnit(path)
		elseif (extension == "wc3dest") then
			createDest(path)
		elseif (extension == "wc3dood") then
			createDoodad(path)
		elseif (extension == "wc3upgr") then
			createUpgrade(path)
		elseif (extension == "wc3skin") then
			skins[#skins + 1] = path
		elseif (extension == "wc3imp") then
			createImport(path)
		elseif (extension == "wc3bolt") then
			createLightning(path)
		elseif (extension == "wc3weather") then
			createWeather(path)
		elseif (extension == "wc3ubersplat") then
			createUbersplat(path)
		elseif (extension == "wc3tile") then
			createTile(path)
		elseif (extension == "wc3sound") then
			createSound(path)
		end

		buildJ(path, extension, getVal("jTargetPath"), dummy)

		c = c + 1
	end

	require 'lfs'

	local function loadfileFromDir(path, params)
		local folder = getFolder(path)
		local fileName = getFileName(path)

		local prevDir = lfs.currentdir()

		lfs.chdir(folder)

		loadfile([[starter.lua]])(unpack(params))

		lfs.chdir(prevDir)
	end

	loadfileFromDir([[SkinEdit\starter.lua]], {rootPath, buildPath, skins})

	finalizeJs()
end

rawDeclaredPath = {}

local defFile = io.open("defFile.txt", "w+")

function defObject(path, extension, refPath, vals, jassIdents)
	defFile:write("\n"..path)
	print("def "..path)

	local parentPath
	local raw

	if vals["raw"] then
		raw = vals["raw"][1]
	end

	if raw then
		parentPath = rawDeclaredPath[raw]
	end

	if parentPath then
		pathMap[path] = parentPath

		path = parentPath

		if vals["var"] then
			vals["var"][1] = allObjVals[path]["var"][1]
		end
	else
		pathMap[path] = path

		if raw then
			rawDeclaredPath[raw] = path
		end

		allObjExtension[path] = extension

		allObjJassIdents[path] = {}
		allObjVals[path] = {}

		objQueue[#objQueue + 1] = path
	end

	pathMap[refPath] = path

	local name

	if jassIdents then
		mergeTable(allObjJassIdents[path], copyTable(jassIdents))

		jassIdents = nil
	end
	if vals then
		name = vals["name"][1]

		local function splitList(s)
			local t2 = s:split(";")

			t = {}

			for k2, v2 in pairs(t2) do
				local sepPos = v2:find("=", 1, true)

				if sepPos then
					local val = v2:sub(sepPos + 1, v2:len())

					if (tobool(val) ~= nil) then
						val = tobool(val)
					elseif tonumber(val) then
						val = tonumber(val)
					end

					t[v2:sub(1, sepPos - 1)] = val
				else
					if (v2 ~= "") then
						t[v2] = v2
					end
				end
			end

			return t
		end

		local specials = vals["specials"]

		if specials then
			for level, val in pairs(specials) do
				vals["specials"][level] = splitList(val)
			end
		end

		local specialsTrue = vals["specialsTrue"]

		if specialsTrue then
			for level, val in pairs(specialsTrue) do
				vals["specialsTrue"][level] = splitList(val)
			end
		end

		if vals["arrayFields"] then
			vals["arrayFields"] = splitList(vals["arrayFields"])
		end
		if vals["customFields"] then
			vals["customFields"] = splitList(vals["customFields"])
		end

		mergeTable(allObjVals[path], copyTable(vals))

		vals = nil
	end

	if name then
		name = reduceName(name)

		if (allObjsByName[extension] == nil) then
			allObjsByName[extension] = {}
		end

		allObjsByName[extension][name] = path
	end
end

function finalize()
	processObjs()

	replaceErrors:close()

	print("merge data")
	--mergeData
	for obj in pairs(createdObjs) do
		local curObjType = obj.type

		local function setTrue(slk, field, level, val, rep, index)
			if (slk == "Profile") then
				if ((val == nil) or (val == "") or (val == [[""]])) then
					return
				end

				if (field == "Hotkey") then
					if (val:lower() == "esc") then
						val = 512
					end
				end

				if (type(val) == "string") then
					local t = {}

					t[1] = "Sellitems"
					t[2] = "Sellunits"
					t[3] = "Upgrade"
					t[4] = "animProps"
					t[5] = "Effectattach"
					t[6] = "Targetattach"

					if not tableContains(t, field) then
						val = val:quote()
					end
				end

				local function addProfileLine(index)
					if (obj.profile == nil) then
						obj.profile = {}

						obj.profile.indexRows = {}
					end

					local indexRow = obj.profile.indexRows[index]

					if (indexRow == nil) then
						indexRow = {}

						indexRow.fieldMaxLevel = {}
						indexRow.lines = {}

						obj.profile.indexRows[index] = indexRow

						if ((index > 1) and (obj.profile.indexRows[index - 1] == nil)) then
							addProfileLine(index - 1)
						end
					end

					if level then
						if indexRow.fieldMaxLevel[field] then
							if (level > indexRow.fieldMaxLevel[field]) then
								indexRow.fieldMaxLevel[field] = level
							end
						else
							indexRow.fieldMaxLevel[field] = level
						end

						if (indexRow.lines[field] == nil) then
							indexRow.lines[field] = {}
						end

						indexRow.lines[field][level] = val
					else
						indexRow.lines[field] = val
					end
				end

				addProfileLine(index)

				return
			end

			if level then
				field = field..string.rep("0", math.floor(math.log10(rep)) - math.floor(math.log10(level)))

				field = field..level
			end

			if obj.raw then
				slkObjSetField(slk, obj.raw, field, val)
			end
		end

		local function set(field, level, val)
			local fieldData = metaData[curObjType][field].vals

			if (headerDataContainsField(obj.type, field, level) ~= true) then
				if (obj.mods == nil) then
					if obj.baseRaw then
						objType[curObjType].ex.customObjs[obj] = obj
					else
						objType[curObjType].ex.origObjs[obj] = obj
					end

					obj.mods = {}
				end

				if level then
					if (obj.mods[field] == nil) then
						obj.mods[field] = {}
					end

					obj.mods[field][level] = val
				else
					obj.mods[field] = val
				end

				return
			end

			local slk = fieldData["slk"]

			if slkByName[slk] then
				slk = slkByName[slk]
			end

			local index = fieldData["index"]

			if (index == -1) then
				index = 0
			end

			setTrue(slk, fieldData["field"], level, val, fieldData["repeat"], index + 1)
		end

		for field, fieldData in pairs(obj.valsTrue) do
			for _, slk in pairs(objType[curObjType].slks) do
				if slk.fields[field] then
					if (type(fieldData) == "table") then
						local level = 1

						while fieldData[level] do
							setTrue(slk, field, level, fieldData[level])

							level = level + 1
						end
					else
						setTrue(slk, field, nil, fieldData)
					end
				end
			end
		end

		for field, fieldData in pairs(obj.vals) do
			if (type(fieldData) == "table") then
				local level = 1

				while fieldData[level] do
					set(field, level, fieldData[level])

					level = level + 1
				end
			else
				set(field, nil, fieldData)
			end
		end
	end

	print("write slks")
	--writeSlks
	for slk in pairs(slks) do
		writeSlk(slk, slk.path)
	end

	print("write profile")
	--profile
	local function createEmpty(path)
		local f = io.open(OUTPUT_PATH..[[\]]..path, "w+")

		if f then
			f:close()
		end
	end

	createEmpty([[Units\HumanAbilityFunc.txt]])
	createEmpty([[Units\HumanAbilityStrings.txt]])
	createEmpty([[Units\HumanUnitFunc.txt]])
	createEmpty([[Units\HumanUnitStrings.txt]])
	createEmpty([[Units\HumanUpgradeFunc.txt]])
	createEmpty([[Units\HumanUpgradeStrings.txt]])

	createEmpty([[Units\NightElfAbilityFunc.txt]])
	createEmpty([[Units\NightElfAbilityStrings.txt]])
	createEmpty([[Units\NightElfUnitFunc.txt]])
	createEmpty([[Units\NightElfUnitStrings.txt]])
	createEmpty([[Units\NightElfUpgradeFunc.txt]])
	createEmpty([[Units\NightElfUpgradeStrings.txt]])

	createEmpty([[Units\OrcAbilityFunc.txt]])
	createEmpty([[Units\OrcAbilityStrings.txt]])
	createEmpty([[Units\OrcUnitFunc.txt]])
	createEmpty([[Units\OrcUnitStrings.txt]])
	createEmpty([[Units\OrcUpgradeFunc.txt]])
	createEmpty([[Units\OrcUpgradeStrings.txt]])

	createEmpty([[Units\UndeadAbilityFunc.txt]])
	createEmpty([[Units\UndeadAbilityStrings.txt]])
	createEmpty([[Units\UndeadUnitFunc.txt]])
	createEmpty([[Units\UndeadUnitStrings.txt]])
	createEmpty([[Units\UndeadUpgradeFunc.txt]])
	createEmpty([[Units\UndeadUpgradeStrings.txt]])

	createEmpty([[Units\NeutralAbilityFunc.txt]])
	createEmpty([[Units\NeutralAbilityStrings.txt]])
	createEmpty([[Units\NeutralUnitFunc.txt]])
	createEmpty([[Units\NeutralUnitStrings.txt]])
	createEmpty([[Units\NeutralUpgradeFunc.txt]])
	createEmpty([[Units\NeutralUpgradeStrings.txt]])

	createEmpty([[Units\CampaignUnitFunc.txt]])
	createEmpty([[Units\CampaignUnitStrings.txt]])

	createEmpty([[Units\CommandFunc.txt]])
	createEmpty([[Units\CommandStrings.txt]])

	createEmpty([[Units\CommonAbilityFunc.txt]])
	createEmpty([[Units\CommonAbilityStrings.txt]])

	createEmpty([[Units\ItemAbilityFunc.txt]])
	createEmpty([[Units\ItemAbilityStrings.txt]])
	createEmpty([[Units\ItemFunc.txt]])
	createEmpty([[Units\ItemStrings.txt]])

	local profileFile = io.open(OUTPUT_PATH..[[\Units\HumanUnitFunc.txt]], "w+")

	for obj in pairs(createdObjs) do
		if obj.profile and obj.profileIdent then
			profileFile:write("\n["..obj.profileIdent.."]")

			local index = 1

			while obj.profile.indexRows[index] do
				local indexRow = obj.profile.indexRows[index]

				for field, val in pairs(indexRow.lines) do
					if (type(val) == "table") then
						for level = 1, indexRow.fieldMaxLevel[field], 1 do
							profileFile:write("\n"..field.."="..val[level])
						end
					else
						profileFile:write("\n"..field.."="..val)
					end
				end

				index = index + 1
			end
		end
	end

	profileFile:close()

	print("write ex")
	--writeExObjs
	local objTypeForEx = {}

	for k, v in pairs(objType) do
		if v.ex then
			objTypeForEx[k] = v
		end
	end

	for _, curObjType in pairs(objTypeForEx) do
		local curFile = curObjType.ex.file

		local function writeInt(val)
			for i = 0, 3, 1 do
				curFile:write(string.char(math.floor(val % math.pow(256, i + 1) / math.pow(256, i))))
			end
		end

		local function writeId(val)
			curFile:write(val)
		end

		local function writeReal(val)
			if (val == 0) then
				curFile:write(string.char(0)..string.char(0)..string.char(0)..string.char(0))

				return
			end

			if (val < 0) then
				sign = "1"
				val = -val
			else
				sign = "0"
			end

			local int = math.floor(val)

			local frac = val - int

			local exp = -1
			local tmp = ""

			while (int ~= 0) do
				tmp = tmp..(int % 2)

				int = math.floor(int / 2)
				exp = exp + 1
			end

			int = tmp:reverse()

			local tmp = ""

			local i = 1

			while (i <= 23 - exp) do
				frac = frac * 2
				if (i == 23 - exp) then
					tmp = tmp..math.floor(frac + 0.5)
				else
					tmp = tmp..math.floor(frac)
				end

				frac = frac - math.floor(frac)
				i = i + 1
			end

			frac = int:sub(int:len() - exp + 1, int:len())..tmp

			exp=exp + 127

			local tmp = ""

			local i = 1

			while (i <= 8) do
				tmp = tmp..(exp % 2)

				exp = math.floor(exp / 2)

				i = i + 1
			end

			exp = tmp:reverse()

			val = sign..exp..frac

			for i=3, 0, -1 do
				local function bin2Dec(para)
					local result = 0
					local mult = 1
					local i = 1

					while (i <= para:len()) do
						result = result + tonumber(para:sub(i, i)) * mult

						i = i + 1
						mult = mult * 2
					end

					return result
				end

				local dec = bin2Dec(val:sub(i * 8 + 1, i * 8 + 8):reverse())

				curFile:write(string.char(dec))
			end
		end

		local function writeUnreal(val)
			writeReal(val)
		end

		local function writeString(val)
			curFile:write(val..string.char(0))
		end

		local function addMods(obj)
			local function addSingle(field, level, val)
				writeId(field)
				local fieldData = metaData[curObjType.name][field].vals

				local t = {}

				t["bool"] = 0
				t["int"] = 0
				t["real"] = 1
				t["unreal"] = 2
				t["string"] = 3

				t["channelType"] = 0
				t["channelFlags"] = 0

				local varType = t[fieldData["type"]]

				if varType then
					writeInt(varType)
				else
					writeInt(3)
				end

				if curObjType.ex.usesLevels then
					writeInt(level)

					local dataNumber = fieldData["data"]

					if dataNumber then
						writeInt(dataNumber)
					else
						writeInt(0)
					end
				end

				if (varType == 0) then
					if (type(val) == "boolean") then
						print(field, val, type(val))
						os.execute("pause")
						if (val == true) then
							val = 1
						else
							val = 0
						end
					elseif (type(val) == "string") then
						print(field, val, type(val))
						os.execute("pause")
						if (val == "true") then
							val = 1
						elseif (val == "false") then
							val = 0
						end
					end

					writeInt(val)
				elseif (varType == 1) then
					writeReal(val)
				elseif (varType == 2) then
					writeUnreal(val)
				else
					writeString(val)
				end
				writeInt(0)
			end

			local function addField(field, val)
				if (type(val) == "table") then
					for level, levelVal in pairs(val) do
						addSingle(field, level, levelVal)
					end
				else
					addSingle(field, 0, val)
				end
			end

			writeInt(getTableSize(obj.mods, true))

			for field, val in pairs(obj.mods) do
				addField(field, val)
			end
		end

		writeInt(curObjType.ex.fileVersion)

		local origObjs = curObjType.ex.origObjs
		local count = 0

		for _, obj in pairs(origObjs) do
			if (obj.raw and obj.mods) then
				count = count + 1
			end
		end

		--writeInt(getTableSize(origObjs))
		writeInt(count)

		for _, obj in pairs(origObjs) do
			if (obj.raw and obj.mods) then
				writeId(obj.raw)

				writeInt(0)

				addMods(obj)
			end
		end

		local customObjs = curObjType.ex.customObjs

		writeInt(getTableSize(customObjs))

		for _, obj in pairs(customObjs) do
			if (obj.baseRaw and obj.raw) then
				writeId(obj.baseRaw)

				writeId(obj.raw)

				addMods(obj)
			end
		end

		curFile:close()
	end

	logFile:close()
end

print("inputPath=", input)
loadfile(input)()

finalize()

local clockD = os.clock() - clock

--
rootPath=[[D:\Warcraft III\Mapping\DWC\Scripts]]
buildPath=[[D:\Warcraft III\Mapping\DWC\compiler\Build]]

if (rootPath and buildPath) then
	local outputFile = io.open(rootPath..[[\war3mapWEplacements.j]], "w+")

	local binDir = [[D:\Warcraft III\Mapping\DWC\Tools\wc3binary2]]

	require "lfs"

	lfs.chdir(binDir)

	require "wc3binaryFile"
	require "wc3binaryMaskFuncs"

	--local f = io.open(buildPath..[[\war3mapUnits.doo]], "r")
	local war3mapUnits = wc3binaryFile.create()
	local war3mapRects = wc3binaryFile.create()

	war3mapUnits:readFromFile(buildPath..[[\war3mapUnits.doo]], dooUnitsMaskFunc)
	war3mapRects:readFromFile(buildPath..[[\war3map.w3r]], rectMaskFunc)

	local lines = {}
	
	table.insert(lines, "struct preplaced")
	
	table.insert(lines, "implement Allocation")
	table.insert(lines, "implement List")
	
	for i = 1, war3mapUnits:getVal("unitsCount"), 1 do
		local unit = war3mapUnits:getSub("unit"..i)

		local editorID = unit:getVal("editorID")

		table.insert(lines, "static thistype unit_"..editorID)
	end
	
	table.insert(lines, "boolean enabled")
	table.insert(lines, "integer ownerIndex")
	table.insert(lines, "integer typeId")
	table.insert(lines, "real x")
	table.insert(lines, "real y")
	table.insert(lines, "real angle")
	table.insert(lines, "thistype waygateTarget")

	table.insert(lines, [[//! runtextmacro CreateList("UNITS")]])
	
	table.insert(lines, "static method createUnit takes boolean enabled, integer typeId, integer ownerIndex, real x, real y, real angle, thistype waygateTarget returns thistype")
	table.insert(lines, "local thistype this = thistype.allocate()")

	table.insert(lines, "set this.enabled = enabled")
	table.insert(lines, "set this.ownerIndex = ownerIndex")
	table.insert(lines, "set this.typeId = typeId")
	table.insert(lines, "set this.x = x")
	table.insert(lines, "set this.y = y")
	table.insert(lines, "set this.angle = angle")
	table.insert(lines, "set this.waygateTarget = waygateTarget")
	
	table.insert(lines, "call thistype.UNITS_Add(this)")
	
	table.insert(lines, "return this")
	table.insert(lines, "endmethod")
	
	table.insert(lines, "static method initUnits")
	
	for i = 1, war3mapUnits:getVal("unitsCount"), 1 do
		local unit = war3mapUnits:getSub("unit"..i)

		local enabled = toJassValue(unit:getVal("targetAcquisition") ~= -2)
		local typeId = unit:getVal("type")
		local ownerIndex = unit:getVal("ownerIndex")
		local x = unit:getVal("x")
		local y = unit:getVal("y")
		local angle = string.format("%.3f", unit:getVal("angle"))
		local waygateTargetIndex = unit:getVal("waygateTargetRectIndex")
		local editorID = unit:getVal("editorID")

		local waygateTarget = "NULL"

		if (waygateTargetIndex > -1) then
			local rectNum = 1
			local rectCount = war3mapRects:getVal("rectsCount")

			while ((rectNum <= rectCount) and (war3mapRects:getSub("rect"..rectNum):getVal("index") ~= waygateTargetIndex)) do
				rectNum = rectNum + 1
			end

			if (rectNum <= rectCount) then
				waygateTarget = "rect_"..war3mapRects:getSub("rect"..rectNum):getVal("name"):gsub(" ", "_")
			end
		end

		local t = {}

		table.insert(t, enabled)
		table.insert(t, "'"..typeId.."'")
		table.insert(t, ownerIndex)
		table.insert(t, x)
		table.insert(t, y)
		table.insert(t, angle)
		table.insert(t, waygateTarget)

		table.insert(lines, "set thistype.unit_"..editorID.." = thistype.createUnit("..table.concat(t, ", ")..")")
	end

	table.insert(lines, "endmethod")

	for i = 1, war3mapRects:getVal("rectsCount"), 1 do
		local unit = war3mapRects:getSub("rect"..i)

		local editorID = unit:getVal("name"):gsub(" ", "_")

		table.insert(lines, "static thistype rect_"..editorID)
	end

	table.insert(lines, "real minX")
	table.insert(lines, "real minY")
	table.insert(lines, "real maxX")
	table.insert(lines, "real maxY")

	table.insert(lines, [[//! runtextmacro CreateList("RECTS")]])

	table.insert(lines, "static method createRect takes real minX, real maxX, real minY, real maxY returns thistype")
	table.insert(lines, "local thistype this = thistype.allocate()")

	table.insert(lines, "set this.minX = minX")
	table.insert(lines, "set this.maxX = maxX")
	table.insert(lines, "set this.minY = minY")
	table.insert(lines, "set this.maxY = maxY")
	table.insert(lines, "set this.x = (minX + maxX) / 2")
	table.insert(lines, "set this.y = (minY + maxY) / 2")

	table.insert(lines, "call this.RECTS_Add(this)")
	
	table.insert(lines, "return this")
	table.insert(lines, "endmethod")

	table.insert(lines, "static method initRects")
	
	for i = 1, war3mapRects:getVal("rectsCount"), 1 do
		local rect = war3mapRects:getSub("rect"..i)

		local minX = rect:getVal("minX")
		local maxX = rect:getVal("maxX")
		local minY = rect:getVal("minY")
		local maxY = rect:getVal("maxY")
		local name = rect:getVal("name"):gsub(" ", "_")

		local t = {}

		table.insert(t, minX)
		table.insert(t, maxX)
		table.insert(t, minY)
		table.insert(t, maxY)

		table.insert(lines, "set thistype.rect_"..name.." = thistype.createRect("..table.concat(t, ", ")..")")
	end

	table.insert(lines, "endmethod")

	table.insert(lines, "endstruct")

	outputFile:write(table.concat(lines, "\n"))

	outputFile:close()
end

print("finished in "..clockD.." seconds")