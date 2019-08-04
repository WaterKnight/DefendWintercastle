//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("Purge", "PURGE")
    static Buff DUMMY_BUFF
    static real DURATION
    static real INTERVAL
    static integer INTERVALS_AMOUNT
    static real SPEED_DECREMENT_PER_INTERVAL
    static real SPEED_INCREMENT

    static Spell THIS_SPELL

    Timer intervalTimer
    integer remainingIntervalsAmount
    Unit target

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local Timer intervalTimer = this.intervalTimer
        local integer remainingIntervalsAmount = this.remainingIntervalsAmount

        call intervalTimer.Destroy()
        call target.Movement.Speed.RelativeA.Subtract(remainingIntervalsAmount * thistype.SPEED_DECREMENT_PER_INTERVAL)
    endmethod

    static method Interval takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

        set this.remainingIntervalsAmount = this.remainingIntervalsAmount - 1
        call this.target.Movement.Speed.RelativeA.Subtract(thistype.SPEED_DECREMENT_PER_INTERVAL)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Timer intervalTimer = Timer.Create()
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        set this.intervalTimer = intervalTimer
        set this.remainingIntervalsAmount = thistype.INTERVALS_AMOUNT
        set this.target = target
        call intervalTimer.SetData(this)
        call target.Movement.Speed.RelativeA.Add(thistype.SPEED_INCREMENT)

        call this.target.Buffs.Dispel(false, true, true)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit target = UNIT.Event.GetTarget()

        if (target.MagicImmunity.Try()) then
            return
        endif

        call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, SPELL.Event.GetLevel(), thistype.DURATION)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_Purge.j

        set thistype.INTERVAL = thistype.DURATION / thistype.INTERVALS_AMOUNT
        set thistype.SPEED_DECREMENT_PER_INTERVAL = thistype.SPEED_INCREMENT / thistype.INTERVALS_AMOUNT
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "Pur", "Purge", "1", "false", "ReplaceableTextures\\CommandButtons\\BTNPurge.blp", "This unit was purged. Its buffs were removed and it is slowed for a couple of seconds, slowly regaining its movements.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDispel(true)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct