
static method Init_obj_summonUnitType3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[3].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[3] = UnitType.Create('uGh3')
    call thistype.SUMMON_UNIT_TYPE[3].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[3].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[3].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[3].Speed.Set(220)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Set(1)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Type.Set(Attack.ARMOR_TYPE_MEDIUM)
    call thistype.SUMMON_UNIT_TYPE[3].Life.Set(275)
    call thistype.SUMMON_UNIT_TYPE[3].Life.SetBJ(275)
    call thistype.SUMMON_UNIT_TYPE[3].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[3].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[3].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[3].SpellPower.Set(60)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Speed.SetByCooldown(1.7)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Delay.Set(0.3)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Set(5)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.SetBJ(5)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Sides.Set(2)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[3].CollisionSize.Set(20)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[3].wc3unit")
    call t.Destroy()
endmethod