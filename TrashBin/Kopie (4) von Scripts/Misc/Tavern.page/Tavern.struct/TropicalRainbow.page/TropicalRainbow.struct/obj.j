//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Tavern.page\Tavern.struct\TropicalRainbow.page\TropicalRainbow.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Tavern.page\\Tavern.struct\\TropicalRainbow.page\\TropicalRainbow.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BTrR', "Tropical Rainbow", 'bTrR')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSnazzyPotion.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\EtherealForm\\SpiritWalkerChange.mdl", AttachPoint.HEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Tavern.page\\Tavern.struct\\TropicalRainbow.page\\TropicalRainbow.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Tavern.page\Tavern.struct\TropicalRainbow.page\TropicalRainbow.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Tavern.page\Tavern.struct\TropicalRainbow.page\TropicalRainbow.struct\obj_thisItem.j
static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Tavern.page\\Tavern.struct\\TropicalRainbow.page\\TropicalRainbow.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('ITrR')
    call thistype.THIS_ITEM.Classes.Add(ItemClass.POWER_UP)
    call thistype.THIS_ITEM.ChargesAmount.Set(1)
    call thistype.THIS_ITEM.Abilities.Add(TropicalRainbow(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Tavern.page\\Tavern.struct\\TropicalRainbow.page\\TropicalRainbow.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Tavern.page\Tavern.struct\TropicalRainbow.page\TropicalRainbow.struct\obj_thisItem.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Tavern.page\Tavern.struct\TropicalRainbow.page\TropicalRainbow.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static real MANA_REGEN_REL_INC = 0.5
static real LIFE_REGEN_REL_INC = 0.5
static real SPEED_REL_INC = 0.2
static real SPELL_POWER_REL_INC = 0.2
static integer DURATION = 60
static real DAMAGE_REL_INC = 0.2
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Tavern.page\\Tavern.struct\\TropicalRainbow.page\\TropicalRainbow.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ATrR')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ITEM)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Tropical Rainbow")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 60)
    call thistype.THIS_SPELL.SetRange(1, 750)
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Tavern.page\\Tavern.struct\\TropicalRainbow.page\\TropicalRainbow.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Tavern.page\Tavern.struct\TropicalRainbow.page\TropicalRainbow.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call ItemType.AddInit(function thistype.Init_obj_thisItem)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod