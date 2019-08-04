//! runtextmacro BaseStruct("HealExplosion", "HEAL_EXPLOSION")
    static BoolExpr DAMAGE_TARGET_FILTER
    static Group ENUM_GROUP
    static BoolExpr HEAL_TARGET_FILTER

    UnitEffect chargeEffect
    integer level

    condMethod DamageConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.NEUTRAL) then
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

    condMethod HealConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target == Unit.TEMP) then
            return false
        endif

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.NEUTRAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if not target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    eventMethod Event_EndCast
        local Unit caster = params.Unit.GetTrigger()
        local boolean success = params.Spell.IsChannelComplete()

        local thistype this = caster

        local UnitEffect chargeEffect = this.chargeEffect
        local integer level = this.level

        call chargeEffect.Destroy()

        if not success then
            return
        endif

        call caster.Effects.Create(thistype.EXPLOSION_EFFECT_PATH, thistype.EXPLOSION_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), thistype.THIS_SPELL.GetAreaRange(level), thistype.DAMAGE_TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
            	call target.Effects.Create(thistype.DAMAGE_TARGET_EFFECT_PATH, thistype.DAMAGE_TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

                call caster.DamageUnitBySpell(target, thistype.DAMAGE, false, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif

        call caster.HealBySpell(caster, thistype.HEAL)

        set User.TEMP = caster.Owner.Get()
        set Unit.TEMP = caster

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), thistype.THIS_SPELL.GetAreaRange(level), thistype.HEAL_TARGET_FILTER)

        call thistype.ENUM_GROUP.RemoveUnit(caster)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call target.Effects.Create(thistype.HEAL_TARGET_EFFECT_PATH, thistype.HEAL_TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

                call caster.HealBySpell(target, thistype.HEAL)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()

        local thistype this = caster

        set this.chargeEffect = caster.Effects.Create(thistype.CHARGE_EFFECT_PATH, thistype.CHARGE_EFFECT_ATTACH_POINT, EffectLevel.LOW)
        set this.level = level
    endmethod

    initMethod Init of Spells_Act1
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.DAMAGE_TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.DamageConditions)
        set thistype.HEAL_TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.HealConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
    endmethod
endstruct