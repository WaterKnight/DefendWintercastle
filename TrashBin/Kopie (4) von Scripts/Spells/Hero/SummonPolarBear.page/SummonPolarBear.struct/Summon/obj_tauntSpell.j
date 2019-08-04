static Spell TAUNT_SPELL
    
static string LEARN_RAW
static string LEARN_BUTTON_POS_Y
static string LEARN_HOTKEY
static string LEARN_BUTTON_POS_X
static string LEARN_ICON
static string LEARN_TOOLTIP
static string LEARN_UBER_TOOLTIP
    
static method Init_obj_tauntSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\tauntSpell.wc3spell")
    set thistype.TAUNT_SPELL = Spell.CreateFromSelf('ATau')
    
    call thistype.TAUNT_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.TAUNT_SPELL.SetLevelsAmount(1)
    call thistype.TAUNT_SPELL.SetName("Taunt")
    call thistype.TAUNT_SPELL.SetAnimation("spell")
    call thistype.TAUNT_SPELL.SetAreaRange(1, 450)
    call thistype.TAUNT_SPELL.SetRange(1, 750)
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\tauntSpell.wc3spell")
    call t.Destroy()
endmethod