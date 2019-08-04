umswe.setarchive("umswe\\umswe.mpq")

 -- enable
if umstiles then

	-- load files if needed
	umswe.registerslk("Units\\UnitBalance.slk","unitbalance")
	umswe.registerslk("Units\\DestructableData.slk","destdata")
	-- umswe.registerslk("Doodads\\Doodads.slk","dooddata")
	
	-- apply changes
	umswe.applyall(destdata,"tilesets","*") -- for non tileset specific destructables
	umswe.applyall(unitbalance,"tilesets","*") -- for non tileset specific creeps
	-- umswe.applyall(dooddata,"tilesets","*") -- for non tileset specific doodads

else -- disable
	
	umswe.deletefile("Units\\UnitBalance.slk")
	umswe.deletefile("Units\\DestructableData.slk")
	-- umswe.deletefile("Doodads\\Doodads.slk")
	
end
