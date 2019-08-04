//! runtextmacro Folder("WaterBindings")
    //! runtextmacro Struct("Summon")
    	static Event DESTROY_EVENT
    	
    	real animusAdd
    	Unit caster
    	
    	eventMethod Event_Destroy
    		local Unit summon = params.Unit.GetTrigger()
    		
    		local thistype this = summon
    		
    		call summon.Event.Remove(DESTROY_EVENT)
    		
    		call caster.Intelligence.Bonus.Subtract(this.animusAdd)
    	endmethod
    	
        static method Start takes Unit caster, integer level, Unit target returns nothing
            local User casterOwner = caster.Owner.Get()
            local real casterX = caster.Position.X.Get()
            local real casterY = caster.Position.Y.Get()
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            local real angle = caster.CastAngle(targetX - casterX, targetY - casterY) 

            local Unit summon = Unit.CreateSummon(thistype.THIS_UNIT_TYPES[level], casterOwner, casterX + thistype.OFFSET * Math.Cos(angle), casterY + thistype.OFFSET * Math.Sin(angle), angle, thistype.DURATION[level])

			call summon.Event.Add(DESTROY_EVENT)

			local real animusAdd = thistype.ANIMUS_INC[level]

			set thistype(summon).animusAdd = animusAdd
			set thistype(summon).caster = caster

			call caster.Intelligence.Bonus.Add(animusAdd)

			call summon.Abilities.AddWithLevel(SoakingAttack.THIS_SPELL, level)

			return

            call summon.Abilities.AddWithLevel(Lariat.THIS_SPELL, level)

            call casterOwner.EnableAbility(Lariat.THIS_SPELL, true)

            call summon.Order.UnitTargetBySpell(Lariat.THIS_SPELL, target)

            call casterOwner.EnableAbility(Lariat.THIS_SPELL, false)
        endmethod

        static method Init takes nothing returns nothing
        	set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Destroy)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("WaterBindings", "WATER_BINDINGS")
    //! runtextmacro LinkToStruct("WaterBindings", "Summon")

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        call thistype(NULL).Summon.Start(caster, level, target)
    endmethod

    initMethod Init of Spells_Hero
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Summon.Init()
    endmethod
endstruct