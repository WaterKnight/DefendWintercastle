static integer array START_OFFSET
static string array SUMMON_UNIT_TYPE
static integer array SUMMON_DURATION
static integer array HEIGHT
static integer array SPEED
static string array DUMMY_UNIT_EFFECT_PATH
static real array DUMMY_UNIT_FADE_OUT
static integer array STUN_DURATION
static string array DUMMY_UNIT_EFFECT_ATTACH_POINT
    
static method Init_obj_ArcticWolf takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AArw')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_ULTIMATE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(3)
    call SpellObjectCreation.TEMP.SetName("Arctic Wolf")
    call SpellObjectCreation.TEMP.SetOrder("spiritwolf")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 300)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 60)
    call SpellObjectCreation.TEMP.SetManaCost(1, 150)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 300)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 60)
    call SpellObjectCreation.TEMP.SetManaCost(2, 150)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 300)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 60)
    call SpellObjectCreation.TEMP.SetManaCost(3, 150)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNWolf.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FAW0', 3, 'CAW0')
    
    set thistype.START_OFFSET[1] = 90
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.ARCTIC_WOLF
    set thistype.SUMMON_DURATION[1] = 60
    set thistype.HEIGHT[1] = 50
    set thistype.SPEED[1] = 400
    set thistype.DUMMY_UNIT_EFFECT_PATH[1] = "Spells\\ArcticWolf\\IceVortex.mdl"
    set thistype.DUMMY_UNIT_FADE_OUT[1] = 0.5
    set thistype.STUN_DURATION[1] = 3
    set thistype.DUMMY_UNIT_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.START_OFFSET[2] = 90
    set thistype.SUMMON_UNIT_TYPE[2] = UnitType.ARCTIC_WOLF2
    set thistype.SUMMON_DURATION[2] = 60
    set thistype.HEIGHT[2] = 50
    set thistype.SPEED[2] = 400
    set thistype.DUMMY_UNIT_EFFECT_PATH[2] = "Spells\\ArcticWolf\\IceVortex.mdl"
    set thistype.DUMMY_UNIT_FADE_OUT[2] = 0.5
    set thistype.STUN_DURATION[2] = 4
    set thistype.DUMMY_UNIT_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.START_OFFSET[3] = 90
    set thistype.SUMMON_UNIT_TYPE[3] = UnitType.ARCTIC_WOLF3
    set thistype.SUMMON_DURATION[3] = 60
    set thistype.HEIGHT[3] = 50
    set thistype.SPEED[3] = 400
    set thistype.DUMMY_UNIT_EFFECT_PATH[3] = "Spells\\ArcticWolf\\IceVortex.mdl"
    set thistype.DUMMY_UNIT_FADE_OUT[3] = 0.5
    set thistype.STUN_DURATION[3] = 5
    set thistype.DUMMY_UNIT_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
endmethod