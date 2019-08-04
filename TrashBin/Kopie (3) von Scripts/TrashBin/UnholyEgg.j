//! runtextmacro Folder("UnholyEgg")
    //! runtextmacro Struct("Hatching")
        static Event DEATH_EVENT
        static constant real DELAY = 5.
        static constant real DELAY_EPSILON = 0.01
        static constant real DURATION = 30.
        static UnitType EGG_UNIT_TYPE
        //! runtextmacro GetKey("KEY")
        static UnitType SUMMON_UNIT_TYPE

        Timer durationTimer
        Unit egg

        method Ending takes Timer durationTimer, Unit egg returns nothing
            call this.deallocate()
            call durationTimer.Data.Integer.Remove(KEY)
            call egg.Data.Integer.Remove(KEY)
            call egg.Event.Remove(DEATH_EVENT)
        endmethod

        static method EndingByTimer takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.Data.Integer.Get(KEY)

            local Unit egg = this.egg

            call this.Ending(durationTimer, egg)

            call Unit.CreateSummon(SUMMON_UNIT_TYPE, egg.Owner.Get(), egg.Position.X.Get(), egg.Position.Y.Get(), UNIT.Facing.STANDARD, DURATION)
        endmethod

        static method Event_Death takes nothing returns nothing
            local Unit egg = UNIT.Event.GetTrigger()

            local thistype this = egg.Data.Integer.Get(KEY)

            call this.Ending(this.durationTimer, egg)
        endmethod

        static method Start takes Unit caster, real targetX, real targetY returns nothing
            local thistype this = thistype.allocate()
            local Timer durationTimer = Timer.Create()
            local Unit egg = Unit.CreateSummon(EGG_UNIT_TYPE, caster.Owner.Get(), targetX, targetY, UNIT.Facing.STANDARD, DELAY + DELAY_EPSILON)

            set this.durationTimer = durationTimer
            set this.egg = egg
            call durationTimer.Data.Integer.Set(KEY, this)
            call egg.Data.Integer.Set(KEY, this)
            call egg.Event.Add(DEATH_EVENT)

            call durationTimer.Start(DELAY, false, function thistype.EndingByTimer)
        endmethod

        static method Init takes nothing returns nothing
            set DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
            set EGG_UNIT_TYPE = UnitType.UNHOLY_EGG
            set SUMMON_UNIT_TYPE = UnitType.SKELETON
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("UnholyEgg", "UNHOLY_EGG")
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dUnE", "Unholy Egg", "DUMMY_UNIT_ID", "Doodads\\Dungeon\\Terrain\\EggSack\\EggSack1.mdl")

    static Spell THIS_SPELL

    //! runtextmacro LinkToStruct("UnholyEgg", "Hatching")

    Unit caster
    Missile dummyMissile
    real targetX
    real targetY

    static method Impact takes nothing returns nothing
        local thistype this = thistype(Missile.GetTrigger().GetDataPackage())

        local Unit caster = this.caster
        local Missile dummyMissile = this.dummyMissile
        local real targetX = this.targetX
        local real targetY = this.targetY

        call this.deallocate()
        call dummyMissile.Destroy()

        call thistype(NULL).Hatching.Start(caster, targetX, targetY)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Missile dummyMissile = Missile.Create()
        local DummyUnit dummyUnit
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()
        local thistype this = thistype.allocate()

        set dummyUnit = dummyMissile.FromUnitToUnit.GetDummyUnit()

        set this.caster = caster
        set this.dummyMissile = dummyMissile
        set this.targetX = targetX
        set this.targetY = targetY
        call dummyMissile.FromUnitToSpot.Start(caster, targetX, targetY, Spot.GetHeight(targetX, targetY), DUMMY_UNIT_ID, Hatching.EGG_UNIT_TYPE.Scale.Get(), 900., 10., function thistype.Impact, this)
    endmethod

    static method Init takes nothing returns nothing
        set THIS_SPELL = Spell.CreateFromSelf('A024')

        call THIS_SPELL.SetOrder(Order.WARD)
        call THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)

        call THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call Hatching.Init()
    endmethod
endstruct