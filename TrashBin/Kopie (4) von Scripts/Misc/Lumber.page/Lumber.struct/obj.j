//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Lumber.page\Lumber.struct\obj_thisItemType.j
static ItemType THIS_ITEM_TYPE
    
    
static method Init_obj_thisItemType takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Lumber.page\\Lumber.struct\\thisItemType.wc3item")
    set thistype.THIS_ITEM_TYPE = ItemType.CreateFromSelf('ILum')
    call thistype.THIS_ITEM_TYPE.Classes.Add(ItemClass.POWER_UP)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Lumber.page\\Lumber.struct\\thisItemType.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Lumber.page\Lumber.struct\obj_thisItemType.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Lumber.page\Lumber.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qLum'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Lumber.page\\Lumber.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Lumber.page\\Lumber.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Lumber.page\Lumber.struct\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call ItemType.AddInit(function thistype.Init_obj_thisItemType)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod