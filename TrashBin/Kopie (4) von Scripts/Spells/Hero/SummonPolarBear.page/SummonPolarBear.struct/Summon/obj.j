//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_this.j
static integer REMAINING_LIFE_MIN_FACTOR = 0
static integer array DURATION
static real array INVULNERABILITY_DURATION
static real HEAL_FACTOR = 0.5
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\this.wc3obj")
    set thistype.DURATION[1] = 30
    set thistype.DURATION[2] = 30
    set thistype.DURATION[3] = 30
    set thistype.DURATION[4] = 30
    set thistype.DURATION[5] = 30
    set thistype.INVULNERABILITY_DURATION[1] = 1.5
    set thistype.INVULNERABILITY_DURATION[2] = 1.5
    set thistype.INVULNERABILITY_DURATION[3] = 1.5
    set thistype.INVULNERABILITY_DURATION[4] = 1.5
    set thistype.INVULNERABILITY_DURATION[5] = 1.5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_summonUnitType[5].j

static method Init_obj_summonUnitType5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[5].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[5] = UnitType.Create('uPB5')
    call thistype.SUMMON_UNIT_TYPE[5].Scale.Set(1.45)
    call thistype.SUMMON_UNIT_TYPE[5].Impact.Z.Set(126.15)
    call thistype.SUMMON_UNIT_TYPE[5].Outpact.Z.Set(126.15)
    call thistype.SUMMON_UNIT_TYPE[5].Speed.Set(270)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Set(6)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[5].Life.Set(900)
    call thistype.SUMMON_UNIT_TYPE[5].Life.SetBJ(900)
    call thistype.SUMMON_UNIT_TYPE[5].LifeRegeneration.Set(2.5)
    call thistype.SUMMON_UNIT_TYPE[5].Mana.Set(160)
    call thistype.SUMMON_UNIT_TYPE[5].Mana.SetBJ(160)
    call thistype.SUMMON_UNIT_TYPE[5].ManaRegeneration.Set(1.5)
    call thistype.SUMMON_UNIT_TYPE[5].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[5].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[5].SpellPower.Set(85)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Speed.SetByCooldown(1.35)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Delay.Set(0.63)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Set(27)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.SetBJ(27)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Dices.Set(4)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Sides.Set(4)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[5].CollisionSize.Set(100.92)
    call thistype.SUMMON_UNIT_TYPE[5].Abilities.AddWithLevel(ArcticBlink(NULL).THIS_SPELL, 3)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[5].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_summonUnitType[5].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_summonUnitType[3].j

