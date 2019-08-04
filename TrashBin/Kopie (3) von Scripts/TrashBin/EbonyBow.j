//! runtextmacro Folder("EbonyBow")
    //! runtextmacro Struct("Secondary")
        static real array DAMAGE_FACTOR
        //! runtextmacro DummyUnit_CreateSimpleType("/", "dEbS", "EbonyBow Secondary", "DUMMY_UNIT_ID", "Abilities\\Weapons\\MoonPriestessMissile\\MoonPriestessMissile.mdl")
        static Group ENUM_GROUP
        static BoolExpr TARGET_FILTER

        Unit caster
        real damage
        Unit target

        static method Impact takes nothing returns nothing
            local Missile dummyMissile = Missile.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local Unit caster = this.caster
            local real damage = this.damage
            local Unit target = this.target

            call this.deallocate()
            call dummyMissile.Destroy()

            call caster.Damage.Events.VsUnit(target, false, damage)
        endmethod

        static method StartTarget takes Unit caster, integer level, Unit target returns nothing
            local Missile dummyMissile = Missile.Create()
            local thistype this = thistype.allocate()

            set this.caster = caster
            set this.damage = caster.Damage.GetAll() * DAMAGE_FACTOR[level]
            set this.target = target
            call dummyMissile.FromUnitToUnit.Start(caster, target, DUMMY_UNIT_ID, 0.75, 1100., 10., function thistype.Impact, false, this)
        endmethod

        static method Conditions takes nothing returns boolean
            local Unit filterUnit = UNIT.Event.Native.GetFilter()

            if (filterUnit == Unit.TEMP) then
                return false
            endif
            if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
                return false
            endif
            if (filterUnit.IsAllyOf(User.TEMP)) then
                return false
            endif

            return true
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            set User.TEMP = caster.Owner.Get()
            set Unit.TEMP = target

            call ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(target.Position.X.Get(), target.Position.Y.Get(), EbonyBow.THIS_SPELL.GetAreaRange(level), TARGET_FILTER)

            set target = ENUM_GROUP.GetFirst()

            if (target != NULL) then
                loop
                    call ENUM_GROUP.RemoveUnit(target)

                    call thistype.StartTarget(caster, level, target)

                    set target = ENUM_GROUP.GetFirst()
                    exitwhen (target == NULL)
                endloop
            endif
        endmethod

        static method Init takes nothing returns nothing
            set DAMAGE_FACTOR[1] = 0.35
            set DAMAGE_FACTOR[2] = 0.5
            set DAMAGE_FACTOR[3] = 0.6
            set DAMAGE_FACTOR[4] = 0.7
            set DAMAGE_FACTOR[5] = 0.75
            set ENUM_GROUP = Group.Create()
            set TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("EbonyBow", "EBONY_BOW")
    static real array DAMAGE_FACTOR
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dEbo", "EbonyBow", "DUMMY_UNIT_ID", "Abilities\\Weapons\\MoonPriestessMissile\\MoonPriestessMissile.mdl")

    static Spell THIS_SPELL

    Unit caster
    real damage
    Unit target

    //! runtextmacro LinkToStruct("EbonyBow", "Secondary")

    static method Impact takes nothing returns nothing
        local Missile dummyMissile = Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local real damage = this.damage
        local Unit target = this.target

        call this.deallocate()
        call dummyMissile.Destroy()

        call caster.Damage.Events.VsUnit(target, true, damage)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Missile dummyMissile = Missile.Create()
        local Unit target = UNIT.Event.GetTarget()
        local thistype this = thistype.allocate()

        local integer level = caster.Abilities.GetLevel(THIS_SPELL)

        set this.caster = caster
        set this.damage = caster.Damage.GetAll() * DAMAGE_FACTOR[level]
        set this.target = target
        call dummyMissile.FromUnitToUnit.Start(caster, target, DUMMY_UNIT_ID, 1., 1100., 10., function thistype.Impact, false, this)

        call thistype(NULL).Secondary.Start(caster, level, target)
    endmethod

    static method Init takes nothing returns nothing
        //! runtextmacro Spell_Create("/", "THIS_SPELL", "AEbB", "Ebony Bow", "ARTIFACT")

        //! runtextmacro Spell_SetAnimation("/", "attack")
        //! runtextmacro Spell_SetAreaRange5("/", "300.", "300.", "300.", "300.", "300.", "false")
        //! runtextmacro Spell_SetCooldown5("/", "0.5", "0.5", "0.5", "0.5", "0.5")
        //! runtextmacro Spell_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNImprovedBows.blp")
        //! runtextmacro Spell_SetManaCost5("/", "45", "45", "45", "45", "45")
        //! runtextmacro Spell_SetRange5("/", "600.", "600.", "600.", "600.", "600.")
        //! runtextmacro Spell_SetTargets("/", "enemy")
        //! runtextmacro Spell_SetTargetType("/", "UNIT")

        //! runtextmacro Spell_Finalize("/")

        set DAMAGE_FACTOR[1] = 1.
        set DAMAGE_FACTOR[2] = 1.2
        set DAMAGE_FACTOR[3] = 1.4
        set DAMAGE_FACTOR[4] = 1.5
        set DAMAGE_FACTOR[5] = 1.6
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Secondary.Init()
    endmethod
endstruct