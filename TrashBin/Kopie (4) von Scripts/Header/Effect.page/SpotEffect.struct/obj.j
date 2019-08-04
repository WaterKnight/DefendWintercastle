//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Effect.page\SpotEffect.struct\obj_withZDummyDestructable.j
static constant integer WITH_Z_DUMMY_DESTRUCTABLE_ID = 'cEfL'
    
    
static method Init_obj_withZDummyDestructable takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Effect.page\\SpotEffect.struct\\withZDummyDestructable.wc3dest")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Effect.page\\SpotEffect.struct\\withZDummyDestructable.wc3dest")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Effect.page\SpotEffect.struct\obj_withZDummyDestructable.j


private static method onInit takes nothing returns nothing
    call DestructableType.AddInit(function thistype.Init_obj_withZDummyDestructable)
endmethod