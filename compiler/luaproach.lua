require "fileLib"
require "stringLib"

logPath = "luaproachLog.log"

log = io.open(logPath, "w+")

logDetailedPath = "luaproachLogDetailed.log"

logDetailed = io.open(logDetailedPath, "w+")

logDetailed:close()

tempC = 0

os.execute('rd tempCalls /s /q')
os.execute('mkdir tempCalls')

	function cutFloat(a)
		return (math.floor(a * 100) / 100)
	end

	function runOs(cmd, args, options, fromFolder, doNotWait, name)
		cmd = cmd:gsub('/', '\\')

		local fileName = getFileName(cmd)
		local folder = getFolder(cmd)

		--if doNotWait then
		--	cmd = fileName
		--else
			if (folder and (folder ~= "")) then
				cmd = cmd:quote()
			end
		--end

		if options then
			for k, v in pairs(options) do
				v = tostring(v)

				options[k] = '/'..v
			end

			options = table.concat(options, ' ')

			cmd = cmd..' '..options
		end

		if args then
			for k, v in pairs(args) do
				v = tostring(v)

				args[k] = v:quote()
			end

			args = table.concat(args, ' ')

			cmd = cmd..' '..args
		end

		tempC = tempC + 1

		local tempFilePath = [[tempCalls\temp]]..tempC..[[.bat]]

		local file = io.open(tempFilePath, 'w+')

		if fromFolder then
			file:write('cd /d '..fromFolder:quote()..'\n')
		end

		if doNotWait then
			file:write(cmd)
		else
			if name then
				file:write('@echo | call '..cmd)
			else
				file:write(cmd)
			end

			file:write("\nexit")
		end

		file:close()

		os.execute("@echo OFF")
		if doNotWait then
			os.execute('start /min '..tempFilePath..' 2>>NUL')
		else
			if (name == nil) then
				name = ""
			end

			os.execute('start /wait /min '..name:quote()..' '..tempFilePath..' >> '..logDetailedPath:quote()..' 2>>NUL')
		end
		os.execute("@echo ON")
	end

	function runProg(interpreter, path, args, doNotWait)
		path = path:gsub('/', '\\')

		local folder = getFolder(path)
		local fileName = getFileName(path)

		if interpreter then
			if args then
				local tmp = {}

				for k, v in pairs(args) do
					tmp[k] = v
				end

				for k, v in pairs(tmp) do
					args[k + 1] = v
				end
			else
				args = {}
			end

			args[1] = path
		end

		local t = os.clock()

		print('run '..path)

		if interpreter then
			runOs(interpreter, args, nil, folder, doNotWait, nil)
		else
			runOs(path, args, nil, folder, doNotWait, path)
		end

		log:write('finished '..path..' after '..cutFloat(os.clock() - t)..' seconds\n')
		io.write(' - '..cutFloat(os.clock() - t)..'seconds\n')
	end

function start(params)
	local time = os.clock()

	--folder = getFolder(params[1])

	--params[3] = folder..params[3]

	local map = params[4]

	if (map == nil) then
		local f = io.open('curMapPath.txt', 'r')

		if f then
			map = f:read('*a')

			f:close()
		end
	end

	if (map == nil) then
		print([[no map found]])
		os.execute('pause')

		return
	end

	local f = io.open('curMapPath.txt', 'w+')

	f:write(map)

	f:close()

	local f = io.open(map, 'r')

	if (f == nil) then
		print([[cannot open map ]]..map)
		os.execute('pause')

		return
	end

	f:close()

	local buildNum

	local f = io.open('curBuildNum.txt', 'r')

	if f then
		buildNum = f:read('*a')

		f:close()
	end

	if (buildNum == nil) then
		print([[no buildNum]])
		os.execute('pause')

		return
	end

	buildNum = buildNum + 1

	local f = io.open('curBuildNum.txt', 'w+')

	f:write(buildNum)

	f:close()

	local targetPath = map..'Build'

	runOs([[mkdir]], {targetPath})

	local mapFileName = getFileName(map)
	local mapFolder = getFolder(map)

	local rootPath = [[D:\Warcraft III\Mapping\DWC\Scripts]]
	local buildPath = [[D:\Warcraft III\Mapping\DWC\compiler\Build]]

	local inputPath = [[D:\Warcraft III\Mapping\DWC\compiler\input.w3x]]
	local outputPath = [[D:\Warcraft III\Mapping\DWC\compiler\output.w3x]]

	os.remove(outputPath)

	copyFile(map, inputPath)

	os.execute([[rd /s /q ]]..buildPath:quote())

	local function portData(data)
		local f = io.open('portDataScript.txt', 'w+')

		f:write(data)

		f:close()

		runOs([[D:\Warcraft III\Mapping\Tools\Ladik\MPQEditor.exe]], {'portDataScript.txt'}, {'console'})
	end	

	portData([[

rd ]]..buildPath:quote()..[[ /s /q

mkdir Build

e ]]..inputPath:quote()..[[ * ]]..buildPath:quote()..[[ /fp

del ]]..(buildPath..[[\(attributes)]]):quote()..[[

del ]]..(buildPath..[[\(listfile)]]):quote()..[[

exit

]])

	runProg('lua', [[D:\Warcraft III\Mapping\DWC\Tools\ObjectMorpher\objectMorpher.lua]], {buildPath})

	runProg('lua', [[D:\Warcraft III\Mapping\DWC\SpellLoader\loader.lua]])

	--merge objects
	--runProg('lua', [[D:\Warcraft III\Mapping\DWC\SpellLoader\ObjectBuilderInput.lua]])
	runProg(nil, [[D:\Warcraft III\Mapping\DWC\SpellLoader\merge.bat]], {rootPath, buildPath})

	--import files
	local jassHelperPath = [[D:\Warcraft III\Mapping\DWC\Tools\jassnewgenpack5d]]

	runOs('xcopy', {[[D:\Warcraft III\Mapping\DWC\SpellLoader\GeneratedImports]], jassHelperPath..[[\CustomWE]]}, {'E', 'I', 'Y'})
	runOs('xcopy', {[[D:\Warcraft III\Mapping\DWC\SpellLoader\GeneratedImports]], buildPath}, {'E', 'I', 'Y'})

	--import credits.txt
	runOs('xcopy', {[[D:\Warcraft III\Mapping\DWC\credits.txt]], buildPath}, {'E', 'I', 'Y'})

	--jassHelper and script
	runProg(nil, [[D:\Warcraft III\Mapping\DWC\Tools\BeforeJasshelper\starter.bat]], {buildPath})

	local f = io.open([[D:\Warcraft III\Mapping\DWC\Tools\BeforeJasshelper\returnFail.txt]], 'r')

	if f then
		f:close()
		runable = false

		print('there were errors')
		os.execute('pause')

		return
	end

	local jassHelperArgs = {jassHelperPath, [[D:\Warcraft III\Mapping\DWC\Tools\jassnewgenpack5d\jasshelper\common.j]], [[D:\Warcraft III\Mapping\DWC\Tools\jassnewgenpack5d\jasshelper\blizzard.j]], buildPath..[[\war3map.j]], buildPath..[[\war3map.j]]}

	local jassErrorPath = [[D:\Warcraft III\Mapping\DWC\Tools\jassnewgenpack5d\jasshelper\jassParserCLIErrors.txt]]

	os.remove(jassErrorPath:quote())

	runProg(nil, [[D:\Warcraft III\Mapping\DWC\compiler\jassHelperStarter.bat]], jassHelperArgs)

	runable = true

	local f = io.open([[D:\Warcraft III\Mapping\DWC\Tools\jassnewgenpack5d\logs\compileerrors.txt]], 'r')

	if f then
		f:close()
		runable = false

		print('there were errors')
		os.execute('pause')

		return
	end

	runProg(nil, [[D:\Warcraft III\Mapping\DWC\Tools\jassnewgenpack5d\jasshelper\pjassStart.bat]], {buildPath..[[\war3map.j]]})

	local f = io.open(jassErrorPath, 'r')

	if f then
		local content = f:read('*a')

		if ((content ~= nil) and (content ~= '')) then
			runable = false

			f:close()

			os.execute((buildPath..[[\war3map.j]]):quote())
			os.execute(jassErrorPath:quote())

			print('there were errors')
			os.execute('pause')

			return
		end
		f:close()
	else
		print('could not open '..jassErrorPath)
	end

	--funcSorter
	runProg(nil, [[D:\Warcraft III\Mapping\DWC\Tools\FuncSorter\starter.bat]], {buildPath})

	--info file
	runProg(nil, [[D:\Warcraft III\Mapping\DWC\Tools\InfoFiler\starter.bat]], {buildPath, buildNum})

	--skinEdit
	--runProg(nil, [[D:\Warcraft III\Mapping\DWC\Tools\SkinEdit\starter.bat]], {rootPath, buildPath})

	--finished
	print('finished')

	portData([[

del ]]..outputPath:quote()..[[

n ]]..outputPath:quote()..[[

a ]]..outputPath:quote()..[[ ]]..(buildPath..[[\*]]):quote()..[[ /auto /r

REM htsize ]]..outputPath:quote()..[[ 0x2000

exit

]])

	--header
	runProg('lua', [[D:\Warcraft III\Mapping\DWC\compiler\addHeader.lua]], {outputPath})

	if runable then
		print("compiled in "..os.clock() - time.." seconds")

		local outputOptPath = getFolder(outputPath)..getFileName(outputPath, true).."_opt.w3x"

		runProg(nil, [[D:\Warcraft III\Mapping\DWC\Tools\Wc3Optimizer\runOptimizer.bat]], {outputPath, outputOptPath})

		local copyPath = [[D:\Warcraft III\Maps\FA\dwctest\dwc]]..buildNum..[[.w3x]]

		runOs([[A>]]..copyPath:quote())

		runOs('copy', {outputOptPath, copyPath}, {'Y'})

		runProg("lua", [[D:\Warcraft III\Mapping\DWC\Tools\logTracker.lua]], {true}, true)
print(outputOptPath)
os.execute("pause")
		runProg(nil, [[D:\Warcraft III\windowStart.bat]], {outputOptPath})
	else
		print('there were errors')
		os.execute('pause')
	end
end

params = {...}

start(params)

--	local outputPath = [[D:\Warcraft III\Mapping\DWC\compiler\output.w3x]]

--		local outputOptPath = getFolder(outputPath)..getFileName(outputPath, true).."_opt.w3x"

--		runProg("lua", [[D:\Warcraft III\Mapping\DWC\Tools\logTracker.lua]], {true}, true)

--		runProg(nil, [[D:\Warcraft III\windowStart.bat]], {outputOptPath})

log:close()