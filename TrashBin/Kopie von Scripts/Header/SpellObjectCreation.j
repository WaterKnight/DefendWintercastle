struct SpellObjectCreation
    static integer RESEARCH_RAW
    static integer RESEARCH_REPLACER_RAW
    static constant integer TARGET_TYPE_IMMEDIATE = 0
    static constant integer TARGET_TYPE_PASSIVE = 1
    static constant integer TARGET_TYPE_POINT = 2
    static constant integer TARGET_TYPE_POINT_OR_UNIT = 3
    static constant integer TARGET_TYPE_UNIT = 4
    static Spell TEMP
    static integer TEMP_RAW

    static boolean IS_HERO_SPELL

    static constant boolean DATA_TYPE_boolean_IS_BOOLEAN = true
    static constant boolean DATA_TYPE_integer_IS_INTEGER = true
    static constant boolean DATA_TYPE_real_IS_REAL = true
    static constant boolean DATA_TYPE_string_IS_STRING = true

    static constant boolean TYPE_PARALLEL_IMMEDIATE_IS_PARALLEL_IMMEDIATE = true

        static constant boolean CLASS_ARTIFACT_IS_HERO_SPELL = false
        static constant boolean CLASS_HERO_FIRST_IS_HERO_SPELL = true
        static constant boolean CLASS_HERO_SECOND_IS_HERO_SPELL = true
        static constant boolean CLASS_HERO_ULTIMATE_EX_IS_HERO_SPELL = true
        static constant boolean CLASS_HERO_ULTIMATE_IS_HERO_SPELL = true
        static constant boolean CLASS_ITEM_IS_HERO_SPELL = false
        static constant boolean CLASS_NORMAL_IS_HERO_SPELL = false
        static constant boolean CLASS_PURCHASABLE_IS_HERO_SPELL = true

        static constant integer CLASS_ARTIFACT_LEVELS_AMOUNT = 5
        static constant integer CLASS_HERO_FIRST_LEVELS_AMOUNT = 5
        static constant integer CLASS_HERO_SECOND_LEVELS_AMOUNT = 5
        static constant integer CLASS_HERO_ULTIMATE_EX_LEVELS_AMOUNT = 2
        static constant integer CLASS_HERO_ULTIMATE_LEVELS_AMOUNT = 3
        static constant integer CLASS_ITEM_LEVELS_AMOUNT = 1
        static constant integer CLASS_NORMAL_LEVELS_AMOUNT = 1
        static constant integer CLASS_PURCHASABLE_LEVELS_AMOUNT = 5
endstruct

//! externalblock extension=lua ObjectMerger $FILENAME$
    //! i file = io.open("spellsDelete.lua", "r")

    //! i if (file ~= nil) then
        //! i delCur = file:read() + 0

        //! i for i = 0, delCur, 1 do
            //! i os.remove("spell"..i..".lua")
        //! i end

        //! i file:close()
    //! i end

    //! i file = io.open("spells.lua", "w+")

    //! i file:write(-1)

    //! i file:close()

    //! i file = io.open("spellsDelete.lua", "w+")

    //! i file:write(-1)

    //! i file:close()

    //! i file = io.open("objectMergerInput.lua", "w+")

    //! i file:close()
//! endexternalblock

//! textmacro Spell_Destroy takes raw
//! endtextmacro

//! textmacro Spell_OpenScope takes doExternal
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i file = io.open("spells.lua", "r")

        //! i cur = file:read() + 1

        //! i file:close()

        //! i file = io.open("spells.lua", "w+")

        //! i file:write(cur)

        //! i file:close()

        //! i file = io.open("spellsDelete.lua", "r")

        //! i delCur = file:read() + 0

        //! i file:close()

        //! i if (cur > delCur) then
            //! i file = io.open("spellsDelete.lua", "w+")

            //! i file:write(cur)

            //! i file:close()
        //! i end

        //! i file = io.open("spell"..cur..".lua", "w+")

        //! i file:close()

        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i --START OF OpenScope
            //! i

            //! i Color = {}

            //! i Color.DWC = "|cff00bfff"
            //! i Color.GOLD = "|cffffcc00"
            //! i Color.RESET = "|r"

            //! i Color.CHANNEL = "|cff00ffff"
            //! i Color.COLDNESS = "|cff0000ff"
            //! i Color.ECLIPSE = "|cffff00ff"
            //! i Color.IGNITION = "|cffff0000"
            //! i Color.INVISIBILITY = "|cffffff00"
            //! i Color.POISON = "|cff00ff00"
            //! i Color.SILENCE = "|cffc8b380"
            //! i Color.SLEEP = "|cff00ffff"
            //! i Color.SPELL_SHIELD = "|cffff00ff"

            //! i Math = {}

            //! i Math.QUARTER_ANGLE = 1.57

            //! i BUFF_DESCRIPTIONS = {}

            //! i BUFF_DESCRIPTIONS["CHANNEL"] = Color.CHANNEL.."Channel"..Color.RESET.."|nThe cast of an ability is being woven. While doing so, the unit cannot move nor attack but fire other non-channeling spells and use items. An issued 'Stop' order will cancel everything."
            //! i BUFF_DESCRIPTIONS["COLDNESS"] = Color.COLDNESS.."Coldness"..Color.RESET.."|nReduces attack speed by "..Color.GOLD.."25%"..Color.RESET.." and move speed by "..Color.GOLD.."25%"..Color.RESET..". Cold units take "..Color.GOLD.."135%"..Color.RESET.." damage when being below "..Color.GOLD.."35%"..Color.RESET.." life."
            //! i BUFF_DESCRIPTIONS["ECLIPSE"] = Color.ECLIPSE.."Eclipse"..Color.RESET.."|nDecreases move speed by "..Color.GOLD.."30%"..Color.RESET..", spellpower by "..Color.GOLD.."50%"..Color.RESET.." and mana regeneration by "..Color.GOLD.."50%"..Color.RESET.."%."
            //! i BUFF_DESCRIPTIONS["IGNITION"] = Color.IGNITION.."Ignition"..Color.RESET.."|nUnveils invisible units and causes "..Color.GOLD.."5%"..Color.RESET.." ("..Color.GOLD.."2%"..Color.RESET..") magic damage every second."
            //! i BUFF_DESCRIPTIONS["INVISIBILITY"] = Color.INVISIBILITY.."Invisibility"..Color.RESET.."|nCarriers of this buff are masked to non-allies. Performing attacks or casting abilities reveals oneself. Invisible units are sure to deal a critical strike when they surprise with a stealthed melee attack."
            //! i BUFF_DESCRIPTIONS["POISON"] = Color.POISON.."Poison"..Color.RESET.."|nReduces attack speed by "..Color.GOLD.."35%"..Color.RESET.." and move speed by "..Color.GOLD.."20%"..Color.RESET..". Poisoned units regenerate their hitpoints only half as fast."
            //! i BUFF_DESCRIPTIONS["SILENCE"] = Color.SILENCE.."Silence"..Color.RESET.."|nSilenced units are unable to cast abilities."
            //! i BUFF_DESCRIPTIONS["SLEEP"] = Color.SLEEP.."Sleep"..Color.RESET.."|nSleeping units are unable to act and wake up when attacked. This damage is sure to be critical."
            //! i BUFF_DESCRIPTIONS["SPELL_SHIELD"] = Color.SPELL_SHIELD.."Spell Shield"..Color.RESET.."|nProtects the unit from many disadvantageous magical effects. Unlike 'Magic Immunity', the 'Spell Shield' blocks only one such thing and then disperses."

            //! i CLASS_ARTIFACT = 0
            //! i CLASS_HERO_FIRST = 1
            //! i CLASS_HERO_SECOND = 2
            //! i CLASS_HERO_ULTIMATE = 3
            //! i CLASS_HERO_ULTIMATE_EX = 4
            //! i CLASS_ITEM = 5
            //! i CLASS_NORMAL = 6
            //! i CLASS_PURCHASABLE = 7

            //! i function set(field, value, default)
                //! i if (value == nil) then
                    //! i makechange(current, field, default)
                //! i else
                    //! i makechange(current, field, value)
                //! i end
            //! i end

            //! i function setLv(field, level, value, default)
                //! i if (value == nil) then
                    //! i makechange(current, field, level, default)
                //! i else
                    //! i makechange(current, field, level, value)
                //! i end
            //! i end

            //! i function setLevelsAmount(value)
                //! i levelsAmount = value

                //! i if (value == 1) then
                    //! i tooltip[1] = Color.DWC..name..Color.RESET
                //! i else
                    //! i for i = 1, value, 1 do
                        //! i tooltip[i] = Color.DWC..name..Color.RESET.." ["..Color.GOLD.."Level "..i..Color.RESET.."]"
                    //! i end
                //! i end
            //! i end

            //! i function addSharedBuff(value)
                //! i sharedBuffsCount = sharedBuffsCount + 1

                //! i sharedBuffs[sharedBuffsCount] = value
            //! i end

            //! i function addData(name, values)
                //! i if (name == nil) then
                    //! i return
                //! i end

                //! i it = 1

                //! i datasCount = datasCount + 1

                //! i datas[datasCount] = name
                //! i datasValue[datasCount] = {}

                //! i while (values[it] ~= nil) do
                    //! i datasValue[datasCount][it] = values[it]

                    //! i it = it + 1
                //! i end
            //! i end

            //! i areaRange = {}
            //! i castTime = {}
            //! i channelTime = {}
            //! i cooldown = {}
            //! i datas = {}
            //! i datasCount = 0
            //! i datasValue = {}
            //! i isHeroSpell = false
            //! i manaCost = {}
            //! i range = {}
            //! i sharedBuffs = {}
            //! i sharedBuffsCount = 0
            //! i showAreaRange = {}
            //! i targets = {}
            //! i tooltip = {}
            //! i uberTooltip = {}
            //! i
            //! i --END OF OpenScope
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_Create takes doExternal, var, raw, name
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i --CREATE SPELL "$name$"
            //! i
            //! i name = "$name$"
            //! i raw = "$raw$"
        //! i ]])
    $doExternal$//! endexternalblock

    set $var$ = Spell.CreateFromSelf('$raw$')

    set SpellObjectCreation.TEMP = $var$

    call SpellObjectCreation.TEMP.SetName("$name$")
//! endtextmacro

//! textmacro Spell_SetLevelsAmount takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i setLevelsAmount($value$)
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetLevelsAmount($value$)
//! endtextmacro

