static Spell DUMMY_SPELL
    
    
static method Init_obj_dummySpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FountainHeal.page\\FountainHeal.struct\\dummySpell.wc3spell")
    set thistype.DUMMY_SPELL = Spell.CreateFromSelf('AFHD')
    
    call thistype.DUMMY_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.DUMMY_SPELL.SetLevelsAmount(1)
    call thistype.DUMMY_SPELL.SetName("Fountain Heal")
    call thistype.DUMMY_SPELL.SetAnimation("spell")
    call thistype.DUMMY_SPELL.SetRange(1, 384)
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FountainHeal.page\\FountainHeal.struct\\dummySpell.wc3spell")
    call t.Destroy()
endmethod