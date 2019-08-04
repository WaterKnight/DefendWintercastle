
static method Init_obj_summonUnitType4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[4].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[4] = UnitType.Create('uGh4')
    call thistype.SUMMON_UNIT_TYPE[4].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[4].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[4].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[4].Speed.Set(220)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Set(1)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Type.Set(Attack.ARMOR_TYPE_MEDIUM)
    call thistype.SUMMON_UNIT_TYPE[4].Life.Set(350)
    call thistype.SUMMON_UNIT_TYPE[4].Life.SetBJ(350)
    call thistype.SUMMON_UNIT_TYPE[4].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[4].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[4].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[4].SpellPower.Set(60)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Speed.SetByCooldown(1.7)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Delay.Set(0.3)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Set(10)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.SetBJ(10)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Sides.Set(2)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[4].CollisionSize.Set(20)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[4].wc3unit")
    call t.Destroy()
endmethod