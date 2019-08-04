
static method Init_obj_summonUnitType5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[5].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[5] = UnitType.Create('uPB5')
    call thistype.SUMMON_UNIT_TYPE[5].Scale.Set(1.45)
    call thistype.SUMMON_UNIT_TYPE[5].Impact.Z.Set(126.15)
    call thistype.SUMMON_UNIT_TYPE[5].Outpact.Z.Set(126.15)
    call thistype.SUMMON_UNIT_TYPE[5].Speed.Set(270)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Set(6)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[5].Life.Set(900)
    call thistype.SUMMON_UNIT_TYPE[5].Life.SetBJ(900)
    call thistype.SUMMON_UNIT_TYPE[5].LifeRegeneration.Set(2.5)
    call thistype.SUMMON_UNIT_TYPE[5].Mana.Set(160)
    call thistype.SUMMON_UNIT_TYPE[5].Mana.SetBJ(160)
    call thistype.SUMMON_UNIT_TYPE[5].ManaRegeneration.Set(1.5)
    call thistype.SUMMON_UNIT_TYPE[5].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[5].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[5].SpellPower.Set(85)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Speed.SetByCooldown(1.35)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Delay.Set(0.63)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Set(27)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.SetBJ(27)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Dices.Set(4)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Sides.Set(4)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[5].CollisionSize.Set(100.92)
    call thistype.SUMMON_UNIT_TYPE[5].Abilities.AddWithLevel(ArcticBlink(NULL).THIS_SPELL, 3)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[5].wc3unit")
    call t.Destroy()
endmethod