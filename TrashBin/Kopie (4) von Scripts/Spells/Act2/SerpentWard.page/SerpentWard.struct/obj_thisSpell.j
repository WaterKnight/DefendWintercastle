static Spell THIS_SPELL
    
static integer SUMMON_AMOUNT = 3
static integer DURATION = 20
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SerpentWard.page\\SerpentWard.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASeW')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Serpent Ward")
    call thistype.THIS_SPELL.SetOrder(OrderId("ward"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 15)
    call thistype.THIS_SPELL.SetManaCost(1, 55)
    call thistype.THIS_SPELL.SetRange(1, 550)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSerpentWard.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\SerpentWard.page\\SerpentWard.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod