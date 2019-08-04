//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\IceTea.page\IceTea.struct\obj_IceTea.j
static ItemType ICE_TEA
    
    
static method Init_obj_IceTea takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\IceTea.wc3item")
    set thistype.ICE_TEA = ItemType.CreateFromSelf('IIcT')
    call thistype.ICE_TEA.ChargesAmount.Set(1)
    call thistype.ICE_TEA.Abilities.AddWithLevel(IceTea(NULL).THIS_SPELL, 2)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\IceTea.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\IceTea.page\IceTea.struct\obj_IceTea.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\IceTea.page\IceTea.struct\obj_SoftDrink.j
static ItemType SOFT_DRINK
    
    
static method Init_obj_SoftDrink takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\SoftDrink.wc3item")
    set thistype.SOFT_DRINK = ItemType.CreateFromSelf('ISDr')
    call thistype.SOFT_DRINK.ChargesAmount.Set(1)
    call thistype.SOFT_DRINK.Abilities.Add(IceTea(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\SoftDrink.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\IceTea.page\IceTea.struct\obj_SoftDrink.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\IceTea.page\IceTea.struct\obj_ThirstQuencher.j
static ItemType THIRST_QUENCHER
    
    
static method Init_obj_ThirstQuencher takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\ThirstQuencher.wc3item")
    set thistype.THIRST_QUENCHER = ItemType.CreateFromSelf('IThQ')
    call thistype.THIRST_QUENCHER.ChargesAmount.Set(1)
    call thistype.THIRST_QUENCHER.Abilities.AddWithLevel(IceTea(NULL).THIS_SPELL, 3)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\ThirstQuencher.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\IceTea.page\IceTea.struct\obj_ThirstQuencher.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\IceTea.page\IceTea.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string CASTER_EFFECT_PATH = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl"
static string CASTER_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static integer array REFRESHED_MANA
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AIcT')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ITEM)
    call thistype.THIS_SPELL.SetLevelsAmount(3)
    call thistype.THIS_SPELL.SetName("Ice Tea")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 20)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 20)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetCooldown(3, 20)
    call thistype.THIS_SPELL.SetRange(3, 750)
    
    set thistype.REFRESHED_MANA[1] = 200
    set thistype.REFRESHED_MANA[2] = 350
    set thistype.REFRESHED_MANA[3] = 500
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\IceTea.page\IceTea.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call ItemType.AddInit(function thistype.Init_obj_IceTea)
    call ItemType.AddInit(function thistype.Init_obj_SoftDrink)
    call ItemType.AddInit(function thistype.Init_obj_ThirstQuencher)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod