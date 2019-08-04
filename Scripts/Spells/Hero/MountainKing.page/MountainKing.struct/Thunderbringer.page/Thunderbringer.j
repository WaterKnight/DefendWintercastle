//! runtextmacro BaseStruct("Thunderbringer", "THUNDERBRINGER")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif
        if target.MagicImmunity.Try() then
            return false
        endif

        return true
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        local real x = target.Position.X.Get()
        local real y = target.Position.Y.Get()

        call caster.Effects.Create(thistype.CASTER_SPECIAL_EFFECT_PATH, thistype.CASTER_SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT_PATH, EffectLevel.NORMAL).Destroy()
        call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT2_PATH, EffectLevel.NORMAL).Destroy()

        //call target.Position.Timed.AddKnockback(350., Math.AtanByDeltas(y - caster.Position.Y.Get(), x - caster.Position.X.Get()), 0.5)

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = caster.Damage.Get() + thistype.DAMAGE[level]
            local real stunDuration = thistype.STUN_DURATION[level]

            loop
                call target.Buffs.Timed.Start(UNIT.Stun.NORMAL_BUFF, level, stunDuration)

                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    initMethod Init of Spells_Artifacts
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct