BUTTON_POS_X = {}

BUTTON_POS_X["ARTIFACT"] = "1"
BUTTON_POS_X["HERO_FIRST"] = "0"
BUTTON_POS_X["HERO_SECOND"] = "1"
BUTTON_POS_X["HERO_ULTIMATE"] = "2"
BUTTON_POS_X["HERO_ULTIMATE_EX"] = "3"
BUTTON_POS_X["NORMAL"] = "0"
BUTTON_POS_X["PURCHASABLE"] = "2"

BUTTON_POS_Y = {}

BUTTON_POS_Y["ARTIFACT"] = "1"
BUTTON_POS_Y["HERO_FIRST"] = "2"
BUTTON_POS_Y["HERO_SECOND"] = "2"
BUTTON_POS_Y["HERO_ULTIMATE"] = "2"
BUTTON_POS_Y["HERO_ULTIMATE_EX"] = "2"
BUTTON_POS_Y["NORMAL"] = "2"
BUTTON_POS_Y["PURCHASABLE"] = "1"

HOTKEY = {}

HOTKEY["ARTIFACT"] = "F"
HOTKEY["HERO_FIRST"] = "Q"
HOTKEY["HERO_SECOND"] = "W"
HOTKEY["HERO_ULTIMATE"] = "E"
HOTKEY["HERO_ULTIMATE_EX"] = "R"
HOTKEY["NORMAL"] = "Q"
HOTKEY["PURCHASABLE"] = "T"

IS_HERO_SPELL = {}

IS_HERO_SPELL["HERO_FIRST"] = true
IS_HERO_SPELL["HERO_SECOND"] = true
IS_HERO_SPELL["HERO_ULTIMATE"] = true
IS_HERO_SPELL["HERO_ULTIMATE_EX"] = true
IS_HERO_SPELL["PURCHASABLE"] = true

LEARN_BUTTON_POS_X = {}

LEARN_BUTTON_POS_X["HERO_FIRST"] = "0"
LEARN_BUTTON_POS_X["HERO_SECOND"] = "1"
LEARN_BUTTON_POS_X["HERO_ULTIMATE"] = "2"
LEARN_BUTTON_POS_X["HERO_ULTIMATE_EX"] = "3"
LEARN_BUTTON_POS_X["PURCHASABLE"] = "0"

LEARN_BUTTON_POS_Y = {}

LEARN_BUTTON_POS_Y["HERO_FIRST"] = "0"
LEARN_BUTTON_POS_Y["HERO_SECOND"] = "0"
LEARN_BUTTON_POS_Y["HERO_ULTIMATE"] = "0"
LEARN_BUTTON_POS_Y["HERO_ULTIMATE_EX"] = "0"
LEARN_BUTTON_POS_Y["PURCHASABLE"] = "1"

LEARN_HOTKEY = {}

LEARN_HOTKEY["ARTIFACT"] = "F"
LEARN_HOTKEY["HERO_FIRST"] = "Q"
LEARN_HOTKEY["HERO_SECOND"] = "W"
LEARN_HOTKEY["HERO_ULTIMATE"] = "E"
LEARN_HOTKEY["HERO_ULTIMATE_EX"] = "R"
LEARN_HOTKEY["NORMAL"] = "Q"
LEARN_HOTKEY["PURCHASABLE"] = "T"

LEARN_SLOT = {}

LEARN_SLOT["HERO_FIRST"] = "0"
LEARN_SLOT["HERO_SECOND"] = "1"
LEARN_SLOT["HERO_ULTIMATE"] = "2"
LEARN_SLOT["HERO_ULTIMATE_EX"] = "3"
LEARN_SLOT["PURCHASABLE"] = "4"

LEARN_PREFIX = {}

LEARN_PREFIX[0] = "F"
LEARN_PREFIX[1] = "G"
LEARN_PREFIX[2] = "H"
LEARN_PREFIX[3] = "J"
LEARN_PREFIX[4] = "K"

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

function trimString(s, rem)
    while s:find(rem, 1, true) do
        s = s:sub(1, s:find(rem, 1, true) - 1)..s:sub(s:find(rem, 1, true) + 1)
    end

    return s
end

