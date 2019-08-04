//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\WhiteStaff.page\WhiteStaff.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static real INTERVAL = 0.75
static integer array MANA_HEAL_PER_SECOND
static string EFFECT_LIGHTNING_PATH = "SPLK"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\WhiteStaff.page\\WhiteStaff.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AWhS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ARTIFACT)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("White Staff")
    call thistype.THIS_SPELL.SetOrder(OrderId("sanctuary"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetChannelTime(1, 5)
    call thistype.THIS_SPELL.SetCooldown(1, 10)
    call thistype.THIS_SPELL.SetManaCost(1, 5)
    call thistype.THIS_SPELL.SetRange(1, 700)
    call thistype.THIS_SPELL.SetChannelTime(2, 5)
    call thistype.THIS_SPELL.SetCooldown(2, 10)
    call thistype.THIS_SPELL.SetManaCost(2, 5)
    call thistype.THIS_SPELL.SetRange(2, 700)
    call thistype.THIS_SPELL.SetChannelTime(3, 5)
    call thistype.THIS_SPELL.SetCooldown(3, 10)
    call thistype.THIS_SPELL.SetManaCost(3, 5)
    call thistype.THIS_SPELL.SetRange(3, 700)
    call thistype.THIS_SPELL.SetChannelTime(4, 5)
    call thistype.THIS_SPELL.SetCooldown(4, 10)
    call thistype.THIS_SPELL.SetManaCost(4, 5)
    call thistype.THIS_SPELL.SetRange(4, 700)
    call thistype.THIS_SPELL.SetChannelTime(5, 5)
    call thistype.THIS_SPELL.SetCooldown(5, 10)
    call thistype.THIS_SPELL.SetManaCost(5, 5)
    call thistype.THIS_SPELL.SetRange(5, 700)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAdvancedStrengthOfTheMoon.blp")
    
    set thistype.MANA_HEAL_PER_SECOND[1] = 3
    set thistype.MANA_HEAL_PER_SECOND[2] = 4
    set thistype.MANA_HEAL_PER_SECOND[3] = 5
    set thistype.MANA_HEAL_PER_SECOND[4] = 6
    set thistype.MANA_HEAL_PER_SECOND[5] = 7
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\WhiteStaff.page\\WhiteStaff.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\WhiteStaff.page\WhiteStaff.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod