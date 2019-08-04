//! runtextmacro BaseStruct("FlameTongue", "FLAME_TONGUE")
    static real array DURATION
    static Group ENUM_GROUP
    static real array HORIZONTAL_ACCELERATION
    static real array HORIZONTAL_OFFSET_FACTOR
    static real array HORIZONTAL_MAX_WIDTH_LENGTH
    static real array LENGTH
    static BoolExpr TARGET_FILTER

    real angle
    real areaRange
    Unit caster
    real damage
    real damageIgniteFactor
    real horizontalAcceleration
    real horizontalAngleX
    real horizontalAngleY
    real horizontalOffsetFactor
    Timer intervalTimer
    real length
    real lengthAdd
    integer level
    real maxDamage
    UnitList targetGroup
    real x
    real xAdd
    real y
    real yAdd
    SpellInstance whichInstance

    timerMethod Ending2
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local Timer intervalTimer = this.intervalTimer
        local UnitList targetGroup = this.targetGroup
        local SpellInstance whichInstance = this.whichInstance

        call this.deallocate()
        call durationTimer.Destroy()
        call intervalTimer.Destroy()
        call targetGroup.Destroy()
        call whichInstance.Destroy()
    endmethod

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if UnitList.TEMP.Contains(target) then
            return false
        endif

        if not target.Classes.Contains(UnitClass.GROUND) then
            return false
        endif
        if target.Classes.Contains(UnitClass.DEAD) then
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

    method DoExplosion takes real areaRange, Unit caster, User casterOwner, real damage, integer directionFactor, real horizontalX, real horizontalY, UnitList targetGroup, real x, real y, SpellInstance whichInstance returns nothing
        set x = x + directionFactor * horizontalX
        set y = y + directionFactor * horizontalY

        call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()
        call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT2_PATH, EffectLevel.NORMAL).Destroy()

        set UnitList.TEMP = targetGroup
        set User.TEMP = casterOwner

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, areaRange, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damageIgniteFactor = this.damageIgniteFactor
            local real maxDamage = this.maxDamage

            loop
                set damage = Math.Min(damage, maxDamage)
                call targetGroup.Add(target)

                set maxDamage = maxDamage - damage

                if target.Ignited.Is() then
                    set damage = damage * damageIgniteFactor
                endif

                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop

            set this.maxDamage = maxDamage
        endif
    endmethod

    timerMethod Move
        local thistype this = Timer.GetExpired().GetData()

        local real angle = this.angle
        local real areaRange = this.areaRange
        local Unit caster = this.caster
        local real damage = this.damage
        local real length = this.length + this.lengthAdd
        local UnitList targetGroup = this.targetGroup
        local real x = this.x + this.xAdd
        local real y = this.y + this.yAdd
        local SpellInstance whichInstance = this.whichInstance

        local User casterOwner = caster.Owner.Get()
        local real horizontalLength = length * (this.horizontalAcceleration * length + this.horizontalOffsetFactor)

        local real horizontalX = horizontalLength * this.horizontalAngleX
        local real horizontalY = horizontalLength * this.horizontalAngleY

        set this.length = length
        set this.x = x
        set this.y = y

        call this.DoExplosion(areaRange, caster, casterOwner, damage, -1, horizontalX, horizontalY, targetGroup, x, y, whichInstance)
        call this.DoExplosion(areaRange, caster, casterOwner, damage, 1, horizontalX, horizontalY, targetGroup, x, y, whichInstance)
    endmethod

    timerMethod Start2
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        set this.lengthAdd = -this.lengthAdd
        set this.xAdd = -this.xAdd
        set this.yAdd = -this.yAdd
        call this.targetGroup.Clear()

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Move)

        call durationTimer.Start(thistype.DURATION[this.level], false, function thistype.Ending2)
    endmethod

    timerMethod Ending
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        call this.intervalTimer.Pause()

        call durationTimer.Start(0.15, false, function thistype.Start2)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real dX = targetX - casterX
        local real dY = targetY - casterY

        local real angle = caster.CastAngle(dX, dY)
        local real d = Math.DistanceByDeltas(dX, dY)

        local real horizontalAngle = angle - Math.QUARTER_ANGLE

		local thistype this = thistype.allocate()

        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()
        local SpellInstance whichInstance = SpellInstance.Create(caster, thistype.THIS_SPELL)

        set this.angle = angle
        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level] + caster.Damage.Get() * thistype.DAMAGE_DAMAGE_MOD_FACTOR
        set this.damageIgniteFactor = (1. + thistype.DAMAGE_IGNITE_BONUS[level])
        set this.horizontalAcceleration = thistype.HORIZONTAL_ACCELERATION[level]
        set this.horizontalAngleX = Math.Cos(horizontalAngle)
        set this.horizontalAngleY = Math.Sin(horizontalAngle)
        set this.horizontalOffsetFactor = thistype.HORIZONTAL_OFFSET_FACTOR[level]
        set this.intervalTimer = intervalTimer
        set this.length = 0.
        set this.lengthAdd = thistype.LENGTH[level]
        set this.level = level
        set this.maxDamage = thistype.MAX_DAMAGE[level]
        set this.targetGroup = UnitList.Create()
        set this.x = targetX
        set this.xAdd = thistype.LENGTH[level] * Math.Cos(angle)
        set this.y = targetY
        set this.yAdd = thistype.LENGTH[level] * Math.Sin(angle)
        set this.whichInstance = whichInstance
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Move)

        call durationTimer.Start(thistype.DURATION[level], false, function thistype.Ending)
    endmethod

    initMethod Init of Spells_Purchasable
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set thistype.DURATION[iteration] = Real.ToInt((thistype.MAX_LENGTH[iteration] / thistype.SPEED[iteration]) / thistype.INTERVAL) * thistype.INTERVAL
            set thistype.HORIZONTAL_MAX_WIDTH_LENGTH[iteration] = thistype.HORIZONTAL_MAX_WIDTH_LENGTH_FACTOR[iteration] * thistype.MAX_LENGTH[iteration]
            set thistype.LENGTH[iteration] = thistype.SPEED[iteration] * thistype.INTERVAL

            set thistype.HORIZONTAL_ACCELERATION[iteration] = thistype.HORIZONTAL_MAX_WIDTH[iteration] / thistype.HORIZONTAL_MAX_WIDTH_LENGTH[iteration] / (thistype.HORIZONTAL_MAX_WIDTH_LENGTH[iteration] + thistype.MAX_LENGTH[iteration])

            set thistype.HORIZONTAL_OFFSET_FACTOR[iteration] = -thistype.HORIZONTAL_ACCELERATION[iteration] * thistype.MAX_LENGTH[iteration]

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop
    endmethod
endstruct