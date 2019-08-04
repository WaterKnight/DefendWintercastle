struct ItemObjectCreation
    static ItemType TEMP

    //! textmacro ItemObjectCreation_CreateScrollAbility takes doExternal, raw
        static constant integer SCROLL_SPELL_ID = '$raw$'

        $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
            //! i function set(field, value)
                //! i makechange(current, field, value)
            //! i end

            //! i function setLv(field, level, value)
                //! i makechange(current, field, level, value)
            //! i end

            //! i setobjecttype("abilities")

            //! i createobject("AImh", "$raw$")

            //! i set("acap", "")
            //! i set("acat", "")
            //! i set("anam", "Scroll")
            //! i set("aart", "")
            //! i set("aite", "\0")
            //! i set("ansf", "")
            //! i setLv("Ilif", 1, 0)
        $doExternal$//! endexternalblock
    //! endtextmacro

    //! textmacro ItemObjectCreation_CreatePowerUpAbility takes doExternal, raw
        static constant integer POWER_UP_SPELL_ID = '$raw$'

        $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
            //! i function set(field, value)
                //! i makechange(current, field, value)
            //! i end

            //! i function setLv(field, level, value)
                //! i makechange(current, field, level, value)
            //! i end

            //! i setobjecttype("abilities")

            //! i createobject("AImh", "$raw$")

            //! i set("acap", "")
            //! i set("acat", "")
            //! i set("anam", "PowerUp")
            //! i set("aart", "")
            //! i set("aite", "\0")
            //! i set("ansf", "")
            //! i setLv("Ilif", 1, 0)
        $doExternal$//! endexternalblock
    //! endtextmacro

    //! runtextmacro ItemObjectCreation_CreateScrollAbility("", "AISc")
    //! runtextmacro ItemObjectCreation_CreatePowerUpAbility("", "APUp")
endstruct

//! textmacro Item_Create takes doExternal, var, raw, name
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "w")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i POWER_UP_SPELL_ID = "APUp"

            //! i function set(field, value)
                //! i makechange(current, field, value)
            //! i end

            //! i function addAbility(value)
                //! i if (abilitiesCount == 0) then
                    //! i abilities = value
                    //! i if (cooldownGroup == nil) then
                        //! i cooldownGroup = value
                    //! i end
                //! i else
                    //! i abilities = abilities..","..value
                //! i end

                //! i abilitiesCount = abilitiesCount + 1
            //! i end

            //! i setobjecttype("items")

            //! i raw = "I$raw$"

            //! i createobject("ches", raw)

            //! i abilitiesCount = 0
            //! i name = "$name$"

            //! i set("iarm", "Wood")
            //! i set("ides", "")
            //! i set("iico", "")
            //! i set("ifil", "")
            //! i set("ipaw", "1")
            //! i set("isel", "1")
            //! i set("istr", 0)
            //! i set("unam", name)
            //! i set("utip", "")
            //! i set("utub", "")
        //! i ]])
    $doExternal$//! endexternalblock

    set $var$ = ItemType.CreateFromSelf('I$raw$')

    set ItemObjectCreation.TEMP = $var$
//! endtextmacro

//! textmacro Item_Finalize takes doExternal
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i if (isPowerUp) then
                //! i set("iabi", POWER_UP_SPELL_ID)
                //! i set("iusa", "1")
            //! i else
                //! i if (isScroll) then
                    //! i addAbility("AISc")
                //! i end

                //! i if (abilitiesCount > 0) then
                    //! i set("iabi", abilities)
                    //! i set("icid", cooldownGroup)
                    //! i set("iusa", "1")
                //! i end
            //! i end
            //! i if (tooltip ~= nil) then
                //! i set("utip", string.gsub(tooltip, "<name>", name))
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    $doExternal$//! external ObjectMerger test.lua
//! endtextmacro

//! textmacro Item_AddAbility takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i addAbility("$value$")
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Item_SetArmor takes doExternal, soundset
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("iarm", "$soundset$")
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Item_AddClass takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i if ("$value$" == "SCROLL") then
                //! i isScroll = true
            //! i elseif ("$value$" == "POWER_UP") then
                //! i isPowerUp = true
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    call ItemObjectCreation.TEMP.Classes.Add(ItemClass.$value$)
//! endtextmacro

//! textmacro Item_SetChargesAmount takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
        //! i ]])
    $doExternal$//! endexternalblock

    call ItemObjectCreation.TEMP.ChargesAmount.Set($value$)
//! endtextmacro

//! textmacro Item_SetCooldownGroup takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i cooldownGroup = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Item_SetCost takes doExternal, supplyCost, tintCost
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("igol", $supplyCost$)
            //! i set("ilum", $tintCost$)
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Item_SetDescription takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("ides", "$value$")
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Item_SetIcon takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("iico", "$value$")
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Item_SetModel takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("ifil", "$value$")
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Item_SetScale takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("isca", $value$)
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Item_SetTooltip takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i tooltip = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Item_SetVertexColor takes doExternal red, green, blue, alpha
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("iclr", $red$)
            //! i set("iclg", $green$)
            //! i set("iclb", $blue$)
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Item_SetUberTooltip takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("utub", "$value$")
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro