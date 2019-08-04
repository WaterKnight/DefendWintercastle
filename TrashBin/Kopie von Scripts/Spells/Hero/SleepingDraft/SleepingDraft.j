//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("SleepingDraft", "SLEEPING_DRAFT")
    static Buff DUMMY_BUFF
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dSle", "Sleeping Draft", "DUMMY_UNIT_ID", "Abilities\\Spells\\Other\\AcidBomb\\BottleMissile.mdl")
    static real array DURATION
    static Group ENUM_GROUP
    static real array HERO_DURATION
    static string TARGET_EFFECT_ATTACH_POINT
    static string TARGET_EFFECT_PATH
    static BoolExpr TARGET_FILTER
    static integer array TARGETS_AMOUNT

    static Spell THIS_SPELL

    Unit caster
    integer level

    static method Conditions takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (filterUnit.IsAllyOf(User.TEMP)) then
            return false
        endif

        return true
    endmethod

    static method Impact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()
        local integer iteration
        local integer maxTargetsAmount
        local Unit target

        local thistype this = dummyMissile.GetData()
        local real x = dummyMissile.Position.X.Get()
        local real y = dummyMissile.Position.Y.Get()

        local Unit caster = this.caster
        local integer level = this.level

        call this.deallocate()
        call dummyMissile.Destroy()

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.GetNearest(x, y)

        if (target != NULL) then
            set iteration = 1
            set maxTargetsAmount = thistype.TARGETS_AMOUNT[level]

            loop
                exitwhen (iteration > maxTargetsAmount)

                set target = thistype.ENUM_GROUP.GetNearest(x, y)
                exitwhen (target == NULL)
                call thistype.ENUM_GROUP.RemoveUnit(target)

                call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

                if (target.Classes.Contains(UnitClass.HERO)) then
                    call target.Sleep.AddTimed(thistype.HERO_DURATION[level])
                else
                    call target.Sleep.AddTimed(thistype.DURATION[level])
                endif

                set iteration = iteration + 1
            endloop
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

        call dummyMissile.Arc.SetByPerc(0.2)
        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.5)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(700.)
        call dummyMissile.Position.SetToUnit(caster)

        call dummyMissile.GoToUnit.Start(target, false)
    endmethod

    static method Init takes nothing returns nothing
        //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "SDB", "Sleep", "5", "false", "ReplaceableTextures\\CommandButtons\\BTNPotionOfClarity.blp", "zzZ")

        //! import obj_SleepingDraft.j

        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct