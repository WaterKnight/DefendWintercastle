function createSpell(inc, index)
    if inc then
        file = io.open("increasingSpells["..index.."].wc3spell", "w+")
        raw = "Aiz"..index
        val = math.pow(2, index)
    else
        file = io.open("decreasingSpells["..index.."].wc3spell", "w+")
        raw = "Adz"..index
        val = -math.pow(2, index)
    end

    file:write([[
field	jass ident	1
name
raw		]]..raw..[[

base		SPECIAL_AIaa
classes		DUMMY

specials		Iaa1=]]..val..[[

specials		acat=
]])

    file:close()

    abi = raw

    if inc then
        file = io.open("increasingItemTypes["..index.."].wc3item", "w+")
        raw = "Iid"..index
    else
        file = io.open("decreasingItemTypes["..index.."].wc3item", "w+")
        raw = "Idd"..index
    end

    file:write([[
field	jass ident	1
name
raw		]]..raw..[[

base		SPECIAL_manh
classes		DUMMY

specials		iabi=]]..abi..[[;ipow=1
]])

    file:close()
end

maxIndex = 7

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

decreasingItemsMax			]]..maxIndex..[[

increasingItemsMax			]]..maxIndex..[[

]])

file:write([[
packets	]])

for i = 0, maxIndex, 1 do
file:write("\t"..math.pow(2, i))
end

file:close()