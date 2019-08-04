local params = {...}

log = params[1]
replaceErrors = params[2]
pathMap = params[3]
allObjsByName = params[4]

function getObjByName(extension, name)
	local result

	if allObjsByName[extension] then
		result = allObjsByName[extension][name]
	end

	if (result == nil) then
		for k, v in pairs(allObjsByName) do
			if allObjsByName[k][name] then
				result = allObjsByName[k][name]
			end
		end
	end

	if result then
		return result
	end

	log:write("getObjByName: obj "..name.." does not exist")

	return nil
end

function pathToFullPath(base, value, mainExtension)
	value = value:dequote()

	local name = value

	if ((value:find(".wc3", 1, true) == nil) and mainExtension) then
		value = value.."."..mainExtension
	end

	local result

	if base then
		result = getRefPath(getFolder(base))..value

		if pathMap[result] then
			return pathMap[result]
		end
	end

	result = [[D:\Warcraft III\Maps\DWC\Scripts\]]..value

	if pathMap[result] then
		return pathMap[result]
	end

	result = getObjByName(mainExtension, reduceName(name))

	if pathMap[result] then
		return pathMap[result]
	end

	return nil
end

	require "Color"

	function encolor(a, col)
		return col..string.gsub(a, Color.RESET, col)..Color.RESET
	end

	function engold(a)
		return encolor(a, Color.GOLD)
	end

	function replace(a, sub, rep)
		if (rep == nil) then
			rep = ""
		end

		while a:find(sub, 1, true) do
			a = a:sub(1, a:find(sub, 1, true) - 1)..rep..a:sub(a:find(sub, 1, true) + rep:len() + 1, a:len())
		end

		return a
	end

	function replaceTags(path, a, lv, doColor)
		a = a:gsub("<level>", lv)
		a = a:gsub("<prevLevel>", lv - 1)

		if sharedBuffs then
			if sharedBuffs[lv] then
				for key, buff in pairs(sharedBuffs[lv]) do
					local searchStart = "<"..buff..">"
					local searchEnd = "</"..buff..">"

					while a:find(searchStart, 1, true) do
						local tagStart = a:find(searchStart, 1, true)

						local tagEnd = a:find(searchEnd, tagStart, true)

						if tagEnd then
							a = a:sub(1, tagStart + searchStart:len() - 1)..encolor(a:sub(tagStart + searchStart:len(), tagEnd - 1), BUFF_COLOR[buff])..a:sub(tagEnd + searchEnd:len(), a:len())
						end

						a = a:sub(1, tagStart - 1)..a:sub(tagStart + searchStart:len(), a:len())
					end

					a = a:gsub(searchEnd, "")
				end
			end
		end

		while a:find("<", 1, true) do
			local tagStart = a:find("<", 1, true)

			if a:find(">", tagStart, true) then
				local tagEnd = a:find(">", tagStart, true)

				local field = a:sub(tagStart + 1, tagEnd - 1)
				local targetPath

				if field:find(":", 1, true) then
					targetPath = pathToFullPath(path, field:sub(1, field:find(":", 1, true) - 1), "wc3obj")

					field = field:sub(field:find(":", 1, true) + 1, field:len())
				else
					targetPath = path
				end

				local mods = {}

				if field:find(",", 1, true) then
					mods = field:sub(field:find(",", 1, true) + 1, field:len()):split(",")

					field = field:sub(1, field:find(",", 1, true) - 1)
				end

				local lastChar = field:sub(field:len(), field:len())
				local level
				local pos = 1

				while tonumber(lastChar) do
					if (level == nil) then
						level = 0
					end

					level = level + tonumber(lastChar) * pos

					field = field:sub(1, field:len() - 1)

					lastChar = field:sub(field:len(), field:len())
					pos = pos + 1
				end

				if (level == nil) then
					level = lv
				end

				local obj = allObjVals[targetPath]

				if obj then
					if (obj[field] and (obj[field][level] or obj[field][1])) then
						local c = 1
						local val

						if obj[field][level] then
							val = obj[field][level]
						else
							val = obj[field][1]
						end

						while mods[c] do
							if (mods[c] == "%") then
								if tonumber(val) then
									val = val * 100

									val = val.."%"
								end
							end

							c = c + 1
						end

						if doColor then
							val = engold(val)
						end

						a = a:sub(1, tagStart)..val..a:sub(tagEnd, a:len())
					else
						a = a:sub(1, tagStart)..engold("$"..field.."$")..a:sub(tagEnd, a:len())
						replaceErrors:write("\n\nin '"..path.."'\n\t".."cannot find field '"..field.."' ("..level..") of '"..targetPath.."'")
					end
				else
					a = a:sub(1, tagStart - 1)..engold("$"..a:sub(tagStart + 1, tagEnd - 1).."$")..a:sub(tagEnd + 1, a:len())
					replaceErrors:write("\n\nin '"..path.."'\n\t".."cannot find obj '"..targetPath.."'")
				end

				a = a:sub(1, a:find(">", tagStart, true) - 1)..a:sub(a:find(">", tagStart, true) + 1, a:len())
			end

			a = a:sub(1, a:find("<", 1, true) - 1)..a:sub(a:find("<", 1, true) + 1, a:len())
		end

		return a
	end