//! textmacro Spell_SetTypes takes doExternal, value, class
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i class = CLASS_$class$
            //! i setobjecttype("abilities")

            //! i if ("$value$" == "NORMAL") then
                //! i channelBased = true
                //! i showAreaRange = {}
                //! i createobject("ANcl", raw)

                //! i set("acap", "")
                //! i set("acat", "")
                //! i set("aeat", "")
                //! i set("aher", "\0")
                //! i set("ahky", "")
                //! i set("anam", name)
                //! i set("ata0", "")
                //! i set("atat", "")
            //! i elseif ("$value$" == "PARALLEL_IMMEDIATE") then
                //! i order = "berserk"
                //! i parallelImmediate = true

                //! i createobject("Absk", raw)

                //! i set("ahky", "")
                //! i set("anam", name)
                //! i set("ata0", "")
                //! i set("atat", "")
            //! i elseif ("$value$" == "PASSIVE") then
                //! i createobject("Agyb", raw)

                //! i set("acap", "")
                //! i set("acat", "")
                //! i set("aeat", "")
                //! i set("aher", "\0")
                //! i set("ahky", "")
                //! i set("anam", name)
                //! i set("areq", "")
                //! i set("ata0", "")
                //! i set("atat", "")
            //! i elseif (string.sub("$value$", 1, 1 + 7 - 1) == "SPECIAL") then
                //! i createobject(string.sub("$value$", 1 + 7 + 1, string.len("$value$")), raw)

                //! i set("acap", "")
                //! i set("acat", "")
                //! i set("aeat", "")
                //! i set("aher", "\0")
                //! i set("ahky", "")
                //! i set("anam", name)
                //! i set("ata0", "")
                //! i set("atat", "")
            //! i end

            //! i if ("$class$" == "ARTIFACT") then
                //! i hotkey = "F"
                //! i if (x == nil) then
                    //! i x = 1
                    //! i y = 1
                //! i end
                //! i if (levelsAmount == nil) then
                    //! i setLevelsAmount(5)
                //! i end
            //! i elseif ("$class$" == "HERO_FIRST") then
                //! i hotkey = "Q"
                //! i isHeroSpell = true
                //! i if (x == nil) then
                    //! i x = 0
                    //! i y = 2
                //! i end
                //! i if (levelsAmount == nil) then
                    //! i setLevelsAmount(5)
                //! i end
            //! i elseif ("$class$" == "HERO_SECOND") then
                //! i hotkey = "W"
                //! i isHeroSpell = true
                //! i if (x == nil) then
                    //! i x = 1
                    //! i y = 2
                //! i end
                //! i if (levelsAmount == nil) then
                    //! i setLevelsAmount(5)
                //! i end
            //! i elseif ("$class$" == "HERO_ULTIMATE") then
                //! i hotkey = "E"
                //! i isHeroSpell = true
                //! i if (x == nil) then
                    //! i x = 2
                    //! i y = 2
                //! i end
                //! i if (levelsAmount == nil) then
                    //! i setLevelsAmount(3)
                //! i end
            //! i elseif ("$class$" == "HERO_ULTIMATE_EX") then
                //! i hotkey = "R"
                //! i isHeroSpell = true
                //! i if (x == nil) then
                    //! i x = 3
                    //! i y = 2
                //! i end
                //! i if (levelsAmount == nil) then
                    //! i setLevelsAmount(2)
                //! i end
            //! i elseif ("$class$" == "ITEM") then
                //! i set("aite", 1)
                //! i if (levelsAmount == nil) then
                    //! i setLevelsAmount(1)
                //! i end
            //! i elseif ("$class$" == "NORMAL") then
                //! i hotkey = "Q"
                //! i if (x == nil) then
                    //! i x = 0
                    //! i y = 2
                //! i end
                //! i if (levelsAmount == nil) then
                    //! i setLevelsAmount(1)
                //! i end
            //! i elseif ("$class$" == "PURCHASABLE") then
                //! i hotkey = "T"
                //! i isHeroSpell = true
                //! i if (x == nil) then
                    //! i x = 2
                    //! i y = 1
                //! i end
                //! i if (levelsAmount == nil) then
                    //! i setLevelsAmount(5)
                //! i end
            //! i end

            //! i set("ahky", hotkey)
        //! i ]])
    $doExternal$//! endexternalblock

    static if (SpellObjectCreation.CLASS_$class$_IS_HERO_SPELL) then
        set SpellObjectCreation.IS_HERO_SPELL = true
    else
        set SpellObjectCreation.IS_HERO_SPELL = false
    endif
    call SpellObjectCreation.TEMP.SetClass(SpellClass.$class$)
    if (SpellObjectCreation.TEMP.GetLevelsAmount() == 0) then
        call SpellObjectCreation.TEMP.SetLevelsAmount(SpellObjectCreation.CLASS_$class$_LEVELS_AMOUNT)
    endif
    static if (SpellObjectCreation.TYPE_$value$_IS_PARALLEL_IMMEDIATE) then
        call SpellObjectCreation.TEMP.SetOrder(Order.BERSERK)
    endif
//! endtextmacro

//! textmacro Spell_Finalize takes doExternal
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i function replace(a, sub, rep, gold)
                //! i if (rep == nil) then
                    //! i rep = ""
                //! i end

                //! i c = 1
                //! i if (gold == nil) then
                    //! i rep = Color.GOLD..rep..Color.RESET
                //! i end

                //! i while (c < string.len(a) - string.len(sub) + 2) do
                    //! i if (string.sub(a, c, c + string.len(sub) - 1) == sub) then
                        //! i a = string.sub(a, 1, c - 1)..rep..string.sub(a, c + string.len(sub))
                    //! i else
                        //! i c = c + 1
                    //! i end
                //! i end

                //! i return a
            //! i end

            //! i function replaceTags(a, level)
                //! i a = string.gsub(a, "<level>", level)
                //! i a = string.gsub(a, "<prevLevel>", level - 1)

                //! i a = replace(a, "<areaRange>", areaRange[level])
                //! i a = replace(a, "<channelTime>", channelTime[level])
                //! i a = replace(a, "<cooldown>", cooldown[level])
                //! i a = replace(a, "<manaCost>", manaCost[level])
                //! i a = replace(a, "<name>", name)
                //! i for i = 1, levelsAmount, 1 do
                    //! i a = replace(a, "<areaRange"..i..">", areaRange[i])
                    //! i a = replace(a, "<channelTime"..i..">", channelTime[i])
                    //! i a = replace(a, "<cooldown"..i..">", cooldown[i])
                    //! i a = replace(a, "<manaCost"..i..">", manaCost[i])
                //! i end

                //! i for i = 1, datasCount, 1 do
                    //! i if (datasValue[i][level] == nil) then
                        //! i a = replace(a, "<"..datas[i]..">", datasValue[i][1])
                        //! i if (type(datasValue[i][1]) == "number") then
                            //! i a = replace(a, "<"..datas[i]..",%>", (datasValue[i][1] * 100).."%")
                        //! i end
                    //! i else
                        //! i a = replace(a, "<"..datas[i]..">", datasValue[i][level])
                        //! i if (type(datasValue[i][level]) == "number") then
                            //! i a = replace(a, "<"..datas[i]..",%>", (datasValue[i][level] * 100).."%")
                        //! i end
                    //! i end

                    //! i for i2 = 1, levelsAmount, 1 do
                        //! i a = replace(a, "<"..datas[i]..i2..">", datasValue[i][i2])

                        //! i if (type(datasValue[i][i2]) == "number") then
                            //! i a = replace(a, "<"..datas[i]..i2..",%>", (datasValue[i][i2] * 100).."%")
                        //! i end
                    //! i end
                //! i end

                //! i a = replace(a, "<COLDNESS>", Color.COLDNESS, false)
                //! i a = replace(a, "</COLDNESS>", Color.RESET, false)
                //! i a = replace(a, "<ECLIPSE>", Color.ECLIPSE, false)
                //! i a = replace(a, "</ECLIPSE>", Color.RESET, false)
                //! i a = replace(a, "<IGNITION>", Color.IGNITION, false)
                //! i a = replace(a, "</IGNITION>", Color.RESET, false)
                //! i a = replace(a, "<INVISIBILITY>", Color.INVISIBILITY, false)
                //! i a = replace(a, "</INVISIBILITY>", Color.RESET, false)
                //! i a = replace(a, "<POISON>", Color.POISON, false)
                //! i a = replace(a, "</POISON>", Color.RESET, false)
                //! i a = replace(a, "<SLEEP>", Color.SLEEP, false)
                //! i a = replace(a, "</SLEEP>", Color.RESET, false)

                //! i return a
            //! i end

            //! i --FINALIZE
            //! i
            //! i set("alev", levelsAmount)

            //! i for i = 1, levelsAmount, 1 do
                //! i if (uberTooltip[i] == nil) then
                    //! i if (i == 1) then
                        //! i uberTooltip[i] = ""
                    //! i else
                        //! i uberTooltip[i] = uberTooltip[i - 1]
                    //! i end
                //! i end
            //! i end

            //! i set("aani", animation, "")
            //! i set("aart", icon, "")
            //! i set("abpx", x, 0)
            //! i set("abpy", y, 0)
            //! i for i = 1, levelsAmount, 1 do
                //! i if (parallelImmediate) then
                    //! i setLv("abuf", i, "BPar", "")
                //! i end
                //! i if (showAreaRange[i]) then
                    //! i setLv("aare", i, areaRange[i], 0)
                //! i end
                //! i setLv("acas", i, castTime[i], 0)
                //! i setLv("acdn", i, cooldown[i], 0)
                //! i setLv("amcs", i, manaCost[i], 0)
                //! i setLv("aran", i, range[i], 0)
                //! i setLv("atar", i, targetsAll, "")
            //! i end

            //! i for i = 1, levelsAmount, 1 do
                //! i if (targets[i] ~= nil) then
                    //! i setLv("atar", i, targets[i])
                //! i end
            //! i end

            //! i for i = 1, levelsAmount, 1 do
                //! i if (hotkey == nil) then
                    //! i setLv("atp1", i, tooltip[i], "")
                //! i else
                    //! i setLv("atp1", i, "("..Color.GOLD..hotkey..Color.RESET..") "..tooltip[i], "")
                //! i end
            //! i end
            //! i for i = 1, levelsAmount, 1 do
                //! i uberTooltip[i] = replaceTags(uberTooltip[i], i)

                //! i for i2 = 1, sharedBuffsCount, 1 do
                    //! i buff = sharedBuffs[i2]

                    //! i uberTooltip[i] = uberTooltip[i].."|n|n"..BUFF_DESCRIPTIONS[buff]
                //! i end

                //! i if (lore ~= nil) then
                    //! i uberTooltip[i] = uberTooltip[i].."|n|n"..Color.GOLD..lore..Color.RESET
                //! i end

                //! i if (cooldown[i] ~= nil) then
                    //! i if (cooldown[i] > 0) then
                        //! i uberTooltip[i] = uberTooltip[i].."|n|n"..Color.DWC.."Cooldown: "..Color.GOLD..cooldown[i]..Color.DWC.." seconds"..Color.RESET
                    //! i end
                //! i end

                //! i setLv("aub1", i, uberTooltip[i], "")
            //! i end
            //! i if (channelBased) then
                //! i if (order ~= nil) then
                    //! i for i = 1, levelsAmount, 1 do
                        //! i setLv("Ncl6", i, order)
                    //! i end
                //! i end
                //! i for i = 1, levelsAmount, 1 do
                    //! i setLv("Ncl1", i, 0, 0)
                    //! i setLv("Ncl2", i, targetType, 0)
                //! i end

                //! i for i = 1, levelsAmount, 1 do
                    //! i if (showAreaRange[i]) then
                        //! i setLv("Ncl3", i, 19)
                    //! i else
                        //! i setLv("Ncl3", i, 17)
                    //! i end
                    //! i setLv("Ncl4", i, 0)
                    //! i setLv("Ncl5", i, "\0")
                //! i end
            //! i end

            //! i if (isHeroSpell) then
                //! i if (class == CLASS_ARTIFACT) then
                    //! i index = 4
                    //! i LEARN_BUTTON_POS_X = 0
                    //! i LEARN_BUTTON_POS_Y = 1
                    //! i LEARN_PREFIX = "K"
                //! i elseif (class == CLASS_HERO_FIRST) then
                    //! i index = 0
                    //! i LEARN_BUTTON_POS_X = 0
                    //! i LEARN_BUTTON_POS_Y = 0
                    //! i LEARN_PREFIX = "F"
                //! i elseif (class == CLASS_HERO_SECOND) then
                    //! i index = 1
                    //! i LEARN_BUTTON_POS_X = 1
                    //! i LEARN_BUTTON_POS_Y = 0
                    //! i LEARN_PREFIX = "G"
                //! i elseif (class == CLASS_HERO_ULTIMATE) then
                    //! i index = 2
                    //! i LEARN_BUTTON_POS_X = 2
                    //! i LEARN_BUTTON_POS_Y = 0
                    //! i LEARN_PREFIX = "H"
                //! i elseif (class == CLASS_HERO_ULTIMATE_EX) then
                    //! i index = 3
                    //! i LEARN_BUTTON_POS_X = 3
                    //! i LEARN_BUTTON_POS_Y = 0
                    //! i LEARN_PREFIX = "J"
                //! i end

                //! i for level = 1, levelsAmount, 1 do
                    //! i if (researchUberTooltip[level] == nil) then
                        //! i researchUberTooltip[level] = researchUberTooltip[level - 1]
                    //! i end
                //! i end

                //! i createobject("ANeg", "C"..researchRaw..index)

                //! i set("abpx", 0)
                //! i set("abpy", 0)
                //! i set("ahky", "")
                //! i set("alev", levelsAmount)
                //! i set("anam", name.." Hero Spell Replacer "..index)
                //! i set("arac", "other")
                //! i set("aret", "")
                //! i set("arhk", "")
                //! i set("arpx", 0)
                //! i set("arut", "")
                //! i for level = 1, levelsAmount, 1 do
                    //! i setLv("abuf", level, "BHSR")
                    //! i setLv("atp1", level, "")
                    //! i setLv("aub1", level, "")
                    //! i setLv("Neg1", level, 0)
                    //! i setLv("Neg2", level, 0)
                    //! i if (level == 1) then
                        //! i setLv("Neg3", level, "AHS"..index..","..LEARN_PREFIX..researchRaw..(level - 1))
                    //! i else
                        //! i setLv("Neg3", level, LEARN_PREFIX..researchRaw..(level - 2)..","..LEARN_PREFIX..researchRaw..(level - 1))
                    //! i end
                    //! i setLv("Neg4", level, "")
                    //! i setLv("Neg5", level, "")
                    //! i setLv("Neg6", level, "")
                //! i end

                //! i for level = 1, levelsAmount, 1 do
                    //! i if (researchUberTooltip[level] ~= nil) then
                        //! i researchUberTooltip[level] = replaceTags(researchUberTooltip[level], level)
                    //! i end

                    //! i createobject("ANcl", LEARN_PREFIX..researchRaw..(level - 1))

                    //! i set("aani", "")
                    //! i set("aart", "")
                    //! i set("abpx", 0)
                    //! i set("acap", "")
                    //! i set("acat", "")
                    //! i set("aeat", "")
                    //! i set("ahky", "")
                    //! i set("alev", 1)
                    //! i set("anam", name.." Hero Spell Learner "..index.." Level "..level)
                    //! i set("arac", "other")
                    //! i for i3 = 1, 1, 1 do
                        //! i setLv("aran", i3, 0)
                        //! i setLv("Ncl1", i3, 0)
                        //! i setLv("Ncl3", i3, 0)
                        //! i setLv("Ncl4", i3, 0)
                        //! i setLv("Ncl5", i3, "\0")
                    //! i end
                    //! i set("arar", icon, "")
                    //! i set("aret", "Learn ("..Color.GOLD..hotkey..Color.RESET..") "..Color.DWC..name..Color.RESET.." ["..Color.GOLD.."Level %d"..Color.RESET.."]")
                    //! i set("arhk", hotkey)
                    //! i set("arpx", LEARN_BUTTON_POS_X)
                    //! i set("arpy", LEARN_BUTTON_POS_Y)
                    //! i set("arut", researchUberTooltip[level], "")
                    //! i set("ata0", "")
                    //! i set("atat", "")
                    //! i setLv("atp1", 1, "")
                    //! i setLv("aub1", 1, "")
                    //! i setLv("Ncl6", 1, "")
                //! i end
            //! i end
        //! i ]])

        //! i file = io.open("spell"..cur..".lua", "r")

        //! i code = file:read("*a")

        //! i file:close()

        //! i file = io.open("objectMergerInput.lua", "w+")

        //! i file:write(code)

        //! i file:close()

        //! i file = io.open("spells.lua", "r")

        //! i cur = file:read() - 1

        //! i file:close()

        //! i file = io.open("spells.lua", "w")

        //! i file:write(cur)

        //! i file:close()
    $doExternal$//! endexternalblock

    if (SpellObjectCreation.IS_HERO_SPELL) then
        call HeroSpell.InitSpell(SpellObjectCreation.TEMP, SpellObjectCreation.RESEARCH_RAW, SpellObjectCreation.TEMP.GetLevelsAmount(), SpellObjectCreation.RESEARCH_REPLACER_RAW)
    endif

    $doExternal$//! external ObjectMerger objectMergerInput.lua
