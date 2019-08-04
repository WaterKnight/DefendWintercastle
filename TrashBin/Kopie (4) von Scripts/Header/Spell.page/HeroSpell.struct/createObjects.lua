count = 5
levelsAmount = 5

function createSlot(index)
    file = io.open("slots["..index.."].wc3spell", "w+")
    raw = "AHS"..index

    file:write([[
field	jass ident	1
name
raw		]]..raw..[[

base		SPECIAL_ANcl
classes		DUMMY
levelsAmount		]]..levelsAmount..[[
]])

    file:close()
end

maxIndex = 6

for i = 0, (count - 1), 1 do
    createSlot(i)
end

file = io.open("spellReplacerBuff.wc3buff", "w+")

    file:write([[
field	jass ident	1
name		HeroSpellReplacerBuff
raw		]].."BHSR"..[[

base		SPECIAL_BNeg
classes		DUMMY
]])

file:close()

file = io.open("this.wc3obj", "w+")

file:write([[
field	jass ident	value]])

file:write([[

maxSlots		]]..count..[[

slotId	integer	]].."\'AHS0\'"..[[
]])

file:close()