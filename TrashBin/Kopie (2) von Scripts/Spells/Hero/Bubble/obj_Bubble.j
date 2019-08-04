
static method Init_obj_Bubble takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABub')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_ULTIMATE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(3)
    call SpellObjectCreation.TEMP.SetName("Bubble")
    call SpellObjectCreation.TEMP.SetOrder("voodoo")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell,channel")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 600)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 10)
    call SpellObjectCreation.TEMP.SetCooldown(1, 90)
    call SpellObjectCreation.TEMP.SetManaCost(1, 250)
    call SpellObjectCreation.TEMP.SetRange(1, 675)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 600)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 13)
    call SpellObjectCreation.TEMP.SetCooldown(2, 80)
    call SpellObjectCreation.TEMP.SetManaCost(2, 250)
    call SpellObjectCreation.TEMP.SetRange(2, 675)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 600)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 16)
    call SpellObjectCreation.TEMP.SetCooldown(3, 70)
    call SpellObjectCreation.TEMP.SetManaCost(3, 250)
    call SpellObjectCreation.TEMP.SetRange(3, 675)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBigBadVoodooSpell.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FBu0', 3, 'CBu0')
    
endmethod