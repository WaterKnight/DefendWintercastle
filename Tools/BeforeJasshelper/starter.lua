require "stringLib"

params = {...}

buildPath = params[1]

if buildPath then
	os.execute([[copy >NUL ]]..(buildPath..[[\war3map.j]]):quote()..[[ input.j]])
end

local success = (os.execute([[lua beforeJasshelper.lua "input.j"]]) == 0)

if success then
	if buildPath then
		os.execute([[copy >NUL ]]..[[ output.j ]]..(buildPath..[[\war3map.j]]):quote())
	end

	os.remove("returnFail.txt")
else
	local f = io.open("returnFail.txt", "w+")

	f:close()
end