static Spell THIS_SPELL
    
static integer array LIFE_REGEN_INCREMENT
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\GarmentsOfTheSalamander.page\\GarmentsOfTheSalamander.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASam')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_SECOND)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Garments of the Salamander")
    call thistype.THIS_SPELL.SetOrder(OrderId("evileye"))
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 3)
    call thistype.THIS_SPELL.SetManaCost(1, 15)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 3)
    call thistype.THIS_SPELL.SetManaCost(2, 15)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetCooldown(3, 3)
    call thistype.THIS_SPELL.SetManaCost(3, 15)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetCooldown(4, 3)
    call thistype.THIS_SPELL.SetManaCost(4, 15)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetCooldown(5, 3)
    call thistype.THIS_SPELL.SetManaCost(5, 15)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNThunderLizardSalamander.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FSa0', 5, 'VSa0')
    
    set thistype.LIFE_REGEN_INCREMENT[1] = 5
    set thistype.LIFE_REGEN_INCREMENT[2] = 8
    set thistype.LIFE_REGEN_INCREMENT[3] = 11
    set thistype.LIFE_REGEN_INCREMENT[4] = 14
    set thistype.LIFE_REGEN_INCREMENT[5] = 17
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\GarmentsOfTheSalamander.page\\GarmentsOfTheSalamander.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod