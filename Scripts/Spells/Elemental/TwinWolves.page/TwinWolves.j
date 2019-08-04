//! runtextmacro BaseStruct("TwinWolves", "TWIN_WOLVES")
	static method CreateWolf takes integer level, Unit caster, real x, real y, real angle returns Unit
		local User casterOwner = caster.Owner.Get()

		local Unit wolf = Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE[level], casterOwner, x, y, angle, thistype.SUMMON_DURATION[level])

		call wolf.Abilities.AddWithLevel(Carnivore.THIS_SPELL, level)
		call wolf.VertexColor.Subtract(0., 0., 0., 255.)
		call wolf.VertexColor.Timed.Add(0., 0., 0., 255., thistype.SUMMON_FADE_IN)

		return wolf
	endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        
        local real sourceAngle = caster.Facing.Get()
        
        local real sourceOffset = caster.CollisionSize.Get(true) + thistype.SUMMON_OFFSET
        
        local real sourceX = caster.Position.X.Get() + sourceOffset * Math.Cos(sourceAngle)
        local real sourceY = caster.Position.Y.Get() + sourceOffset * Math.Sin(sourceAngle)
        
        local integer summonAmount = thistype.SUMMON_AMOUNT[level]

		local real summonWindowStart = sourceAngle - thistype.SUMMON_WINDOW / 2
		local real summonWindowAdd = thistype.SUMMON_WINDOW / (summonAmount - 1)

		local Unit array wolves

        loop
            exitwhen (summonAmount < 1)

			local real angle = summonWindowStart + (summonAmount - 1) * summonWindowAdd

			local real x = sourceX + thistype.SUMMON_OFFSET2 * Math.Cos(angle)
			local real y = sourceY + thistype.SUMMON_OFFSET2 * Math.Sin(angle)

            set wolves[summonAmount] = thistype.CreateWolf(level, caster, x, y, angle)

			call wolves[summonAmount].Order.PointTarget(Order.ATTACK, x + thistype.SUMMON_MOVE_OFFSET * Math.Cos(angle), y + thistype.SUMMON_MOVE_OFFSET * Math.Sin(angle))

            set summonAmount = summonAmount - 1
        endloop

        call Brotherhood.Add(wolves[1], level, wolves[2])
        call Brotherhood.Add(wolves[2], level, wolves[1])

		call WolfsMark.AddToUnit(caster, level)
    endmethod

    initMethod Init of Spells_Hero
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct