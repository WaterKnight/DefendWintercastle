
static method Init_obj_summonUnitType3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\summonUnitType[3].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[3] = UnitType.Create('uDe3')
    call thistype.SUMMON_UNIT_TYPE[3].Scale.Set(0.7)
    call thistype.SUMMON_UNIT_TYPE[3].Impact.Z.Set(49)
    call thistype.SUMMON_UNIT_TYPE[3].Outpact.Z.Set(29.4)
    call thistype.SUMMON_UNIT_TYPE[3].Speed.Set(270)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Set(0)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Type.Set(Attack.ARMOR_TYPE_HERO)
    call thistype.SUMMON_UNIT_TYPE[3].Life.Set(185)
    call thistype.SUMMON_UNIT_TYPE[3].Life.SetBJ(185)
    call thistype.SUMMON_UNIT_TYPE[3].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[3].SightRange.Set(1800)
    call thistype.SUMMON_UNIT_TYPE[3].SightRange.SetBJ(1800)
    call thistype.SUMMON_UNIT_TYPE[3].SpellPower.Set(35)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Set(Attack.HOMING_MISSILE)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Range.Set(500)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Speed.SetByCooldown(1.8)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Delay.Set(0.55)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Missile.Speed.Set(600)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Set(20)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.SetBJ(20)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Sides.Set(7)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Type.Set(Attack.DMG_TYPE_CHAOS)
    call thistype.SUMMON_UNIT_TYPE[3].CollisionSize.Set(7.84)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\summonUnitType[3].wc3unit")
    call t.Destroy()
endmethod