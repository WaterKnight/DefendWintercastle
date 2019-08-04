require 'waterlua'

local configPath = getFolder(io.local_dir())..'config.txt'

local config = configParser(configPath)

--local dataPath = projectPath..[[Scripts\]]
--local specsPath = projectPath..[[Specs\]]

local projectPath = config['project']
local dataPath = config['data']
local specsPath = config['specs']
local buildPath = config['compile']

local toolsPath = [[D:\Warcraft III\Mapping\Compiler\Tools\]]

unwrap(buildPath)

local logDetailedPath = 'luaproachLogDetailed.log'

local logDetailed = io.open(logDetailedPath, 'w+')

logDetailed:close()

assert(config, 'no config file '..tostring(configPath))

log('projectPath', projectPath)
log('dataPath', dataPath)
log('specsPath', specsPath)
log('mapPath', mapPath)
log('------------------------------')

local runable = true

--runTool([[Tools\objectMorper\objectMorpher.lua]], {buildPath})

--merge objects
if not runTool(toolsPath..[[builder\loader.lua]], {dataPath, specsPath}) then
	return
end

if not runTool(toolsPath..[[builder\objectBuilder.lua]], {dataPath, buildPath, specsPath}) then
	return
end

local objectBuilderOutputPath =  toolsPath..[[builder\output\]]

runTool('mapMerger', {buildPath, objectBuilderOutputPath})

if true then
	return
end


if not runTool(toolsPath..[[WEPlacements\WEPlacements.lua]], {dataPath, buildPath}) then
	return
end

--import files
local jassHelperPath = [[Tools\jassnewgenpack5d\]]

local jassHelperCustomWEPath = jassHelperPath..[[CustomWE\]]

flushDir(jassHelperCustomWEPath)

copyDir([[Tools\builder\GeneratedImports]], jassHelperCustomWEPath, true)
copyDir([[Tools\builder\GeneratedImports]], buildPath, true)

--jassHelper and script
if not runTool(toolsPath..[[beforeJasshelper\beforeJasshelper.lua]], {buildPath..'war3map.j', buildPath..'war3map.j', dataPath}) then
	return
end

local jassErrorPath = [[Tools\jassnewgenpack5d\jasshelper\jassParserCLIErrors.txt]]

removeFile(jassErrorPath:quote())
--[[D:\Warcraft III\Mapping\Compiler\Tools\jassnewgenpack5d\jasshelper\jasshelper2.exe]]
local res, errorMsg = runToolEx('jasshelper', {'--scriptonly', [[jasshelper\common.j]], [[jasshelper\blizzard.j]], buildPath..[[war3map.j]], buildPath..[[war3map.j]]})

if not res then
	error(tostring(errorMsg))
end

if io.pathExists([[Tools\jassnewgenpack5d\logs\compileerrors.txt]]) then
	return
end

if not runTool([[Tools\jassnewgenpack5d\jasshelper\pjassStart.bat]], {buildPath..[[war3map.j]]}) then
	return
end

--funcSorter
if not runTool(toolsPath..[[funcSorter\starter.bat]], {buildPath}) then
	return
end

--info file
if not runTool(toolsPath..[[infoFiler\starter.bat]], {buildPath, buildNum}) then
	return
end

--skinEdit
--if not runTool(toolsPath..[[skinEdit\starter.bat]], {dataPath, buildPath}) then
--	return
--end

--header
runTool([[addHeader.lua]], {outputPath})

pack(buildPath)

runTool(toolsPath..[[wc3Optimizer\start.bat]], {mapPath, mapPath})