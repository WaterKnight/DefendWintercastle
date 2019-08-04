static string array EXPLOSION_EFFECT_PATH
static integer array FLOOR_TOLERANCE
static integer array FIRST_BOUNCE_DURATION
static integer array MAX_DAMAGE
static integer array Z_ACCELERATION
static integer array EXPLOSION_DURATION
static integer array DAMAGE
    
static method Init_obj_BouncyBomb takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABoB')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Bouncy Bomb")
    call SpellObjectCreation.TEMP.SetOrder("firebolt")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 100)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 10)
    call SpellObjectCreation.TEMP.SetManaCost(1, 25)
    call SpellObjectCreation.TEMP.SetRange(1, 600)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHealthStone.blp")
    
    set thistype.EXPLOSION_EFFECT_PATH[1] = "Objects\\Spawnmodels\\Human\\FragmentationShards\\FragBoomSpawn.mdl"
    set thistype.FLOOR_TOLERANCE[1] = 1
    set thistype.FIRST_BOUNCE_DURATION[1] = 1
    set thistype.MAX_DAMAGE[1] = 120
    set thistype.Z_ACCELERATION[1] = -1000
    set thistype.EXPLOSION_DURATION[1] = 3
    set thistype.DAMAGE[1] = 40
endmethod