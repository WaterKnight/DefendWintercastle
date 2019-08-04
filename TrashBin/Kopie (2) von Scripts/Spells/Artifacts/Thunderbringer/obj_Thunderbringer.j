static string array SPECIAL_EFFECT2_PATH
static integer array STUN_DURATION
static integer array DURATION
static string array SPECIAL_EFFECT_PATH
static integer array DAMAGE
    
static method Init_obj_Thunderbringer takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AThu')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ARTIFACT)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Thunderbringer")
    call SpellObjectCreation.TEMP.SetOrder("sanctuary")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 100)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 8)
    call SpellObjectCreation.TEMP.SetManaCost(1, 35)
    call SpellObjectCreation.TEMP.SetRange(1, 175)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 150)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 8)
    call SpellObjectCreation.TEMP.SetManaCost(2, 45)
    call SpellObjectCreation.TEMP.SetRange(2, 175)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 200)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 8)
    call SpellObjectCreation.TEMP.SetManaCost(3, 55)
    call SpellObjectCreation.TEMP.SetRange(3, 175)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 225)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 8)
    call SpellObjectCreation.TEMP.SetManaCost(4, 65)
    call SpellObjectCreation.TEMP.SetRange(4, 175)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 250)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 8)
    call SpellObjectCreation.TEMP.SetManaCost(5, 75)
    call SpellObjectCreation.TEMP.SetRange(5, 175)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNStormHammer.blp")
    
    set thistype.SPECIAL_EFFECT2_PATH[1] = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl"
    set thistype.STUN_DURATION[1] = 2
    set thistype.DURATION[1] = 12
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl"
    set thistype.DAMAGE[1] = 30
    set thistype.SPECIAL_EFFECT2_PATH[2] = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl"
    set thistype.STUN_DURATION[2] = 2.25
    set thistype.DURATION[2] = 12
    set thistype.SPECIAL_EFFECT_PATH[2] = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl"
    set thistype.DAMAGE[2] = 60
    set thistype.SPECIAL_EFFECT2_PATH[3] = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl"
    set thistype.STUN_DURATION[3] = 2.5
    set thistype.DURATION[3] = 12
    set thistype.SPECIAL_EFFECT_PATH[3] = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl"
    set thistype.DAMAGE[3] = 90
    set thistype.SPECIAL_EFFECT2_PATH[4] = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl"
    set thistype.STUN_DURATION[4] = 2.75
    set thistype.DURATION[4] = 12
    set thistype.SPECIAL_EFFECT_PATH[4] = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl"
    set thistype.DAMAGE[4] = 120
    set thistype.SPECIAL_EFFECT2_PATH[5] = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl"
    set thistype.STUN_DURATION[5] = 3
    set thistype.DURATION[5] = 12
    set thistype.SPECIAL_EFFECT_PATH[5] = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl"
    set thistype.DAMAGE[5] = 150
endmethod