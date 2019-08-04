static string array CASTER_EFFECT_ATTACH_POINT
static string array TARGET_LIFE_EFFECT_PATH
static string array SPECIALS
static string array TARGET_MANA_EFFECT_PATH
static real array HEAL_LIFE_PER_MANA_POINT
static string array CASTER_EFFECT_PATH
static string array TARGET_MANA_EFFECT_ATTACH_POINT
static string array TARGET_LIFE_EFFECT_ATTACH_POINT
static real array HEAL_MANA_PER_MANA_POINT
    
static method Init_obj_FountainHeal takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AFoH')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Fountain Heal")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 0)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\")
    
    set thistype.CASTER_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.TARGET_LIFE_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl"
    set thistype.SPECIALS[1] = "acat=;aeat=Abilities\\Spells\\NightElf\\MoonWell\\MoonWellTarget.mdl;asat=;Mbt1=0;Mbt2=0;Mbt3=999;Mbt4=37.5;Mbt5=\\0"
    set thistype.TARGET_MANA_EFFECT_PATH[1] = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl"
    set thistype.HEAL_LIFE_PER_MANA_POINT[1] = 1.5
    set thistype.CASTER_EFFECT_PATH[1] = "Abilities\\Spells\\NightElf\\MoonWell\\MoonWellCasterArt.mdl"
    set thistype.TARGET_MANA_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.TARGET_LIFE_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.HEAL_MANA_PER_MANA_POINT[1] = 1.5
endmethod