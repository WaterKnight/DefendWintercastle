//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BBar', "Strong", 'bBar')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFrostMourne.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer OFFSET = 260
static integer array SUMMONS_AMOUNT
static real MOVE_DURATION = 0.4
static real WINDOW_PER_SUMMON = 0.36 * Math.QUARTER_ANGLE
static string BARRIER_EFFECT_PATH = "Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl"
static real array DURATION
static integer CASTER_OFFSET = 150
static string BARRIER_EFFECT_ATTACH_POINT = "AttachPoint.OVERHEAD"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ABar')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Barrier")
    call thistype.THIS_SPELL.SetOrder(OrderId("summonfactory"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 8)
    call thistype.THIS_SPELL.SetManaCost(1, 20)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 8)
    call thistype.THIS_SPELL.SetManaCost(2, 30)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetCooldown(3, 8)
    call thistype.THIS_SPELL.SetManaCost(3, 40)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetCooldown(4, 8)
    call thistype.THIS_SPELL.SetManaCost(4, 50)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetCooldown(5, 8)
    call thistype.THIS_SPELL.SetManaCost(5, 60)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFrostMourne.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FBa0', 5, 'VBa0')
    
    set thistype.SUMMONS_AMOUNT[1] = 3
    set thistype.SUMMONS_AMOUNT[2] = 3
    set thistype.SUMMONS_AMOUNT[3] = 4
    set thistype.SUMMONS_AMOUNT[4] = 4
    set thistype.SUMMONS_AMOUNT[5] = 5
    set thistype.DURATION[1] = 3
    set thistype.DURATION[2] = 3.5
    set thistype.DURATION[3] = 4
    set thistype.DURATION[4] = 4.5
    set thistype.DURATION[5] = 5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_summonUnitType[3].j

static method Init_obj_summonUnitType3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[3].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[3] = UnitType.Create('uBa3')
    call thistype.SUMMON_UNIT_TYPE[3].Classes.Add(UnitClass.STRUCTURE)
    call thistype.SUMMON_UNIT_TYPE[3].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[3].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[3].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[3].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Set(7)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Type.Set(Attack.ARMOR_TYPE_FORT)
    call thistype.SUMMON_UNIT_TYPE[3].Life.Set(240)
    call thistype.SUMMON_UNIT_TYPE[3].Life.SetBJ(240)
    call thistype.SUMMON_UNIT_TYPE[3].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[3].SpellPower.Set(80)
    call thistype.SUMMON_UNIT_TYPE[3].CollisionSize.Set(40)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[3].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_summonUnitType[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_summonUnitType[5].j
static UnitType array SUMMON_UNIT_TYPE
    
    
static method Init_obj_summonUnitType5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[5].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[5] = UnitType.Create('uBa5')
    call thistype.SUMMON_UNIT_TYPE[5].Classes.Add(UnitClass.STRUCTURE)
    call thistype.SUMMON_UNIT_TYPE[5].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[5].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[5].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[5].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Set(9)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Type.Set(Attack.ARMOR_TYPE_FORT)
    call thistype.SUMMON_UNIT_TYPE[5].Life.Set(400)
    call thistype.SUMMON_UNIT_TYPE[5].Life.SetBJ(400)
    call thistype.SUMMON_UNIT_TYPE[5].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[5].SpellPower.Set(100)
    call thistype.SUMMON_UNIT_TYPE[5].CollisionSize.Set(40)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[5].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_summonUnitType[5].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_summonUnitType[4].j

static method Init_obj_summonUnitType4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[4].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[4] = UnitType.Create('uBa4')
    call thistype.SUMMON_UNIT_TYPE[4].Classes.Add(UnitClass.STRUCTURE)
    call thistype.SUMMON_UNIT_TYPE[4].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[4].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[4].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[4].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Set(8)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Type.Set(Attack.ARMOR_TYPE_FORT)
    call thistype.SUMMON_UNIT_TYPE[4].Life.Set(310)
    call thistype.SUMMON_UNIT_TYPE[4].Life.SetBJ(310)
    call thistype.SUMMON_UNIT_TYPE[4].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[4].SpellPower.Set(90)
    call thistype.SUMMON_UNIT_TYPE[4].CollisionSize.Set(40)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[4].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_summonUnitType[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_summonUnitType[1].j

static method Init_obj_summonUnitType1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[1].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.Create('uBar')
    call thistype.SUMMON_UNIT_TYPE[1].Classes.Add(UnitClass.STRUCTURE)
    call thistype.SUMMON_UNIT_TYPE[1].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[1].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[1].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[1].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[1].Speed.Set(1)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Set(5)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Type.Set(Attack.ARMOR_TYPE_FORT)
    call thistype.SUMMON_UNIT_TYPE[1].Life.Set(125)
    call thistype.SUMMON_UNIT_TYPE[1].Life.SetBJ(125)
    call thistype.SUMMON_UNIT_TYPE[1].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[1].SpellPower.Set(60)
    call thistype.SUMMON_UNIT_TYPE[1].CollisionSize.Set(40)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[1].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_summonUnitType[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_summonUnitType[2].j

static method Init_obj_summonUnitType2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[2].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[2] = UnitType.Create('uBa2')
    call thistype.SUMMON_UNIT_TYPE[2].Classes.Add(UnitClass.STRUCTURE)
    call thistype.SUMMON_UNIT_TYPE[2].Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE[2].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[2].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[2].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Set(6)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Type.Set(Attack.ARMOR_TYPE_FORT)
    call thistype.SUMMON_UNIT_TYPE[2].Life.Set(180)
    call thistype.SUMMON_UNIT_TYPE[2].Life.SetBJ(180)
    call thistype.SUMMON_UNIT_TYPE[2].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[2].SpellPower.Set(70)
    call thistype.SUMMON_UNIT_TYPE[2].CollisionSize.Set(40)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\summonUnitType[2].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.struct\obj_summonUnitType[2].j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType3)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType5)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType4)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType1)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType2)
endmethod