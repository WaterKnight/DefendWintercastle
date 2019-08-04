static string array CASTER_EFFECT_ATTACH_POINT
static integer array MANA_HEAL
static string array CASTER_EFFECT_PATH
static integer array LIFE_HEAL
static integer array FIELD
    
static method Init_obj_Heal takes nothing returns nothing
    set thistype.CASTER_EFFECT_ATTACH_POINT[1] = AttachPoint.OVERHEAD
    set thistype.MANA_HEAL[1] = 20
    set thistype.CASTER_EFFECT_PATH[1] = "Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkZapTarget.mdl"
    set thistype.LIFE_HEAL[1] = 20
    set thistype.FIELD[1] = 1
    set thistype.CASTER_EFFECT_ATTACH_POINT[2] = AttachPoint.OVERHEAD
    set thistype.MANA_HEAL[2] = 30
    set thistype.CASTER_EFFECT_PATH[2] = "Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkZapTarget.mdl"
    set thistype.LIFE_HEAL[2] = 30
    set thistype.FIELD[2] = 2
    set thistype.CASTER_EFFECT_ATTACH_POINT[3] = AttachPoint.OVERHEAD
    set thistype.MANA_HEAL[3] = 40
    set thistype.CASTER_EFFECT_PATH[3] = "Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkZapTarget.mdl"
    set thistype.LIFE_HEAL[3] = 40
    set thistype.FIELD[3] = 3
    set thistype.CASTER_EFFECT_ATTACH_POINT[4] = AttachPoint.OVERHEAD
    set thistype.MANA_HEAL[4] = 50
    set thistype.CASTER_EFFECT_PATH[4] = "Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkZapTarget.mdl"
    set thistype.LIFE_HEAL[4] = 50
    set thistype.FIELD[4] = 4
    set thistype.CASTER_EFFECT_ATTACH_POINT[5] = AttachPoint.OVERHEAD
    set thistype.MANA_HEAL[5] = 60
    set thistype.CASTER_EFFECT_PATH[5] = "Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkZapTarget.mdl"
    set thistype.LIFE_HEAL[5] = 60
    set thistype.FIELD[5] = 5
endmethod