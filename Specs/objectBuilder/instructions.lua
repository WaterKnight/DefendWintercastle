local fieldIsArray = {}

if sheet.arrayFields then
	for k2, v2 in pairs(sheet.arrayFields) do
		fieldIsArray[v2] = true
	end
end

if (sheet.customFields ~= nil) then
	for _, field in pairs(sheet.customFields) do
		local jassType = sheet.fields[field].jassType

		assert(jassType, 'no jassType for field '..field)

		if fieldIsArray[field] then
			for level = 0, sheet.levelsAmount, 1 do
				local val = sheet:getVal(field, level)

				if (val ~= nil) then
					jStream:addVar(field, jassType, level, toJassValue(val, jassType))
				end
			end
		else
			local t = {'boolean', 'integer', 'real', 'string'}

			local val = sheet:getVal(field, 1)

			if (val ~= nil) then
				if (val and tableContains(t, jassType)) then
					jStream:addVar(field, jassType, nil, toJassValue(val, jassType))
				else
					jStream:addVar(field, jassType)
				end
			end
		end
	end
end