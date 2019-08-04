static integer array BURNED_MANA
static integer array STUN_DURATION
static string array EFFECT_LIGHTNING_PATH
static real array TRANSFERED_MANA_FACTOR
static integer array DAMAGE
    
static method Init_obj_DeprivingShock takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ADeS')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_SECOND)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Depriving Shock")
    call SpellObjectCreation.TEMP.SetOrder("darkconversion")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 150)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0.5)
    call SpellObjectCreation.TEMP.SetCooldown(1, 4)
    call SpellObjectCreation.TEMP.SetManaCost(1, 30)
    call SpellObjectCreation.TEMP.SetRange(1, 375)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 175)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0.5)
    call SpellObjectCreation.TEMP.SetCooldown(2, 4)
    call SpellObjectCreation.TEMP.SetManaCost(2, 45)
    call SpellObjectCreation.TEMP.SetRange(2, 375)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 200)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0.5)
    call SpellObjectCreation.TEMP.SetCooldown(3, 4)
    call SpellObjectCreation.TEMP.SetManaCost(3, 60)
    call SpellObjectCreation.TEMP.SetRange(3, 375)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 225)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0.5)
    call SpellObjectCreation.TEMP.SetCooldown(4, 4)
    call SpellObjectCreation.TEMP.SetManaCost(4, 75)
    call SpellObjectCreation.TEMP.SetRange(4, 375)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 250)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0.5)
    call SpellObjectCreation.TEMP.SetCooldown(5, 4)
    call SpellObjectCreation.TEMP.SetManaCost(5, 90)
    call SpellObjectCreation.TEMP.SetRange(5, 375)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNRavenForm.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FDS0', 5, 'CDS0')
    
    set thistype.BURNED_MANA[1] = 65
    set thistype.STUN_DURATION[1] = 1
    set thistype.EFFECT_LIGHTNING_PATH[1] = "MBUR"
    set thistype.TRANSFERED_MANA_FACTOR[1] = 0.5
    set thistype.DAMAGE[1] = 20
    set thistype.BURNED_MANA[2] = 100
    set thistype.STUN_DURATION[2] = 1
    set thistype.EFFECT_LIGHTNING_PATH[2] = "MBUR"
    set thistype.TRANSFERED_MANA_FACTOR[2] = 0.5
    set thistype.DAMAGE[2] = 30
    set thistype.BURNED_MANA[3] = 140
    set thistype.STUN_DURATION[3] = 1
    set thistype.EFFECT_LIGHTNING_PATH[3] = "MBUR"
    set thistype.TRANSFERED_MANA_FACTOR[3] = 0.5
    set thistype.DAMAGE[3] = 45
    set thistype.BURNED_MANA[4] = 185
    set thistype.STUN_DURATION[4] = 1
    set thistype.EFFECT_LIGHTNING_PATH[4] = "MBUR"
    set thistype.TRANSFERED_MANA_FACTOR[4] = 0.5
    set thistype.DAMAGE[4] = 60
    set thistype.BURNED_MANA[5] = 235
    set thistype.STUN_DURATION[5] = 1
    set thistype.EFFECT_LIGHTNING_PATH[5] = "MBUR"
    set thistype.TRANSFERED_MANA_FACTOR[5] = 0.5
    set thistype.DAMAGE[5] = 75
endmethod