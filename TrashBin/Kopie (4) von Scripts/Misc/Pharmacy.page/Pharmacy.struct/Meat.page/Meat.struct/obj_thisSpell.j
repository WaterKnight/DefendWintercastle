static Spell THIS_SPELL
    
static integer HEAL = 300
static string CASTER_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static integer INTERVAL = 1
static integer DURATION = 10
static string CASTER_EFFECT_PATH = "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\Meat.page\\Meat.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AMea')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ITEM)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Meat")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 20)
    call thistype.THIS_SPELL.SetRange(1, 750)
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\Meat.page\\Meat.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod