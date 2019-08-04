f1=io.open("HeroTaurenChieftain.mdl", "r")
f2=io.open("HeroTaurenChieftainCIN.mdl", "r")

l1=f1:read()
	l2=f2:read()

local c=1

while l1 do
	if l1~=l2 then
		print(c, l1, l2)
		os.execute("pause")
	end

	c=c+1
	l1=f1:read()
	l2=f2:read()
end

if l1==l2 then
	print("equal")
else
	print("unequal")
end

f1:close()
f2:close()

os.execute("pause")