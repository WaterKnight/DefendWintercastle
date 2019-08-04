params = {...}

local t = os.clock()

os.execute('@echo | call "runOptimizer.bat" "'..params[1]..'" "'..params[2]..'"')

print(os.clock()-t)

os.execute("pause")