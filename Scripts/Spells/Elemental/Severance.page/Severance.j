//! runtextmacro Folder("Severance")
    //! runtextmacro Struct("Buff")
        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
        	call UNIT.Madness.NORMAL_BUFF.Variants.Add(thistype.DUMMY_BUFF)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Severance", "SEVERANCE")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    real areaRange
    Unit caster
    real damage
    integer level
    integer maxTargetsAmount
    Unit target
    UnitList targetGroup
    integer targetsAmount

    //! runtextmacro LinkToStruct("Severance", "Buff")

    method Ending takes nothing returns nothing
        call this.deallocate()
        call this.targetGroup.Destroy()
    endmethod

    static method Conditions takes Unit target returns boolean
        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
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

    condMethod Conditions_Group
        local Unit target = UNIT.Event.Native.GetFilter()

        if UnitList.TEMP.Contains(target) then
            return false
        endif
        if not thistype.Conditions(target) then
            return false
        endif

        return true
    endmethod

    method StartMissile takes real sourceX, real sourceY, real sourceZ, Unit target returns nothing
        local Missile dummyMissile = Missile.Create()

        set this.target = target

        call this.targetGroup.Add(target)

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(900.)
        call dummyMissile.Position.Set(sourceX, sourceY, sourceZ)

        call dummyMissile.GoToUnit.Start(target, null)
    endmethod

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer maxTargetsAmount = this.maxTargetsAmount
        local integer targetsAmount = this.targetsAmount
        local Unit target = this.target
        local UnitList targetGroup = this.targetGroup

        local real targetX = dummyMissile.Position.X.Get()
        local real targetY = dummyMissile.Position.Y.Get()
        local real targetZ = dummyMissile.Position.Z.Get()

        call dummyMissile.Destroy()

        if (target != NULL) then
            set User.TEMP = caster.Owner.Get()

            if thistype.Conditions(target) then
                local real damage = this.damage

                call caster.DamageUnitBySpell(target, damage, true, false)

                set this.damage = damage * (1. - thistype.DAMAGE_DEC_FACTOR)

                call thistype(NULL).Buff.Start(level, target)
            endif
        endif

        if (targetsAmount == maxTargetsAmount) then
            call this.Ending()
        else
            set UnitList.TEMP = targetGroup
            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, this.areaRange, thistype.TARGET_FILTER)

			if (target != NULL) then
				call thistype.ENUM_GROUP.RemoveUnit(target)

				call targetGroup.Remove(target)
			endif

            set target = thistype.ENUM_GROUP.GetNearest(targetX, targetY)

            if (target == NULL) then
                call this.Ending()
            else
                set this.targetsAmount = targetsAmount + 1

                call this.StartMissile(targetX, targetY, targetZ, target)
            endif
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local thistype this = thistype.allocate()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.level = level
        set this.maxTargetsAmount = thistype.TARGETS_AMOUNT[level]
        set this.targetGroup = UnitList.Create()
        set this.targetsAmount = 1

        call this.StartMissile(casterX, casterY, caster.Position.Z.GetByCoords(casterX, casterY) + caster.Outpact.Z.Get(true), target)
    endmethod

    initMethod Init of Spells_Purchasable
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions_Group)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Buff.Init()
    endmethod
endstruct