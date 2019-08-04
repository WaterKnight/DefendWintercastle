umswe.setarchive("umswe\\umswe.mpq")

 -- enable
if umspathing then
	
	-- load files
	umswe.registerslk("TerrainArt\\Terrain.slk","terrain")

	function applypathing(tile,build,walk,fly)
		umswe.applyslk(terrain,tile,"buildable",build)
		umswe.applyslk(terrain,tile,"walkable",walk)
		umswe.applyslk(terrain,tile,"flyable",fly)
	end	
	
	umswe.runscript("umswe\\umswepathing.conf.lua") -- apply changes

else -- disable
	
	umswe.deletefile("TerrainArt\\Terrain.slk")
	
end
