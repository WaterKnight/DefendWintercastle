//! runtextmacro BaseStruct("CustomDrop", "CUSTOM_DROP")
    string whichEffectAttachPoint
    integer whichEffectLevel
    string whichEffectPath
    Event whichEvent

    method GetEffectAttachPoint takes nothing returns string
        return this.whichEffectAttachPoint
    endmethod

    method GetEffectLevel takes nothing returns integer
        return this.whichEffectLevel
    endmethod

    method GetEffectPath takes nothing returns string
        return this.whichEffectPath
    endmethod

    method GetEvent takes nothing returns Event
        return this.whichEvent
    endmethod

    static method Create takes Event whichEvent, string whichEffectPath, string whichEffectAttachPoint, EffectLevel whichEffectLevel returns thistype
        local thistype this = thistype.allocate()

        set this.whichEffectAttachPoint = whichEffectAttachPoint
        set this.whichEffectLevel = whichEffectLevel
        set this.whichEffectPath = whichEffectPath
        set this.whichEvent = whichEvent

        return this
    endmethod
endstruct

//! runtextmacro Folder("DummyUnit")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("DummyUnit", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("DummyUnit", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("DummyUnit")
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            //! textmacro DummyUnit_Event_Native_CreateResponse takes name, source
                static method Get$name$ takes nothing returns DummyUnit
                    return DummyUnit.GetFromSelf($source$())
                endmethod
            //! endtextmacro

            //! runtextmacro DummyUnit_Event_Native_CreateResponse("Trigger", "GetTriggerUnit")
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")

        //! runtextmacro Event_Implement("DummyUnit")
    endstruct

    //! runtextmacro Struct("Abilities")
        method GetLevelBySelf takes integer spellSelf returns integer
            return GetUnitAbilityLevel(DummyUnit(this).self, spellSelf)
        endmethod

        method GetLevel takes Spell whichSpell returns integer
            return this.GetLevelBySelf(whichSpell.self)
        endmethod

        method SetLevelBySelf takes integer spellSelf, integer level returns integer
            return SetUnitAbilityLevel(DummyUnit(this).self, spellSelf, level)
        endmethod

        method SetLevel takes Spell whichSpell, integer level returns integer
            return this.SetLevelBySelf(whichSpell.self, level)
        endmethod

        method RemoveBySelf takes integer spellSelf returns boolean
            return UnitRemoveAbility(DummyUnit(this).self, spellSelf)
        endmethod

        method Remove takes Spell whichSpell returns boolean
            return this.RemoveBySelf(whichSpell.self)
        endmethod

        method AddBySelf takes integer spellSelf returns boolean
            return UnitAddAbility(DummyUnit(this).self, spellSelf)
        endmethod

        method Add takes Spell whichSpell returns boolean
            return this.AddBySelf(whichSpell.self)
        endmethod
    endstruct

    //! runtextmacro Struct("Animation")
        method Queue takes string whichAnimation returns nothing
            call QueueUnitAnimation(DummyUnit(this).self, whichAnimation)
        endmethod

        method Set takes string whichAnimation returns nothing
            call SetUnitAnimation(DummyUnit(this).self, whichAnimation)
        endmethod

        method SetByIndex takes integer whichAnimation returns nothing
            call SetUnitAnimationByIndex(DummyUnit(this).self, whichAnimation)
        endmethod
    endstruct

    //! runtextmacro Struct("DestroyTimed")
        //! runtextmacro GetKey("KEY")

        DummyUnit parent

        static method Ending takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local DummyUnit parent = this.parent

            call this.deallocate()
            call durationTimer.Destroy()

            call parent.DestroyInstantly()
        endmethod

        method Start takes real duration returns nothing
            local DummyUnit parent = this

            set this = thistype.allocate()

			local Timer durationTimer = Timer.Create()

            set this.parent = parent
            call durationTimer.SetData(this)

            call durationTimer.Start(duration, false, function thistype.Ending)
        endmethod
    endstruct

    //! runtextmacro Struct("Destruction")
        static constant real DURATION = 5.
        //! runtextmacro GetKey("KEY")

        DummyUnit parent

        static method Ending takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local DummyUnit parent = this.parent

            call this.deallocate()
            call durationTimer.Destroy()

            call parent.DestroyInstantly()
        endmethod

        method Start takes nothing returns nothing
            local DummyUnit parent = this

            set this = thistype.allocate()

			local Timer durationTimer = Timer.Create()

            set this.parent = parent
            call durationTimer.SetData(this)

            call durationTimer.Start(thistype.DURATION, false, function thistype.Ending)
        endmethod
    endstruct

    //! runtextmacro Struct("Facing")
        static constant real STANDARD = Math.SOUTH_ANGLE

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method GetNative takes nothing returns real
            return (GetUnitFacing(DummyUnit(this).self) * Math.DEG_TO_RAD)
        endmethod

        method Set takes real value returns nothing
            set this.value = value
            call SetUnitFacing(DummyUnit(this).self, value * Math.RAD_TO_DEG)
            /*if (Math.AngleDifference(value, this.GetNative()) < Math.QUARTER_ANGLE) then
                call SetUnitFacing(DummyUnit(this).self, value * Math.RAD_TO_DEG)

                return
            endif

            call RemoveUnit(DummyUnit(this).self)

            set DummyUnit(this).self = CreateUnit(User.DUMMY.self, DummyUnit(this).GetTypeId(), 0., 0., value * Math.RAD_TO_DEG)

            call DummyUnit(this).Abilities.AddBySelf(DUMMY_UNIT.Position.Z.ENABLER_SPELL_ID)
            call DummyUnit(this).Abilities.RemoveBySelf(DUMMY_UNIT.Position.Z.ENABLER_SPELL_ID)

            call DummyUnit(this).Position.Update()
            call DummyUnit(this).Scale.Update()
            call DummyUnit(this).VertexColor.Update()*/
        endmethod

        method SetToDestructable takes Destructable target returns nothing
            call this.Set(Math.AtanByDeltas(target.GetY() - DummyUnit(this).Position.Y.Get(), target.GetX() - DummyUnit(this).Position.X.Get()))
        endmethod

        method SetToOtherDummyUnit takes DummyUnit otherDummyUnit returns nothing
            call this.Set(Math.AtanByDeltas(otherDummyUnit.Position.Y.Get() - DummyUnit(this).Position.Y.Get(), otherDummyUnit.Position.X.Get() - DummyUnit(this).Position.X.Get()))
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")
    endstruct

    //! runtextmacro Struct("PlayerColor")
        method Set takes playercolor value returns nothing
            call SetUnitColor(DummyUnit(this).self, value)
        endmethod
    endstruct

    //! runtextmacro Struct("Order")
        method GetNative takes nothing returns Order
            return Order.GetFromSelf(GetUnitCurrentOrder(DummyUnit(this).self))
        endmethod

        method Immediate takes Order whichOrder returns boolean
            return IssueImmediateOrderById(DummyUnit(this).self, whichOrder.self)
        endmethod

        method PointTarget takes Order whichOrder, real x, real y returns boolean
            return IssuePointOrderById(DummyUnit(this).self, whichOrder.self, x, y)
        endmethod

        method UnitTarget takes Order whichOrder, Unit target returns boolean
            return IssueTargetOrderById(DummyUnit(this).self, whichOrder.self, Unit(target).self)
        endmethod

        method UnitTargetInstantly takes Order whichOrder, Unit target returns boolean
            call DummyUnit(this).Position.X.Set(target.Position.X.Get())
            call DummyUnit(this).Position.Y.Set(target.Position.Y.Get())

            return this.UnitTarget(whichOrder, target)
        endmethod
    endstruct

    //! runtextmacro Struct("Owner")
        User owner

        method Get takes nothing returns User
            return this.owner
        endmethod

        method Set takes User owner returns nothing
            set this.owner = owner
            call SetUnitOwner(DummyUnit(this).self, owner.self, true)
        endmethod

        method Event_Create takes User owner returns nothing
            set this.owner = owner
        endmethod
    endstruct

    //! runtextmacro Folder("Position")
        //! runtextmacro Struct("X")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method GetNative takes nothing returns real
                return GetUnitX(DummyUnit(this).self)
            endmethod

            method Set takes real val returns nothing
                if ((val < WORLD_MIN_X) or (val > WORLD_MAX_X)) then
                    call DebugEx(thistype.NAME + " out of bounds " + DummyUnit(this).GetName() + " " + R2S(val))

                    return
                endif

                set this.value = val
                call SetUnitX(DummyUnit(this).self, val)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd("real", "0.")
        endstruct

        //! runtextmacro Struct("Y")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method GetNative takes nothing returns real
                return GetUnitY(DummyUnit(this).self)
            endmethod

            method Set takes real val returns nothing
                if ((val < WORLD_MIN_Y) or (val > WORLD_MAX_Y)) then
                    call DebugEx(thistype.NAME + " out of bounds " + DummyUnit(this).GetName() + " " + R2S(val))

                    return
                endif

                set this.value = val
                call SetUnitY(DummyUnit(this).self, val)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd("real", "0.")
        endstruct

        //! runtextmacro Struct("Z")
            real value

            method Get takes nothing returns real
                return this.value
            endmethod

            method GetFlyHeight takes nothing returns real
                return (this.value - Spot.GetHeight(DummyUnit(this).Position.X.Get(), DummyUnit(this).Position.Y.Get()))
            endmethod

            method GetFlyHeightNative takes nothing returns real
                return GetUnitFlyHeight(DummyUnit(this).self)
            endmethod

            method GetNative takes nothing returns real
                return (Spot.GetHeight(DummyUnit(this).Position.X.GetNative(), DummyUnit(this).Position.Y.GetNative()) + this.GetFlyHeightNative())
            endmethod

            method SetByCoords takes real x, real y, real z returns nothing
                set this.value = z
                call SetUnitFlyHeight(DummyUnit(this).self, z - Spot.GetHeight(x, y), 0.)
            endmethod

            method UpdateByCoords takes real x, real y returns nothing
                call this.SetByCoords(x, y, this.value)
            endmethod

            method Set takes real z returns nothing
                call this.SetByCoords(DummyUnit(this).Position.X.Get(), DummyUnit(this).Position.Y.Get(), z)
            endmethod

            method SetFlyHeightNative takes real height, real duration returns nothing
                if (duration > 0) then
                    call SetUnitFlyHeight(DummyUnit(this).self, height, (height - this.GetFlyHeightNative()) / duration)
                else
                    call SetUnitFlyHeight(DummyUnit(this).self, height, 0.)
                endif
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes real x, real y, real z returns nothing
                call DummyUnit(this).Abilities.AddBySelf(BJUnit.Z_ENABLER_SPELL_ID)
                call DummyUnit(this).Abilities.RemoveBySelf(BJUnit.Z_ENABLER_SPELL_ID)

                call this.SetByCoords(x, y, z)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Position")
        //! runtextmacro LinkToStruct("Position", "X")
        //! runtextmacro LinkToStruct("Position", "Y")
        //! runtextmacro LinkToStruct("Position", "Z")

        method Set takes real x, real y, real z returns nothing
            call this.X.Set(x)
            call this.Y.Set(y)

            call this.Z.SetByCoords(x, y, z)
        endmethod

        method Add takes real x, real y, real z returns nothing
            call this.Set(this.X.Get() + x, this.Y.Get() + y, this.Z.Get() + z)
        endmethod

        method SetXY takes real x, real y returns nothing
            call this.X.Set(x)
            call this.Y.Set(y)
            call this.Z.SetByCoords(x, y, this.Z.Get())
        endmethod

        method AddXY takes real x, real y returns nothing
            call this.SetXY(this.X.Get() + x, this.Y.Get() + y)
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.X.Get(), this.Y.Get(), this.Z.Get())
        endmethod
    endstruct

    //! runtextmacro Struct("FollowDummyUnit")
        //! runtextmacro GetKey("KEY")
        static Event PARENT_DESTROY_EVENT
        static Event TARGET_DESTROY_EVENT
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        real offsetX
        real offsetY
        real offsetZ
        DummyUnit target
        boolean useScale

        method Ending takes DummyUnit parent, DummyUnit target returns nothing
            call parent.Event.Remove(PARENT_DESTROY_EVENT)
            call target.Data.Integer.Remove(KEY)
            //call target.Event.Remove(TARGET_DESTROY_EVENT)

            if this.RemoveFromList() then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        eventMethod Event_ParentDestroy
            local DummyUnit parent = params.DummyUnit.GetTrigger()

            local thistype this = parent

            call this.Ending(parent, this.target)
        endmethod

        eventMethod Event_TargetDestroy
            local DummyUnit target = params.DummyUnit.GetTrigger()

            local thistype this = target.Data.Integer.Get(KEY)

            call this.Ending(this, target)
        endmethod

        timerMethod Update
            local integer iteration = thistype.ALL_COUNT

            loop
                local thistype this = thistype.ALL[iteration]

                local real offsetX = this.offsetX
                local real offsetY = this.offsetY
                local real offsetZ = this.offsetZ
                local DummyUnit target = this.target

                if this.useScale then
                    local real scale = target.Scale.Get()

                    set offsetX = offsetX * scale
                    set offsetY = offsetY * scale
                    set offsetZ = offsetZ * scale
                endif

                call DummyUnit(this).Position.Set(target.Position.X.GetNative() + offsetX, target.Position.Y.GetNative() + offsetY, target.Position.Z.Get() + offsetZ)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        method Start takes DummyUnit target, boolean useScale, real offsetX, real offsetY, real offsetZ returns nothing
            set this.offsetX = offsetX
            set this.offsetY = offsetY
            set this.offsetZ = offsetZ
            set this.target = target
            set this.useScale = useScale
            call DummyUnit(this).Event.Add(PARENT_DESTROY_EVENT)
            //call target.Event.Add(TARGET_DESTROY_EVENT)

            if this.AddToList() then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.PARENT_DESTROY_EVENT = Event.Create(DummyUnit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_ParentDestroy)
            //set thistype.TARGET_DESTROY_EVENT = Event.Create(DummyUnit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TargetDestroy)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("FollowUnit")
        //! runtextmacro GetKey("KEY")
        static Event PARENT_DESTROY_EVENT
        static Event TARGET_DESTROY_EVENT
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        real offsetX
        real offsetY
        real offsetZ
        Unit target
        boolean useOutpact
        boolean useScale

        method Ending takes DummyUnit parent, Unit target returns nothing
            call parent.Event.Remove(PARENT_DESTROY_EVENT)
            call target.Data.Integer.Remove(KEY)
            //call target.Event.Remove(TARGET_DESTROY_EVENT)

            if this.RemoveFromList() then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        eventMethod Event_ParentDestroy
            local DummyUnit parent = params.DummyUnit.GetTrigger()

            local thistype this = parent

            call this.Ending(parent, this.target)
        endmethod

        eventMethod Event_TargetDestroy
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target.Data.Integer.Get(KEY)

            call this.Ending(this, target)
        endmethod

        timerMethod Update
            local integer iteration = thistype.ALL_COUNT

            loop
                local thistype this = thistype.ALL[iteration]

                local real offsetX = this.offsetX
                local real offsetY = this.offsetY
                local real offsetZ = this.offsetZ
                local Unit target = this.target

                if this.useOutpact then
                    set offsetX = offsetX + target.Outpact.X.Get(false)
                    set offsetY = offsetY + target.Outpact.Y.Get(false)
                    set offsetZ = offsetZ + target.Outpact.Z.Get(false)
                endif

                if this.useScale then
                    local real scale = target.Scale.Get()

                    set offsetX = offsetX * scale
                    set offsetY = offsetY * scale
                    set offsetZ = offsetZ * scale
                endif

                call DummyUnit(this).Position.Set(target.Position.X.Get() + offsetX, target.Position.Y.Get() + offsetY, target.Position.Z.Get() + offsetZ)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        method Start takes Unit target, boolean useOutpact, boolean useScale, real offsetX, real offsetY, real offsetZ returns nothing
            set this.offsetX = offsetX
            set this.offsetY = offsetY
            set this.offsetZ = offsetZ
            set this.target = target
            set this.useOutpact = useOutpact
            set this.useScale = useScale
            call DummyUnit(this).Event.Add(PARENT_DESTROY_EVENT)
            //call target.Event.Add(TARGET_DESTROY_EVENT)

            if this.AddToList() then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.PARENT_DESTROY_EVENT = Event.Create(DummyUnit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_ParentDestroy)
            //set thistype.TARGET_DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TargetDestroy)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("Rotate")
        static Event DESTROY_EVENT
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        real add

        method Ending takes nothing returns nothing
            call DummyUnit(this).Event.Remove(DESTROY_EVENT)

            if this.RemoveFromList() then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        eventMethod Event_Destroy
            local thistype this = params.DummyUnit.GetTrigger()

            call this.Ending()
        endmethod

        timerMethod Update
            local integer iteration = thistype.ALL_COUNT

            loop
                local thistype this = thistype.ALL[iteration]

                call DummyUnit(this).Facing.Add(this.add)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        method Start takes real speed returns nothing
            set this.add = speed * thistype.UPDATE_TIME
            call DummyUnit(this).Event.Add(DESTROY_EVENT)

            if this.AddToList() then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(DummyUnit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Scale")
        //! runtextmacro Struct("Timed")
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")
            static Timer UPDATE_TIMER

            real bonusScalePerInterval
            Timer durationTimer
            DummyUnit parent

            private method Ending takes Timer durationTimer, DummyUnit parent returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                call parent.Data.Integer.Table.Remove(KEY_ARRAY, this)
                if this.RemoveFromList() then
                    call thistype.UPDATE_TIMER.Pause()
                endif
            endmethod

            eventMethod Event_Decay
                local DummyUnit parent = params.DummyUnit.GetTrigger()

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                if (iteration > Memory.IntegerKeys.Table.EMPTY) then
                    loop
                        local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                        call this.Ending(this.durationTimer, parent)

                        set iteration = iteration - 1
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                    endloop
                endif
            endmethod

            timerMethod EndingByTimer
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                call this.Ending(durationTimer, this.parent)
            endmethod

            timerMethod Update
                local integer iteration = thistype.ALL_COUNT

                loop
                    local thistype this = thistype.ALL[iteration]

                    call this.parent.Scale.Add(this.bonusScalePerInterval)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endmethod

            method Add takes real scale, real duration returns nothing
                local DummyUnit parent = this

                if (duration == 0.) then
                    call DummyUnit(this).Scale.Add(scale)

                    return
                endif

				local integer wavesAmount = Real.ToInt(duration / thistype.UPDATE_TIME)

                set this = thistype.allocate()

				local Timer durationTimer = Timer.Create()

                set this.bonusScalePerInterval = scale / wavesAmount
                set this.durationTimer = durationTimer
                set this.parent = parent
                call durationTimer.SetData(this)
                call parent.Data.Integer.Table.Add(KEY_ARRAY, this)

                if this.AddToList() then
                    call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                endif

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)
            endmethod

            method Subtract takes real scale, real duration returns nothing
                call this.Add(-scale, duration)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.UPDATE_TIMER = Timer.Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Scale")
        //! runtextmacro LinkToStruct("Scale", "Timed")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Set takes real value returns nothing
            set this.value = value
            call SetUnitScale(DummyUnit(this).self, value, value, value)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd("real", "1.")

        static method Init takes nothing returns nothing
            call thistype(NULL).Timed.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("VertexColor")
        //! runtextmacro Struct("Red")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Green")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Blue")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Alpha")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Timed")
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
            static Timer UPDATE_TIMER

            real bonusRedPerInterval
            real bonusGreenPerInterval
            real bonusBluePerInterval
            real bonusAlphaPerInterval
            Timer durationTimer
            DummyUnit parent

            private method Ending takes Timer durationTimer, DummyUnit parent returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                call parent.Data.Integer.Table.Remove(KEY_ARRAY, this)
                if this.RemoveFromList() then
                    call thistype.UPDATE_TIMER.Pause()
                endif
            endmethod

            eventMethod Event_Decay
                local DummyUnit parent = params.DummyUnit.GetTrigger()

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                if (iteration > Memory.IntegerKeys.Table.EMPTY) then
                    loop
                        local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                        call this.Ending(this.durationTimer, parent)

                        set iteration = iteration - 1
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                    endloop
                endif
            endmethod

            timerMethod EndingByTimer
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                call this.Ending(durationTimer, this.parent)
            endmethod

            timerMethod Update
                local integer iteration = thistype.ALL_COUNT

                loop
                    local thistype this = thistype.ALL[iteration]

                    call this.parent.VertexColor.Add(this.bonusRedPerInterval, this.bonusGreenPerInterval, this.bonusBluePerInterval, this.bonusAlphaPerInterval)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endmethod

            method Add takes real red, real green, real blue, real alpha, real duration returns nothing
                local DummyUnit parent = this

                if (duration == 0.) then
                    call DummyUnit(this).VertexColor.Add(red, green, blue, alpha)

                    return
                endif

				local integer wavesAmount = Real.ToInt(duration / thistype.UPDATE_TIME)

                set this = thistype.allocate()

                local Timer durationTimer = Timer.Create()

                set this.bonusRedPerInterval = red / wavesAmount
                set this.bonusGreenPerInterval = green / wavesAmount
                set this.bonusBluePerInterval = blue / wavesAmount
                set this.bonusAlphaPerInterval = alpha / wavesAmount
                set this.durationTimer = durationTimer
                set this.parent = parent
                call durationTimer.SetData(this)
                call parent.Data.Integer.Table.Add(KEY_ARRAY, this)

                if this.AddToList() then
                    call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                endif

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)
            endmethod

            method Subtract takes real red, real green, real blue, real alpha, real duration returns nothing
                call this.Add(-red, -green, -blue, -alpha, duration)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.UPDATE_TIMER = Timer.Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("VertexColor")
        //! runtextmacro LinkToStruct("VertexColor", "Red")
        //! runtextmacro LinkToStruct("VertexColor", "Green")
        //! runtextmacro LinkToStruct("VertexColor", "Blue")
        //! runtextmacro LinkToStruct("VertexColor", "Alpha")

        //! runtextmacro LinkToStruct("VertexColor", "Timed")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Set takes real red, real green, real blue, real alpha returns nothing
            call this.Red.Set(red)
            call this.Green.Set(green)
            call this.Blue.Set(blue)
            call this.Alpha.Set(alpha)
            call SetUnitVertexColor(DummyUnit(this).self, Real.ToInt(red), Real.ToInt(green), Real.ToInt(blue), Real.ToInt(alpha))
        endmethod

        method Add takes real red, real green, real blue, real alpha returns nothing
            call this.Set(this.Red.Get() + red, this.Green.Get() + green, this.Blue.Get() + blue, this.Alpha.Get() + alpha)
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Red.Get(), this.Green.Get(), this.Blue.Get(), this.Alpha.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(255., 255., 255., 255.)
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Timed.Init()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("DummyUnit", "DUMMY_UNIT")
    static EventType DEATH_EVENT_TYPE
    static EventType DESTROY_EVENT_TYPE
    //! runtextmacro GetKey("KEY")
    static constant integer NONE_ID = 0

    static thistype WORLD_CASTER

    unit self
    integer typeId

    //! runtextmacro LinkToStruct("DummyUnit", "Abilities")
    //! runtextmacro LinkToStruct("DummyUnit", "Animation")
    //! runtextmacro LinkToStruct("DummyUnit", "Data")
    //! runtextmacro LinkToStruct("DummyUnit", "DestroyTimed")
    //! runtextmacro LinkToStruct("DummyUnit", "Destruction")
    //! runtextmacro LinkToStruct("DummyUnit", "Event")
    //! runtextmacro LinkToStruct("DummyUnit", "Facing")
    //! runtextmacro LinkToStruct("DummyUnit", "FollowDummyUnit")
    //! runtextmacro LinkToStruct("DummyUnit", "FollowUnit")
    //! runtextmacro LinkToStruct("DummyUnit", "Id")
    //! runtextmacro LinkToStruct("DummyUnit", "Order")
    //! runtextmacro LinkToStruct("DummyUnit", "Owner")
    //! runtextmacro LinkToStruct("DummyUnit", "PlayerColor")
    //! runtextmacro LinkToStruct("DummyUnit", "Position")
    //! runtextmacro LinkToStruct("DummyUnit", "Rotate")
    //! runtextmacro LinkToStruct("DummyUnit", "Scale")
    //! runtextmacro LinkToStruct("DummyUnit", "VertexColor")

    static method GetFromSelf takes unit self returns thistype
        return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
    endmethod

    method GetName takes nothing returns string
        return GetUnitName(this.self)
    endmethod

    method GetSelf takes nothing returns unit
        return this.self
    endmethod

    method GetProperName takes nothing returns string
        return GetHeroProperName(this.self)
    endmethod

    method GetTypeId takes nothing returns integer
        return this.typeId
    endmethod

    method DestroyInstantly takes nothing returns nothing
        local EventResponse params = EventResponse.Create(this.Id.Get())

        call params.DummyUnit.SetTrigger(this)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = this.Event.Count(thistype.DESTROY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()

		local unit self = this.self

        call this.deallocate()
        call RemoveUnit(self)

        set self = null
    endmethod

    method Destroy takes nothing returns nothing
        local EventResponse params = EventResponse.Create(this.Id.Get())

        call params.DummyUnit.SetTrigger(this)

if (GetUnitAbilityLevel(this.self, thistype.LOCUST_SPELL_ID) == 0) then
	call DebugEx(GetUnitName(this.self) + " had no locust")
endif

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = this.Event.Count(thistype.DEATH_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.DEATH_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()

        call this.Animation.Set(Animation.DEATH)
        call this.Animation.Queue(null)
        call this.Destruction.Start()
    endmethod

    method Flash takes integer red, integer green, integer blue, integer alpha returns nothing
        call AddIndicator(this.self, red, green, blue, alpha)
    endmethod

    method Kill takes nothing returns nothing
        call KillUnit(this.self)
    endmethod

    method SetMoveSpeed takes real value returns nothing
        call SetUnitMoveSpeed(this.self, value)
    endmethod

    method SetMoveWindow takes real value returns nothing
        call SetUnitPropWindow(this.self, value)
    endmethod

    method SetLocust takes nothing returns nothing
        call UnitAddAbility(this.self, thistype.LOCUST_SPELL_ID)
    endmethod

    method SetScale takes real scale returns nothing
        call SetUnitScale(this.self, scale, scale, scale)
    endmethod

    method SetTimeScale takes real scale returns nothing
        call SetUnitTimeScale(this.self, scale)
    endmethod

    method SetTurnSpeed takes real value returns nothing
        call SetUnitTurnSpeed(this.self, value)
    endmethod

    method AddEffect takes string path, string attachPoint, EffectLevel level returns DummyUnitEffect
        return DummyUnitEffect.Create(this, path, attachPoint, level)
    endmethod

    method CreateEffect takes string path, string attachPoint, EffectLevel level returns DummyUnitEffect
        return DummyUnitEffect.Create(this, path, attachPoint, level)
    endmethod

    static method Create takes integer unitId, real x, real y, real z, real angle returns thistype
    	local thistype this = thistype.allocate()

        local unit self = CreateUnit(User.DUMMY.self, unitId, 0., 0., angle * Math.RAD_TO_DEG)

        set this.self = self
        set this.typeId = unitId
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        call this.Id.Event_Create()

        set self = null
        call this.Facing.Set(angle)
        call this.Owner.Set(User.DUMMY)
        call this.Position.X.Set(x)
        call this.Position.Y.Set(y)
        call this.Position.Z.Event_Create(x, y, z)
        call this.Scale.Event_Create()
        call this.VertexColor.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DEATH_EVENT_TYPE = EventType.Create()
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()

        call thistype(NULL).FollowDummyUnit.Init()
        call thistype(NULL).FollowUnit.Init()
        call thistype(NULL).Scale.Init()
        call thistype(NULL).Rotate.Init()
        call thistype(NULL).VertexColor.Init()

        //World Caster
        set thistype.WORLD_CASTER = thistype.Create(thistype.WORLD_CASTER_ID, 0., 0., 0., 0.)
    endmethod
endstruct

//! runtextmacro BaseStruct("TargetFlag", "TARGET_FLAG")
    static constant integer ALLY = 0
endstruct

//! runtextmacro BaseStruct("Misc", "MISC")
    initMethod Init of Header_5
        call Attack.Init()
        call DummyUnit.Init()
    endmethod
endstruct