//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\EyeOfTheFlame.page\EyeOfTheFlame.struct\obj_summonUnitType.j
static UnitType SUMMON_UNIT_TYPE
    
    
static method Init_obj_summonUnitType takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EyeOfTheFlame.page\\EyeOfTheFlame.struct\\summonUnitType.wc3unit")
    set thistype.SUMMON_UNIT_TYPE = UnitType.Create('uEoF')
    call thistype.SUMMON_UNIT_TYPE.Classes.Add(UnitClass.WARD)
    call thistype.SUMMON_UNIT_TYPE.Scale.Set(1.25)
    call thistype.SUMMON_UNIT_TYPE.Impact.Z.Set(93.75)
    call thistype.SUMMON_UNIT_TYPE.Outpact.Z.Set(351.5625)
    call thistype.SUMMON_UNIT_TYPE.Armor.Set(0)
    call thistype.SUMMON_UNIT_TYPE.Armor.Type.Set(Attack.ARMOR_TYPE_LARGE)
    call thistype.SUMMON_UNIT_TYPE.Life.Set(65)
    call thistype.SUMMON_UNIT_TYPE.Life.SetBJ(65)
    call thistype.SUMMON_UNIT_TYPE.LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE.SightRange.Set(1200)
    call thistype.SUMMON_UNIT_TYPE.SightRange.SetBJ(1200)
    call thistype.SUMMON_UNIT_TYPE.SpellPower.Set(60)
    call thistype.SUMMON_UNIT_TYPE.Attack.Set(Attack.HOMING_MISSILE)
    call thistype.SUMMON_UNIT_TYPE.Attack.Range.Set(300)
    call thistype.SUMMON_UNIT_TYPE.Attack.Speed.SetByCooldown(0.5)
    call thistype.SUMMON_UNIT_TYPE.Damage.Delay.Set(0.1)
    call thistype.SUMMON_UNIT_TYPE.Attack.Missile.Speed.Set(600)
    call thistype.SUMMON_UNIT_TYPE.Damage.Set(2)
    call thistype.SUMMON_UNIT_TYPE.Damage.SetBJ(2)
    call thistype.SUMMON_UNIT_TYPE.Damage.Dices.Set(1)
    call thistype.SUMMON_UNIT_TYPE.Damage.Sides.Set(3)
    call thistype.SUMMON_UNIT_TYPE.Damage.Type.Set(Attack.DMG_TYPE_MAGIC)
    call thistype.SUMMON_UNIT_TYPE.CollisionSize.Set(25)
    call thistype.SUMMON_UNIT_TYPE.Abilities.Add(TorchLight(NULL).THIS_SPELL)
    call thistype.SUMMON_UNIT_TYPE.Abilities.Add(RevealAura(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EyeOfTheFlame.page\\EyeOfTheFlame.struct\\summonUnitType.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\EyeOfTheFlame.page\EyeOfTheFlame.struct\obj_summonUnitType.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\EyeOfTheFlame.page\EyeOfTheFlame.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer DURATION = 40
static integer SUMMONS_AMOUNT = 1
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EyeOfTheFlame.page\\EyeOfTheFlame.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AEoF')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ITEM)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Eye of the Flame")
    call thistype.THIS_SPELL.SetOrder(OrderId("evileye"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 15)
    call thistype.THIS_SPELL.SetRange(1, 550)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EyeOfTheFlame.page\\EyeOfTheFlame.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\EyeOfTheFlame.page\EyeOfTheFlame.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\EyeOfTheFlame.page\EyeOfTheFlame.struct\obj_thisItem.j
static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EyeOfTheFlame.page\\EyeOfTheFlame.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('IEoF')
    call thistype.THIS_ITEM.ChargesAmount.Set(1)
    call thistype.THIS_ITEM.Abilities.Add(EyeOfTheFlame(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EyeOfTheFlame.page\\EyeOfTheFlame.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\EyeOfTheFlame.page\EyeOfTheFlame.struct\obj_thisItem.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call ItemType.AddInit(function thistype.Init_obj_thisItem)
endmethod