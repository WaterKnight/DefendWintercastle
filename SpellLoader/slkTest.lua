require "slkLib"

require "tableLib"

slk = readSlk("AbilityData")

print(slk)

f=io.open("abilityTest.txt", "w+")

for k, obj in pairs(slk.objs) do
	if obj.vals["useInEditor"]~=1 then
		f:write("\n//"..obj.vals["comments"])
		f:write("\n".."addAbility('"..k.."')")
	end
end

f:close()