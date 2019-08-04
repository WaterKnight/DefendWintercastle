static Spell THIS_SPELL
    
static integer OFFSET = 500
static integer SUMMON_UNIT_TYPE2_CHANCE = 1
static integer SUMMON_DURATION = 20
static UnitType SUMMON_UNIT_TYPE2
static UnitType SUMMON_UNIT_TYPE
static integer SUMMONS_AMOUNT_PER_INTERVAL = 2
static integer INTERVALS_AMOUNT = 6
static integer SUMMON_UNIT_TYPE_CHANCE = 1
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SummonMinions.page\\SummonMinions.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASuM')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Summon Minions")
    call thistype.THIS_SPELL.SetOrder(OrderId("summonGrizzly"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetChannelTime(1, 10)
    call thistype.THIS_SPELL.SetCooldown(1, 30)
    call thistype.THIS_SPELL.SetManaCost(1, 0)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNMassTeleport.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SummonMinions.page\\SummonMinions.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod