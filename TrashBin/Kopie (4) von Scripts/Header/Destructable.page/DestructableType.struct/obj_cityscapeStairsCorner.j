static DestructableType CITYSCAPE_STAIRS_CORNER
    
    
static method Init_obj_cityscapeStairsCorner takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\cityscapeStairsCorner.wc3dest")
    set thistype.CITYSCAPE_STAIRS_CORNER = DestructableType.Create('C003')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\cityscapeStairsCorner.wc3dest")
    call t.Destroy()
endmethod