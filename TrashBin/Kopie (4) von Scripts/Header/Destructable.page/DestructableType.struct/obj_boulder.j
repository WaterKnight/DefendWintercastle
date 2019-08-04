static DestructableType BOULDER
    
    
static method Init_obj_boulder takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\boulder.wc3dest")
    set thistype.BOULDER = DestructableType.Create('C007')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\boulder.wc3dest")
    call t.Destroy()
endmethod