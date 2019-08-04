static real array LIFE_FACTOR
static string array TARGET_EFFECT_PATH
static string array TARGET_EFFECT_ATTACH_POINT
static real array MANA_FACTOR
static string array SPECIAL_EFFECT_PATH
static integer array DELAY
static integer array INVISIBILITY_DURATION
    
static method Init_obj_RigorMortis takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ARig')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_ULTIMATE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(3)
    call SpellObjectCreation.TEMP.SetName("Rigor Mortis")
    call SpellObjectCreation.TEMP.SetOrder("rejuvination")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 70)
    call SpellObjectCreation.TEMP.SetManaCost(1, 100)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 60)
    call SpellObjectCreation.TEMP.SetManaCost(2, 150)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 50)
    call SpellObjectCreation.TEMP.SetManaCost(3, 200)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNStatUp.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FRe0', 3, 'CRe0')
    
    set thistype.LIFE_FACTOR[1] = 0.3
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.MANA_FACTOR[1] = 0.3
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Orc\\Reincarnation\\ReincarnationTarget.mdl"
    set thistype.DELAY[1] = 4
    set thistype.INVISIBILITY_DURATION[1] = 5
    set thistype.LIFE_FACTOR[2] = 0.5
    set thistype.TARGET_EFFECT_PATH[2] = "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.MANA_FACTOR[2] = 0.5
    set thistype.SPECIAL_EFFECT_PATH[2] = "Abilities\\Spells\\Orc\\Reincarnation\\ReincarnationTarget.mdl"
    set thistype.DELAY[2] = 4
    set thistype.INVISIBILITY_DURATION[2] = 5
    set thistype.LIFE_FACTOR[3] = 0.7
    set thistype.TARGET_EFFECT_PATH[3] = "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.MANA_FACTOR[3] = 0.7
    set thistype.SPECIAL_EFFECT_PATH[3] = "Abilities\\Spells\\Orc\\Reincarnation\\ReincarnationTarget.mdl"
    set thistype.DELAY[3] = 4
    set thistype.INVISIBILITY_DURATION[3] = 5
endmethod