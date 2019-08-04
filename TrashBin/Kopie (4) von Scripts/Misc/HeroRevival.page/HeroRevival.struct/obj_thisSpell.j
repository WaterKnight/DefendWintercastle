static Spell THIS_SPELL
    
static integer MANA_CAP = 100
static real LIFE_FACTOR = 0.5
static string DEATH_EFFECT_ATTACH_PT = "AttachPoint.CHEST"
static string REVIVE_EFFECT_PATH = "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl"
static string DEATH_EFFECT_PATH = "Abilities\\Spells\\Undead\\CarrionSwarm\\CarrionSwarmDamage.mdl"
static integer MANA_REGENERATION = 10
static integer MAGIC_IMMUNITY_DURATION = 5
static string GHOST_EFFECT_PATH = "Abilities\\Spells\\Undead\\RegenerationAura\\ObsidianRegenAura.mdl"
static real MANA_FACTOR = 0.5
static string GHOST_EFFECT_ATTACH_PT = "AttachPoint.ORIGIN"
static string REVIVE_EFFECT_ATTACH_PT = "AttachPoint.ORIGIN"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\HeroRevival.page\\HeroRevival.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AHRv')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Revive Hero")
    call thistype.THIS_SPELL.SetOrder(OrderId("resurrection"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCastTime(1, 1)
    call thistype.THIS_SPELL.SetManaCost(1, 100)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNResurrection.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\HeroRevival.page\\HeroRevival.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod