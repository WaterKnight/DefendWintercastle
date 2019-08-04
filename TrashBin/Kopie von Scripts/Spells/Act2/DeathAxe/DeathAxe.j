//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("DeathAxe", "DEATH_AXE")
    static real DISARM_DURATION
    static real DAMAGE
    static Event DEATH_EVENT
    static real DELAY
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dDeA", "DeathAxe", "DUMMY_UNIT_ID", "Spells\\DeathAxe\\DeathAxe.mdl")
    static BoolExpr MISSILE_TARGET_FILTER
    static BoolExpr TARGET_FILTER

    static Spell THIS_SPELL

    Unit caster
    real damage
    Timer delayTimer
    integer level

    static method TargetConditions takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()
        local thistype this

        if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.NEUTRAL)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (filterUnit.IsAllyOf(User.TEMP)) then
            return false
        endif

        return true
    endmethod

    static method Missile_TargetConditions takes nothing returns boolean
        local Missile dummyMissile
        local thistype this

        set dummyMissile = MISSILE.Event.GetTrigger()

        set this = dummyMissile.GetData()

        set User.TEMP = this.caster.Owner.Get()

        if (thistype.TargetConditions() == false) then
            return false
        endif

        return true
    endmethod

    static method Impact takes nothing returns nothing
        local Unit caster
        local real damage
        local Missile dummyMissile = MISSILE.Event.GetTrigger()
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        if (target == NULL) then
            call this.deallocate()
            call dummyMissile.Destroy()

            return
        endif

        set caster = this.caster
        set damage = this.damage

        call this.deallocate()
        call dummyMissile.Destroy()

        if (target.MagicImmunity.Try()) then
            return
        endif

        call caster.DamageUnitBySpell(target, damage, true, false)

        call target.Attack.DisableTimed(thistype.DISARM_DURATION, UNIT.Attack.NORMAL_BUFF)
    endmethod

    static method Delay takes nothing returns nothing
        local real angle
        local Timer delayTimer = Timer.GetExpired()
        local Missile dummyMissile = Missile.Create()
        local DummyUnit dummyUnit
        local Unit target
        local real targetX
        local real targetY

        local thistype this = delayTimer.GetData()

        local Unit caster = this.caster
        local integer level = this.level

        local real startX = caster.Position.X.Get()
        local real startY = caster.Position.Y.Get()
        local real maxLength = thistype.THIS_SPELL.GetRange(level)

        call delayTimer.Destroy()

        set User.TEMP = caster.Owner.Get()

        set target = GROUP.EnumUnits.InRange.WithCollision.GetNearest(startX, startY, thistype.THIS_SPELL.GetRange(level), thistype.TARGET_FILTER)

        if (target == NULL) then
            call this.deallocate()
        else
            set targetX = target.Position.X.Get()
            set targetY = target.Position.Y.Get()

            set angle = Math.AtanByDeltas(targetY - startY, targetX - startX)

            set dummyUnit = dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.5)
            call dummyMissile.Acceleration.Set(500.)
            call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(350.)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyUnit.AddEffect("Abilities\\Weapons\\VengeanceMissile\\VengeanceMissile.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)

            call dummyMissile.Impact.SetFilter(thistype.MISSILE_TARGET_FILTER)
            call dummyMissile.GoToSpot.Start(startX + maxLength * Math.Cos(angle), startY + maxLength * Math.Sin(angle), Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)
        endif

        call caster.Refs.Subtract()
    endmethod

    static method Start takes Unit caster, integer level returns nothing
        local Timer delayTimer = Timer.Create()
        local thistype this = thistype.allocate()

        set this.caster = caster
        set this.damage = thistype.DAMAGE
        set this.delayTimer = delayTimer
        set this.level = level
        call delayTimer.SetData(this)

        call caster.Refs.Add()

        call delayTimer.Start(thistype.DELAY, false, function thistype.Delay)
    endmethod

    static method Event_Death takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()

        call thistype.Start(caster, level)
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Remove(DEATH_EVENT)
    endmethod

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Add(DEATH_EVENT)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_DeathAxe.j

        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        set thistype.MISSILE_TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Missile_TargetConditions)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct