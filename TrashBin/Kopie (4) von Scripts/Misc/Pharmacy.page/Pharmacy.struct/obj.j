//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\obj_shop.j
static UnitType SHOP
    
    
static method Init_obj_shop takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\shop.wc3unit")
    set thistype.SHOP = UnitType.Create('uPha')
    call thistype.SHOP.Classes.Add(UnitClass.STRUCTURE)
    call thistype.SHOP.Classes.Add(UnitClass.NEUTRAL)
    call thistype.SHOP.Classes.Add(UnitClass.STRUCTURE)
    call thistype.SHOP.Scale.Set(2)
    call thistype.SHOP.Impact.Z.Set(480)
    call thistype.SHOP.Outpact.Z.Set(240)
    call thistype.SHOP.Armor.Set(0)
    call thistype.SHOP.Armor.Type.Set(Attack.ARMOR_TYPE_FORT)
    call thistype.SHOP.Life.Set(UNIT_TYPE.Life.INFINITE)
    call thistype.SHOP.Life.SetBJ(UNIT_TYPE.Life.INFINITE)
    call thistype.SHOP.LifeRegeneration.Set(0)
    call thistype.SHOP.SightRange.Set(500)
    call thistype.SHOP.SightRange.SetBJ(500)
    call thistype.SHOP.Abilities.Add(Invulnerability(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\shop.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\obj_shop.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_shop)
endmethod