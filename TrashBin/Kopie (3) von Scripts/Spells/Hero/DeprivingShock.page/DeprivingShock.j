//! runtextmacro Folder("DeprivingShock")
    //! runtextmacro Struct("Buff")
        integer amount
        real evasionAdd

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            set this.amount = 0

            call target.EvasionChance.Bonus.Subtract(this.evasionAdd)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local integer amount = this.amount

            local real evasionAdd = thistype.EVASION_INCREMENT[level] * amount

            set this.evasionAdd = evasionAdd

            call target.EvasionChance.Bonus.Add(evasionAdd)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            local thistype this = target

            local integer amount = this.amount

            if (amount < 3) then
                set amount = this.amount

                if (amount > 0) then
                    call target.Buffs.Remove(thistype.DUMMY_BUFF[amount])
                endif

                set amount = amount + 1

                set this.amount = amount
            endif

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF[amount], level, thistype.DURATION[level])
        endmethod

        static method Event_Learn takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            set this.amount = 0
        endmethod

        static method Init takes nothing returns nothing
            local Buff currentBuff
            local integer iteration = 1

            call DeprivingShock.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))

                loop
                    exitwhen (iteration > 3)

                    set currentBuff = thistype.DUMMY_BUFF[iteration]

                    call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                    call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

                    set iteration = iteration + 1
                endloop
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("DeprivingShock", "DEPRIVING_SHOCK")
    static real array DAMAGE_FACTOR
    static BoolExpr DAMAGE_TARGET_FILTER
    static Event DEATH_EVENT
    static Event DESTROY_EVENT
    static Group ENUM_GROUP
    //! runtextmacro GetKeyArray("KEY_ARRAY")

    real areaRange
    real burnedMana
    real damage
    Lightning effectLightning
    integer level
    real stunDuration
    Unit target
    boolean targetAlive

    //! runtextmacro LinkToStruct("DeprivingShock", "Buff")

    static method Event_Death takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()
        local thistype this

        local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

        call target.Event.Remove(DEATH_EVENT)
        call target.Event.Remove(DESTROY_EVENT)
        loop
            set this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            set this.targetAlive = false
            call target.Data.Integer.Table.Remove(KEY_ARRAY, this)

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    static method Event_Destroy takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()
        local thistype this

        local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

        call target.Event.Remove(DEATH_EVENT)
        call target.Event.Remove(DESTROY_EVENT)
        loop
            set this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            set this.targetAlive = false
            call target.Data.Integer.Table.Remove(KEY_ARRAY, this)

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    static method DamageConditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target == Unit.TEMP) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.AIR) == false) then
            return false
        endif
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

    static method DealSplashDamage takes real areaRange, Unit caster, real damage, Unit primaryTarget, real x, real y returns nothing
        local Unit target

        set User.TEMP = caster.Owner.Get()
        set Unit.TEMP = caster

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, areaRange, thistype.DAMAGE_TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (primaryTarget != NULL) then
            call thistype.ENUM_GROUP.RemoveUnit(primaryTarget)
        endif

        if (target != NULL) then
            loop
                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_EndCast takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local boolean success = SPELL.Event.IsChannelComplete()

        local thistype this = caster

        local real damage = this.damage
        local Lightning effectLightning = this.effectLightning
        local integer level = this.level
        local real stunDuration = this.stunDuration
        local Unit target = this.target

        local real burnedMana = Math.Min(this.burnedMana, target.Mana.Get())
        local boolean targetAlive = this.targetAlive

        call effectLightning.Destroy()
        if (targetAlive) then
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Event.Remove(DEATH_EVENT)
                call target.Event.Remove(DESTROY_EVENT)
            endif
        endif

        if (success) then
            call thistype(NULL).Buff.Start(level, caster)

            call target.Stun.AddTimed(stunDuration, UNIT.Stun.NORMAL_BUFF)

            call caster.BurnManaBySpell(target, burnedMana)

            call caster.DamageUnitBySpell(target, damage, true, true)

            call caster.HealManaBySpell(caster, burnedMana * thistype.TRANSFERED_MANA_FACTOR)
        endif

        call target.Refs.Subtract()
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Lightning effectLightning = Lightning.Create(thistype.EFFECT_LIGHTNING_PATH)
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()

        local thistype this = caster

        set this.burnedMana = thistype.BURNED_MANA[level]
        set this.damage = thistype.DAMAGE[level]
        set this.effectLightning = effectLightning
        set this.level = level
        set this.stunDuration = thistype.STUN_DURATION[level]
        set this.target = target
        set this.targetAlive = true
        if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
            call target.Event.Add(DEATH_EVENT)
            call target.Event.Add(DESTROY_EVENT)
        endif

        call effectLightning.FromUnitToUnit.Start(caster, target)
        call target.Refs.Add()
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration

        set thistype.DAMAGE_TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.DamageConditions)
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Destroy)
        set thistype.ENUM_GROUP = Group.Create()
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))

        set iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set thistype.DAMAGE_FACTOR[iteration] = (thistype.BURNED_MANA[iteration] - thistype.DAMAGE[iteration]) / thistype.BURNED_MANA[iteration]

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop

        call thistype(NULL).Buff.Init()
    endmethod
endstruct