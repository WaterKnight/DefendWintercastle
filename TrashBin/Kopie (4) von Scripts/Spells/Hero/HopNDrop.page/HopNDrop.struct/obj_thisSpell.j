static Spell THIS_SPELL
    
static integer HEIGHT = 500
static integer DURATION = 1
static integer MAX_LENGTH = 900
static integer FLOOR_TOLERANCE = 1
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AHop')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_SECOND)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Hop'n'Drop")
    call thistype.THIS_SPELL.SetOrder(OrderId("stasistrap"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 22)
    call thistype.THIS_SPELL.SetManaCost(1, 120)
    call thistype.THIS_SPELL.SetRange(1, 900)
    call thistype.THIS_SPELL.SetCooldown(2, 20)
    call thistype.THIS_SPELL.SetManaCost(2, 140)
    call thistype.THIS_SPELL.SetRange(2, 900)
    call thistype.THIS_SPELL.SetCooldown(3, 18)
    call thistype.THIS_SPELL.SetManaCost(3, 160)
    call thistype.THIS_SPELL.SetRange(3, 900)
    call thistype.THIS_SPELL.SetCooldown(4, 16)
    call thistype.THIS_SPELL.SetManaCost(4, 180)
    call thistype.THIS_SPELL.SetRange(4, 900)
    call thistype.THIS_SPELL.SetCooldown(5, 14)
    call thistype.THIS_SPELL.SetManaCost(5, 200)
    call thistype.THIS_SPELL.SetRange(5, 900)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGoblinLandMine.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FHD0', 5, 'VHD0')
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod