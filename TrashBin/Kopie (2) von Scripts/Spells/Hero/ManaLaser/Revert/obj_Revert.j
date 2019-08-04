static string array CAST_END_EFFECT_PATH
static integer array DURATION
static string array SOURCE_EFFECT_PATH
static string array CAST_EFFECT_PATH
    
static method Init_obj_Revert takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AMaR')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_FIRST)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Revert")
    call SpellObjectCreation.TEMP.SetOrder("darkconversion")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 0)
    call SpellObjectCreation.TEMP.SetManaCost(2, 0)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 0)
    call SpellObjectCreation.TEMP.SetManaCost(3, 0)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 0)
    call SpellObjectCreation.TEMP.SetManaCost(4, 0)
    call SpellObjectCreation.TEMP.SetRange(4, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 0)
    call SpellObjectCreation.TEMP.SetManaCost(5, 0)
    call SpellObjectCreation.TEMP.SetRange(5, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNNeutralManaShieldOff.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FMR0', 5, 'CMR0')
    
    set thistype.CAST_END_EFFECT_PATH[1] = "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl"
    set thistype.DURATION[1] = 5
    set thistype.SOURCE_EFFECT_PATH[1] = "Spells\\ManaLaser\\Revert\\SourceEffect.mdx"
    set thistype.CAST_EFFECT_PATH[1] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.CAST_END_EFFECT_PATH[2] = "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl"
    set thistype.DURATION[2] = 5
    set thistype.SOURCE_EFFECT_PATH[2] = "Spells\\ManaLaser\\Revert\\SourceEffect.mdx"
    set thistype.CAST_EFFECT_PATH[2] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.CAST_END_EFFECT_PATH[3] = "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl"
    set thistype.DURATION[3] = 5
    set thistype.SOURCE_EFFECT_PATH[3] = "Spells\\ManaLaser\\Revert\\SourceEffect.mdx"
    set thistype.CAST_EFFECT_PATH[3] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.CAST_END_EFFECT_PATH[4] = "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl"
    set thistype.DURATION[4] = 5
    set thistype.SOURCE_EFFECT_PATH[4] = "Spells\\ManaLaser\\Revert\\SourceEffect.mdx"
    set thistype.CAST_EFFECT_PATH[4] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.CAST_END_EFFECT_PATH[5] = "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl"
    set thistype.DURATION[5] = 5
    set thistype.SOURCE_EFFECT_PATH[5] = "Spells\\ManaLaser\\Revert\\SourceEffect.mdx"
    set thistype.CAST_EFFECT_PATH[5] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
endmethod