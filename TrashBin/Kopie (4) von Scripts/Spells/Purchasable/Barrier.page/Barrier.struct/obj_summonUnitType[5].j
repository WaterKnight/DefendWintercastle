static UnitType array SUMMON_UNIT_TYPE
    
    
static method Init_obj_summonUnitType5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[5].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[5] = UnitType.Create('uBa5')
    call thistype.SUMMON_UNIT_TYPE[5].Classes.Add(UnitClass.STRUCTURE)
    call thistype.SUMMON_UNIT_TYPE[5].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[5].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[5].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[5].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Set(9)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Type.Set(Attack.ARMOR_TYPE_FORT)
    call thistype.SUMMON_UNIT_TYPE[5].Life.Set(400)
    call thistype.SUMMON_UNIT_TYPE[5].Life.SetBJ(400)
    call thistype.SUMMON_UNIT_TYPE[5].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[5].SpellPower.Set(100)
    call thistype.SUMMON_UNIT_TYPE[5].CollisionSize.Set(40)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[5].wc3unit")
    call t.Destroy()
endmethod