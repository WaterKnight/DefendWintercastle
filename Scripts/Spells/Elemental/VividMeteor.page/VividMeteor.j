//! runtextmacro Folder("VividMeteor")
    //! runtextmacro Struct("Effects")
        static real ANGLE_ADD
        static real ANGLE_ADD_ADD
        static real ANGLE_PER_DUMMY_ADD
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
            if this.RemoveFromList() then
                call thistype.UPDATE_TIMER.Pause()
            endif

			local integer iteration = Memory.IntegerKeys.Table.CountIntegers(PARENT_KEY_ARRAY + this, DUMMY_UNITS_KEY_ARRAY)

            loop
                local DummyUnit dummyUnit = Memory.IntegerKeys.Table.GetInteger(PARENT_KEY_ARRAY + this, DUMMY_UNITS_KEY_ARRAY, iteration)

                call Memory.IntegerKeys.Table.RemoveInteger(PARENT_KEY_ARRAY + this, DUMMY_UNITS_KEY_ARRAY, dummyUnit)

                if (iteration != Memory.IntegerKeys.Table.STARTED) then
                    call dummyUnit.DestroyInstantly()
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        timerMethod Update
            local integer iteration = thistype.ALL_COUNT

            loop
                local thistype this = thistype.ALL[iteration]

                local real angleAdd = this.angleAdd + thistype.ANGLE_ADD_ADD
                local integer iteration2 = Memory.IntegerKeys.Table.CountIntegers(PARENT_KEY_ARRAY + this, DUMMY_UNITS_KEY_ARRAY)
                local real offset = this.offset + thistype.OFFSET_ADD
                local real x = this.x
                local real y = this.y

                set this.angleAdd = angleAdd
                set this.offset = offset

				local real angle = this.angle + angleAdd

                set this.angle = angle

                loop
                    set angle = angle + thistype.ANGLE_PER_DUMMY_ADD

                    local DummyUnit dummyUnit = Memory.IntegerKeys.Table.GetInteger(PARENT_KEY_ARRAY + this, DUMMY_UNITS_KEY_ARRAY, iteration2)

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

            set this.angle = thistype.ANGLE_START
            set this.angleAdd = thistype.ANGLE_ADD
            set this.offset = thistype.OFFSET_START
            set this.x = x
            set this.y = y

			local integer iteration = thistype.DUMMY_UNITS_AMOUNT

            loop
                exitwhen (iteration < 1)

                set angle = angle + thistype.ANGLE_PER_DUMMY_ADD

                local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, x + thistype.OFFSET_START * Math.Cos(angle), y + thistype.OFFSET_START * Math.Sin(angle), Spot.GetHeight(x, y), thistype.ANGLE_START + Math.QUARTER_ANGLE)

                call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, DUMMY_UNITS_KEY_ARRAY, dummyUnit)
                call dummyUnit.SetScale(0.75)
                call dummyUnit.SetTimeScale(0.75 / VividMeteor.DELAY)

                set iteration = iteration - 1
            endloop

            if this.AddToList() then
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
    integer level
    real targetX
    real targetY

    //! runtextmacro LinkToStruct("VividMeteor", "Effects")

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
            return false
        endif
        if target.Classes.Contains(UnitClass.NEUTRAL) then
            return false
        endif
        if target.MagicImmunity.Try() then
            return false
        endif

        return true
    endmethod

    timerMethod Ending
        local Timer delayTimer = Timer.GetExpired()

        local thistype this = delayTimer.GetData()

        local Unit caster = this.caster
        local real heal = this.heal
        local integer level = this.level
        local real targetX = this.targetX
        local real targetY = this.targetY

        local User casterOwner = caster.Owner.Get()

        call this.deallocate()
        call delayTimer.Destroy()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, this.areaRange, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = this.damage
            local real poisonNormDuration = thistype.POISON_DURATION[level]
            local real poisonHeroDuration = thistype.POISON_HERO_DURATION[level]

            loop
                if target.IsAllyOf(casterOwner) then
                    call caster.HealBySpell(target, heal)
                else
					local real poisonDuration

					if target.Classes.Contains(UnitClass.HERO) then
						set poisonDuration = poisonHeroDuration
					else
						set poisonDuration = poisonNormDuration
					endif

                    call target.Buffs.Timed.Start(thistype.POISON_BUFF, level, poisonDuration)

                    call caster.DamageUnitBySpell(target, damage, true, false)
                endif

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif

        call this.Effects.Ending()
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

        local thistype this = thistype.allocate()

		local Timer delayTimer = Timer.Create()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.heal = thistype.HEAL[level]
        set this.level = level
        set this.targetX = targetX
        set this.targetY = targetY
        call delayTimer.SetData(this)

        call this.Effects.Start(targetX, targetY)

        call delayTimer.Start(thistype.DELAY, false, function thistype.Ending)
    endmethod

    initMethod Init of Spells_Purchasable
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call UNIT.Poisoned.NORMAL_BUFF.Variants.Add(thistype.POISON_BUFF)

        call thistype(NULL).Effects.Init()
    endmethod
endstruct