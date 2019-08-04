umswe.setarchive("umswe\\umswe.mpq")

 -- enable
if umscore then

	-- umswe logo
	umswe.importfile("umswe\\UMSWE.tga","ReplaceableTextures\\WorldEditUI\\UMSWE.tga")
	
	-- trigger category icons
	umswe.importfile("umswe\\Actions-Regions.tga","ReplaceableTextures\\WorldEditUI\\Actions-Regions.tga")
	umswe.importfile("umswe\\Actions-Success.tga","ReplaceableTextures\\WorldEditUI\\Actions-Success.tga")
	umswe.importfile("umswe\\Actions-Trackable.tga","ReplaceableTextures\\WorldEditUI\\Actions-Trackable.tga")
	umswe.importfile("umswe\\Actions-Compatibility.tga","ReplaceableTextures\\WorldEditUI\\Actions-Compatibility.tga")

	-- file example
	-- umswe.importorigfile("TerrainArt\\CliffTypes.slk","TerrainArt\\CliffTypes.slk")
	-- umswe.importorigsubfile("O.mpq","ReplaceableTextures\\Cliff\\Cliff0.blp","ReplaceableTextures\\Cliff\\Cliff0.blp")

else -- disable
	
	umswe.deletefile("ReplaceableTextures\\WorldEditUI\\UMSWE.tga")
	umswe.deletefile("ReplaceableTextures\\WorldEditUI\\Actions-Regions.tga")
	umswe.deletefile("ReplaceableTextures\\WorldEditUI\\Actions-Success.tga")
	umswe.deletefile("ReplaceableTextures\\WorldEditUI\\Actions-Trackable.tga")
	umswe.deletefile("ReplaceableTextures\\WorldEditUI\\Actions-Compatibility.tga")
	
end
