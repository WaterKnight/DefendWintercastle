//open object D:\Warcraft III\Maps\DWC\Scripts\Units\Sebastian.page\Sebastian.struct\obj_thisUnitType.j
static UnitType THIS_UNIT_TYPE
    
    
static method Init_obj_thisUnitType takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Units\\Sebastian.page\\Sebastian.struct\\thisUnitType.wc3unit")
    set thistype.THIS_UNIT_TYPE = UnitType.Create('uSeb')
    call thistype.THIS_UNIT_TYPE.Classes.Add(UnitClass.NEUTRAL)
    call thistype.THIS_UNIT_TYPE.Scale.Set(1)
    call thistype.THIS_UNIT_TYPE.Impact.Z.Set(60)
    call thistype.THIS_UNIT_TYPE.Outpact.Z.Set(60)
    call thistype.THIS_UNIT_TYPE.Armor.Set(0)
    call thistype.THIS_UNIT_TYPE.Armor.Type.Set(Attack.ARMOR_TYPE_UNARMORED)
    call thistype.THIS_UNIT_TYPE.Life.Set(120)
    call thistype.THIS_UNIT_TYPE.Life.SetBJ(120)
    call thistype.THIS_UNIT_TYPE.LifeRegeneration.Set(0)
    call thistype.THIS_UNIT_TYPE.SightRange.Set(500)
    call thistype.THIS_UNIT_TYPE.SightRange.SetBJ(500)
    call thistype.THIS_UNIT_TYPE.SpellPower.Set(400)
    call thistype.THIS_UNIT_TYPE.Abilities.Add(Invulnerability(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Units\\Sebastian.page\\Sebastian.struct\\thisUnitType.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Units\Sebastian.page\Sebastian.struct\obj_thisUnitType.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_thisUnitType)
endmethod