static method Init_obj_summonUnitType3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[3].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[3] = UnitType.Create('uPB3')
    call thistype.SUMMON_UNIT_TYPE[3].Scale.Set(1.25)
    call thistype.SUMMON_UNIT_TYPE[3].Impact.Z.Set(93.75)
    call thistype.SUMMON_UNIT_TYPE[3].Outpact.Z.Set(93.75)
    call thistype.SUMMON_UNIT_TYPE[3].Speed.Set(270)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Set(4)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[3].Life.Set(620)
    call thistype.SUMMON_UNIT_TYPE[3].Life.SetBJ(620)
    call thistype.SUMMON_UNIT_TYPE[3].LifeRegeneration.Set(2.5)
    call thistype.SUMMON_UNIT_TYPE[3].Mana.Set(120)
    call thistype.SUMMON_UNIT_TYPE[3].Mana.SetBJ(120)
    call thistype.SUMMON_UNIT_TYPE[3].ManaRegeneration.Set(1)
    call thistype.SUMMON_UNIT_TYPE[3].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[3].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[3].SpellPower.Set(65)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Speed.SetByCooldown(1.35)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Delay.Set(0.63)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Set(24)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.SetBJ(24)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Sides.Set(4)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[3].CollisionSize.Set(75)
    call thistype.SUMMON_UNIT_TYPE[3].Abilities.Add(ArcticBlink(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[3].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_summonUnitType[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_summonUnitType[4].j

static method Init_obj_summonUnitType4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[4].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[4] = UnitType.Create('uPB4')
    call thistype.SUMMON_UNIT_TYPE[4].Scale.Set(1.35)
    call thistype.SUMMON_UNIT_TYPE[4].Impact.Z.Set(109.35)
    call thistype.SUMMON_UNIT_TYPE[4].Outpact.Z.Set(109.35)
    call thistype.SUMMON_UNIT_TYPE[4].Speed.Set(270)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Set(5)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[4].Life.Set(750)
    call thistype.SUMMON_UNIT_TYPE[4].Life.SetBJ(750)
    call thistype.SUMMON_UNIT_TYPE[4].LifeRegeneration.Set(2.5)
    call thistype.SUMMON_UNIT_TYPE[4].Mana.Set(140)
    call thistype.SUMMON_UNIT_TYPE[4].Mana.SetBJ(140)
    call thistype.SUMMON_UNIT_TYPE[4].ManaRegeneration.Set(1.25)
    call thistype.SUMMON_UNIT_TYPE[4].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[4].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[4].SpellPower.Set(75)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Speed.SetByCooldown(1.35)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Delay.Set(0.63)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Set(26)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.SetBJ(26)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Dices.Set(3)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Sides.Set(4)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[4].CollisionSize.Set(87.48)
    call thistype.SUMMON_UNIT_TYPE[4].Abilities.AddWithLevel(ArcticBlink(NULL).THIS_SPELL, 2)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[4].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_summonUnitType[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_summonUnitType[2].j

static method Init_obj_summonUnitType2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[2].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[2] = UnitType.Create('uPB2')
    call thistype.SUMMON_UNIT_TYPE[2].Scale.Set(1.15)
    call thistype.SUMMON_UNIT_TYPE[2].Impact.Z.Set(79.35)
    call thistype.SUMMON_UNIT_TYPE[2].Outpact.Z.Set(79.35)
    call thistype.SUMMON_UNIT_TYPE[2].Speed.Set(270)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Set(3)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[2].Life.Set(500)
    call thistype.SUMMON_UNIT_TYPE[2].Life.SetBJ(500)
    call thistype.SUMMON_UNIT_TYPE[2].LifeRegeneration.Set(2)
    call thistype.SUMMON_UNIT_TYPE[2].Mana.Set(100)
    call thistype.SUMMON_UNIT_TYPE[2].Mana.SetBJ(100)
    call thistype.SUMMON_UNIT_TYPE[2].ManaRegeneration.Set(0.75)
    call thistype.SUMMON_UNIT_TYPE[2].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[2].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[2].SpellPower.Set(55)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Speed.SetByCooldown(1.35)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Delay.Set(0.63)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Set(18)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.SetBJ(18)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Dices.Set(1)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Sides.Set(6)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[2].CollisionSize.Set(63.48)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[2].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_summonUnitType[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_summonUnitType[1].j
static UnitType array SUMMON_UNIT_TYPE
    
    
static method Init_obj_summonUnitType1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[1].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.Create('uPoB')
    call thistype.SUMMON_UNIT_TYPE[1].Scale.Set(0.95)
    call thistype.SUMMON_UNIT_TYPE[1].Impact.Z.Set(54.15)
    call thistype.SUMMON_UNIT_TYPE[1].Outpact.Z.Set(54.15)
    call thistype.SUMMON_UNIT_TYPE[1].Speed.Set(270)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Set(2)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE[1].Life.Set(400)
    call thistype.SUMMON_UNIT_TYPE[1].Life.SetBJ(400)
    call thistype.SUMMON_UNIT_TYPE[1].LifeRegeneration.Set(1.5)
    call thistype.SUMMON_UNIT_TYPE[1].Mana.Set(80)
    call thistype.SUMMON_UNIT_TYPE[1].Mana.SetBJ(80)
    call thistype.SUMMON_UNIT_TYPE[1].ManaRegeneration.Set(0.5)
    call thistype.SUMMON_UNIT_TYPE[1].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[1].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[1].SpellPower.Set(45)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Speed.SetByCooldown(1.35)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Delay.Set(0.63)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Set(14)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.SetBJ(14)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Dices.Set(1)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Sides.Set(5)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[1].CollisionSize.Set(43.32)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\summonUnitType[1].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_summonUnitType[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_tauntSpell.j
static Spell TAUNT_SPELL
    
static string LEARN_RAW
static string LEARN_BUTTON_POS_Y
static string LEARN_HOTKEY
static string LEARN_BUTTON_POS_X
static string LEARN_ICON
static string LEARN_TOOLTIP
static string LEARN_UBER_TOOLTIP
    
static method Init_obj_tauntSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\tauntSpell.wc3spell")
    set thistype.TAUNT_SPELL = Spell.CreateFromSelf('ATau')
    
    call thistype.TAUNT_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.TAUNT_SPELL.SetLevelsAmount(1)
    call thistype.TAUNT_SPELL.SetName("Taunt")
    call thistype.TAUNT_SPELL.SetAnimation("spell")
    call thistype.TAUNT_SPELL.SetAreaRange(1, 450)
    call thistype.TAUNT_SPELL.SetRange(1, 750)
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\tauntSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\obj_tauntSpell.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType5)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType3)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType4)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType2)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType1)
    call Spell.AddInit(function thistype.Init_obj_tauntSpell)
endmethod