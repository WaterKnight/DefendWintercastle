//! runtextmacro BaseStruct("KnockbackAccelerated", "KNOCKBACK_ACCELERATED")
	//! runtextmacro GetKey("KEY")
	//! runtextmacro GetKeyArray("KEY_ARRAY")
	//! runtextmacro CreateList("TARGET_LIST")

	Unit target
	TranslationAccelerated trans

	destroyMethod Destroy
		local Unit target = this.target
		local TranslationAccelerated trans = this.trans

		if target.Data.Integer.Table.Remove(KEY_ARRAY, this) then
			call thistype.TARGET_LIST_Remove(target)
		endif

		call trans.Data.Integer.Remove(KEY)

		call trans.Destroy()

		//call this.deallocate()

		call target.Movement.Add()
	endmethod

	static method Event_TransDestroy takes TranslationAccelerated trans
		local thistype this = trans.Data.Integer.Get(KEY)

		call this.Destroy()
	endmethod

	static method Event_Move takes Unit target, real x, real y returns boolean
		if not thistype.TARGET_LIST_Contains(target) then
			return false
		endif

		if (Spot.GetCliffLevel(x, y) < Spot.GetCliffLevel(target.Position.X.Get(), target.Position.Y.Get())) then
			return false
		endif

		if not SPOT.BlockCheck.DoWithZ(x, y, target.Position.Z.Get()) then
			return false
		endif

        local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Destroy()

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop

		return true
	endmethod

	static method Create takes Unit target, real speed, real acceleration, real angle, real duration returns thistype
		local TranslationAccelerated trans = TranslationAccelerated.CreateSpeedDirection(target, speed, acceleration, angle, duration)

		if (trans == NULL) then
			return NULL
		endif

		local thistype this = thistype.allocate()

		set this.trans = trans
		set this.target = target

		call trans.Data.Integer.Set(KEY, this)

		if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
			call thistype.TARGET_LIST_Add(target)
		endif

		call target.Movement.Subtract()

		return this
	endmethod

	static method Init
	endmethod
endstruct

//! runtextmacro BaseStruct("Knockback", "KNOCKBACK")
	//! runtextmacro GetKey("KEY")
	//! runtextmacro GetKeyArray("KEY_ARRAY")
	//! runtextmacro CreateList("TARGET_LIST")

	Unit target
	Translation trans

	destroyMethod Destroy
		local Unit target = this.target
		local Translation trans = this.trans

		if target.Data.Integer.Table.Remove(KEY_ARRAY, this) then
			call thistype.TARGET_LIST_Remove(target)
		endif

		call trans.Data.Integer.Remove(KEY)

		call trans.Destroy()

		//call this.deallocate()

		call target.Movement.Add()
	endmethod

	static method Event_TransDestroy takes Translation trans
		local thistype this = trans.Data.Integer.Get(KEY)

		call this.Destroy()
	endmethod

	static method Event_Move takes Unit target, real x, real y returns boolean
		if not thistype.TARGET_LIST_Contains(target) then
			return false
		endif

		if (Spot.GetCliffLevel(x, y) < Spot.GetCliffLevel(target.Position.X.Get(), target.Position.Y.Get())) then
			return false
		endif

		if not SPOT.BlockCheck.DoWithZ(x, y, target.Position.Z.Get()) then
			return false
		endif

        local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Destroy()

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop

		return true
	endmethod

	static method Create takes Unit target, real speed, real angle, real duration returns thistype
		local Translation trans = Translation.CreateSpeedDirection(target, speed, angle, duration)

		if (trans == NULL) then
			return NULL
		endif

		local thistype this = thistype.allocate()

		set this.trans = trans
		set this.target = target

		call trans.Data.Integer.Set(KEY, this)

		if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
			call thistype.TARGET_LIST_Add(target)
		endif

		call target.Movement.Subtract()

		return this
	endmethod

	static method Init
		call KnockbackAccelerated.Init()
	endmethod
endstruct