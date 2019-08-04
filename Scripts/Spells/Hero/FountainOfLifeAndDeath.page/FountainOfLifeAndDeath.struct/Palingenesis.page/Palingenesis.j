//! runtextmacro BaseStruct("Palingenesis", "PALINGENESIS")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    Unit caster
    integer level
    Unit target

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level

        local User casterOwner = caster.Owner.Get()

        call dummyMissile.Destroy()

        if (target == NULL) then
            return
        endif

        if not target.Classes.Contains(UnitClass.DEAD) then
            return
        endif

        call target.Effects.Create(thistype.SUMMON_EFFECT_PATH, thistype.SUMMON_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call target.Revive()

        call target.Buffs.Add(thistype.SUMMON_BUFF, level)
        call target.Owner.Set(casterOwner)

        call target.SetSummon(thistype.SUMMON_DURATION[level])

        call target.BloodExplosion.Set(thistype.SUMMON_DEATH_EFFECT_PATH)
        call target.VertexColor.Add(-128, -128, -128, 0)
    endmethod

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if not target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif

        return true
    endmethod

    static method Start takes Unit caster, integer level, Unit target returns nothing
        local Missile dummyMissile = Missile.Create()

        local thistype this = dummyMissile

        set this.caster = caster
        set this.level = level
        set this.target = target

        call dummyMissile.Arc.SetByPerc(0.06)
        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(500.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToUnit.Start(target, function Missile.Destruction)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target

        local real x = caster.Position.X.Get()
        local real y = caster.Position.Y.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.NearestUnit.DoWithCollision(x, y)

        if (target == NULL) then
            return
        endif

        call thistype.Start(caster, level, target)
    endmethod

    condEventMethod Event_OrderConditions
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()

        local real x = caster.Position.X.Get()
        local real y = caster.Position.Y.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        return not thistype.ENUM_GROUP.IsEmpty()
    endmethod

    static method AddAbility takes Unit caster, integer level returns nothing
        call caster.Abilities.AddWithLevel(thistype.THIS_SPELL, level)

        call caster.Abilities.AutoCast.Change(thistype.THIS_SPELL)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.SetOrderConditions(BoolExpr.GetFromFunction(function thistype.Event_OrderConditions))
    endmethod
endstruct