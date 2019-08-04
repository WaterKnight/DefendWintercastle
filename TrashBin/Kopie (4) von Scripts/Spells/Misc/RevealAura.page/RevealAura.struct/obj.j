//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RevealAura.page\RevealAura.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\RevealAura.page\\RevealAura.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Human\\MagicSentry\\MagicSentryCaster.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\RevealAura.page\\RevealAura.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RevealAura.page\RevealAura.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RevealAura.page\RevealAura.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\RevealAura.page\\RevealAura.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AReA')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(2)
    call thistype.THIS_SPELL.SetName("Reveal Aura")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 200)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetAreaRange(2, 1500)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\PassiveButtons\\PASBTNMagicalSentry.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\RevealAura.page\\RevealAura.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RevealAura.page\RevealAura.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod