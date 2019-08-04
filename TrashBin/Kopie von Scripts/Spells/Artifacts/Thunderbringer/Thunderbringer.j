//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("Thunderbringer", "THUNDERBRINGER")
    static real array DAMAGE
    static real array DURATION
    static Group ENUM_GROUP
    static string SPECIAL_EFFECT_PATH
    static string SPECIAL_EFFECT2_PATH
    static real array STUN_DURATION
    static BoolExpr TARGET_FILTER

    static Spell THIS_SPELL

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif

        return true
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local real damage
        local integer level = SPELL.Event.GetLevel()
        local real stunDuration
        local Unit target = UNIT.Event.GetTarget()

        local real x = target.Position.X.Get()
        local real y = target.Position.Y.Get()

        call caster.Effects.Create("Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", AttachPoint.WEAPON, EffectLevel.LOW).Destroy()

        call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT_PATH, EffectLevel.NORMAL).Destroy()
        call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT2_PATH, EffectLevel.NORMAL).Destroy()

        call target.Position.Timed.AddKnockback(350., Math.AtanByDeltas(y - caster.Position.Y.Get(), x - caster.Position.X.Get()), 0.5)

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set damage = caster.Damage.GetAll() + thistype.DAMAGE[level]
            set stunDuration = thistype.STUN_DURATION[level]

            loop
                call target.Stun.AddTimed(stunDuration, UNIT.Stun.NORMAL_BUFF)

                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_Thunderbringer.j

        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct