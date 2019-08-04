static integer array MANA_INCREMENT
static string array CASTER_EFFECT_ATTACH_POINT
static string array CASTER_EFFECT_PATH
    
static method Init_obj_VioletEarring takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AViE')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ARTIFACT)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Violet Earring")
    call SpellObjectCreation.TEMP.SetOrder("sanctuary")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 40)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 38)
    call SpellObjectCreation.TEMP.SetManaCost(2, 0)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 36)
    call SpellObjectCreation.TEMP.SetManaCost(3, 0)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 34)
    call SpellObjectCreation.TEMP.SetManaCost(4, 0)
    call SpellObjectCreation.TEMP.SetRange(4, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 32)
    call SpellObjectCreation.TEMP.SetManaCost(5, 0)
    call SpellObjectCreation.TEMP.SetRange(5, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHeartOfAszune.blp")
    
    set thistype.MANA_INCREMENT[1] = 160
    set thistype.CASTER_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.CASTER_EFFECT_PATH[1] = "Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl"
    set thistype.MANA_INCREMENT[2] = 250
    set thistype.CASTER_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.CASTER_EFFECT_PATH[2] = "Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl"
    set thistype.MANA_INCREMENT[3] = 340
    set thistype.CASTER_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.CASTER_EFFECT_PATH[3] = "Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl"
    set thistype.MANA_INCREMENT[4] = 430
    set thistype.CASTER_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.CASTER_EFFECT_PATH[4] = "Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl"
    set thistype.MANA_INCREMENT[5] = 520
    set thistype.CASTER_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.CASTER_EFFECT_PATH[5] = "Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl"
endmethod