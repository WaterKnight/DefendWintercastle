static real array SPEED_RELATIVE_INCREMENT
static real array LIFE_REGEN_RELATIVE_INCREMENT
static integer array DURATION
static real array MANA_REGEN_RELATIVE_INCREMENT
static real array SPELL_POWER_RELATIVE_INCREMENT
static real array DAMAGE_RELATIVE_INCREMENT
    
static method Init_obj_TropicalRainbow takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ATrR')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ITEM)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Tropical Rainbow")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 60)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("")
    
    set thistype.SPEED_RELATIVE_INCREMENT[1] = 0.2
    set thistype.LIFE_REGEN_RELATIVE_INCREMENT[1] = 0.5
    set thistype.DURATION[1] = 60
    set thistype.MANA_REGEN_RELATIVE_INCREMENT[1] = 0.5
    set thistype.SPELL_POWER_RELATIVE_INCREMENT[1] = 0.2
    set thistype.DAMAGE_RELATIVE_INCREMENT[1] = 0.2
endmethod