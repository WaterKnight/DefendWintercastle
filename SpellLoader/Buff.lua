require "Color"

BUFF_COLOR = {}
BUFF_DESCRIPTION = {}
BUFF_NAME = {}

function create(field, name, color, description)
	local arg = {}

	arg[#arg + 1] = field
	arg[#arg + 1] = name
	arg[#arg + 1] = color
	arg[#arg + 1] = description

	assert(color, "createBuff: no color".." ("..table.concat(arg, ",")..")")

	BUFF_COLOR[field] = color
	BUFF_DESCRIPTION[field] = Color.START..color..name..Color.RESET.."|n"..description
	BUFF_NAME[field] = name
end

function applyGold(val)
    return engold(val)
end

create("BANISH", "Banish", Color.BANISH, "Becomes immune to physical attacks. Increases the effect of taken magical damage and received heals by "..applyGold("50%")..".")
create("BLEED", "Bleeding", Color.BLEED, "Reveals invisible units and causes "..applyGold("5%").." ("..applyGold("2%")..") physical damage every second.")
create("CHANNEL", "Channel", Color.CHANNEL, "The cast of an ability is being woven. While doing so, the unit cannot move nor attack but fire other non-channeling spells and use items. An issued 'Hold position' order will cancel everything.")
create("COLDNESS", "Coldness", Color.COLDNESS, "Reduces attack speed by "..applyGold("25%").." and move speed by "..applyGold("25%")..". Cold units take "..applyGold("135%").." damage when being below "..applyGold("35%").." life.")
create("ECLIPSE", "Eclipse", Color.ECLIPSE, "Decreases move speed by "..applyGold("30%")..", spellpower by "..applyGold("50%").." and mana regeneration by "..applyGold("50%").."%.")
create("EXPLOSION", "Explosion", Color.EXPLOSION, "The death of explosive units makes the killer cause "..applyGold("60%").." of the victim's max life to nearby foes around the victim.")
create("IGNITION", "Ignition", Color.IGNITION, "Unveils invisible units and causes "..applyGold("5%").." ("..applyGold("2%")..") magic damage every second.")
create("INVIS", "Invisibility", Color.INVIS, "Carriers of this buff are masked to non-allies. Performing attacks or casting abilities reveals oneself. Invisible units are sure to deal a critical strike when they surprise with a stealthed melee attack.")
create("INVU", "Invulnerability", Color.INVU, "Protects from all harm.")
create("IMMORTAL", "Immortality", Color.IMMORTAL, "Death is avoided, hitpoints cannot drop to zero.")
create("MADNESS", "Madness", Color.MADNESS, "Drives a unit into confusion; a state in which it cannot be controlled and randomly attacks whatever appears before its eyes.")
create("PERM_INVIS", "Greater invisibility", Color.PERM_INVIS, "Carriers of this buff are masked to non-allies. Invisible units are sure to deal a critical strike when they surprise with a stealthed melee attack.|nEven performing attacks or casting abilities does not reveal oneself.")
create("POISON", "Poison", Color.POISON, "Reduces attack speed by "..applyGold("35%").." and move speed by "..applyGold("20%")..". Poisoned units regenerate their hitpoints only half as fast.")
create("PURGE", "Purge", Color.PURGE, "Dispels the target and slows it by initially "..applyGold("70%")..". This effect weakens down over the duration.")
create("SILENCE", "Silence", Color.SILENCE, "Silenced units are unable to cast abilities.")
create("SLEEP", "Sleep", Color.SLEEP, "Sleeping units are unable to act and wake up when attacked. This damage is sure to be critical.")
create("SPELL_SHIELD", "Spell Shield", Color.SPELL_SHIELD, "Protects the unit from many disadvantageous magical effects. Unlike 'Magic Immunity', the 'Spell Shield' blocks only one such thing and then disperses.")
create("SWIFTNESS", "Swiftness", Color.SWIFTNESS, "A buff that boosts the evasion by constant "..applyGold("10%").." (cannot be negated). Is stackable up to three times.")
create("UNTOUCH", "Untouchable", Color.UNTOUCH, "Cannot be targeted.")
create("WHIRL", "Whirl", Color.WHIRL, "When a unit is whirled up, it cannot act nor be targeted and does not regenerate.")

create("FROST", "Frost", Color.FROST, "Covers a unit in ice, rendering it unable to act. Adds explosion ("..BUFF_DESCRIPTION["EXPLOSION"].."). '"..applyGold("Frost").."' inherits from '"..applyGold("coldness").."' ("..BUFF_DESCRIPTION["COLDNESS"]..")")