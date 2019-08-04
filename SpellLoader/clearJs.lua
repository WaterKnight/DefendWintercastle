function clearJs()
	for line in io.popen([[dir "..\Scripts\*obj_*.j" /b /s]]):lines() do
	    os.remove(line)
	end
	
	for line in io.popen([[dir "..\Scripts\*obj.j" /b /s]]):lines() do
	    os.remove(line)
	end
end

clearJs()