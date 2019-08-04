local BUFF_ID = "BUSC"

function createBuff()
	local raw = BUFF_ID
	local file = io.open("dummyBuff.wc3buff", "w+")

	file:write([[
field	jass ident	1
name		Unit Scale Buff
raw		]]..raw..[[

base		SPECIAL_Bblo
classes		DUMMY

icon		ReplaceableTextures\CommandButtons\BTNBloodLust.blp
]])

	file:close()
end

createBuff()

local chars = {}

for i=0, 9, 1 do
	chars[i]=i
end

chars[10] = "A"
chars[11] = "B"
chars[12] = "C"
chars[13] = "D"
chars[14] = "E"
chars[15] = "F"
chars[16] = "G"
chars[17] = "H"
chars[18] = "I"
chars[19] = "J"
chars[20] = "K"
chars[21] = "L"
chars[22] = "M"
chars[23] = "N"
chars[24] = "O"
chars[25] = "P"
chars[26] = "Q"
chars[27] = "R"
chars[28] = "S"
chars[29] = "T"
chars[30] = "U"
chars[31] = "V"
chars[32] = "W"
chars[33] = "X"
chars[34] = "Y"
chars[35] = "Z"

function createSpell(index, val)
	val = string.format("%.2f", val)

	local one = index % 36
	local two = math.floor((index - one) / 36) % 36

	local raw = "AC"..chars[two]..chars[one]
	local file = io.open("dummySpells["..index.."].wc3spell", "w+")

	file:write([[
field	jass ident	1
name		Unit Scale Ability ]]..val..[[

raw		]]..raw..[[

base		SPECIAL_Ablo
classes		DUMMY

range		99999
targets		ground,enemies,friend,structure,air,neutral,invulnerable,vulnerable,ward

specials		Blo3=]]..val..[[

specials		abuf=]]..BUFF_ID..[[

]])

	file:close()
end

local min = -5
local max = 5

local stepSize = 0.02

local c = 0
local val = min

while (val <= max) do
	createSpell(c, min + c * stepSize)

	val = val + stepSize
	c = c + 1
end

local minIndex = 0
local maxIndex = c - 1

function createJassFile()
	local file = io.open("this.wc3obj", "w+")

	file:write([[
field	jass ident	1
min		]]..min..[[

minIndex		]]..minIndex..[[

max		]]..max..[[

maxIndex		]]..maxIndex..[[

stepSize		]]..stepSize..[[
]])

	file:close()
end

createJassFile()