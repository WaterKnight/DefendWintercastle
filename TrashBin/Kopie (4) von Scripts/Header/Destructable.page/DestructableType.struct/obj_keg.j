static DestructableType KEG
    
    
static method Init_obj_keg takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\keg.wc3dest")
    set thistype.KEG = DestructableType.Create('CKeg')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\keg.wc3dest")
    call t.Destroy()
endmethod