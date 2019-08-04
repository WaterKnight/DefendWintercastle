//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string SUMMON_EFFECT_PATH = "Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl"
static integer array MAX_TARGETS_AMOUNT
static real INTERVAL = 0.05
static integer array DURATION
static string SPECIAL_EFFECT_PATH = "Abilities\\Weapons\\TreantMissile\\TreantMissile.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AHoN')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_SECOND)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Hand of Nature")
    call thistype.THIS_SPELL.SetOrder(OrderId("entanglingroots"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 250)
    call thistype.THIS_SPELL.SetCooldown(1, 8)
    call thistype.THIS_SPELL.SetManaCost(1, 65)
    call thistype.THIS_SPELL.SetRange(1, 650)
    call thistype.THIS_SPELL.SetAreaRange(2, 250)
    call thistype.THIS_SPELL.SetCooldown(2, 8)
    call thistype.THIS_SPELL.SetManaCost(2, 75)
    call thistype.THIS_SPELL.SetRange(2, 650)
    call thistype.THIS_SPELL.SetAreaRange(3, 250)
    call thistype.THIS_SPELL.SetCooldown(3, 8)
    call thistype.THIS_SPELL.SetManaCost(3, 85)
    call thistype.THIS_SPELL.SetRange(3, 650)
    call thistype.THIS_SPELL.SetAreaRange(4, 250)
    call thistype.THIS_SPELL.SetCooldown(4, 8)
    call thistype.THIS_SPELL.SetManaCost(4, 95)
    call thistype.THIS_SPELL.SetRange(4, 650)
    call thistype.THIS_SPELL.SetAreaRange(5, 250)
    call thistype.THIS_SPELL.SetCooldown(5, 8)
    call thistype.THIS_SPELL.SetManaCost(5, 105)
    call thistype.THIS_SPELL.SetRange(5, 650)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNEntanglingRoots.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FHN0', 5, 'VHN0')
    
    set thistype.MAX_TARGETS_AMOUNT[1] = 2
    set thistype.MAX_TARGETS_AMOUNT[2] = 2
    set thistype.MAX_TARGETS_AMOUNT[3] = 2
    set thistype.MAX_TARGETS_AMOUNT[4] = 2
    set thistype.MAX_TARGETS_AMOUNT[5] = 2
    set thistype.DURATION[1] = 40
    set thistype.DURATION[2] = 40
    set thistype.DURATION[3] = 40
    set thistype.DURATION[4] = 40
    set thistype.DURATION[5] = 40
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\obj_summonUnitType[5].j

static method Init_obj_summonUnitType5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\summonUnitType[5].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[5] = UnitType.Create('uCL5')
    call thistype.SUMMON_UNIT_TYPE[5].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[5].Scale.Set(0.9)
    call thistype.SUMMON_UNIT_TYPE[5].VertexColor.Set(0, 255, 0, 255)
    call thistype.SUMMON_UNIT_TYPE[5].Impact.Z.Set(81)
    call thistype.SUMMON_UNIT_TYPE[5].Outpact.Z.Set(182.25)
    call thistype.SUMMON_UNIT_TYPE[5].Attachments.Add("Units\\CobraLily\\LightingOrb.mdx", AttachPoint.HEAD, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Set(2)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[5].Life.Set(450)
    call thistype.SUMMON_UNIT_TYPE[5].Life.SetBJ(450)
    call thistype.SUMMON_UNIT_TYPE[5].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[5].SightRange.Set(1200)
    call thistype.SUMMON_UNIT_TYPE[5].SightRange.SetBJ(1200)
    call thistype.SUMMON_UNIT_TYPE[5].SpellPower.Set(15)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Set(Attack.HOMING_MISSILE)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Range.Set(500)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Speed.SetByCooldown(1.25)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Delay.Set(0.4)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Missile.Speed.Set(600)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Set(32)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.SetBJ(32)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Dices.Set(3)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Sides.Set(4)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Type.Set(Attack.DMG_TYPE_PIERCE)
    call thistype.SUMMON_UNIT_TYPE[5].CollisionSize.Set(12.96)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\summonUnitType[5].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\obj_summonUnitType[5].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\obj_summonUnitType[1].j

static method Init_obj_summonUnitType1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\summonUnitType[1].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.Create('uCoL')
    call thistype.SUMMON_UNIT_TYPE[1].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[1].Scale.Set(0.7)
    call thistype.SUMMON_UNIT_TYPE[1].VertexColor.Set(0, 255, 0, 255)
    call thistype.SUMMON_UNIT_TYPE[1].Impact.Z.Set(49)
    call thistype.SUMMON_UNIT_TYPE[1].Outpact.Z.Set(110.25)
    call thistype.SUMMON_UNIT_TYPE[1].Attachments.Add("Units\\CobraLily\\LightingOrb.mdx", AttachPoint.HEAD, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Set(0)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[1].Life.Set(150)
    call thistype.SUMMON_UNIT_TYPE[1].Life.SetBJ(150)
    call thistype.SUMMON_UNIT_TYPE[1].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[1].SightRange.Set(1200)
    call thistype.SUMMON_UNIT_TYPE[1].SightRange.SetBJ(1200)
    call thistype.SUMMON_UNIT_TYPE[1].SpellPower.Set(15)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Set(Attack.HOMING_MISSILE)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Range.Set(500)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Speed.SetByCooldown(1.25)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Delay.Set(0.4)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Missile.Speed.Set(600)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Set(12)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.SetBJ(12)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Dices.Set(1)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Sides.Set(3)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Type.Set(Attack.DMG_TYPE_PIERCE)
    call thistype.SUMMON_UNIT_TYPE[1].CollisionSize.Set(7.84)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\summonUnitType[1].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\obj_summonUnitType[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\obj_summonUnitType[4].j

static method Init_obj_summonUnitType4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\summonUnitType[4].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[4] = UnitType.Create('uCL4')
    call thistype.SUMMON_UNIT_TYPE[4].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[4].Scale.Set(0.85)
    call thistype.SUMMON_UNIT_TYPE[4].VertexColor.Set(0, 255, 0, 255)
    call thistype.SUMMON_UNIT_TYPE[4].Impact.Z.Set(72.25)
    call thistype.SUMMON_UNIT_TYPE[4].Outpact.Z.Set(162.5625)
    call thistype.SUMMON_UNIT_TYPE[4].Attachments.Add("Units\\CobraLily\\LightingOrb.mdx", AttachPoint.HEAD, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Set(2)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[4].Life.Set(375)
    call thistype.SUMMON_UNIT_TYPE[4].Life.SetBJ(375)
    call thistype.SUMMON_UNIT_TYPE[4].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[4].SightRange.Set(1200)
    call thistype.SUMMON_UNIT_TYPE[4].SightRange.SetBJ(1200)
    call thistype.SUMMON_UNIT_TYPE[4].SpellPower.Set(15)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Set(Attack.HOMING_MISSILE)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Range.Set(500)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Speed.SetByCooldown(1.25)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Delay.Set(0.4)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Missile.Speed.Set(600)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Set(26)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.SetBJ(26)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Dices.Set(3)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Sides.Set(3)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Type.Set(Attack.DMG_TYPE_PIERCE)
    call thistype.SUMMON_UNIT_TYPE[4].CollisionSize.Set(11.56)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\summonUnitType[4].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\obj_summonUnitType[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\obj_summonUnitType[2].j
static UnitType array SUMMON_UNIT_TYPE
    
    
static method Init_obj_summonUnitType2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\summonUnitType[2].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[2] = UnitType.Create('uCL2')
    call thistype.SUMMON_UNIT_TYPE[2].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[2].Scale.Set(0.75)
    call thistype.SUMMON_UNIT_TYPE[2].VertexColor.Set(0, 255, 0, 255)
    call thistype.SUMMON_UNIT_TYPE[2].Impact.Z.Set(56.25)
    call thistype.SUMMON_UNIT_TYPE[2].Outpact.Z.Set(126.5625)
    call thistype.SUMMON_UNIT_TYPE[2].Attachments.Add("Units\\CobraLily\\LightingOrb.mdx", AttachPoint.HEAD, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Set(1)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[2].Life.Set(225)
    call thistype.SUMMON_UNIT_TYPE[2].Life.SetBJ(225)
    call thistype.SUMMON_UNIT_TYPE[2].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[2].SightRange.Set(1200)
    call thistype.SUMMON_UNIT_TYPE[2].SightRange.SetBJ(1200)
    call thistype.SUMMON_UNIT_TYPE[2].SpellPower.Set(15)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Set(Attack.HOMING_MISSILE)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Range.Set(500)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Speed.SetByCooldown(1.25)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Delay.Set(0.4)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Missile.Speed.Set(600)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Set(16)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.SetBJ(16)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Sides.Set(2)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Type.Set(Attack.DMG_TYPE_PIERCE)
    call thistype.SUMMON_UNIT_TYPE[2].CollisionSize.Set(9)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\summonUnitType[2].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\obj_summonUnitType[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\obj_summonUnitType[3].j

static method Init_obj_summonUnitType3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\summonUnitType[3].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[3] = UnitType.Create('uCL3')
    call thistype.SUMMON_UNIT_TYPE[3].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[3].Scale.Set(0.8)
    call thistype.SUMMON_UNIT_TYPE[3].VertexColor.Set(0, 255, 0, 255)
    call thistype.SUMMON_UNIT_TYPE[3].Impact.Z.Set(64)
    call thistype.SUMMON_UNIT_TYPE[3].Outpact.Z.Set(144)
    call thistype.SUMMON_UNIT_TYPE[3].Attachments.Add("Units\\CobraLily\\LightingOrb.mdx", AttachPoint.HEAD, EffectLevel.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Set(1)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[3].Life.Set(300)
    call thistype.SUMMON_UNIT_TYPE[3].Life.SetBJ(300)
    call thistype.SUMMON_UNIT_TYPE[3].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[3].SightRange.Set(1200)
    call thistype.SUMMON_UNIT_TYPE[3].SightRange.SetBJ(1200)
    call thistype.SUMMON_UNIT_TYPE[3].SpellPower.Set(15)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Set(Attack.HOMING_MISSILE)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Range.Set(500)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Speed.SetByCooldown(1.25)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Delay.Set(0.4)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Missile.Speed.Set(600)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Set(21)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.SetBJ(21)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Sides.Set(3)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Type.Set(Attack.DMG_TYPE_PIERCE)
    call thistype.SUMMON_UNIT_TYPE[3].CollisionSize.Set(10.24)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\summonUnitType[3].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\obj_summonUnitType[3].j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType5)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType1)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType4)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType2)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType3)
endmethod