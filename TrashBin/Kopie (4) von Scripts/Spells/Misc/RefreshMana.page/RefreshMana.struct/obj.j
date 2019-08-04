//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RefreshMana.page\RefreshMana.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static real MANA_FACTOR = 0.5
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\Items\\AIre\\AIreTarget.mdl"
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\RefreshMana.page\\RefreshMana.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AReM')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Refresh Mana")
    call thistype.THIS_SPELL.SetOrder(OrderId("replenishmana"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 30)
    call thistype.THIS_SPELL.SetManaCost(1, 90)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNManaRecharge.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\RefreshMana.page\\RefreshMana.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RefreshMana.page\RefreshMana.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod