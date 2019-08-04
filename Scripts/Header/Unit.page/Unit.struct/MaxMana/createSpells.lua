chars = {}

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

charsC = 36

function getAscii(val, digits)
	local c = val
	local s = ""

	for i = 3, 0, -1 do
		local val = math.floor(c / math.pow(charsC, i))

		s = s..chars[val]

		c = c % math.pow(charsC, i)
	end

	return s:sub(s:len() - digits + 1, s:len())
end

incObjs = {}
decObjs = {}

function createSpell(val, inc)
	local file
	local raw

	if inc then
		file = io.open("increasingSpell"..val..".wc3spell", "w+")
		raw = "SM"..getAscii(val - 1, 2)

		incObjs[val] = raw
	else
		file = io.open("decreasingSpell"..val..".wc3spell", "w+")
		raw = "TM"..getAscii(val - 1, 2)

		decObjs[val] = raw
	end

	if inc then
		val = -val
	end

	file:write([[
field	jass ident	1	2
name
raw		]]..raw..[[

base		SPECIAL_AImm
classes		DUMMY
levelsAmount		]]..(2)..[[

specials		Iman=0	Iman=]]..(val)..[[
]])

	file:close()

	return raw
end

function createInitFile(inc)
	local file
	local objs
	local prefix

	if inc then
		file = io.open("incInit.wc3obj", "w+")
		objs = incObjs
		prefix = "inc"
	else
		file = io.open("decInit.wc3obj", "w+")
		objs = decObjs
		prefix = "dec"
	end

	file:write([[
field	jass ident	]])

	local maxVal
	local maxValRaw
	local s
	local s2

	for val, raw in pairs(objs) do
		if maxVal then
			if (val > maxVal) then
				maxVal = val
				maxValRaw = raw
			end
		else
			maxVal = val
			maxValRaw = raw
		end

		if s then
			s = s.."\t"..val
			s2 = s2.."\t".."'"..raw.."'"
		else
			s = val
			s2 = "'"..raw.."'"
		end
	end

	file:write(s)

	file:write([[

]]..prefix..[[Raws	integer	]])

	file:write(s2)

	file:write([[

]]..prefix..[[MaxPacket		]]..maxVal..[[

]]..prefix..[[MaxPacketRaw	integer	]].."'"..maxValRaw.."'")

	file:close()
end

function createSpells(maxVal, inc)
	for i = 1, maxVal, 1 do
		raw = createSpell(i, inc)
	end

	createInitFile(inc)
end

createSpells(256, true)
createSpells(256, false)