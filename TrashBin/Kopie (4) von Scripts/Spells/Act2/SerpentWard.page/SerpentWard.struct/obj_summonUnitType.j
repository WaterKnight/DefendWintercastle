static UnitType SUMMON_UNIT_TYPE
    
    
static method Init_obj_summonUnitType takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SerpentWard.page\\SerpentWard.struct\\summonUnitType.wc3unit")
    set thistype.SUMMON_UNIT_TYPE = UnitType.Create('uSeW')
    call thistype.SUMMON_UNIT_TYPE.Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE.Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE.Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE.Outpact.Z.Set(225)
    call thistype.SUMMON_UNIT_TYPE.Armor.Set(0)
    call thistype.SUMMON_UNIT_TYPE.Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE.Life.Set(100)
    call thistype.SUMMON_UNIT_TYPE.Life.SetBJ(100)
    call thistype.SUMMON_UNIT_TYPE.LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE.SightRange.Set(1200)
    call thistype.SUMMON_UNIT_TYPE.SightRange.SetBJ(1200)
    call thistype.SUMMON_UNIT_TYPE.SpellPower.Set(35)
    call thistype.SUMMON_UNIT_TYPE.Attack.Set(Attack.HOMING_MISSILE)
    call thistype.SUMMON_UNIT_TYPE.Attack.Range.Set(600)
    call thistype.SUMMON_UNIT_TYPE.Attack.Speed.SetByCooldown(1.5)
    call thistype.SUMMON_UNIT_TYPE.Damage.Delay.Set(0.3)
    call thistype.SUMMON_UNIT_TYPE.Attack.Missile.Speed.Set(900)
    call thistype.SUMMON_UNIT_TYPE.Damage.Set(12)
    call thistype.SUMMON_UNIT_TYPE.Damage.SetBJ(12)
    call thistype.SUMMON_UNIT_TYPE.Damage.Dices.Set(1)
    call thistype.SUMMON_UNIT_TYPE.Damage.Sides.Set(3)
    call thistype.SUMMON_UNIT_TYPE.Damage.Type.Set(Attack.DMG_TYPE_PIERCE)
    call thistype.SUMMON_UNIT_TYPE.CollisionSize.Set(16)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SerpentWard.page\\SerpentWard.struct\\summonUnitType.wc3unit")
    call t.Destroy()
endmethod