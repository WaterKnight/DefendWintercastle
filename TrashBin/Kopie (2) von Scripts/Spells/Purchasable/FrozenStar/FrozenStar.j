//! runtextmacro Spell_OpenScope("/")

//! runtextmacro Folder("FrozenStar")
    //! runtextmacro Struct("Target")
        static Buff DUMMY_BUFF
        static real array DURATION
        static real array SPEED_INCREMENT

        real speedAdd

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local real speedAdd = this.speedAdd

            call target.Cold.Subtract()
            call target.Movement.Speed.Subtract(speedAdd)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real speedAdd = thistype.SPEED_INCREMENT[level]
            local thistype this = target

            set this.speedAdd = speedAdd

            call target.Cold.Add()
            call target.Movement.Speed.Add(speedAdd)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            //! import obj_FrozenStar_Target.j

                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "FrS", "Frozen Star", "5", "false", "ReplaceableTextures\\CommandButtons\\BTNBreathOfFrost.blp", "This unit was recently affected by a cold shiver. It has problems to do fast movements.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct

    //! runtextmacro Struct("Explosion")
        static real array DAMAGE
        static Group ENUM_GROUP
        static string SPECIAL_EFFECT_PATH = "Units\\NightElf\\Wisp\\WispExplode.mdl"
        static BoolExpr TARGET_FILTER

        static method Conditions takes nothing returns boolean
            local Unit filterUnit = UNIT.Event.Native.GetFilter()

            if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
                return false
            endif
            if (filterUnit.IsAllyOf(User.TEMP)) then
                return false
            endif

            return true
        endmethod

        method Start takes Unit caster, real damage, integer level, real x, real y returns nothing
            local FrozenStar parent = this
            local Unit target

            call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, FrozenStar.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

            set target = thistype.ENUM_GROUP.FetchFirst()

            if (target != NULL) then
                loop
                    call FROZEN_STAR.Target.Start(level, target)

                    call caster.DamageUnitBySpell(target, damage, true, false)

                    set target = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (target == NULL)
                endloop
            endif
        endmethod

        static method Init takes nothing returns nothing
            //! import obj_FrozenStar_Explosion.j

            set thistype.ENUM_GROUP = Group.Create()
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("FrozenStar", "FROZEN_STAR")
    static real ANGLE_D_FACTOR
    static real CASTER_SIGHT_D_FACTOR
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dFrS", "Ice Lance", "DUMMY_UNIT_ID", "Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl")
    static real array DURATION
    static Group ENUM_GROUP
    static real INTERVAL
    static real array LENGTH
    static real MAX_ANGLE_D
    static real array MAX_LENGTH
    static real array MOVING_AREA_RANGE
    static string SPECIAL_EFFECT_PATH
    static real array SPEED
    static BoolExpr TARGET_FILTER
    static thistype TEMP
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    static Spell THIS_SPELL

    real angle
    real areaRange
    Unit caster
    real damage
    DummyUnit dummyUnit
    real horizontalAcceleration
    real horizontalAngleX
    real horizontalAngleY
    real horizontalOffsetFactor
    real length
    real lengthAdd
    integer level
    Group targetGroup
    real x
    real xAdd
    real y
    real yAdd
    Timer updateTimer
    SpellInstance whichInstance

    //! runtextmacro LinkToStruct("FrozenStar", "Explosion")
    //! runtextmacro LinkToStruct("FrozenStar", "Target")

    static method Ending takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local Unit caster = this.caster
        local real damage = this.damage
        local DummyUnit dummyUnit = this.dummyUnit
        local integer level = this.level
        local Group targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer
        local real x = this.x
        local real y = this.y
        local SpellInstance whichInstance = this.whichInstance

        call this.deallocate()
        call dummyUnit.Destroy()
        call durationTimer.Destroy()
        call targetGroup.Destroy()
        call updateTimer.Destroy()
        call whichInstance.Destroy()

        call thistype(NULL).Explosion.Start(caster, damage, level, x, y)
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (Group.TEMP.ContainsUnit(target)) then
            return false
        endif

        if (target.Classes.Contains(UnitClass.DEAD)) then
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

    static method Move takes nothing returns nothing
        local integer level
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local real angle = this.angle
        local DummyUnit dummyUnit = this.dummyUnit
        local real length = this.length + this.lengthAdd
        local Group targetGroup = this.targetGroup
        local real x = this.x + this.xAdd
        local real y = this.y + this.yAdd

        local real horizontalLength = length * (this.horizontalAcceleration * length + this.horizontalOffsetFactor)

        set this.length = length
        set this.x = x
        set this.y = y

        set x = x + horizontalLength * this.horizontalAngleX
        set y = y + horizontalLength * this.horizontalAngleY

        call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

        call dummyUnit.Position.X.Set(x)
        call dummyUnit.Position.Y.Set(y)

        set User.TEMP = this.caster.Owner.Get()
        set Group.TEMP = targetGroup

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, this.areaRange, thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set level = this.level

            loop
                call targetGroup.AddUnit(target)

                call this.Target.Start(level, target)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer durationTimer = Timer.Create()
        local integer level = SPELL.Event.GetLevel()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()
        local thistype this = thistype.allocate()
        local Timer updateTimer = Timer.Create()

        local real casterAngle = caster.Facing.Get()
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local SpellInstance whichInstance = SpellInstance.Create(caster, thistype.THIS_SPELL)

        local real dX = targetX - casterX
        local real dY = targetY - casterY

        local real angle = caster.CastAngle(dX, dY)
        local real casterSightD = thistype.MAX_LENGTH[level] * thistype.CASTER_SIGHT_D_FACTOR
        local real d = Math.DistanceByDeltas(dX, dY)

        local real angleD = Math.Min(Math.AngleDifference(casterAngle, angle) * thistype.ANGLE_D_FACTOR, thistype.MAX_ANGLE_D)
        local real horizontalAngle = angle - Math.QUARTER_ANGLE + 2 * Math.QUARTER_ANGLE * Boolean.ToInt(Math.CompareAngles(casterAngle, angle))
        local real length = casterSightD * Math.Cos(angleD)

        local real horizontalAcceleration = (Math.Sin(angleD) * casterSightD) / (length * (length - thistype.MAX_LENGTH[level]))

        set this.angle = angle
        set this.areaRange = thistype.MOVING_AREA_RANGE[level]
        set this.caster = caster
        set this.damage = Explosion.DAMAGE[level]
        set this.dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, casterX, casterY, caster.Position.Z.GetByCoords(casterX, casterY) + caster.Outpact.Z.Get(true), angle)
        set this.horizontalAcceleration = horizontalAcceleration
        set this.horizontalAngleX = horizontalAngle * Math.Cos(horizontalAngle)
        set this.horizontalAngleY = horizontalAngle * Math.Sin(horizontalAngle)
        set this.horizontalOffsetFactor = -horizontalAcceleration * thistype.MAX_LENGTH[level]
        set this.length = 0.
        set this.lengthAdd = thistype.LENGTH[level]
        set this.level = level
        set this.targetGroup = Group.Create()
        set this.updateTimer = updateTimer
        set this.x = casterX
        set this.xAdd = thistype.LENGTH[level] * Math.Cos(angle)
        set this.y = casterY
        set this.yAdd = thistype.LENGTH[level] * Math.Sin(angle)
        set this.whichInstance = whichInstance
        call durationTimer.SetData(this)
        call updateTimer.SetData(this)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)

        call durationTimer.Start(thistype.DURATION[level], false, function thistype.Ending)
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration

        //! import obj_FrozenStar.j

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

        call thistype(NULL).Explosion.Init()
        call thistype(NULL).Target.Init()

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct