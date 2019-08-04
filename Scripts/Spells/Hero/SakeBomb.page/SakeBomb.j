//! runtextmacro Folder("SakeBomb")
    //! runtextmacro Struct("Missile")
        Unit caster
        integer level
        real targetX
        real targetY
        SpellInstance whichInstance

        eventMethod Impact
            local Missile dummyMissile = params.Missile.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local Unit caster = this.caster
            local integer level = this.level
            local real targetX = this.targetX
            local real targetY = this.targetY
            local SpellInstance whichInstance = this.whichInstance

            call this.deallocate()
            call dummyMissile.Destroy()

            call SakeBomb.Start(caster, level, targetX, targetY, whichInstance)
        endmethod

        static method Start takes Unit caster, integer level, real targetX, real targetY, SpellInstance whichInstance returns nothing
            local thistype this = thistype.allocate()

			local Missile dummyMissile = Missile.Create()

            set this.caster = caster
            set this.level = level
            set this.targetX = targetX
            set this.targetY = targetY
            set this.whichInstance = whichInstance

            call dummyMissile.Arc.SetByPerc(0.5)
            call dummyMissile.CollisionSize.Set(32.)
            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(700.)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SakeBomb", "SAKE_BOMB")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    DummyUnit areaDummyUnit
    real areaRange
    Unit caster
    real damage
    DummyUnit dummyUnit
    integer intervalsAmount
    real poisonDuration
    real targetX
    real targetY
    real targetZ
    SpellInstance whichInstance

    //! runtextmacro LinkToStruct("SakeBomb", "Missile")

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
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

    timerMethod Interval
        local Timer intervalTimer = Timer.GetExpired()

        local thistype this = intervalTimer.GetData()

        local integer intervalsAmount = this.intervalsAmount - 1

        if (intervalsAmount == 0) then
            local DummyUnit areaDummyUnit = this.areaDummyUnit
            local real areaRange = this.areaRange
            local Unit caster = this.caster
            local real damage = this.damage
            local DummyUnit dummyUnit = this.dummyUnit
            local real poisonDuration = this.poisonDuration
            local SpellInstance whichInstance = this.whichInstance
            local real x = this.targetX
            local real y = this.targetY

            local integer level = whichInstance.GetLevel()

            call this.deallocate()
            call areaDummyUnit.DestroyInstantly()
            call dummyUnit.Destroy()
            call intervalTimer.Destroy()
            call whichInstance.Destroy()

            call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT_PATH, EffectLevel.NORMAL).Destroy()

            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, areaRange, thistype.TARGET_FILTER)

            local Unit target = thistype.ENUM_GROUP.FetchFirst()

            if (target != NULL) then
                loop
                    local real d = Math.DistanceByDeltas(target.Position.X.Get() - x, target.Position.Y.Get() - y)

                    local real rangeFactor = Math.Shapes.LinearFromCoords(0., thistype.DAMAGE_RANGE_FACTOR_CLOSE, areaRange, thistype.DAMAGE_RANGE_FACTOR_FAR, d)

                    call caster.BurnManaBySpell(target, target.MaxMana.Get() * thistype.MANA_BURN_REL[level])

                    call caster.DamageUnitBySpell(target, rangeFactor * damage * (1. + Boolean.ToInt(target.Poisoned.Is()) * thistype.POISON_DAMAGE_ADD_FACTOR), true, true)

                    call target.Buffs.Timed.Start(thistype.POISON_BUFF, level, poisonDuration)

                    set target = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (target == NULL)
                endloop
            endif
        else
            set this.intervalsAmount = intervalsAmount
            call TEXT_TAG.CreateJumping.Create(String.Color.Do(Integer.ToString(intervalsAmount), String.Color.RelativeTo(1. - intervalsAmount * 0.05, 0.25, 0., 0.)), 0.034 - intervalsAmount * 0.003, this.targetX, this.targetY, this.targetZ + UNIT_TYPE.Outpact.Z.STANDARD, TextTag.GetFreeId())
        endif
    endmethod

    static method Start takes Unit caster, integer level, real targetX, real targetY, SpellInstance whichInstance returns nothing
        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local real poisonDuration = thistype.POISON_DURATION[level]
        local real targetZ = Spot.GetHeight(targetX, targetY)

        local thistype this = thistype.allocate()

        local DummyUnit areaDummyUnit = DummyUnit.Create(thistype.AREA_DUMMY_UNIT_ID, targetX, targetY, targetZ, UNIT.Facing.STANDARD)
        local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, targetX, targetY, targetZ, UNIT.Facing.STANDARD)
		local Timer intervalTimer = Timer.Create()

        set this.areaDummyUnit = areaDummyUnit
        set this.areaRange = areaRange
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.dummyUnit = dummyUnit
        set this.intervalsAmount = Real.ToInt(DURATION)
        set this.poisonDuration = poisonDuration
        set this.targetX = targetX
        set this.targetY = targetY
        set this.targetZ = targetZ
        set this.whichInstance = whichInstance
        call intervalTimer.SetData(this)

        call areaDummyUnit.SetScale(areaRange / (256. / 5))
        call areaDummyUnit.VertexColor.Set(255, 255, 255, 127)

        call intervalTimer.Start(1., true, function thistype.Interval)

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, areaRange, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

                call target.Buffs.Timed.Start(thistype.POISON_BUFF, level, poisonDuration)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()

        call thistype(NULL).Missile.Start(caster, params.Spell.GetLevel(), params.Spot.GetTargetX(), params.Spot.GetTargetY(), SpellInstance.Create(caster, thistype.THIS_SPELL))
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call UNIT.Poisoned.NORMAL_BUFF.Variants.Add(thistype.POISON_BUFF)
    endmethod
endstruct