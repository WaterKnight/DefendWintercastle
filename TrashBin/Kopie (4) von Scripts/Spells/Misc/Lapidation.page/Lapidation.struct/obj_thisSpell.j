static Spell THIS_SPELL
    
static integer DAMAGE = 100
static integer MAX_TARGETS_AMOUNT = 10
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\Lapidation.page\\Lapidation.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ALap')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Lapidation")
    call thistype.THIS_SPELL.SetOrder(OrderId("sleep"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 700)
    call thistype.THIS_SPELL.SetCooldown(1, 60)
    call thistype.THIS_SPELL.SetManaCost(1, 80)
    call thistype.THIS_SPELL.SetRange(1, 99999)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGolemStormBolt.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\Lapidation.page\\Lapidation.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod