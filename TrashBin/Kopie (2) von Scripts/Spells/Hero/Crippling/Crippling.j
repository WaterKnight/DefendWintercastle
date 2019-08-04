//! runtextmacro Folder("Crippling")
    //! runtextmacro Struct("Target")
        static real array ATTACK_SPEED_INCREMENT
        static real array DAMAGE
        static string DAMAGE_EFFECT_ATTACH_POINT
        static string DAMAGE_EFFECT_PATH
        static real array DAMAGE_FACTOR
        static real array DAMAGE_RELATIVE_INCREMENT
        static Buff DUMMY_BUFF
        static real array DURATION

        //! import "Spells\Hero\Crippling\Target\obj.j"

        real attackSpeedAdd
        Unit caster
        real damage
        real damageAdd
        real damageFactor

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local real attackSpeedAdd = this.attackSpeedAdd
            local Unit caster = this.caster
            local real damage = this.damage
            local real damageAdd = this.damageAdd
            local real damageFactor = this.damageFactor

            call target.Attack.Speed.BonusA.Subtract(attackSpeedAdd)
            call target.Damage.Relative.Subtract(damageAdd)

            call target.Effects.Create(thistype.DAMAGE_EFFECT_PATH, thistype.DAMAGE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

            call caster.DamageUnitBySpell(target, damage + damageFactor * target.MaxLife.GetAll(), true, false)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit caster = Unit.TEMP
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real attackSpeedAdd = thistype.ATTACK_SPEED_INCREMENT[level]
            local real damageAdd = thistype.DAMAGE_RELATIVE_INCREMENT[level]
            local thistype this = target

            set this.attackSpeedAdd = attackSpeedAdd
            set this.caster = caster
            set this.damage = thistype.DAMAGE[level]
            set this.damageAdd = damageAdd
            set this.damageFactor = thistype.DAMAGE_FACTOR[level]

            call target.Attack.Speed.BonusA.Add(attackSpeedAdd)
            call target.Damage.Relative.Add(damageAdd)
        endmethod

        method Start takes Unit caster, integer level, Unit target returns nothing
            set Unit.TEMP = caster

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "Crp", "Crippled", "5", "false", "ReplaceableTextures\\CommandButtons\\BTNDispelMagic.blp", "This unit is weakened by 'Crippling', reduced armor and attack speed.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.SetLostOnDispel(true)
                call thistype.DUMMY_BUFF.TargetEffects.Add("Spells\\Crippling\\Target.mdx", AttachPoint.ORIGIN, EffectLevel.LOW)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Crippling", "CRIPPLING")
    static string AREA_EFFECT_PATH
    static Group ENUM_GROUP
    static real TARGET_CHANCE
    static BoolExpr TARGET_FILTER

    static Spell THIS_SPELL

    //! import "Spells\Hero\Crippling\obj.j"

    //! runtextmacro LinkToStruct("Crippling", "Target")

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif
        if (Math.Random(0., 1.) > thistype.TARGET_CHANCE) then
            return false
        endif

        return true
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()
        local Unit target
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()

        call Spot.CreateEffect(targetX, targetY, thistype.AREA_EFFECT_PATH, EffectLevel.LOW).Destroy()

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call thistype(NULL).Target.Start(caster, level, target)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Target.Init()
    endmethod
endstruct