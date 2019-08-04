//! runtextmacro Folder("Knockout")
    //! runtextmacro Struct("Target")
        Unit caster

        static method Event_BuffGain takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            set this.caster = caster
            call target.Stun.AddTimed(thistype.STUN_DURATION, UNIT.Stun.NORMAL_BUFF)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            if (target.Buffs.Contains(thistype.DUMMY_BUFF) == false) then
                call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.BUFF_DURATION)
            endif

            call target.Position.Timed.Accelerated.AddKnockback(900., -900., Math.AtanByDeltas(target.Position.Y.Get() - caster.Position.Y.Get(), target.Position.X.Get() - caster.Position.X.Get()), 0.14)

            call caster.DamageUnitBySpell(target, thistype.DAMAGE, true, false)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Knockout", "KNOCKOUT")
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dKnO", "Knockout", "DUMMY_UNIT_ID", "Abilities\\Spells\\Undead\\OrbOfDeath\\AnnihilationMissile.mdl")

    Unit caster
    integer level
    Unit target

    //! runtextmacro LinkToStruct("Knockout", "Target")

    static method Conditions takes Unit caster, Unit target returns boolean
        if (target == NULL) then
            return false
        endif

        if (target.IsAllyOf(caster.Owner.Get())) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif

        return true
    endmethod

    static method Impact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this.target

        call this.deallocate()
        call dummyMissile.Destroy()

        if (thistype.Conditions(caster, target)) then
            call thistype(NULL).Target.Start(caster, level, target)
        endif
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Missile dummyMissile = Missile.Create()
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()
        local thistype this = thistype.allocate()

        set this.caster = caster
        set this.level = level
        set this.target = target
        call caster.Position.SetWithCollision(target.Position.X.Get(), target.Position.Y.Get())

        call caster.Facing.SetToUnit(target)

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(700.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToUnit.Start(target, false)
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Target.Init()
    endmethod
endstruct