static real array HEAL_FACTOR
static integer array SILENCE_DURATION
static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_MutingShout takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AMuS')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Muting Shout")
    call SpellObjectCreation.TEMP.SetOrder("roar")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 550)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 15)
    call SpellObjectCreation.TEMP.SetManaCost(1, 30)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBattleRoar.blp")
    
    set thistype.HEAL_FACTOR[1] = 0.05
    set thistype.SILENCE_DURATION[1] = 4
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
endmethod