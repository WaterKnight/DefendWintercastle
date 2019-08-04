count = 5
levelsAmount = 6

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

specials		aher=1
]])

    local reqLevel = {}
    local skipLevel = {}

    reqLevel[0] = 1
    reqLevel[1] = 1
    reqLevel[2] = 6
    reqLevel[3] = 10
    reqLevel[4] = 2
    skipLevel[0] = 2
    skipLevel[1] = 2
    skipLevel[2] = 6
    skipLevel[3] = 10
    skipLevel[4] = 2

    file:write([[
specials		arlv=]]..reqLevel[index]..[[

specials		alsk=]]..skipLevel[index]..[[
    ]])

    file:close()
end

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

specials	ftat=
specials	ftac=0
specials	fta0=
specials	fta1=
specials	fta2=
specials	fta3=
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