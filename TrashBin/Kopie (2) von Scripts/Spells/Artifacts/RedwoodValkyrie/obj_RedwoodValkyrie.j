static integer array SPLASH_DAMAGE
static integer array IGNITE_DURATION
static string array LAUNCH_EFFECT_ATTACH_POINT
static string array MISSILE_EFFECT_ATTACH_POINT
static real array DAMAGE_DAMAGE_MOD_FACTOR
static integer array SPLASH_AREA_RANGE
static string array LAUNCH_EFFECT_PATH
static string array MISSILE_EFFECT_PATH
static integer array DAMAGE
    
static method Init_obj_RedwoodValkyrie takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ARwV')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ARTIFACT)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Redwood Valkyrie")
    call SpellObjectCreation.TEMP.SetOrder("sanctuary")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT_OR_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("attack")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 80)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 4)
    call SpellObjectCreation.TEMP.SetManaCost(1, 30)
    call SpellObjectCreation.TEMP.SetRange(1, 900)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 80)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 4)
    call SpellObjectCreation.TEMP.SetManaCost(2, 40)
    call SpellObjectCreation.TEMP.SetRange(2, 900)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 80)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 4)
    call SpellObjectCreation.TEMP.SetManaCost(3, 50)
    call SpellObjectCreation.TEMP.SetRange(3, 900)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 80)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 4)
    call SpellObjectCreation.TEMP.SetManaCost(4, 60)
    call SpellObjectCreation.TEMP.SetRange(4, 900)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 80)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 4)
    call SpellObjectCreation.TEMP.SetManaCost(5, 70)
    call SpellObjectCreation.TEMP.SetRange(5, 900)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFlamingArrows.blp")
    
    set thistype.SPLASH_DAMAGE[1] = 20
    set thistype.IGNITE_DURATION[1] = 8
    set thistype.LAUNCH_EFFECT_ATTACH_POINT[1] = AttachPoint.WEAPON
    set thistype.MISSILE_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[1] = 1.75
    set thistype.SPLASH_AREA_RANGE[1] = 115
    set thistype.LAUNCH_EFFECT_PATH[1] = "Abilities\\Spells\\Other\\Incinerate\\IncinerateBuff.mdl"
    set thistype.MISSILE_EFFECT_PATH[1] = "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl"
    set thistype.DAMAGE[1] = 15
    set thistype.SPLASH_DAMAGE[2] = 30
    set thistype.IGNITE_DURATION[2] = 8
    set thistype.LAUNCH_EFFECT_ATTACH_POINT[2] = AttachPoint.WEAPON
    set thistype.MISSILE_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[2] = 2
    set thistype.SPLASH_AREA_RANGE[2] = 115
    set thistype.LAUNCH_EFFECT_PATH[2] = "Abilities\\Spells\\Other\\Incinerate\\IncinerateBuff.mdl"
    set thistype.MISSILE_EFFECT_PATH[2] = "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl"
    set thistype.DAMAGE[2] = 30
    set thistype.SPLASH_DAMAGE[3] = 40
    set thistype.IGNITE_DURATION[3] = 8
    set thistype.LAUNCH_EFFECT_ATTACH_POINT[3] = AttachPoint.WEAPON
    set thistype.MISSILE_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[3] = 2.25
    set thistype.SPLASH_AREA_RANGE[3] = 115
    set thistype.LAUNCH_EFFECT_PATH[3] = "Abilities\\Spells\\Other\\Incinerate\\IncinerateBuff.mdl"
    set thistype.MISSILE_EFFECT_PATH[3] = "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl"
    set thistype.DAMAGE[3] = 45
    set thistype.SPLASH_DAMAGE[4] = 50
    set thistype.IGNITE_DURATION[4] = 8
    set thistype.LAUNCH_EFFECT_ATTACH_POINT[4] = AttachPoint.WEAPON
    set thistype.MISSILE_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[4] = 2.5
    set thistype.SPLASH_AREA_RANGE[4] = 115
    set thistype.LAUNCH_EFFECT_PATH[4] = "Abilities\\Spells\\Other\\Incinerate\\IncinerateBuff.mdl"
    set thistype.MISSILE_EFFECT_PATH[4] = "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl"
    set thistype.DAMAGE[4] = 60
    set thistype.SPLASH_DAMAGE[5] = 60
    set thistype.IGNITE_DURATION[5] = 8
    set thistype.LAUNCH_EFFECT_ATTACH_POINT[5] = AttachPoint.WEAPON
    set thistype.MISSILE_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[5] = 2.75
    set thistype.SPLASH_AREA_RANGE[5] = 115
    set thistype.LAUNCH_EFFECT_PATH[5] = "Abilities\\Spells\\Other\\Incinerate\\IncinerateBuff.mdl"
    set thistype.MISSILE_EFFECT_PATH[5] = "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl"
    set thistype.DAMAGE[5] = 75
endmethod