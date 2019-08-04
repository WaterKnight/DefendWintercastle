require "stringLib"

params = {...}

map = params[1]

file = io.open("exportMapScript.txt", "w+")

file:write([[

rd Build /s /q

mkdir Build

e ]]..map:quote()..[[ * Build /fp

del Build\(attributes)
del Build\(listfile)

del test.w3x

n test.w3x
a test.w3x Build\* /auto /r

htsize test.w3x 0x2000

exit

]])

file:close()

print("here exportMapData.lua")

os.execute([[D:\Warcra~1\Maps\Tools\Ladik\MPQEditor.exe /console exportMapScript.txt]])

print("end exportMapData.lua")

os.execute("pause")