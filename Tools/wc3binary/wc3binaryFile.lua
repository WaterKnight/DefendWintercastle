--wc3binaryFile.lua

wc3binaryFile = {}

function wc3binaryFile.create()
	local this = {}

	this.name = "root"

	local floor = math.floor
	local char = string.char
	local byte = string.byte

	local NULL_CHAR = char(0)

	local mode

	local readByte
	local readShort
	local readInt
	local readReal
	local readUnreal
	local readChar
	local readString
	local readId

	local writeByte
	local writeShort
	local writeInt
	local writeReal
	local writeUnreal
	local writeChar
	local writeString
	local writeId

	local types = {}

	local TYPE_BYTE
	local TYPE_SHORT
	local TYPE_INT
	local TYPE_REAL
	local TYPE_UNREAL
	local TYPE_CHAR
	local TYPE_STRIGN
	local TYPE_ID

	local typeByName = {}

	local function createType(name, size, readFunc, writeFunc, defVal)
		local this = {}

		this.name = name
		this.size = size
		this.sizeBit = size * 8
		this.readFunc = readFunc
		this.writeFunc = writeFunc
		this.defVal = defVal

		types[this] = this
		typeByName[name] = this

		return this
	end

	TYPE_BYTE = createType("byte", 1, readByte, writeByte, NULL_CHAR)
	TYPE_SHORT = createType("short", 2, readShort, writeShort, 0)
	TYPE_INT = createType("int", 4, readInt, writeInt, 0)
	TYPE_REAL = createType("real", 4, readReal, writeReal, 0)
	TYPE_UNREAL = createType("unreal", 4, readUnreal, writeUnreal, 0)
	TYPE_CHAR = createType("char", 1, readChar, writeChar, NULL_CHAR)
	TYPE_STRING = createType("string", -1, readString, writeString, "")
	TYPE_ID = createType("id", 4, readId, writeId, NULL_CHAR:rep(4))
	TYPE_STRUCT = createType("struct", 0, nil, nil, nil)

	this.getTypeByName = function(name)
		return typeByName[name]
	end

	local pow2Table = {}

	for i = -32, 255, 1 do
		pow2Table[i] = math.pow(2, i - 1)
	end	

	local function pow2(i)
		return pow2Table[i + 1]
	end

	local pow256Table = {}

	for i = 1, 5, 1 do
		pow256Table[i] = math.pow(256, i - 1)
	end	

	local function pow256(i)
		return pow256Table[i + 1]
	end

	local curPos
	local input
	local inputString

	local function paramsToString(...)
		local arg = {...}
		local result
		local n = select('#', ...)

		for c = 1, n, 1 do
			local v = arg[c]

			if result then
				result = result..", "
			else
				result = ""
			end

			if (type(v) == "string") then
				result = result..[["]]..tostring(v)..[["]]
			else
				result = result..tostring(v)
			end
		end

		return [[(]]..result..[[)]]
	end

	function this:getFullPath()
		local string result = self.name

		local parent = self.parent

		while parent do
			result = parent.name..[[\]]..result

			parent = parent.parent
		end

		return result
	end

	local function getSubByName(parent, name)
		if (name == nil) then
			print([[try to access field with nil name]])

			return nil
		end

		if (parent.subsByName == nil) then
			print([[field "]]..name..[[" does not exist under parent ]]..parent.name)

			return nil
		end

		local sub = parent.subsByName[name]

		if (sub == nil) then
			print([[field "]]..name..[[" does not exist under parent ]]..parent.name)

			return nil
		end

		return sub
	end

	function this:getVal(name)
		if (name == nil) then
			if (self.type == "struct") then
				print([[setVal - field is of struct type ]]..paramsToString(name, val))

				return nil
			end

			return self.val
		end

		local sub = getSubByName(self, name)

		if (sub == nil) then
			return nil
		end
		if (sub.type == "struct") then
			print([[getVal - field is of struct type ]]..paramsToString(name))

			return nil
		end

		return sub.val
	end

	function this:setVal(name, val)
		if (name == nil) then
			if (self.type == "struct") then
				print([[setVal - field is of struct type ]]..paramsToString(name, val))

				return
			end

			self.val = val

			return
		end

		local sub = getSubByName(self, name)

		if (sub == nil) then
			return
		end
		if (sub.type == "struct") then
			print([[setVal - field is of struct type ]]..paramsToString(name, val))

			return
		end

		sub.val = val
	end

	local function getFlagByName(self, flagName, ignoreNil)
		local flags = self.flagsByName

		if (flags == nil) then
			print([[field "]]..self:getFullPath()..[[" has no flags]])

			return nil
		end

		if (flagName == nil) then
			print([[try to access flag with nil name of field "]]..self:getFullPath()..[["]])

			return nil
		end

		local flag = flags[flagName]

		if (ignoreNil ~= true) then
			if (flag == nil) then
				print([[field "]]..self:getFullPath()..[[" has no flag "]]..flagName..[["]])
			end
		end

		return flag
	end

	function this:getFlagVal(flagName)
		local flag = getFlagByName(self, flagName)

		if (flag == nil) then
			return nil
		end

		return flag.val
	end

	function this:setFlagVal(flagName, val)
		local flag = getFlagByName(self, flagName)

		if (flag == nil) then
			return
		end

		if ((val ~= 0) and (val ~= 1)) then
			print([[setFlagVal - flags must be either 1 or 0 ]]..paramsToString(flagName, val))

			return
		end

		flag.val = val

		self.val = 0

		local flags = self.flags

		for bit, val in pairs(flags) do
			self.val = self.val + val * pow2(bit - 1)
		end
	end

	local function readBit(val, pos)
		local rest

		if (val == nil) then
			return nil
		end

		for i = 1, pos, 1 do
			rest = val % 2

			val = (val - rest) / 2
		end

		return rest
	end

	function this:print(firstArg)
		if ((firstArg == nil) or ((type(firstArg) == "number") and (floor(firstArg) == firstArg))) then
			local maxBeforePause = firstArg
			local maxBeforePauseC = 1

			local function printSubs(parent, nestDepth)
				local function writeLine(s)
					print(string.rep("\t", nestDepth)..s)
				end

				if parent.subs then
					for i = 1, parent.subsCount, 1 do
						local sub = parent.subs[i]

						if (maxBeforePauseC == maxBeforePause) then
							maxBeforePauseC = 1
							os.execute("pause")
							os.execute("cls")
						else
							maxBeforePauseC = maxBeforePauseC + 1
						end

						if sub.flags then
							writeLine(sub.name..":")

							for bit, flag in pairs(sub.flags) do
								writeLine("\t"..flag.name.." --> "..flag.val)
							end
						elseif (sub.val) then
							writeLine(sub.name.." --> "..sub.val)
						else
							writeLine(sub.name)
						end

						printSubs(sub, nestDepth + 1)
					end
				end
			end

			printSubs(self, 0)
		elseif (type(firstArg) == "string") then
			local f = io.open(firstArg, "w+")

			if (f == nil) then
				print([[print - could not write to path "]]..firstArg..[["]])

				return
			end

			local function printSubs(parent, nestDepth)
				local function writeLine(s)
					f:write(string.rep("\t", nestDepth)..s.."\n")
				end

				if parent.subs then
					for i = 1, parent.subsCount, 1 do
						local sub = parent.subs[i]

						if sub.flags then
							writeLine(sub.name..":")

							for bit, flag in pairs(sub.flags) do
								writeLine("\t"..flag.name.." --> "..flag.val)
							end
						elseif (sub.val) then
							writeLine(sub.name.." --> "..sub.val)
						else
							writeLine(sub.name)
						end

						printSubs(sub, nestDepth + 1)
					end
				end
			end

			printSubs(self, 0)

			f:close()
		else
			print([[print - first argument must be either integer or string]])
		end
	end

	local function readFromInput(index)
		return input[index]
	end

	local function readFromInputString(a, b)
		return inputString:sub(a, b)
	end

	local function byteToBits(t, val)
		for i = 1, 8, 1 do
			local rest = val % 2

			val = (val - rest) / 2
			t[#t + 1] = rest
		end

		return t
	end

	TYPE_BYTE.readFunc = function(name)
		local result = readFromInput(curPos)

		if (result == nil) then
			return nil
		end

		curPos = curPos + TYPE_BYTE.size

		return result
	end

	local SHORT_SIZE = pow2(TYPE_SHORT.sizeBit)
	local SHORT_MAX = SHORT_SIZE / 2

	TYPE_SHORT.readFunc = function(name)
		local result = 0

		for i = 1, 0, -1 do
			local cut = readFromInput(curPos + i)

			if (cut == nil) then
				return nil
			end

			result = result + tonumber(cut) * pow256(i)
		end

		curPos = curPos + TYPE_SHORT.size

		if (result > SHORT_MAX) then
			result = result - SHORT_SIZE
		end

		return result
	end

	local INT_SIZE = pow2(TYPE_INT.sizeBit)
	local INT_MAX = INT_SIZE / 2

	TYPE_INT.readFunc = function(name)
		local result = 0

		for i = 0, 3, 1 do
			local cut = readFromInput(curPos + i)

			if (cut == nil) then
				return nil
			end

			result = result + tonumber(cut) * pow256(i)
		end

		curPos = curPos + TYPE_INT.size

		if (result > INT_MAX) then
			result = result - INT_SIZE
		end

		return result
	end

	TYPE_REAL.readFunc = function(name)
		local result = {}
		local resultCount = 0

		for i = 0, 3, 1 do
			local cut = readFromInput(curPos + i)

			if (cut == nil) then
				return
			end

			local num = tonumber(cut)

			for i2 = 0, 7, 1 do
				local rest = num % 2

				num = (num - rest) / 2

				resultCount = resultCount + 1
				result[resultCount] = rest
			end
		end

		local exp = 0
		local frac = 1

		for i = 1, 23, 1 do
			frac = frac + result[24 - i] * pow2(-i)
		end
		for i = 24, 31, 1 do
			exp = exp + result[i] * pow2(i - 24)
		end
		local sign = result[32]

		result = math.pow(-1, sign) * frac * pow2(2, exp - 127)

		result = floor(result * 100 + 0.5) / 100

		curPos = curPos + TYPE_REAL.size

		return result
	end

	TYPE_UNREAL.readFunc = function(name)
		return readReal()
	end

	TYPE_CHAR.readFunc = function(name)
		local result = readFromInput(curPos)

		if (result == nil) then
			return nil
		end

		curPos = curPos + TYPE_CHAR.size

		return result
	end

	TYPE_STRING.readFunc = function(name)
		local til = curPos			

		local cut = readFromInput(til)

		if (cut == nil) then
			return nil
		end

		while (cut ~= 0) do
			til = til + 1

			cut = readFromInput(til)

			if (cut == nil) then
				return nil
			end
		end

		local result = readFromInputString(curPos, til - 1)

		if (result == nil) then
			result = ""
		end

		curPos = til + 1

		return result
	end

	TYPE_ID.readFunc = function(name)
		local result = readFromInputString(curPos, curPos + TYPE_ID.size - 1)

		if (result == nil) then
			return nil
		end

		curPos = curPos + TYPE_ID.size

		return result
	end

	local function addFlags(self, flagTable, bits)
		if (type(flagTable) ~= "table") then
			print([[addFlags - flagTable is not a table ]]..paramsToString(flagTable))

			return
		end

		local sizeBit = self.type.sizeBit
		local val = self.val
		local valBitsOffset = self.valBitsOffset

		if (self.flags == nil) then
			self.flags = {}
			self.flagsByName = {}
		end

		--[[local t = {}

		for i = 1, sizeBit, 1 do
			local rest = val % 2

			val = (val - rest) / 2
			t[i] = rest
		end]]

		for i, name in pairs(flagTable) do
			i = tonumber(i)

			if false then
			if ((i == nil) or (i ~= floor(i))) then
				print([[addFlags - "]]..tostring(i)..[[" is not a valid flag index (must be integer)]])

				return
			end

			if ((i < 1) or (i > sizeBit)) then
				print([[addFlags - index ]]..i..[[is out of bounds for type ]]..self.type.name..[[ (should be within 1-]]..sizeBit..[[)]]..paramsToString(flagTable))

				return
			end
			if (type(name) ~= "string") then
				print([[addFlags - ]]..tostring(name)..[[ is no string ]]..paramsToString(flagTable))

				return
			end
			end

			local flag = {}

			flag.name = name
			flag.val = bits[i]

			self.flags[i] = flag
			self.flagsByName[name] = flag
		end
	end

	local function addSub(parent, name, type, flagTable, val, bits)
		if ((name == nil) or (type == nil)) then
			print([[no name/type passed to add ]]..paramsToString(name, type))

			return
		end

		if (types[type] == nil) then
			print([[try to add with invalid type ]]..paramsToString(name, type))

			return
		end

		local sub = {}

		sub.getFullPath = parent.getFullPath
		sub.getVal = parent.getVal
		sub.setVal = parent.setVal
		sub.getFlagVal = parent.getFlagVal
		sub.setFlagVal = parent.setFlagVal
		sub.print = parent.print
		sub.add = parent.add

		sub.name = name
		sub.parent = parent
		sub.type = type

		sub.val = val

		if flagTable then
			addFlags(sub, flagTable, bits)
		end

		if (parent.subs == nil) then
			parent.subs = {}
			parent.subsCount = 0
			parent.subsByName = {}
		end

		parent.subsCount = parent.subsCount + 1
		parent.subs[parent.subsCount] = sub
		parent.subsByName[name] = sub

		return sub
	end

	local function read(parent, name, type, flagTable)
		if ((name == nil) or (type == nil)) then
			print([[no name/type passed to read ]]..paramsToString(name, type))

			return
		end

		if (types[type] == nil) then
			print([[try to read with invalid type ]]..paramsToString(name, type))

			return
		end

		local val
		local posStart = curPos

		if type.readFunc then
			val = type.readFunc(name)

			if (val == nil) then
				print([[no ]]..type.name..[[ "]]..name..[[" at pos ]]..(curPos - 1)..[[ (0x]]..string.format("%X", curPos - 1)..[[)]])

				return
			end
		end

		local posEnd = curPos

		local size = posEnd - posStart

		local bits

		if flagTable then
			bits = {}

			for i = 0, size - 1, 1 do
				local b = readFromInput(posStart + i)

				for i2 = 1, 8, 1 do
					local rest = b % 2

					b = (b - rest) / 2
					bits[i * 8 + i2] = rest
				end
			end
		end

		local sub = addSub(parent, name, type, flagTable, val, bits)

		return sub
	end

	local output
	local outputCount

	local function writeToOutput(val)
		outputCount = outputCount + 1

		output[outputCount] = val
	end

	TYPE_BYTE.writeFunc = function(val)
		writeToOutput(char(val))
	end

	TYPE_SHORT.writeFunc = function(val)
		writeToOutput(char(floor(val % 256))..char(floor(val % 65536 / 256)))
	end

	TYPE_INT.writeFunc = function(val)
		for i = 0, 3, 1 do
			writeToOutput(char(floor(val % pow256(i + 1) / pow256(i))))
		end
	end

	TYPE_REAL.writeFunc = function(val)
		if (val == 0) then
			writeToOutput(NULL_CHAR:rep(4))

			return
		end

		if (val < 0) then
			sign = "1"
			val = -val
		else
			sign = "0"
		end

		local exp = floor(math.log(val) / math.log(2))

		val = val / pow2(exp)

		local frac = val - floor(val)
		local fracString = ""

		for i = 1, 22, 1 do
			frac = frac * 2

			fracString = fracString..floor(frac)

			frac = frac - floor(frac)
		end

		fracString = fracString..floor(frac * 2 + 0.5)

		exp = exp + 127

		local expString = ""

		local i = 1

		for i = 1, 8, 1 do
			expString = expString..(exp % 2)

			exp = floor(exp / 2)
		end

		expString = expString:reverse()

		val = sign..expString..fracString

		for i = 3, 0, -1 do
			local function bin2Dec(para)
				local result = 0
				local mult = 1
				local i = 1

				while (i <= para:len()) do
					result = result + tonumber(para:sub(i, i)) * mult

					i = i + 1
					mult = mult * 2
				end

				return result
			end

			local dec = bin2Dec(val:sub(i * 8 + 1, i * 8 + 8):reverse())

			writeToOutput(char(dec))
		end
	end

	TYPE_UNREAL.writeFunc = function(val)
		writeReal(val)
	end

	TYPE_CHAR.writeFunc = function(val)
		writeToOutput(val)
	end

	TYPE_STRING.writeFunc = function(val)
		writeToOutput(val..NULL_CHAR)
	end

	TYPE_ID.writeFunc = function(val)
		writeToOutput(val)
	end

	local function write(parent, name)
		if ((name == nil) or (type == nil)) then
			print([[no name/type passed to write ]]..paramsToString(name, type))

			return
		end

		--if (types[type] == nil) then
		--	print([[try to write with invalid type ]]..paramsToString(name, type))

		--	return
		--end

		local sub = getSubByName(parent, name)

		local type = sub.type

		if type.writeFunc then
			local val = sub:getVal()

			if (val == nil) then
				print([[could not write "]]..sub:getFullPath()..[[", replace by default value]])

				val = type.defVal
			end

			type.writeFunc(val)
		end

		return sub
	end

	function this:add(name, type, useFlags)
		if (types[type] == nil) then
			local typeName = typeByName[type]

			if (typeName == nil) then
				print([[cannot add incorrect type ]]..paramsToString(name, type))

				return
			else
				type = typeName
			end
		end

		if (mode == "reading") then
			return read(self, name, type, useFlags)
		elseif (mode == "writing") then
			return write(self, name)
		else
			return addSub(self, name, type, useFlags)
		end
	end

	this.readFromFile = function(path, maskFunc)
		local t = os.clock()

		if (type(maskFunc) ~= "function") then
			print([[writing to file needs valid mask function ]]..paramsToString(path, maskFunc))

			return
		end

		local f = io.open(path, "rb")

		if (f == nil) then
			print(path.." could not be read")

			return
		end

		curPos = 1
		input = {}
		inputString = f:read("*a")

		for i = 1, inputString:len(), 1 do
			input[i] = inputString:sub(i, i):byte()
		end
print("rdy "..os.clock())
		f:close()

		mode = "reading"

		maskFunc(this)

		mode = nil

		print([[read ]]..path..[[ in ]]..os.clock() - t..[[ seconds]])
	end

	this.writeToFile = function(path, maskFunc)
		local t = os.clock()

		if (type(maskFunc) ~= "function") then
			print([[writing to file needs valid mask function ]]..paramsToString(path, maskFunc))

			return
		end

		output = {}
		outputCount = 0

		mode = "writing"

		maskFunc(this)

		mode = nil

		local f = io.open(path, "wb+")

		if (f == nil) then
			print("cannot write to "..path)

			return
		end

		local function writeTableToFile(f, t)
			local tCount = #t

			if (tCount == 0) then
				return
			end

			local packSize = 7500

			for i = 1, tCount / packSize + 1, 1 do
				f:write(unpack(t, (i - 1) * packSize + 1, math.min(i * packSize, tCount)))
			end
		end

		writeTableToFile(f, output)

		f:close()

		print([[wrote ]]..path..[[ in ]]..os.clock() - t..[[ seconds]])
	end

	return this
end