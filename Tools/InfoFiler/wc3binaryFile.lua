--wc3binaryFile.lua

wc3binaryFile = {}

function wc3binaryFile.create()
	local this = {}

	local dataByName = {}
	local dataPatterns = {}

	local mode

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

	local function getDataByName(name)
		if (name == nil) then
			print([[try to access field with nil name]])

			return nil
		end

		local d = dataByName[name]

		if (d == nil) then
			print([[field "]]..name..[[" does not exist]])

			return nil
		end

		return d
	end

	this.getVal = function(name)
		local d = getDataByName(name)

		if (d == nil) then
			return nil
		end

		return d.val
	end

	this.setVal = function(name, val)
		local d = getDataByName(name)

		if (d == nil) then
			return
		end

		d.val = val
	end

	local function getDataFlagByName(parentName, subName, ignoreNil)
		local d = getDataByName(parentName)

		if (d == nil) then
			return nil
		end

		local flags = d.flagsByName

		if (flags == nil) then
			print([[field "]]..parentName..[[" has no flags]])

			return nil
		end

		if (subName == nil) then
			print([[try to access flag with nil name of field ]]..parentName)

			return nil
		end

		local flag = flags[subName]

		if (ignoreNil ~= true) then
			if (flag == nil) then
				print([[field "]]..parentName..[[" has no flag "]]..subName..[["]])
			end
		end

		return flag
	end

	this.getValFlag = function(parentName, subName)
		local flag = getDataFlagByName(parentName, subName)

		if (flag == nil) then
			return nil
		end

		return flag.val
	end

	this.setValFlag = function(parentName, subName, val)
		local flag = getDataFlagByName(parentName, subName)

		if (flag == nil) then
			return
		end

		if ((val ~= 0) and (val ~= 1)) then
			print([[setValFlag - flags must be either 1 or 0 ]]..paramsToString(parentName, subName, val))

			return
		end

		flag.val = val

		local d = getDataByName(parentName)

		d.val = 0

		local flags = d.flags

		for bit = 1, #flags, 1 do
			d.val = d.val + flags[bit].val * math.pow(2, bit - 1)
		end
	end

	this.addIntFlag = function(parentName, subName)
		if (mode == "writing") then
			return
		end

		local parent = getDataByName(parentName)

		if (parent == nil) then
			return
		end

		if (subName == nil) then
			print("addIntFlag - subName is nil")

			return
		end

		if getDataFlagByName(parentName, subName, true) then
			print([[addIntFlag - field "]]..parentName..[[" already has flag "]]..subName..[["]])

			return
		end

		if (#parent.flags > 31) then
			print([[addIntFlag - field "]]..parentName..[[" already has the max of 32 flags]])

			return
		end

		local sub = {}

		sub.name = subName

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

		sub.val = readBit(parent.val, #parent.flags + 1)

		parent.flags[#parent.flags + 1] = sub
		parent.flagsByName[subName] = sub
	end

	this.print = function(maxBeforePause)
		local c = 1
		local maxBeforePauseC = 1

		while dataPatterns[c] do
			local d = dataPatterns[c]

			if (d.type == "intflags") then
				for c2 = 1, #d.flags, 1 do
					local sub = d.flags[c2]

					print(d.name.."_"..sub.name.." --> "..sub.val)
				end
			else
				print(d.name.." --> "..d.val)
			end

			c = c + 1

			if (maxBeforePauseC == maxBeforePause) then
				maxBeforePauseC = 1
				os.execute("pause")
				os.execute("cls")
			else
				maxBeforePauseC = maxBeforePauseC + 1
			end
		end
	end

	local curPos
	local input

	local function read(name, type)
		if ((name == nil) or (type == nil)) then
			print([[no name/type passed to read ]]..paramsToString(name, type))

			return
		end

		local function readFromInput(a, b)
			local result = input:sub(a, b)

			if (b > input:len()) then
				return nil
			end

			if (b < a) then
				return nil
			end

			return result
		end

		local function readByte(name)
			local result = readFromInput(curPos, curPos)

			if (result == nil) then
				return nil
			end

			curPos = curPos + 1

			return string.byte(result)
		end

		local function readInt(name)
			local i = 4
			local result = 0

			for i = 0, 3, 1 do
				local cut = readFromInput(curPos + i, curPos + i)

				if (cut == nil) then
					return nil
				end

				cut = cut:byte()

				result = result + tonumber(cut) * math.pow(256, i)
			end

			curPos = curPos + 4

			if (result > math.pow(2, 32) / 2) then
				return (result - math.pow(2, 32))
			end

			return result
		end

		local function readReal(name)
			local result = ""

			for i = 3, 0, -1 do
				local cut = readFromInput(curPos + i, curPos + i)

				if (cut == nil) then
					return
				end

				cut = cut:byte()

				local num = tonumber(cut)

				for i2 = 7, 0, -1 do
					local quo = math.floor(num / math.pow(2, i2))

					num = num - quo * math.pow(2, i2)
					result = result..quo
				end
			end

			result = result:reverse()

			local exp = 0
			local frac = 1

			for i = 1, 23, 1 do
				frac = frac + result:sub(24 - i, 24 - i) * math.pow(2, -i)
			end
			for i = 24, 31, 1 do
				exp = exp + tonumber(result:sub(i, i)) * math.pow(2, i - 24)
			end
			local sign = result:sub(32, 32)

			result = math.pow(-1, sign) * frac * math.pow(2, exp - 127)

			curPos = curPos + 4

			result = math.floor(result * math.pow(10, 2) + 0.5) / math.pow(10, 2)

			return result
		end

		local function readUnreal(name)
			local result = readReal()

			return result
		end

		local function readChar(name)
			local result = readFromInput(curPos, curPos)

			if (result == nil) then
				return nil
			end

			curPos = curPos + 1

			return result
		end

		local function readString(name)
			local til = curPos			

			local cut = readFromInput(til, til)

			if (cut == nil) then
				return nil
			end

			cut = cut:byte()

			while (cut ~= 0) do
				til = til + 1

				cut = readFromInput(til, til)

				if (cut == nil) then
					return nil
				end

				cut = cut:byte()
			end

			local result = readFromInput(curPos, til - 1)

			if (result == nil) then
				result = ""
			end

			curPos = til + 1

			return result
		end

		local function readId(name)
			local result = readFromInput(curPos, curPos + 3)

			if (result == nil) then
				return nil
			end

			curPos = curPos + 4

			return result
		end

		local t = {}

		t["int"] = readInt
		t["intflags"] = readInt
		t["real"] = readReal
		t["unreal"] = readUnreal
		t["byte"] = readByte
		t["char"] = readChar
		t["string"] = readString
		t["id"] = readId

		if (t[type] == nil) then
			print([[try to read with invalid type ]]..paramsToString(name, type))

			return
		end

		local val = t[type](name)

		if (val == nil) then
			print([[no ]]..type..[[ "]]..name..[[" at pos ]]..(curPos - 1)..[[ (0x]]..string.format("%X", curPos - 1)..[[)]])

			return
		end

		local d = {}

		dataPatterns[#dataPatterns + 1] = d

		d.name = name
		d.type = type

		dataByName[name] = d

		d.val = val

		if (type == "intflags") then
			d.flags = {}
			d.flagsByName = {}
		end
	end

	local output

	local function write(name, type)
		if ((name == nil) or (type == nil)) then
			print([[no name/type passed to write ]]..paramsToString(name, type))

			return
		end

		local val = this.getVal(name)

		if (val == nil) then
			local defVals = {}

			defVals["byte"] = string.char(0)
			defVals["int"] = 0
			defVals["intflags"] = 0
			defVals["real"] = 0
			defVals["unreal"] = 0
			defVals["char"] = string.char(0)
			defVals["string"] = ""
			defVals["id"] = string.char(0):rep(4)

			print([[could not write "]]..name..[[", replace by default value]])

			if defVals[type] then
				val = defVals[type]
			else
				print([[..or not, type "]]..type..[[" is unrecognized]])

				return
			end
		end

		local function writeToOutput(val)
			output = output..val
		end

		local function writeByte(val)
			writeToOutput(string.char(val))
		end

		local function writeInt(val)
			for i = 0, 3, 1 do
				writeToOutput(string.char(math.floor(val % math.pow(256, i + 1) / math.pow(256, i))))
			end
		end

		local function writeReal(val)
			if (val == 0) then
				writeToOutput(string.char(0):rep(4))

				return
			end

			if (val < 0) then
				sign = "1"
				val = -val
			else
				sign = "0"
			end

			local exp = math.floor(math.log(val) / math.log(2))

			val = val / math.pow(2, exp)

			local frac = val - math.floor(val)
			local fracString = ""

			for i = 1, 22, 1 do
				frac = frac * 2

				fracString = fracString..math.floor(frac)

				frac = frac - math.floor(frac)
			end

			fracString = fracString..math.floor(frac * 2 + 0.5)

			exp = exp + 127

			local expString = ""

			local i = 1

			for i = 1, 8, 1 do
				expString = expString..(exp % 2)

				exp = math.floor(exp / 2)
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

				writeToOutput(string.char(dec))
			end
		end

		local function writeUnreal(val)
			writeReal(val)
		end

		local function writeChar(val)
			writeToOutput(val)
		end

		local function writeString(val)
			writeToOutput(val..string.char(0))
		end

		local function writeId(val)
			writeToOutput(val)
		end

		local t = {}

		t["int"] = writeInt
		t["intflags"] = writeInt
		t["real"] = writeReal
		t["unreal"] = writeUnreal
		t["byte"] = writeByte
		t["char"] = writeChar
		t["string"] = writeString
		t["id"] = writeId

		if (t[type] == nil) then
			print([[try to write with invalid type ]]..paramsToString(name, type))

			return
		end

		t[type](val)
	end

	this.add = function(name, type)
		if (mode == "reading") then
			read(name, type)
		elseif (mode == "writing") then
			write(name, type)
		end
	end

	this.readFromFile = function(path, maskFunc)
		if (type(maskFunc) ~= "function") then
			print([[writing to file needs valid mask function ]]..paramsToString(path, maskFunc))

			return
		end

		local f = io.open(path, "r")

		if (f == nil) then
			print(path.." could not be read")

			return
		end

		curPos = 1
		input = f:read("*a")

		f:close()

		mode = "reading"

		maskFunc(this)

		for k, v in pairs(dataByName) do
			if v.flags then
				for i = #v.flags + 1, 32, 1 do
					this.addIntFlag(k, "unknownBit"..i)
				end
			end
		end

		mode = nil
	end

	this.writeToFile = function(path, maskFunc)
		if (type(maskFunc) ~= "function") then
			print([[writing to file needs valid mask function ]]..paramsToString(path, maskFunc))

			return
		end

		output = ""

		mode = "writing"

		maskFunc(this)

		mode = nil

		local f = io.open(path, "w+")

		if (f == nil) then
			print("cannot write to "..path)

			return
		end

		f:write(output)

		f:close()
	end

	return this
end