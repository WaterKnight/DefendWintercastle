//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\Knockback\obj_this.j
static integer AREA_RANGE = 80
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\Knockback\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\Knockback\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\Knockback\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\Knockback\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\Knockback\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\Knockback\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\Knockback\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod