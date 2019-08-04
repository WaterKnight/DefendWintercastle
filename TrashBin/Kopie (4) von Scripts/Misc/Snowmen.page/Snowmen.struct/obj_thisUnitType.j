static UnitType THIS_UNIT_TYPE
    
    
static method Init_obj_thisUnitType takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Snowmen.page\\Snowmen.struct\\thisUnitType.wc3unit")
    set thistype.THIS_UNIT_TYPE = UnitType.Create('uSnM')
    call thistype.THIS_UNIT_TYPE.Classes.Add(UnitClass.STRUCTURE)
    call thistype.THIS_UNIT_TYPE.Classes.Add(UnitClass.NEUTRAL)
    call thistype.THIS_UNIT_TYPE.Classes.Add(UnitClass.STRUCTURE)
    call thistype.THIS_UNIT_TYPE.Scale.Set(2)
    call thistype.THIS_UNIT_TYPE.Impact.Z.Set(480)
    call thistype.THIS_UNIT_TYPE.Outpact.Z.Set(240)
    call thistype.THIS_UNIT_TYPE.Armor.Set(0)
    call thistype.THIS_UNIT_TYPE.Armor.Type.Set(Attack.ARMOR_TYPE_MEDIUM)
    call thistype.THIS_UNIT_TYPE.Life.Set(200)
    call thistype.THIS_UNIT_TYPE.Life.SetBJ(200)
    call thistype.THIS_UNIT_TYPE.LifeRegeneration.Set(0)
    call thistype.THIS_UNIT_TYPE.SightRange.Set(1500)
    call thistype.THIS_UNIT_TYPE.SightRange.SetBJ(1500)
    call thistype.THIS_UNIT_TYPE.SpellPower.Set(25)
    call thistype.THIS_UNIT_TYPE.Drop.Supply.Set(30)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Snowmen.page\\Snowmen.struct\\thisUnitType.wc3unit")
    call t.Destroy()
endmethod