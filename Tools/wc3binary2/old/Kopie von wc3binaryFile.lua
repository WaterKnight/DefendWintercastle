--wc3binaryFile.lua

wc3binaryFile = {}

function wc3binaryFile.create()
	local this = {}

	this.name = "root"

	local methods = {}

	local floor = math.floor
	local char = string.char
	local byte = string.byte
	local ntype = type

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
	local TYPE_STRING
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

	local function nilTo0(a)
		if a then
			return a
		end

		return 0
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

			if (ntype(v) == "string") then
				result = result..[["]]..tostring(v)..[["]]
			else
				result = result..tostring(v)
			end
		end

		return [[(]]..result..[[)]]
	end

	local function checkMethodCaller()
		local caller = debug.getinfo(2)

		local selfVar, self = debug.getlocal(2, 1)

		if (self[caller.name] == caller.func) then
			return
		end

		assert(self[caller.name] == caller.func, [[try to call function "]]..caller.name..[[" with invalid subject, check for correct operator (use : instead of .)]])
	end

	function methods:getFullPath()
		checkMethodCaller()

		local string result = self.name

		local parent = self.parent

		while parent do
			result = parent.name..[[\]]..result

			parent = parent.parent
		end

		return result
	end

	function methods:getSubByName(name)
		checkMethodCaller()

		if (name == nil) then
			print([[try to access field with nil name]])

			return nil
		end

		if (self.subsByName == nil) then
			print([[field "]]..name..[[" does not exist under parent ]]..self.name)

			return nil
		end

		local sub = self.subsByName[name]

		if (sub == nil) then
			print([[field "]]..name..[[" does not exist under parent ]]..self.name)

			return nil
		end

		return sub
	end

	function methods:getVal(name)
		checkMethodCaller()

		if (name == nil) then
			if (self.type == TYPE_STRUCT) then
				print([[setVal - field is of struct type ]]..paramsToString(name, val))

				return nil
			end

			return self.val
		end

		local sub = self:getSubByName(name)

		if (sub == nil) then
			return nil
		end
		if (sub.type == TYPE_STRUCT) then
			print([[getVal - field is of struct type ]]..paramsToString(name))

			return nil
		end

		return sub.val
	end

	function methods:setVal(name, val)
		checkMethodCaller()

		if (name == nil) then
			if (self.type == TYPE_STRUCT) then
				print([[setVal - field is of struct type ]]..paramsToString(name, val))

				return
			end

			self.val = val

			return
		end

		local sub = self:getSubByName(name)

		if (sub == nil) then
			return
		end
		if (sub.type == TYPE_STRUCT) then
			print([[setVal - field is of struct type ]]..paramsToString(name, val))

			return
		end

		sub.val = val
	end

	function methods:print(firstArg)
		checkMethodCaller()

		if ((firstArg == nil) or ((ntype(firstArg) == "number") and (floor(firstArg) == firstArg))) then
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

						if (sub.val) then
							writeLine(sub.name.." --> "..tostring(sub.val))
						else
							writeLine(sub.name)
						end

						printSubs(sub, nestDepth + 1)
					end
				end
			end

			printSubs(self, 0)
		elseif (ntype(firstArg) == "string") then
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

						if (sub.val) then
							writeLine(sub.name.." --> "..tostring(sub.val))
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

		result = math.pow(-1, sign) * frac * pow2(exp - 127)

		result = floor(result * 100 + 0.5) / 100

		curPos = curPos + TYPE_REAL.size

		return result
	end

	TYPE_UNREAL.readFunc = function(name)
		return readReal(name)
	end

	TYPE_CHAR.readFunc = function(name)
		local result = readFromInputString(curPos, curPos)

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

	local function addBits(field, bits)
		local node = field.parent
		local type = field.type

		local size = type.sizeBit

		field.bits = {}

		local maxBit = 0

		for bit in pairs(bits) do
			if (bit > maxBit) then
				maxBit = bit
			end
		end

		for bit = 1, maxBit, 1 do
			local name = bits[bit]

			if name then
				bit = tonumber(bit)

				if ((bit == nil) or (bit ~= floor(bit))) then
					print([[addBits - "]]..tostring(bit)..[[" is not a valid flag index (must be integer)]])

					return
				end

				if ((bit < 1) or (bit > size)) then
					print([[addBits - index ]]..bit..[[ is out of bounds for type ]]..type.name..[[ (should be within 1-]]..size..[[)]])

					return
				end

				if (ntype(name) ~= "string") then
					print([[addBits - ]]..tostring(name)..[[ is no string ]])

					return
				end

				local sub = node.subsByName[name]

				if sub then
					if (sub.posVals == nil) then
						print([[addBits - try to redeclare field ]]..sub:getFullPath())

						return
					end

					sub.posValsCount = sub.posValsCount + 1
					sub.posVals[bit] = sub.posValsCount
				else
					sub = {}

					sub.getFullPath = methods.getFullPath
					sub.getVal = methods.getVal
					sub.setVal = methods.setVal

					sub.name = name
					sub.posValsCount = 1
					sub.posVals = {}
					sub.posVals[bit] = 1
					sub.val = 0

					node.subsCount = node.subsCount + 1
					node.subs[node.subsCount] = sub
					node.subsByName[name] = sub
				end

				field.bits[bit] = sub
			end
		end
	end

	local function addData(parent, name, type, bits)
		if ((name == nil) or (type == nil)) then
			print([[no name/type passed to add ]]..paramsToString(name, type))

			return
		end

		if (types[type] == nil) then
			print([[try to add with invalid type ]]..paramsToString(name, type))

			return
		end

		local sub = {}

		sub.getFullPath = methods.getFullPath
		sub.getVal = methods.getVal
		sub.setVal = methods.setVal

		sub.name = name
		sub.parent = parent
		sub.type = type

		if (parent.subs == nil) then
			parent.subs = {}
			parent.subsCount = 0
			parent.subsByName = {}
		end

		parent.subsCount = parent.subsCount + 1
		parent.subs[parent.subsCount] = sub
		parent.subsByName[name] = sub

		if bits then
			addBits(sub, bits)
		end

		return sub
	end

	local function readBits(field)
		local bits = field.bits

		if (ntype(bits) ~= "table") then
			print([[readBits - not a table]])

			return
		end

		fillTo = ((curPos - 1) - 1) * 8

		for bit, name in pairs(bits) do
			bits[bit].val = bits[bit].val + inputBits[fillTo - floor((bit - 1) / 8) * 8 + bit] * pow2(bits[bit].posVals[bit] - 1)
		end
	end

	local function read(field)
		if (field == nil) then
			print([[no field passed to read ]]..paramsToString(field))

			return
		end

		local type = field.type
		local val

		if type.readFunc then
			if field.bits then
				if (type.size > 0) then
					local fillTo = curPos + type.size - 1

					for bit, name in pairs(field.bits) do
						local byteIndex = fillTo - floor((bit - 1) / 8)
						local byteBit = (bit - 1) % 8 + 1

						local val = input[byteIndex]
print("deny "..bit)
						if (ntype(val) ~= "table") then
print("prev val", byteIndex, "-->", val)
							input[byteIndex] = {}
						end

						input[byteIndex][byteBit] = 0
					end

					for byteIndex = curPos, fillTo, 1 do
						if (ntype(input[byteIndex]) == "table") then
							local val = 0

							for i = 1, 8, 1 do
								if (nilTo0(input[byteIndex][i]) ~= 0) then
print("have", i, input[byteIndex][i])
									val = val + pow2(i - 1)
								end
							end

							input[byteIndex] = val
print("new val", byteIndex, "-->", val)
						end
					end
				end
			end

			val = type.readFunc(field.name)

			if (val == nil) then
				print([[no ]]..type.name..[[ "]]..field.name..[[" at pos ]]..(curPos - 1)..[[ (0x]]..string.format("%X", curPos - 1)..[[)]])

				return
			end

			field.val = val
		end

		if field.bits then
			readBits(field)
		end

		return sub
	end

	local output
	local outputCount
	local tmpOutput
	local tmpOutputCount

	local function writeToTmp(val)
		tmpOutputCount = tmpOutputCount + 1

		tmpOutput[tmpOutputCount] = val
	end

	local function writeToOutput(val)
		outputCount = outputCount + 1

		output[outputCount] = val
	end

	TYPE_BYTE.writeFunc = function(val)
		writeToTmp(char(val))
	end

	TYPE_SHORT.writeFunc = function(val)
		writeToTmp(char(floor(val % 256)))
		writeToTmp(char(floor(val % 65536 / 256)))
	end

	TYPE_INT.writeFunc = function(val)
		for i = 0, 3, 1 do
			writeToTmp(char(floor(val % pow256(i + 1) / pow256(i))))
		end
	end

	TYPE_REAL.writeFunc = function(val)
		if (val == 0) then
			writeToTmp(NULL_CHAR:rep(4))

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

			writeToTmp(char(dec))
		end
	end

	TYPE_UNREAL.writeFunc = function(val)
		writeToTmp(writeReal(val))
	end

	TYPE_CHAR.writeFunc = function(val)
		writeToTmp(val)
	end

	TYPE_STRING.writeFunc = function(val)
		writeToTmp(val..NULL_CHAR)
	end

	TYPE_ID.writeFunc = function(val)
		writeToTmp(val)
	end

	local function writeBits(field)
		local bits = field.bits

		if (ntype(bits) ~= "table") then
			print([[writeBits - not a table]])

			return
		end

		for bit, name in pairs(bits) do
			local byteIndex = tmpOutputCount - floor((bit - 1) / 8)
			local byteBit = (bit - 1) % 8 + 1

			local val = tmpOutput[byteIndex]

			if (type(val) ~= "table") then
				val = val:byte()

				tmpOutput[byteIndex] = {}

				for i = 1, 8, 1 do
					local rest = val % 2

					val = (val - rest) / 2
					tmpOutput[byteIndex][i] = rest
				end
			end
print(bit, bits[bit].name, bits[bit].val)
			tmpOutput[byteIndex][byteBit] = tmpOutput[byteIndex][byteBit] + nilTo0(floor(bits[bit].val / pow2(bits[bit].posVals[bit] - 1)) % 2)
		end

		for byteIndex = 1, tmpOutputCount, 1 do
			if (type(tmpOutput[byteIndex]) == "table") then
				local val = 0

				for i = 1, 8, 1 do
					if (nilTo0(tmpOutput[byteIndex][i]) ~= 0) then
						val = val + pow2(i - 1)
					end
				end

				tmpOutput[byteIndex] = char(val)
			end
		end
	end

	local function write(field)
		if (field == nil) then
			print([[no field passed to write ]]..paramsToString(field))

			return
		end

		local type = field.type

		if type.writeFunc then
			local val = field:getVal()

			if (val == nil) then
				print([[could not write "]]..field:getFullPath()..[[", replace by default value]])

				val = type.defVal
			end

			tmpOutput = {}
			tmpOutputCount = 0

			type.writeFunc(val)

			if field.bits then
				writeBits(field)
			end

			for i = 1, tmpOutputCount, 1 do
				writeToOutput(tmpOutput[i])
			end
		end

		return field
	end

	function methods:addNode(name)
		checkMethodCaller()

		if (name == nil) then
			print([[addNode - no name passed]])

			return
		end

		if (mode == "writing") then
			return self:getSubByName(name)
		end

		local parent = self
		local sub = {}

		sub.name = name
		sub.parent = parent

		sub.add = methods.add
		sub.addNode = methods.addNode
		sub.clear = methods.clear
		sub.getSubByName = methods.getSubByName
		sub.getVal = methods.getVal
		sub.setVal = methods.setVal
		sub.getFullPath = methods.getFullPath
		sub.print = methods.print
		sub.readFromFile = methods.readFromFile
		sub.writeToFile = methods.writeToFile

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

	function methods:clear()
		checkMethodCaller()

		self.subs = {}
		self.subsCount = 0
		self.subsByName = {}
	end

	function methods:add(name, type, bits)
		checkMethodCaller()

		local result

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
			result = addData(self, name, type, bits)

			read(result)
		elseif (mode == "writing") then
			result = self:getSubByName(name)

			write(result)
		else
			result = addData(self, name, type, bits)
		end

		return result
	end

	function methods:readFromFile(path, maskFunc)
		checkMethodCaller()

		self:clear()

		local t = os.clock()

		if (ntype(maskFunc) ~= "function") then
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
		inputBits = {}
		inputString = f:read("*a")

		for i = 1, inputString:len(), 1 do
			input[i] = inputString:sub(i, i):byte()

			local val = input[i]

			for i2 = 1, 8, 1 do
				local rest = val % 2

				val = (val - rest) / 2
				inputBits[(i - 1) * 8 + i2] = rest
			end
		end
print("rdy "..os.clock())
		f:close()

		mode = "reading"

		maskFunc(self)

		mode = nil

		print([[read ]]..path..[[ in ]]..os.clock() - t..[[ seconds]])
	end

	function methods:writeToFile(path, maskFunc)
		checkMethodCaller()

		local t = os.clock()

		if (ntype(maskFunc) ~= "function") then
			print([[writing to file needs valid mask function ]]..paramsToString(path, maskFunc))

			return
		end

		output = {}
		outputCount = 0

		mode = "writing"

		maskFunc(self)

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

	this.add = methods.add
	this.addNode = methods.addNode
	this.clear = methods.clear
	this.getFullPath = methods.getFullPath
	this.getSubByName = methods.getSubByName
	this.getVal = methods.getVal
	this.setVal = methods.setVal
	this.print = methods.print
	this.readFromFile = methods.readFromFile
	this.writeToFile = methods.writeToFile

	return this
end