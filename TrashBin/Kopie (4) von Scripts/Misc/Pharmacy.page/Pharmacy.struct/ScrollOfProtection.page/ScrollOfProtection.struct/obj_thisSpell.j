static Spell THIS_SPELL
    
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\ScrollOfProtection.page\\ScrollOfProtection.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AScP')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ITEM)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Scroll of Protection")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 600)
    call thistype.THIS_SPELL.SetCooldown(1, 40)
    call thistype.THIS_SPELL.SetManaCost(1, 0)
    call thistype.THIS_SPELL.SetRange(1, 750)
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\ScrollOfProtection.page\\ScrollOfProtection.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod