static UnitType array SUMMON_UNIT_TYPE
    
    
static method Init_obj_summonUnitType1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[1].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.Create('uPoB')
    call thistype.SUMMON_UNIT_TYPE[1].Scale.Set(0.95)
    call thistype.SUMMON_UNIT_TYPE[1].Impact.Z.Set(54.15)
    call thistype.SUMMON_UNIT_TYPE[1].Outpact.Z.Set(54.15)
    call thistype.SUMMON_UNIT_TYPE[1].Speed.Set(270)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Set(2)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[1].Life.Set(400)
    call thistype.SUMMON_UNIT_TYPE[1].Life.SetBJ(400)
    call thistype.SUMMON_UNIT_TYPE[1].LifeRegeneration.Set(1.5)
    call thistype.SUMMON_UNIT_TYPE[1].Mana.Set(80)
    call thistype.SUMMON_UNIT_TYPE[1].Mana.SetBJ(80)
    call thistype.SUMMON_UNIT_TYPE[1].ManaRegeneration.Set(0.5)
    call thistype.SUMMON_UNIT_TYPE[1].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[1].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[1].SpellPower.Set(45)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Speed.SetByCooldown(1.35)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Delay.Set(0.63)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Set(14)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.SetBJ(14)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Dices.Set(1)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Sides.Set(5)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[1].CollisionSize.Set(43.32)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[1].wc3unit")
    call t.Destroy()
endmethod