static integer array OFFSET
static real array MOVE_DURATION
static string array SUMMON_UNIT_TYPE
static integer array DURATION
static integer array CASTER_OFFSET
static string array BARRIER_EFFECT_ATTACH_POINT
static integer array SUMMONS_AMOUNT
static string array BARRIER_EFFECT_PATH
static string array WINDOW_PER_SUMMON
    
static method Init_obj_Barrier takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABar')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.PURCHASABLE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Barrier")
    call SpellObjectCreation.TEMP.SetOrder("summonfactory")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 8)
    call SpellObjectCreation.TEMP.SetManaCost(1, 20)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 8)
    call SpellObjectCreation.TEMP.SetManaCost(2, 30)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 8)
    call SpellObjectCreation.TEMP.SetManaCost(3, 40)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 8)
    call SpellObjectCreation.TEMP.SetManaCost(4, 50)
    call SpellObjectCreation.TEMP.SetRange(4, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 8)
    call SpellObjectCreation.TEMP.SetManaCost(5, 60)
    call SpellObjectCreation.TEMP.SetRange(5, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFrostMourne.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FBa0', 5, 'CBa0')
    
    set thistype.OFFSET[1] = 260
    set thistype.MOVE_DURATION[1] = 0.4
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.BARRIER
    set thistype.DURATION[1] = 3
    set thistype.CASTER_OFFSET[1] = 150
    set thistype.BARRIER_EFFECT_ATTACH_POINT[1] = AttachPoint.OVERHEAD
    set thistype.SUMMONS_AMOUNT[1] = 3
    set thistype.BARRIER_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl"
    set thistype.WINDOW_PER_SUMMON[1] = "0.36 * Math.QUARTER_ANGLE"
    set thistype.OFFSET[2] = 260
    set thistype.MOVE_DURATION[2] = 0.4
    set thistype.SUMMON_UNIT_TYPE[2] = UnitType.BARRIER2
    set thistype.DURATION[2] = 3.5
    set thistype.CASTER_OFFSET[2] = 150
    set thistype.BARRIER_EFFECT_ATTACH_POINT[2] = AttachPoint.OVERHEAD
    set thistype.SUMMONS_AMOUNT[2] = 3
    set thistype.BARRIER_EFFECT_PATH[2] = "Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl"
    set thistype.WINDOW_PER_SUMMON[2] = "0.36 * Math.QUARTER_ANGLE"
    set thistype.OFFSET[3] = 260
    set thistype.MOVE_DURATION[3] = 0.4
    set thistype.SUMMON_UNIT_TYPE[3] = UnitType.BARRIER3
    set thistype.DURATION[3] = 4
    set thistype.CASTER_OFFSET[3] = 150
    set thistype.BARRIER_EFFECT_ATTACH_POINT[3] = AttachPoint.OVERHEAD
    set thistype.SUMMONS_AMOUNT[3] = 4
    set thistype.BARRIER_EFFECT_PATH[3] = "Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl"
    set thistype.WINDOW_PER_SUMMON[3] = "0.36 * Math.QUARTER_ANGLE"
    set thistype.OFFSET[4] = 260
    set thistype.MOVE_DURATION[4] = 0.4
    set thistype.SUMMON_UNIT_TYPE[4] = UnitType.BARRIER4
    set thistype.DURATION[4] = 4.5
    set thistype.CASTER_OFFSET[4] = 150
    set thistype.BARRIER_EFFECT_ATTACH_POINT[4] = AttachPoint.OVERHEAD
    set thistype.SUMMONS_AMOUNT[4] = 4
    set thistype.BARRIER_EFFECT_PATH[4] = "Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl"
    set thistype.WINDOW_PER_SUMMON[4] = "0.36 * Math.QUARTER_ANGLE"
    set thistype.OFFSET[5] = 260
    set thistype.MOVE_DURATION[5] = 0.4
    set thistype.SUMMON_UNIT_TYPE[5] = UnitType.BARRIER5
    set thistype.DURATION[5] = 5
    set thistype.CASTER_OFFSET[5] = 150
    set thistype.BARRIER_EFFECT_ATTACH_POINT[5] = AttachPoint.OVERHEAD
    set thistype.SUMMONS_AMOUNT[5] = 5
    set thistype.BARRIER_EFFECT_PATH[5] = "Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl"
    set thistype.WINDOW_PER_SUMMON[5] = "0.36 * Math.QUARTER_ANGLE"
endmethod