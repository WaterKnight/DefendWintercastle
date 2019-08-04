//! runtextmacro BaseStruct("ManaColossus", "MANA_COLOSSUS")
    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()

        local User casterOwner = caster.Owner.Get()
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real angle = caster.Facing.Get()

        local Unit summon = Unit.CreateSummon(thistype.THIS_UNIT_TYPES[level], casterOwner, casterX + thistype.OFFSET * Math.Cos(angle), casterY + thistype.OFFSET * Math.Sin(angle), angle, thistype.DURATION[level])

        call summon.Abilities.AddWithLevel(TheurgicVessel.THIS_SPELL, level)
    endmethod

    initMethod Init of Spells_Hero
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct