static integer array HEAL
static integer array HEAL_SPELL_POWER_MOD_FACTOR
static integer array ARMOR_INCREMENT
static integer array DURATION
static real array LIFE_REGEN_ADD
static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_Zodiac takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AZod')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_FIRST)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Zodiac")
    call SpellObjectCreation.TEMP.SetOrder("darkconversion")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 7)
    call SpellObjectCreation.TEMP.SetManaCost(1, 60)
    call SpellObjectCreation.TEMP.SetRange(1, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 7)
    call SpellObjectCreation.TEMP.SetManaCost(2, 80)
    call SpellObjectCreation.TEMP.SetRange(2, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 7)
    call SpellObjectCreation.TEMP.SetManaCost(3, 100)
    call SpellObjectCreation.TEMP.SetRange(3, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 7)
    call SpellObjectCreation.TEMP.SetManaCost(4, 120)
    call SpellObjectCreation.TEMP.SetRange(4, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 7)
    call SpellObjectCreation.TEMP.SetManaCost(5, 140)
    call SpellObjectCreation.TEMP.SetRange(5, 600)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNRacoon.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FZo0', 5, 'CZo0')
    
    set thistype.HEAL[1] = 90
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[1] = 1
    set thistype.ARMOR_INCREMENT[1] = 4
    set thistype.DURATION[1] = 12
    set thistype.LIFE_REGEN_ADD[1] = 0.75
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl"
    set thistype.HEAL[2] = 165
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[2] = 1
    set thistype.ARMOR_INCREMENT[2] = 8
    set thistype.DURATION[2] = 15
    set thistype.LIFE_REGEN_ADD[2] = 0.75
    set thistype.SPECIAL_EFFECT_PATH[2] = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl"
    set thistype.HEAL[3] = 240
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[3] = 1
    set thistype.ARMOR_INCREMENT[3] = 12
    set thistype.DURATION[3] = 18
    set thistype.LIFE_REGEN_ADD[3] = 0.75
    set thistype.SPECIAL_EFFECT_PATH[3] = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl"
    set thistype.HEAL[4] = 315
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[4] = 1
    set thistype.ARMOR_INCREMENT[4] = 16
    set thistype.DURATION[4] = 21
    set thistype.LIFE_REGEN_ADD[4] = 0.75
    set thistype.SPECIAL_EFFECT_PATH[4] = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl"
    set thistype.HEAL[5] = 390
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[5] = 1
    set thistype.ARMOR_INCREMENT[5] = 20
    set thistype.DURATION[5] = 24
    set thistype.LIFE_REGEN_ADD[5] = 0.75
    set thistype.SPECIAL_EFFECT_PATH[5] = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl"
endmethod