//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\EyeOfTheFlame.page\EyeOfTheFlame.struct\TorchLight.page\TorchLight.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer HERO_DURATION = 2
static integer DURATION = 5
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EyeOfTheFlame.page\\EyeOfTheFlame.struct\\TorchLight.page\\TorchLight.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateHidden(thistype.NAME + " (thisSpell)")
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Torch Light")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNVolcano.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EyeOfTheFlame.page\\EyeOfTheFlame.struct\\TorchLight.page\\TorchLight.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\EyeOfTheFlame.page\EyeOfTheFlame.struct\TorchLight.page\TorchLight.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\EyeOfTheFlame.page\EyeOfTheFlame.struct\TorchLight.page\TorchLight.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EyeOfTheFlame.page\\EyeOfTheFlame.struct\\TorchLight.page\\TorchLight.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EyeOfTheFlame.page\\EyeOfTheFlame.struct\\TorchLight.page\\TorchLight.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\EyeOfTheFlame.page\EyeOfTheFlame.struct\TorchLight.page\TorchLight.struct\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod