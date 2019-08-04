//! runtextmacro Folder("WindDance")
    //! runtextmacro Struct("Target")
    	static Event ENDING_EVENT
        static Event START_EVENT

		eventMethod Event_Ending
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local TheurgicVessel parent = aura.GetData()

			call target.Buffs.Subtract(thistype.DUMMY_BUFF)
			//call target.Movement.Add()
		endmethod

		eventMethod Event_Start
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local Unit caster = aura.GetCaster()
			local TheurgicVessel parent = aura.GetData()

			local integer level = parent.level

			call target.Buffs.Add(thistype.DUMMY_BUFF, level)
			//call target.Movement.Subtract()
		endmethod

        static method Init takes nothing returns nothing
            set thistype.ENDING_EVENT = Event.Create(AURA.Target.ENDING_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Ending)
            set thistype.START_EVENT = Event.Create(AURA.Target.START_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Start)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("WindDance", "WIND_DANCE")
	static real array DAMAGE_PER_INTERVAL
	static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    Aura aura
    Unit caster
    real damage
    Timer intervalTimer
    integer level

    //! runtextmacro LinkToStruct("WindDance", "Target")

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    static method Interval takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

		local real areaRange = this.aura.GetAreaRange()
        local Unit caster = this.caster
        local Unit cyclone = this

		local real x = cyclone.Position.X.Get()
		local real y = cyclone.Position.Y.Get()

        set User.TEMP = cyclone.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, areaRange, thistype.TARGET_FILTER)

		local Unit target = thistype.ENUM_GROUP.FetchFirst()

		if (target != NULL) then
			local real damage = this.damage

        	loop
        		local real dX = target.Position.X.Get() - x
        		local real dY = target.Position.Y.Get() - y

        		local real d = Math.DistanceByDeltas(dX, dY)
        		local real ang = Math.AtanByDeltas(dY, dX)

        		local real rangeFactor = Math.Limit(Math.Shapes.LinearFromCoords(0., 1., areaRange, 0., d), 0., 1.)

				set ang = ang + thistype.ANGLE_SPEED_MAX * rangeFactor * thistype.DAMAGE_INTERVAL
				set d = d * (1 - thistype.DIST_DEC_FACTOR * thistype.DAMAGE_INTERVAL)

				//call target.Position.Timed.Accelerated.AddKnockback(areaRange * rangeFactor, 0., ang + Math.QUARTER_ANGLE, thistype.DAMAGE_INTERVAL)
				call target.Position.SetXY(x + d * Math.Cos(ang), y + d * Math.Sin(ang))

            	call caster.DamageUnitBySpell(target, damage * rangeFactor, true, false)

            	set target = thistype.ENUM_GROUP.FetchFirst()
            	exitwhen (target == NULL)
        	endloop
        endif
    endmethod

    eventMethod Event_BuffLose
        local Unit cyclone = params.Unit.GetTrigger()

        local thistype this = cyclone

		local Aura aura = this.aura
		local Timer intervalTimer = this.intervalTimer

		call aura.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = params.Buff.GetData()
        local Unit cyclone = params.Unit.GetTrigger()
        local integer level = params.Buff.GetLevel()

        local thistype this = cyclone

		local Aura aura = Aura.Create(cyclone)
        local Timer intervalTimer = Timer.Create()

		set this.aura = aura
        set this.caster = caster
        set this.damage = thistype.DAMAGE_PER_INTERVAL[level]
        set this.intervalTimer = intervalTimer
        set this.level = level
        call aura.SetData(this)
        call intervalTimer.SetData(this)

		call aura.SetAreaRange(Cyclone.THIS_SPELL.GetAreaRange(level))
        call aura.SetTargetFilter(thistype.TARGET_FILTER)

		call aura.Event.Add(thistype(NULL).Target.ENDING_EVENT)
		call aura.Event.Add(thistype(NULL).Target.START_EVENT)

		call aura.Enable()

		call intervalTimer.Start(thistype.DAMAGE_INTERVAL, true, function thistype.Interval)
    endmethod

    eventMethod Event_Unlearn
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

	static Unit CASTER = NULL

    eventMethod Event_Learn
    	local Unit caster = thistype.CASTER
    	local Unit cyclone = params.Unit.GetTrigger()

		set thistype.CASTER = NULL

		if (caster == NULL) then
			set caster = cyclone.Owner.Get().Hero.Get()
		endif

        call cyclone.Buffs.AddEx(thistype.DUMMY_BUFF, params.Spell.GetLevel(), caster)
    endmethod

    static method AddToUnit takes Unit caster, Unit cyclone, integer level returns nothing
    	set thistype.CASTER = caster

        call cyclone.Abilities.AddWithLevel(thistype.THIS_SPELL, level)
    endmethod

    static method Init takes nothing returns nothing
    	set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))

        local integer iteration = Cyclone.THIS_SPELL.GetLevelsAmount()

        loop
            exitwhen (iteration < 1)

            set thistype.DAMAGE_PER_INTERVAL[iteration] = thistype.DAMAGE_PER_SECOND[iteration] * thistype.DAMAGE_INTERVAL

            set iteration = iteration - 1
        endloop

		call thistype(NULL).Target.Init()
    endmethod
endstruct