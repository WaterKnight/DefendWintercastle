//! runtextmacro Spell_OpenScope("/")

//! runtextmacro Folder("RelentlessShiver")
    //! runtextmacro Struct("Buff")
        static Unit CASTER
        static Event DEATH_EVENT
        static Buff DUMMY_BUFF
        static real array DURATION
        static Buff SUMMON_BUFF
        static string SUMMON_DEATH_EFFECT_PATH
        static real array SUMMON_DURATION
        static string SUMMON_EFFECT_ATTACH_POINT
        static string SUMMON_EFFECT_PATH

        Unit caster
        integer level

        static method Event_Death takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local User casterOwner = this.caster.Owner.Get()
            local integer level = this.level

            call target.Buffs.Remove(thistype.DUMMY_BUFF)

            call target.Effects.Create(thistype.SUMMON_EFFECT_PATH, thistype.SUMMON_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

            call target.Revive()

            call target.Buffs.Add(thistype.SUMMON_BUFF, level)
            call target.Owner.Set(casterOwner)

            call target.SetSummon(thistype.SUMMON_DURATION[level])

            call target.BloodExplosion.Set(thistype.SUMMON_DEATH_EFFECT_PATH)
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            call target.Event.Remove(DEATH_EVENT)

            call target.Cold.Subtract()
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit caster = thistype.CASTER
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            set this.caster = caster
            set this.level = level

            call target.Event.Add(DEATH_EVENT)

            call target.Cold.Add()
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            set thistype.CASTER = caster

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            //! import obj_RelentlessShiver_Buff.j

            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)

                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "DRB", "Dark Reawakening", "3", "false", "ReplaceableTextures\\CommandButtons\\BTNAnimateDead.blp", "This unit frantically shivers and will be reawakened for Smokealot upon death.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\NightElf\\shadowstrike\\shadowstrike.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)

                //! runtextmacro Buff_Create("/", "SUMMON_BUFF", "DRS", "Awakened", "3", "false", "ReplaceableTextures\\CommandButtons\\BTNAnimateDead.blp", "This unit was brought back to life.")
        endmethod
    endstruct

    //! runtextmacro Struct("Missile")
        static real array DAMAGE
        //! runtextmacro DummyUnit_CreateSimpleType("/", "dReS", "Relentless Shiver", "DUMMY_UNIT_ID", "Abilities\\Weapons\\WingedSerpentMissile\\WingedSerpentMissile.mdl")

        Unit caster
        integer level

        static method Impact takes nothing returns nothing
            local Missile dummyMissile = MISSILE.Event.GetTrigger()
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local Unit caster = this.caster
            local integer level = this.level

            call this.deallocate()
            call dummyMissile.Destroy()

            call RELENTLESS_SHIVER.Buff.Start(caster, level, target)

            call caster.DamageUnitBySpell(target, thistype.DAMAGE[level], true, false)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local Missile dummyMissile = Missile.Create()
            local thistype this = thistype.allocate()

            set this.caster = caster
            set this.level = level

            call dummyMissile.Arc.SetByPerc(0.06)
            call dummyMissile.CollisionSize.Set(8.)
            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 0.5)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(500.)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToUnit.Start(target, false)
        endmethod

        static method Init takes nothing returns nothing
            //! import obj_RelentlessShiver_Missile.j
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("RelentlessShiver", "RELENTLESS_SHIVER")
    static Buff DUMMY_BUFF
    static Group ENUM_GROUP
    static real INTERVAL
    static real MANA_COST_BUFFER
    static real array MANA_COST_PER_INTERVAL
    static real array MANA_COST_PER_SECOND
    static integer array MAX_TARGETS_AMOUNT
    static string SPECIAL_EFFECT_ATTACH_POINT
    static string SPECIAL_EFFECT_PATH
    static BoolExpr TARGET_FILTER

    static Spell THIS_SPELL

    real areaRange
    Timer intervalTimer
    integer level
    real manaCostPerInterval

    //! runtextmacro LinkToStruct("RelentlessShiver", "Buff")
    //! runtextmacro LinkToStruct("RelentlessShiver", "Missile")

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.HERO)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif

        return true
    endmethod

    static method Interval takes nothing returns nothing
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        local real areaRange = this.areaRange
        local integer level = this.level
        local real manaCostPerInterval = this.manaCostPerInterval

        call caster.Mana.Subtract(manaCostPerInterval)

        if (caster.Mana.Get() < thistype.MANA_COST_BUFFER) then
            call caster.Buffs.Remove(thistype.DUMMY_BUFF)
        endif

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), areaRange, thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call thistype(NULL).Missile.Start(caster, level, target)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        local thistype this = caster

        local Timer intervalTimer = this.intervalTimer

        call intervalTimer.Destroy()
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer intervalTimer = Timer.Create()
        local integer level = BUFF.Event.GetLevel()

        local thistype this = caster

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.level = level
        set this.intervalTimer = intervalTimer
        set this.manaCostPerInterval = thistype.MANA_COST_PER_INTERVAL[level]
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration

        //! import obj_RelentlessShiver.j

        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "ReS", "Relentless Shiver", "3", "true", "ReplaceableTextures\\CommandButtons\\BTNDoom.blp", "Sends out sparks of frost, shackling hostile spirits in the living world.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

        set iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            exitwhen (iteration < 1)

            set thistype.MANA_COST_PER_INTERVAL[iteration] = thistype.MANA_COST_PER_SECOND[iteration] * thistype.INTERVAL

            set iteration = iteration - 1
        endloop

        call thistype(NULL).Buff.Init()
        call thistype(NULL).Missile.Init()

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct