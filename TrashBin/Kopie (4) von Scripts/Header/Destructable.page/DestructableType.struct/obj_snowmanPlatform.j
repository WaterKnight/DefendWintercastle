static DestructableType SNOWMAN_PLATFORM
    
    
static method Init_obj_snowmanPlatform takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\snowmanPlatform.wc3dest")
    set thistype.SNOWMAN_PLATFORM = DestructableType.Create('C00G')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\snowmanPlatform.wc3dest")
    call t.Destroy()
endmethod