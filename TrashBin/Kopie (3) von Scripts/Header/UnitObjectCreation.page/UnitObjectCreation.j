struct UnitObjectCreation
    static real STANDARD_SCALE
    static UnitType TEMP
endstruct

//! textmacro Unit_Create takes doExternal, var, raw, name, isHero, race, standardScale
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "w")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i function set(field, value)
                //! i makechange(current, field, value)
            //! i end

            //! i function addAbility(value)
                //! i if (abilitiesCount == 0) then
                    //! i abilities = value
                //! i else
                    //! i abilities = abilities..","..value
                //! i end

                //! i abilitiesCount = abilitiesCount + 1
            //! i end

            //! i setobjecttype("units")

            //! i if ($isHero$) then
                //! i raw = "U$raw$"
            //! i else
                //! i raw = "u$raw$"
            //! i end

            //! i createobject("nglm", raw)

            //! i abilitiesCount = 0
            //! i isStructure = false
            //! i isUpgrade = false
            //! i name = "$name$"
            //! i standardScale = $standardScale$

            //! i scaleFactor = 1. / standardScale

            //! i set("uabi", "")
            //! i set("uarm", "")
            //! i set("uble", 0)
            //! i set("ucam", 0)
            //! i set("ucar", 1)
            //! i set("ucbs", 0)
            //! i set("ucol", 0)
            //! i set("udea", string.char(3))
            //! i set("udty", "")
            //! i set("udtm", 0)
            //! i set("uerd", 0)
            //! i set("ufle", 0)
            //! i set("uimz", 0)
            //! i set("ulpz", 0)
            //! i set("umdl", "")
            //! i set("umvt", "")
            //! i set("umxp", 0)
            //! i set("umxr", 0)
            //! i set("unam", name)
            //! i set("upri", 0)
            //! i if ("$race$" == "DEFENDER") then
                //! i set("urac", "human")
            //! i elseif ("$race$" == "ATTACKER") then
                //! i set("urac", "creeps")
            //! i elseif ("$race$" == "OTHER") then
                //! i set("uhos", 0)
                //! i set("urac", "other")
            //! i end
            //! i set("urun", 0)
            //! i set("ushh", 0)
            //! i set("ushu", "")
            //! i set("ushw", 0)
            //! i set("usnd", 0)
            //! i set("ussc", 0)
            //! i set("utar", "")
            //! i set("utyp", "")
            //! i set("uwal", 0)

            //! i if ($isHero$) then
                //! i set("uhhd", "1")
                //! i addAbility("AInv")
                //! i set("uhab", "AHS0,AHS1,AHS2,AHS3,AHS4")
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    set UnitObjectCreation.STANDARD_SCALE = $standardScale$
    static if ($isHero$) then
        set $var$ = UnitType.Create('U$raw$')

        call $var$.Classes.Add(UnitClass.HERO)
    else
        set $var$ = UnitType.Create('u$raw$')
    endif

    set UnitObjectCreation.TEMP = $var$
//! endtextmacro

//! textmacro Unit_Finalize takes doExternal
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("uabi", abilities)
            //! i if (collisionSize ~= nil) then
                //! i set("ucol", collisionSize * scaleFactor)
            //! i end
            //! i if (impactZ ~= nil) then
                //! i set("uimz", impactZ * scaleFactor)
                //! i set("ulpx", outpactX * scaleFactor)
                //! i set("ulpy", outpactY * scaleFactor)
                //! i set("ulpz", outpactZ * scaleFactor)
            //! i end
            //! i if (shadowHeight ~= nil) then
                //! i set("ushh", shadowHeight * scaleFactor)
                //! i set("ushw", shadowWidth * scaleFactor)
            //! i end
            //! i if (selectionScale ~= nil) then
                //! i set("ussc", selectionScale * scaleFactor)
            //! i end
            //! i if (isStructure == false) then
                //! i set("umvs", -1)
            //! i end
            //! i if (isUpgrade) then
                //! i set("utip", "Upgrade to "..name)
            //! i else
                //! i if (isStructure) then
                    //! i set("utip", "Build "..name)
                //! i else
                    //! i set("utip", "Train "..name)
                //! i end
            //! i end
            //! i if (uberTooltip ~= nil) then
                //! i uberTooltip = string.gsub(uberTooltip, "<maxDmg>", maxDmg)
                //! i uberTooltip = string.gsub(uberTooltip, "<minDmg>", minDmg)

                //! i set("utub", uberTooltip)
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    $doExternal$//! external ObjectMerger test.lua
//! endtextmacro

//! textmacro Unit_AddAttachment takes doExternal, path, attachPoint, effectLevel
    call UnitObjectCreation.TEMP.Attachments.Add("$path$", AttachPoint.$attachPoint$, EffectLevel.$effectLevel$)
//! endtextmacro

//! textmacro Unit_SetArmor takes doExternal, type, amount, soundset
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("uarm", "$soundset$")
            //! i set("udef", math.floor($amount$))
            //! i if ("$type$" == "LIGHT") then
                //! i set("udty", "small")
            //! i elseif ("$type$" == "MEDIUM") then
                //! i set("udty", "medium")
            //! i elseif ("$type$" == "LARGE") then
                //! i set("udty", "large")
            //! i elseif ("$type$" == "FORT") then
                //! i set("udty", "fort")
            //! i elseif ("$type$" == "HERO") then
                //! i set("udty", "hero")
            //! i elseif ("$type$" == "UNARMORED") then
                //! i set("udty", "none")
            //! i elseif ("$type$" == "DIVINE") then
                //! i set("udty", "divine")
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.Armor.Set($amount$)
    call UnitObjectCreation.TEMP.Armor.Type.Set(Attack.ARMOR_TYPE_$type$)
//! endtextmacro

//! textmacro Unit_SetAttack takes doExternal, type, cooldown, range, rangeBuffer, targets, waitAfter, sound
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("ua1c", $cooldown$)
            //! i if ("$dmgType$" == "NORMAL") then
                //! i set("ua1t", "normal")
            //! i elseif ("$dmgType$" == "PIERCE") then
                //! i set("ua1t", "pierce")
            //! i elseif ("$dmgType$" == "SIEGE") then
                //! i set("ua1t", "siege")
            //! i elseif ("$dmgType$" == "MAGIC") then
                //! i set("ua1t", "magic")
            //! i elseif ("$dmgType$" == "CHAOS") then
                //! i set("ua1t", "chaos")
            //! i elseif ("$dmgType$" == "HERO") then
                //! i set("ua1t", "hero")
            //! i elseif ("$dmgType$" == "SPELLS") then
                //! i set("ua1t", "spells")
            //! i end
            //! i set("ua1g", "$targets$")
            //! i set("ua1r", $range$)
            //! i if ("$type$" == "NORMAL") then
                //! i set("ua1w", "normal")
            //! i elseif ("$type$" == "MISSILE") then
                //! i set("ua1w", "missile")
            //! i elseif ("$type$" == "HOMING_MISSILE") then
                //! i set("ua1w", "missile")
                //! i set("umh1", 1)
            //! i elseif ("$type$" == "ARTILLERY") then
                //! i set("ua1f", 50.)
                //! i set("ua1h", 500.)
                //! i set("ua1p", "invulnerable")
                //! i set("ua1q", 1000.)
                //! i set("ua1w", "artillery")
            //! i end
            //! i set("uaen", string.char(1))
            //! i set("ubs1", $waitAfter$)
            //! i set("ucs1", "$sound$")
            //! i set("urb1", $rangeBuffer$)
            //! i set("utc1", 1)
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.Attack.Set(Attack.$type$)
    call UnitObjectCreation.TEMP.Attack.Range.Set($range$)
    call UnitObjectCreation.TEMP.Attack.Speed.SetByCooldown($cooldown$)
//! endtextmacro

//! textmacro Unit_SetAttackMissile takes doExternal, model, speed, arc
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("ua1m", "$model$")
            //! i set("ua1z", $speed$)
            //! i set("uma1", $arc$)
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.Attack.Missile.Speed.Set($speed$)
//! endtextmacro

//! textmacro Unit_AddAttackSplash takes doExternal, radius, dmgFactor
    call UnitObjectCreation.TEMP.Attack.Splash.Add($radius$, $dmgFactor$)
//! endtextmacro

//! textmacro Unit_AddAttackSplashTargets takes doExternal, value
    call UnitObjectCreation.TEMP.Attack.Splash.TargetFlag.Add(TargetFlag.$value$)
//! endtextmacro

//! textmacro Unit_SetBlend takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("uble", $value$)
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_SetBlood takes doExternal, value
    call UnitObjectCreation.TEMP.Blood.Set("$value$")
//! endtextmacro

//! textmacro Unit_SetCasting takes doExternal, waitBefore, waitAfter
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("ucbs", $waitAfter$)
            //! i set("ucpt", $waitBefore$)
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_AddClass takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i if ("$value$" == "STRUCTURE") then
                //! i isStructure = true
                //! i set("ubdg", 1)
            //! i end
            //! i if ("$value$" == "UPGRADED") then
                //! i isUpgrade = true
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.Classes.Add(UnitClass.$value$)
//! endtextmacro

//! textmacro Unit_SetCollisionSize takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i collisionSize = $value$
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.CollisionSize.SetByScale($value$, UnitObjectCreation.STANDARD_SCALE)
//! endtextmacro

//! textmacro Unit_SetCombatFlags takes doExternal, value, acquireRange
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("uacq", $acquireRange$)
            //! i set("utar", "$value$")
        //! i ]])
    $doExternal$//! endexternalblock

    set UnitObjectCreation.TEMP.combatFlags = "$value$"
//! endtextmacro

//! textmacro Unit_SetDamage takes doExternal, dmgType, baseAmount, dicesAmount, sidesAmount, dmgPoint
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i maxDmg = ($baseAmount$ + $dicesAmount$ * $sidesAmount$)
            //! i minDmg = ($baseAmount$ + $dicesAmount$)
            //! i if ("$dmgType$" == "NORMAL") then
                //! i dmgType = "normal"
            //! i elseif ("$dmgType$" == "PIERCE") then
                //! i dmgType = "pierce"
            //! i elseif ("$dmgType$" == "SIEGE") then
                //! i dmgType = "siege"
            //! i elseif ("$dmgType$" == "MAGIC") then
                //! i dmgType = "magic"
            //! i elseif ("$dmgType$" == "CHAOS") then
                //! i dmgType = "chaos"
            //! i elseif ("$dmgType$" == "HERO") then
                //! i dmgType = "hero"
            //! i elseif ("$dmgType$" == "SPELLS") then
                //! i dmgType = "spells"
            //! i end
            //! i set("ua1b", $baseAmount$)
            //! i set("ua1d", $dicesAmount$)
            //! i set("ua1s", $sidesAmount$)
            //! i set("udp1", $dmgPoint$)

            //! i set("ua1t", dmgType)
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.Damage.Set($baseAmount$)
    call UnitObjectCreation.TEMP.Damage.SetBJ($baseAmount$)
    call UnitObjectCreation.TEMP.Damage.Delay.Set($dmgPoint$)
    call UnitObjectCreation.TEMP.Damage.Dices.Set($dicesAmount$)
    call UnitObjectCreation.TEMP.Damage.Sides.Set($sidesAmount$)
    call UnitObjectCreation.TEMP.Damage.Type.Set(Attack.DMG_TYPE_$dmgType$)
//! endtextmacro

//! textmacro Unit_SetDeathTime takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("udtm", $value$)
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_SetElevation takes doExternal, pointsAmount, radius, maxRoll, maxPitch
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("uept", $pointsAmount$)
            //! i set("uerd", $radius$)
            //! i set("umxr", $maxRoll$)
            //! i set("umxp", $maxPitch$)
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_SetExp takes doExternal, value
    call UnitObjectCreation.TEMP.Drop.Exp.Set($value$)
//! endtextmacro

//! textmacro Unit_SetHeroAttributes takes doExternal, primary, armorPerLevel, agility, agilityPerLevel, intelligence, intelligencePerLevel, strength, strengthPerLevel
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i if ("$primary$" == "AGILITY") then
                //! i set("upra", "AGI")
            //! i elseif ("$primary$" == "INTELLIGENCE") then
                //! i set("upra", "INT")
            //! i elseif ("$primary$" == "STRENGTH") then
                //! i set("upra", "STR")
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.Hero.Agility.Set($agility$)
    call UnitObjectCreation.TEMP.Hero.Agility.PerLevel.Set($agilityPerLevel$)
    call UnitObjectCreation.TEMP.Hero.ArmorPerLevel.Set($armorPerLevel$)
    call UnitObjectCreation.TEMP.Hero.Intelligence.Set($intelligence$)
    call UnitObjectCreation.TEMP.Hero.Intelligence.PerLevel.Set($intelligencePerLevel$)
    call UnitObjectCreation.TEMP.Hero.Strength.Set($strength$)
    call UnitObjectCreation.TEMP.Hero.Strength.PerLevel.Set($strengthPerLevel$)
//! endtextmacro

//! textmacro Unit_SetHeroNames takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("upro", "$value$")
            //! i set("upru", 1)
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_SetIcon takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("uico", "$value$")
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_SetLife takes doExternal, value, regen
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i if ("$value$" == "UNIT_TYPE.Life.BLACK_DISPLAY") then
                //! i set("uhpm", 150000)
            //! i else
                //! i set("uhpm", $value$)
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.Life.Set($value$)
    call UnitObjectCreation.TEMP.Life.SetBJ($value$)
    call UnitObjectCreation.TEMP.LifeRegeneration.Set($regen$)
//! endtextmacro

//! textmacro Unit_SetMana takes doExternal, value, regen
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("umpm", $value$)
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.Mana.Set($value$)
    call UnitObjectCreation.TEMP.Mana.SetBJ($value$)
    call UnitObjectCreation.TEMP.ManaRegeneration.Set($regen$)
