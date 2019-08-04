
static method Init_obj_summonUnitType3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[3].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[3] = UnitType.Create('uBa3')
    call thistype.SUMMON_UNIT_TYPE[3].Classes.Add(UnitClass.STRUCTURE)
    call thistype.SUMMON_UNIT_TYPE[3].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[3].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[3].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[3].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Set(7)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Type.Set(Attack.ARMOR_TYPE_FORT)
    call thistype.SUMMON_UNIT_TYPE[3].Life.Set(240)
    call thistype.SUMMON_UNIT_TYPE[3].Life.SetBJ(240)
    call thistype.SUMMON_UNIT_TYPE[3].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[3].SpellPower.Set(80)
    call thistype.SUMMON_UNIT_TYPE[3].CollisionSize.Set(40)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[3].wc3unit")
    call t.Destroy()
endmethod