//! endtextmacro

//! textmacro Spell_SetAnimation takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i animation = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetAnimation("$value$")
//! endtextmacro

//! textmacro Spell_SetAreaRange takes doExternal, value, showGraphic
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i areaRange[1] = $value$
            //! i showAreaRange[1] = $showGraphic$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetAreaRange(1, $value$)
//! endtextmacro

//! textmacro Spell_SetAreaRange2 takes doExternal, value, value2, showGraphic
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i areaRange[1] = $value$
            //! i areaRange[2] = $value2$
            //! i showAreaRange[1] = $showGraphic$
            //! i showAreaRange[2] = $showGraphic$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetAreaRange(1, $value$)
    call SpellObjectCreation.TEMP.SetAreaRange(2, $value2$)
//! endtextmacro

//! textmacro Spell_SetAreaRange3 takes doExternal, value, value2, value3, showGraphic
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i areaRange[1] = $value$
            //! i areaRange[2] = $value2$
            //! i areaRange[3] = $value3$
            //! i showAreaRange[1] = $showGraphic$
            //! i showAreaRange[2] = $showGraphic$
            //! i showAreaRange[3] = $showGraphic$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetAreaRange(1, $value$)
    call SpellObjectCreation.TEMP.SetAreaRange(2, $value2$)
    call SpellObjectCreation.TEMP.SetAreaRange(3, $value3$)
