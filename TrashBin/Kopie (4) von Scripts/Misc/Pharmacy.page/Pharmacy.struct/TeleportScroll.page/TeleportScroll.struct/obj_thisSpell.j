static Spell THIS_SPELL
    
static string CASTER_ARRIVAL_EFFECT_PATH = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl"
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTo.mdl"
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static integer MAX_OFFSET = 1024
static integer DELAY = 4
static string CASTER_ARRIVAL_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\TeleportScroll.page\\TeleportScroll.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ATpS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ITEM)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Teleport Scroll")
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT_OR_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetChannelTime(1, 4)
    call thistype.THIS_SPELL.SetCooldown(1, 30)
    call thistype.THIS_SPELL.SetManaCost(1, 0)
    call thistype.THIS_SPELL.SetRange(1, 99999)
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\TeleportScroll.page\\TeleportScroll.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod