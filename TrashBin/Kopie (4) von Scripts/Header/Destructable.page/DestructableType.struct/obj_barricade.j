static DestructableType BARRICADE
    
    
static method Init_obj_barricade takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\barricade.wc3dest")
    set thistype.BARRICADE = DestructableType.Create('C006')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\barricade.wc3dest")
    call t.Destroy()
endmethod