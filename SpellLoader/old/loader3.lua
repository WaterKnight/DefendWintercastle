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
IS_HERO_SPELL["HERO_PURCHASABLE"] = true

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

function buildObjectMergerInput()
end

function loadSlk(path)
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

    curX = 1
    curY = 1

    for y = 1, maxY, 1 do
        table[y] = {}
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

                    if (tonumber(line) ~= nil) then
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

function loadTxt(path)
    file = io.open(path..".txt", "r")

    curY = 0

    for line in file:lines() do
        if (line ~= nil) then
            curX = 0
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

function updateFile(path)
    folder = ""
    line = path
    maxX = nil
    maxY = nil
    table = {}

    while (string.find(line, "\\") ~= nil) do
        folder = folder..string.sub(line, 1, string.find(line, "\\"))
        line = string.sub(line, string.find(line, "\\") + 1)
    end

    fileName = line
print("load "..fileName.." at "..folder)
    loadTxt(path)

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

    allLevelVals = {}
    allVals = {}

    for y = 1, maxY, 1 do
        field = table[y][1]

        if (field ~= nil) then
            if (type(field) == "string") then
                field = dequote(field)
            end
            levelVals = {}
            vals = {}

            for x = 2, maxX, 1 do
                vals[x - 1] = table[y][x]

                if (type(vals[x - 1]) == "string") then
                    vals[x - 1] = dequote(vals[x - 1])
                end

                if (x > 2) then
                    level = x - 2

                    levelVals[level] = vals[x - 1]

                    if ((levelVals[level] == nil) and (level > 1)) then
                        levelVals[level] = levelVals[level - 1]
                    end
                end
            end

            if (field == "class") then
                class = vals[2]

                levelsAmount = LEVELS_AMOUNT[class]
            end

            allVals[field] = vals
            allLevelVals[field] = levelVals
        end
    end

    curLine = 0
    file = io.open(folder.."obj_"..fileName..".j", "w+")

    function writeLine(s)
        curLine = curLine + 1

        if (curLine > 1) then
            s = "\n"..s
        end

        file:write(s)
    end

    function formLevelValsString(field)
        s = ""

        for level = 1, levelsAmount, 1 do
        print("level "..level)
            s = s.."\""..allLevelVals[field][level].."\""

            if (level ~= levelsAmount) then
                s = s..", "
            end
        end

        return s
    end

    function b2s(flag)
        if (flag) then
            return "true"
        end

        return "false"
    end

    require "Color"

    function setSingleVal(var)
        if (allLevelVals[var] == nil) then
            return nil
        end

        return allLevelVals[var][1]
    end

    name = setSingleVal("name")
    raw = setSingleVal("raw")

    base = setSingleVal("base")
    class = setSingleVal("class")
    levelsAmount = setSingleVal("levelsAmount")
    order = setSingleVal("order")
    target = setSingleVal("target")

    animation = setSingleVal("animation")
    areaRange = allLevelVals["areaRange"]
    areaRangeDisplay = setSingleVal("areaRangeDisplay")
    cooldown = allLevelVals["cooldown"]
    manaCost = allLevelVals["manaCost"]
    range = allLevelVals["range"]
    targets = allLevelVals["targets"]

    buttonPosX = setSingleVal("buttonPosX")
    buttonPosY = setSingleVal("buttonPosY")
    hotkey = setSingleVal("hotkey")
    icon = setSingleVal("icon")
    researchTooltip = allLevelVals["researchTooltip"]
    sharedBuffs = allLevelVals["sharedBuffs"]
    tooltip = allLevelVals["tooltip"]
    uberTooltip = allLevelVals["uberTooltip"]

    if (areaRangeDisplay == nil) then
        areaRangeDisplay = false
    end

    if (buttonPosX == nil) then
        buttonPosX = BUTTON_POS_X[class]
    end
    if (buttonPosY == nil) then
        buttonPosY = BUTTON_POS_X[class]
    end
    if (hotkey == nil) then
        if (class ~= "PASSIVE") then
            hotkey = HOTKEY[class]
        end
    end
    isHeroSpell = IS_HERO_SPELL[class]
    if (levelsAmount == nil) then
       	levelsAmount = LEVELS_AMOUNT[class]
    end
    if (class == "PARALLEL_IMMEDIATE") then
        order = "berserk"
    end

    for level = 1, levelsAmount, 1 do
        if (tooltip[level] == nil) then
            tooltip[level] = Color.DWC..name..Color.RESET
        end

	    if (hotkey ~= nil) then
	        tooltip[level] = "("..Color.GOLD..hotkey..Color.RESET..") "..tooltip[level]
	    end
	    if (levelsAmount > 1) then
	        tooltip[level] = tooltip[level].." ["..Color.GOLD.."Level "..level..Color.RESET.."]"
	    end
    end

    function buildObjectMergerInput()
        file = io.open("ObjectMergerInput.lua", "w+")

        function writeVal(var, ident)
            if (var == nil) then
                return ""
            end

            if (type(var) == "boolean") then
                var = b2s(var)
            end

            return "\n"..ident.." = "..var
        end

        function writeTable(var, ident)
            if (var == nil) then
                return ""
            end

            s = "\n"..ident.." = {}"

            for level = 1, levelsAmount, 1 do
                if (var[level] ~= nil) then
                    s = s.."\n"..ident.."["..level.."] = "..var[level]
                end
            end

            return s
        end

        file:write([[
            require "Buff.lua"
            require "Color.lua"
            require "Math.lua"

	        ]]..writeVal(name, "name")..[[
	        ]]..writeVal(raw, "raw")..[[

            ]]..writeVal(base, "base")..[[
            ]]..writeVal(class, "class")..[[
            ]]..writeVal(isHeroSpell, "isHeroSpell")..[[
            ]]..writeVal(levelsAmount, "levelsAmount")..[[
            ]]..writeVal(order, "order")..[[
            ]]..writeVal(target, "target")..[[

            ]]..writeVal(animation, "animation")..[[
            ]]..writeTable(areaRange, "areaRange")..[[
            ]]..writeVal(areaRangeDisplay, "areaRangeDisplay")..[[
            ]]..writeTable(cooldown, "cooldown")..[[
            ]]..writeTable(manaCost, "manaCost")..[[
            ]]..writeTable(range, "range")..[[
            ]]..writeTable(targets, "targets")..[[

            ]]..writeTable(researchTooltip, "researchTooltip")..[[
            ]]..writeTable(tooltip, "tooltip")..[[
            ]]..writeTable(uberTooltip, "uberTooltip")..[[
        ]])

        file:write("\n")

        file:write([[
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

            setobjecttype("abilities")

	        if (base == "NORMAL") then
                channelBased = true
                createobject("ANcl", raw)

                set("acap", "")
                set("acat", "")
                set("aeat", "")
                set("aher", "\0")
                set("ahky", "")
                set("anam", name)
                set("ata0", "")
                set("atat", "")
	        elseif (base == "PARALLEL_IMMEDIATE") then
                createobject("Absk", raw)

                set("ahky", "")
                set("anam", name)
                set("ata0", "")
                set("atat", "")
	        elseif (base == "PASSIVE") then
                createobject("Agyb", raw)

                set("acap", "")
                set("acat", "")
                set("aeat", "")
                set("aher", "\0")
                set("ahky", "")
                set("anam", name)
                set("areq", "")
                set("ata0", "")
                set("atat", "")
	        elseif (string.sub(base, 1, 1 + 7 - 1) == "SPECIAL") then
                createobject(string.sub(base, 1 + 7 + 1, string.len(base)), raw)

                set("acap", "")
                set("acat", "")
                set("aeat", "")
                set("aher", "\0")
                set("ahky", "")
                set("anam", name)
                set("ata0", "")
                set("atat", "")
	        end

            if (class == "ITEM") then
                set("aite", 1)
            end

            set("ahky", hotkey)

            function replace(a, sub, rep, gold)
                if (rep == nil) then
                    rep = ""
                end

                c = 1
                if (gold == nil) then
                    rep = Color.GOLD..rep..Color.RESET
                end

                while (c < string.len(a) - string.len(sub) + 2) do
                    if (string.sub(a, c, c + string.len(sub) - 1) == sub) then
                        a = string.sub(a, 1, c - 1)..rep..string.sub(a, c + string.len(sub))
                    else
                        c = c + 1
                    end
                end

                return a
            end

            function replaceTags(a, level)
                a = string.gsub(a, "<level>", level)
                a = string.gsub(a, "<prevLevel>", level - 1)

                a = replace(a, "<areaRange>", areaRange[level])
                a = replace(a, "<channelTime>", channelTime[level])
                a = replace(a, "<cooldown>", cooldown[level])
                a = replace(a, "<manaCost>", manaCost[level])
                a = replace(a, "<name>", name)
                for i = 1, levelsAmount, 1 do
                    a = replace(a, "<areaRange"..i..">", areaRange[i])
                    a = replace(a, "<channelTime"..i..">", channelTime[i])
                    a = replace(a, "<cooldown"..i..">", cooldown[i])
                    a = replace(a, "<manaCost"..i..">", manaCost[i])
                end

                for i = 1, datasCount, 1 do
                    if (datasValue[i][level] == nil) then
                        a = replace(a, "<"..datas[i]..">", datasValue[i][1])
                        if (type(datasValue[i][1]) == "number") then
                            a = replace(a, "<"..datas[i]..",%>", (datasValue[i][1] * 100).."%")
                        end
                    else
                        a = replace(a, "<"..datas[i]..">", datasValue[i][level])
                        if (type(datasValue[i][level]) == "number") then
                            a = replace(a, "<"..datas[i]..",%>", (datasValue[i][level] * 100).."%")
                        end
                    end

                    for i2 = 1, levelsAmount, 1 do
                        a = replace(a, "<"..datas[i]..i2..">", datasValue[i][i2])

                        if (type(datasValue[i][i2]) == "number") then
                            a = replace(a, "<"..datas[i]..i2..",%>", (datasValue[i][i2] * 100).."%")
                        end
                    end
                end

                for buff in sharedBuffs do
                    a = replace(a, "<"..curBuff:getName()..">", curBuff:getColor(), false)
                    a = replace(a, "</"..curBuff:getName()..">", Color.RESET, false)
                end

                return a
            end

            set("alev", levelsAmount)

            set("aani", animation, "..animation..")
            set("aart", icon, "..icon..")
            set("abpx", x, buttonPosX)
            set("abpy", y, buttonPosY)
            for i = 1, levelsAmount, 1 do
                if (base == "PARALLEL_IMMEDIATE") then
                    setLv("abuf", i, "BPar", "")
                end
                if (showAreaRange[i]) then
                    setLv("aare", i, areaRange[i], 0)
                end
                setLv("acas", i, castTime[i], 0)
                setLv("acdn", i, cooldown[i], 0)
                setLv("amcs", i, manaCost[i], 0)
                setLv("aran", i, range[i], 0)
                setLv("atar", i, targets[i], "")
                setLv("atp1", i, tooltip[i], "")
            end

            for level = 1, levelsAmount, 1 do
                uberTooltip[level] = replaceTags(uberTooltip[level], level)

                for buff in sharedBuffs do
                    uberTooltip[level] = uberTooltip[level].."|n|n"..buff:getDescription()
                end

                if (lore ~= nil) then
                    uberTooltip[level] = uberTooltip[level].."|n|n"..Color.GOLD..lore..Color.RESET
                end

                if (cooldown[level] ~= nil) then
                    if (cooldown[level] > 0) then
                        uberTooltip[level] = uberTooltip[level].."|n|n"..Color.DWC.."Cooldown: "..Color.GOLD..cooldown[level]..Color.DWC.." seconds"..Color.RESET
                    end
                end

                setLv("aub1", level, uberTooltip[level], "")
            end
            if (channelBased) then
                if (order ~= nil) then
                    for level = 1, levelsAmount, 1 do
                        setLv("Ncl6", level, order)
                    end
                end
                for level = 1, levelsAmount, 1 do
                    setLv("Ncl1", level, 0, 0)
                    setLv("Ncl2", level, targetType, 0)
                end

                for level = 1, levelsAmount, 1 do
                    if (showAreaRange[level]) then
                        setLv("Ncl3", level, 19)
                    else
                        setLv("Ncl3", level, 17)
                    end
                    setLv("Ncl4", level, 0)
                    setLv("Ncl5", level, "\0")
                end
            end

            if (isHeroSpell) then
                learnSlot = LEARN_SLOT[class]
                researchHotkey = ]]..LEARN_HOTKEY[class]..[[

                learnPrefix = LEARN_PREFIX[learnSlot]

                createobject("ANeg", "C"..researchRaw..index)

                set("abpx", 0)
                set("abpy", 0)
                set("ahky", "")
                set("alev", levelsAmount)
                set("anam", name.." Hero Spell Replacer "..index)
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
                        setLv("Neg3", level, "AHS"..index..","..learnPrefix..researchRaw..(level - 1))
                    else
                        setLv("Neg3", level, learnPrefix..researchRaw..(level - 2)..","..learnPrefix..researchRaw..(level - 1))
                    end
                    setLv("Neg4", level, "")
                    setLv("Neg5", level, "")
                    setLv("Neg6", level, "")
                end

                for level = 1, levelsAmount, 1 do
                    if (researchUberTooltip[level] ~= nil) then
                        researchUberTooltip[level] = replaceTags(researchUberTooltip[level], level)
                    end

                    createobject("ANcl", learnPrefix..researchRaw..(level - 1))

                    set("aani", "")
                    set("aart", "")
                    set("abpx", 0)
                    set("acap", "")
                    set("acat", "")
                    set("aeat", "")
                    set("ahky", "")
                    set("alev", 1)
                    set("anam", name.." Hero Spell Learner "..learnSlot.." Level "..level)
                    set("arac", "other")
                    for i3 = 1, 1, 1 do
                        setLv("aran", i3, 0)
                        setLv("Ncl1", i3, 0)
                        setLv("Ncl3", i3, 0)
                        setLv("Ncl4", i3, 0)
                        setLv("Ncl5", i3, "\0")
                    end
                    set("arar", icon, "")
                    set("aret", "Learn ("..Color.GOLD..hotkey..Color.RESET..") "..Color.DWC..name..Color.RESET.." ["..Color.GOLD.."Level %d"..Color.RESET.."]")
                    set("arhk", researchHotkey)
                    set("arpx", LEARN_BUTTON_POS_X[class])
                    set("arpy", LEARN_BUTTON_POS_Y[class])
                    set("arut", researchUberTooltip[level], "")
                    set("ata0", "")
                    set("atat", "")
                    setLv("atp1", 1, "")
                    setLv("aub1", 1, "")
                    setLv("Ncl6", 1, "")
                end
            end
        ]])

        file:close()
    end

    buildObjectMergerInput()
end

function addFile(path)
    filePathsCount = filePathsCount + 1

    filePaths[filePathsCount] = "..\\"..path
end

file = io.open("paths.txt", "r")
filePaths = {}
filePathsCount = 0

for line in file:lines() do
    if (line ~= nil) then
        addFile(line)
    end
end

file:close()

while (filePathsCount > 0) do
    print("load "..filePaths[filePathsCount])
    updateFile(filePaths[filePathsCount])

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
