function createSpell(inc, maxIndex)
    if inc then
        file = io.open("increasingSpell.wc3spell", "w+")
        raw = "AiSR"
    else
        file = io.open("decreasingSpell.wc3spell", "w+")
        raw = "AdSR"
    end

    file:write([[
field	jass ident	1]])

    for i2 = 0, maxIndex, 1 do
        file:write("\t"..(i2 + 2))
    end

file:write([[

name
raw		]]..raw..[[

base		SPECIAL_AIsi
classes		DUMMY
levelsAmount		]]..maxIndex..[[

specials		Isib=0]])

    for i2 = 0, maxIndex, 1 do
        if inc then
            val = -math.pow(2, i2)
        else
            val = math.pow(2, i2)
        end

        file:write("\tIsib="..val)
    end

    file:close()
end

decreasingSpellsMax = 12
increasingSpellsMax = 12

maxIndex = math.max(decreasingSpellsMax, increasingSpellsMax)

createSpell(false, decreasingSpellsMax)
createSpell(true, increasingSpellsMax)

file = io.open("this.wc3obj", "w+")

file:write([[
field	jass ident]])

for i = 0, maxIndex, 1 do
    file:write("\t"..i)
end

file:write([[

decreasingSpellsMax		]]..decreasingSpellsMax..[[

increasingSpellsMax		]]..increasingSpellsMax..[[

packets	]])

for i = 0, maxIndex, 1 do
    file:write("\t"..math.pow(2, i))
end

file:close()