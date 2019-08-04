static Spell BASE_NORM
    
    
static method Init_obj_baseNorm takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\baseNorm.wc3spell")
    set thistype.BASE_NORM = Spell.CreateHidden(thistype.NAME + " (baseNorm)")
    
    call thistype.BASE_NORM.SetLevelsAmount(5)
    call thistype.BASE_NORM.SetAnimation("spell")
    call thistype.BASE_NORM.SetIcon("ReplaceableTextures\\CommandButtons\\")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\baseNorm.wc3spell")
    call t.Destroy()
endmethod