//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SerpentWard.page\SerpentWard.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qSeW'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SerpentWard.page\\SerpentWard.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SerpentWard.page\\SerpentWard.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SerpentWard.page\SerpentWard.struct\obj_dummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SerpentWard.page\SerpentWard.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer SUMMON_AMOUNT = 3
static integer DURATION = 20
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SerpentWard.page\\SerpentWard.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASeW')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Serpent Ward")
    call thistype.THIS_SPELL.SetOrder(OrderId("ward"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 15)
    call thistype.THIS_SPELL.SetManaCost(1, 55)
    call thistype.THIS_SPELL.SetRange(1, 550)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSerpentWard.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SerpentWard.page\\SerpentWard.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SerpentWard.page\SerpentWard.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SerpentWard.page\SerpentWard.struct\obj_summonUnitType.j
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
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SerpentWard.page\SerpentWard.struct\obj_summonUnitType.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType)
endmethod