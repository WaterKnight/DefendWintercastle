
static method Init_obj_summonUnitType2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[2].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[2] = UnitType.Create('uBa2')
    call thistype.SUMMON_UNIT_TYPE[2].Classes.Add(UnitClass.STRUCTURE)
    call thistype.SUMMON_UNIT_TYPE[2].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[2].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[2].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[2].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Set(6)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Type.Set(Attack.ARMOR_TYPE_FORT)
    call thistype.SUMMON_UNIT_TYPE[2].Life.Set(180)
    call thistype.SUMMON_UNIT_TYPE[2].Life.SetBJ(180)
    call thistype.SUMMON_UNIT_TYPE[2].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[2].SpellPower.Set(70)
    call thistype.SUMMON_UNIT_TYPE[2].CollisionSize.Set(40)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[2].wc3unit")
    call t.Destroy()
endmethod