function updateFile(path, jPrefix)
    local extension = path:sub(path:find(".wc3", 1, true) + 1)
    local folder = ""
    local line = path:sub(1, path:find(".wc3", 1, true) - 1)
    local maxX = nil
    local maxY = nil
    local table = {}

    while (string.find(line, "\\") ~= nil) do
        folder = folder..string.sub(line, 1, string.find(line, "\\"))
        line = string.sub(line, string.find(line, "\\") + 1)
    end

    local file = nil
    local fileName = line

	local function loadSlk(path)
	    file = io.open(path..".slk", "r")
	
	    repeat
	        line = file:read()
	
	        if (line ~= nil) then
	            if (string.sub(line, 1, 2) == "B;") then
	                line = string.sub(line, 3)
	
	                maxY = tonumber(string.sub(line, 2, string.find(line, ";") - 1))
	
	                line = string.sub(line, string.find(line, ";") + 1)
	
	                maxX = tonumber(string.sub(line, 2, string.find(line, ";") - 1))
	            end
	        end
	    until (maxX ~= nil)
	
	    local curX = 1
	    local curY = 1
	
	    for y = 1, maxY, 1 do
	        table[y] = {}
	    end

		function dequote(s)
		    i = 1
		
		    while i <= s:len() do
		        if (s:sub(i, i) == "\"") then
		            s = s:sub(1, i - 1)..s:sub(i + 1)
		        else
		            i = i + 1
		        end
		    end
		
		    return s
		end

	    for line in file:lines() do
	        if (line ~= nil) then
	            if ((string.sub(line, 1, 2) == "C;") or (string.sub(line, 1, 2) == "F;")) then
	                line = string.sub(line, 3)
	
	                tmpX = nil
	                tmpY = nil
	
	                while ((string.sub(line, 1, 1) ~= "X") and (string.sub(line, 1, 1) ~= "Y") and (string.sub(line, 1, 1) ~= "K") and (string.find(line, ";") ~= nil)) do
	                    line = string.sub(line, string.find(line, ";") + 1)
	                end
	
	                if (string.sub(line, 1, 1) == "Y") then
	                    if (string.find(line, ";") == nil) then
	                        tmpY = tonumber(string.sub(line, 2))
	                    else
	                        tmpY = tonumber(string.sub(line, 2, string.find(line, ";") - 1))
	
	                        line = string.sub(line, string.find(line, ";") + 1)
	                    end
	                end
	
	                if (string.sub(line, 1, 1) == "X") then
	                    if (string.find(line, ";") == nil) then
	                        tmpX = tonumber(string.sub(line, 2))
	                    else
	                        tmpX = tonumber(string.sub(line, 2, string.find(line, ";") - 1))
	
	                        line = string.sub(line, string.find(line, ";") + 1)
	                    end
	                end
	
	                if (tmpY ~= nil) then
	                    curY = tmpY
	                    curX = 1
	                end
	
	                if (tmpX ~= nil) then
	                    curX = tmpX
	                end
	
	                if (string.sub(line, 1, 1) == "K") then
	                    line = string.sub(line, 2)
	
	                    if (tonumber(line) == nil) then
	                        if ((string.sub(line, 1, 1) == "\"") and (string.sub(line, string.length(line), string.length(line)) == "\"")) then
	                            line = string.sub(line, 2, string.length(line) - 1)
	                        end
	                    else
	                        line = tonumber(line)
	                    end
	
	                    table[curY][curX] = line
	
	                    if (curX == maxX) then
	                        curX = 1
	                        curY = curY + 1
	                    else
	                        curX = curX + 1
	                    end
	                end
	            end
	        end
	    end
	
	    file:close()
	end
	
	local function loadTxt(path)
	    file = io.open(path..".txt", "r")
	
	    local curY = 0
	
	    for line in file:lines() do
	        if (line ~= nil) then
	            local curX = 0
	            curY = curY + 1
	
	            table[curY] = {}
	
	            repeat
	                curX = curX + 1
	
	                if ((maxX == nil) or (curX > maxX)) then
	                    maxX = curX
	                end
	
	                if (string.find(line, "\t") == nil) then
	                    if ((line ~= nil) and (line ~= "")) then
		                    if (tonumber(line) == nil) then
		                        table[curY][curX] = line
		                    else
		                        table[curY][curX] = tonumber(line)
		                    end
	                    end
	
	                    line = nil
	                else
	                    val = string.sub(line, 1, string.find(line, "\t") - 1)
	
	                    if ((val ~= nil) and (val ~= "")) then
	                        if (tonumber(val) == nil) then
	                            table[curY][curX] = val
	                        else
	                            table[curY][curX] = tonumber(val)
	                        end
	                    end
	
	                    line = string.sub(line, string.find(line, "\t") + 1)
	                end
	            until (line == nil)
	        end
	    end
	
	    file:close()
	    maxY = curY
	end
	
    string.doubleBackslashes = function(s)
        --[[local i = string.len(s)

        while (i >= 1) do
            if (string.sub(s, i, i) == "\\") then
                s = string.sub(s, 1, i).."\\"..string.sub(s, i + 1)
            end

            i = i - 1
        end

        return s]]
        return string.gsub(s, "\\", "\\\\")
    end
	
	string.split = function(s, delimiter)
	    local results = {}
	    local resultsCount = 0
	    
	    while (s:find(delimiter) ~= nil) do
	        resultsCount = resultsCount + 1
	
	        results[resultsCount] = s:sub(1, s:find(delimiter) - 1)
	
	        s = s:sub(s:find(delimiter) + 1)
	    end
	
	    resultsCount = resultsCount + 1
	
	    results[resultsCount] = s
	
	    return results
	end
	
	local function loadWc3Obj(path)
	    file = io.open(path, "r")
	
	    local curY = 0
	
	    for line in file:lines() do
	        if (line ~= nil) then
	            local curX = 0
	            curY = curY + 1
	
	            table[curY] = {}
	
	            for i,s in pairs(line:split("\t")) do
	                curX = curX + 1
	
	                if ((maxX == nil) or (curX > maxX)) then
	                    maxX = curX
	                end
	
	                if (tonumber(s) == nil) then
	                    table[curY][curX] = s
	                else
	                    table[curY][curX] = tonumber(s)
	                end
	            end
	        end
	    end
	
	    file:close()
	    maxY = curY
	end

