//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SpiritWolves.page\SpiritWolves.struct\obj_summonUnitType.j
static UnitType SUMMON_UNIT_TYPE
    
    
static method Init_obj_summonUnitType takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SpiritWolves.page\\SpiritWolves.struct\\summonUnitType.wc3unit")
    set thistype.SUMMON_UNIT_TYPE = UnitType.Create('uSpW')
    call thistype.SUMMON_UNIT_TYPE.Scale.Set(1.25)
    call thistype.SUMMON_UNIT_TYPE.Impact.Z.Set(77.479338842975)
    call thistype.SUMMON_UNIT_TYPE.Outpact.Z.Set(77.479338842975)
    call thistype.SUMMON_UNIT_TYPE.Armor.Set(0)
    call thistype.SUMMON_UNIT_TYPE.Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE.Life.Set(300)
    call thistype.SUMMON_UNIT_TYPE.Life.SetBJ(300)
    call thistype.SUMMON_UNIT_TYPE.LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE.SightRange.Set(1200)
    call thistype.SUMMON_UNIT_TYPE.SightRange.SetBJ(1200)
    call thistype.SUMMON_UNIT_TYPE.SpellPower.Set(45)
    call thistype.SUMMON_UNIT_TYPE.Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE.Attack.Range.Set(90)
    call thistype.SUMMON_UNIT_TYPE.Attack.Speed.SetByCooldown(1)
    call thistype.SUMMON_UNIT_TYPE.Damage.Delay.Set(0.33)
    call thistype.SUMMON_UNIT_TYPE.Damage.Set(15)
    call thistype.SUMMON_UNIT_TYPE.Damage.SetBJ(15)
    call thistype.SUMMON_UNIT_TYPE.Damage.Dices.Set(1)
    call thistype.SUMMON_UNIT_TYPE.Damage.Sides.Set(2)
    call thistype.SUMMON_UNIT_TYPE.Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE.CollisionSize.Set(41.322314049587)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SpiritWolves.page\\SpiritWolves.struct\\summonUnitType.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SpiritWolves.page\SpiritWolves.struct\obj_summonUnitType.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SpiritWolves.page\SpiritWolves.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer OFFSET = 70
static integer DURATION = 40
static integer SUMMON_AMOUNT = 2
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SpiritWolves.page\\SpiritWolves.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASpW')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Spirit Wolves")
    call thistype.THIS_SPELL.SetOrder(OrderId("spiritwolf"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 22)
    call thistype.THIS_SPELL.SetManaCost(1, 125)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSpiritWolf.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SpiritWolves.page\\SpiritWolves.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SpiritWolves.page\SpiritWolves.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod