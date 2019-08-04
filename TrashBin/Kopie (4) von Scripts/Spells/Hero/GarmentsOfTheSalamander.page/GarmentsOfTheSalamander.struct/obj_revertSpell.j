static Spell REVERT_SPELL
    
    
static method Init_obj_revertSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\GarmentsOfTheSalamander.page\\GarmentsOfTheSalamander.struct\\revertSpell.wc3spell")
    set thistype.REVERT_SPELL = Spell.CreateFromSelf('ASaR')
    
    call thistype.REVERT_SPELL.SetClass(SpellClass.HERO_SECOND)
    call thistype.REVERT_SPELL.SetLevelsAmount(5)
    call thistype.REVERT_SPELL.SetName("Revert to Human Form")
    call thistype.REVERT_SPELL.SetOrder(OrderId("evileye"))
    call thistype.REVERT_SPELL.SetAnimation("spell")
    call thistype.REVERT_SPELL.SetCooldown(1, 3)
    call thistype.REVERT_SPELL.SetRange(1, 750)
    call thistype.REVERT_SPELL.SetCooldown(2, 3)
    call thistype.REVERT_SPELL.SetRange(2, 750)
    call thistype.REVERT_SPELL.SetCooldown(3, 3)
    call thistype.REVERT_SPELL.SetRange(3, 750)
    call thistype.REVERT_SPELL.SetCooldown(4, 3)
    call thistype.REVERT_SPELL.SetRange(4, 750)
    call thistype.REVERT_SPELL.SetCooldown(5, 3)
    call thistype.REVERT_SPELL.SetRange(5, 750)
    call thistype.REVERT_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHeroBloodElfPrince.blp")
    
    call HeroSpell.InitSpell(thistype.REVERT_SPELL, 'FSR0', 5, 'VSR0')
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\GarmentsOfTheSalamander.page\\GarmentsOfTheSalamander.struct\\revertSpell.wc3spell")
    call t.Destroy()
endmethod