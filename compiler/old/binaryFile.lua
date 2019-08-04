function readBit(val, pos)
	local rest

	for i = 1, pos, 1 do
		rest = val % 2

		val = (val - rest) / 2
	end

	return rest
end

function readByte()
	local result = data:sub(curPos, curPos)

	curPos = curPos + 1

	return string.byte(result)
end

function readInt()
	local i = 4
	local result = 0

	for i = 0, 3, 1 do
		result = result + tonumber(data:sub(curPos + i, curPos + i):byte()) * math.pow(256, i)
	end

	curPos = curPos + 4

	if (result > math.pow(2, 32) / 2) then
		return (result - math.pow(2, 32))
	end

	return result
end

function readReal()
	local result = ""

	for i = 3, 0, -1 do
		local num = tonumber(data:sub(curPos + i, curPos + i):byte())

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
		frac = frac + result:sub(24-i, 24-i) * math.pow(2, -i)
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

function readUnreal()
	local result = readReal()

	return result
end

function readChar()
	local result = data:sub(curPos, curPos)

	curPos = curPos + 1

	return result
end

function readString()
	local til = curPos

	while (tonumber(data:sub(til, til):byte()) ~= 0) do
		til = til + 1
	end

	local result = data:sub(curPos, til - 1)

	curPos = til + 1

	return result
end

function readId()
	local result = data:sub(curPos, curPos + 3)

	curPos = curPos + 4

	return result
end

function writeByte(val)
	f:write(string.char(val))
end

function writeInt(val)
	for i = 0, 3, 1 do
		f:write(string.char(math.floor(val % math.pow(256, i + 1) / math.pow(256, i))))
	end
end

function writeId(val)
	f:write(val)
end

function writeReal(val)
	if (val == 0) then
		f:write(string.char(0)..string.char(0)..string.char(0)..string.char(0))

		return
	end

	if (val < 0) then
		sign = "1"
		val = -val
	else
		sign = "0"
	end

	local int = math.floor(val)

	local frac = val - int

	local exp = -1
	local tmp = ""

	while (int ~= 0) do
		tmp = tmp..(int % 2)

		int = math.floor(int / 2)
		exp = exp + 1
	end

	int = tmp:reverse()

	local tmp = ""

	local i = 1

	while (i <= 23 - exp) do
		frac = frac * 2
		if (i == 23 - exp) then
			tmp = tmp..math.floor(frac + 0.5)
		else
			tmp = tmp..math.floor(frac)
		end

		frac = frac - math.floor(frac)
		i = i + 1
	end

	frac = int:sub(int:len() - exp + 1, int:len())..tmp

	exp=exp + 127

	local tmp = ""

	local i = 1

	while (i <= 8) do
		tmp = tmp..(exp % 2)

		exp = math.floor(exp / 2)

		i = i + 1
	end

	exp = tmp:reverse()

	val = sign..exp..frac

	for i=3, 0, -1 do
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

		f:write(string.char(dec))
	end
end

function writeChar(val)
	f:write(val)
end

function writeString(val)
	f:write(val..string.char(0))
end