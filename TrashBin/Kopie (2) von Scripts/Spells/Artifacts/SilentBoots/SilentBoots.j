//! runtextmacro BaseStruct("SilentBoots", "SILENT_BOOTS")
    static string CASTER_EFFECT_ATTACH_POINT
    static string CASTER_EFFECT_PATH
    static Buff DUMMY_BUFF
    static real array DURATION
    static Event INVISIBILITY_EVENT
    static real array MOVE_SPEED_INCREMENT

    static Spell THIS_SPELL

    //! import "Spells\Artifacts\SilentBoots\obj.j"

    real speedIncrement

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local real speedIncrement = this.speedIncrement

        call target.Event.Remove(INVISIBILITY_EVENT)

        call target.Movement.Speed.BonusA.Subtract(speedIncrement)
    endmethod

    static method Event_InvisibilityEnding takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local real speedIncrement = thistype.MOVE_SPEED_INCREMENT[level]
        local thistype this = target

        set this.speedIncrement = speedIncrement
        call target.Event.Add(INVISIBILITY_EVENT)

        call target.Movement.Speed.BonusA.Add(speedIncrement)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call caster.Invisibility.AddTimed(thistype.DURATION[level])
        call caster.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
    endmethod

    static method Init takes nothing returns nothing
        set thistype.INVISIBILITY_EVENT = Event.Create(UNIT.Invisibility.ENDING_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_InvisibilityEnding)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "SiB", "Silent Boots", "1", "true", "ReplaceableTextures\\CommandButtons\\BTNSlippersOfAgility.blp", "This unit is stealthed and has increased movement speed.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDeath(true)
            call thistype.DUMMY_BUFF.SetLostOnDispel(true)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    endmethod
endstruct