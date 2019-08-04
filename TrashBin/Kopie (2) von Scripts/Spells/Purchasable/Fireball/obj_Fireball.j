static real array MIN_DAMAGE_FACTOR
static integer array MIN_DAMAGE_RANGE
static integer array DAMAGE_SPELL_POWER_MOD_FACTOR
static real array FRIENDLY_FIRE_FACTOR
static integer array DAMAGE
    
static method Init_obj_Fireball takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AFiB')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.PURCHASABLE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Fireball")
    call SpellObjectCreation.TEMP.SetOrder("firebolt")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 150)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 6)
    call SpellObjectCreation.TEMP.SetManaCost(1, 15)
    call SpellObjectCreation.TEMP.SetRange(1, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 175)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 6)
    call SpellObjectCreation.TEMP.SetManaCost(2, 25)
    call SpellObjectCreation.TEMP.SetRange(2, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 200)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 6)
    call SpellObjectCreation.TEMP.SetManaCost(3, 35)
    call SpellObjectCreation.TEMP.SetRange(3, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 225)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 6)
    call SpellObjectCreation.TEMP.SetManaCost(4, 45)
    call SpellObjectCreation.TEMP.SetRange(4, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 250)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 6)
    call SpellObjectCreation.TEMP.SetManaCost(5, 55)
    call SpellObjectCreation.TEMP.SetRange(5, 700)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFireForTheCannon.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FFb0', 5, 'CFb0')
    
    set thistype.MIN_DAMAGE_FACTOR[1] = 0.4
    set thistype.MIN_DAMAGE_RANGE[1] = 1000
    set thistype.DAMAGE_SPELL_POWER_MOD_FACTOR[1] = 1
    set thistype.FRIENDLY_FIRE_FACTOR[1] = 0.4
    set thistype.DAMAGE[1] = 55
    set thistype.MIN_DAMAGE_FACTOR[2] = 0.4
    set thistype.MIN_DAMAGE_RANGE[2] = 1000
    set thistype.DAMAGE_SPELL_POWER_MOD_FACTOR[2] = 1
    set thistype.FRIENDLY_FIRE_FACTOR[2] = 0.4
    set thistype.DAMAGE[2] = 90
    set thistype.MIN_DAMAGE_FACTOR[3] = 0.4
    set thistype.MIN_DAMAGE_RANGE[3] = 1000
    set thistype.DAMAGE_SPELL_POWER_MOD_FACTOR[3] = 1
    set thistype.FRIENDLY_FIRE_FACTOR[3] = 0.4
    set thistype.DAMAGE[3] = 125
    set thistype.MIN_DAMAGE_FACTOR[4] = 0.4
    set thistype.MIN_DAMAGE_RANGE[4] = 1000
    set thistype.DAMAGE_SPELL_POWER_MOD_FACTOR[4] = 1
    set thistype.FRIENDLY_FIRE_FACTOR[4] = 0.4
    set thistype.DAMAGE[4] = 160
    set thistype.MIN_DAMAGE_FACTOR[5] = 0.4
    set thistype.MIN_DAMAGE_RANGE[5] = 1000
    set thistype.DAMAGE_SPELL_POWER_MOD_FACTOR[5] = 1
    set thistype.FRIENDLY_FIRE_FACTOR[5] = 0.4
    set thistype.DAMAGE[5] = 195
endmethod