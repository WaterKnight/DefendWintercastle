require 'waterlua'

io.local_require[[color]]

local all = {}
local allById = {}

local function getById(id)
	return allById[id]
end

local function create(id, name, col, description)
	local args = {}

	args[#args + 1] = field
	args[#args + 1] = name
	args[#args + 1] = col
	args[#args + 1] = description

	assert(col, "createBuff: no color".." ("..table.concat(args, ",")..")")

	local this = {}

	this.color = col
	this.description = module_color.START..col..name..module_color.RESET.."|n"..description
	this.name = name

	all[#all + 1] = this
	allById[id] = this

	return this
end

local function applyGold(val)
    return module_color.engold(val)
end

create("BANISH", "Banish", module_color.BANISH, "Becomes immune to physical attacks. Increases the effect of taken magical damage and received heals by "..applyGold("50%")..".")
create("BLEED", "Bleeding", module_color.BLEED, "Reveals invisible units and causes "..applyGold("5%").." ("..applyGold("2%")..") physical damage every second.")
create("CHANNEL", "Channel", module_color.CHANNEL, "The cast of an ability is being woven. While doing so, the unit cannot move nor attack but fire other non-channeling spells and use items. An issued 'Hold position' order will cancel everything.")
create("COLDNESS", "Coldness", module_color.COLDNESS, "Reduces attack speed by "..applyGold("25%").." and move speed by "..applyGold("25%")..". Cold units take "..applyGold("135%").." damage when being below "..applyGold("35%").." life.")
create("ECLIPSE", "Eclipse", module_color.ECLIPSE, "Decreases move speed by "..applyGold("30%")..", spellpower by "..applyGold("50%").." and mana regeneration by "..applyGold("50%").."%.")
create("EXPLOSION", "Explosion", module_color.EXPLOSION, "The death of explosive units makes the killer cause "..applyGold("60%").." of the victim's max life to nearby foes around the victim.")
create("IGNITION", "Ignition", module_color.IGNITION, "Unveils invisible units and causes "..applyGold("5%").." ("..applyGold("2%")..") magic damage every second.")
create("INVIS", "Invisibility", module_color.INVIS, "Carriers of this buff are masked to non-allies. Performing attacks or casting abilities reveals oneself. Invisible units are sure to deal a critical strike when they surprise with a stealthed melee attack.")
create("INVU", "Invulnerability", module_color.INVU, "Protects from all harm.")
create("IMMORTAL", "Immortality", module_color.IMMORTAL, "Death is avoided, hitpoints cannot drop to zero.")
create("MADNESS", "Madness", module_color.MADNESS, "Drives a unit into confusion; a state in which it cannot be controlled and randomly attacks whatever appears before its eyes.")
create("PERM_INVIS", "Greater invisibility", module_color.PERM_INVIS, "Carriers of this buff are masked to non-allies. Invisible units are sure to deal a critical strike when they surprise with a stealthed melee attack.|nEven performing attacks or casting abilities does not reveal oneself.")
create("POISON", "Poison", module_color.POISON, "Reduces attack speed by "..applyGold("35%").." and move speed by "..applyGold("20%")..". Poisoned units regenerate their hitpoints only half as fast.")
create("PURGE", "Purge", module_color.PURGE, "Dispels the target and slows it by initially "..applyGold("70%")..". This effect weakens down over the duration.")
create("SILENCE", "Silence", module_color.SILENCE, "Silenced units are unable to cast abilities.")
create("SLEEP", "Sleep", module_color.SLEEP, "Sleeping units are unable to act and wake up when attacked. This damage is sure to be critical.")
create("SPELL_SHIELD", "Spell Shield", module_color.SPELL_SHIELD, "Protects the unit from many disadvantageous magical effects. Unlike 'Magic Immunity', the 'Spell Shield' blocks only one such thing and then disperses.")
create("SWIFTNESS", "Swiftness", module_color.SWIFTNESS, "A buff that boosts the evasion by constant "..applyGold("10%").." (cannot be negated). Is stackable up to three times.")
create("UNTOUCH", "Untouchable", module_color.UNTOUCH, "Cannot be targeted.")
create("WHIRL", "Whirl", module_color.WHIRL, "When a unit is whirled up, it cannot act nor be targeted and does not regenerate.")

create("FROST", "Frost", module_color.FROST, "Covers a unit in ice, rendering it unable to act. Adds explosion ("..getById('EXPLOSION').description.."). '"..applyGold("Frost").."' inherits from '"..applyGold("coldness").."' ("..getById('COLDNESS').description..")")

local this = {}

this.all = all
this.getById = getById

module_sharedBuff = this