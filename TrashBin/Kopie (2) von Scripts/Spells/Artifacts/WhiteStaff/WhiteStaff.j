//! runtextmacro Folder("WhiteStaff")
    //! runtextmacro Struct("Target")
        static Buff DUMMY_BUFF
        static real array EVASION_INCREMENT

        //! import "Spells\Artifacts\WhiteStaff\Target\obj.j"

        real evasionAdd

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local real evasionAdd = this.evasionAdd

            call target.EvasionChance.Bonus.Subtract(evasionAdd)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real evasionAdd = thistype.EVASION_INCREMENT[level]
            local thistype this = target

            set this.evasionAdd = evasionAdd

            call target.EvasionChance.Bonus.Add(evasionAdd)
        endmethod

        static method Init takes nothing returns nothing
                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "WhS", "White Staff", "5", "true", "ReplaceableTextures\\CommandButtons\\BTNAdvancedStrengthOfTheMoon.blp", "The evasion is increased. The caster channeling this buff regenerates mana.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("WhiteStaff", "WHITE_STAFF")
    static string EFFECT_LIGHTNING_PATH
    static real INTERVAL
    static real array MANA_HEAL
    static real array MANA_HEAL_PER_SECOND

    static Spell THIS_SPELL

    //! import "Spells\Artifacts\WhiteStaff\obj.j"

    Lightning effectLightning
    Timer intervalTimer
    real manaHeal
    Unit target

    //! runtextmacro LinkToStruct("WhiteStaff", "Target")

    static method Interval takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        call caster.HealManaBySpell(caster, this.manaHeal)
    endmethod

    static method Event_EndCast takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = BUFF.Event.GetLevel()

        local thistype this = caster

        local Lightning effectLightning = this.effectLightning
        local Timer intervalTimer = this.intervalTimer
        local Unit target = this.target

        call effectLightning.Destroy()
        call intervalTimer.Destroy()

        call target.Buffs.Subtract(thistype(NULL).Target.DUMMY_BUFF)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Lightning effectLightning = Lightning.Create(thistype.EFFECT_LIGHTNING_PATH)
        local Timer intervalTimer = Timer.Create()
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()

        local thistype this = caster

        set this.effectLightning = effectLightning
        set this.intervalTimer = intervalTimer
        set this.manaHeal = thistype.MANA_HEAL[level]
        set this.target = target
        call intervalTimer.SetData(this)

        call effectLightning.FromUnitToUnit.Start(caster, target)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)

        call target.Buffs.Add(thistype(NULL).Target.DUMMY_BUFF, level)
    endmethod

    static method Init takes nothing returns nothing
        local integer level

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))

        set level = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            exitwhen (level < 1)

            set thistype.MANA_HEAL[level] = thistype.MANA_HEAL_PER_SECOND[level] * thistype.INTERVAL

            set level = level - 1
        endloop
    endmethod
endstruct