//! endtextmacro

//! textmacro Spell_SetAreaRange5 takes doExternal, value, value2, value3, value4, value5, showGraphic
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i areaRange[1] = $value$
            //! i areaRange[2] = $value2$
            //! i areaRange[3] = $value3$
            //! i areaRange[4] = $value4$
            //! i areaRange[5] = $value5$
            //! i showAreaRange[1] = $showGraphic$
            //! i showAreaRange[2] = $showGraphic$
            //! i showAreaRange[3] = $showGraphic$
            //! i showAreaRange[4] = $showGraphic$
            //! i showAreaRange[5] = $showGraphic$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetAreaRange(1, $value$)
    call SpellObjectCreation.TEMP.SetAreaRange(2, $value2$)
    call SpellObjectCreation.TEMP.SetAreaRange(3, $value3$)
    call SpellObjectCreation.TEMP.SetAreaRange(4, $value4$)
    call SpellObjectCreation.TEMP.SetAreaRange(5, $value5$)
//! endtextmacro

//! textmacro Spell_SetAreaRangeLv takes doExternal, level, value, showGraphic
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i areaRange[$level$] = $value$
            //! i showAreaRange[$level$] = $showGraphic$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetAreaRange(level, $value$)
//! endtextmacro

//! textmacro Spell_SetButtonPosition takes doExternal, x, y
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i x = $x$
            //! i y = $y$
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetCastTime takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i castTime[1] = $value$
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetCastTime2 takes doExternal, value, value2
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i castTime[1] = $value$
            //! i castTime[2] = $value2$
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetCastTime3 takes doExternal, value, value2, value3
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i castTime[1] = $value$
            //! i castTime[2] = $value2$
            //! i castTime[3] = $value3$
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetCastTime5 takes doExternal, value, value2, value3, value4, value5
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i castTime[1] = $value$
            //! i castTime[2] = $value2$
            //! i castTime[3] = $value3$
            //! i castTime[4] = $value4$
            //! i castTime[5] = $value5$
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetCastTimeLv takes doExternal, level, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i castTime[$level$] = $value$
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetChannelTime takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i channelTime[1] = $value$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetChannelTime(1, $value$)
//! endtextmacro

//! textmacro Spell_SetChannelTime2 takes doExternal, value, value2
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i channelTime[1] = $value$
            //! i channelTime[2] = $value2$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetChannelTime(1, $value$)
    call SpellObjectCreation.TEMP.SetChannelTime(2, $value2$)
//! endtextmacro

//! textmacro Spell_SetChannelTime3 takes doExternal, value, value2, value3
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i channelTime[1] = $value$
            //! i channelTime[2] = $value2$
            //! i channelTime[3] = $value3$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetChannelTime(1, $value$)
    call SpellObjectCreation.TEMP.SetChannelTime(2, $value2$)
    call SpellObjectCreation.TEMP.SetChannelTime(3, $value3$)
//! endtextmacro

//! textmacro Spell_SetChannelTime5 takes doExternal, value, value2, value3, value4, value5
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i channelTime[1] = $value$
            //! i channelTime[2] = $value2$
            //! i channelTime[3] = $value3$
            //! i channelTime[4] = $value4$
            //! i channelTime[5] = $value5$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetChannelTime(1, $value$)
    call SpellObjectCreation.TEMP.SetChannelTime(2, $value2$)
    call SpellObjectCreation.TEMP.SetChannelTime(3, $value3$)
    call SpellObjectCreation.TEMP.SetChannelTime(4, $value4$)
    call SpellObjectCreation.TEMP.SetChannelTime(5, $value5$)
