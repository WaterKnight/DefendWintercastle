//! runtextmacro BaseStruct("SpiritWolves", "SPIRIT_WOLVES")
    //! runtextmacro GetKey("KEY")
    static Event SUMMON_DEATH_EVENT

    Unit caster
    UnitList summonGroup
    SpellInstance whichInstance

    eventMethod Event_Summon_Death
        local Unit summon = params.Unit.GetTrigger()

        local thistype this = summon.Data.Integer.Get(KEY)

        local UnitList summonGroup = this.summonGroup

        call summon.Data.Integer.Remove(KEY)
        call summon.Event.Remove(SUMMON_DEATH_EVENT)
        call summonGroup.Remove(summon)

        if summonGroup.IsEmpty() then
            local Unit caster = this.caster
            local SpellInstance whichInstance = this.whichInstance

            call this.deallocate()
            call caster.Data.Integer.Remove(KEY)
            call summonGroup.Destroy()
            call whichInstance.Destroy()
        endif
    endmethod

	method Ending takes nothing returns nothing
        local UnitList summonGroup = this.summonGroup

        local Unit summon = summonGroup.GetFirst()

        call summonGroup.Refs.Add()

        loop
            call summon.Kill()

            set summon = summonGroup.GetFirst()
            exitwhen (summon == NULL)
        endloop

        call summonGroup.Refs.Remove()
	endmethod

    method CreateSummon takes User casterOwner, real casterX, real casterY, real angle, UnitList summonGroup returns Unit
        local Unit summon = Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE, casterOwner, casterX, casterY, angle, thistype.DURATION)

        call summon.Data.Integer.Set(KEY, this)
        call summon.Event.Add(SUMMON_DEATH_EVENT)
        call summonGroup.Add(summon)

		return summon
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()

        local thistype this = caster.Data.Integer.Get(KEY)

        if (this != NULL) then
            call this.Ending()
        endif

		local integer iteration = thistype.SUMMON_AMOUNT

        if (iteration > 0) then
            set this = thistype.allocate()

			local UnitList summonGroup = UnitList.Create()

            set this.caster = caster
            set this.summonGroup = summonGroup
            set this.whichInstance = SpellInstance.Create(caster, thistype.THIS_SPELL)
            call caster.Data.Integer.Set(KEY, this)

			local real angle = caster.Facing.Get()
			local User casterOwner = caster.Owner.Get()
	        local real casterX = caster.Position.X.Get() + thistype.OFFSET * Math.Cos(angle)
	        local real casterY = caster.Position.Y.Get() + thistype.OFFSET * Math.Sin(angle)

            loop
                local Unit summon = this.CreateSummon(casterOwner, casterX, casterY, angle, summonGroup)

                set iteration = iteration - 1
                exitwhen (iteration < 1)
            endloop
        endif
    endmethod

    initMethod Init of Spells_Act2
        set thistype.SUMMON_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Summon_Death)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct