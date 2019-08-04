static DestructableType STAIRS_CORNER
    
    
static method Init_obj_stairsCorner takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\stairsCorner.wc3dest")
    set thistype.STAIRS_CORNER = DestructableType.Create('C00E')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\stairsCorner.wc3dest")
    call t.Destroy()
endmethod