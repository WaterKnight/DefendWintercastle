os.execute("cls")

require "wc3binaryFile"
require "wc3binaryMaskFuncs"

data = wc3binaryFile.create()

data:readFromFile('war3map.doo', dooMaskFunc)

print(data:getVal("treeCount"))

local centerX=-1024
local centerY=5120

--5632

--local centerX=0
--local centerY=0

for i = 1, data:getVal("treeCount"), 1 do
	local tree = data:getSub("tree"..i)

	local x = tree:getVal("x")-centerX
	local y = tree:getVal("y")-centerY

	local angToCenter=math.atan2(y, x)-math.pi/2
	local dist=math.sqrt(x*x+y*y)
print(x+x, y+y, angToCenter+angToCenter, dist+dist)
	x=centerX+dist*math.cos(angToCenter)
	y=centerY+dist*math.sin(angToCenter)

	local scaleX = tree:getVal("scaleX")
	local scaleY = tree:getVal("scaleY")

	tree:setVal("x", x)
	tree:setVal("y", y)
	tree:setVal("angle", (tree:getVal("angle") - math.pi/2) % (math.pi*2))
	tree:setVal("scaleX", scaleY)
	tree:setVal("scaleY", scaleX)
end

data:print("print.txt")

data:writeToFile('war3mapEx.doo', dooMaskFunc)

data = wc3binaryFile.create()

data:readFromFile('war3map.w3c', camMaskFunc)

for i = 1, data:getVal("camCount"), 1 do
	local cam = data:getSub("cam"..i)

	local x = cam:getVal("targetX")-centerX
	local y = cam:getVal("targetY")-centerY

	local angToCenter=math.atan2(y, x)-math.pi/2
	local dist=math.sqrt(x*x+y*y)

	x=centerX+dist*math.cos(angToCenter)
	y=centerY+dist*math.sin(angToCenter)

	cam:setVal("rotation", (cam:getVal("rotation") - math.pi/2) % (math.pi*2))
	cam:setVal("targetX", x)
	cam:setVal("targetY", y)
end

data:print("cams.txt")

data:writeToFile('war3mapEx.w3c', camMaskFunc)