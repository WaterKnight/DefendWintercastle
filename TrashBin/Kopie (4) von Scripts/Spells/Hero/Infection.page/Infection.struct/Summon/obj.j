//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_summonUnitType[3].j

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
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_summonUnitType[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_this.j
static integer array MAX_AMOUNT
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\this.wc3obj")
    set thistype.MAX_AMOUNT[1] = 4
    set thistype.MAX_AMOUNT[2] = 4
    set thistype.MAX_AMOUNT[3] = 4
    set thistype.MAX_AMOUNT[4] = 4
    set thistype.MAX_AMOUNT[5] = 4
    set thistype.DURATION[1] = 23
    set thistype.DURATION[2] = 23
    set thistype.DURATION[3] = 23
    set thistype.DURATION[4] = 23
    set thistype.DURATION[5] = 23
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_summonUnitType[2].j

static method Init_obj_summonUnitType2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\summonUnitType[2].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[2] = UnitType.Create('uDe2')
    call thistype.SUMMON_UNIT_TYPE[2].Scale.Set(0.7)
    call thistype.SUMMON_UNIT_TYPE[2].Impact.Z.Set(49)
    call thistype.SUMMON_UNIT_TYPE[2].Outpact.Z.Set(29.4)
    call thistype.SUMMON_UNIT_TYPE[2].Speed.Set(270)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Set(0)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Type.Set(Attack.ARMOR_TYPE_HERO)
    call thistype.SUMMON_UNIT_TYPE[2].Life.Set(125)
    call thistype.SUMMON_UNIT_TYPE[2].Life.SetBJ(125)
    call thistype.SUMMON_UNIT_TYPE[2].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[2].SightRange.Set(1800)
    call thistype.SUMMON_UNIT_TYPE[2].SightRange.SetBJ(1800)
    call thistype.SUMMON_UNIT_TYPE[2].SpellPower.Set(25)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Set(Attack.HOMING_MISSILE)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Range.Set(500)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Speed.SetByCooldown(1.8)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Delay.Set(0.55)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Missile.Speed.Set(600)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Set(14)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.SetBJ(14)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Sides.Set(7)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Type.Set(Attack.DMG_TYPE_CHAOS)
    call thistype.SUMMON_UNIT_TYPE[2].CollisionSize.Set(7.84)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\summonUnitType[2].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_summonUnitType[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_summonUnitType[4].j

static method Init_obj_summonUnitType4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\summonUnitType[4].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[4] = UnitType.Create('uDe4')
    call thistype.SUMMON_UNIT_TYPE[4].Scale.Set(0.7)
    call thistype.SUMMON_UNIT_TYPE[4].Impact.Z.Set(49)
    call thistype.SUMMON_UNIT_TYPE[4].Outpact.Z.Set(29.4)
    call thistype.SUMMON_UNIT_TYPE[4].Speed.Set(270)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Set(0)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Type.Set(Attack.ARMOR_TYPE_HERO)
    call thistype.SUMMON_UNIT_TYPE[4].Life.Set(255)
    call thistype.SUMMON_UNIT_TYPE[4].Life.SetBJ(255)
    call thistype.SUMMON_UNIT_TYPE[4].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[4].SightRange.Set(1800)
    call thistype.SUMMON_UNIT_TYPE[4].SightRange.SetBJ(1800)
    call thistype.SUMMON_UNIT_TYPE[4].SpellPower.Set(45)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Set(Attack.HOMING_MISSILE)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Range.Set(500)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Speed.SetByCooldown(1.8)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Delay.Set(0.55)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Missile.Speed.Set(600)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Set(28)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.SetBJ(28)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Sides.Set(7)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Type.Set(Attack.DMG_TYPE_CHAOS)
    call thistype.SUMMON_UNIT_TYPE[4].CollisionSize.Set(7.84)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\summonUnitType[4].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_summonUnitType[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_summonUnitType[1].j
static UnitType array SUMMON_UNIT_TYPE
    
    
static method Init_obj_summonUnitType1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\summonUnitType[1].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.Create('uDes')
    call thistype.SUMMON_UNIT_TYPE[1].Scale.Set(0.6)
    call thistype.SUMMON_UNIT_TYPE[1].Impact.Z.Set(36)
    call thistype.SUMMON_UNIT_TYPE[1].Outpact.Z.Set(21.6)
    call thistype.SUMMON_UNIT_TYPE[1].Speed.Set(270)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Set(0)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Type.Set(Attack.ARMOR_TYPE_HERO)
    call thistype.SUMMON_UNIT_TYPE[1].Life.Set(75)
    call thistype.SUMMON_UNIT_TYPE[1].Life.SetBJ(75)
    call thistype.SUMMON_UNIT_TYPE[1].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[1].SightRange.Set(1800)
    call thistype.SUMMON_UNIT_TYPE[1].SightRange.SetBJ(1800)
    call thistype.SUMMON_UNIT_TYPE[1].SpellPower.Set(15)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Set(Attack.HOMING_MISSILE)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Range.Set(500)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Speed.SetByCooldown(1.8)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Delay.Set(0.55)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Missile.Speed.Set(600)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Set(10)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.SetBJ(10)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Sides.Set(7)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Type.Set(Attack.DMG_TYPE_CHAOS)
    call thistype.SUMMON_UNIT_TYPE[1].CollisionSize.Set(5.76)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\summonUnitType[1].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_summonUnitType[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_summonUnitType[5].j

static method Init_obj_summonUnitType5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\summonUnitType[5].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[5] = UnitType.Create('uDe5')
    call thistype.SUMMON_UNIT_TYPE[5].Scale.Set(0.7)
    call thistype.SUMMON_UNIT_TYPE[5].Impact.Z.Set(49)
    call thistype.SUMMON_UNIT_TYPE[5].Outpact.Z.Set(29.4)
    call thistype.SUMMON_UNIT_TYPE[5].Speed.Set(270)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Set(0)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Type.Set(Attack.ARMOR_TYPE_HERO)
    call thistype.SUMMON_UNIT_TYPE[5].Life.Set(335)
    call thistype.SUMMON_UNIT_TYPE[5].Life.SetBJ(335)
    call thistype.SUMMON_UNIT_TYPE[5].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[5].SightRange.Set(1800)
    call thistype.SUMMON_UNIT_TYPE[5].SightRange.SetBJ(1800)
    call thistype.SUMMON_UNIT_TYPE[5].SpellPower.Set(55)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Set(Attack.HOMING_MISSILE)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Range.Set(500)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Speed.SetByCooldown(1.8)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Delay.Set(0.55)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Missile.Speed.Set(600)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Set(38)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.SetBJ(38)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Sides.Set(7)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Type.Set(Attack.DMG_TYPE_CHAOS)
    call thistype.SUMMON_UNIT_TYPE[5].CollisionSize.Set(7.84)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\summonUnitType[5].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon\obj_summonUnitType[5].j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType3)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType2)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType4)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType1)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType5)
endmethod