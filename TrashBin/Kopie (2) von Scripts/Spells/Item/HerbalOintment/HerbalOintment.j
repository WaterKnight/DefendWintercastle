//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("HerbalOintment", "HERBAL_OINTMENT")
    static Event DAMAGE_EVENT
    static Buff DUMMY_BUFF
    static real DURATION
    static real INTERVAL
    static real LIFE_ADD
    static real LIFE_ADD_PER_INTERVAL
    static real MANA_ADD
    static real MANA_ADD_PER_INTERVAL
    static integer WAVES_AMOUNT

    static Spell THIS_SPELL

    Timer intervalTimer
    Unit target

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local Timer intervalTimer = this.intervalTimer

        call intervalTimer.Destroy()
        call target.Event.Remove(DAMAGE_EVENT)
    endmethod

    static method Event_Damage takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Heal takes nothing returns nothing
        local Timer intervalTimer = Timer.GetExpired()

        local thistype this = intervalTimer.GetData()

        local Unit target = this.target

        call target.HealBySpell(target, thistype.LIFE_ADD_PER_INTERVAL)
        call target.HealManaBySpell(target, thistype.MANA_ADD_PER_INTERVAL)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Timer intervalTimer = Timer.Create()
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        set this.intervalTimer = intervalTimer
        set this.target = target
        call intervalTimer.SetData(this)
        call target.Event.Add(DAMAGE_EVENT)

        call target.Buffs.Dispel(true, false, true)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Heal)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, SPELL.Event.GetLevel(), thistype.DURATION)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_HerbalOintment.j

        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.TARGET_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Damage)
        set thistype.WAVES_AMOUNT = Real.ToInt(thistype.DURATION / thistype.INTERVAL)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_SpellEffect))

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "HeO", "Herbal Ointment", "1", "true", "ReplaceableTextures\\CommandButtons\\BTNHealingSalve.blp", "Treated by 'Herbal Ointment', regenerates hitpoints and is dispelled after some seconds.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\ANrl\\ANrlTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\ANrm\\ANrmTarget.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)

        set thistype.LIFE_ADD_PER_INTERVAL = thistype.LIFE_ADD / thistype.WAVES_AMOUNT
        set thistype.MANA_ADD_PER_INTERVAL = thistype.MANA_ADD / thistype.WAVES_AMOUNT

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct