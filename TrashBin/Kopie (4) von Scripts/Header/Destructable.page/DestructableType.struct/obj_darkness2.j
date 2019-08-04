static DestructableType DARKNESS2
    
    
static method Init_obj_darkness2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\darkness2.wc3dest")
    set thistype.DARKNESS2 = DestructableType.Create('C009')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\darkness2.wc3dest")
    call t.Destroy()
endmethod