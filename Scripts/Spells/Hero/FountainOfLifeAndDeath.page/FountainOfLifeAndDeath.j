//! runtextmacro BaseStruct("FountainOfLifeAndDeath", "FOUNTAIN_OF_LIFE_AND_DEATH")
    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

        local thistype this = thistype.allocate()

        local real angle = caster.CastAngle(targetX - caster.Position.X.Get(), targetY - caster.Position.Y.Get())

        local Unit fountain = Unit.CreateSummon(thistype.FOUNTAIN_TYPE, caster.Owner.Get(), targetX, targetY, angle, thistype.DURATION[level])

        set targetX = fountain.Position.X.Get()
        set targetY = fountain.Position.Y.Get()

        call fountain.Position.Timed.Set(targetX, targetY, Spot.GetHeight(targetX, targetY) + thistype.HEIGHT, thistype.DELAY)

        call DecayAura.AddAbility(fountain, caster, level)
        call Palingenesis.AddAbility(fountain, level)
    endmethod

    initMethod Init of Spells_Hero
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct