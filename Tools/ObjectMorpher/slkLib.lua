require "stringLib"

function readSlk(path, useHeader)
	local data = {}
	local file = io.open(path, "r")

	local curX = 0
	local curY = 0
	local maxX = 0
	local maxY = 0

	if (file == nil) then
		print("readSlk: could not open "..path)

		return nil
	end

	for line in file:lines() do
		line = line:split(";")

		if (line[1] == "C") then
			local c = 1
			local val
			local x
			local y

			while line[c] do
				if (line[c]:sub(1, 1) == "X") then
					x = tonumber(line[c]:sub(2, line[c]:len()))
				end
				if (line[c]:sub(1, 1) == "Y") then
					y = tonumber(line[c]:sub(2, line[c]:len()))
				end
				if (line[c]:sub(1, 1) == "K") then
					val = line[c]:sub(2, line[c]:len())

					if (val:sub(1, 1) == "\"") then
						val = val:sub(2, val:len() - 1)
					end
				end

				c = c + 1
			end

			if (x == nil) then
				x = curX
			end
			if (y == nil) then
				y = curY
			end

			if (data[y] == nil) then
				data[y] = {}
			end

			if (x > maxX) then
				maxX = x
			end
			if (y > maxY) then
				maxY = y
			end
			data[y][x] = val

			curX = x
			curY = y
		end
	end

	local self = {}

	self.objs = {}

	for y = 2, maxY, 1 do
		self.objs[data[y][1]] = {}

		for x in pairs(data[y]) do
			local field = data[1][x]

			if field then
				self.objs[data[y][1]][field] = data[y][x]
			end
		end
	end

	return self
end