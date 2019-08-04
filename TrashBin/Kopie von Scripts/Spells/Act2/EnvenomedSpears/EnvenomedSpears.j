//! runtextmacro Spell_OpenScope("/")

//! runtextmacro Folder("EnvenomedSpears")
    //! runtextmacro Struct("Target")
        static Unit CASTER
        static real DAMAGE
        static real DAMAGE_PER_SECOND
        static Buff DUMMY_BUFF
        static real DURATION
        static real HERO_DURATION
        static real INTERVAL

        Unit caster
        real damage
        Timer intervalTimer

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local Timer intervalTimer = this.intervalTimer

            call intervalTimer.Destroy()
            call target.Poisoned.Subtract()
        endmethod

        static method Interval takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            call this.caster.DamageUnitBySpell(target, Math.Min(this.damage, target.Life.Get() - UNIT.Life.IMMORTAL), false, false)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit caster = thistype.CASTER
            local Timer intervalTimer = Timer.Create()
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            set this.caster = caster
            set this.damage = thistype.DAMAGE
            set this.intervalTimer = intervalTimer
            call intervalTimer.SetData(this)
            call target.Poisoned.Add()

            call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local real duration

            if (target.Classes.Contains(UnitClass.HERO)) then
                set duration = thistype.HERO_DURATION
            else
                set duration = thistype.DURATION
            endif

            set thistype.CASTER = caster

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, duration)
        endmethod

        static method Init takes nothing returns nothing
            //! import obj_EnvenomedSpears_Target.j

            set thistype.DAMAGE = thistype.DAMAGE_PER_SECOND * thistype.INTERVAL

                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "EnS", "Poisoned", "1", "false", "ReplaceableTextures\\CommandButtons\\BTNEnvenomedSpear.blp", "This unit suffers from a poison, its movements are slowed and the toxin prevents regeneration.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.SetLostOnDispel(true)
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("EnvenomedSpears", "ENVENOMED_SPEARS")
    static Event DAMAGE_EVENT
    static Buff DUMMY_BUFF

    static Spell THIS_SPELL

    //! runtextmacro LinkToStruct("EnvenomedSpears", "Target")

    static method Conditions takes Unit target returns boolean
        if (target.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif

        return true
    endmethod

    static method Event_Damage takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        if (thistype.Conditions(target) == false) then
            return
        endif

        call thistype(NULL).Target.Start(UNIT.Event.GetDamager(), UNIT.Event.GetDamager().Abilities.GetLevel(thistype.THIS_SPELL), target)
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Remove(DAMAGE_EVENT)
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Add(DAMAGE_EVENT)
    endmethod

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        //! import EnvonmedSpears.j

        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))

        call thistype(NULL).Target.Init()

            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDeath(false)

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct