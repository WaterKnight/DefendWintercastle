static Spell THIS_SPELL
    
static integer array STAMINA_INCREMENT
static real STAMINA_RELATIVE_INCREMENT = 0.05
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\MagicBottle.page\\MagicBottle.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AMaB')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ARTIFACT)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Magic Bottle")
    call thistype.THIS_SPELL.SetOrder(OrderId("sanctuary"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 16)
    call thistype.THIS_SPELL.SetManaCost(1, 55)
    call thistype.THIS_SPELL.SetRange(1, 700)
    call thistype.THIS_SPELL.SetCooldown(2, 16)
    call thistype.THIS_SPELL.SetManaCost(2, 75)
    call thistype.THIS_SPELL.SetRange(2, 700)
    call thistype.THIS_SPELL.SetCooldown(3, 16)
    call thistype.THIS_SPELL.SetManaCost(3, 95)
    call thistype.THIS_SPELL.SetRange(3, 700)
    call thistype.THIS_SPELL.SetCooldown(4, 16)
    call thistype.THIS_SPELL.SetManaCost(4, 115)
    call thistype.THIS_SPELL.SetRange(4, 700)
    call thistype.THIS_SPELL.SetCooldown(5, 16)
    call thistype.THIS_SPELL.SetManaCost(5, 125)
    call thistype.THIS_SPELL.SetRange(5, 700)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNPotionOfOmniscience.blp")
    
    set thistype.STAMINA_INCREMENT[1] = 25
    set thistype.STAMINA_INCREMENT[2] = 35
    set thistype.STAMINA_INCREMENT[3] = 45
    set thistype.STAMINA_INCREMENT[4] = 55
    set thistype.STAMINA_INCREMENT[5] = 60
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\MagicBottle.page\\MagicBottle.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod