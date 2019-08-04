//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\Invisibility.page\Invisibility.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\Invisibility.page\\Invisibility.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateHidden(thistype.NAME + " (thisSpell)")
    
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Invisibility")
    call thistype.THIS_SPELL.SetAnimation("spell")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\Invisibility.page\\Invisibility.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\Invisibility.page\Invisibility.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\Invisibility.page\Invisibility.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\Invisibility.page\\Invisibility.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\Invisibility.page\\Invisibility.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\Invisibility.page\Invisibility.struct\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod