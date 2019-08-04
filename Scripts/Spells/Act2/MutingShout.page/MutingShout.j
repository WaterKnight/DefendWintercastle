//! runtextmacro BaseStruct("MutingShout", "MUTING_SHOUT")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    condMethod Conditions
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

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        call Spot.CreateEffect(casterX, casterY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(casterX, casterY, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()
        local integer targetsAmount = 0

        if (target != NULL) then
            loop
                set targetsAmount = targetsAmount + 1

                call target.Buffs.Timed.Start(thistype.SILENCE_BUFF, level, thistype.SILENCE_DURATION)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif

        call caster.HealBySpell(caster, thistype.HEAL_FACTOR * caster.MaxLife.Get() * targetsAmount)
    endmethod

    initMethod Init of Spells_Act2
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call UNIT.Silence.NORMAL_BUFF.Variants.Add(thistype.SILENCE_BUFF)
    endmethod
endstruct