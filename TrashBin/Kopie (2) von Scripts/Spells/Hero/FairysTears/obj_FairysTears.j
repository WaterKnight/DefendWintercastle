static real array INTERVAL
    
static method Init_obj_FairysTears takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AFyT')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_ULTIMATE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(3)
    call SpellObjectCreation.TEMP.SetName("Fairy's Tears")
    call SpellObjectCreation.TEMP.SetOrder("starfall")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell,channel")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 450)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 80)
    call SpellObjectCreation.TEMP.SetCooldown(1, 24)
    call SpellObjectCreation.TEMP.SetManaCost(1, 250)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 525)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 80)
    call SpellObjectCreation.TEMP.SetCooldown(2, 27)
    call SpellObjectCreation.TEMP.SetManaCost(2, 350)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 600)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 80)
    call SpellObjectCreation.TEMP.SetCooldown(3, 30)
    call SpellObjectCreation.TEMP.SetManaCost(3, 450)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNStarfall.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FFy0', 3, 'CFy0')
    
    set thistype.INTERVAL[1] = 0.25
    set thistype.INTERVAL[2] = 0.25
    set thistype.INTERVAL[3] = 0.25
endmethod