static real array STOLEN_MANA_ABSORPTION_FACTOR
static integer array STOLEN_MANA
static integer array DURATION
static real array PULL_FACTOR
static integer array INTERVAL
    
static method Init_obj_Tsukuyomi takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ATsu')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_ULTIMATE_EX)
    call SpellObjectCreation.TEMP.SetLevelsAmount(2)
    call SpellObjectCreation.TEMP.SetName("Tsukuyomi")
    call SpellObjectCreation.TEMP.SetOrder("banish")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell,channel")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 275)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 80)
    call SpellObjectCreation.TEMP.SetManaCost(1, 200)
    call SpellObjectCreation.TEMP.SetRange(1, 900)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 350)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 80)
    call SpellObjectCreation.TEMP.SetManaCost(2, 300)
    call SpellObjectCreation.TEMP.SetRange(2, 900)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBanish.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FTs0', 2, 'CTs0')
    
    set thistype.STOLEN_MANA_ABSORPTION_FACTOR[1] = 0.15
    set thistype.STOLEN_MANA[1] = 10
    set thistype.DURATION[1] = 15
    set thistype.PULL_FACTOR[1] = 0.35
    set thistype.INTERVAL[1] = 1
    set thistype.STOLEN_MANA_ABSORPTION_FACTOR[2] = 0.15
    set thistype.STOLEN_MANA[2] = 20
    set thistype.DURATION[2] = 20
    set thistype.PULL_FACTOR[2] = 0.45
    set thistype.INTERVAL[2] = 1
endmethod