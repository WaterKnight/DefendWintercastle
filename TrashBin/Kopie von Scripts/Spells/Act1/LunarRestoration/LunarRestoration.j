//! runtextmacro Spell_OpenScope("/")

//! runtextmacro Folder("LunarRestoration")
    //! runtextmacro Struct("Revival")
        static Buff DUMMY_BUFF
        static real DURATION
        static real LIFE_FACTOR
        static real MANA_FACTOR
        static Event REVIVE_EVENT
        static string SPECIAL_EFFECT_PATH

        Timer durationTimer
        integer level
        SpotEffect specialEffect
        Unit target
        real targetX
        real targetY

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local SpotEffect specialEffect = this.specialEffect

            call durationTimer.Destroy()
            call specialEffect.Destroy()
            call target.Event.Remove(REVIVE_EVENT)
        endmethod

        static method EndingByTimer takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local integer level = this.level
            local Unit target = this.target

            call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)

            call target.Revive()

            call target.Life.Set(target.MaxLife.GetAll() * thistype.LIFE_FACTOR)
            call target.Mana.Set(target.MaxMana.GetAll() * thistype.MANA_FACTOR - LunarRestoration.THIS_SPELL.GetManaCost(level))
        endmethod

        static method Event_Revive takes nothing returns nothing
            call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Timer durationTimer = Timer.Create()
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()
            local thistype this = target

            set this.durationTimer = durationTimer
            set this.level = level
            set this.specialEffect = Spot.CreateEffect(targetX, targetY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW)
            set this.target = target
            set this.targetX = targetX
            set this.targetY = targetY
            call durationTimer.SetData(this)
            call target.Event.Add(REVIVE_EVENT)

            call target.Revival.Set(true)

            call durationTimer.Start(thistype.DURATION, false, function thistype.EndingByTimer)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Add(thistype.DUMMY_BUFF, level)
        endmethod

        static method Init takes nothing returns nothing
            //! import obj_LunarRestoration_Revival.j

            set thistype.REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Revive)

                set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("LunarRestoration", "LUNAR_RESTORATION")
    static Event DEATH_EVENT
    static Buff DUMMY_BUFF

    static Spell THIS_SPELL

    //! runtextmacro LinkToStruct("LunarRestoration", "Revival")

    static method Event_Death takes nothing returns nothing
        local integer level
        local Unit target = UNIT.Event.GetTrigger()

        if (UNIT.Event.GetKiller() == NULL) then
            return
        endif

        if (target.Revival.Is()) then
            return
        endif

        set level = SPELL.Event.GetLevel()

        if (target.Mana.Get() < thistype.THIS_SPELL.GetManaCost(level)) then
            return
        endif

        call thistype(NULL).Revival.Start(level, target)
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Remove(DEATH_EVENT)
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Add(DEATH_EVENT)
    endmethod

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_LunarRestoration.j

        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))

            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

        call thistype(NULL).Revival.Init()

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct