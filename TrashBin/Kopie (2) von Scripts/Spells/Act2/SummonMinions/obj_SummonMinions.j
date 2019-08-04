static integer array OFFSET
static integer array SUMMON_UNIT_TYPE2_CHANCE
static integer array SUMMON_DURATION
static integer array SUMMUN_UNIT_TYPE_CHANCE
static string array SUMMON_UNIT_TYPE
static integer array SUMMONS_AMOUNT_PER_INTERVAL
static integer array INTERVALS_AMOUNT
static string array SUMMON_UNIT_TYPE2
    
static method Init_obj_SummonMinions takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ASuM')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Summon Minions")
    call SpellObjectCreation.TEMP.SetOrder("summonGrizzly")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 10)
    call SpellObjectCreation.TEMP.SetCooldown(1, 30)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNMassTeleport.blp")
    
    set thistype.OFFSET[1] = 500
    set thistype.SUMMON_UNIT_TYPE2_CHANCE[1] = 1
    set thistype.SUMMON_DURATION[1] = 20
    set thistype.SUMMUN_UNIT_TYPE_CHANCE[1] = 1
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.AXE_FIGHTER
    set thistype.SUMMONS_AMOUNT_PER_INTERVAL[1] = 2
    set thistype.INTERVALS_AMOUNT[1] = 6
    set thistype.SUMMON_UNIT_TYPE2[1] = UnitType.SPEAR_SCOUT
endmethod