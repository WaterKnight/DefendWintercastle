//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\HealExplosion.page\HealExplosion.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string CHARGE_EFFECT_PATH = "Spells\\HealExplosion\\Charge.mdx"
static string EXPLOSION_EFFECT_PATH = "Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl"
static string DAMAGE_TARGET_EFFECT_ATTACH_POINT = "AttachPoint.CHEST"
static integer HEAL = 120
static string HEAL_TARGET_EFFECT_ATTACH_POINT = "AttachPoint.CHEST"
static string DAMAGE_TARGET_EFFECT_PATH = "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosDone.mdl"
static string EXPLOSION_EFFECT_ATTACH_POINT = "AttachPoint.CHEST"
static string HEAL_TARGET_EFFECT_PATH = "Abilities\\Spells\\Items\\StaffOfPurification\\PurificationTarget.mdl"
static string CHARGE_EFFECT_ATTACH_POINT = "AttachPoint.WEAPON"
static integer DAMAGE = 50
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\HealExplosion.page\\HealExplosion.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AHEx')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Heal Explosion")
    call thistype.THIS_SPELL.SetOrder(OrderId("bloodlust"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 300)
    call thistype.THIS_SPELL.SetChannelTime(1, 2.5)
    call thistype.THIS_SPELL.SetCooldown(1, 15)
    call thistype.THIS_SPELL.SetManaCost(1, 25)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHealExplosion.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\HealExplosion.page\\HealExplosion.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\HealExplosion.page\HealExplosion.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod