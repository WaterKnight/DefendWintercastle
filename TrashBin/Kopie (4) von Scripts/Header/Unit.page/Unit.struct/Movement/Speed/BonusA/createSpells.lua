dummySpellRaw = "AmSp"

file = io.open("dummySpell.wc3spell", "w+")

file:write([[
field	jass ident	1
name
raw		]]..dummySpellRaw..[[

base		SPECIAL_AIms
classes		DUMMY
levelsAmount		]]..(3)..[[

specials		Imvb=0	Imvb=-1	Imvb=1]])

file:close()

file = io.open("storageSpell.wc3spell", "w+")

file:write([[
field	jass ident	1
name
raw		]].."AmSx"..[[

base		SPECIAL_Aspb
classes		DUMMY

specials		spb1=]]..dummySpellRaw)

file:close()