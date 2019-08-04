//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\RabbitsFoot.page\RabbitsFoot.struct\obj_thisItem.j
static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\RabbitsFoot.page\\RabbitsFoot.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('IRaF')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\RabbitsFoot.page\\RabbitsFoot.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\RabbitsFoot.page\RabbitsFoot.struct\obj_thisItem.j


private static method onInit takes nothing returns nothing
    call ItemType.AddInit(function thistype.Init_obj_thisItem)
endmethod