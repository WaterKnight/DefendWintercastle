//! runtextmacro BaseStruct("PathingBlockers", "PATHING_BLOCKERS")
	static method Enum
		local destructable d = GetFilterDestructable()

		if (GetDestructableTypeId(d) == PathingBlockers.P_G4X4_ID) then
			call KillDestructable(d)
		endif

		set d = null
	endmethod

	initMethod Init of Misc
		call EnumDestructablesInRect(Rectangle.WORLD.self, null, function thistype.Enum)
	endmethod
endstruct