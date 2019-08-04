static UnitType SUMMON_UNIT_TYPE
    
    
static method Init_obj_summonUnitType takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\SetMines\\Mine\\summonUnitType.wc3unit")
    set thistype.SUMMON_UNIT_TYPE = UnitType.Create('uTrM')
    call thistype.SUMMON_UNIT_TYPE.Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE.Scale.Set(1.35)
    call thistype.SUMMON_UNIT_TYPE.Impact.Z.Set(109.35)
    call thistype.SUMMON_UNIT_TYPE.Outpact.Z.Set(109.35)
    call thistype.SUMMON_UNIT_TYPE.Attachments.Add("Units\\Trap\\PointingArrow.mdx", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.SUMMON_UNIT_TYPE.Armor.Set(1)
    call thistype.SUMMON_UNIT_TYPE.Armor.Type.Set(Attack.ARMOR_TYPE_MEDIUM)
    call thistype.SUMMON_UNIT_TYPE.Life.Set(5)
    call thistype.SUMMON_UNIT_TYPE.Life.SetBJ(5)
    call thistype.SUMMON_UNIT_TYPE.LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE.CollisionSize.Set(29.16)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\SetMines\\Mine\\summonUnitType.wc3unit")
    call t.Destroy()
endmethod