print("load "..fileName.." at "..folder)
    loadWc3Obj(path)

    --[[for y = 1, maxY, 1 do
        s = ""
        for x = 1, maxX, 1  do
            if (table[y][x] == nil) then
                s = s.."nil".."|"
            else
                s = s..table[y][x].."|"
            end
        end

        print(s)

        print("---")
    end]]

    local levelVals = {}
    local vals = {}

    for y = 1, maxY, 1 do
        local field = table[y][1]

        if ((field ~= nil) and (field ~= "")) then
            vals[field] = {}
            levelVals[field] = {}

            for x = 2, maxX, 1 do
                vals[field][x - 1] = table[y][x]

                if (x > 2) then
                    levelVals[field][x - 2] = vals[field][x - 1]
                end
            end
        end
    end

    local function getVal(field)
        return levelVals[field]
    end

	if (extension == ".wc3spell") then
	    local class
	    local isDefaultField = {}
	    local isHeroSpell
	    local isNewSpell = (levelVals["raw"] ~= nil)
	    local levelsAmount = maxX - 2
	
		local function setDefaultValue(field, val)
		    isDefaultField[field] = true
		    if ((levelVals[field] == nil) or (levelVals[field][1] == nil)) then
		        levelVals[field] = {}
		
		        levelVals[field][1] = val
		    end
		end
	
	    if (isNewSpell) then
	    	setDefaultValue("field", "")
	
		    setDefaultValue("name", "")
		    setDefaultValue("raw", "")
		
		    setDefaultValue("base", "NORMAL")
		    setDefaultValue("class", "NORMAL")
		
		    class = getVal("class")[1]
		
		    isHeroSpell = IS_HERO_SPELL[class]
	
		    setDefaultValue("levelsAmount", LEVELS_AMOUNT[class])
		    setDefaultValue("order", ORDER[getVal("base")])
		    setDefaultValue("target", TARGET[getVal("base")])
		
		    levelsAmount = getVal("levelsAmount")[1]
		
		    setDefaultValue("animation", "spell")
		    setDefaultValue("areaRange", 0)
		    setDefaultValue("areaRangeDisplay", false)
		    setDefaultValue("castTime", 0)
		    setDefaultValue("channelTime", 0)
		    setDefaultValue("cooldown", 0)
		    setDefaultValue("manaCost", 0)
		    setDefaultValue("range", 750)
		    setDefaultValue("targets", nil)
		
		    setDefaultValue("buttonPosX", BUTTON_POS_X[class])
		    setDefaultValue("buttonPosY", BUTTON_POS_Y[class])
		    setDefaultValue("hotkey", HOTKEY[class])
		    setDefaultValue("icon", nil)
		    setDefaultValue("lore", nil)
		    setDefaultValue("sharedBuffs", nil)
		    setDefaultValue("tooltip", nil)
		    setDefaultValue("uberTooltip", nil)
		
		    if (isHeroSpell) then
		        setDefaultValue("learnButtonPosX", LEARN_BUTTON_POS_X[class])
		        setDefaultValue("learnButtonPosY", LEARN_BUTTON_POS_Y[class])
		        setDefaultValue("learnHotkey", HOTKEY[class])
		        setDefaultValue("learnIcon", getVal("icon")[1])
		        setDefaultValue("learnPrefix", LEARN_PREFIX[class])
		        setDefaultValue("learnRaw", string.sub(getVal("raw")[1], 2, 3))
		        setDefaultValue("learnSlot", LEARN_SLOT[class])
		        setDefaultValue("learnTooltip", nil)
		        setDefaultValue("learnUberTooltip", nil)
		    end
	    end
	elseif (extension == ".wc3buff") then
		setDefaultValue("name", nil)
		setDefaultValue("raw", nil)

		setDefaultValue("class", nil)
		setDefaultValue("levelsAmount", nil)
		setDefaultValue("positive", nil)

	    setDefaultValue("icon", nil)
	    setDefaultValue("tooltip", nil)
	    setDefaultValue("uberTooltip", nil)

	    setDefaultValue("sfxPath", nil)
	    setDefaultValue("sfxAttachPt", nil)
	    setDefaultValue("sfxLevel", nil)
	elseif (extension == ".wc3item") then
		setDefaultValue("name", nil)
		setDefaultValue("raw", nil)

		setDefaultValue("classes", nil)
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
	elseif (extension == ".wc3unit") then
		setDefaultValue("name", nil)
		setDefaultValue("raw", nil)
		
		setDefaultValue("classes", nil)
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

		setDefaultValue("attackMissileModel", nil)
		setDefaultValue("attackMissileSpeed", nil)
		setDefaultValue("attackMissileArc", nil)

		setDefaultValue("damageType", nil)
		setDefaultValue("damageAmount", nil)
		setDefaultValue("damageDices", nil)
		setDefaultValue("damageSides", nil)

		setDefaultValue("collisionSize", nil)
		setDefaultValue("combatFlags", nil)
		setDefaultValue("deathTime", nil)
		setDefaultValue("exp", nil)
		setDefaultValue("gold", nil)

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
    end

    local customFields = {}

    string.quote = function(s)
        return "\""..s.."\""
    end

    for field, val in pairs(levelVals) do
        for level = 2, levelsAmount, 1 do
            if (val[level] == nil) then
               val[level] = val[level - 1]
            end
        end
        
        if (isDefaultField[field] ~= true) then
            customFields[field] = field
        end
    end

	require "Buff"

	local sharedBuffs = {}
	
	for level = 1, levelsAmount, 1 do
	    count = 0
	    line = getVal("sharedBuffs")[level]
	    sharedBuffs[level] = {}
	
	    while ((line ~= nil) and (line ~= "")) do
	        count = count + 1
	
	        if (string.find(line, ";") == nil) then
	            sharedBuffs[level][count] = line
	
	            line = nil
	        else
	            sharedBuffs[level][count] = string.sub(line, string.find(line, ";") - 1)
	
	            line = string.sub(line, string.find(line, ";") + 1)
	        end
	    end
	end

    require "Color"

    function replace(a, sub, rep, gold)
        if (rep == nil) then
            rep = ""
        end

        if (gold == nil) then
            rep = Color.GOLD..rep..Color.RESET
        end

        while (string.find(a, sub) ~= nil) do
            a = string.sub(a, 1, string.find(a, sub) - 1)..rep..string.sub(a, string.find(a, sub) + 1)
        end

        return a
    end

	function replaceTags(a, level)
	    a = string.gsub(a, "<level>", level)
	    a = string.gsub(a, "<prevLevel>", level - 1)
	
	    for field, val in pairs(levelVals) do
	        if ((type(val[level]) == "integer") or (type(val[level]) == "string")) then
	            a = replace(a, "<"..field..">", val[level])
		        for level = 1, levelsAmount, 1 do
		            a = replace(a, "<"..field..level..">", val[level])
		        end
		        if (tonumber(val[level])) then
		            a = replace(a, "<"..field..level..",%>", (val[level] * 100).."%")
			        for level = 1, levelsAmount, 1 do
			            a = replace(a, "<"..field..level..",%>", (val[level] * 100).."%")
			        end
		        end
	        end
	    end
	
	    for key, buff in pairs(sharedBuffs[level]) do
	        a = replace(a, "<"..buff..">", BUFF_COLOR[buff], false)
	        a = replace(a, "</"..buff..">", Color.RESET, false)
	    end
	
	    return a
	end

    if (extension == ".wc3spell") then
	    for level = 1, levelsAmount, 1 do
	        if (getVal("tooltip")[level] == nil) then
		        if (getVal("name")[level] ~= nil) then
		            getVal("tooltip")[level] = Color.DWC..getVal("name")[level]..Color.RESET
		        end
		    end
	
		    if (getVal("hotkey")[level] ~= nil) then
		        if (getVal("tooltip")[level] == nil) then
		            getVal("tooltip")[level] = "("..Color.GOLD..getVal("hotkey")[level]..Color.RESET..") "
		        else
		            getVal("tooltip")[level] = "("..Color.GOLD..getVal("hotkey")[level]..Color.RESET..") "..getVal("tooltip")[level]
		        end
		    end
		    if (levelsAmount > 1) then
		        if (getVal("tooltip")[level] == nil) then
		            getVal("tooltip")[level] = " ["..Color.GOLD.."Level "..level..Color.RESET.."]"
		        else
		            getVal("tooltip")[level] = getVal("tooltip")[level].." ["..Color.GOLD.."Level "..level..Color.RESET.."]"
		        end
		    end
	
	        if (getVal("uberTooltip")[level] == nil) then
	            getVal("uberTooltip")[level] = nil
	        end
	
	        if (getVal("uberTooltip")[level] ~= nil) then
		        getVal("uberTooltip")[level] = replaceTags(getVal("uberTooltip")[level], level)
		    end
	
	        for key, buff in pairs(sharedBuffs[level]) do
	            if (getVal("uberTooltip")[level] == nil) then
	                getVal("uberTooltip")[level] = BUFF_DESCRIPTION[buff]
	            else
	                getVal("uberTooltip")[level] = getVal("uberTooltip")[level].."|n|n"..BUFF_DESCRIPTION[buff]
	            end
		    end
	
		    if (getVal("lore")[level] ~= nil) then
		        if (getVal("uberTooltip")[level] == nil) then
		            getVal("uberTooltip")[level] = Color.GOLD..getVal("lore")[level]..Color.RESET
		        else
		            getVal("uberTooltip")[level] = getVal("uberTooltip")[level].."|n|n"..Color.GOLD..getVal("lore")[level]..Color.RESET
		        end
		    end
		
		    if (getVal("cooldown")[level] ~= nil) then
		        if (getVal("cooldown")[level] > 0) then
		            if (getVal("uberTooltip")[level] == nil) then
		                getVal("uberTooltip")[level] = Color.DWC.."Cooldown: "..Color.GOLD..getVal("cooldown")[level]..Color.DWC.." seconds"..Color.RESET
		            else
		                getVal("uberTooltip")[level] = getVal("uberTooltip")[level].."|n|n"..Color.DWC.."Cooldown: "..Color.GOLD..getVal("cooldown")[level]..Color.DWC.." seconds"..Color.RESET
		            end
		        end
		    end
	
	        if (isHeroSpell) then
		        if (getVal("learnTooltip")[level] == nil) then
		            if (getVal("name")[level] ~= nil) then
		                getVal("learnTooltip")[level] = Color.DWC..getVal("name")[level]..Color.RESET
		            end
		
		            if (getVal("hotkey")[level] ~= nil) then
		                if (getVal("learnTooltip")[level] == nil) then
		                    getVal("learnTooltip")[level] = "("..Color.GOLD..getVal("hotkey")[level]..Color.RESET..") "
		                else
		                    getVal("learnTooltip")[level] = "("..Color.GOLD..getVal("hotkey")[level]..Color.RESET..") "..getVal("learnTooltip")[level]
		                end
		            end
		            if (levelsAmount > 1) then
		                if (getVal("learnTooltip")[level] == nil) then
		                    getVal("learnTooltip")[level] = " ["..Color.GOLD.."Level %d"..Color.RESET.."]"
		                else
		                    getVal("learnTooltip")[level] = getVal("learnTooltip")[level].." ["..Color.GOLD.."Level %d"..Color.RESET.."]"
		                end
		            end
		
		            if (getVal("learnTooltip")[level] ~= nil) then
		                getVal("learnTooltip")[level] = "Learn "..getVal("learnTooltip")[level]
		            end
		        end
		        if (getVal("learnUberTooltip")[level] ~= nil) then
			        getVal("learnUberTooltip")[level] = replaceTags(getVal("learnUberTooltip")[level], level)
			    end
	        end
	    end
	elseif (extension == ".wc3buff") then
	elseif (extension == ".wc3item") then
	elseif (extension == ".wc3unit") then
    end

	function buildJ()
	    local curLine = 0
	    local file = io.open(folder.."obj_"..jPrefix..fileName..".j", "w+")
	
	    local function writeLine(s)
	        curLine = curLine + 1
	
	        if (curLine > 1) then
	        --print("write "..s.." --> "..string.find(s, "static"))
	            if ((string.find(s, "static") ~= 1) and (string.find(s, "end") ~= 1)) then
	                s = "    "..s
	            end

	            s = "\n"..s
	        end
	
	        file:write(s)
	    end

	    local function toJassName(s)
		    local result = ""

		    for i = 1, s:len(), 1 do
		        local c = s:sub(i, i)

		        if ((c >= 'A') and (c <= 'Z') and (i ~= 1)) then
		            result = result.."_"..c
		        else
		            result = result..c:upper()
		        end
		    end

		    return result
		end

		local objJassType

		if (extension == "wc3buff") then
		    objJassType = "Buff"
		elseif (extension == "wc3spell") then
		    objJassType = "Spell"
		elseif (extension == "wc3item") then
		    objJassType = "Item"
		elseif (extension == "wc3unit") then
		    objJassType = "Unit"
		end

		if (objJassType ~= nil) then
		    local varDecLine = "static "..objJassType

		    if (toJassName(fileName):find("[", 1, true) ~= nil) then
		        varDecLine = varDecLine.." array"
		    end

		    varDecLine = varDecLine.." "..toJassName(fileName)

			writeLine(varDecLine)
			writeLine("")
		end

		for field, val in pairs(customFields) do
		    local jassType = type(getVal(val)[1])

		    if (jassType == "boolean") then
		        jassType = "boolean"
		    elseif (jassType == "number") then
		        for level = 1, levelsAmount, 1 do
			        if (math.floor(getVal(val)[1]) ~= getVal(val)[1]) then
			            jassType = "real"
			        end
		        end

		        if (jassType == "number") then
		            jassType = "integer"
		        end
		    else
		        jassType = "string"
		    end

		    local varDecLine = "static "..jassType.." array "..toJassName(val)

		    if (toJassName(val):find("//") == 1) then
		        varDecLine = "//"..varDecLine
		    end

		    writeLine(varDecLine)
		end

		writeLine("")

		local jassFileName = trimString(trimString(fileName, "["), "]")

	    writeLine("static method Init_obj_"..jassFileName.." takes nothing returns nothing")
	    
	    if (extension == "wc3spell") then
	        writeLine("set SpellObjectCreation.TEMP = Spell.CreateFromSelf('"..getVal("raw")[1].."')")
	
	        writeLine("")
	
		    if (getVal("class")[1] ~= nil) then
		        writeLine("call SpellObjectCreation.TEMP.SetClass(SpellClass."..getVal("class")[1]..")")
		    end
		    if (getVal("levelsAmount")[1] ~= nil) then
		        writeLine("call SpellObjectCreation.TEMP.SetLevelsAmount("..getVal("levelsAmount")[1]..")")
		    end
		    if (getVal("name")[1] ~= nil) then
		        writeLine("call SpellObjectCreation.TEMP.SetName("..string.quote(getVal("name")[1])..")")
		    end
		    if (getVal("order")[1] ~= nil) then
		        writeLine("call SpellObjectCreation.TEMP.SetOrder("..string.quote(getVal("order")[1])..")")
		    end
		    if (getVal("target")[1] ~= nil) then
		        writeLine("call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_"..getVal("target")[1]..")")
		    end
		    
		    if (getVal("animation")[1] ~= nil) then
		        writeLine("call SpellObjectCreation.TEMP.SetAnimation("..string.quote(getVal("animation")[1])..")")
		    end
		    for level = 1, levelsAmount, 1 do
			    if (getVal("areaRange")[level] ~= nil) then
			        writeLine("call SpellObjectCreation.TEMP.SetAreaRange("..level..", "..getVal("areaRange")[level]..")")
			    end
			    if (getVal("castTime")[level] ~= nil) then
			        writeLine("call SpellObjectCreation.TEMP.SetCastTime("..level..", "..getVal("castTime")[level]..")")
			    end
			    if (getVal("channelTime")[level] ~= nil) then
			        writeLine("call SpellObjectCreation.TEMP.SetChannelTime("..level..", "..getVal("channelTime")[level]..")")
			    end
			    if (getVal("cooldown")[level] ~= nil) then
			        writeLine("call SpellObjectCreation.TEMP.SetCooldown("..level..", "..getVal("cooldown")[level]..")")
			    end
			    if (getVal("manaCost")[level] ~= nil) then
			        writeLine("call SpellObjectCreation.TEMP.SetManaCost("..level..", "..getVal("manaCost")[level]..")")
			    end
			    if (getVal("range")[level] ~= nil) then
			        writeLine("call SpellObjectCreation.TEMP.SetRange("..level..", "..getVal("range")[level]..")")
		   	    end
		    end
		
			if (getVal("icon")[1] ~= nil) then
			    writeLine("call SpellObjectCreation.TEMP.SetIcon("..string.quote(string.doubleBackslashes(getVal("icon")[1]))..")")
			end
		    
		    writeLine("")
		    
		    if (isHeroSpell) then
			    writeLine("call Hero.InitSpell(SpellObjectCreation.TEMP, 'F"..getVal("learnRaw")[1].."0', "..levelsAmount..", 'C"..getVal("learnRaw")[1].."0')")
			    
			    writeLine("")
			end
		elseif (extension == "wc3buff") then
			local var = getVal("var")

	        writeLine([[set thistype.]]..var..[[ = Buff.Create('B]]..getVal("raw")..[[', "]]..getVal("name")..[[", 'b]]..getVal("raw")..[[')]])
	
	        writeLine([[call thistype.]]..var..[[.SetIcon("]]..getVal("icon")..[[")]])
	        writeLine([[call thistype.]]..var..[[.SetPositive(]]..getVal("positive")..[[)]])
		elseif (extension == "wc3item") then
			local var = getVal("var")

			for class in getVal("classes"):split(";") do
		    	writeLine([[call ItemObjectCreation.]]..var..[[.Classes.Add(ItemClass.]]..class..[[)]])
		    end

		    writeLine([[call ItemObjectCreation.]]..var..[[.ChargesAmount.Set(]]..getVal("chargesAmount")..[[)]])
		elseif (extension == "wc3unit") then
		end
		
		local function isPlainText(s)
		    local val = s:find(".", 1, true)
		    
		    if (val) then
		        val = s:sub(val + 1)

			    if (val:upper() == val) then
			        return false
			    end
		    end
		    
		    return true
		end
		
		for level = 1, levelsAmount, 1 do
			for field, val in pairs(customFields) do
			    local result = getVal(val)[level]

			    if (result ~= nil) then
				    if (type(result) == "string") then
				        if (isPlainText(result)) then
					        result = result:doubleBackslashes()
					        result = result:quote()
				        end
				    end
				    
				    writeLine("set thistype."..toJassName(val).."["..level.."] = "..result)
			    end
			end
		end
		
		writeLine("endmethod")
	    
	    file:close()
	end

	buildJ()

    local function loadIncludes()
		if ((getVal("include") ~= nil) and (getVal("include")[1] ~= nil)) then
		    for i,s in pairs(getVal("include")[1]:split(";")) do
		        if (s ~= nil) then
		            local incVals, incLevelVals = updateFile(folder..s, jPrefix..fileName.."_")
	
		            for field, val in pairs(incVals) do
		                customFields[s.."_"..field] = s.."_"..field
		                vals[s.."_"..field] = val
		            end
		            for field, val in pairs(incLevelVals) do
		                levelVals[s.."_"..field] = val
		            end
		            
		            --[[for field, val in pairs(incVals) do
						curX = 0
		                customFields[s.."_"..field] = s.."_"..field
	
		                vals[s.."_"..field] = {}
		                levelVals[field] = {}
	
	                    for f,v in pairs(val) do
		                	curX = curX + 1
		                    
		                    vals[s.."_"..field][curX] = val[curX]
		                    if (curX > 1) then
			                    levelVals[field][curX - 1] = val[curX]
		                    end
	                    end
		            end]]
		        end
		    end
		end
	end

    local function b2s(flag)
        if (flag) then
            return "true"
        end

        return "false"
    end

    local function buildObjectMergerInput()
        local file = io.open("ObjectMergerInput.lua", "a")

        file:write("levelVals = {}")

        for field, val in pairs(levelVals) do
            file:write("\n".."levelVals[\""..field.."\"] = {}")

            for level = 1, levelsAmount, 1 do
                if (getVal(field)[level] ~= nil) then
                    if (type(getVal(field)[level]) == "boolean") then
                        file:write("\n".."levelVals[\""..field.."\"]["..level.."] = "..b2s(getVal(field)[level]))
                    elseif (type(getVal(field)[level]) == "string") then
                        file:write("\n".."levelVals[\""..field.."\"]["..level.."] = \""..string.doubleBackslashes(getVal(field)[level]).."\"")
                    else
                        file:write("\n".."levelVals[\""..field.."\"]["..level.."] = "..getVal(field)[level])
                    end
                end
            end
        end

        file:write("\n")

        if (extension == "wc3spell") then
	        file:write([[
	            function getVal(field)
	                return levelVals[field]
	            end
	
	            function set(field, value, default)
	                if (value == nil) then
	                    makechange(current, field, default)
	                else
	                    makechange(current, field, value)
	                end
	            end
	
	            function setLv(field, level, value, default)
	                if (value == nil) then
	                    makechange(current, field, level, default)
	                else
	                    makechange(current, field, level, value)
	                end
	            end

	            base = getVal("base")[1]
	            class = getVal("class")[1]
	            levelsAmount = getVal("levelsAmount")[1]
	            raw = getVal("raw")[1]
	
		        if (base == "NORMAL") then
		            baseRaw = "ANcl"
	                channelBased = true
		        elseif (base == "PARALLEL_IMMEDIATE") then
		            baseRaw = "Absk"
		        elseif (base == "PASSIVE") then
		            baseRaw = "Agyb"
		        elseif (string.sub(base, 1, 1 + 7 - 1) == "SPECIAL") then
		            baseRaw = string.sub(base, 1 + 7 + 1, string.len(base))
		        end
	
	            createobject(baseRaw, raw)
	
	            set("acap", "")
	            set("acat", "")
	            set("aeat", "")
	            set("aher", "\0")
	            set("ahky", "")
	            if (class == "ITEM") then
	                set("aite", 1)
	            end
	            set("anam", getVal("name")[1], "defaultName")
	            set("areq", "")
	            set("ata0", "")
	            set("atat", "")
	
	            set("aani", getVal("animation")[1], "")
	            set("aart", getVal("icon")[1], "")
	            set("abpx", getVal("buttonPosX")[1], 0)
	            set("abpy", getVal("buttonPosY")[1], 0)
	            set("ahky", getVal("hotkey")[1], "")
	            set("alev", levelsAmount)
	
	            for level = 1, levelsAmount, 1 do
	                if (base == "PARALLEL_IMMEDIATE") then
	                    setLv("abuf", level, "BPar", "")
	                end
		            if (getVal(areaRangeDisplay, level)) then
		                setLv("aare", level, getVal("areaRange")[level], 0)
		            end
	                setLv("acas", level, getVal("castTime")[level], 0)
	                setLv("acdn", level, getVal("cooldown")[level], 0)
	                setLv("amcs", level, getVal("manaCost")[level], 0)
	                setLv("aran", level, getVal("range")[level], 0)
	                setLv("atar", level, getVal("targets")[level], "")
	                setLv("atp1", level, getVal("tooltip")[level], "")
	                setLv("aub1", level, getVal("uberTooltip")[level], "")
	            end
	
	            if (channelBased) then
	                for level = 1, levelsAmount, 1 do
	                    setLv("Ncl1", level, 0, 0)
	                    if (getVal("target")[level] == "IMMEDIATE") then
	                        setLv("Ncl2", level, 0, 0)
	                    elseif (getVal("target")[level] == "POINT") then
	                        setLv("Ncl2", level, 2, 0)
	                    elseif (getVal("target")[level] == "POINT_OR_UNIT") then
	                        setLv("Ncl2", level, 3, 0)
	                    elseif (getVal("target")[level] == "UNIT") then
	                        setLv("Ncl2", level, 1, 0)
	                    end
	                    if (getVal("areaRangeDisplay")[level]) then
	                        setLv("Ncl3", level, 19)
	                    else
	                        setLv("Ncl3", level, 17)
	                    end
	                    setLv("Ncl4", level, 0)
	                    setLv("Ncl5", level, "\0")
	                    setLv("Ncl6", level, getVal("order")[level], "")
	                end
	            end
	
	            if (isHeroSpell) then
	                learnPrefix = getVal("learnPrefix")[1]
	                learnRaw = getVal("learnRaw")[1]
	                learnSlot = getVal("learnSlot")[1]
	
	                createobject("ANeg", "C"..learnRaw..index)
	
	                set("abpx", 0)
	                set("abpy", 0)
	                set("ahky", "")
	                set("alev", levelsAmount)
	                set("anam", getVal("name")[1].." Hero Spell Replacer "..index)
	                set("arac", "other")
	                set("aret", "")
	                set("arhk", "")
	                set("arpx", 0)
	                set("arut", "")
	
	                for level = 1, levelsAmount, 1 do
	                    setLv("abuf", level, "BHSR")
	                    setLv("atp1", level, "")
	                    setLv("aub1", level, "")
	                    setLv("Neg1", level, 0)
	                    setLv("Neg2", level, 0)
	                    if (level == 1) then
	                        setLv("Neg3", level, "AHS"..index..","..learnPrefix..learnRaw..(level - 1))
	                    else
	                        setLv("Neg3", level, learnPrefix..learnRaw..(level - 2)..","..learnPrefix..learnRaw..(level - 1))
	                    end
	                    setLv("Neg4", level, "")
	                    setLv("Neg5", level, "")
	                    setLv("Neg6", level, "")
	                end
	
	                for level = 1, levelsAmount, 1 do
	                    createobject("ANcl", learnPrefix..learnRaw..(level - 1))
	
	                    set("aani", "")
	                    set("aart", "")
	                    set("abpx", 0)
	                    set("acap", "")
	                    set("acat", "")
	                    set("aeat", "")
	                    set("ahky", "")
	                    set("alev", 1)
	                    set("anam", getVal("name")[1].." Hero Spell Learner "..learnSlot.." Level "..level)
	                    set("arac", "other")
	
	                    setLv("aran", 1, 0)
	                    set("arar", icon, "")
	                    set("ata0", "")
	                    set("atat", "")
	                    setLv("atp1", 1, "")
	                    setLv("aub1", 1, "")
	                    setLv("Ncl1", 1, 0)
	                    setLv("Ncl3", 1, 0)
	                    setLv("Ncl4", 1, 0)
	                    setLv("Ncl5", 1, "\0")
	                    setLv("Ncl6", 1, "")
	                    
	                    set("aret", getVal("learnTooltip")[level])
	                    set("arhk", getVal("learnHotkey")[1])
	                    set("arpx", getVal("learnButtonPosX")[1])
	                    set("arpy", getVal("learnButtonPosY")[1])
	                    set("arut", getVal("learnUberTooltip")[level], "")
	                end
	            end
	        ]])
        elseif (extension == "wc3buff") then
        	file:write([[
	            function getVal(field)
	                return levelVals[field]
	            end
	
	            function set(field, value, default)
	                if (value == nil) then
	                    makechange(current, field, default)
	                else
	                    makechange(current, field, value)
	                end
	            end

	            //! i setobjecttype("buffs")
	
	            //! i createobject("Basl", "B"..getVal("raw"))
	
	            //! i set("fart", "getVal("icon"))
	            //! i set("fnsf", "")
	            //! i set("ftat", "")
	            //! i set("fube", getVal("uberTooltip"))
	
	            //! i if (getVal("positive")) then
	                //! i set("ftip", "|cff00ff00"..getVal("name"))
	            //! i else
	                //! i set("ftip", getVal("name"))
	            //! i end
	
	            //! i setobjecttype("abilities")
	
	            //! i createobject("Aasl", "b"..getVal("raw"))
	
	            //! i setl("aare", 1, 0)
	            //! i for i = 1, $levelsAmount$, 1 do
	                //! i setl("abuf", i, "B"..getVal("raw"))
	                //! i setl("atar", i, "invulnerable,self,vulnerable")
	                //! i setl("Slo1", i, 0)
	            //! i end
	            //! i set("alev", getVal("levelsAmount"))
	            //! i set("anam", getVal("name"))
	            //! i set("ansf", "(Buffer)")
	            //! i set("arac", "other")

		        set thistype.$var$ = Buff.Create('B$raw$', "$name$", 'b$raw$')
		
		        call thistype.$var$.SetIcon("$icon$")
		        call thistype.$var$.SetPositive($positive$)
		    //! endtextmacro
	        ]])
        elseif (extension == "wc3item") then
        	local function tableContains(t, e)
        		for k, v in pairs(t) do
        			if (v == e) then
        				return true
        			end
        		end

        		return false
        	end

            file:write([[
                POWER_UP_SPELL_ID = "APUp"

	            function set(field, value)
	                makechange(current, field, value)
	            end
	
	            function addAbility(value)
	                if (abilitiesCount == 0) then
	                    abilities = value
	                    if (cooldownGroup == nil) then
	                        cooldownGroup = value
	                    end
	                else
	                    abilities = abilities..","..value
	                end
	
	                abilitiesCount = abilitiesCount + 1
	            end
	
	            setobjecttype("items")
	
	            raw = "I]]..getVal("raw")..[["
	
	            createobject("ches", raw)
	
	            abilitiesCount = 0
	
	            set("iarm", "]]..getVal("armor")..[[")
	            set("iclr", ]]..getVal("vertexColorRed")..[[)
	            set("iclg", ]]..getVal("vertexColorGreen")..[[)
	            set("iclb", ]]..getVal("vertexColorBlue")..[[)
	            set("ides", "]]..getVal("description")..[[")
	            set("iico", "]]..getVal("icon")..[[")
	            set("ifil", "]]..getVal("model")..[[")
	            set("igol", ]]..getVal("goldCost")..[[)
	            set("ilum", ]]..getVal("lumberCost")..[[)
	            set("ipaw", "1")
	            set("isca", ]]..getVal("scale").[[)
	            set("isel", "1")
	            set("istr", 0)
	            set("unam", ]]..getVal("name")..[[)
	            set("utip", "]]..getVal("tooltip")..[[")
	            set("utub", "]]..getVal("uberTooltip")..[[")

	            if (]]....[[) then

	            else
	                if (isScroll) then
	                    addAbility("AISc")
	                end
	
	                if (abilitiesCount > 0) then
	                    set("iabi", abilities)
	                    set("icid", cooldownGroup)
	                    set("iusa", "1")
	                end
	            end
            ]])
            
            if tableContains(getVal("classes"):split(";"), "POWER_UP") then
            	file:write([[
	                set("iabi", POWER_UP_SPELL_ID)
	                set("iusa", "1")
            	]])
            else
            	if tableContains(getVal("classes"):split(";"), "SCROLL") then
            		file:write([[
            			addAbility("AISc")
            		]])
            	end

	            if ]]..getVal("abilities")..[[ then
	                file:write([[
	                    set("iabi", abilities)
	                    set("icid", cooldownGroup)
	                    set("iusa", "1")
            		]])
	            end
            end
        elseif (extension == "wc3unit") then
        end

        file:close()
    end

    if (isNewSpell) then
        --buildObjectMergerInput()
    end
    
    return vals, levelVals
end

function wawa()
file = io.open("paths.txt", "r")
filePaths = {}
filePathsCount = 0

for line in file:lines() do
    if ((line ~= nil) and (line ~= "")) then
        filePathsCount = filePathsCount + 1

        filePaths[filePathsCount] = "..\\Scripts\\Spells\\"..line
    end
end

file:close()

file = io.open("ObjectMergerInput.lua", "w+")

file:write([[
    setobjecttype("abilities")
]])

file:close()

while (filePathsCount > 0) do
    print("load "..filePaths[filePathsCount])
    updateFile(filePaths[filePathsCount], "")

    filePathsCount = filePathsCount - 1
end

function bla()

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
end

--wawa()
function start()
local line

local function getFileName(s, noExtension)
    while (s:find("\\") ~= nil) do
        s = s:sub(s:find("\\") + 1)
    end

    if (noExtension) then
        if (s:find(".", 1, true) ~= nil) then
            s = s:sub(1, s:find(".", 1, true) - 1)
        end
    end

    return s
end

local function getFolder(s)
    res = ""

    while (s:find("\\") ~= nil) do
        res = res..s:sub(1, s:find("\\"))

        s = s:sub(s:find("\\") + 1)
    end

    return res
end

--local file = io.open("..\\Scripts\\root.j", "w+")
--
--for line in io.popen([[dir "..\Scripts\*.j" /b /s]]):lines() do
--    if (getFileName(line):find("obj_") ~= 1) then
--        --print(line)
--        file:write("//! import \""..line.."\"\n")
--    end
--end
--
--file:close()

--clear
for line in io.popen([[dir "..\Scripts\*obj_*.j" /b /s]]):lines() do
    os.remove(line)
end

for line in io.popen([[dir "..\Scripts\*obj.j" /b /s]]):lines() do
    os.remove(line)
end

--for line in io.popen([[dir "..\Scripts\ItemTypes\*.wc3obj" /b /s]]):lines() do
--    os.rename(line, line:sub(1, line:find(".wc3obj", 1, true) - 1)..".wc3item")
--end

--update obj
local doUpdates = true

if (doUpdates) then
	for line in io.popen([[dir "..\Scripts\*.wc3*" /b /s]]):lines() do
	    --line = line:sub(1, line:find(".wc3obj") - 1)
	
	    updateFile(line, "")
	end

--	for line in io.popen([[dir "..\Scripts\*.wc3obj" /b /s]]):lines() do
--	    line = line:sub(1, line:find(".wc3obj") - 1)
--	
--	    updateFile(line, "")
--	end

	--obj imports
	folderImports = {}
	
	for line in io.popen([[dir "..\Scripts\*obj_*.j" /b /s]]):lines() do
	    --os.remove(line)
	    folder = getFolder(line)
	
	    if (folderImports[folder] == nil) then
	        folderImports[folder] = {}
	    end
	    
	    folderImports[folder][line] = line
	    --print("in "..folder)
	end
	
	for folder in pairs(folderImports) do
	    file = io.open(folder.."\\obj.j", "w+")
	
	    for imp in pairs(folderImports[folder]) do
	        local impFile = io.open(imp, "r")

	        if impFile then
	            file:write("//open object "..imp.."\n")
	            for impFileLine in impFile:lines() do
	                file:write(impFileLine.."\n")
	            end

	            impFile:close()

	            file:write("//close object "..imp.."\n\n")
	        end
	    end
	
	    file:write("\nprivate static method onInit takes nothing returns nothing")
	
	    for imp in pairs(folderImports[folder]) do
			file:write("\n    call Spell.AddInit(function thistype.Init_"..trimString(trimString(getFileName(imp, true), "["), "]")..")")
	    end
	
	    file:write("\nendmethod")
	
	    file:close()
	end
end

--write output
file = io.open("..\\output.j", "w+")

for line in io.popen([[dir "..\Scripts\*.j" /b /s]]):lines() do
    if (getFileName(line):find("obj", 1, true) ~= 1) then
	    file:write("\n//file: "..line.."\n")
	    file2 = io.open(line)

	    if (file2 ~= nil) then
	        local foundImp = {}
	        local nestDepth = 0
	        local prefix = ""

		    for line2 in file2:lines() do
		        local isFolder = (line2:find("//! runtextmacro Folder", 1, true) ~= nil)
		        local isStructLine = (line2:find("//! runtextmacro BaseStruct", 1, true) ~= nil) or (line2:find("//! runtextmacro Struct", 1, true) ~=  nil)
		        file:write(line2.."\n")

		        if (isFolder or isStructLine) then
		            nestDepth = nestDepth + 1

		            local structName

                    if (isFolder) then
	                    structName = line2:sub(line2:find("(".."\"", 1, true) + 2, line2:find(")") - 2)

                        if (nestDepth == 1) then
	                        structName = structName..".struct"
                        end
	                elseif ((line2:find("//! runtextmacro BaseStruct") ~= nil)) then
	                    structName = line2:sub(line2:find("(".."\"", 1, true) + 2, line2:find(",") - 2)

	                    structName = structName..".struct"
	                else
	                    structName = line2:sub(line2:find("(".."\"", 1, true) + 2, line2:find(")") - 2)
	                end

	                prefix = prefix..structName.."\\"

			        if ((foundImp[prefix] == nil) and isStructLine) then
			            local impPath = getFolder(line)..prefix.."obj.j"

			            local imp = io.open(impPath, "r")
			            foundImp[prefix] = true

			            if (imp ~= nil) then
			                file:write(string.rep(" ", nestDepth * 4).."//import: "..impPath.."\n")

			                for line3 in imp:lines() do
			                    file:write(string.rep(" ", nestDepth * 4)..line3.."\n")
			                end
	
			                imp:close()
	
			                file:write(string.rep(" ", nestDepth * 4).."//end of import: "..impPath.."\n")
			            end
			        end
		        elseif ((line2:find("endstruct") ~= nil) or (line2:find("endscope") ~= nil)) then
		            nestDepth = nestDepth - 1

		            string.backFind = function(s, search)
		                s = s:reverse()

		                if (s:find(search) == nil) then
		                    return nil
		                end

		                return (s:len() - s:find(search) + 1)
		            end

		            if (prefix:backFind("\\") ~= nil) then
		                prefix = prefix:sub(1, prefix:backFind("\\") - 1)

                        if (prefix:backFind("\\") == nil) then
                            prefix = ""
                        else
                            prefix = prefix:sub(1, prefix:backFind("\\"))
                        end
		            end
		        end
		    end
	    end
	    file:write("\n//end of file: "..line.."\n")
    end
end

file:close()

--clear
for line in io.popen([[dir "..\Scripts\*obj_*.j" /b /s]]):lines() do
    --os.remove(line)
end

for line in io.popen([[dir "..\Scripts\*obj.j" /b /s]]):lines() do
    --os.remove(line)
end
end

start()

--for line in io.popen([[dir "..\Scripts\*.struct" /b /s]]):lines() do
--    for line2 in io.popen([[dir "]]..line..[[\*.struct" /b /s]]):lines() do
--        print("replace "..line2.." by "..line2:sub(1, line2:find(".struct", line2:find(".struct", 1, true) + 1, true) - 1))
--        os.rename(line2, line2:sub(1, line2:find(".struct", line2:find(".struct", 1, true) + 1, true) - 1))
--    end
--end