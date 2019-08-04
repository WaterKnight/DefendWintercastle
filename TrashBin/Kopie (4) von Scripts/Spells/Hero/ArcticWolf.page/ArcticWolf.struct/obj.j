//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\ArcticWolf.struct\obj_summonUnitType[2].j

static method Init_obj_summonUnitType2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\summonUnitType[2].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[2] = UnitType.Create('uAW2')
    call thistype.SUMMON_UNIT_TYPE[2].Scale.Set(1.375)
    call thistype.SUMMON_UNIT_TYPE[2].VertexColor.Set(150, 120, 255, 255)
    call thistype.SUMMON_UNIT_TYPE[2].Impact.Z.Set(113.4375)
    call thistype.SUMMON_UNIT_TYPE[2].Outpact.Z.Set(113.4375)
    call thistype.SUMMON_UNIT_TYPE[2].Attachments.Add("Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", AttachPoint.HAND_LEFT, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[2].Attachments.Add("Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", AttachPoint.HAND_RIGHT, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[2].Attachments.Add("Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", AttachPoint.FOOT_LEFT, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[2].Attachments.Add("Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", AttachPoint.FOOT_RIGHT, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[2].Speed.Set(320)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Set(2)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[2].Life.Set(750)
    call thistype.SUMMON_UNIT_TYPE[2].Life.SetBJ(750)
    call thistype.SUMMON_UNIT_TYPE[2].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[2].Mana.Set(300)
    call thistype.SUMMON_UNIT_TYPE[2].Mana.SetBJ(300)
    call thistype.SUMMON_UNIT_TYPE[2].ManaRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[2].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[2].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[2].SpellPower.Set(80)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Range.Set(90)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Speed.SetByCooldown(1.35)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Delay.Set(0.33)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Set(48)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.SetBJ(48)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Sides.Set(11)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[2].CollisionSize.Set(62.390625)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\summonUnitType[2].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\ArcticWolf.struct\obj_summonUnitType[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\ArcticWolf.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qArW'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\ArcticWolf.struct\obj_dummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\ArcticWolf.struct\obj_this.j
static integer array SUMMON_DURATION
static integer SPEED = 400
static integer START_OFFSET = 90
static integer HEIGHT = 50
static string DUMMY_UNIT_EFFECT_PATH = "Spells\\ArcticWolf\\IceVortex.mdl"
static real DUMMY_UNIT_FADE_OUT = 0.5
static integer array STUN_DURATION
static string DUMMY_UNIT_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\this.wc3obj")
    set thistype.SUMMON_DURATION[1] = 60
    set thistype.SUMMON_DURATION[2] = 60
    set thistype.SUMMON_DURATION[3] = 60
    set thistype.SUMMON_DURATION[4] = 60
    set thistype.SUMMON_DURATION[5] = 60
    set thistype.STUN_DURATION[1] = 3
    set thistype.STUN_DURATION[2] = 4
    set thistype.STUN_DURATION[3] = 5
    set thistype.STUN_DURATION[4] = 5
    set thistype.STUN_DURATION[5] = 5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\ArcticWolf.struct\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\ArcticWolf.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AArw')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE)
    call thistype.THIS_SPELL.SetLevelsAmount(3)
    call thistype.THIS_SPELL.SetName("Arctic Wolf")
    call thistype.THIS_SPELL.SetOrder(OrderId("spiritwolf"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 300)
    call thistype.THIS_SPELL.SetCooldown(1, 60)
    call thistype.THIS_SPELL.SetManaCost(1, 150)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetAreaRange(2, 300)
    call thistype.THIS_SPELL.SetCooldown(2, 60)
    call thistype.THIS_SPELL.SetManaCost(2, 150)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetAreaRange(3, 300)
    call thistype.THIS_SPELL.SetCooldown(3, 60)
    call thistype.THIS_SPELL.SetManaCost(3, 150)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNWolf.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FAW0', 3, 'VAW0')
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\ArcticWolf.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\ArcticWolf.struct\obj_summonUnitType[1].j
static UnitType array SUMMON_UNIT_TYPE
    
    
static method Init_obj_summonUnitType1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\summonUnitType[1].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.Create('uArW')
    call thistype.SUMMON_UNIT_TYPE[1].Scale.Set(1.25)
    call thistype.SUMMON_UNIT_TYPE[1].VertexColor.Set(150, 120, 255, 200)
    call thistype.SUMMON_UNIT_TYPE[1].Impact.Z.Set(93.75)
    call thistype.SUMMON_UNIT_TYPE[1].Outpact.Z.Set(93.75)
    call thistype.SUMMON_UNIT_TYPE[1].Attachments.Add("Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", AttachPoint.HAND_LEFT, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[1].Attachments.Add("Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", AttachPoint.HAND_RIGHT, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[1].Attachments.Add("Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", AttachPoint.FOOT_LEFT, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[1].Attachments.Add("Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", AttachPoint.FOOT_RIGHT, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[1].Speed.Set(320)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Set(2)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[1].Life.Set(750)
    call thistype.SUMMON_UNIT_TYPE[1].Life.SetBJ(750)
    call thistype.SUMMON_UNIT_TYPE[1].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[1].Mana.Set(300)
    call thistype.SUMMON_UNIT_TYPE[1].Mana.SetBJ(300)
    call thistype.SUMMON_UNIT_TYPE[1].ManaRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[1].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[1].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[1].SpellPower.Set(50)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Range.Set(90)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Speed.SetByCooldown(1.35)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Delay.Set(0.33)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Set(30)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.SetBJ(30)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Sides.Set(9)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[1].CollisionSize.Set(51.5625)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\summonUnitType[1].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\ArcticWolf.struct\obj_summonUnitType[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\ArcticWolf.struct\obj_summonUnitType[3].j

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
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\ArcticWolf.struct\obj_summonUnitType[3].j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType2)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType1)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType3)
endmethod