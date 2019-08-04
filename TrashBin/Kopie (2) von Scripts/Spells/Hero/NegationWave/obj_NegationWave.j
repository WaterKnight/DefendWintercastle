static string array SPELL_STEAL_CASTER_EFFECT_ATTACH_POINT
static string array CASTER_EFFECT_ATTACH_POINT
static string array EFFECT_LIGHTNING_PATH
static integer array TARGETS_AMOUNT
static string array TARGET_EFFECT_ATTACH_POINT
static integer array DAMAGE
static integer array SILENCE_DURATION
static string array TARGET_EFFECT_PATH
static string array SPELL_STEAL_TARGET_EFFECT_ATTACH_POINT
static string array CASTER_EFFECT_PATH
static string array SPELL_STEAL_CASTER_EFFECT_PATH
static real array DELAY
static string array SPELL_STEAL_TARGET_EFFECT_PATH
    
static method Init_obj_NegationWave takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ANeW')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_ULTIMATE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(3)
    call SpellObjectCreation.TEMP.SetName("Negation Wave")
    call SpellObjectCreation.TEMP.SetOrder("healingwave")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 500)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 9)
    call SpellObjectCreation.TEMP.SetManaCost(1, 105)
    call SpellObjectCreation.TEMP.SetRange(1, 550)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 500)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 9)
    call SpellObjectCreation.TEMP.SetManaCost(2, 120)
    call SpellObjectCreation.TEMP.SetRange(2, 550)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 500)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 9)
    call SpellObjectCreation.TEMP.SetManaCost(3, 135)
    call SpellObjectCreation.TEMP.SetRange(3, 550)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFeedback.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FNW0', 3, 'CNW0')
    
    set thistype.SPELL_STEAL_CASTER_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
    set thistype.CASTER_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.EFFECT_LIGHTNING_PATH[1] = "FORK"
    set thistype.TARGETS_AMOUNT[1] = 3
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
    set thistype.DAMAGE[1] = 30
    set thistype.SILENCE_DURATION[1] = 2
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Weapons\\Bolt\\BoltImpact.mdl"
    set thistype.SPELL_STEAL_TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
    set thistype.CASTER_EFFECT_PATH[1] = "Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl"
    set thistype.SPELL_STEAL_CASTER_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\SpellSteal\\SpellStealMissile.mdl"
    set thistype.DELAY[1] = 0.35
    set thistype.SPELL_STEAL_TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl"
    set thistype.SPELL_STEAL_CASTER_EFFECT_ATTACH_POINT[2] = AttachPoint.CHEST
    set thistype.CASTER_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.EFFECT_LIGHTNING_PATH[2] = "FORK"
    set thistype.TARGETS_AMOUNT[2] = 4
    set thistype.TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.CHEST
    set thistype.DAMAGE[2] = 40
    set thistype.SILENCE_DURATION[2] = 2.2
    set thistype.TARGET_EFFECT_PATH[2] = "Abilities\\Weapons\\Bolt\\BoltImpact.mdl"
    set thistype.SPELL_STEAL_TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.CHEST
    set thistype.CASTER_EFFECT_PATH[2] = "Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl"
    set thistype.SPELL_STEAL_CASTER_EFFECT_PATH[2] = "Abilities\\Spells\\Human\\SpellSteal\\SpellStealMissile.mdl"
    set thistype.DELAY[2] = 0.35
    set thistype.SPELL_STEAL_TARGET_EFFECT_PATH[2] = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl"
    set thistype.SPELL_STEAL_CASTER_EFFECT_ATTACH_POINT[3] = AttachPoint.CHEST
    set thistype.CASTER_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.EFFECT_LIGHTNING_PATH[3] = "FORK"
    set thistype.TARGETS_AMOUNT[3] = 5
    set thistype.TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.CHEST
    set thistype.DAMAGE[3] = 50
    set thistype.SILENCE_DURATION[3] = 2.4
    set thistype.TARGET_EFFECT_PATH[3] = "Abilities\\Weapons\\Bolt\\BoltImpact.mdl"
    set thistype.SPELL_STEAL_TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.CHEST
    set thistype.CASTER_EFFECT_PATH[3] = "Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl"
    set thistype.SPELL_STEAL_CASTER_EFFECT_PATH[3] = "Abilities\\Spells\\Human\\SpellSteal\\SpellStealMissile.mdl"
    set thistype.DELAY[3] = 0.35
    set thistype.SPELL_STEAL_TARGET_EFFECT_PATH[3] = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl"
endmethod