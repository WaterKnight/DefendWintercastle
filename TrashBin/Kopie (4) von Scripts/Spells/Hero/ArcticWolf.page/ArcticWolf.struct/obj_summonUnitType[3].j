
static method Init_obj_summonUnitType3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\summonUnitType[3].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[3] = UnitType.Create('uAW3')
    call thistype.SUMMON_UNIT_TYPE[3].Scale.Set(1.5)
    call thistype.SUMMON_UNIT_TYPE[3].VertexColor.Set(150, 120, 255, 255)
    call thistype.SUMMON_UNIT_TYPE[3].Impact.Z.Set(135)
    call thistype.SUMMON_UNIT_TYPE[3].Outpact.Z.Set(135)
    call thistype.SUMMON_UNIT_TYPE[3].Attachments.Add("Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", AttachPoint.HAND_LEFT, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[3].Attachments.Add("Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", AttachPoint.HAND_RIGHT, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[3].Attachments.Add("Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", AttachPoint.FOOT_LEFT, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[3].Attachments.Add("Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", AttachPoint.FOOT_RIGHT, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[3].Speed.Set(320)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Set(2)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[3].Life.Set(750)
    call thistype.SUMMON_UNIT_TYPE[3].Life.SetBJ(750)
    call thistype.SUMMON_UNIT_TYPE[3].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[3].Mana.Set(300)
    call thistype.SUMMON_UNIT_TYPE[3].Mana.SetBJ(300)
    call thistype.SUMMON_UNIT_TYPE[3].ManaRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[3].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[3].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[3].SpellPower.Set(110)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Range.Set(90)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Speed.SetByCooldown(1.35)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Delay.Set(0.33)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Set(70)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.SetBJ(70)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Sides.Set(22)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[3].CollisionSize.Set(74.25)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\summonUnitType[3].wc3unit")
    call t.Destroy()
endmethod