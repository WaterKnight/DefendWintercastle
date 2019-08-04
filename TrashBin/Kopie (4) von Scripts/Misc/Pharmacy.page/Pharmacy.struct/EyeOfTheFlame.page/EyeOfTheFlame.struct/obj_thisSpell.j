static Spell THIS_SPELL
    
static integer DURATION = 40
static integer SUMMONS_AMOUNT = 1
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EyeOfTheFlame.page\\EyeOfTheFlame.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AEoF')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ITEM)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Eye of the Flame")
    call thistype.THIS_SPELL.SetOrder(OrderId("evileye"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 15)
    call thistype.THIS_SPELL.SetRange(1, 550)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EyeOfTheFlame.page\\EyeOfTheFlame.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod