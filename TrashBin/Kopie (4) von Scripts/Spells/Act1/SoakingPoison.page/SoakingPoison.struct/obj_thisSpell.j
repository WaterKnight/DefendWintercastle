static Spell THIS_SPELL
    
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\SoakingPoison.page\\SoakingPoison.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASoP')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Soaking Poison")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\PassiveButtons\\PASBTNPoisonSting.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\SoakingPoison.page\\SoakingPoison.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod