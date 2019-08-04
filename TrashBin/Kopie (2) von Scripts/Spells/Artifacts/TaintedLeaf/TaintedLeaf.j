//! runtextmacro BaseStruct("TaintedLeaf", "TAINTED_LEAF")
    static real array HEAL
    static real array HEAL_FACTOR
    static string HEAL_TARGET_EFFECT_ATTACH_POINT
    static string HEAL_TARGET_EFFECT_PATH
    static real SELF_FACTOR
    static real array SLEEP_DURATION
    static real array SLEEP_HERO_DURATION
    static Buff TAINTED_BUFF

    static Spell THIS_SPELL

    //! import "Spells\Artifacts\TaintedLeaf\obj.j"

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        call target.Damage.Relative.Subtract(1.)
        call target.MagicImmunity.Subtract(UNIT.MagicImmunity.NONE_BUFF)
        call target.VertexColor.Subtract(255., -255., 255., 0.)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        call target.Damage.Relative.Add(1.)
        call target.MagicImmunity.Add(UNIT.MagicImmunity.NONE_BUFF)
        call target.VertexColor.Add(255., -255., 255., 0.)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()

        local UnitType targetType = target.Type.Get()

        call target.Effects.Create(thistype.HEAL_TARGET_EFFECT_PATH, thistype.HEAL_TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).DestroyTimed.Start(2.)

        call caster.HealBySpell(target, (thistype.HEAL_FACTOR[level] * target.MaxLife.GetAll() + thistype.HEAL[level]) * (1. - Boolean.ToInt(target == caster) * (1. - thistype.SELF_FACTOR)))

        if (target.IsAllyOf(caster.Owner.Get())) then
            if ((targetType == UnitType.COBRA_LILY) or (targetType == UnitType.COBRA_LILY2) or (targetType == UnitType.COBRA_LILY3) or (targetType == UnitType.COBRA_LILY4) or (targetType == UnitType.COBRA_LILY5) and (target.Buffs.Contains(thistype.TAINTED_BUFF) == false)) then
                call target.Buffs.Add(thistype.TAINTED_BUFF, 1)
            endif
        else
            call caster.Sleep.AddTimed(thistype.SLEEP_HERO_DURATION[level])
            if (target.Classes.Contains(UnitClass.HERO)) then
                call target.Sleep.AddTimed(thistype.SLEEP_HERO_DURATION[level])
            else
                call target.Sleep.AddTimed(thistype.SLEEP_DURATION[level])
            endif
        endif
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            //! runtextmacro Buff_Create("/", "TAINTED_BUFF", "TaL", "Tainted Leaf", "1", "true", "ReplaceableTextures\\CommandButtons\\BTNRejuvenation.blp", "Transformed.")

            call thistype.TAINTED_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.TAINTED_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.TAINTED_BUFF.SetLostOnDispel(true)
    endmethod
endstruct