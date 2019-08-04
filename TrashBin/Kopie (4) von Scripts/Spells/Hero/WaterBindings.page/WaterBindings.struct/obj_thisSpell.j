static Spell THIS_SPELL
    
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AWaB')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_FIRST)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Water Bindings")
    call thistype.THIS_SPELL.SetOrder(OrderId("summongrizzly"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 12)
    call thistype.THIS_SPELL.SetManaCost(1, 90)
    call thistype.THIS_SPELL.SetRange(1, 650)
    call thistype.THIS_SPELL.SetCooldown(2, 12)
    call thistype.THIS_SPELL.SetManaCost(2, 105)
    call thistype.THIS_SPELL.SetRange(2, 650)
    call thistype.THIS_SPELL.SetCooldown(3, 12)
    call thistype.THIS_SPELL.SetManaCost(3, 120)
    call thistype.THIS_SPELL.SetRange(3, 650)
    call thistype.THIS_SPELL.SetCooldown(4, 12)
    call thistype.THIS_SPELL.SetManaCost(4, 140)
    call thistype.THIS_SPELL.SetRange(4, 650)
    call thistype.THIS_SPELL.SetCooldown(5, 12)
    call thistype.THIS_SPELL.SetManaCost(5, 160)
    call thistype.THIS_SPELL.SetRange(5, 650)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSummonWaterElemental.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FWB0', 5, 'VWB0')
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod