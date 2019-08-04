objType = {}

function createObjType(name, filePath, version, usesLevels)
	self = {}

	objType[name] = self

	self.file = io.open(filePath, "wb+")
	self.origObjs = {}
	self.customObjs = {}
	self.usesLevels = usesLevels
	self.version = version
end

createObjType("units", "war3map.w3u", 2)
createObjType("items", "war3map.w3t", 2)
createObjType("destructables", "war3map.w3b", 2)
createObjType("doodads", "war3map.w3d", 2, true)
createObjType("abilities", "war3map.w3a", 2, true)
createObjType("buffs", "war3map.w3h", 2)
createObjType("upgrades", "war3map.w3q", 2, true)

function logf(s)
end

function makechange(raw, field, level, val)
print(field)
	if (val == nil) then
		val = level

		objVals[raw][field] = val
	else
		if (objVals[raw][field] == nil) then
			objVals[raw][field] = {}
		end

		objVals[raw][field][level] = val
	end
end

objs = {}

objBase = {}
objVals = {}

existsInSlk = {}

function modifyobject(raw)
	if (objs[raw] == nil) then
		objs[raw] = raw
		objVals[raw] = {}

		if (objBase[raw] == nil) then
			curObjType.origObjs[raw] = raw
		else
			curObjType.customObjs[raw] = raw
		end
	end

	current = raw
end

function createobject(baseRaw, raw)
	objBase[raw] = baseRaw

	modifyobject(raw)
end

function setobjecttype(name)
	curObjType = objType[name]
end

function finalize()
	local function getTableSize(t)
		local c = 0

		for _ in pairs(t) do
			c = c + 1
		end

		return c
	end

	for k, curObjType in pairs(objType) do
		local curFile = curObjType.file

		local function writeInt(val)
			for i = 0, 3, 1 do
				curFile:write(string.char(math.floor(val % math.pow(256, i + 1) / math.pow(256, i))))
			end
		end

		local function writeId(val)
			curFile:write(val)
		end

		local function writeString(val)
			curFile:write(val..string.char(0))
		end

		local function addMods(raw)
			local function addSingle(field, level, val)
				writeId(field)
				if tonumber(val) then
					writeInt(0)--varType
				else
					writeInt(3)--varType
				end
				if curObjType.usesLevels then
					writeInt(level)--level
					writeInt(0)--dataNumber
				end

				if tonumber(val) then
					writeInt(val)
				else
					writeString(val)
				end
				writeInt(0)
			end

			local function addField(raw, field, val)
				if (type(objVals[raw]) == "table") then
					for level, levelVal in pairs(val) do
						addSingle(field, level, levelVal)
					end
				else
					addSingle(field, 0, val)
				end
			end

			for field, val in pairs(objVals[raw]) do
				addField(raw, field, val)
			end
		end

		writeInt(curObjType.version)

		local origObjs = curObjType.origObjs

		writeInt(getTableSize(origObjs))

		for raw in pairs(origObjs) do
			writeId(raw)

			writeInt(0)

			writeInt(getTableSize(objVals[raw]))

			addMods(raw)
		end

		local customObjs = curObjType.customObjs

		writeInt(getTableSize(customObjs))

		for raw in pairs(customObjs) do
			writeId(objBase[raw])

			writeId(raw)

			writeInt(getTableSize(objVals[raw]))

			addMods(raw)
		end

		curObjType.file:close()
	end
end