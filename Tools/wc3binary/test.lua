local params = {...}

local buildPath = params[1]

local path = "war3map.doo"

require "wc3binaryFile"
require "wc3binaryMaskFuncs"

data = wc3binaryFile.create()

data.readFromFile(path, dooMaskFunc)

local t = os.clock()

for i = 1, data:getVal("treeCount"), 1 do
	local x = data:getVal("tree"..i.."x")
	local y = data:getVal("tree"..i.."y")
	local scaleX = data:getVal("tree"..i.."scaleX")
	local scaleY = data:getVal("tree"..i.."scaleY")

	--data:setVal("tree"..i.."x", y)
	--data:setVal("tree"..i.."y", x)
	--data:setVal("tree"..i.."angle", (data:getVal("tree"..i.."angle") + math.pi/2) % (math.pi*2))
	--data:setVal("tree"..i.."scaleX", scaleY)
	--data:setVal("tree"..i.."scaleY", scaleX)
end

data:setVal("treeCount", 5000)

data:print("print.txt")

print("printed in "..(os.clock() - t).." seconds")

data.writeToFile("war3mapEx.doo", dooMaskFunc)