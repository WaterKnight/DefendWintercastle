//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\BigBoom\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer array IGNITE_DURATION
static integer array DAMAGE
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\BigBoom\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ABiB')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Big Boom")
    call thistype.THIS_SPELL.SetOrder(OrderId("mirrorimage"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT_OR_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 300)
    call thistype.THIS_SPELL.SetCooldown(1, 0)
    call thistype.THIS_SPELL.SetManaCost(1, 0)
    call thistype.THIS_SPELL.SetRange(1, 50)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSelfDestruct.blp")
    
    set thistype.IGNITE_DURATION[1] = 10
    set thistype.DAMAGE[1] = 100
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\BigBoom\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\BigBoom\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod