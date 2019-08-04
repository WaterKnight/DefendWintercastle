static real array INTERVAL
static integer array MANA_HEAL_PER_SECOND
static string array EFFECT_LIGHTNING_PATH
    
static method Init_obj_WhiteStaff takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AWhS')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ARTIFACT)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("White Staff")
    call SpellObjectCreation.TEMP.SetOrder("sanctuary")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 5)
    call SpellObjectCreation.TEMP.SetCooldown(1, 10)
    call SpellObjectCreation.TEMP.SetManaCost(1, 5)
    call SpellObjectCreation.TEMP.SetRange(1, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 5)
    call SpellObjectCreation.TEMP.SetCooldown(2, 10)
    call SpellObjectCreation.TEMP.SetManaCost(2, 5)
    call SpellObjectCreation.TEMP.SetRange(2, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 5)
    call SpellObjectCreation.TEMP.SetCooldown(3, 10)
    call SpellObjectCreation.TEMP.SetManaCost(3, 5)
    call SpellObjectCreation.TEMP.SetRange(3, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 5)
    call SpellObjectCreation.TEMP.SetCooldown(4, 10)
    call SpellObjectCreation.TEMP.SetManaCost(4, 5)
    call SpellObjectCreation.TEMP.SetRange(4, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 5)
    call SpellObjectCreation.TEMP.SetCooldown(5, 10)
    call SpellObjectCreation.TEMP.SetManaCost(5, 5)
    call SpellObjectCreation.TEMP.SetRange(5, 700)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAdvancedStrengthOfTheMoon.blp")
    
    set thistype.INTERVAL[1] = 0.75
    set thistype.MANA_HEAL_PER_SECOND[1] = 3
    set thistype.EFFECT_LIGHTNING_PATH[1] = "SPLK"
    set thistype.INTERVAL[2] = 0.75
    set thistype.MANA_HEAL_PER_SECOND[2] = 4
    set thistype.EFFECT_LIGHTNING_PATH[2] = "SPLK"
    set thistype.INTERVAL[3] = 0.75
    set thistype.MANA_HEAL_PER_SECOND[3] = 5
    set thistype.EFFECT_LIGHTNING_PATH[3] = "SPLK"
    set thistype.INTERVAL[4] = 0.75
    set thistype.MANA_HEAL_PER_SECOND[4] = 6
    set thistype.EFFECT_LIGHTNING_PATH[4] = "SPLK"
    set thistype.INTERVAL[5] = 0.75
    set thistype.MANA_HEAL_PER_SECOND[5] = 7
    set thistype.EFFECT_LIGHTNING_PATH[5] = "SPLK"
endmethod