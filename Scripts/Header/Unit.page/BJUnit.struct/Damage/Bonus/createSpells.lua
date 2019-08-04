function createSpell(inc, index)
    if inc then
        file = io.open("increasingSpells["..index.."].wc3spell", "w+")
        raw = "AiD"..index
        val = math.pow(2, index)
    else
        file = io.open("decreasingSpells["..index.."].wc3spell", "w+")
        raw = "AdD"..index
        val = -math.pow(2, index)
    end

    file:write([[
field	jass ident	1
name
raw		]]..raw..[[

base		SPECIAL_AIat
classes		DUMMY

specials		Iatt=]]..val)

    file:close()
end

maxIndex = 6

for i = 0, maxIndex, 1 do
    createSpell(false, i)
    createSpell(true, i)
end

file = io.open("this.wc3obj", "w+")

file:write([[
field	jass ident]])

for i = 0, maxIndex, 1 do
file:write("\t"..i)
end

file:write([[

decreasingSpellsMax			]]..maxIndex..[[

increasingSpellsMax			]]..maxIndex..[[

]])

file:write([[
packets	]])

for i = 0, maxIndex, 1 do
file:write("\t"..math.pow(2, i))
end

file:close()