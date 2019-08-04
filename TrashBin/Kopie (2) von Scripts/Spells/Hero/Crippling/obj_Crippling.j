static string array AREA_EFFECT_PATH
static real array TARGET_CHANCE
    
static method Init_obj_Crippling takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ACrp')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_SECOND)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Crippling")
    call SpellObjectCreation.TEMP.SetOrder("cripple")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 300)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 20)
    call SpellObjectCreation.TEMP.SetManaCost(1, 85)
    call SpellObjectCreation.TEMP.SetRange(1, 650)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 300)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 18)
    call SpellObjectCreation.TEMP.SetManaCost(2, 110)
    call SpellObjectCreation.TEMP.SetRange(2, 650)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 300)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 16)
    call SpellObjectCreation.TEMP.SetManaCost(3, 135)
    call SpellObjectCreation.TEMP.SetRange(3, 650)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 300)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 14)
    call SpellObjectCreation.TEMP.SetManaCost(4, 160)
    call SpellObjectCreation.TEMP.SetRange(4, 650)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 300)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 12)
    call SpellObjectCreation.TEMP.SetManaCost(5, 185)
    call SpellObjectCreation.TEMP.SetRange(5, 650)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDispelMagic.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FCp0', 5, 'CCp0')
    
    set thistype.AREA_EFFECT_PATH[1] = "Spells\\Crippling\\Area.mdx"
    set thistype.TARGET_CHANCE[1] = 0.75
    set thistype.AREA_EFFECT_PATH[2] = "Spells\\Crippling\\Area.mdx"
    set thistype.TARGET_CHANCE[2] = 0.75
    set thistype.AREA_EFFECT_PATH[3] = "Spells\\Crippling\\Area.mdx"
    set thistype.TARGET_CHANCE[3] = 0.75
    set thistype.AREA_EFFECT_PATH[4] = "Spells\\Crippling\\Area.mdx"
    set thistype.TARGET_CHANCE[4] = 0.75
    set thistype.AREA_EFFECT_PATH[5] = "Spells\\Crippling\\Area.mdx"
    set thistype.TARGET_CHANCE[5] = 0.75
endmethod