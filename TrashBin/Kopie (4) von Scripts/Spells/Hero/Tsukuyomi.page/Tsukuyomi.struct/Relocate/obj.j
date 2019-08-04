//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\Relocate\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer SPEED = 300
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\Relocate\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ATsR')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE_EX)
    call thistype.THIS_SPELL.SetLevelsAmount(2)
    call thistype.THIS_SPELL.SetName("Relocate")
    call thistype.THIS_SPELL.SetOrder(OrderId("bloodlust"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 0)
    call thistype.THIS_SPELL.SetManaCost(1, 0)
    call thistype.THIS_SPELL.SetRange(1, 99999)
    call thistype.THIS_SPELL.SetCooldown(2, 0)
    call thistype.THIS_SPELL.SetManaCost(2, 0)
    call thistype.THIS_SPELL.SetRange(2, 99999)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNUndeadUnLoad.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FTR0', 2, 'VTR0')
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\Relocate\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\Relocate\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod