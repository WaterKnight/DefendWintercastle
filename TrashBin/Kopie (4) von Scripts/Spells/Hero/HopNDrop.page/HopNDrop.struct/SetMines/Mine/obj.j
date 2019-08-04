//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HopNDrop.page\HopNDrop.struct\SetMines\Mine\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\SetMines\\Mine\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BSMB', "Mine", 'bSMB')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGoblinLandMine.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("units\\human\\phoenix\\phoenix.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\SetMines\\Mine\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HopNDrop.page\HopNDrop.struct\SetMines\Mine\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HopNDrop.page\HopNDrop.struct\SetMines\Mine\obj_this.j
static real MOVE_DURATION = 0.5
static integer STUN_DURATION = 2
static real EXPLOSION_DELAY = 1.5
static integer MOVE_Z_SPEED_START = 40
static real FRIENDLY_FIRE_FACTOR = 0.25
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\SetMines\\Mine\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\SetMines\\Mine\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HopNDrop.page\HopNDrop.struct\SetMines\Mine\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HopNDrop.page\HopNDrop.struct\SetMines\Mine\obj_summonUnitType.j
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
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HopNDrop.page\HopNDrop.struct\SetMines\Mine\obj_summonUnitType.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType)
endmethod