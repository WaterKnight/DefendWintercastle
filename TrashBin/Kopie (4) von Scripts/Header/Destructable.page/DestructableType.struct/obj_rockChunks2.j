static DestructableType ROCK_CHUNKS2
    
    
static method Init_obj_rockChunks2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\rockChunks2.wc3dest")
    set thistype.ROCK_CHUNKS2 = DestructableType.Create('C008')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\rockChunks2.wc3dest")
    call t.Destroy()
endmethod