static string array ENEMY_EFFECT_PATH
static integer array ECLIPSE_DURATION
static integer array SPELL_SHIELD_DURATION
static integer array MAX_ENEMIES_AMOUNT
static integer array HEAL
static string array ENEMY_EFFECT_ATTACH_POINT
static integer array DAMAGE
    
static method Init_obj_BatSwarm takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABaS')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ARTIFACT)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Bat Swarm")
    call SpellObjectCreation.TEMP.SetOrder("sanctuary")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 400)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 14)
    call SpellObjectCreation.TEMP.SetManaCost(1, 75)
    call SpellObjectCreation.TEMP.SetRange(1, 800)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 400)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 14)
    call SpellObjectCreation.TEMP.SetManaCost(2, 85)
    call SpellObjectCreation.TEMP.SetRange(2, 800)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 400)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 14)
    call SpellObjectCreation.TEMP.SetManaCost(3, 95)
    call SpellObjectCreation.TEMP.SetRange(3, 800)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 400)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 14)
    call SpellObjectCreation.TEMP.SetManaCost(4, 105)
    call SpellObjectCreation.TEMP.SetRange(4, 800)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 400)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 14)
    call SpellObjectCreation.TEMP.SetManaCost(5, 115)
    call SpellObjectCreation.TEMP.SetRange(5, 800)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCarrionSwarm.blp")
    
    set thistype.ENEMY_EFFECT_PATH[1] = "Abilities\\Weapons\\LocustMissile\\LocustMissile.mdl"
    set thistype.ECLIPSE_DURATION[1] = 7
    set thistype.SPELL_SHIELD_DURATION[1] = 7
    set thistype.MAX_ENEMIES_AMOUNT[1] = 3
    set thistype.HEAL[1] = 20
    set thistype.ENEMY_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
    set thistype.DAMAGE[1] = 20
    set thistype.ENEMY_EFFECT_PATH[2] = "Abilities\\Weapons\\LocustMissile\\LocustMissile.mdl"
    set thistype.ECLIPSE_DURATION[2] = 7
    set thistype.SPELL_SHIELD_DURATION[2] = 7
    set thistype.MAX_ENEMIES_AMOUNT[2] = 3
    set thistype.HEAL[2] = 25
    set thistype.ENEMY_EFFECT_ATTACH_POINT[2] = AttachPoint.CHEST
    set thistype.DAMAGE[2] = 30
    set thistype.ENEMY_EFFECT_PATH[3] = "Abilities\\Weapons\\LocustMissile\\LocustMissile.mdl"
    set thistype.ECLIPSE_DURATION[3] = 7
    set thistype.SPELL_SHIELD_DURATION[3] = 7
    set thistype.MAX_ENEMIES_AMOUNT[3] = 3
    set thistype.HEAL[3] = 30
    set thistype.ENEMY_EFFECT_ATTACH_POINT[3] = AttachPoint.CHEST
    set thistype.DAMAGE[3] = 45
    set thistype.ENEMY_EFFECT_PATH[4] = "Abilities\\Weapons\\LocustMissile\\LocustMissile.mdl"
    set thistype.ECLIPSE_DURATION[4] = 7
    set thistype.SPELL_SHIELD_DURATION[4] = 7
    set thistype.MAX_ENEMIES_AMOUNT[4] = 3
    set thistype.HEAL[4] = 35
    set thistype.ENEMY_EFFECT_ATTACH_POINT[4] = AttachPoint.CHEST
    set thistype.DAMAGE[4] = 65
    set thistype.ENEMY_EFFECT_PATH[5] = "Abilities\\Weapons\\LocustMissile\\LocustMissile.mdl"
    set thistype.ECLIPSE_DURATION[5] = 7
    set thistype.SPELL_SHIELD_DURATION[5] = 7
    set thistype.MAX_ENEMIES_AMOUNT[5] = 3
    set thistype.HEAL[5] = 40
    set thistype.ENEMY_EFFECT_ATTACH_POINT[5] = AttachPoint.CHEST
    set thistype.DAMAGE[5] = 90
endmethod