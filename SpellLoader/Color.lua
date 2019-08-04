Color = {}

Color.START = "|c"
Color.RESET = "|r"

Color.DWC = "ff00bfff"
Color.GOLD = "ffffcc00"
Color.ORANGE = "ffff9f00"
Color.WHITE = "ffffffff"

Color.BANISH = "ff007f00"
Color.BLEED = "ffff0000"
Color.CHANNEL = "ff00ffff"
Color.COLDNESS = "ff7f7fff"
Color.ECLIPSE = "ffff00ff"
Color.EXPLOSION = "ff7f0000"
Color.FROST = "ff0000ff"
Color.IGNITION = "ffff0000"
Color.IMMORTAL = "ffffffff"
Color.INVIS = "ffffff00"
Color.INVU = "ffff7f7f"
Color.MADNESS = "ffd45e19"
Color.PERM_INVIS = "ff7f7f00"
Color.POISON = "ff00ff00"
Color.PURGE = "ff007777"
Color.SILENCE = "ffc8b380"
Color.SLEEP = "ff00ffff"
Color.SPELL_SHIELD = "ffff00ff"
Color.SWIFTNESS = "ff007f7f"
Color.UNTOUCH = "ff000000"
Color.WHIRL = "ff7f7f7f"

function encolor(a, col)
	assert(col, "encolor: col is nil ("..tostring(a)..", "..tostring(col)..")")

	return Color.START..col..string.gsub(a, Color.RESET, "")..Color.RESET
end

function engold(a)
	return encolor(a, Color.GOLD)
end