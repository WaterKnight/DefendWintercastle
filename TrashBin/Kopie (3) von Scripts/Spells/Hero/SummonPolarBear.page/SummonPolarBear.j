//! runtextmacro Folder("SummonPolarBear")
    //! runtextmacro Struct("Summon")
        static Event BEAR_DEATH_EVENT
        static Event CASTER_DEATH_EVENT
        //! runtextmacro GetKey("KEY")

        Unit bear
        Unit caster
        real remainingLife
        Timer remainingLifeTimer

        static method Event_Bear_Death takes nothing returns nothing
            local Unit bear = UNIT.Event.GetTrigger()

            local thistype this = bear.Data.Integer.Get(KEY)
            local Unit caster = this.caster
            local real remainingLife = this.remainingLife
            local Timer remainingLifeTimer = this.remainingLifeTimer

            call this.deallocate()
            call bear.Data.Integer.Remove(KEY)
            call bear.Event.Remove(BEAR_DEATH_EVENT)
            call caster.Data.Integer.Remove(KEY)
            call caster.Event.Remove(CASTER_DEATH_EVENT)
            call remainingLifeTimer.Destroy()

            if (remainingLife > 0.) then
                call caster.HealBySpell(caster, remainingLife * thistype.HEAL_FACTOR)
            endif
        endmethod

        static method CatchLife takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()

            local Unit bear = this.bear

            set this.remainingLife = Math.Max(bear.Life.Get(), bear.MaxLife.GetAll() * thistype.REMAINING_LIFE_MIN_FACTOR)
        endmethod

        static method Event_Caster_Death takes nothing returns nothing
            local thistype this = UNIT.Event.GetTrigger().Data.Integer.Get(KEY)

            call this.bear.KillInstantly()
        endmethod

        static method Start takes Unit caster, integer level, Unit target, real x, real y returns nothing
            local Unit bear
            local User casterOwner = caster.Owner.Get()
            local real remainingLife
            local Timer remainingLifeTimer
            local thistype this = caster.Data.Integer.Get(KEY)

            if (this != NULL) then
                set bear = this.bear

                set remainingLife = bear.Life.Get()

                call bear.KillInstantly()

                call caster.HealBySpell(caster, remainingLife * thistype.HEAL_FACTOR)
            endif

            set bear = Unit.CreateSummon(thistype.SUMMON_UNIT_TYPES[level], casterOwner, x, y, UNIT.Facing.STANDARD, thistype.DURATION[level])
            set remainingLifeTimer = Timer.Create()

            set this = thistype.allocate()

            set this.bear = bear
            set this.caster = caster
            set this.remainingLife = 0.
            set this.remainingLifeTimer = remainingLifeTimer
            call bear.Data.Integer.Set(KEY, this)
            call bear.Event.Add(BEAR_DEATH_EVENT)
            call caster.Data.Integer.Set(KEY, this)
            call caster.Event.Add(CASTER_DEATH_EVENT)
            call remainingLifeTimer.SetData(this)

            call bear.Invulnerability.AddTimed(thistype.INVULNERABILITY_DURATION[level], UNIT.Invulnerability.NORMAL_BUFF)

            call remainingLifeTimer.Start(thistype.DURATION[level] - 0.01, false, function thistype.CatchLife)

            call bear.Abilities.Add(thistype.TAUNT_SPELL)

            call casterOwner.EnableAbility(thistype.TAUNT_SPELL, true)

            call bear.Order.Immediate(Order.TAUNT)

            call casterOwner.EnableAbility(thistype.TAUNT_SPELL, false)

            if (target.IsAllyOf(casterOwner)) then
                call target.Invulnerability.AddTimed(thistype.INVULNERABILITY_DURATION[level], UNIT.Invulnerability.NORMAL_BUFF)
            else
                //call bear.Order.UnitTarget(Order.ATTACK, target)
                call bear.Order.UnitTargetBySpell(ArcticBlink.THIS_SPELL, target)
            endif
        endmethod

        //! textmacro SummonPolarBear_Taunt_Create takes doExternal
            $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
                //! i local function GetCurrentRaw()
                    //! i file = io.open("test.lua", "r")

                    //! i result = file:read("*all")

                    //! i file:close()

                    //! i return result
                //! i end

                //! i setobjecttype("abilities")

                //! i modifyobject(GetCurrentRaw())
            $doExternal$//! endexternalblock
        //! endtextmacro

        static method Init2 takes nothing returns nothing
            //! runtextmacro Spell_Create("/", "TAUNT_SPELL", "ATau", "Taunt")

            //! runtextmacro Spell_SetTypes("/", "SPECIAL_Atau", "NORMAL")

            //! runtextmacro Spell_SetAreaRange("/", "450.", "true")

            ///! runtextmacro SummonPolarBear_Taunt_Create("/")

            //! runtextmacro Spell_Finalize("/")
        endmethod

        static method Init takes nothing returns nothing
            set thistype.BEAR_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Bear_Death)
            set thistype.CASTER_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Caster_Death)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SummonPolarBear", "SUMMON_POLAR_BEAR")
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dSuB", "SummonPolarBear", "DUMMY_UNIT_ID", "units\\creeps\\PolarBear\\PolarBear.mdl")

    Unit caster
    integer level
    Unit target

    //! runtextmacro LinkToStruct("SummonPolarBear", "Summon")

    static method Impact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this.target
        local real targetX = dummyMissile.Position.X.Get()
        local real targetY = dummyMissile.Position.Y.Get()

        call this.deallocate()
        call dummyMissile.Destroy()

        call thistype(NULL).Summon.Start(caster, level, target, targetX, targetY)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Missile dummyMissile = Missile.Create()
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()
        local thistype this = thistype.allocate()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local UnitType summonType = thistype(NULL).Summon.SUMMON_UNIT_TYPES[level]
        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()

        set this.caster = caster
        set this.level = level
        set this.target = target

        call dummyMissile.Arc.SetByPerc(0.06)
        call dummyMissile.CollisionSize.Set(2 * summonType.CollisionSize.Get())
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 0.25)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(summonType.Speed.Get() * 4.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Summon.Init()

        call thistype(NULL).Summon.Init2()
    endmethod
endstruct