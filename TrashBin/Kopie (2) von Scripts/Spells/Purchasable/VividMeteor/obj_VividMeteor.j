static integer array HEAL
static integer array POISON_DURATION
static integer array DAMAGE
static real array DELAY
static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_VividMeteor takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AViM')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.PURCHASABLE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Vivid Meteor")
    call SpellObjectCreation.TEMP.SetOrder("monsoon")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 300)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 10)
    call SpellObjectCreation.TEMP.SetManaCost(1, 80)
    call SpellObjectCreation.TEMP.SetRange(1, 1400)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 300)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 10)
    call SpellObjectCreation.TEMP.SetManaCost(2, 100)
    call SpellObjectCreation.TEMP.SetRange(2, 1400)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 300)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 10)
    call SpellObjectCreation.TEMP.SetManaCost(3, 120)
    call SpellObjectCreation.TEMP.SetRange(3, 1400)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 300)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 10)
    call SpellObjectCreation.TEMP.SetManaCost(4, 140)
    call SpellObjectCreation.TEMP.SetRange(4, 1400)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 300)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 10)
    call SpellObjectCreation.TEMP.SetManaCost(5, 160)
    call SpellObjectCreation.TEMP.SetRange(5, 1400)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFireRocks.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FVi0', 5, 'CVi0')
    
    set thistype.HEAL[1] = 125
    set thistype.POISON_DURATION[1] = 3
    set thistype.DAMAGE[1] = 65
    set thistype.DELAY[1] = 1.5
    set thistype.SPECIAL_EFFECT_PATH[1] = "Units\\Demon\\Infernal\\InfernalBirth.mdl"
    set thistype.HEAL[2] = 200
    set thistype.POISON_DURATION[2] = 4
    set thistype.DAMAGE[2] = 105
    set thistype.DELAY[2] = 1.5
    set thistype.SPECIAL_EFFECT_PATH[2] = "Units\\Demon\\Infernal\\InfernalBirth.mdl"
    set thistype.HEAL[3] = 275
    set thistype.POISON_DURATION[3] = 5
    set thistype.DAMAGE[3] = 145
    set thistype.DELAY[3] = 1.5
    set thistype.SPECIAL_EFFECT_PATH[3] = "Units\\Demon\\Infernal\\InfernalBirth.mdl"
    set thistype.HEAL[4] = 350
    set thistype.POISON_DURATION[4] = 6
    set thistype.DAMAGE[4] = 185
    set thistype.DELAY[4] = 1.5
    set thistype.SPECIAL_EFFECT_PATH[4] = "Units\\Demon\\Infernal\\InfernalBirth.mdl"
    set thistype.HEAL[5] = 425
    set thistype.POISON_DURATION[5] = 7
    set thistype.DAMAGE[5] = 225
    set thistype.DELAY[5] = 1.5
    set thistype.SPECIAL_EFFECT_PATH[5] = "Units\\Demon\\Infernal\\InfernalBirth.mdl"
endmethod