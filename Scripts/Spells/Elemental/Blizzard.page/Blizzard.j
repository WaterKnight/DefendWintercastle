//! runtextmacro Folder("Blizzard")
    //! runtextmacro Struct("Wave")
        static Group ENUM_GROUP
        static BoolExpr TARGET_FILTER

        real areaRange
        Unit caster
        real damage
        real targetX
        real targetY

        condMethod Conditions
            local Unit target = UNIT.Event.Native.GetFilter()

            if target.Classes.Contains(UnitClass.DEAD) then
                return false
            endif
            if target.MagicImmunity.Try() then
                return false
            endif

            return true
        endmethod

        timerMethod Ending
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local real areaRange = this.areaRange
            local Unit caster = this.caster
            local real damage = this.damage
            local real targetX = this.targetX
            local real targetY = this.targetY

            local SpellInstance whichInstance = SpellInstance.Create(caster, Blizzard.THIS_SPELL)

            call this.deallocate()
            call durationTimer.Destroy()
            call whichInstance.Destroy()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, areaRange, thistype.TARGET_FILTER)

            loop
                local Unit target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)

                call caster.DamageUnitBySpell(target, damage, true, false)
            endloop
        endmethod

        static method Start takes Unit caster, integer level, real targetX, real targetY returns nothing
            local real areaRange = Blizzard.THIS_SPELL.GetAreaRange(level)

            local thistype this = thistype.allocate()

            local Sound dummySound = Sound.Create("Abilities\\Spells\\Human\\Blizzard\\BlizzardTarget" + Integer.ToString(Math.RandomI(1, 3)) + ".wav", false, true, false, 10, 10, SoundEax.SPELL)
            local Timer durationTimer = Timer.Create()

            set this.areaRange = areaRange
            set this.caster = caster
            set this.damage = thistype.DAMAGE[level]
            set this.targetX = targetX
            set this.targetY = targetY
            call durationTimer.SetData(this)

            set areaRange = areaRange * 0.75

			local integer iteration = thistype.DEBRIS_AMOUNT[level]

            loop
                exitwhen (iteration < 1)

                local real angle = Math.RandomAngle()
                local real offset = Math.Random(0., areaRange)

                call Spot.CreateEffect(targetX + offset * Math.Cos(angle), targetY + offset * Math.Sin(angle), thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

                set iteration = iteration - 1
            endloop

            call durationTimer.Start(thistype.DAMAGE_DELAY, false, function thistype.Ending)

            call dummySound.SetPositionAndPlay(targetX, targetY, Spot.GetHeight(targetX, targetY))

            call dummySound.Destroy(true)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Blizzard", "BLIZZARD")
    static SpellInstance WHICH_INSTANCE

    Sound effectSound
    Timer intervalTimer
    integer level
    real targetX
    real targetY

    //! runtextmacro LinkToStruct("Blizzard", "Wave")

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this

        call thistype(NULL).Wave.Start(target, this.level, this.targetX, this.targetY)
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Sound effectSound = this.effectSound
        local Timer intervalTimer = this.intervalTimer

        call effectSound.Destroy(true)
        call intervalTimer.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local SpellInstance whichInstance = thistype.WHICH_INSTANCE

        local Unit target = whichInstance.GetCaster()
        local real targetX = whichInstance.GetTargetX()
        local real targetY = whichInstance.GetTargetY()

        local thistype this = target

        local Sound effectSound = Sound.Create("Abilities\\Spells\\Human\\Blizzard\\BlizzardLoop1.wav", true, true, false, 10, 10, SoundEax.SPELL)
        local Timer intervalTimer = Timer.Create()

        set this.effectSound = effectSound
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.targetX = targetX
        set this.targetY = targetY
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)

        call effectSound.SetPositionAndPlay(targetX, targetY, Spot.GetHeight(targetX, targetY))

        call thistype(NULL).Wave.Start(target, level, targetX, targetY)
    endmethod

    eventMethod Event_EndCast
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_SpellEffect
        set thistype.WHICH_INSTANCE = params.SpellInstance.GetTrigger()

        call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Purchasable
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Wave.Init()
    endmethod
endstruct