//! endtextmacro

//! textmacro Unit_SetMissilePoints takes doExternal, impactZ, outpactX, outpactY, outpactZ
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i impactZ = $impactZ$
            //! i outpactX = $outpactX$
            //! i outpactY = $outpactY$
            //! i outpactZ = $outpactZ$
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.Impact.Z.Set($impactZ$ * UnitObjectCreation.STANDARD_SCALE)
    call UnitObjectCreation.TEMP.Outpact.Z.Set($outpactZ$ * UnitObjectCreation.STANDARD_SCALE)
//! endtextmacro

//! textmacro Unit_SetModel takes doExternal, value, attachPoints, anims, attachModifiers, bones
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("uaap", "$attachModifiers$")
            //! i set("ualp", "$attachPoints$")
            //! i set("uani", "$anims$")
            //! i set("ubpr", "$bones$")
            //! i set("umdl", "$value$")
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_SetMovement takes doExternal, type, speed, turnRate, orientationInterpolation, walkAnim, runAnim
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("uori", $orientationInterpolation$)
            //! i set("umvr", $turnRate$)
            //! i set("umvs", $speed$)
            //! i if ("$type$" == "NONE") then
                //! i set("umvt", "")
            //! i elseif ("$type$" == "FOOT") then
                //! i set("umvt", "foot")
            //! i elseif ("$type$" == "HORSE") then
                //! i set("umvt", "horse")
            //! i elseif ("$type$" == "FLY") then
                //! i set("umvt", "fly")
            //! i elseif ("$type$" == "HOVER") then
                //! i set("umvt", "hover")
            //! i elseif ("$type$" == "FLOAT") then
                //! i set("umvt", "float")
            //! i elseif ("$type$" == "AMPHIBIOUS") then
                //! i set("umvt", "amph")
            //! i end
            //! i set("urun", $runAnim$)
            //! i set("uwal", $walkAnim$)
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.Speed.Set($speed$)
//! endtextmacro

//! textmacro Unit_SetMovementHeight takes doExternal, value, min
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("umvh", $value$)
            //! i set("umvf", $min$)
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_SetPathingTexture takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("upat", "$value$")
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_SetScale takes doExternal, value, selection
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i scaleFactor = $value$ / standardScale
            //! i selectionScale = $selection$
            //! i set("usca", $value$)
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.Scale.Set($value$)
//! endtextmacro

//! textmacro Unit_SetShadow takes doExternal, type, width, height, xOffset, yOffset
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i shadowHeight = $height$
            //! i shadowWidth = $width$
            //! i set("ushx", $xOffset$)
            //! i set("ushy", $yOffset$)
            //! i if ("$type$" == "NONE") then
                //! i set("ushu", "")
            //! i elseif ("$type$" == "NORMAL") then
                //! i set("ushu", "Shadow")
            //! i elseif ("$type$" == "FLY") then
                //! i set("ushu", "ShadowFlyer")
            //! i else
                //! i set("ushb", "$type$")
            //! i end
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_SetSight takes doExternal, nightValue, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("usin", $nightValue$)
            //! i set("usid", $value$)
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.SightRange.Set($value$)
    call UnitObjectCreation.TEMP.SightRange.SetBJ($value$)
//! endtextmacro

//! textmacro Unit_SetSoundset takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("usnd", "$value$")
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_SetSoldItems takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i addAbility("Aneu")
            //! i addAbility("Apit")
            //! i set("usei", "$value$")
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_SetSpellPower takes doExternal, value
    call UnitObjectCreation.TEMP.SpellPower.Set($value$)
//! endtextmacro

//! textmacro Unit_SetSupply takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("ubba", $value$)
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.Drop.Supply.Set($value$)
//! endtextmacro

//! textmacro Unit_SetUbersplat takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("uubs", "$value$")
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_SetUberTooltip takes doExternal, value
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i uberTooltip = "$value$"
        //! i ]])
    $doExternal$//! endexternalblock
//! endtextmacro

//! textmacro Unit_SetVertexColor takes doExternal red, green, blue, alpha
    $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
        //! i function writeLua(code)
            //! i file = io.open("test.lua", "a")

            //! i file:write(code)

            //! i file:close()
        //! i end

        //! i writeLua([[
            //! i set("uclr", $red$)
            //! i set("uclg", $green$)
            //! i set("uclb", $blue$)
        //! i ]])
    $doExternal$//! endexternalblock

    call UnitObjectCreation.TEMP.VertexColor.Set($red$, $green$, $blue$, $alpha$)
//! endtextmacro