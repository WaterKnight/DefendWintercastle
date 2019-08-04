//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\obj_thisItem.j
static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('IElD')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\obj_thisItem.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\obj_SpearOfTheDefender.j
static ItemType SPEAR_OF_THE_DEFENDER
    
    
static method Init_obj_SpearOfTheDefender takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\SpearOfTheDefender.wc3item")
    set thistype.SPEAR_OF_THE_DEFENDER = ItemType.CreateFromSelf('ISoD')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\SpearOfTheDefender.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\obj_SpearOfTheDefender.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer HEAL = 120
static real EVASION_INCREMENT = 0.35
static integer INTELLIGENCE_INCREMENT = 3
static string HEAL_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string HEAL_EFFECT_PATH = "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('APeF')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ITEM)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Penguin Feather")
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 12)
    call thistype.THIS_SPELL.SetManaCost(1, 60)
    call thistype.THIS_SPELL.SetRange(1, 725)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNEtherealFormOn.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\obj_shop.j
static UnitType SHOP
    
    
static method Init_obj_shop takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\shop.wc3unit")
    set thistype.SHOP = UnitType.Create('uGaC')
    call thistype.SHOP.Classes.Add(UnitClass.STRUCTURE)
    call thistype.SHOP.Classes.Add(UnitClass.NEUTRAL)
    call thistype.SHOP.Classes.Add(UnitClass.STRUCTURE)
    call thistype.SHOP.Scale.Set(1.5)
    call thistype.SHOP.Impact.Z.Set(270)
    call thistype.SHOP.Outpact.Z.Set(135)
    call thistype.SHOP.Armor.Set(0)
    call thistype.SHOP.Armor.Type.Set(Attack.ARMOR_TYPE_FORT)
    call thistype.SHOP.Life.Set(UNIT_TYPE.Life.INFINITE)
    call thistype.SHOP.Life.SetBJ(UNIT_TYPE.Life.INFINITE)
    call thistype.SHOP.LifeRegeneration.Set(0)
    call thistype.SHOP.SightRange.Set(500)
    call thistype.SHOP.SightRange.SetBJ(500)
    call thistype.SHOP.Abilities.Add(Invulnerability(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\shop.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\obj_shop.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BSoD', "Bleeding", 'bSoD')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qBoS'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call ItemType.AddInit(function thistype.Init_obj_thisItem)
    call ItemType.AddInit(function thistype.Init_obj_SpearOfTheDefender)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_shop)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod