//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\obj_zEnablerSpell.j
static constant integer Z_ENABLER_SPELL_ID = 'aFly'
    
    
static method Init_obj_zEnablerSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\zEnablerSpell.wc3spell")
    call InitAbility('aFly')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\zEnablerSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\obj_zEnablerSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\obj_zEnablerUnit.j
static constant integer Z_ENABLER_UNIT_ID = 'qFly'
    
    
static method Init_obj_zEnablerUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\zEnablerUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\zEnablerUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\obj_zEnablerUnit.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_zEnablerSpell)
    call UnitType.AddInit(function thistype.Init_obj_zEnablerUnit)
endmethod