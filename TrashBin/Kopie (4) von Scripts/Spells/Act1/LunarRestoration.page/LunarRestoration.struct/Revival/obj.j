//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\LunarRestoration.page\LunarRestoration.struct\Revival\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LunarRestoration.page\\LunarRestoration.struct\\Revival\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LunarRestoration.page\\LunarRestoration.struct\\Revival\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\LunarRestoration.page\LunarRestoration.struct\Revival\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\LunarRestoration.page\LunarRestoration.struct\Revival\obj_this.j
static real MANA_FACTOR = 0.3
static real DURATION = 4.5
static real LIFE_FACTOR = 0.3
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Orc\\Reincarnation\\ReincarnationTarget.mdl"
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LunarRestoration.page\\LunarRestoration.struct\\Revival\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LunarRestoration.page\\LunarRestoration.struct\\Revival\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\LunarRestoration.page\LunarRestoration.struct\Revival\obj_this.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod