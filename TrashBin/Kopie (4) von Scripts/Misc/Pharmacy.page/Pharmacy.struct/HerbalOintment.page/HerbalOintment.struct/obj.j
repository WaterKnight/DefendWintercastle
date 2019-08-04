//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\HerbalOintment.page\HerbalOintment.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\HerbalOintment.page\\HerbalOintment.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BHeO', "Herbal Ointment", 'bHeO')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHealingSalve.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\ANrl\\ANrlTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\ANrm\\ANrmTarget.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\HerbalOintment.page\\HerbalOintment.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\HerbalOintment.page\HerbalOintment.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\HerbalOintment.page\HerbalOintment.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer INTERVAL = 1
static integer DURATION = 10
static integer LIFE_ADD = 200
static integer MANA_ADD = 200
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\HerbalOintment.page\\HerbalOintment.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AHeO')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ITEM)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Herbal Ointment")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 10)
    call thistype.THIS_SPELL.SetRange(1, 750)
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\HerbalOintment.page\\HerbalOintment.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\HerbalOintment.page\HerbalOintment.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\HerbalOintment.page\HerbalOintment.struct\obj_thisItem.j
static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\HerbalOintment.page\\HerbalOintment.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('IHeO')
    call thistype.THIS_ITEM.ChargesAmount.Set(2)
    call thistype.THIS_ITEM.Abilities.Add(HerbalOintment(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\HerbalOintment.page\\HerbalOintment.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\HerbalOintment.page\HerbalOintment.struct\obj_thisItem.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call ItemType.AddInit(function thistype.Init_obj_thisItem)
endmethod