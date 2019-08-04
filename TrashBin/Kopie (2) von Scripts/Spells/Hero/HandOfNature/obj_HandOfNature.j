static integer array SUMMON_DURATION
static real array MOVE_INTERVAL
static string array SUMMON_EFFECT_PATH
static integer array MAX_TARGETS_AMOUNT
static string array SUMMON_UNIT_TYPES
static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_HandOfNature takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AHoN')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_SECOND)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Hand of Nature")
    call SpellObjectCreation.TEMP.SetOrder("entanglingroots")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 250)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 8)
    call SpellObjectCreation.TEMP.SetManaCost(1, 65)
    call SpellObjectCreation.TEMP.SetRange(1, 650)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 250)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 8)
    call SpellObjectCreation.TEMP.SetManaCost(2, 75)
    call SpellObjectCreation.TEMP.SetRange(2, 650)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 250)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 8)
    call SpellObjectCreation.TEMP.SetManaCost(3, 85)
    call SpellObjectCreation.TEMP.SetRange(3, 650)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 250)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 8)
    call SpellObjectCreation.TEMP.SetManaCost(4, 95)
    call SpellObjectCreation.TEMP.SetRange(4, 650)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 250)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 8)
    call SpellObjectCreation.TEMP.SetManaCost(5, 105)
    call SpellObjectCreation.TEMP.SetRange(5, 650)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNEntanglingRoots.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FHN0', 5, 'CHN0')
    
    set thistype.SUMMON_DURATION[1] = 40
    set thistype.MOVE_INTERVAL[1] = 0.05
    set thistype.SUMMON_EFFECT_PATH[1] = "Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl"
    set thistype.MAX_TARGETS_AMOUNT[1] = 2
    set thistype.SUMMON_UNIT_TYPES[1] = UnitType.COBRA_LILY
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Weapons\\TreantMissile\\TreantMissile.mdl"
    set thistype.SUMMON_DURATION[2] = 40
    set thistype.MOVE_INTERVAL[2] = 0.05
    set thistype.SUMMON_EFFECT_PATH[2] = "Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl"
    set thistype.MAX_TARGETS_AMOUNT[2] = 2
    set thistype.SUMMON_UNIT_TYPES[2] = UnitType.COBRA_LILY2
    set thistype.SPECIAL_EFFECT_PATH[2] = "Abilities\\Weapons\\TreantMissile\\TreantMissile.mdl"
    set thistype.SUMMON_DURATION[3] = 40
    set thistype.MOVE_INTERVAL[3] = 0.05
    set thistype.SUMMON_EFFECT_PATH[3] = "Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl"
    set thistype.MAX_TARGETS_AMOUNT[3] = 2
    set thistype.SUMMON_UNIT_TYPES[3] = UnitType.COBRA_LILY3
    set thistype.SPECIAL_EFFECT_PATH[3] = "Abilities\\Weapons\\TreantMissile\\TreantMissile.mdl"
    set thistype.SUMMON_DURATION[4] = 40
    set thistype.MOVE_INTERVAL[4] = 0.05
    set thistype.SUMMON_EFFECT_PATH[4] = "Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl"
    set thistype.MAX_TARGETS_AMOUNT[4] = 2
    set thistype.SUMMON_UNIT_TYPES[4] = UnitType.COBRA_LILY4
    set thistype.SPECIAL_EFFECT_PATH[4] = "Abilities\\Weapons\\TreantMissile\\TreantMissile.mdl"
    set thistype.SUMMON_DURATION[5] = 40
    set thistype.MOVE_INTERVAL[5] = 0.05
    set thistype.SUMMON_EFFECT_PATH[5] = "Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl"
    set thistype.MAX_TARGETS_AMOUNT[5] = 2
    set thistype.SUMMON_UNIT_TYPES[5] = UnitType.COBRA_LILY5
    set thistype.SPECIAL_EFFECT_PATH[5] = "Abilities\\Weapons\\TreantMissile\\TreantMissile.mdl"
endmethod