function GetSpellTargetX_Wrapped takes nothing returns real
    return GetSpellTargetX()
endfunction

function GetSpellTargetY_Wrapped takes nothing returns real
    return GetSpellTargetY()
endfunction

//! runtextmacro Folder("Spot")
    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            static method GetOrderTargetX takes nothing returns real
                return GetOrderPointX()
            endmethod

            static method GetOrderTargetY takes nothing returns real
                return GetOrderPointY()
            endmethod

            static method HasSpellTarget takes nothing returns boolean
                local Spot target = Spot.CreateFromSelf(GetSpellTargetLoc())

                local boolean result = (target.self != null)

                call target.Destroy()

                return result
            endmethod

            static method GetSpellTargetX takes nothing returns real
                return GetSpellTargetX_Wrapped()
            endmethod

            static method GetSpellTargetY takes nothing returns real
                return GetSpellTargetY_Wrapped()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")
    endstruct

	//! runtextmacro Struct("BlockCheck")
		static item DUMMY_ITEM
		static boolexpr HIDE_BOOLEXPR
		static rect HIDE_RECT

		static item array HIDDEN
		static integer HIDDEN_COUNT = ARRAY_EMPTY

		static method Hide
			if not IsItemVisible(GetFilterItem()) then
				return
			endif

			set thistype.HIDDEN_COUNT = thistype.HIDDEN_COUNT + 1
			set thistype.HIDDEN[thistype.HIDDEN_COUNT] = GetFilterItem()
		endmethod

		static method Do takes real x, real y returns boolean
			call MoveRectTo(thistype.HIDE_RECT, x, y)
	
			call EnumItemsInRect(thistype.HIDE_RECT, thistype.HIDE_BOOLEXPR, null)

	        call SetItemPosition(thistype.DUMMY_ITEM, x, y)

	        local real targetX = GetWidgetX(thistype.DUMMY_ITEM)
	        local real targetY = GetWidgetY(thistype.DUMMY_ITEM)

			call SetItemVisible(thistype.DUMMY_ITEM, false)
	
			loop
				exitwhen (thistype.HIDDEN_COUNT < ARRAY_MIN)

				call SetItemVisible(thistype.HIDDEN[thistype.HIDDEN_COUNT], true)

				set thistype.HIDDEN_COUNT = thistype.HIDDEN_COUNT - 1
			endloop
	
	        local real d = Math.DistanceSquareByDeltas(targetX - x, targetY - y)
	
	        return (d > 1.)
		endmethod

		static constant real HEIGHT_TOLERANCE = 0.

		method DoWithZ takes real x, real y, real z returns boolean
			if not (z < Spot.GetHeight(x, y) - thistype.HEIGHT_TOLERANCE) then
				return false
			endif

			return this.Do(x, y)
		endmethod

		static method Init
			set thistype.DUMMY_ITEM = CreateItem(thistype.DUMMY_ITEM_ID, 0, 0)
			set thistype.HIDE_BOOLEXPR = Condition(function thistype.Hide)
			set thistype.HIDE_RECT = Rect(0, 0, 64, 64)

			call SetItemVisible(thistype.DUMMY_ITEM, false)
		endmethod
	endstruct

    //! runtextmacro Struct("DeformNova")
        static constant real ANGLE_ADD = Math.FULL_ANGLE / 5
        static constant real UPDATE_TIME = 16 * FRAME_UPDATE_TIME
        static Timer UPDATE_TIMER

        real depth
        real length
        real lengthAdd
        real x
        real y

        static method Update takes nothing returns nothing
            local integer iteration = thistype.ALL_COUNT

            loop
                local real angle = Math.FULL_ANGLE
                local thistype this = thistype.ALL[iteration]

                local real depth = this.depth
                local real length = this.length + this.lengthAdd
                local real x = this.x
                local real y = this.y

                set this.length = length

                loop
                    call TerrainDeformCrater(x + length * Math.Cos(angle), y + length * Math.Sin(angle), 1., depth, 1000, false)

                    set angle = angle - ANGLE_ADD
                    exitwhen (angle < 0)
                endloop

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        static method Ending takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            call this.deallocate()
            call durationTimer.Destroy()
            if this.RemoveFromList() then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        static method Create takes real x, real y, real depth, real length, real speed returns nothing
            local real duration = length / speed

            local thistype this = thistype.allocate()

			local Timer durationTimer = Timer.Create()

            set this.depth = depth
            set this.length = 0.
            set this.lengthAdd = speed * UPDATE_TIME
            set this.x = x
            set this.y = y
            call durationTimer.SetData(this)

            if this.AddToList() then
                call thistype.UPDATE_TIMER.Start(UPDATE_TIME, true, function thistype.Update)
            endif

            call durationTimer.Start(duration, false, function thistype.Ending)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Spot", "SPOT")
    static thistype DUMMY
    static constant real SLOPE_PRECISION = 2.

    location self

	//! runtextmacro LinkToStruct("Spot", "BlockCheck")
    //! runtextmacro LinkToStruct("Spot", "DeformNova")
    //! runtextmacro LinkToStruct("Spot", "Event")

    method Destroy takes nothing returns nothing
        local location self = this.self

        call this.deallocate()
        call RemoveLocation(self)

        set self = null
    endmethod

    //! runtextmacro CreateSimpleAddState("real", "0")

    method GetZ takes nothing returns real
        return GetLocationZ(this.self)
    endmethod

	static method IsBlocked takes real x, real y returns boolean
        return thistype(NULL).BlockCheck.Do(x, y)
    endmethod

    static method IsWalkable takes real x, real y returns boolean
        return not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
    endmethod

    method Move takes real x, real y returns nothing
        call MoveLocation(this.self, x, y)
    endmethod

	static method GetCliffLevel takes real x, real y returns integer
		return GetTerrainCliffLevel(x, y)
	endmethod

    static method GetHeight takes real x, real y returns real
        call thistype.DUMMY.Move(x, y)

        return thistype.DUMMY.GetZ()
    endmethod

    method GetSlopeX takes real x, real y returns real
        return (Math.QUARTER_ANGLE - Math.Atan(thistype.GetHeight(x + thistype.SLOPE_PRECISION / 2., y) - thistype.GetHeight(x - thistype.SLOPE_PRECISION / 2., y) / SLOPE_PRECISION))
    endmethod

    method GetSlopeNormalX takes real x, real y returns real
        return (2. * Math.QUARTER_ANGLE - Math.Atan(thistype.GetHeight(x + thistype.SLOPE_PRECISION / 2., y) - thistype.GetHeight(x - thistype.SLOPE_PRECISION / 2., y) / SLOPE_PRECISION))
    endmethod

    method GetSlopeY takes real x, real y returns real
        return (Math.QUARTER_ANGLE - Math.Atan(thistype.GetHeight(x, y + thistype.SLOPE_PRECISION / 2.) - thistype.GetHeight(x, y - thistype.SLOPE_PRECISION / 2.) / SLOPE_PRECISION))
    endmethod

    method GetSlopeNormalY takes real x, real y returns real
        return (2. * Math.QUARTER_ANGLE - Math.Atan(thistype.GetHeight(x, y + thistype.SLOPE_PRECISION / 2.) - thistype.GetHeight(x, y - thistype.SLOPE_PRECISION / 2.) / SLOPE_PRECISION))
    endmethod

    static method SetHeight takes real x, real y, real value returns nothing
        call TerrainDeformCrater(x, y, 1., -(value - Spot.GetHeight(x, y)), 1, true)
    endmethod

    static method AddHeight takes real x, real y, real value returns nothing
        call thistype.SetHeight(x, y, Spot.GetHeight(x, y) + value)
    endmethod

    static method CreateRipple takes real x, real y, real startRadius, real endRadius, real depth, real duration returns nothing
        local real radiusFactor = startRadius / endRadius

        call TerrainDeformRipple(x, y, endRadius, depth, Real.ToInt(duration * 1000), 1, 0., 1., radiusFactor, false)
    endmethod

    static method CreateWave takes real x, real y, real length, real speed, real angle, real radius, real depth returns nothing
        call TerrainDeformWave(x, y, Math.Cos(angle), Math.Sin(angle), length, speed, radius, depth, 0, 1)
    endmethod

    static method CreateFromSelf takes location self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self

        return this
    endmethod

    static method Create takes real x, real y returns thistype
        return thistype.CreateFromSelf(Location(x, y))
    endmethod

    static method CreateEffect takes real x, real y, string modelPath, EffectLevel level returns SpotEffect
        return SpotEffect.Create(x, y, modelPath, level)
    endmethod

    static method CreateEffectWithZ takes real x, real y, real z, string modelPath, EffectLevel level returns SpotEffect
        return SpotEffect.CreateWithZ(x, y, z, modelPath, level)
    endmethod

    static method CreateEffectWithSize takes real x, real y, string modelPath, EffectLevel level, real size returns SpotEffectWithSize
        return SpotEffectWithSize.Create(x, y, modelPath, level, size)
    endmethod

    static method GetSpellTargetX takes nothing returns real
        return GetSpellTargetX()
    endmethod

    static method GetSpellTargetY takes nothing returns real
        return GetSpellTargetY()
    endmethod

    static method GetSpellTarget takes nothing returns thistype
        return CreateFromSelf(GetSpellTargetLoc())
    endmethod

    initMethod Init of Header_2
        set thistype.DUMMY = Create(0., 0.)

		call thistype(NULL).BlockCheck.Init()
        call thistype(NULL).DeformNova.Init()
    endmethod
endstruct