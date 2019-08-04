//! runtextmacro Folder("GhostSword")
    //! runtextmacro Struct("Sword")
    	static Event CRIT_EVENT
        static Event DAMAGE_EVENT
    	static Group ENUM_GROUP
    	static BoolExpr TARGET_FILTER
        static constant real UPDATE_TIME = 0.1
        static Timer UPDATE_TIMER

		//! runtextmacro CreateList("ACTIVE_LIST")
		//! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

		boolean active
		Timer cooldownTimer
        real damageFactor
        integer level
        real stolenMana

		eventMethod Event_Crit
			local Unit sword = params.Unit.GetTrigger()
			local Unit target = params.Unit.GetTarget()

			local thistype this = sword

			local real duration

			if target.Classes.Contains(UnitClass.HERO) then
				set duration = thistype.PURGE_HERO_DURATION[level]
			else
				set duration = thistype.PURGE_DURATION[level]
			endif

			call Purge.Start(this.level, target, duration)
		endmethod

        eventMethod Event_Damage
            local Unit sword = params.Unit.GetDamager()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = sword

            local real stolenMana = Math.Min(target.Mana.Get(), this.stolenMana)

            if (stolenMana > 0.) then
                call target.Effects.Create(thistype.VICTIM_EFFECT_PATH, thistype.VICTIM_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
                call target.Mana.Subtract(stolenMana)

                call sword.DamageUnitBySpell(target, stolenMana * this.damageFactor, true, false)
            endif
        endmethod

		timerMethod Cooldown
			local thistype this = Timer.GetExpired().GetData()

			set this.active = true

			if thistype.ACTIVE_LIST_Add(this) then
				call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
			endif
		endmethod

	    condMethod Conditions
	        local Unit target = UNIT.Event.Native.GetFilter()
	
	        if target.Classes.Contains(UnitClass.DEAD) then
	            return false
	        endif
	        if target.IsAllyOf(User.TEMP) then
	            return false
	        endif
	
	        return true
	    endmethod

		timerMethod Update
            call thistype.FOR_EACH_LIST_Set()

            loop
                local thistype this = thistype.FOR_EACH_LIST_FetchFirst()
                exitwhen (this == NULL)

				local Unit sword = this

        		set User.TEMP = sword.Owner.Get()

        		call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(sword.Position.X.Get(), sword.Position.Y.Get(), sword.CollisionSize.Get(true), thistype.TARGET_FILTER)

		        local Unit target = thistype.ENUM_GROUP.FetchFirst()

				if (target != NULL) then
					if thistype.ACTIVE_LIST_Remove(this) then
						call thistype.UPDATE_TIMER.Pause()
					endif

					set this.active = false

					call this.cooldownTimer.Start(1., false, function thistype.Cooldown)

					call sword.Animation.Set(Animation.ATTACK)

					loop
                		call sword.Damage.Events.VsUnit(target, true, sword.Damage.Get())

						set target = thistype.ENUM_GROUP.FetchFirst()
						exitwhen (target == NULL)
                	endloop
                endif
            endloop
		endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

			local Timer cooldownTimer = this.cooldownTimer

            //call Spot.CreateEffect(target.Position.X.Get(), target.Position.Y.Get(), thistype.DEATH_EFFECT_PATH, EffectLevel.LOW)
            call target.Effects.Create(thistype.DEATH_EFFECT_PATH, thistype.DEATH_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

			call cooldownTimer.Destroy()
			call target.Event.Remove(CRIT_EVENT)
            call target.Event.Remove(DAMAGE_EVENT)

			if this.active then
				if thistype.ACTIVE_LIST_Remove(this) then
					call thistype.UPDATE_TIMER.Pause()
				endif
			endif
        endmethod

        eventMethod Event_BuffGain
            local integer level = params.Buff.GetLevel()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

			local Timer cooldownTimer = Timer.Create()

			set this.active = true
			set this.cooldownTimer = cooldownTimer
            set this.damageFactor = thistype.DAMAGE_FACTOR[level]
            set this.level = level
            set this.stolenMana = thistype.STOLEN_MANA[level]
            call cooldownTimer.SetData(this)

            //call Spot.CreateEffect(target.Position.X.Get(), target.Position.Y.Get(), thistype.SUMMON_EFFECT_PATH, EffectLevel.LOW).Destroy()
            call target.Effects.Create(thistype.SUMMON_EFFECT_PATH, thistype.SUMMON_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

            call target.Event.Add(CRIT_EVENT)
            call target.Event.Add(DAMAGE_EVENT)

			if thistype.ACTIVE_LIST_Add(this) then
				//call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
			endif
        endmethod

        static method Create takes User casterOwner, real x, real y, real angle, integer level returns Unit
            local Unit sword = Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE[level], casterOwner, x, y, angle, GhostSword.DURATION[level])

            call sword.Buffs.Add(thistype.DUMMY_BUFF, level)

            //call sword.Abilities.AddBySelf(DummyUnit.LOCUST_SPELL_ID)
            //call sword.Animation.Loop.Start(Animation.STAND_READY)
            call sword.Ghost.Add()
            call sword.Movement.Subtract()
            call sword.Pathing.Subtract()

            call sword.Abilities.AddWithLevel(HackNSlay.THIS_SPELL, level)
            call sword.Abilities.Add(Invulnerability.THIS_SPELL)

            return sword
        endmethod

        static method Init takes nothing returns nothing
        	set thistype.CRIT_EVENT = Event.Create(UNIT.CriticalChance.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Crit)
            set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
            set thistype.UPDATE_TIMER = Timer.Create()
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

        	set thistype.ENUM_GROUP = Group.Create()
        	set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("GhostSword", "GHOST_SWORD")
    //! runtextmacro GetKeyArray("SWORDS_KEY_ARRAY")
    static Event TRANSPORT_START_EVENT
    static Event TRANSPORT_ENDING_EVENT
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")
    static Timer UPDATE_TIMER

    //! runtextmacro CreateList("ACTIVE_LIST")
    //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

    real angle
    real angleAdd

    //! runtextmacro LinkToStruct("GhostSword", "Sword")

    timerMethod Update
        call thistype.FOR_EACH_LIST_Set()

        loop
            local thistype this = thistype.FOR_EACH_LIST_FetchFirst()
            exitwhen (this == NULL)

            local real angle = this.angle
            local real angleAdd = this.angleAdd
            local Unit target = this

            //local real angle = target.Facing.Get() - Math.QUARTER_ANGLE
            //local real angleAdd = Math.HALF_ANGLE

            local real colSize = target.CollisionSize.Get(true)

            set this.angle = angle + thistype.ANGLE_SPEED * thistype.UPDATE_TIME

            local integer iteration = target.Data.Integer.Table.Count(SWORDS_KEY_ARRAY)

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local Unit sword = target.Data.Integer.Table.Get(SWORDS_KEY_ARRAY, iteration)

				if (target.Order.GetNative() == NULL) then
                	//call sword.Facing.Set(angle)
                endif
                //call SetUnitLookAt(sword.self, "bone_chest", sword.self, Math.Cos(angle), Math.Sin(angle), 0.)
                call sword.Position.SetXY(target.Position.X.Get() + (colSize * (1 + thistype.SUMMON_OFFSET_FACTOR)) * Math.Cos(angle), target.Position.Y.Get() + (colSize * (1 + thistype.SUMMON_OFFSET_FACTOR)) * Math.Sin(angle))
                //call sword.Position.SetXY(target.Position.X.Get() + (colSize * (1 + thistype.SUMMON_OFFSET_FACTOR)) * Math.Cos(angle), target.Position.Y.Get() + (colSize * (1 + thistype.SUMMON_OFFSET_FACTOR)) * Math.Sin(angle))
                //call sword.Scale.Set(colSize / 36.)

                set angle = angle + angleAdd
                set iteration = iteration - 1
            endloop
        endloop
    endmethod

	eventMethod Event_TransportEnding
		local Unit target = params.Unit.GetTrigger()

		local thistype this = target

        if thistype.ACTIVE_LIST_Add(this) then
            call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
        endif

        local integer iteration = target.Data.Integer.Table.Count(SWORDS_KEY_ARRAY)

        loop
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

            local Unit sword = target.Data.Integer.Table.Get(SWORDS_KEY_ARRAY, iteration)

            call sword.Transport.Subtract()

            set iteration = iteration - 1
        endloop
	endmethod

	eventMethod Event_TransportStart
		local Unit target = params.Unit.GetTrigger()

		local thistype this = target

        if thistype.ACTIVE_LIST_Remove(this) then
            call thistype.UPDATE_TIMER.Pause()
        endif

        local integer iteration = target.Data.Integer.Table.Count(SWORDS_KEY_ARRAY)

        loop
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

            local Unit sword = target.Data.Integer.Table.Get(SWORDS_KEY_ARRAY, iteration)

            call sword.Transport.Add()

            set iteration = iteration - 1
        endloop
	endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local integer iteration = target.Data.Integer.Table.Count(SWORDS_KEY_ARRAY)

        loop
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

            local Unit sword = target.Data.Integer.Table.Get(SWORDS_KEY_ARRAY, iteration)

            call sword.Kill()

            call sword.Refs.Subtract()

            set iteration = iteration - 1
        endloop

        call target.Data.Integer.Table.Clear(SWORDS_KEY_ARRAY)

		call target.Event.Remove(TRANSPORT_ENDING_EVENT)
		call target.Event.Remove(TRANSPORT_START_EVENT)

        if thistype.ACTIVE_LIST_Remove(this) then
            call thistype.UPDATE_TIMER.Pause()
        endif
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()
        local SpellInstance whichInstance = params.Buff.GetData()

        local Unit caster = whichInstance.GetCaster()

        local real colSize = target.CollisionSize.Get(true)
        local integer iteration = thistype.SUMMONS_AMOUNT[level]
        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()

        local real angle = caster.Facing.Get()
        local real angleAdd = Math.FULL_ANGLE / iteration
        local User casterOwner = caster.Owner.Get()

		local thistype this = target

        set this.angle = angle
        set this.angleAdd = angleAdd
        call target.Event.Add(TRANSPORT_ENDING_EVENT)
        call target.Event.Add(TRANSPORT_START_EVENT)

        loop
            exitwhen (iteration < 1)

            local Unit sword = thistype(NULL).Sword.Create(casterOwner, targetX + (colSize * (1 + thistype.SUMMON_OFFSET_FACTOR)) * Math.Cos(angle), targetY + (colSize * (1 + thistype.SUMMON_OFFSET_FACTOR)) * Math.Sin(angle), angle, level)

            call target.Data.Integer.Table.Add(SWORDS_KEY_ARRAY, sword)

            call sword.Refs.Add()
            call sword.Scale.Set(colSize / 36.)

			call SetUnitLookAt(sword.self, "bone_chest", target.self, 0., 0., 0.)

            set angle = angle + angleAdd
            set iteration = iteration - 1
        endloop

        if thistype.ACTIVE_LIST_Add(this) then
            call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
        endif
    endmethod

    eventMethod Event_SpellEffect
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()
        local SpellInstance whichInstance = params.SpellInstance.GetTrigger()

		call target.Buffs.Remove(thistype.DUMMY_BUFF)

        call target.Buffs.Timed.StartEx(thistype.DUMMY_BUFF, level, whichInstance, thistype.DURATION[level])
    endmethod

    initMethod Init of Spells_Purchasable
        set thistype.TRANSPORT_ENDING_EVENT = Event.Create(UNIT.Transport.ENDING_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_TransportEnding)
        set thistype.TRANSPORT_START_EVENT = Event.Create(UNIT.Transport.START_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_TransportStart)
        set thistype.UPDATE_TIMER = Timer.Create()
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Sword.Init()
    endmethod
endstruct