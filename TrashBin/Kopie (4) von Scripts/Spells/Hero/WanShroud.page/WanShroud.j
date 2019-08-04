//! runtextmacro Folder("WanShroud")
    //! runtextmacro Struct("Missile")
        Unit caster
        integer level
        real targetX
        real targetY

        static method Impact takes nothing returns nothing
            local Missile dummyMissile = MISSILE.Event.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local Unit caster = this.caster
            local integer level = this.level
            local real targetX = this.targetX
            local real targetY = this.targetY

            call this.deallocate()
            call dummyMissile.Destroy()

            call WanShroud.Start(caster, level, targetX, targetY)
        endmethod

        static method Start takes Unit caster, integer level, real targetX, real targetY returns nothing
            local Missile dummyMissile = Missile.Create()
            local thistype this = thistype.allocate()

            set this.caster = caster
            set this.level = level
            set this.targetX = targetX
            set this.targetY = targetY

            call dummyMissile.Acceleration.Set(2000.)
            call dummyMissile.Arc.SetByPerc(0.2)
            call dummyMissile.CollisionSize.Set(48.)
            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(500.)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))
        endmethod
    endstruct

    //! runtextmacro Struct("Target")
        static Event DEATH_EVENT
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

        WanShroud parent

        static method Event_BuffLose takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            call target.Armor.Relative.Subtract(thistype.ARMOR_INCREMENT[level])
            call target.EvasionChance.Defense.Add(thistype.MISS_INCREMENT[level])
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            call target.Armor.Relative.Add(thistype.ARMOR_INCREMENT[level])
            call target.EvasionChance.Defense.Subtract(thistype.MISS_INCREMENT[level])
        endmethod

        method Ending takes WanShroud parent, Unit target, Group targetGroup returns nothing
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Event.Remove(DEATH_EVENT)

                call target.Buffs.Subtract(thistype.DUMMY_BUFF)
            endif
            call target.Data.Integer.Remove(KEY_ARRAY_DETAIL + parent)
            call targetGroup.RemoveUnit(target)
        endmethod

        method EndingByParent takes Unit target, Group targetGroup returns nothing
            local WanShroud parent = this

            set this = target.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)

            call this.Ending(parent, target, targetGroup)
        endmethod

        static method Event_Death takes nothing returns nothing
            local WanShroud parent
            local Unit target = UNIT.Event.GetTrigger()
            local thistype this

            local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                set this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                set parent = this.parent

                call this.Ending(parent, target, parent.targetGroup)

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method Start takes integer level, Unit target, Group targetGroup returns nothing
            local WanShroud parent = this

            set this = thistype.allocate()

            set this.parent = parent
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Event.Add(DEATH_EVENT)

                call target.Buffs.Add(thistype.DUMMY_BUFF, level)
            endif
            call target.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)
            call targetGroup.AddUnit(target)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("WanShroud", "WAN_SHROUD")
    static BoolExpr AURA_FILTER
    static BoolExpr DAMAGE_FILTER
    static Group ENUM_GROUP
    static Group ENUM_GROUP2
    static constant real UPDATE_TIME = 0.5

    real absorptionFactor
    DummyUnit areaDummyUnit
    real areaRange
    Unit caster
    real damage
    Timer intervalTimer
    integer level
    real maxHeal
    Group targetGroup
    real targetX
    real targetY
    Timer updateTimer

    //! runtextmacro LinkToStruct("WanShroud", "Missile")
    //! runtextmacro LinkToStruct("WanShroud", "Target")

    method ClearTargetGroup takes Group targetGroup returns nothing
        local Unit target

        loop
            set target = targetGroup.GetFirst()
            exitwhen (target == NULL)

            call this.Target.EndingByParent(target, targetGroup)
        endloop
    endmethod

    static method Ending takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local DummyUnit areaDummyUnit = this.areaDummyUnit
        local Timer intervalTimer = this.intervalTimer
        local Group targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer

        call this.ClearTargetGroup(targetGroup)

        call areaDummyUnit.Destroy()
        call durationTimer.Destroy()
        call intervalTimer.Destroy()
        call targetGroup.Destroy()
        call updateTimer.Destroy()
    endmethod

    static method DamageConditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (target.Invulnerability.Try()) then
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

    static method Interval takes nothing returns nothing
        local real causedDamage
        local real damage
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster
        local real targetX = this.targetX
        local real targetY = this.targetY

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, this.areaRange, thistype.DAMAGE_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target == NULL) then
            return
        endif

        set causedDamage = 0.
        set damage = this.damage

        loop
            call target.Effects.Create(thistype.DAMAGE_EFFECT_PATH, thistype.DAMAGE_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

            set causedDamage = causedDamage + caster.DamageUnitBySpell(target, damage, true, false)

            set target = thistype.ENUM_GROUP.FetchFirst()
            exitwhen (target == NULL)
        endloop

        if (caster.Position.InRangeWithCollision(targetX, targetY, this.areaRange)) then
            call caster.HealBySpell(caster, Math.Min(this.absorptionFactor * causedDamage, this.maxHeal))
        endif
    endmethod

    static method AuraConditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.GROUND) == false) then
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

    static method Update takes nothing returns nothing
        local integer level
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster
        local Group targetGroup = this.targetGroup
        local real targetX = this.targetX
        local real targetY = this.targetY

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, this.areaRange, thistype.AURA_FILTER)

        set target = targetGroup.GetFirst()

        if (target != NULL) then
            loop
                if (thistype.ENUM_GROUP.ContainsUnit(target)) then
                    call targetGroup.RemoveUnit(target)

                    call thistype.ENUM_GROUP.RemoveUnit(target)
                    call thistype.ENUM_GROUP2.AddUnit(target)
                else
                    call this.Target.EndingByParent(target, targetGroup)
                endif

                set target = targetGroup.GetFirst()
                exitwhen (target == NULL)
            endloop

            call targetGroup.AddGroupClear(thistype.ENUM_GROUP2)
        endif

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set level = this.level

            loop
                call this.Target.Start(level, target, targetGroup)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Start takes Unit caster, integer level, real targetX, real targetY returns nothing
        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()
        local Timer updateTimer = Timer.Create()

        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local real targetZ = Spot.GetHeight(targetX, targetY)
        local thistype this = thistype.allocate()

        local DummyUnit areaDummyUnit = DummyUnit.Create(thistype.AREA_DUMMY_UNIT_ID, targetX, targetY, targetZ, 0.)

        set this.absorptionFactor = thistype.ABSORPTION_FACTOR[level]
        set this.areaDummyUnit = areaDummyUnit
        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.damage = thistype.DAMAGE_PER_INTERVAL[level]
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.maxHeal = thistype.MAX_HEAL_PER_INTERVAL[level]
        set this.targetGroup = Group.Create()
        set this.targetX = targetX
        set this.targetY = targetY
        set this.updateTimer = updateTimer
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)
        call updateTimer.SetData(this)

        call areaDummyUnit.Scale.Set(areaRange / 180.)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)

        call durationTimer.Start(thistype.DURATION[level], false, function thistype.Ending)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        call thistype(NULL).Missile.Start(UNIT.Event.GetTrigger(), SPELL.Event.GetLevel(), SPOT.Event.GetTargetX(), SPOT.Event.GetTargetY())
    endmethod

    static method Init takes nothing returns nothing
        set thistype.AURA_FILTER = BoolExpr.GetFromFunction(function thistype.AuraConditions)
        set thistype.DAMAGE_FILTER = BoolExpr.GetFromFunction(function thistype.DamageConditions)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.ENUM_GROUP2 = Group.Create()
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Target.Init()
    endmethod
endstruct