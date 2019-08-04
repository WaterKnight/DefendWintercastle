static string array CASTER_EFFECT_PATH
static integer array HEAL
static string array CASTER_EFFECT_ATTACH_POINT
    
static method Init_obj_Medipack takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AMeP')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Medipack")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 15)
    call SpellObjectCreation.TEMP.SetManaCost(1, 25)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNManual.blp")
    
    set thistype.CASTER_EFFECT_PATH[1] = "Spells\\Medipack\\Medipack.mdx"
    set thistype.HEAL[1] = 150
    set thistype.CASTER_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
endmethod