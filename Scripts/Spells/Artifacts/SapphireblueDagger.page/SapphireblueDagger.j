//! runtextmacro BaseStruct("SapphireblueDagger", "SAPPHIREBLUE_DAGGER")
	static Event DAMAGE_EVENT
    static Group ENUM_GROUP
    static real array MAX_RANGE_SQUARE
    static BoolExpr TARGET_FILTER

    eventMethod Event_Damage
    	local Unit caster = params.Unit.GetTrigger()
        local Unit target = params.Unit.GetTarget()

		local integer level = caster.Buffs.GetLevel(thistype.CASTER_BUFF)

		call caster.DamageUnitBySpell(target, thistype.DAMAGE_INC[level], true, false)
    endmethod

    eventMethod Event_BuffLose
        call params.Unit.GetTrigger().Event.Remove(DAMAGE_EVENT)
    endmethod

    eventMethod Event_BuffGain
        call params.Unit.GetTrigger().Event.Add(DAMAGE_EVENT)
    endmethod

    condMethod TargetConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
            return false
        endif
        if target.Classes.Contains(UnitClass.HERO) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif
        if target.MagicImmunity.Try() then
            return false
        endif

        return true
    endmethod

	static method DoFrost takes real sourceX, real sourceY, real targetX, real targetY, Unit caster, integer level returns nothing
		local real dX = targetX - sourceX
		local real dY = targetY - sourceY
		local real width = caster.CollisionSize.Get(true)

        set User.TEMP = caster.Owner.Get()

		call thistype.ENUM_GROUP.EnumUnits.InLine.WithCollision.Do(sourceX, sourceY, Math.DistanceByDeltas(dX, dY), Math.AtanByDeltas(dY, dX), width, width, thistype.TARGET_FILTER)

		local Unit target = thistype.ENUM_GROUP.FetchFirst()

		if (target != NULL) then
			local real duration = thistype.FROST_DURATION[level]

            loop	
				call target.Buffs.Timed.Start(thistype.FROST_BUFF, level, duration)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
		endif
	endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local User casterOwner = caster.Owner.Get()
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real dX = targetX - casterX
        local real dY = targetY - casterY

        if (Math.DistanceSquareByDeltas(dX, dY) > thistype.MAX_RANGE_SQUARE[level]) then
            local real angle = caster.CastAngle(dX, dY)

            set targetX = casterX + thistype.MAX_RANGE[level] * Math.Cos(angle)
            set targetY = casterY + thistype.MAX_RANGE[level] * Math.Sin(angle)
        endif

        call Spot.CreateEffect(casterX, casterY, thistype.START_EFFECT_PATH, EffectLevel.NORMAL).Destroy()

		call thistype.DoFrost(casterX, casterY, targetX, targetY, caster, level)

        call Spot.CreateEffect(targetX, targetY, thistype.TARGET_EFFECT_PATH, EffectLevel.LOW).Destroy()

        call caster.Position.SetWithCollision(targetX, targetY)

		call caster.Buffs.Timed.Start(thistype.CASTER_BUFF, level, thistype.CASTER_BUFF_DURATION[level])

        call Swiftness.Start(caster, level)
    endmethod

    initMethod Init of Spells_Artifacts
    	set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.CASTER_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.CASTER_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call UNIT.Frost.NORMAL_BUFF.Variants.Add(thistype.FROST_BUFF)

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set thistype.MAX_RANGE_SQUARE[iteration] = Math.Square(thistype.MAX_RANGE[iteration])

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop
    endmethod
endstruct