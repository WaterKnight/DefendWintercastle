//! runtextmacro Folder("BattleRage")
    //! runtextmacro Struct("Target")
        real damageAdd

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local real damageAdd = this.damageAdd

            call target.Damage.Relative.Subtract(damageAdd)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real damageAdd = thistype.DAMAGE_RELATIVE_INCREMENT[level]

            local thistype this = target

            set this.damageAdd = damageAdd
            call target.Damage.Relative.Add(damageAdd)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("BattleRage", "BATTLE_RAGE")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    //! runtextmacro LinkToStruct("BattleRage", "Target")

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif

        return true
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local real attackDisableDuration
        local Unit caster = UNIT.Event.GetTrigger()
        local User casterOwner
        local real damage
        local real damageFactor
        local integer level = SPELL.Event.GetLevel()
        local Unit target

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        call Spot.CreateEffect(casterX, casterY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(casterX, casterY, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set attackDisableDuration = thistype.ATTACK_DISABLE_DURATION[level]
            set casterOwner = caster.Owner.Get()
            set damage = thistype.DAMAGE[level]
            set damageFactor = thistype.DAMAGE_FACTOR[level]

            loop
                if (target.IsAllyOf(casterOwner)) then
                    call thistype(NULL).Target.Start(level, target)
                else
                    if (target.MagicImmunity.Try() == false) then
                        call target.Attack.DisableTimed(attackDisableDuration, UNIT.Attack.NORMAL_BUFF)

                        call caster.DamageUnitBySpell(target, damage + target.MaxLife.GetAll() * damageFactor, true, false)
                    endif
                endif

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