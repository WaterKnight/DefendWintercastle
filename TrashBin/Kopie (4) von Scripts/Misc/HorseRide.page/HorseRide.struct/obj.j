//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\HorseRide.page\HorseRide.struct\obj_shopItem.j
static ItemType SHOP_ITEM
    
    
static method Init_obj_shopItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\HorseRide.page\\HorseRide.struct\\shopItem.wc3item")
    set thistype.SHOP_ITEM = ItemType.CreateFromSelf('IHoR')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\HorseRide.page\\HorseRide.struct\\shopItem.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\HorseRide.page\HorseRide.struct\obj_shopItem.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\HorseRide.page\HorseRide.struct\obj_shop.j
static UnitType SHOP
    
    
static method Init_obj_shop takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\HorseRide.page\\HorseRide.struct\\shop.wc3unit")
    set thistype.SHOP = UnitType.Create('uRiS')
    call thistype.SHOP.Classes.Add(UnitClass.STRUCTURE)
    call thistype.SHOP.Classes.Add(UnitClass.NEUTRAL)
    call thistype.SHOP.Classes.Add(UnitClass.STRUCTURE)
    call thistype.SHOP.Scale.Set(1.3)
    call thistype.SHOP.Impact.Z.Set(202.8)
    call thistype.SHOP.Outpact.Z.Set(101.4)
    call thistype.SHOP.Armor.Set(0)
    call thistype.SHOP.Armor.Type.Set(Attack.ARMOR_TYPE_LIGHT)
    call thistype.SHOP.Life.Set(UNIT_TYPE.Life.INFINITE)
    call thistype.SHOP.Life.SetBJ(UNIT_TYPE.Life.INFINITE)
    call thistype.SHOP.LifeRegeneration.Set(0)
    call thistype.SHOP.SightRange.Set(500)
    call thistype.SHOP.SightRange.SetBJ(500)
    call thistype.SHOP.Abilities.Add(Invulnerability(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\HorseRide.page\\HorseRide.struct\\shop.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\HorseRide.page\HorseRide.struct\obj_shop.j


private static method onInit takes nothing returns nothing
    call ItemType.AddInit(function thistype.Init_obj_shopItem)
    call UnitType.AddInit(function thistype.Init_obj_shop)
endmethod