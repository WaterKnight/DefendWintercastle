//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Stun\obj_dummyBuff.j
static constant integer DUMMY_BUFF_ID = 'BStn'
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Stun\\dummyBuff.wc3buff")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Stun\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Stun\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Stun\obj_dummySpell.j
static constant integer DUMMY_SPELL_ID = 'AStn'
    
    
static method Init_obj_dummySpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Stun\\dummySpell.wc3spell")
    call InitAbility('AStn')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Stun\\dummySpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Stun\obj_dummySpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Stun\obj_normalBuff.j
static Buff NORMAL_BUFF
    
    
static method Init_obj_normalBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Stun\\normalBuff.wc3buff")
    set thistype.NORMAL_BUFF = Buff.Create('BStu', "Stunned", 'bStu')
    call thistype.NORMAL_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNStun.blp")
    call thistype.NORMAL_BUFF.TargetEffects.Add("Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Stun\\normalBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Stun\obj_normalBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Stun\obj_noneBuff.j
static Buff NONE_BUFF
    
    
static method Init_obj_noneBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Stun\\noneBuff.wc3buff")
    set thistype.NONE_BUFF = Buff.CreateHidden(thistype.NAME + " (noneBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Stun\\noneBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Stun\obj_noneBuff.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_dummySpell)
    call Buff.AddInit(function thistype.Init_obj_normalBuff)
    call Buff.AddInit(function thistype.Init_obj_noneBuff)
endmethod