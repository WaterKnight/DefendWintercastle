Math = {}

Math.QUARTER_ANGLE = 1.57

function hex2Dec(val)
	return tonumber(val, 16)
end

function dec2Hex(val)
	return string.format("%X", val)
end