static Spell THIS_SPELL
    
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\Invisibility.page\\Invisibility.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateHidden(thistype.NAME + " (thisSpell)")
    
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Invisibility")
    call thistype.THIS_SPELL.SetAnimation("spell")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\Invisibility.page\\Invisibility.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod