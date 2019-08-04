 umswe.setarchive("umswe\\umswe.mpq")
 
 -- enable
if umscategories then
	
	-- load files if needed
	umswe.registerini("UI\\WorldEditStrings.txt","westrings")
	umswe.registerini("Units\\MiscGame.txt","miscgame")
	
	oe={}
	gc={}
	gi={}
	
	umswe.runscript("umswe\\umswecategories.conf.lua") -- load replacements for the prefixes
	
	function replaceprefix(prefix,tab)
	  local first = string.sub(prefix, 1, 1)
	  local repl = tab[first]
	  if repl ~= nil then
	  	return repl .. string.sub(prefix, 2)
	  elseif string.len(prefix) == 1 then
	  	return "";
	  elseif string.sub(prefix, 2, 2) == " " then
	  	return string.sub(prefix, 3)
	  else
	  	return string.sub(prefix, 2)
	  end
	end
	
	function prependcategory(tab,key,prefix)
		prefix = replaceprefix(prefix,tab)
		if prefix ~= "" then
			umswe.prependstr(miscgame,key,prefix)
		end
	end
	
	function addcategory(tab, key, value)
		value = replaceprefix(value,tab)
		umswe.setstr(miscgame,key,value)
	end
	
	-- object editor categories
	-- A=Text
	-- B=Abilities
	-- C=Data
	-- D=Movement
	-- E=Techtree
	-- F=Stats
	-- G=Pathing
	-- H=Editor
	-- I=Sound
	-- J=Art
	-- K=Combat
	prependcategory(oe,"WESTRING_OE_CAT_TEXT","A")
	prependcategory(oe,"WESTRING_OE_CAT_ABILITIES","B")
	prependcategory(oe,"WESTRING_OE_CAT_DATA","C")
	prependcategory(oe,"WESTRING_OE_CAT_MOVEMENT","D")
	prependcategory(oe,"WESTRING_OE_CAT_TECHTREE","E")
	prependcategory(oe,"WESTRING_OE_CAT_STATS","F")
	prependcategory(oe,"WESTRING_OE_CAT_PATHING","G")
	prependcategory(oe,"WESTRING_OE_CAT_EDITOR","H")
	prependcategory(oe,"WESTRING_OE_CAT_SOUND","I")
	prependcategory(oe,"WESTRING_OE_CAT_ART","J")
	prependcategory(oe,"WESTRING_OE_CAT_COMBAT","K")
	
	-- gameplay constants categories
	-- A=Hero
	-- B=Inventory
	-- C=Combat
	-- D=Creeps
	-- E=Upkeep
	-- F=Spells
	-- G=Movement
	-- H=Buildings
	-- I=Range
	-- J=Miscellaneous
	-- K=Gold Mine
	-- L=Time
	-- M=Cancel
	-- N=Techtree
	-- O=Gameplay
	prependcategory(gc,"WESTRING_MISCVAL_MULE","A")
	prependcategory(gc,"WESTRING_MISCVAL_MHEL","A")
	prependcategory(gc,"WESTRING_MISCVAL_HEXR","A")
	prependcategory(gc,"WESTRING_MISCVAL_GEXP","A")
	prependcategory(gc,"WESTRING_MISCVAL_BGXP","A")
	prependcategory(gc,"WESTRING_MISCVAL_MHDX","A")
	prependcategory(gc,"WESTRING_MISCVAL_MXPN","A")
	prependcategory(gc,"WESTRING_MISCVAL_XPN1","A")
	prependcategory(gc,"WESTRING_MISCVAL_XPN2","A")
	prependcategory(gc,"WESTRING_MISCVAL_XPN3","A")
	prependcategory(gc,"WESTRING_MISCVAL_MHRC","A")
	prependcategory(gc,"WESTRING_MISCVAL_MHRL","A")
	prependcategory(gc,"WESTRING_MISCVAL_MHRT","A")
	prependcategory(gc,"WESTRING_MISCVAL_MHAC","A")
	prependcategory(gc,"WESTRING_MISCVAL_MHAL","A")
	prependcategory(gc,"WESTRING_MISCVAL_HRMS","A")
	prependcategory(gc,"WESTRING_MISCVAL_HRMF","A")
	prependcategory(gc,"WESTRING_MISCVAL_HRLF","A")
	prependcategory(gc,"WESTRING_MISCVAL_HAMS","A")
	prependcategory(gc,"WESTRING_MISCVAL_HAMF","A")
	prependcategory(gc,"WESTRING_MISCVAL_HALF","A")
	prependcategory(gc,"WESTRING_MISCVAL_RBFG","A")
	prependcategory(gc,"WESTRING_MISCVAL_RLFG","A")
	prependcategory(gc,"WESTRING_MISCVAL_RBFL","A")
	prependcategory(gc,"WESTRING_MISCVAL_RLFL","A")
	prependcategory(gc,"WESTRING_MISCVAL_RMAF","A")
	prependcategory(gc,"WESTRING_MISCVAL_RBFT","A")
	prependcategory(gc,"WESTRING_MISCVAL_RMTF","A")
	prependcategory(gc,"WESTRING_MISCVAL_AWBF","A")
	prependcategory(gc,"WESTRING_MISCVAL_AWLF","A")
	prependcategory(gc,"WESTRING_MISCVAL_AWBL","A")
	prependcategory(gc,"WESTRING_MISCVAL_AWLL","A")
	prependcategory(gc,"WESTRING_MISCVAL_AWMF","A")
	prependcategory(gc,"WESTRING_MISCVAL_GNXP","A")
	prependcategory(gc,"WESTRING_MISCVAL_GNXA","A")
	prependcategory(gc,"WESTRING_MISCVAL_GNXB","A")
	prependcategory(gc,"WESTRING_MISCVAL_GNXC","A")
	prependcategory(gc,"WESTRING_MISCVAL_GHXP","A")
	prependcategory(gc,"WESTRING_MISCVAL_GHFA","A")
	prependcategory(gc,"WESTRING_MISCVAL_GHFB","A")
	prependcategory(gc,"WESTRING_MISCVAL_GHFC","A")
	prependcategory(gc,"WESTRING_MISCVAL_HFXP","A")
	prependcategory(gc,"WESTRING_MISCVAL_SKIF","A")
	prependcategory(gc,"WESTRING_MISCVAL_TXP1","A")
	prependcategory(gc,"WESTRING_MISCVAL_TXP2","A")
	prependcategory(gc,"WESTRING_MISCVAL_TXP3","A")
	prependcategory(gc,"WESTRING_MISCVAL_TXP4","A")
	prependcategory(gc,"WESTRING_MISCVAL_TXP5","A")
	prependcategory(gc,"WESTRING_MISCVAL_TXP6","A")
	prependcategory(gc,"WESTRING_MISCVAL_TXP7","A")
	prependcategory(gc,"WESTRING_MISCVAL_TXP8","A")
	prependcategory(gc,"WESTRING_MISCVAL_TXP9","A")
	prependcategory(gc,"WESTRING_MISCVAL_HALS","A")
	prependcategory(gc,"WESTRING_MISCVAL_SATB","A")
	prependcategory(gc,"WESTRING_MISCVAL_SHPB","A")
	prependcategory(gc,"WESTRING_MISCVAL_SREB","A")
	prependcategory(gc,"WESTRING_MISCVAL_IMAB","A")
	prependcategory(gc,"WESTRING_MISCVAL_IMRB","A")
	prependcategory(gc,"WESTRING_MISCVAL_ADEB","A")
	prependcategory(gc,"WESTRING_MISCVAL_ADBA","A")
	prependcategory(gc,"WESTRING_MISCVAL_AMVB","A")
	prependcategory(gc,"WESTRING_MISCVAL_AASB","A")
	prependcategory(gc,"WESTRING_MISCVAL_DROP","B")
	prependcategory(gc,"WESTRING_MISCVAL_GIVE","B")
	prependcategory(gc,"WESTRING_MISCVAL_PICK","B")
	prependcategory(gc,"WESTRING_MISCVAL_PAIR","B")
	prependcategory(gc,"WESTRING_MISCVAL_PAIF","B")
	prependcategory(gc,"WESTRING_MISCVAL_CFHR","C")
	prependcategory(gc,"WESTRING_MISCVAL_CFHC","C")
	prependcategory(gc,"WESTRING_MISCVAL_DEFA","C")
	prependcategory(gc,"WESTRING_MISCVAL_CTNO","C")
	prependcategory(gc,"WESTRING_MISCVAL_CTPI","C")
	prependcategory(gc,"WESTRING_MISCVAL_CTSI","C")
	prependcategory(gc,"WESTRING_MISCVAL_CTMA","C")
	prependcategory(gc,"WESTRING_MISCVAL_CTCH","C")
	prependcategory(gc,"WESTRING_MISCVAL_CTSP","C")
	prependcategory(gc,"WESTRING_MISCVAL_CTHE","C")
	prependcategory(gc,"WESTRING_MISCVAL_CHTM","C")
	prependcategory(gc,"WESTRING_MISCVAL_EDBO","C")
	prependcategory(gc,"WESTRING_MISCVAL_MDRE","C")
	prependcategory(gc,"WESTRING_MISCVAL_BCNR","D")
	prependcategory(gc,"WESTRING_MISCVAL_NUNR","D")
	prependcategory(gc,"WESTRING_MISCVAL_GUAD","D")
	prependcategory(gc,"WESTRING_MISCVAL_GUAM","D")
	prependcategory(gc,"WESTRING_MISCVAL_GUAT","D")
	prependcategory(gc,"WESTRING_MISCVAL_CCCR","D")
	prependcategory(gc,"WESTRING_MISCVAL_FCAP","E")
	prependcategory(gc,"WESTRING_MISCVAL_UPKU","E")
	prependcategory(gc,"WESTRING_MISCVAL_UPKG","E")
	prependcategory(gc,"WESTRING_MISCVAL_UPKW","E")
	prependcategory(gc,"WESTRING_MISCVAL_SCRB","F")
	prependcategory(gc,"WESTRING_MISCVAL_FROM","F")
	prependcategory(gc,"WESTRING_MISCVAL_FROA","F")
	prependcategory(gc,"WESTRING_MISCVAL_EHBO","F")
	prependcategory(gc,"WESTRING_MISCVAL_MXUS","G")
	prependcategory(gc,"WESTRING_MISCVAL_MNUS","G")
	prependcategory(gc,"WESTRING_MISCVAL_MXBS","G")
	prependcategory(gc,"WESTRING_MISCVAL_MNBS","G")
	prependcategory(gc,"WESTRING_MISCVAL_DBST","H Buildings -")
	prependcategory(gc,"WESTRING_MISCVAL_RZOF","H Buildings -")
	prependcategory(gc,"WESTRING_MISCVAL_BUBR","H Buildings -")
	prependcategory(gc,"WESTRING_MISCVAL_BANG","H Buildings -")
	prependcategory(gc,"WESTRING_MISCVAL_RANG","H Buildings -")
	prependcategory(gc,"WESTRING_MISCVAL_FARR","I Range -")
	prependcategory(gc,"WESTRING_MISCVAL_DFRR","I Range -")
	prependcategory(gc,"WESTRING_MISCVAL_FOLR","I Range -")
	prependcategory(gc,"WESTRING_MISCVAL_FOLS","I Range -")
	prependcategory(gc,"WESTRING_MISCVAL_FOLI","I Range -")
	prependcategory(gc,"WESTRING_MISCVAL_MCOR","I Range -")
	prependcategory(gc,"WESTRING_MISCVAL_DEIN","J Miscellaneous -")
	prependcategory(gc,"WESTRING_MISCVAL_READ","J Miscellaneous -")
	prependcategory(gc,"WESTRING_MISCVAL_ANDE","J Miscellaneous -")
	prependcategory(gc,"WESTRING_MISCVAL_ANRA","J Miscellaneous -")
	prependcategory(gc,"WESTRING_MISCVAL_TRAS","J Miscellaneous -")
	prependcategory(gc,"WESTRING_MISCVAL_TRAL","J Miscellaneous -")
	prependcategory(gc,"WESTRING_MISCVAL_INVS","J Miscellaneous -")
	prependcategory(gc,"WESTRING_MISCVAL_SANT","J Miscellaneous -")
	prependcategory(gc,"WESTRING_MISCVAL_GMMG","K")
	prependcategory(gc,"WESTRING_MISCVAL_LOGA","K")
	prependcategory(gc,"WESTRING_MISCVAL_GMOD","K")
	prependcategory(gc,"WESTRING_MISCVAL_DAYL","L")
	prependcategory(gc,"WESTRING_MISCVAL_DAWN","L")
	prependcategory(gc,"WESTRING_MISCVAL_DUSK","L")
	prependcategory(gc,"WESTRING_MISCVAL_DAYH","L")
	prependcategory(gc,"WESTRING_MISCVAL_BDET","L Time -")
	prependcategory(gc,"WESTRING_MISCVAL_SDET","L Time -")
	prependcategory(gc,"WESTRING_MISCVAL_DECT","L Time -")
	prependcategory(gc,"WESTRING_MISCVAL_DIST","L Time -")
	prependcategory(gc,"WESTRING_MISCVAL_BUDT","L Time -")
	prependcategory(gc,"WESTRING_MISCVAL_EFDT","L Time -")
	prependcategory(gc,"WESTRING_MISCVAL_CADT","L Time -")
	prependcategory(gc,"WESTRING_MISCVAL_FFDT","L Time -")
	prependcategory(gc,"WESTRING_MISCVAL_RRCO","M")
	prependcategory(gc,"WESTRING_MISCVAL_RRRE","M")
	prependcategory(gc,"WESTRING_MISCVAL_RRHR","M")
	prependcategory(gc,"WESTRING_MISCVAL_RRTU","M")
	prependcategory(gc,"WESTRING_MISCVAL_RRBU","M")
	prependcategory(gc,"WESTRING_MISCVAL_CLDR","M")
	prependcategory(gc,"WESTRING_MISCVAL_HERO","N")
	prependcategory(gc,"WESTRING_MISCVAL_TALT","N")
	prependcategory(gc,"WESTRING_MISCVAL_TWN1","N")
	prependcategory(gc,"WESTRING_MISCVAL_TWN2","N")
	prependcategory(gc,"WESTRING_MISCVAL_TWN3","N")
	prependcategory(gc,"WESTRING_MISCVAL_TWN4","N")
	prependcategory(gc,"WESTRING_MISCVAL_TWN5","N")
	prependcategory(gc,"WESTRING_MISCVAL_TWN6","N")
	prependcategory(gc,"WESTRING_MISCVAL_TWN7","N")
	prependcategory(gc,"WESTRING_MISCVAL_TWN8","N")
	prependcategory(gc,"WESTRING_MISCVAL_TWN9","N")
	prependcategory(gc,"WESTRING_MISCVAL_EQNH","N")
	prependcategory(gc,"WESTRING_MISCVAL_EQNA","N")
	prependcategory(gc,"WESTRING_MISCVAL_EQN1","N")
	prependcategory(gc,"WESTRING_MISCVAL_EQN2","N")
	prependcategory(gc,"WESTRING_MISCVAL_EQN3","N")
	prependcategory(gc,"WESTRING_MISCVAL_EQN4","N")
	prependcategory(gc,"WESTRING_MISCVAL_EQN5","N")
	prependcategory(gc,"WESTRING_MISCVAL_EQN6","N")
	prependcategory(gc,"WESTRING_MISCVAL_EQN7","N")
	prependcategory(gc,"WESTRING_MISCVAL_EQN8","N")
	prependcategory(gc,"WESTRING_MISCVAL_EQN9","N")
	prependcategory(gc,"WESTRING_MISCVAL_MIRD","O")
	prependcategory(gc,"WESTRING_MISCVAL_MIRT","O")
	prependcategory(gc,"WESTRING_MISCVAL_MIRL","O")
	prependcategory(gc,"WESTRING_MISCVAL_MIRU","O")
	prependcategory(gc,"WESTRING_MISCVAL_CYST","O")
	prependcategory(gc,"WESTRING_MISCVAL_DCAL","O")
	prependcategory(gc,"WESTRING_MISCVAL_MTCL","O")
	prependcategory(gc,"WESTRING_MISCVAL_DSCL","O")
	prependcategory(gc,"WESTRING_MISCVAL_TPCL","O")
	prependcategory(gc,"WESTRING_MISCVAL_ARCL","O")
	prependcategory(gc,"WESTRING_MISCVAL_MLCL","O")
	prependcategory(gc,"WESTRING_MISCVAL_MADI","O")
	prependcategory(gc,"WESTRING_MISCVAL_ISDD","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDRP","O")
	prependcategory(gc,"WESTRING_MISCVAL_UDRP","O")
	prependcategory(gc,"WESTRING_MISCVAL_AMBO","O")
	prependcategory(gc,"WESTRING_MISCVAL_EIMA","O")
	prependcategory(gc,"WESTRING_MISCVAL_WIMA","O")
	prependcategory(gc,"WESTRING_MISCVAL_IGAB","O")
	prependcategory(gc,"WESTRING_MISCVAL_IASB","O")
	prependcategory(gc,"WESTRING_MISCVAL_IGMB","O")
	prependcategory(gc,"WESTRING_MISCVAL_IGDB","O")
	prependcategory(gc,"WESTRING_MISCVAL_ICRL","O")
	prependcategory(gc,"WESTRING_MISCVAL_ICRM","O")
	prependcategory(gc,"WESTRING_MISCVAL_IBAU","O")
	prependcategory(gc,"WESTRING_MISCVAL_IGAU","O")
	prependcategory(gc,"WESTRING_MISCVAL_INBA","O")
	prependcategory(gc,"WESTRING_MISCVAL_PUBA","O")
	prependcategory(gc,"WESTRING_MISCVAL_BUBA","O")
	prependcategory(gc,"WESTRING_MISCVAL_AUBA","O")
	prependcategory(gc,"WESTRING_MISCVAL_FHBA","O")
	prependcategory(gc,"WESTRING_MISCVAL_MSBS","O")
	prependcategory(gc,"WESTRING_MISCVAL_DUEB","O")
	prependcategory(gc,"WESTRING_MISCVAL_DTLI","O")
	prependcategory(gc,"WESTRING_MISCVAL_DTMA","O")
	prependcategory(gc,"WESTRING_MISCVAL_DGBL","O")
	prependcategory(gc,"WESTRING_MISCVAL_DGBM","O")
	prependcategory(gc,"WESTRING_MISCVAL_EDBA","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDAV","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDAF","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDBS","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDBF","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDBM","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDBU","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDCA","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDCR","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDCF","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDDE","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDDS","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDIM","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDMF","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDMS","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDME","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDRF","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDRG","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDSF","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDSU","O")
	prependcategory(gc,"WESTRING_MISCVAL_CDWW","O")
	prependcategory(gc,"WESTRING_MISCVAL_RUCO","O")
	prependcategory(gc,"WESTRING_MISCVAL_DEDE","O")
	prependcategory(gc,"WESTRING_MISCVAL_ISAR","O")
	prependcategory(gc,"WESTRING_MISCVAL_USAR","O")
	prependcategory(gc,"WESTRING_MISCVAL_ASAR","O")
	
	-- game interface categories
	-- A=Icon
	-- B=Model
	-- C=Image
	-- D=Path
	-- E=Sound
	-- F=Text
	-- G=Chat
	-- H=Font
	prependcategory(gi,"WESTRING_SKINVAL_IDLE","A")
	prependcategory(gi,"WESTRING_SKINVAL_C001","A")
	prependcategory(gi,"WESTRING_SKINVAL_C002","A")
	prependcategory(gi,"WESTRING_SKINVAL_C003","A")
	prependcategory(gi,"WESTRING_SKINVAL_C004","A")
	prependcategory(gi,"WESTRING_SKINVAL_C005","A")
	prependcategory(gi,"WESTRING_SKINVAL_C006","A")
	prependcategory(gi,"WESTRING_SKINVAL_C007","A")
	prependcategory(gi,"WESTRING_SKINVAL_C008","A")
	prependcategory(gi,"WESTRING_SKINVAL_C009","A")
	prependcategory(gi,"WESTRING_SKINVAL_C010","A")
	prependcategory(gi,"WESTRING_SKINVAL_C011","A")
	prependcategory(gi,"WESTRING_SKINVAL_C012","A")
	prependcategory(gi,"WESTRING_SKINVAL_C013","A")
	prependcategory(gi,"WESTRING_SKINVAL_C014","A")
	prependcategory(gi,"WESTRING_SKINVAL_C015","A")
	prependcategory(gi,"WESTRING_SKINVAL_C016","A")
	prependcategory(gi,"WESTRING_SKINVAL_C017","A")
	prependcategory(gi,"WESTRING_SKINVAL_C018","A")
	prependcategory(gi,"WESTRING_SKINVAL_C019","A")
	prependcategory(gi,"WESTRING_SKINVAL_C020","A")
	prependcategory(gi,"WESTRING_SKINVAL_C021","A")
	prependcategory(gi,"WESTRING_SKINVAL_C022","A")
	prependcategory(gi,"WESTRING_SKINVAL_C023","A")
	prependcategory(gi,"WESTRING_SKINVAL_C024","A")
	prependcategory(gi,"WESTRING_SKINVAL_C025","A")
	prependcategory(gi,"WESTRING_SKINVAL_C026","A")
	prependcategory(gi,"WESTRING_SKINVAL_C027","A")
	prependcategory(gi,"WESTRING_SKINVAL_C028","A")
	prependcategory(gi,"WESTRING_SKINVAL_C029","A")
	prependcategory(gi,"WESTRING_SKINVAL_C030","A")
	prependcategory(gi,"WESTRING_SKINVAL_C031","A")
	prependcategory(gi,"WESTRING_SKINVAL_C032","A")
	prependcategory(gi,"WESTRING_SKINVAL_C033","A")
	prependcategory(gi,"WESTRING_SKINVAL_C034","A")
	prependcategory(gi,"WESTRING_SKINVAL_C035","A")
	prependcategory(gi,"WESTRING_SKINVAL_C036","A")
	prependcategory(gi,"WESTRING_SKINVAL_C037","A")
	prependcategory(gi,"WESTRING_SKINVAL_C038","A")
	prependcategory(gi,"WESTRING_SKINVAL_C039","A")
	prependcategory(gi,"WESTRING_SKINVAL_C040","A")
	prependcategory(gi,"WESTRING_SKINVAL_C041","A")
	prependcategory(gi,"WESTRING_SKINVAL_C042","A")
	prependcategory(gi,"WESTRING_SKINVAL_C043","A")
	prependcategory(gi,"WESTRING_SKINVAL_C044","A")
	prependcategory(gi,"WESTRING_SKINVAL_C045","A")
	prependcategory(gi,"WESTRING_SKINVAL_C046","A")
	prependcategory(gi,"WESTRING_SKINVAL_C047","A")
	prependcategory(gi,"WESTRING_SKINVAL_C048","A")
	prependcategory(gi,"WESTRING_SKINVAL_C049","A")
	prependcategory(gi,"WESTRING_SKINVAL_C050","A")
	prependcategory(gi,"WESTRING_SKINVAL_C051","A")
	prependcategory(gi,"WESTRING_SKINVAL_C052","A")
	prependcategory(gi,"WESTRING_SKINVAL_C053","A")
	prependcategory(gi,"WESTRING_SKINVAL_C054","A")
	prependcategory(gi,"WESTRING_SKINVAL_C055","A")
	prependcategory(gi,"WESTRING_SKINVAL_C056","A")
	prependcategory(gi,"WESTRING_SKINVAL_C057","A")
	prependcategory(gi,"WESTRING_SKINVAL_C058","A")
	prependcategory(gi,"WESTRING_SKINVAL_C059","A")
	prependcategory(gi,"WESTRING_SKINVAL_C060","A")
	prependcategory(gi,"WESTRING_SKINVAL_C061","A")
	prependcategory(gi,"WESTRING_SKINVAL_C062","B")
	prependcategory(gi,"WESTRING_SKINVAL_C063","B")
	prependcategory(gi,"WESTRING_SKINVAL_C064","A")
	prependcategory(gi,"WESTRING_SKINVAL_C065","A")
	prependcategory(gi,"WESTRING_SKINVAL_C066","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM01","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM02","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM03","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM04","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM05","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM06","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM07","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM08","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM09","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM10","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM11","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM12","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM13","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM14","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM15","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM16","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM17","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM18","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM19","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM20","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM21","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM22","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM23","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM24","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM25","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM26","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM27","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM28","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM29","A")
	prependcategory(gi,"WESTRING_SKINVAL_CM30","A")
	prependcategory(gi,"WESTRING_SKINVAL_C094","A")
	prependcategory(gi,"WESTRING_SKINVAL_C095","A")
	prependcategory(gi,"WESTRING_SKINVAL_C096","A")
	prependcategory(gi,"WESTRING_SKINVAL_C097","A")
	prependcategory(gi,"WESTRING_SKINVAL_C098","A")
	prependcategory(gi,"WESTRING_SKINVAL_C099","A")
	prependcategory(gi,"WESTRING_SKINVAL_C100","A")
	prependcategory(gi,"WESTRING_SKINVAL_C101","A")
	prependcategory(gi,"WESTRING_SKINVAL_C102","A")
	prependcategory(gi,"WESTRING_SKINVAL_C103","A")
	prependcategory(gi,"WESTRING_SKINVAL_C104","A")
	prependcategory(gi,"WESTRING_SKINVAL_C105","A")
	prependcategory(gi,"WESTRING_SKINVAL_C106","A")
	prependcategory(gi,"WESTRING_SKINVAL_C107","A")
	prependcategory(gi,"WESTRING_SKINVAL_C108","A")
	prependcategory(gi,"WESTRING_SKINVAL_C109","A")
	prependcategory(gi,"WESTRING_SKINVAL_C110","A")
	prependcategory(gi,"WESTRING_SKINVAL_C111","A")
	prependcategory(gi,"WESTRING_SKINVAL_C112","A")
	prependcategory(gi,"WESTRING_SKINVAL_C113","A")
	prependcategory(gi,"WESTRING_SKINVAL_C114","A")
	prependcategory(gi,"WESTRING_SKINVAL_C115","A")
	prependcategory(gi,"WESTRING_SKINVAL_C116","A")
	prependcategory(gi,"WESTRING_SKINVAL_C117","A")
	prependcategory(gi,"WESTRING_SKINVAL_C118","A")
	prependcategory(gi,"WESTRING_SKINVAL_C119","A")
	prependcategory(gi,"WESTRING_SKINVAL_C120","A")
	prependcategory(gi,"WESTRING_SKINVAL_C121","A")
	prependcategory(gi,"WESTRING_SKINVAL_C122","A")
	prependcategory(gi,"WESTRING_SKINVAL_C123","A")
	prependcategory(gi,"WESTRING_SKINVAL_C124","A")
	prependcategory(gi,"WESTRING_SKINVAL_C125","A")
	prependcategory(gi,"WESTRING_SKINVAL_C126","A")
	prependcategory(gi,"WESTRING_SKINVAL_C127","A")
	prependcategory(gi,"WESTRING_SKINVAL_C128","A")
	prependcategory(gi,"WESTRING_SKINVAL_C11A","A")
	prependcategory(gi,"WESTRING_SKINVAL_C11B","A")
	prependcategory(gi,"WESTRING_SKINVAL_M001","B")
	prependcategory(gi,"WESTRING_SKINVAL_M002","B")
	prependcategory(gi,"WESTRING_SKINVAL_M003","B")
	prependcategory(gi,"WESTRING_SKINVAL_M004","B")
	prependcategory(gi,"WESTRING_SKINVAL_M005","B")
	prependcategory(gi,"WESTRING_SKINVAL_M006","B")
	prependcategory(gi,"WESTRING_SKINVAL_M007","B")
	prependcategory(gi,"WESTRING_SKINVAL_M008","B")
	prependcategory(gi,"WESTRING_SKINVAL_M009","B")
	prependcategory(gi,"WESTRING_SKINVAL_M010","B")
	prependcategory(gi,"WESTRING_SKINVAL_M011","B")
	prependcategory(gi,"WESTRING_SKINVAL_M012","B")
	prependcategory(gi,"WESTRING_SKINVAL_M013","B")
	prependcategory(gi,"WESTRING_SKINVAL_M014","B")
	prependcategory(gi,"WESTRING_SKINVAL_M015","B")
	prependcategory(gi,"WESTRING_SKINVAL_M016","B")
	prependcategory(gi,"WESTRING_SKINVAL_M017","B")
	prependcategory(gi,"WESTRING_SKINVAL_M018","B")
	prependcategory(gi,"WESTRING_SKINVAL_M019","B")
	prependcategory(gi,"WESTRING_SKINVAL_M020","B")
	prependcategory(gi,"WESTRING_SKINVAL_M021","B")
	prependcategory(gi,"WESTRING_SKINVAL_M022","B")
	prependcategory(gi,"WESTRING_SKINVAL_M023","B")
	prependcategory(gi,"WESTRING_SKINVAL_M024","B")
	prependcategory(gi,"WESTRING_SKINVAL_M025","B")
	prependcategory(gi,"WESTRING_SKINVAL_M026","B")
	prependcategory(gi,"WESTRING_SKINVAL_M027","B")
	prependcategory(gi,"WESTRING_SKINVAL_M028","B")
	prependcategory(gi,"WESTRING_SKINVAL_M029","B")
	prependcategory(gi,"WESTRING_SKINVAL_M030","B")
	prependcategory(gi,"WESTRING_SKINVAL_M031","B")
	prependcategory(gi,"WESTRING_SKINVAL_M032","B")
	prependcategory(gi,"WESTRING_SKINVAL_M033","B")
	prependcategory(gi,"WESTRING_SKINVAL_M034","B")
	prependcategory(gi,"WESTRING_SKINVAL_M035","B")
	prependcategory(gi,"WESTRING_SKINVAL_M036","B")
	prependcategory(gi,"WESTRING_SKINVAL_M037","B")
	prependcategory(gi,"WESTRING_SKINVAL_M038","B")
	prependcategory(gi,"WESTRING_SKINVAL_M039","B")
	prependcategory(gi,"WESTRING_SKINVAL_I001","C")
	prependcategory(gi,"WESTRING_SKINVAL_I002","C")
	prependcategory(gi,"WESTRING_SKINVAL_I003","C")
	prependcategory(gi,"WESTRING_SKINVAL_I004","C")
	prependcategory(gi,"WESTRING_SKINVAL_I005","C")
	prependcategory(gi,"WESTRING_SKINVAL_I006","C")
	prependcategory(gi,"WESTRING_SKINVAL_I007","C")
	prependcategory(gi,"WESTRING_SKINVAL_I008","C")
	prependcategory(gi,"WESTRING_SKINVAL_I009","C")
	prependcategory(gi,"WESTRING_SKINVAL_I010","C")
	prependcategory(gi,"WESTRING_SKINVAL_I011","C")
	prependcategory(gi,"WESTRING_SKINVAL_I012","C")
	prependcategory(gi,"WESTRING_SKINVAL_I013","C")
	prependcategory(gi,"WESTRING_SKINVAL_I014","C")
	prependcategory(gi,"WESTRING_SKINVAL_I015","C")
	prependcategory(gi,"WESTRING_SKINVAL_I016","C")
	prependcategory(gi,"WESTRING_SKINVAL_I017","C")
	prependcategory(gi,"WESTRING_SKINVAL_I018","C")
	prependcategory(gi,"WESTRING_SKINVAL_I019","C")
	prependcategory(gi,"WESTRING_SKINVAL_I020","C")
	prependcategory(gi,"WESTRING_SKINVAL_I021","C")
	prependcategory(gi,"WESTRING_SKINVAL_I022","C")
	prependcategory(gi,"WESTRING_SKINVAL_I023","C")
	prependcategory(gi,"WESTRING_SKINVAL_I024","C")
	prependcategory(gi,"WESTRING_SKINVAL_I025","C")
	prependcategory(gi,"WESTRING_SKINVAL_I026","C")
	prependcategory(gi,"WESTRING_SKINVAL_I027","C")
	prependcategory(gi,"WESTRING_SKINVAL_I028","C")
	prependcategory(gi,"WESTRING_SKINVAL_I029","C")
	prependcategory(gi,"WESTRING_SKINVAL_I030","C")
	prependcategory(gi,"WESTRING_SKINVAL_I031","C")
	prependcategory(gi,"WESTRING_SKINVAL_I032","C")
	prependcategory(gi,"WESTRING_SKINVAL_I033","C")
	prependcategory(gi,"WESTRING_SKINVAL_I034","C")
	prependcategory(gi,"WESTRING_SKINVAL_I035","C")
	prependcategory(gi,"WESTRING_SKINVAL_I036","C")
	prependcategory(gi,"WESTRING_SKINVAL_I037","C")
	prependcategory(gi,"WESTRING_SKINVAL_I038","C")
	prependcategory(gi,"WESTRING_SKINVAL_I039","C")
	prependcategory(gi,"WESTRING_SKINVAL_I040","C")
	prependcategory(gi,"WESTRING_SKINVAL_I041","C")
	prependcategory(gi,"WESTRING_SKINVAL_I042","C")
	prependcategory(gi,"WESTRING_SKINVAL_I043","C")
	prependcategory(gi,"WESTRING_SKINVAL_I044","C")
	prependcategory(gi,"WESTRING_SKINVAL_I045","C")
	prependcategory(gi,"WESTRING_SKINVAL_I046","C")
	prependcategory(gi,"WESTRING_SKINVAL_I047","C")
	prependcategory(gi,"WESTRING_SKINVAL_I048","C")
	prependcategory(gi,"WESTRING_SKINVAL_I049","C")
	prependcategory(gi,"WESTRING_SKINVAL_I050","C")
	prependcategory(gi,"WESTRING_SKINVAL_I051","C")
	prependcategory(gi,"WESTRING_SKINVAL_I052","C")
	prependcategory(gi,"WESTRING_SKINVAL_I053","C")
	prependcategory(gi,"WESTRING_SKINVAL_I054","C")
	prependcategory(gi,"WESTRING_SKINVAL_I055","C")
	prependcategory(gi,"WESTRING_SKINVAL_I056","C")
	prependcategory(gi,"WESTRING_SKINVAL_I057","C")
	prependcategory(gi,"WESTRING_SKINVAL_I058","C")
	prependcategory(gi,"WESTRING_SKINVAL_I059","C")
	prependcategory(gi,"WESTRING_SKINVAL_I060","C")
	prependcategory(gi,"WESTRING_SKINVAL_I061","C")
	prependcategory(gi,"WESTRING_SKINVAL_I062","C")
	prependcategory(gi,"WESTRING_SKINVAL_I063","C")
	prependcategory(gi,"WESTRING_SKINVAL_I064","C")
	prependcategory(gi,"WESTRING_SKINVAL_I065","C")
	prependcategory(gi,"WESTRING_SKINVAL_I066","C")
	prependcategory(gi,"WESTRING_SKINVAL_I067","C")
	prependcategory(gi,"WESTRING_SKINVAL_I068","C")
	prependcategory(gi,"WESTRING_SKINVAL_I069","C")
	prependcategory(gi,"WESTRING_SKINVAL_I070","C")
	prependcategory(gi,"WESTRING_SKINVAL_I071","C")
	prependcategory(gi,"WESTRING_SKINVAL_I072","C")
	prependcategory(gi,"WESTRING_SKINVAL_I073","C")
	prependcategory(gi,"WESTRING_SKINVAL_I074","C")
	prependcategory(gi,"WESTRING_SKINVAL_I075","C")
	prependcategory(gi,"WESTRING_SKINVAL_I076","C")
	prependcategory(gi,"WESTRING_SKINVAL_I077","C")
	prependcategory(gi,"WESTRING_SKINVAL_I078","C")
	prependcategory(gi,"WESTRING_SKINVAL_I079","C")
	prependcategory(gi,"WESTRING_SKINVAL_I080","C")
	prependcategory(gi,"WESTRING_SKINVAL_I081","C")
	prependcategory(gi,"WESTRING_SKINVAL_I082","C")
	prependcategory(gi,"WESTRING_SKINVAL_I083","C")
	prependcategory(gi,"WESTRING_SKINVAL_I084","C")
	prependcategory(gi,"WESTRING_SKINVAL_I085","C")
	prependcategory(gi,"WESTRING_SKINVAL_I086","C")
	prependcategory(gi,"WESTRING_SKINVAL_I087","C")
	prependcategory(gi,"WESTRING_SKINVAL_I088","C")
	prependcategory(gi,"WESTRING_SKINVAL_I089","C")
	prependcategory(gi,"WESTRING_SKINVAL_I090","C")
	prependcategory(gi,"WESTRING_SKINVAL_I091","C")
	prependcategory(gi,"WESTRING_SKINVAL_I092","C")
	prependcategory(gi,"WESTRING_SKINVAL_I093","C")
	prependcategory(gi,"WESTRING_SKINVAL_I094","C")
	prependcategory(gi,"WESTRING_SKINVAL_I095","C")
	prependcategory(gi,"WESTRING_SKINVAL_I096","C")
	prependcategory(gi,"WESTRING_SKINVAL_I097","C")
	prependcategory(gi,"WESTRING_SKINVAL_I098","C")
	prependcategory(gi,"WESTRING_SKINVAL_I099","C")
	prependcategory(gi,"WESTRING_SKINVAL_I100","C")
	prependcategory(gi,"WESTRING_SKINVAL_I101","C")
	prependcategory(gi,"WESTRING_SKINVAL_PAT1","D")
	prependcategory(gi,"WESTRING_SKINVAL_PAT2","D")
	prependcategory(gi,"WESTRING_SKINVAL_PAT3","D")
	prependcategory(gi,"WESTRING_SKINVAL_S000","E")
	prependcategory(gi,"WESTRING_SKINVAL_S001","E")
	prependcategory(gi,"WESTRING_SKINVAL_S002","E")
	prependcategory(gi,"WESTRING_SKINVAL_S003","E")
	prependcategory(gi,"WESTRING_SKINVAL_S004","E")
	prependcategory(gi,"WESTRING_SKINVAL_S005","E")
	prependcategory(gi,"WESTRING_SKINVAL_S006","E")
	prependcategory(gi,"WESTRING_SKINVAL_S007","E")
	prependcategory(gi,"WESTRING_SKINVAL_S008","E")
	prependcategory(gi,"WESTRING_SKINVAL_S009","E")
	prependcategory(gi,"WESTRING_SKINVAL_S010","E")
	prependcategory(gi,"WESTRING_SKINVAL_S011","E")
	prependcategory(gi,"WESTRING_SKINVAL_S012","E")
	prependcategory(gi,"WESTRING_SKINVAL_S013","E")
	prependcategory(gi,"WESTRING_SKINVAL_S014","E")
	prependcategory(gi,"WESTRING_SKINVAL_S015","E")
	prependcategory(gi,"WESTRING_SKINVAL_S016","E")
	prependcategory(gi,"WESTRING_SKINVAL_S017","E")
	prependcategory(gi,"WESTRING_SKINVAL_S018","E")
	prependcategory(gi,"WESTRING_SKINVAL_SOU1","E")
	prependcategory(gi,"WESTRING_SKINVAL_SOU2","E")
	prependcategory(gi,"WESTRING_SKINVAL_FRAMEDEF_DEFAULT","F")
	prependcategory(gi,"WESTRING_SKINVAL_ERROR_DEFAULT","F")
	prependcategory(gi,"WESTRING_SKINVAL_FUH2","F")
	prependcategory(gi,"WESTRING_SKINVAL_FUH3","F")
	prependcategory(gi,"WESTRING_SKINVAL_FUH4","F")
	prependcategory(gi,"WESTRING_SKINVAL_FUH5","F")
	prependcategory(gi,"WESTRING_SKINVAL_FUH6","F")
	prependcategory(gi,"WESTRING_SKINVAL_FUH7","F")
	prependcategory(gi,"WESTRING_SKINVAL_FUH8","F")
	prependcategory(gi,"WESTRING_SKINVAL_CAT1","F")
	prependcategory(gi,"WESTRING_SKINVAL_CAT2","F")
	prependcategory(gi,"WESTRING_SKINVAL_CAT3","F")
	prependcategory(gi,"WESTRING_SKINVAL_CAT4","F")
	
	-- new category entries
	addcategory(gi,"WESTRING_COMMANDSTRRAL0","F Text - Tooltip - Rallypoint")
	addcategory(gi,"WESTRING_COMMANDSTRRAL1","F Text - Ubertip - Rallypoint")
	addcategory(gi,"WESTRING_COMMANDSTRRAL2","F Text - Hotkey - Rallypoint")
	addcategory(gi,"WESTRING_COMMANDSTRCAN1","F Text - Ubertip - Cancel")
	addcategory(gi,"WESTRING_COMMANDSTRCAN2","F Text - Hotkey - Cancel")
	addcategory(gi,"WESTRING_COMMANDSTRCAN0","F Text - Tooltip - Cancel")
	addcategory(gi,"WESTRING_COMMANDSTRCANB0","F Text - Tooltip - Cancel Build")
	addcategory(gi,"WESTRING_COMMANDSTRCANB1","F Text - Ubertip - Cancel Build")
	addcategory(gi,"WESTRING_COMMANDSTRCANB2","F Text - Hotkey - Cancel Build")
	addcategory(gi,"WESTRING_COMMANDSTRCANT0","F Text - Tooltip - Cancel Train")
	addcategory(gi,"WESTRING_COMMANDSTRCANT1","F Text - Ubertip - Cancel Train")
	addcategory(gi,"WESTRING_COMMANDSTRCANT2","F Text - Hotkey - Cancel Train")
	addcategory(gi,"WESTRING_COMMANDSTRCANR0","F Text - Tooltip - Cancel Revive")
	addcategory(gi,"WESTRING_COMMANDSTRCANR1","F Text - Ubertip - Cancel Revive")
	addcategory(gi,"WESTRING_COMMANDSTRCANR2","F Text - Hotkey - Cancel Revive")
	addcategory(gi,"WESTRING_COMMANDSTRHOL0","F Text - Tooltip - Hold Position")
	addcategory(gi,"WESTRING_COMMANDSTRHOL1","F Text - Ubertip - Hold Position")
	addcategory(gi,"WESTRING_COMMANDSTRHOL2","F Text - Hotkey - Hold Position")
	addcategory(gi,"WESTRING_COMMANDSTRPAT0","F Text - Tooltip - Patrol")
	addcategory(gi,"WESTRING_COMMANDSTRPAT1","F Text - Ubertip - Patrol")
	addcategory(gi,"WESTRING_COMMANDSTRPAT2","F Text - Hotkey - Patrol")
	addcategory(gi,"WESTRING_COMMANDSTRSTP0","F Text - Tooltip - Stop")
	addcategory(gi,"WESTRING_COMMANDSTRSTP1","F Text - Ubertip - Stop")
	addcategory(gi,"WESTRING_COMMANDSTRSTP2","F Text - Hotkey - Stop")
	addcategory(gi,"WESTRING_COMMANDSTRATG0","F Text - Tooltip - Attack Ground")
	addcategory(gi,"WESTRING_COMMANDSTRATG1","F Text - Ubertip - Attack Ground")
	addcategory(gi,"WESTRING_COMMANDSTRATG2","F Text - Hotkey - Attack Ground")
	addcategory(gi,"WESTRING_COMMANDSTRSKL0","F Text - Tooltip - Select Hero Skill")
	addcategory(gi,"WESTRING_COMMANDSTRSKL1","F Text - Ubertip - Select Hero Skill")
	addcategory(gi,"WESTRING_COMMANDSTRSKL2","F Text - Hotkey - Select Hero Skill")
	addcategory(gi,"WESTRING_COMMANDSTRMOV0","F Text - Tooltip - Move")
	addcategory(gi,"WESTRING_COMMANDSTRMOV1","F Text - Ubertip - Move")
	addcategory(gi,"WESTRING_COMMANDSTRMOV2","F Text - Hotkey - Move")
	addcategory(gi,"WESTRING_COMMANDSTRATK0","F Text - Tooltip - Attack")
	addcategory(gi,"WESTRING_COMMANDSTRATK1","F Text - Ubertip - Attack")
	addcategory(gi,"WESTRING_COMMANDSTRATK2","F Text - Hotkey - Attack")
	addcategory(gi,"WESTRING_COMMANDSTRBLD0","F Text - Tooltip - Build")
	addcategory(gi,"WESTRING_COMMANDSTRBLD1","F Text - Ubertip - Build")
	addcategory(gi,"WESTRING_COMMANDSTRBLD2","F Text - Hotkey - Build")
	addcategory(gi,"WESTRING_COMMANDSTRBLH0","F Text - Tooltip - Build Human")
	addcategory(gi,"WESTRING_COMMANDSTRBLH1","F Text - Ubertip - Build Human")
	addcategory(gi,"WESTRING_COMMANDSTRBLH2","F Text - Hotkey - Build Human")
	addcategory(gi,"WESTRING_COMMANDSTRBLO0","F Text - Tooltip - Build Orc")
	addcategory(gi,"WESTRING_COMMANDSTRBLO1","F Text - Ubertip - Build Orc")
	addcategory(gi,"WESTRING_COMMANDSTRBLO2","F Text - Hotkey - Build Orc")
	addcategory(gi,"WESTRING_COMMANDSTRBLE0","F Text - Tooltip - Build Nightelf")
	addcategory(gi,"WESTRING_COMMANDSTRBLE1","F Text - Ubertip - Build Nightelf")
	addcategory(gi,"WESTRING_COMMANDSTRBLE2","F Text - Hotkey - Build Nightelf")
	addcategory(gi,"WESTRING_COMMANDSTRBLU0","F Text - Tooltip - Build Undead")
	addcategory(gi,"WESTRING_COMMANDSTRBLU1","F Text - Ubertip - Build Undead")
	addcategory(gi,"WESTRING_COMMANDSTRBLU2","F Text - Hotkey - Build Undead")
	addcategory(gi,"WESTRING_COMMANDSTRBLN0","F Text - Tooltip - Build Naga")
	addcategory(gi,"WESTRING_COMMANDSTRBLN1","F Text - Ubertip - Build Naga")
	addcategory(gi,"WESTRING_COMMANDSTRBLN2","F Text - Hotkey - Build Naga")
	addcategory(gi,"WESTRING_COMMANDSTRPUR0","F Text - Tooltip - Sell Item")
	addcategory(gi,"WESTRING_COMMANDSTRPUR1","F Text - Ubertip - Sell Item")
	addcategory(gi,"WESTRING_COMMANDSTRPUR2","F Text - Hotkey - Sell Item")
	addcategory(gi,"WESTRING_CHAT_RECIPIENT_ALL","G Chat - Recipient All")
	addcategory(gi,"WESTRING_CHAT_RECIPIENT_ALLIES","G Chat - Recipient Allies")
	addcategory(gi,"WESTRING_CHAT_RECIPIENT_OBSERVERS","G Chat - Recipient Observers")
	addcategory(gi,"WESTRING_CHAT_RECIPIENT_REFEREES","G Chat - Recipient Referees")
	addcategory(gi,"WESTRING_CHAT_RECIPIENT_PRIVATE","G Chat - Recipient Private")
	addcategory(gi,"WESTRING_SKINVAL_CFT0","H Font - Master Font")
	addcategory(gi,"WESTRING_SKINVAL_CFT1","H Font - Message Font")
	addcategory(gi,"WESTRING_SKINVAL_CFT3","H Font - Escape Menu Font")
	addcategory(gi,"WESTRING_SKINVAL_CFT4","H Font - Info Panel Font")
	addcategory(gi,"WESTRING_SKINVAL_CFT2","H Font - Chat Font (broken)")
	addcategory(gi,"WESTRING_SKINVAL_CFT5","H Font - Text Tag Font (broken)")

else -- disable
	
	umswe.deletefile("Units\\MiscGame.txt")
	
end
