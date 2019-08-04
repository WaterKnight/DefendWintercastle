static Spell THIS_SPELL
    
static real INTERVAL = 0.035
static integer MAX_DAMAGE = 700
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Cleavage.page\\Cleavage.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AClv')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Cleavage")
    call thistype.THIS_SPELL.SetOrder(OrderId("evileye"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 7)
    call thistype.THIS_SPELL.SetManaCost(1, 60)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNShockWave.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Cleavage.page\\Cleavage.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod