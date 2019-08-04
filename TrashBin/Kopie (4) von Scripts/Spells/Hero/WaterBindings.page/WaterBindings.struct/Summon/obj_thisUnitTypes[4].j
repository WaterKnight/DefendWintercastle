
static method Init_obj_thisUnitTypes4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\thisUnitTypes[4].wc3unit")
    set thistype.THIS_UNIT_TYPES[4] = UnitType.Create('uWB4')
    call thistype.THIS_UNIT_TYPES[4].Scale.Set(0.9)
    call thistype.THIS_UNIT_TYPES[4].Impact.Z.Set(120)
    call thistype.THIS_UNIT_TYPES[4].Outpact.Z.Set(60)
    call thistype.THIS_UNIT_TYPES[4].Speed.Set(230)
    call thistype.THIS_UNIT_TYPES[4].Armor.Set(2)
    call thistype.THIS_UNIT_TYPES[4].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.THIS_UNIT_TYPES[4].Life.Set(675)
    call thistype.THIS_UNIT_TYPES[4].Life.SetBJ(675)
    call thistype.THIS_UNIT_TYPES[4].LifeRegeneration.Set(0)
    call thistype.THIS_UNIT_TYPES[4].SightRange.Set(1400)
    call thistype.THIS_UNIT_TYPES[4].SightRange.SetBJ(1400)
    call thistype.THIS_UNIT_TYPES[4].SpellPower.Set(30)
    call thistype.THIS_UNIT_TYPES[4].Attack.Set(Attack.MISSILE)
    call thistype.THIS_UNIT_TYPES[4].Attack.Range.Set(600)
    call thistype.THIS_UNIT_TYPES[4].Attack.Speed.SetByCooldown(1.6)
    call thistype.THIS_UNIT_TYPES[4].Damage.Delay.Set(0.4)
    call thistype.THIS_UNIT_TYPES[4].Attack.Missile.Speed.Set(1300)
    call thistype.THIS_UNIT_TYPES[4].Damage.Set(26)
    call thistype.THIS_UNIT_TYPES[4].Damage.SetBJ(26)
    call thistype.THIS_UNIT_TYPES[4].Damage.Dices.Set(3)
    call thistype.THIS_UNIT_TYPES[4].Damage.Sides.Set(3)
    call thistype.THIS_UNIT_TYPES[4].Damage.Type.Set(Attack.DMG_TYPE_PIERCE)
    call thistype.THIS_UNIT_TYPES[4].CollisionSize.Set(32)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\thisUnitTypes[4].wc3unit")
    call t.Destroy()
endmethod