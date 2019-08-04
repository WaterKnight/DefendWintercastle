//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\PenguinFeather.page\PenguinFeather.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer HEAL = 120
static real EVASION_INCREMENT = 0.35
static integer INTELLIGENCE_INCREMENT = 3
static string HEAL_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string HEAL_EFFECT_PATH = "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\PenguinFeather.page\\PenguinFeather.struct\\thisSpell.wc3spell")
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
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\PenguinFeather.page\\PenguinFeather.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\PenguinFeather.page\PenguinFeather.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\PenguinFeather.page\PenguinFeather.struct\obj_thisItem.j
static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\PenguinFeather.page\\PenguinFeather.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('IPeF')
    call thistype.THIS_ITEM.Abilities.Add(PenguinFeather(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\PenguinFeather.page\\PenguinFeather.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\PenguinFeather.page\PenguinFeather.struct\obj_thisItem.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call ItemType.AddInit(function thistype.Init_obj_thisItem)
endmethod