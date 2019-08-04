static Spell THIS_SPELL
    
static real array DURATION
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FrostAttack.page\\FrostAttack.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AFrA')
    
    call thistype.THIS_SPELL.SetLevelsAmount(6)
    call thistype.THIS_SPELL.SetName("Frost Attack")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 140)
    call thistype.THIS_SPELL.SetAreaRange(2, 140)
    call thistype.THIS_SPELL.SetAreaRange(3, 140)
    call thistype.THIS_SPELL.SetAreaRange(4, 140)
    call thistype.THIS_SPELL.SetAreaRange(5, 140)
    call thistype.THIS_SPELL.SetAreaRange(6, 140)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\PassiveButtons\\PASBTNFreezingBreath.blp")
    
    set thistype.DURATION[1] = 2
    set thistype.DURATION[2] = 2.5
    set thistype.DURATION[3] = 3
    set thistype.DURATION[4] = 3.5
    set thistype.DURATION[5] = 4
    set thistype.DURATION[6] = 4.5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FrostAttack.page\\FrostAttack.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod