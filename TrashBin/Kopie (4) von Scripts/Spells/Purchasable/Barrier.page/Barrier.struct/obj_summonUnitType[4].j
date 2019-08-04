
static method Init_obj_summonUnitType4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[4].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[4] = UnitType.Create('uBa4')
    call thistype.SUMMON_UNIT_TYPE[4].Classes.Add(UnitClass.STRUCTURE)
    call thistype.SUMMON_UNIT_TYPE[4].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[4].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[4].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[4].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Set(8)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Type.Set(Attack.ARMOR_TYPE_FORT)
    call thistype.SUMMON_UNIT_TYPE[4].Life.Set(310)
    call thistype.SUMMON_UNIT_TYPE[4].Life.SetBJ(310)
    call thistype.SUMMON_UNIT_TYPE[4].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[4].SpellPower.Set(90)
    call thistype.SUMMON_UNIT_TYPE[4].CollisionSize.Set(40)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[4].wc3unit")
    call t.Destroy()
endmethod