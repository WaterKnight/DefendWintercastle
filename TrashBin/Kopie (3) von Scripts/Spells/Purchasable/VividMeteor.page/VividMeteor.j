//! runtextmacro Folder("VividMeteor")
    //! runtextmacro Struct("Effects")
        static real ANGLE_ADD
        static real ANGLE_ADD_ADD
        static real ANGLE_PER_DUMMY_ADD
        //! runtextmacro DummyUnit_CreateSimpleType("/", "dViM", "Vivid Meteor", "DUMMY_UNIT_ID", "Units\\Demon\\Infernal\\InfernalBirth.mdl")
        //! runtextmacro GetKeyArray("DUMMY_UNITS_KEY_ARRAY")
        static real OFFSET_ADD
        //! runtextmacro GetKeyArray("PARENT_KEY_ARRAY")
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")
        static Timer UPDATE_TIMER

        real angle
        real angleAdd
        real offset
        real x
        real y

        method Ending takes nothing returns nothing
            local DummyUnit dummyUnit
            local integer iteration = Memory.IntegerKeys.Table.CountIntegers(PARENT_KEY_ARRAY + this, DUMMY_UNITS_KEY_ARRAY)

            if (this.RemoveFromList()) then
                call thistype.UPDATE_TIMER.Pause()
            endif

            loop
                set dummyUnit = Memory.IntegerKeys.Table.GetInteger(PARENT_KEY_ARRAY + this, DUMMY_UNITS_KEY_ARRAY, iteration)

                call Memory.IntegerKeys.Table.RemoveInteger(PARENT_KEY_ARRAY + this, DUMMY_UNITS_KEY_ARRAY, dummyUnit)

                if (iteration != Memory.IntegerKeys.Table.STARTED) then
                    call dummyUnit.DestroyInstantly()
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        static method Update takes nothing returns nothing
            local real angle
            local real angleAdd
            local DummyUnit dummyUnit
            local integer iteration = thistype.ALL_COUNT
            local integer iteration2
            local real offset
            local thistype this
            local real x
            local real y

            loop
                set this = thistype.ALL[iteration]

                set angleAdd = this.angleAdd + thistype.ANGLE_ADD_ADD
                set iteration2 = Memory.IntegerKeys.Table.CountIntegers(PARENT_KEY_ARRAY + this, DUMMY_UNITS_KEY_ARRAY)
                set offset = this.offset + thistype.OFFSET_ADD
                set x = this.x
                set y = this.y

                set angle = this.angle + angleAdd
                set this.angleAdd = angleAdd
                set this.offset = offset

                set this.angle = angle

                loop
                    set angle = angle + thistype.ANGLE_PER_DUMMY_ADD

                    set dummyUnit = Memory.IntegerKeys.Table.GetInteger(PARENT_KEY_ARRAY + this, DUMMY_UNITS_KEY_ARRAY, iteration2)

                    call dummyUnit.Facing.Set(angle + Math.QUARTER_ANGLE)
                    call dummyUnit.Position.SetXY(x + offset * Math.Cos(angle), y + offset * Math.Sin(angle))

                    set iteration2 = iteration2 - 1
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)
                endloop

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        method Start takes real x, real y returns nothing
            local real angle = thistype.ANGLE_START
            local DummyUnit dummyUnit
            local integer iteration = thistype.DUMMY_UNITS_AMOUNT

            set this.angle = thistype.ANGLE_START
            set this.angleAdd = thistype.ANGLE_ADD
            set this.offset = thistype.OFFSET_START
            set this.x = x
            set this.y = y

            loop
                exitwhen (iteration < 1)

                set angle = angle + thistype.ANGLE_PER_DUMMY_ADD

                set dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, x + thistype.OFFSET_START * Math.Cos(angle), y + thistype.OFFSET_START * Math.Sin(angle), Spot.GetHeight(x, y), thistype.ANGLE_START + Math.QUARTER_ANGLE)

                call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, DUMMY_UNITS_KEY_ARRAY, dummyUnit)
                call dummyUnit.SetScale(0.75)
                call dummyUnit.SetTimeScale(0.75 / VividMeteor.DELAY)

                set iteration = iteration - 1
            endloop

            if (this.AddToList()) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ANGLE_ADD = thistype.ANGLE_SPEED * thistype.UPDATE_TIME
            set thistype.ANGLE_ADD_ADD = thistype.ANGLE_ACC * thistype.UPDATE_TIME * thistype.UPDATE_TIME
            set thistype.ANGLE_PER_DUMMY_ADD = Math.FULL_ANGLE / thistype.DUMMY_UNITS_AMOUNT
            set thistype.OFFSET_ADD = -thistype.OFFSET_START / VividMeteor.DELAY * thistype.UPDATE_TIME
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("VividMeteor", "VIVID_METEOR")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    real areaRange
    Unit caster
    real damage
    real heal
    real poisonDuration
    real targetX
    real targetY

    //! runtextmacro LinkToStruct("VividMeteor", "Effects")

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.NEUTRAL)) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif

        return true
    endmethod

    static method Ending takes nothing returns nothing
        local real damage
        local Timer delayTimer = Timer.GetExpired()
        local Unit target

        local thistype this = delayTimer.GetData()

        local Unit caster = this.caster
        local real heal = this.heal
        local real poisonDuration = this.poisonDuration
        local real targetX = this.targetX
        local real targetY = this.targetY

        local User casterOwner = caster.Owner.Get()

        call this.deallocate()
        call delayTimer.Destroy()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, this.areaRange, thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set damage = this.damage

            loop
                if (target.IsAllyOf(casterOwner)) then
                    call caster.HealBySpell(target, heal)
                else
                    call target.Poisoned.AddTimed(poisonDuration)

                    call caster.DamageUnitBySpell(target, damage, true, false)
                endif

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif

        call this.Effects.Ending()
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer delayTimer = Timer.Create()
        local integer level = SPELL.Event.GetLevel()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()
        local thistype this = thistype.allocate()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.heal = thistype.HEAL[level]
        set this.poisonDuration = thistype.POISON_DURATION[level]
        set this.targetX = targetX
        set this.targetY = targetY
        call delayTimer.SetData(this)

        call this.Effects.Start(targetX, targetY)

        call delayTimer.Start(thistype.DELAY, false, function thistype.Ending)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Effects.Init()
    endmethod
endstruct