//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BurningOil.page\BurningOil.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static real INTERVAL = 0.75
static integer DURATION = 6
static integer DAMAGE_PER_SECOND = 26
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Orc\\LiquidFire\\Liquidfire.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\BurningOil.page\\BurningOil.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ABuO')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Burning Oil")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 140)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\PassiveButtons\\PASBTNFireRocks.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\BurningOil.page\\BurningOil.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BurningOil.page\BurningOil.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BurningOil.page\BurningOil.struct\obj_missileGraphicSpell.j
static constant integer MISSILE_GRAPHIC_SPELL_ID = 'ABuX'
    
    
static method Init_obj_missileGraphicSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\BurningOil.page\\BurningOil.struct\\missileGraphicSpell.wc3spell")
    call InitAbility('ABuX')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\BurningOil.page\\BurningOil.struct\\missileGraphicSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BurningOil.page\BurningOil.struct\obj_missileGraphicSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BurningOil.page\BurningOil.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\BurningOil.page\\BurningOil.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\BurningOil.page\\BurningOil.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BurningOil.page\BurningOil.struct\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Spell.AddInit(function thistype.Init_obj_missileGraphicSpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod