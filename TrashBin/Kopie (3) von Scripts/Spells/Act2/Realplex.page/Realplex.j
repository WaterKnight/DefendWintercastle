//! runtextmacro BaseStruct("Realplex", "REALPLEX")
    static Event CASTER_DEATH_EVENT
    static Group ENUM_GROUP
    static Event ILLUSION_DEATH_EVENT
    //! runtextmacro GetKey("KEY")

    Unit caster
    Timer durationTimer
    Group illusionGroup

    method EndIllusion takes Unit illusion, Group illusionGroup returns nothing
        call illusion.Data.Integer.Remove(KEY)
        call illusion.Event.Remove(ILLUSION_DEATH_EVENT)
        call illusionGroup.RemoveUnit(illusion)
    endmethod

    method Ending takes Unit caster, Group illusionGroup returns nothing
        local Timer durationTimer = this.durationTimer
        local Unit illusion

        call this.deallocate()
        call durationTimer.Destroy()
        call caster.Data.Integer.Remove(KEY)
        call caster.Event.Remove(CASTER_DEATH_EVENT)
        loop
            set illusion = illusionGroup.GetFirst()
            exitwhen (illusion == NULL)

            call illusion.KillInstantly()
        endloop

        call illusionGroup.Destroy()
    endmethod

    static method Event_Illusion_Death takes nothing returns nothing
        local Unit illusion = UNIT.Event.GetTrigger()

        local thistype this = illusion.Data.Integer.Get(KEY)

        local Group illusionGroup = this.illusionGroup

        call this.EndIllusion(illusion, illusionGroup)
    endmethod

    static method Event_Caster_Death takes nothing returns nothing
        local thistype this = UNIT.Event.GetTrigger().Data.Integer.Get(KEY)

        call this.Ending(this.caster, this.illusionGroup)
    endmethod

    static method MoveEnding takes nothing returns nothing
        local Unit illusion
        local thistype this = Timer.GetExpired().GetData()

        local Group illusionGroup = this.illusionGroup

        loop
            set illusion = illusionGroup.FetchFirst()
            exitwhen (illusion == NULL)

            call thistype.ENUM_GROUP.AddUnit(illusion)
            call illusion.Pathing.Add()
        endloop
        call this.caster.Pathing.Add()

        loop
            set illusion = thistype.ENUM_GROUP.FetchFirst()
            exitwhen (illusion == NULL)

            call illusionGroup.AddUnit(illusion)
            call illusion.Pathing.Add()
            call PauseUnit(illusion.self, false)
        endloop
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer durationTimer = Timer.Create()
        local Unit illusion
        local Group illusionGroup = Group.Create()
        local integer iteration = ILLUSIONS_AMOUNT + 1
        local integer random = Math.RandomI(1, thistype.ILLUSIONS_AMOUNT)

        local real casterFacing = caster.Facing.Get()
        local User casterOwner = caster.Owner.Get()
        local UnitType casterType = caster.Type.Get()
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local integer level = SPELL.Event.GetLevel()
        local thistype this = caster.Data.Integer.Get(KEY)

        local real angle = casterFacing - Math.QUARTER_ANGLE

        local real xAdd = thistype.OFFSET * Math.Cos(angle)
        local real yAdd = thistype.OFFSET * Math.Sin(angle)

        local real x = casterX - thistype.ILLUSIONS_AMOUNT / 2 * xAdd
        local real y = casterY - thistype.ILLUSIONS_AMOUNT / 2 * yAdd

        call Spot.CreateEffect(casterX, casterY, thistype.CASTER_EFFECT_PATH, EffectLevel.LOW).Destroy()

        if (this != NULL) then
            call this.Ending(caster, this.illusionGroup)
        endif

        set this = thistype.allocate()

        set this.caster = caster
        set this.durationTimer = durationTimer
        set this.illusionGroup = illusionGroup
        call caster.Data.Integer.Set(KEY, this)
        call caster.Event.Add(CASTER_DEATH_EVENT)
        call caster.Pathing.Subtract()
        call durationTimer.SetData(this)

        loop
            exitwhen (iteration < 1)

            if (iteration == random) then
                call caster.Position.Timed.SetXY(x, y, thistype.MOVE_DURATION)
            else
                set illusion = Unit.CreateIllusion(casterType, casterOwner, casterX, casterY, casterFacing, thistype.DURATION, DEATH_EFFECT_PATH)

                call illusion.Damage.Relative.Invisible.Add(0.5)
                call illusion.Data.Integer.Set(KEY, this)
                call illusion.Event.Add(ILLUSION_DEATH_EVENT)
                call illusion.Pathing.Subtract()
                call illusionGroup.AddUnit(illusion)
                call PauseUnit(illusion.self, true)

                call illusion.Position.X.Set(casterX)
                call illusion.Position.Y.Set(casterY)

                call illusion.Position.Timed.SetXY(x, y, thistype.MOVE_DURATION)
            endif

            set iteration = iteration - 1
            set x = x + xAdd
            set y = y + yAdd
        endloop

        call durationTimer.Start(thistype.MOVE_DURATION, false, function thistype.MoveEnding)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.CASTER_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Caster_Death)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.ILLUSION_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Illusion_Death)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct