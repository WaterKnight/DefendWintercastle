static DestructableType EXPLOSIVE
    
    
static method Init_obj_explosive takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\explosive.wc3dest")
    set thistype.EXPLOSIVE = DestructableType.Create('CExp')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\explosive.wc3dest")
    call t.Destroy()
endmethod