//! endtextmacro

//! textmacro Spell_SetChannelTimeLv takes doExternal, level, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i channelTime[$level$] = $value$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetChannelTime($level$, $value$)
//! endtextmacro

//! textmacro Spell_SetCooldown takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i cooldown[1] = $value$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetCooldown(1, $value$)
//! endtextmacro

//! textmacro Spell_SetCooldown2 takes doExternal, value, value2
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i cooldown[1] = $value$
            //! i cooldown[2] = $value2$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetCooldown(1, $value$)
    call SpellObjectCreation.TEMP.SetCooldown(2, $value2$)
//! endtextmacro

//! textmacro Spell_SetCooldown3 takes doExternal, value, value2, value3
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i cooldown[1] = $value$
            //! i cooldown[2] = $value2$
            //! i cooldown[3] = $value3$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetCooldown(1, $value$)
    call SpellObjectCreation.TEMP.SetCooldown(2, $value2$)
    call SpellObjectCreation.TEMP.SetCooldown(3, $value3$)
//! endtextmacro

//! textmacro Spell_SetCooldown5 takes doExternal, value, value2, value3, value4, value5
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i cooldown[1] = $value$
            //! i cooldown[2] = $value2$
            //! i cooldown[3] = $value3$
            //! i cooldown[4] = $value4$
            //! i cooldown[5] = $value5$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetCooldown(1, $value$)
    call SpellObjectCreation.TEMP.SetCooldown(2, $value2$)
    call SpellObjectCreation.TEMP.SetCooldown(3, $value3$)
    call SpellObjectCreation.TEMP.SetCooldown(4, $value4$)
    call SpellObjectCreation.TEMP.SetCooldown(5, $value5$)
//! endtextmacro

//! textmacro Spell_SetCooldownLv takes doExternal, level, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i cooldown[$level$] = $value$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetCooldown($level$, $value$)
//! endtextmacro

//! textmacro Spell_SetData takes doExternal, var, name, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i if ("$name$" ~= "") then
                //! i addData("$name$", {$value$})
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    set thistype(NULL).$var$ = $value$
//! endtextmacro

//! textmacro Spell_SetDataOfType takes doExternal, type, var, name, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i if ("$type$" == "string") then
            //! i writeLua([[
                //! i if ("$name$" ~= "") then
                    //! i addData("$name$", {"$value$"})
                //! i end
            //! i ]])
        //! i else
            //! i writeLua([[
                //! i if ("$name$" ~= "") then
                    //! i addData("$name$", {$value$})
                //! i end
            //! i ]])
        //! i end
    $doExternal$//! endexternalblock

    static if (SpellObjectCreation.DATA_TYPE_$type$_IS_BOOLEAN) then
        set thistype(NULL).$var$ = $value$
    elseif (SpellObjectCreation.DATA_TYPE_$type$_IS_INTEGER) then
        set thistype(NULL).$var$ = $value$
    elseif (SpellObjectCreation.DATA_TYPE_$type$_IS_REAL) then
        set thistype(NULL).$var$ = $value$
    elseif (SpellObjectCreation.DATA_TYPE_$type$_IS_STRING) then
        set thistype(NULL).$var$ = "$value$"
    else
        set thistype(NULL).$var$ = $value$
    endif
//! endtextmacro

//! textmacro Spell_SetData2 takes doExternal, var, name, value, value2
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i if ("$name$" ~= "") then
                //! i addData("$name$", {$value$, $value2$})
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    set thistype(NULL).$var$[1] = $value$
    set thistype(NULL).$var$[2] = $value2$
//! endtextmacro

//! textmacro Spell_SetData3 takes doExternal, var, name, value, value2, value3
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i if ("$name$" ~= "") then
                //! i addData("$name$", {$value$, $value2$, $value3$})
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    set thistype(NULL).$var$[1] = $value$
    set thistype(NULL).$var$[2] = $value2$
    set thistype(NULL).$var$[3] = $value3$
//! endtextmacro

//! textmacro Spell_SetData5 takes doExternal, var, name, value, value2, value3, value4, value5
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i if ("$name$" ~= "") then
                //! i addData("$name$", {$value$, $value2$, $value3$, $value4$, $value5$})
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    set thistype(NULL).$var$[1] = $value$
    set thistype(NULL).$var$[2] = $value2$
    set thistype(NULL).$var$[3] = $value3$
    set thistype(NULL).$var$[4] = $value4$
    set thistype(NULL).$var$[5] = $value5$
//! endtextmacro

//! textmacro Spell_SetData6 takes doExternal, var, name, value, value2, value3, value4, value5, value6
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i if ("$name$" ~= "") then
                //! i addData("$name$", {$value$, $value2$, $value3$, $value4$, $value5$, $value6$})
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    set thistype(NULL).$var$[1] = $value$
    set thistype(NULL).$var$[2] = $value2$
    set thistype(NULL).$var$[3] = $value3$
    set thistype(NULL).$var$[4] = $value4$
    set thistype(NULL).$var$[5] = $value5$
    set thistype(NULL).$var$[6] = $value6$
//! endtextmacro

//! textmacro Spell_SetIcon takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i icon = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetIcon("$value$")
//! endtextmacro

//! textmacro Spell_SetLore takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i lore = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetManaCost takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i manaCost[1] = $value$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetManaCost(1, $value$)
//! endtextmacro

//! textmacro Spell_SetManaCost2 takes doExternal, value, value2
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i manaCost[1] = $value$
            //! i manaCost[2] = $value2$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetManaCost(1, $value$)
    call SpellObjectCreation.TEMP.SetManaCost(2, $value2$)
//! endtextmacro

//! textmacro Spell_SetManaCost3 takes doExternal, value, value2, value3
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i manaCost[1] = $value$
            //! i manaCost[2] = $value2$
            //! i manaCost[3] = $value3$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetManaCost(1, $value$)
    call SpellObjectCreation.TEMP.SetManaCost(2, $value2$)
    call SpellObjectCreation.TEMP.SetManaCost(3, $value3$)
//! endtextmacro

//! textmacro Spell_SetManaCost5 takes doExternal, value, value2, value3, value4, value5
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i manaCost[1] = $value$
            //! i manaCost[2] = $value2$
            //! i manaCost[3] = $value3$
            //! i manaCost[4] = $value4$
            //! i manaCost[5] = $value5$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetManaCost(1, $value$)
    call SpellObjectCreation.TEMP.SetManaCost(2, $value2$)
    call SpellObjectCreation.TEMP.SetManaCost(3, $value3$)
    call SpellObjectCreation.TEMP.SetManaCost(4, $value4$)
    call SpellObjectCreation.TEMP.SetManaCost(5, $value5$)
//! endtextmacro

//! textmacro Spell_SetManaCostLv takes doExternal, level, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i manaCost[$level$] = $value$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetManaCost($level$, $value$)
//! endtextmacro

//! textmacro Spell_SetOrder takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i order = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetOrder(Order.GetFromSelf(OrderId("$value$")))
//! endtextmacro

//! textmacro Spell_SetRange takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i range[1] = $value$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetRange(1, $value$)
//! endtextmacro

//! textmacro Spell_SetRange2 takes doExternal, value, value2
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i range[1] = $value$
            //! i range[2] = $value2$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetRange(1, $value$)
    call SpellObjectCreation.TEMP.SetRange(2, $value2$)
//! endtextmacro

//! textmacro Spell_SetRange3 takes doExternal, value, value2, value3
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i range[1] = $value$
            //! i range[2] = $value2$
            //! i range[3] = $value3$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetRange(1, $value$)
    call SpellObjectCreation.TEMP.SetRange(2, $value2$)
    call SpellObjectCreation.TEMP.SetRange(3, $value3$)
//! endtextmacro

//! textmacro Spell_SetRange5 takes doExternal, value, value2, value3, value4, value5
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i range[1] = $value$
            //! i range[2] = $value2$
            //! i range[3] = $value3$
            //! i range[4] = $value4$
            //! i range[5] = $value5$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetRange(1, $value$)
    call SpellObjectCreation.TEMP.SetRange(2, $value2$)
    call SpellObjectCreation.TEMP.SetRange(3, $value3$)
    call SpellObjectCreation.TEMP.SetRange(4, $value4$)
    call SpellObjectCreation.TEMP.SetRange(5, $value5$)
//! endtextmacro

//! textmacro Spell_SetRangeLv takes doExternal, level, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i range[$level$] = $value$
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetRange($level$, $value$)
//! endtextmacro

//! textmacro Spell_AddSharedBuff takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i addSharedBuff("$value$")
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetTargets takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i targetsAll = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetTargetsLv takes doExternal, level, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i targets[$level$] = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetTargetType takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i if ("$value$" == "IMMEDIATE") then
                //! i targetType = 0
            //! i elseif ("$value$" == "POINT") then
                //! i targetType = 2
            //! i elseif ("$value$" == "POINT_OR_UNIT") then
                //! i targetType = 3
            //! i elseif ("$value$" == "UNIT") then
                //! i targetType = 1
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_$value$)
//! endtextmacro

//! textmacro Spell_SetTooltip takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i tooltip[1] = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetTooltip2 takes doExternal, value, value2
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i tooltip[1] = "$value$"
            //! i tooltip[2] = "$value2$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetTooltip3 takes doExternal, value, value2, value3
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i tooltip[1] = "$value$"
            //! i tooltip[2] = "$value2$"
            //! i tooltip[3] = "$value3$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetTooltipLv takes doExternal, level, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i tooltip[$level$] = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetUberTooltip takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i uberTooltip[1] = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetUberTooltip2 takes doExternal, value, value2
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i uberTooltip[1] = "$value$"
            //! i uberTooltip[2] = "$value2$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetUberTooltip3 takes doExternal, value, value2, value3
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i uberTooltip[1] = "$value$"
            //! i uberTooltip[2] = "$value2$"
            //! i uberTooltip[3] = "$value3$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetUberTooltipLv takes doExternal, level, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i uberTooltip[$level$] = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Spell_SetResearchRaw takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i researchRaw = "$value$"
            //! i researchUberTooltip = {}
        //! i ]])
    $doExternal$//! endexternalblock

    set SpellObjectCreation.RESEARCH_RAW = 'F$value$0'
    set SpellObjectCreation.RESEARCH_REPLACER_RAW = 'C$value$0'
//! endtextmacro

//! textmacro Spell_SetResearchUberTooltipLv takes doExternal, level, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("spells.lua", "r")

            //! i cur = file:read()

            //! i file:close()

            //! i file = io.open("spell"..cur..".lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i researchUberTooltip[$level$] = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro