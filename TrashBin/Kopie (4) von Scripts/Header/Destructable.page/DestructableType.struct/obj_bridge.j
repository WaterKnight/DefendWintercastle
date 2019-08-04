static DestructableType BRIDGE
    
    
static method Init_obj_bridge takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\bridge.wc3dest")
    set thistype.BRIDGE = DestructableType.Create('C00D')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\bridge.wc3dest")
    call t.Destroy()
endmethod