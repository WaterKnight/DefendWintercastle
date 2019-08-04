//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon\obj_this.j
static integer OFFSET = 75
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\this.wc3obj")
    set thistype.DURATION[1] = 25
    set thistype.DURATION[2] = 25
    set thistype.DURATION[3] = 25
    set thistype.DURATION[4] = 25
    set thistype.DURATION[5] = 25
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon\obj_thisUnitTypes[3].j

static method Init_obj_thisUnitTypes3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\thisUnitTypes[3].wc3unit")
    set thistype.THIS_UNIT_TYPES[3] = UnitType.Create('uWB3')
    call thistype.THIS_UNIT_TYPES[3].Scale.Set(0.9)
    call thistype.THIS_UNIT_TYPES[3].Impact.Z.Set(120)
    call thistype.THIS_UNIT_TYPES[3].Outpact.Z.Set(60)
    call thistype.THIS_UNIT_TYPES[3].Speed.Set(230)
    call thistype.THIS_UNIT_TYPES[3].Armor.Set(2)
    call thistype.THIS_UNIT_TYPES[3].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.THIS_UNIT_TYPES[3].Life.Set(550)
    call thistype.THIS_UNIT_TYPES[3].Life.SetBJ(550)
    call thistype.THIS_UNIT_TYPES[3].LifeRegeneration.Set(0)
    call thistype.THIS_UNIT_TYPES[3].SightRange.Set(1400)
    call thistype.THIS_UNIT_TYPES[3].SightRange.SetBJ(1400)
    call thistype.THIS_UNIT_TYPES[3].SpellPower.Set(30)
    call thistype.THIS_UNIT_TYPES[3].Attack.Set(Attack.MISSILE)
    call thistype.THIS_UNIT_TYPES[3].Attack.Range.Set(600)
    call thistype.THIS_UNIT_TYPES[3].Attack.Speed.SetByCooldown(1.6)
    call thistype.THIS_UNIT_TYPES[3].Damage.Delay.Set(0.4)
    call thistype.THIS_UNIT_TYPES[3].Attack.Missile.Speed.Set(1300)
    call thistype.THIS_UNIT_TYPES[3].Damage.Set(22)
    call thistype.THIS_UNIT_TYPES[3].Damage.SetBJ(22)
    call thistype.THIS_UNIT_TYPES[3].Damage.Dices.Set(3)
    call thistype.THIS_UNIT_TYPES[3].Damage.Sides.Set(3)
    call thistype.THIS_UNIT_TYPES[3].Damage.Type.Set(Attack.DMG_TYPE_PIERCE)
    call thistype.THIS_UNIT_TYPES[3].CollisionSize.Set(32)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\thisUnitTypes[3].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon\obj_thisUnitTypes[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon\obj_thisUnitTypes[2].j

static method Init_obj_thisUnitTypes2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\thisUnitTypes[2].wc3unit")
    set thistype.THIS_UNIT_TYPES[2] = UnitType.Create('uWB2')
    call thistype.THIS_UNIT_TYPES[2].Scale.Set(0.9)
    call thistype.THIS_UNIT_TYPES[2].Impact.Z.Set(120)
    call thistype.THIS_UNIT_TYPES[2].Outpact.Z.Set(60)
    call thistype.THIS_UNIT_TYPES[2].Speed.Set(230)
    call thistype.THIS_UNIT_TYPES[2].Armor.Set(1)
    call thistype.THIS_UNIT_TYPES[2].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.THIS_UNIT_TYPES[2].Life.Set(425)
    call thistype.THIS_UNIT_TYPES[2].Life.SetBJ(425)
    call thistype.THIS_UNIT_TYPES[2].LifeRegeneration.Set(0)
    call thistype.THIS_UNIT_TYPES[2].SightRange.Set(1400)
    call thistype.THIS_UNIT_TYPES[2].SightRange.SetBJ(1400)
    call thistype.THIS_UNIT_TYPES[2].SpellPower.Set(30)
    call thistype.THIS_UNIT_TYPES[2].Attack.Set(Attack.MISSILE)
    call thistype.THIS_UNIT_TYPES[2].Attack.Range.Set(600)
    call thistype.THIS_UNIT_TYPES[2].Attack.Speed.SetByCooldown(1.6)
    call thistype.THIS_UNIT_TYPES[2].Damage.Delay.Set(0.4)
    call thistype.THIS_UNIT_TYPES[2].Attack.Missile.Speed.Set(1300)
    call thistype.THIS_UNIT_TYPES[2].Damage.Set(18)
    call thistype.THIS_UNIT_TYPES[2].Damage.SetBJ(18)
    call thistype.THIS_UNIT_TYPES[2].Damage.Dices.Set(2)
    call thistype.THIS_UNIT_TYPES[2].Damage.Sides.Set(3)
    call thistype.THIS_UNIT_TYPES[2].Damage.Type.Set(Attack.DMG_TYPE_PIERCE)
    call thistype.THIS_UNIT_TYPES[2].CollisionSize.Set(32)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\thisUnitTypes[2].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon\obj_thisUnitTypes[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon\obj_thisUnitTypes[1].j

static method Init_obj_thisUnitTypes1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\thisUnitTypes[1].wc3unit")
    set thistype.THIS_UNIT_TYPES[1] = UnitType.Create('uWB1')
    call thistype.THIS_UNIT_TYPES[1].Scale.Set(0.9)
    call thistype.THIS_UNIT_TYPES[1].Impact.Z.Set(120)
    call thistype.THIS_UNIT_TYPES[1].Outpact.Z.Set(60)
    call thistype.THIS_UNIT_TYPES[1].Speed.Set(230)
    call thistype.THIS_UNIT_TYPES[1].Armor.Set(1)
    call thistype.THIS_UNIT_TYPES[1].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.THIS_UNIT_TYPES[1].Life.Set(300)
    call thistype.THIS_UNIT_TYPES[1].Life.SetBJ(300)
    call thistype.THIS_UNIT_TYPES[1].LifeRegeneration.Set(0)
    call thistype.THIS_UNIT_TYPES[1].SightRange.Set(1400)
    call thistype.THIS_UNIT_TYPES[1].SightRange.SetBJ(1400)
    call thistype.THIS_UNIT_TYPES[1].SpellPower.Set(30)
    call thistype.THIS_UNIT_TYPES[1].Attack.Set(Attack.MISSILE)
    call thistype.THIS_UNIT_TYPES[1].Attack.Range.Set(600)
    call thistype.THIS_UNIT_TYPES[1].Attack.Speed.SetByCooldown(1.6)
    call thistype.THIS_UNIT_TYPES[1].Damage.Delay.Set(0.4)
    call thistype.THIS_UNIT_TYPES[1].Attack.Missile.Speed.Set(1300)
    call thistype.THIS_UNIT_TYPES[1].Damage.Set(14)
    call thistype.THIS_UNIT_TYPES[1].Damage.SetBJ(14)
    call thistype.THIS_UNIT_TYPES[1].Damage.Dices.Set(2)
    call thistype.THIS_UNIT_TYPES[1].Damage.Sides.Set(3)
    call thistype.THIS_UNIT_TYPES[1].Damage.Type.Set(Attack.DMG_TYPE_PIERCE)
    call thistype.THIS_UNIT_TYPES[1].CollisionSize.Set(32)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\thisUnitTypes[1].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon\obj_thisUnitTypes[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon\obj_thisUnitTypes[4].j

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
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon\obj_thisUnitTypes[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon\obj_thisUnitTypes[5].j
static UnitType array THIS_UNIT_TYPES
    
    
static method Init_obj_thisUnitTypes5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\thisUnitTypes[5].wc3unit")
    set thistype.THIS_UNIT_TYPES[5] = UnitType.Create('uWB5')
    call thistype.THIS_UNIT_TYPES[5].Scale.Set(0.9)
    call thistype.THIS_UNIT_TYPES[5].Impact.Z.Set(120)
    call thistype.THIS_UNIT_TYPES[5].Outpact.Z.Set(60)
    call thistype.THIS_UNIT_TYPES[5].Speed.Set(230)
    call thistype.THIS_UNIT_TYPES[5].Armor.Set(3)
    call thistype.THIS_UNIT_TYPES[5].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.THIS_UNIT_TYPES[5].Life.Set(800)
    call thistype.THIS_UNIT_TYPES[5].Life.SetBJ(800)
    call thistype.THIS_UNIT_TYPES[5].LifeRegeneration.Set(0)
    call thistype.THIS_UNIT_TYPES[5].SightRange.Set(1400)
    call thistype.THIS_UNIT_TYPES[5].SightRange.SetBJ(1400)
    call thistype.THIS_UNIT_TYPES[5].SpellPower.Set(30)
    call thistype.THIS_UNIT_TYPES[5].Attack.Set(Attack.MISSILE)
    call thistype.THIS_UNIT_TYPES[5].Attack.Range.Set(600)
    call thistype.THIS_UNIT_TYPES[5].Attack.Speed.SetByCooldown(1.6)
    call thistype.THIS_UNIT_TYPES[5].Damage.Delay.Set(0.4)
    call thistype.THIS_UNIT_TYPES[5].Attack.Missile.Speed.Set(1300)
    call thistype.THIS_UNIT_TYPES[5].Damage.Set(30)
    call thistype.THIS_UNIT_TYPES[5].Damage.SetBJ(30)
    call thistype.THIS_UNIT_TYPES[5].Damage.Dices.Set(3)
    call thistype.THIS_UNIT_TYPES[5].Damage.Sides.Set(4)
    call thistype.THIS_UNIT_TYPES[5].Damage.Type.Set(Attack.DMG_TYPE_PIERCE)
    call thistype.THIS_UNIT_TYPES[5].CollisionSize.Set(32)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\thisUnitTypes[5].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon\obj_thisUnitTypes[5].j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call UnitType.AddInit(function thistype.Init_obj_thisUnitTypes3)
    call UnitType.AddInit(function thistype.Init_obj_thisUnitTypes2)
    call UnitType.AddInit(function thistype.Init_obj_thisUnitTypes1)
    call UnitType.AddInit(function thistype.Init_obj_thisUnitTypes4)
    call UnitType.AddInit(function thistype.Init_obj_thisUnitTypes5)
endmethod