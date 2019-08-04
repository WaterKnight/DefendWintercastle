//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Silence\obj_dummySpell.j
static constant integer DUMMY_SPELL_ID = 'aSil'
    
    
static method Init_obj_dummySpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Silence\\dummySpell.wc3spell")
    call InitAbility('aSil')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Silence\\dummySpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Silence\obj_dummySpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Silence\obj_noneBuff.j
static Buff NONE_BUFF
    
    
static method Init_obj_noneBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Silence\\noneBuff.wc3buff")
    set thistype.NONE_BUFF = Buff.CreateHidden(thistype.NAME + " (noneBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Silence\\noneBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Silence\obj_noneBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Silence\obj_normalBuff.j
static Buff NORMAL_BUFF
    
    
static method Init_obj_normalBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Silence\\normalBuff.wc3buff")
    set thistype.NORMAL_BUFF = Buff.CreateHidden(thistype.NAME + " (normalBuff)")
    call thistype.NORMAL_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Silence\\normalBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Silence\obj_normalBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Silence\obj_dummyBuff.j
static constant integer DUMMY_BUFF_ID = 'bSil'
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Silence\\dummyBuff.wc3buff")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Silence\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Silence\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_dummySpell)
    call Buff.AddInit(function thistype.Init_obj_noneBuff)
    call Buff.AddInit(function thistype.Init_obj_normalBuff)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod