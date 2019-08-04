//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Attack\obj_disableSpell.j
static constant integer DISABLE_SPELL_ID = 'Abun'
    
    
static method Init_obj_disableSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\disableSpell.wc3spell")
    call InitAbility('Abun')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\disableSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Attack\obj_disableSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Attack\obj_noneBuff.j
static Buff NONE_BUFF
    
    
static method Init_obj_noneBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\noneBuff.wc3buff")
    set thistype.NONE_BUFF = Buff.CreateHidden(thistype.NAME + " (noneBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\noneBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Attack\obj_noneBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Attack\obj_normalBuff.j
static Buff NORMAL_BUFF
    
    
static method Init_obj_normalBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\normalBuff.wc3buff")
    set thistype.NORMAL_BUFF = Buff.CreateHidden(thistype.NAME + " (normalBuff)")
    call thistype.NORMAL_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\StasisTrap\\StasisTotemTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\normalBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Attack\obj_normalBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Attack\obj_iconSpell.j
static constant integer ICON_SPELL_ID = 'ADAI'
    
    
static method Init_obj_iconSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\iconSpell.wc3spell")
    call InitAbility('ADAI')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\iconSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Attack\obj_iconSpell.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_disableSpell)
    call Buff.AddInit(function thistype.Init_obj_noneBuff)
    call Buff.AddInit(function thistype.Init_obj_normalBuff)
    call Spell.AddInit(function thistype.Init_obj_iconSpell)
endmethod