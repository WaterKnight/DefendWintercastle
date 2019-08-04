//! runtextmacro BaseStruct("EbonyShot", "EBONY_SHOT")
    static Event MISSILE_DESTROY_EVENT
    static BoolExpr TARGET_FILTER

    integer count
    real damage
    UnitList targetGroup
    SpellInstance whichInstance

    eventMethod Event_Missile_Destroy
        local Missile dummyMissile = params.Missile.GetTrigger()

		call dummyMissile.Event.Remove(MISSILE_DESTROY_EVENT)

        local thistype this = dummyMissile.GetData()

        local integer count = this.count - 1

        if (count == 0) then
            call this.targetGroup.Destroy()

            call this.deallocate()
        else
            set this.count = count
        endif
    endmethod

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        call dummyMissile.Destroy()
    endmethod

    condMethod TargetConditions
        local EventResponse params = EventResponse.GetTrigger()

        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
            return false
        endif

        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local SpellInstance whichInstance = this.whichInstance

        if target.IsAllyOf(whichInstance.GetCaster().Owner.Get()) then
            return false
        endif

        if this.targetGroup.Contains(target) then
            call whichInstance.GetCaster().DamageUnitBySpell(target, SetVar.GetValDefR("dmgGraze" ,thistype.DAMAGE_GRAZE[whichInstance.GetLevel()]) * MISSILE.UpdateTime.VALUE, true, false)

            return false
        endif

        return true
    endmethod

    eventMethod Collision
        local Missile dummyMissile = params.Missile.GetTrigger()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local real damage = this.damage
        local SpellInstance whichInstance = this.whichInstance

        local Unit caster = whichInstance.GetCaster()

        call this.targetGroup.Add(target)

        call target.Effects.Create(thistype.DAMAGE_EFFECT_PATH, thistype.DAMAGE_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call caster.DamageUnitBySpell(target, damage, false, true)
    endmethod

    method StartMissile takes SpellInstance whichInstance, real angle, real range returns nothing
        local Unit caster = whichInstance.GetCaster()
        local integer level = whichInstance.GetLevel()
        local real targetX = whichInstance.GetTargetX()
        local real targetY = whichInstance.GetTargetY()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local Missile dummyMissile = Missile.Create()

        call dummyMissile.Event.Add(MISSILE_DESTROY_EVENT)

        call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.5).AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
        call dummyMissile.SetData(this)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.Speed.Set(thistype.SPEED)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(casterX + range * Math.Cos(angle), casterY + range * Math.Sin(angle), Spot.GetHeight(targetX, targetY) + caster.Outpact.Z.Get(true))

        call dummyMissile.Position.AddCollision(function thistype.Collision, thistype.TARGET_FILTER)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()
        local SpellInstance whichInstance = params.SpellInstance.GetTrigger()

		call caster.Effects.Create(thistype.LAUNCH_EFFECT_PATH, thistype.LAUNCH_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local integer level = whichInstance.GetLevel()

        local real d = Math.DistanceByDeltas(targetX - casterX, targetY - casterY)

        local integer missilesAmount = SetVar.GetValDefI("missiles", thistype.MISSILES_AMOUNT[level])
        local real range = SetVar.GetValDefR("range", thistype.THIS_SPELL.GetRange(level))

        local real window = Math.Shapes.LinearFromCoords(0., SetVar.GetValDefR("windowClose", thistype.WINDOW_CLOSE[level]), range, SetVar.GetValDefR("windowFar", thistype.WINDOW_FAR[level]), d)

        local real angle = whichInstance.GetAngle() - window / 2
        local real angleAdd = window / (missilesAmount - 1)

        local thistype this = thistype.allocate()

        set this.count = missilesAmount
        set this.damage = thistype.DAMAGE[level] + caster.Damage.Get() * thistype.DAMAGE_DAMAGE_MOD_FACTOR[level]
        set this.targetGroup = UnitList.Create()
        set this.whichInstance = whichInstance

        local integer iteration = missilesAmount

        loop
            exitwhen (iteration < 1)

            call this.StartMissile(whichInstance, angle, range)

            set angle = angle + angleAdd
            set iteration = iteration - 1
        endloop
    endmethod

    initMethod Init of Spells_Hero
        set thistype.MISSILE_DESTROY_EVENT = Event.Create(Missile.DESTROY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Missile_Destroy)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct