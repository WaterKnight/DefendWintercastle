//! runtextmacro BaseStruct("Stampede", "STAMPEDE")
    static constant real BASE_DAMAGE = 25.
    static constant real BASE_DISTANCE = 300.
    static Group ENUM_GROUP
    static constant real INTERVAL = 0.5
    //! runtextmacro GetKey("KEY")
    static Event MOVE_EVENT
    static constant real SPECIAL_EFFECT_SCALE = 0.5
    static constant string SPECIAL_EFFECT_PATH = "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl"//"Abilities\\Weapons\\GlaiveMissile\\GlaiveMissileTarget.mdl"//"Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl"
    static constant string TARGET_EFFECT_ATTACH_POINT = AttachPoint.CHEST
    static constant string TARGET_EFFECT_PATH = "Abilities\\Weapons\\HydraliskImpact\\HydraliskImpact.mdl"
    static BoolExpr TARGET_FILTER

    static constant real DAMAGE_PER_DISTANCE = (BASE_DAMAGE / BASE_DISTANCE)

    static Spell THIS_SPELL

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target == Unit.TEMP) then
            return false
        endif
        if (target.Type.Is(UNIT.Type.DEAD)) then
            return false
        endif

        return true
    endmethod

    static method Event_Move takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local real distance = Math.Sqrt(Real.Event.GetTrigger())
        local Unit target

        set Unit.TEMP = caster

        call ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), caster.CollisionSize.Get(true), TARGET_FILTER)

        set target = ENUM_GROUP.GetFirst()

        if (target != NULL) then
            call EffectWithSize.Create(SPECIAL_EFFECT_PATH, caster.Position.X.Get(), caster.Position.Y.Get(), SPECIAL_EFFECT_SCALE * caster.Scale.Get()).Destroy()
            loop
                call ENUM_GROUP.RemoveUnit(target)

                call target.Effects.Create(TARGET_EFFECT_PATH, TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

                call caster.DamageUnit(target, DAMAGE_PER_DISTANCE * distance, false)

                set target = ENUM_GROUP.GetFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        if (caster.Data.Boolean.Get(KEY) != HASH_TABLE.Boolean.DEFAULT_VALUE) then
            call caster.Data.Boolean.Remove(KEY)
            call caster.Movement.Events.Unreg(MOVE_EVENT)
            call caster.Pathing.Add()
        endif
    endmethod

    static method Event_Learn takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        if (caster.Data.Boolean.Get(KEY) == HASH_TABLE.Boolean.DEFAULT_VALUE) then
            call caster.Data.Boolean.Set(KEY, HASH_TABLE.Boolean.DEFAULT_VALUE == false)
            call caster.Movement.Events.RegWithInterval(MOVE_EVENT, INTERVAL)
            call caster.Pathing.Remove()
        endif
    endmethod

    static method Init takes nothing returns nothing
        set THIS_SPELL = Spell.CreateFromSelf('A012')

        call THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_PASSIVE)

        set ENUM_GROUP = Group.Create()
        set MOVE_EVENT = Event.Create(UNIT.Movement.Events.Interval.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Move)
        set TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
    endmethod
endstruct