local START = "|c"
local RESET = "|r"

local cols = {
	DWC = "ff00bfff",
	GOLD = "ffffcc00",
	ORANGE = "ffff9f00",
	WHITE = "ffffffff",

	BANISH = "ff007f00",
	BLEED = "ffff0000",
	CHANNEL = "ff00ffff",
	COLDNESS = "ff7f7fff",
	ECLIPSE = "ffff00ff",
	EXPLOSION = "ff7f0000",
	FROST = "ff0000ff",
	IGNITION = "ffff0000",
	IMMORTAL = "ffffffff",
	INVIS = "ffffff00",
	INVU = "ffff7f7f",
	MADNESS = "ffd45e19",
	PERM_INVIS = "ff7f7f00",
	POISON = "ff00ff00",
	PURGE = "ff007777",
	SILENCE = "ffc8b380",
	SLEEP = "ff00ffff",
	SPELL_SHIELD = "ffff00ff",
	SWIFTNESS = "ff007f7f",
	UNTOUCH = "ff000000",
	WHIRL = "ff7f7f7f"
}

local function encolor(a, col)
	assert(col, "encolor: col is nil ("..tostring(a)..", "..tostring(col)..")")

	return START..col..string.gsub(a, RESET, "")..RESET
end

local function engold(a)
	return encolor(a, cols.GOLD)
end

local this = {}

this.START = START
this.RESET = RESET

this.colors = {}

for k, v in pairs(cols) do
	this.colors[k] = v
	this[k] = v
end

this.encolor = encolor
this.engold = engold

module_color = this