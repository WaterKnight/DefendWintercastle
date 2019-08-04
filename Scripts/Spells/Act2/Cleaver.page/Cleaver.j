//! runtextmacro Folder("Cleaver")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Cleaver", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Cleaver", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Cleaver")
    endstruct

    //! runtextmacro Struct("Wave")
        static Group ENUM_GROUP
        static real LENGTH
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static BoolExpr TARGET_FILTER

        DummyUnit dummyUnit
        Cleaver parent
        real x
        real xAdd
        real y
        real yAdd

        method Ending takes nothing returns nothing
            local Cleaver parent = this

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            if (iteration < Memory.IntegerKeys.Table.STARTED) then
                return
            endif

            loop
                set this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                local DummyUnit dummyUnit = this.dummyUnit

                call this.deallocate()
                call dummyUnit.Destroy()
                call parent.Data.Integer.Table.Remove(KEY_ARRAY, this)

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        condMethod Conditions
            local Unit target = UNIT.Event.Native.GetFilter()

            if target.Classes.Contains(UnitClass.DEAD) then
                return false
            endif
            if not target.Classes.Contains(UnitClass.GROUND) then
                return false
            endif
            if target.IsAllyOf(User.TEMP) then
                return false
            endif
            if Group.TEMP.ContainsUnit(target) then
                return false
            endif

            return true
        endmethod

        method DealDamage takes nothing returns nothing
            local Cleaver parent = this

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            if (iteration < Memory.IntegerKeys.Table.STARTED) then
                return
            endif

            local Unit caster = parent.caster
            local integer level = parent.level
            local real maxDamage = parent.maxDamage
            local Group targetGroup = parent.targetGroup

            local User casterOwner = caster.Owner.Get()

            loop
                set this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                set Group.TEMP = targetGroup
                set User.TEMP = casterOwner

                call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(this.x, this.y, thistype.AREA_RANGE, thistype.TARGET_FILTER)

                local Unit target = thistype.ENUM_GROUP.FetchFirst()

                if (target != NULL) then
                    loop
                        call targetGroup.AddUnit(target)

                        if not target.MagicImmunity.Try() then
                            local real damage = Math.Min(thistype.DAMAGE, maxDamage)

                            set maxDamage = maxDamage - damage

                            call caster.DamageUnitBySpell(target, damage, false, false)
                        endif

                        set target = thistype.ENUM_GROUP.FetchFirst()
                        exitwhen (target == NULL)
                    endloop
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop

            set parent.maxDamage = maxDamage
        endmethod

        method Move takes nothing returns nothing
            local Cleaver parent = this

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            if (iteration < Memory.IntegerKeys.Table.STARTED) then
                return
            endif

            loop
                set this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                local real x = this.x + this.xAdd
                local real y = this.y + this.yAdd

                set this.x = x
                set this.y = y
                call this.dummyUnit.Position.SetXY(x, y)

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method Start takes real x, real y, real angle returns nothing
            local Cleaver parent = this

            local real xPart = Math.Cos(angle)
            local real yPart = Math.Sin(angle)

            set this = thistype.allocate()

            set x = x + thistype.OFFSET * xPart
            set y = y + thistype.OFFSET * yPart

            set this.dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, x, y, Spot.GetHeight(x, y), angle)
            set this.parent = parent
            set this.x = x
            set this.xAdd = thistype.LENGTH * xPart
            set this.y = y
            set this.yAdd = thistype.LENGTH * yPart
            call parent.Data.Integer.Table.Add(KEY_ARRAY, this)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.LENGTH = thistype.SPEED * thistype.UPDATE_TIME
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Cleaver", "CLEAVER")
    static real DURATION

    Unit caster
    Timer intervalTimer
    integer level
    real maxDamage
    Group targetGroup
    Timer updateTimer

    //! runtextmacro LinkToStruct("Cleaver", "Data")
    //! runtextmacro LinkToStruct("Cleaver", "Id")
    //! runtextmacro Event_Implement2("Cleaver")

    //! runtextmacro LinkToStruct("Cleaver", "Wave")

    timerMethod Ending
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local Timer intervalTimer = this.intervalTimer
        local Group targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer

        call this.Wave.Ending()

        call this.deallocate_demount()

        call durationTimer.Destroy()
        call intervalTimer.Destroy()
        call targetGroup.Destroy()
        call updateTimer.Destroy()
    endmethod

    timerMethod DealDamage
        local thistype this = Timer.GetExpired().GetData()

        call this.Wave.DealDamage()
    endmethod

    timerMethod Move
        local thistype this = Timer.GetExpired().GetData()

        call this.Wave.Move()
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

        local thistype this = thistype.allocate_mount(caster)

        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()
        local Timer updateTimer = Timer.Create()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real dX = targetX - casterX
        local real dY = targetY - casterY

        local real angle = caster.CastAngle(dX, dY)

        set this.caster = caster
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.maxDamage = thistype.MAX_DAMAGE
        set this.targetGroup = Group.Create()
        set this.updateTimer = updateTimer
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)
        call updateTimer.SetData(this)

        call this.Id.Event_Create()

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.DealDamage)
        call updateTimer.Start(thistype(NULL).Wave.UPDATE_TIME, true, function thistype.Move)

        call durationTimer.Start(thistype.DURATION, false, function thistype.Ending)

        call this.Wave.Start(casterX, casterY, angle)
        call this.Wave.Start(casterX, casterY, angle - Math.QUARTER_ANGLE / 3)
        call this.Wave.Start(casterX, casterY, angle + Math.QUARTER_ANGLE / 3)
    endmethod

    initMethod Init of Spells_Act2
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Wave.Init()

        set thistype.DURATION = thistype(NULL).Wave.MAX_LENGTH / thistype(NULL).Wave.SPEED
    endmethod
endstruct