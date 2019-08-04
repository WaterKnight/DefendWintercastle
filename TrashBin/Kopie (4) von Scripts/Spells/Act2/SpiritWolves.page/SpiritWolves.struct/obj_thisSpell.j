static Spell THIS_SPELL
    
static integer OFFSET = 70
static integer DURATION = 40
static integer SUMMON_AMOUNT = 2
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SpiritWolves.page\\SpiritWolves.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASpW')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Spirit Wolves")
    call thistype.THIS_SPELL.SetOrder(OrderId("spiritwolf"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 22)
    call thistype.THIS_SPELL.SetManaCost(1, 125)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSpiritWolf.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SpiritWolves.page\\SpiritWolves.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod