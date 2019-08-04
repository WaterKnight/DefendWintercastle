//open object D:\Warcraft III\Maps\DWC\Scripts\Header\ItemType.page\ItemType.struct\obj_empty.j
static ItemType EMPTY
    
    
static method Init_obj_empty takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\ItemType.page\\ItemType.struct\\empty.wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\ItemType.page\\ItemType.struct\\empty.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\ItemType.page\ItemType.struct\obj_empty.j


private static method onInit takes nothing returns nothing
    call ItemType.AddInit(function thistype.Init_obj_empty)
endmethod