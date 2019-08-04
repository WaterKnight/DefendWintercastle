static real array DAMAGE_AIR_FACTOR
static integer array LIFE_INCREMENT
static real array INTERVAL
static integer array DAMAGE_ALL
    
static method Init_obj_Amaterasu takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AAma')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_ULTIMATE_EX)
    call SpellObjectCreation.TEMP.SetLevelsAmount(2)
    call SpellObjectCreation.TEMP.SetName("Amaterasu")
    call SpellObjectCreation.TEMP.SetOrder("deathanddecay")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell,channel")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 450)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 15)
    call SpellObjectCreation.TEMP.SetCooldown(1, 90)
    call SpellObjectCreation.TEMP.SetManaCost(1, 145)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 450)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 15)
    call SpellObjectCreation.TEMP.SetCooldown(2, 90)
    call SpellObjectCreation.TEMP.SetManaCost(2, 210)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNOrbofSlowness.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FAm0', 2, 'CAm0')
    
    set thistype.DAMAGE_AIR_FACTOR[1] = 0.5
    set thistype.LIFE_INCREMENT[1] = 300
    set thistype.INTERVAL[1] = 0.35
    set thistype.DAMAGE_ALL[1] = 600
    set thistype.DAMAGE_AIR_FACTOR[2] = 0.5
    set thistype.LIFE_INCREMENT[2] = 500
    set thistype.INTERVAL[2] = 0.35
    set thistype.DAMAGE_ALL[2] = 900
endmethod