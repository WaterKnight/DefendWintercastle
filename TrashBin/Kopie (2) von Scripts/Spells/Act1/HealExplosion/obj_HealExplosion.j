static string array CHARGE_EFFECT_PATH
static string array EXPLOSION_EFFECT_PATH
static string array DAMAGE_TARGET_EFFECT_ATTACH_POINT
static integer array HEAL
static string array DAMAGE_TARGET_EFFECT_PATH
static string array EXPLOSION_EFFECT_ATTACH_POINT
static string array HEAL_TARGET_EFFECT_ATTACH_POINT
static string array HEAL_TARGET_EFFECT_PATH
static string array CHARGE_EFFECT_ATTACH_POINT
static integer array DAMAGE
    
static method Init_obj_HealExplosion takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AHEx')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Heal Explosion")
    call SpellObjectCreation.TEMP.SetOrder("bloodlust")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 300)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 2.5)
    call SpellObjectCreation.TEMP.SetCooldown(1, 15)
    call SpellObjectCreation.TEMP.SetManaCost(1, 25)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHealExplosion.blp")
    
    set thistype.CHARGE_EFFECT_PATH[1] = "Spells\\HealExplosion\\Charge.mdx"
    set thistype.EXPLOSION_EFFECT_PATH[1] = "Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl"
    set thistype.DAMAGE_TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
    set thistype.HEAL[1] = 120
    set thistype.DAMAGE_TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosDone.mdl"
    set thistype.EXPLOSION_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
    set thistype.HEAL_TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
    set thistype.HEAL_TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Items\\StaffOfPurification\\PurificationTarget.mdl"
    set thistype.CHARGE_EFFECT_ATTACH_POINT[1] = AttachPoint.WEAPON
    set thistype.DAMAGE[1] = 50
endmethod