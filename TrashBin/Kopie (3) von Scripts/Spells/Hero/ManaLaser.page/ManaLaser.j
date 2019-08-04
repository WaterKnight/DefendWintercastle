//! runtextmacro Folder("ManaLaser")
    //! runtextmacro Struct("Revert")
        static real X
        static real Y

        SpotEffect sourceEffect
        real x
        real y

        static method Event_SpellEffect takes nothing returns nothing
            local Unit caster = UNIT.Event.GetTrigger()

            local thistype this = caster

            local real x = this.x
            local real y = this.y

            call caster.Buffs.Remove(thistype.DUMMY_BUFF)

            call Spot.CreateEffect(caster.Position.X.Get(), caster.Position.Y.Get(), thistype.CAST_EFFECT_PATH, EffectLevel.LOW).Destroy()

            call caster.Position.SetXYZ(x, y, Spot.GetHeight(x, y))
            call Spot.CreateEffect(x, y, thistype.CAST_END_EFFECT_PATH, EffectLevel.LOW).Destroy()
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local SpotEffect sourceEffect = this.sourceEffect

            call sourceEffect.Destroy()

            call HeroSpell.AddToUnit(ManaLaser.THIS_SPELL, target)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()
            local real x = thistype.X
            local real y = thistype.Y

            local thistype this = target

            set this.sourceEffect = Spot.CreateEffect(x, y, thistype.SOURCE_EFFECT_PATH, EffectLevel.LOW)
            set this.x = x
            set this.y = y

            call HeroSpell.AddToUnit(thistype.THIS_SPELL, target)
        endmethod

        static method Start takes Unit target, real x, real y returns nothing
            set thistype.X = x
            set thistype.Y = y
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, thistype.DURATION)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("ManaLaser", "MANA_LASER")
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dMaL", "Mana Laser", "DUMMY_UNIT_ID", "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl")
    static real array DURATION
    static Group ENUM_GROUP
    static real array LENGTH
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")

    real areaRange
    real burnedManaMax
    Unit caster
    integer dispelledTargetsAmount
    integer dispelledTargetsAmountMax
    DummyUnit dummyUnit
    Timer durationTimer
    Group targetGroup
    Timer updateTimer
    real xAdd
    real yAdd

    //! runtextmacro LinkToStruct("ManaLaser", "Revert")

    static method Ending takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local Unit caster = this.caster
        local DummyUnit dummyUnit = this.dummyUnit
        local Group targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer

        local real x = dummyUnit.Position.X.Get()
        local real y = dummyUnit.Position.Y.Get()
        local real z = dummyUnit.Position.Z.Get()

        call this.deallocate()
        call dummyUnit.Destroy()
        call durationTimer.Destroy()
        call targetGroup.Destroy()
        call updateTimer.Destroy()

        call caster.Transport.Subtract()

        call caster.Position.SetXYZ(x, y, Spot.GetHeight(x, y))
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (Group.TEMP.ContainsUnit(target)) then
            return false
        endif

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.MECHANICAL)) then
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

    static method Move takes nothing returns nothing
        local real burnedMana
        local integer dispelledTargetsAmount
        local integer dispelledTargetsAmountMax
        local Lightning effectLightning
        local Unit target
        local real targetMana
        local real targetX
        local real targetY
        local thistype this = Timer.GetExpired().GetData()

        local real areaRange = this.areaRange
        local real burnedManaMax = this.burnedManaMax
        local Unit caster = this.caster
        local DummyUnit dummyUnit = this.dummyUnit
        local Group targetGroup = this.targetGroup

        local real x = dummyUnit.Position.X.Get() + this.xAdd
        local real y = dummyUnit.Position.Y.Get() + this.yAdd

        call dummyUnit.Position.Set(x, y, Spot.GetHeight(x, y) + thistype.HEIGHT)

        set User.TEMP = caster.Owner.Get()
        set Group.TEMP = targetGroup

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, areaRange, thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set dispelledTargetsAmount = this.dispelledTargetsAmount
            set dispelledTargetsAmountMax = this.dispelledTargetsAmountMax

            loop
                set effectLightning = Lightning.Create(thistype.EFFECT_LIGHTNING_PATH)
                call targetGroup.AddUnit(target)

                call effectLightning.FromDummyUnitToUnit.Start(dummyUnit, UNIT_TYPE.Outpact.Z.STANDARD, target)
                call effectLightning.DestroyTimed.Start(0.35)
                call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

                if (target.MagicImmunity.Try() == false) then
                    set targetMana = target.Mana.Get()

                    set burnedMana = Math.Min(targetMana, burnedManaMax)

                    call caster.BurnManaBySpell(target, burnedMana)

                    if (dispelledTargetsAmount < dispelledTargetsAmountMax) then
                        set dispelledTargetsAmount = dispelledTargetsAmount + 1
                        call target.Buffs.Timed.Start(Purge.DUMMY_BUFF, 1, Purge.DURATION)

                        call target.Buffs.Dispel(false, true, true)

                        set this.dispelledTargetsAmount = dispelledTargetsAmount
                    endif
                endif

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local DummyUnit dummyUnit
        local Timer durationTimer = Timer.Create()
        local integer level = SPELL.Event.GetLevel()
        local real partX
        local real partY
        local real startX
        local real startY
        local Group targetGroup = Group.Create()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()
        local thistype this = thistype.allocate()
        local Timer updateTimer = Timer.Create()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real angle = caster.CastAngle(targetX - casterX, targetY - casterY)

        set partX = Math.Cos(angle)
        set partY = Math.Sin(angle)
        set startX = casterX + thistype.START_OFFSET * partX
        set startY = casterY + thistype.START_OFFSET * partY
        set dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, startX, startY, Spot.GetHeight(startX, startY) + thistype.HEIGHT, angle)

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.burnedManaMax = thistype.BURNED_MANA_MAX[level]
        set this.caster = caster
        set this.dispelledTargetsAmount = 0
        set this.dispelledTargetsAmountMax = thistype.DISPELLED_TARGETS_AMOUNT[level]
        set this.dummyUnit = dummyUnit
        set this.durationTimer = durationTimer
        set this.targetGroup = targetGroup
        set this.updateTimer = updateTimer
        set this.xAdd = thistype.LENGTH[level] * partX
        set this.yAdd = thistype.LENGTH[level] * partY
        call durationTimer.SetData(this)
        call updateTimer.SetData(this)

        call caster.Transport.Add()

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)

        call durationTimer.Start(thistype.DURATION[level], false, function thistype.Ending)

        call thistype(NULL).Revert.Start(caster, casterX, casterY)
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration

        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        set iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set thistype.DURATION[iteration] = thistype.MAX_LENGTH[iteration] / thistype.SPEED[iteration]
            set thistype.LENGTH[iteration] = thistype.SPEED[iteration] * thistype.UPDATE_TIME

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop

        call thistype(NULL).Revert.Init()
    endmethod
endstruct