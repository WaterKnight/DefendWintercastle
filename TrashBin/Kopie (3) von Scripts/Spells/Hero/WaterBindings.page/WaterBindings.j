//! runtextmacro Folder("WaterBindings")
    //! runtextmacro Struct("Lariat")
        static real array DAMAGE_PER_INTERVAL
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        real damage
        Lightning effectLightning
        Timer intervalTimer
        Unit target

        static method Interval takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()

            local Unit caster = this

            call caster.DamageUnitBySpell(target, this.damage, true, false)
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit caster
            local Unit target = UNIT.Event.GetTrigger()
            local thistype this

            local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

            call target.Attack.Add()
            call target.Movement.Add()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                set caster = this

                call caster.Stop()

                set iteration = iteration - 1
            endloop
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            call target.Attack.Subtract()
            call target.Movement.Subtract()
        endmethod

        static method Event_EndCast takes nothing returns nothing
            local Unit caster = UNIT.Event.GetTrigger()
            local boolean success = SPELL.Event.IsChannelComplete()

            local thistype this = caster

            local Lightning effectLightning = this.effectLightning
            local Timer intervalTimer = this.intervalTimer
            local Unit target = this.target

            call effectLightning.Destroy()
            call intervalTimer.Destroy()
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Buffs.Remove(thistype.DUMMY_BUFF)
            endif

            if (success) then
                call caster.Order.UnitTarget(Order.ATTACK, target)
            endif
        endmethod

        static method Event_SpellEffect takes nothing returns nothing
            local Unit caster = UNIT.Event.GetTrigger()
            local Lightning effectLightning = Lightning.Create(thistype.EFFECT_LIGHTNING_PATH)
            local Timer intervalTimer = Timer.Create()
            local integer level = SPELL.Event.GetLevel()
            local Unit target = UNIT.Event.GetTarget()

            local thistype this = caster

            set this.damage = thistype.DAMAGE_PER_INTERVAL[level]
            set this.effectLightning = effectLightning
            set this.intervalTimer = intervalTimer
            set this.target = target
            call intervalTimer.SetData(this)
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Buffs.Add(thistype.DUMMY_BUFF, 1)
            endif

            call effectLightning.FromUnitToUnit.Start(caster, target)

            call intervalTimer.Start(thistype.INTERVAL[level], true, function thistype.Interval)
        endmethod

        static method Init takes nothing returns nothing
            local integer iteration

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
            call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))

            set iteration = thistype.THIS_SPELL.GetLevelsAmount()

            loop
                set thistype.DAMAGE_PER_INTERVAL[iteration] = thistype.DAMAGE_PER_SECOND[iteration] * thistype.INTERVAL[iteration]

                set iteration = iteration - 1
                exitwhen (iteration < 1)
            endloop
        endmethod
    endstruct

    //! runtextmacro Struct("Summon")
        static method Start takes Unit caster, integer level, Unit target returns nothing
            local User casterOwner = caster.Owner.Get()
            local real casterX = caster.Position.X.Get()
            local real casterY = caster.Position.Y.Get()
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            local real angle = caster.CastAngle(targetX - casterX, targetY - casterY)

            local Unit summon = Unit.CreateSummon(thistype.THIS_UNIT_TYPES[level], casterOwner, casterX + thistype.OFFSET * Math.Cos(angle), casterY + thistype.OFFSET * Math.Sin(angle), angle, thistype.DURATION[level])

            call summon.Abilities.AddWithLevel(WATER_BINDINGS.Lariat.THIS_SPELL, level)

            call casterOwner.EnableAbility(WATER_BINDINGS.Lariat.THIS_SPELL, true)

            call summon.Order.UnitTargetBySpell(WATER_BINDINGS.Lariat.THIS_SPELL, target)

            call casterOwner.EnableAbility(WATER_BINDINGS.Lariat.THIS_SPELL, false)
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("WaterBindings", "WATER_BINDINGS")
    //! runtextmacro LinkToStruct("WaterBindings", "Lariat")
    //! runtextmacro LinkToStruct("WaterBindings", "Summon")

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()

        call thistype(NULL).Summon.Start(caster, level, target)
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Summon.Init()

        call thistype(NULL).Lariat.Init()
    endmethod
endstruct