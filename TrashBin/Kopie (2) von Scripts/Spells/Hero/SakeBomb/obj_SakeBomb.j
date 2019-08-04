static string array TARGET_EFFECT_ATTACH_POINT
static string array TARGET_EFFECT_PATH
static integer array POISON_DURATION
static integer array DAMAGE
static integer array DURATION
static integer array POISON_DAMAGE_ADD_FACTOR
static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_SakeBomb takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ASaB')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_SECOND)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Sake Bomb")
    call SpellObjectCreation.TEMP.SetOrder("thunderclap")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 200)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 5)
    call SpellObjectCreation.TEMP.SetManaCost(1, 35)
    call SpellObjectCreation.TEMP.SetRange(1, 500)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 225)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 5)
    call SpellObjectCreation.TEMP.SetManaCost(2, 40)
    call SpellObjectCreation.TEMP.SetRange(2, 500)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 250)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 5)
    call SpellObjectCreation.TEMP.SetManaCost(3, 50)
    call SpellObjectCreation.TEMP.SetRange(3, 500)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 275)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 5)
    call SpellObjectCreation.TEMP.SetManaCost(4, 65)
    call SpellObjectCreation.TEMP.SetRange(4, 500)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 300)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 5)
    call SpellObjectCreation.TEMP.SetManaCost(5, 85)
    call SpellObjectCreation.TEMP.SetRange(5, 500)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDrum.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FSB0', 5, 'CSB0')
    
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.OVERHEAD
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Other\\StrongDrink\\BrewmasterTarget.mdl"
    set thistype.POISON_DURATION[1] = 4
    set thistype.DAMAGE[1] = 30
    set thistype.DURATION[1] = 3
    set thistype.POISON_DAMAGE_ADD_FACTOR[1] = 1
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Other\\Volcano\\VolcanoMissile.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.OVERHEAD
    set thistype.TARGET_EFFECT_PATH[2] = "Abilities\\Spells\\Other\\StrongDrink\\BrewmasterTarget.mdl"
    set thistype.POISON_DURATION[2] = 4.5
    set thistype.DAMAGE[2] = 60
    set thistype.DURATION[2] = 3
    set thistype.POISON_DAMAGE_ADD_FACTOR[2] = 1
    set thistype.SPECIAL_EFFECT_PATH[2] = "Abilities\\Spells\\Other\\Volcano\\VolcanoMissile.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.OVERHEAD
    set thistype.TARGET_EFFECT_PATH[3] = "Abilities\\Spells\\Other\\StrongDrink\\BrewmasterTarget.mdl"
    set thistype.POISON_DURATION[3] = 5
    set thistype.DAMAGE[3] = 90
    set thistype.DURATION[3] = 3
    set thistype.POISON_DAMAGE_ADD_FACTOR[3] = 1
    set thistype.SPECIAL_EFFECT_PATH[3] = "Abilities\\Spells\\Other\\Volcano\\VolcanoMissile.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.OVERHEAD
    set thistype.TARGET_EFFECT_PATH[4] = "Abilities\\Spells\\Other\\StrongDrink\\BrewmasterTarget.mdl"
    set thistype.POISON_DURATION[4] = 5.5
    set thistype.DAMAGE[4] = 120
    set thistype.DURATION[4] = 3
    set thistype.POISON_DAMAGE_ADD_FACTOR[4] = 1
    set thistype.SPECIAL_EFFECT_PATH[4] = "Abilities\\Spells\\Other\\Volcano\\VolcanoMissile.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.OVERHEAD
    set thistype.TARGET_EFFECT_PATH[5] = "Abilities\\Spells\\Other\\StrongDrink\\BrewmasterTarget.mdl"
    set thistype.POISON_DURATION[5] = 6
    set thistype.DAMAGE[5] = 150
    set thistype.DURATION[5] = 3
    set thistype.POISON_DAMAGE_ADD_FACTOR[5] = 1
    set thistype.SPECIAL_EFFECT_PATH[5] = "Abilities\\Spells\\Other\\Volcano\\VolcanoMissile.mdl"
endmethod