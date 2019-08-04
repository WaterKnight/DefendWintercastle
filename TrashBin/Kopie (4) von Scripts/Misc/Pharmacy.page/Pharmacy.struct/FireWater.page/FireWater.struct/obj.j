//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\FireWater.page\FireWater.struct\obj_thisItem.j
static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\FireWater.page\\FireWater.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('IFiW')
    call thistype.THIS_ITEM.ChargesAmount.Set(1)
    call thistype.THIS_ITEM.Abilities.Add(FireWater(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\FireWater.page\\FireWater.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\FireWater.page\FireWater.struct\obj_thisItem.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\FireWater.page\FireWater.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string CASTER_EFFECT_PATH = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl"
static string CASTER_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static integer REFRESHED_MANA = 750
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\FireWater.page\\FireWater.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AFiW')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ITEM)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Fire Water")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 70)
    call thistype.THIS_SPELL.SetCooldown(1, 40)
    call thistype.THIS_SPELL.SetRange(1, 750)
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\FireWater.page\\FireWater.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\FireWater.page\FireWater.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call ItemType.AddInit(function thistype.Init_obj_thisItem)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod