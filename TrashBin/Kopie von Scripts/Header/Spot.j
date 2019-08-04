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

        //! runtextmacro CreateAnyStaticStateDefault("TARGET_X", "TargetX", "real", "0.")
        //! runtextmacro CreateAnyStaticStateDefault("TARGET_Y", "TargetY", "real", "0.")
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

        static method Ending takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            call this.deallocate()
            call durationTimer.Destroy()
            if (this.RemoveFromList()) then
                call UPDATE_TIMER.Pause()
            endif
        endmethod

        static method Update takes nothing returns nothing
            local real angle
            local real depth
            local integer iteration = thistype.ALL_COUNT
            local real length
            local thistype this
            local real x
            local real y

            loop
                set angle = Math.FULL_ANGLE
                set this = thistype.ALL[iteration]

                set depth = this.depth
                set length = this.length + this.lengthAdd
                set x = this.x
                set y = this.y

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

        static method Create takes real x, real y, real depth, real length, real speed returns nothing
            local real duration = length / speed
            local Timer durationTimer = Timer.Create()
            local thistype this = thistype.allocate()

            set this.depth = depth
            set this.length = 0.
            set this.lengthAdd = speed * UPDATE_TIME
            set this.x = x
            set this.y = y
            call durationTimer.SetData(this)

            if (this.AddToList()) then
                call UPDATE_TIMER.Start(UPDATE_TIME, true, function thistype.Update)
            endif

            call durationTimer.Start(duration, false, function thistype.Ending)
        endmethod

        static method Init takes nothing returns nothing
            set UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Spot", "SPOT")
    static thistype DUMMY
    static constant real SLOPE_PRECISION = 2.

    location self

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

    static method IsWalkable takes real x, real y returns boolean
        return (IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) == false)
    endmethod

    method Move takes real x, real y returns nothing
        call MoveLocation(this.self, x, y)
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

    static method GetSpellTargetX takes nothing returns real
        return GetSpellTargetX()
    endmethod

    static method GetSpellTargetY takes nothing returns real
        return GetSpellTargetY()
    endmethod

    static method GetSpellTarget takes nothing returns thistype
        return CreateFromSelf(GetSpellTargetLoc())
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DUMMY = Create(0., 0.)

        call thistype(NULL).DeformNova.Init()
    endmethod
endstruct