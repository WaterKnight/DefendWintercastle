static Spell THIS_SPELL
    
static real array INTERVAL
static integer array DAMAGE_PER_SECOND
static string EFFECT_LIGHTNING_PATH = "SPLK"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Lariat\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AWBS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Water Bindings Lariat")
    call thistype.THIS_SPELL.SetOrder(OrderId("summongrizzly"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("attack")
    call thistype.THIS_SPELL.SetChannelTime(1, 5)
    call thistype.THIS_SPELL.SetCooldown(1, 0)
    call thistype.THIS_SPELL.SetManaCost(1, 0)
    call thistype.THIS_SPELL.SetRange(1, 99999)
    call thistype.THIS_SPELL.SetChannelTime(2, 5)
    call thistype.THIS_SPELL.SetCooldown(2, 0)
    call thistype.THIS_SPELL.SetManaCost(2, 0)
    call thistype.THIS_SPELL.SetRange(2, 99999)
    call thistype.THIS_SPELL.SetChannelTime(3, 5)
    call thistype.THIS_SPELL.SetCooldown(3, 0)
    call thistype.THIS_SPELL.SetManaCost(3, 0)
    call thistype.THIS_SPELL.SetRange(3, 99999)
    call thistype.THIS_SPELL.SetChannelTime(4, 5)
    call thistype.THIS_SPELL.SetCooldown(4, 0)
    call thistype.THIS_SPELL.SetManaCost(4, 0)
    call thistype.THIS_SPELL.SetRange(4, 99999)
    call thistype.THIS_SPELL.SetChannelTime(5, 5)
    call thistype.THIS_SPELL.SetCooldown(5, 0)
    call thistype.THIS_SPELL.SetManaCost(5, 0)
    call thistype.THIS_SPELL.SetRange(5, 99999)
    
    set thistype.INTERVAL[1] = 0.25
    set thistype.INTERVAL[2] = 0.25
    set thistype.INTERVAL[3] = 0.25
    set thistype.INTERVAL[4] = 0.25
    set thistype.INTERVAL[5] = 0.25
    set thistype.DAMAGE_PER_SECOND[1] = 7
    set thistype.DAMAGE_PER_SECOND[2] = 10
    set thistype.DAMAGE_PER_SECOND[3] = 14
    set thistype.DAMAGE_PER_SECOND[4] = 19
    set thistype.DAMAGE_PER_SECOND[5] = 25
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Lariat\\thisSpell.wc3spell")
    call t.Destroy()
endmethod