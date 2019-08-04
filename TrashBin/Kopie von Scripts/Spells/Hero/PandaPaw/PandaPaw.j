//! runtextmacro Spell_OpenScope("/")

//! runtextmacro Folder("PandaPawKnockBack")
    //! runtextmacro Struct("Target")
        static Event DEATH_EVENT
        static real array IMPACT_DAMAGE_FACTOR
        static string IMPACT_EFFECT_ATTACH_POINT
        static string IMPACT_EFFECT_PATH
        static real IMPACT_TOLERANCE
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
        static real array LENGTH
        static real MAX_ANGLE_OFFSET
        static real array MAX_LENGTH
        static real array MAX_Z
        static real array Z_ADD_ADD
        static real array Z_ADD_START

        real impactDamageFactor
        PandaPawKnockBack parent
        real xAdd
        real yAdd
        real zAdd
        real zAddAdd

        method Ending takes PandaPawKnockBack parent, Unit target, Group targetGroup returns nothing
            call this.deallocate()
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Event.Remove(DEATH_EVENT)
            endif
            call target.Data.Integer.Remove(KEY_ARRAY_DETAIL + parent)
            call targetGroup.RemoveUnit(target)
        endmethod

        method EndingByParent takes Unit target, Group targetGroup returns nothing
            local PandaPawKnockBack parent = this

            set this = target.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)

            call this.Ending(parent, target, targetGroup)
        endmethod

        static method Event_Death takes nothing returns nothing
            local PandaPawKnockBack parent
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

            call PandaPawKnockBack.ENUM_GROUP.RemoveUnit(target)
        endmethod

        method Move takes Unit caster, real damagePerBuff, Unit target returns nothing
            local real zAdd

            set this = target.Data.Integer.Get(KEY_ARRAY_DETAIL + this)

            set zAdd = this.zAdd + this.zAddAdd

            set this.zAdd = zAdd
            call target.Position.X.Add(this.xAdd)
            call target.Position.Y.Add(this.yAdd)
            call target.Position.Z.Add(zAdd)

            if ((zAdd < 0.) and (target.Position.Z.Get() < Spot.GetHeight(target.Position.X.Get(), target.Position.Y.Get()) + thistype.IMPACT_TOLERANCE)) then
                call target.Effects.Create(thistype.IMPACT_EFFECT_PATH, thistype.IMPACT_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

                call caster.DamageUnitBySpell(target, Math.Abs(zAdd) * this.impactDamageFactor + damagePerBuff * target.Buffs.CountVisibleEx(true, false), true, false)
            endif
        endmethod

        method Start takes real angle, integer level, Unit target, real targetX, real targetY returns nothing
            local PandaPawKnockBack parent = this

            set angle = Math.LimitAngle(Math.AtanByDeltas(target.Position.Y.Get() - targetY, target.Position.X.Get() - targetX), angle - thistype.MAX_ANGLE_OFFSET, angle + thistype.MAX_ANGLE_OFFSET)
            set this = thistype.allocate()

            set this.impactDamageFactor = thistype.IMPACT_DAMAGE_FACTOR[level]
            set this.parent = parent
            set this.xAdd = thistype.LENGTH[level] * Math.Cos(angle)
            set this.yAdd = thistype.LENGTH[level] * Math.Sin(angle)
            set this.zAdd = thistype.Z_ADD_START[level]
            set this.zAddAdd = thistype.Z_ADD_ADD[level]
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Event.Add(DEATH_EVENT)
            endif
            call target.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)
        endmethod

        static method Init takes nothing returns nothing
            local integer iteration

            //! import obj_PandaPaw_KnockBack_Target.j

            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)

                set iteration = PandaPaw.THIS_SPELL.GetLevelsAmount()

                loop
                    set thistype.LENGTH[iteration] = thistype.MAX_LENGTH[iteration] / PandaPawKnockBack.DURATION[iteration] * PandaPawKnockBack.UPDATE_TIME
                    set thistype.Z_ADD_ADD[iteration] = -8. * thistype.MAX_Z[iteration] / PandaPawKnockBack.DURATION[iteration] / PandaPawKnockBack.DURATION[iteration] * PandaPawKnockBack.UPDATE_TIME * PandaPawKnockBack.UPDATE_TIME

                    set thistype.Z_ADD_START[iteration] = -PandaPawKnockBack.DURATION[iteration] * thistype.Z_ADD_ADD[iteration] / 2 / PandaPawKnockBack.UPDATE_TIME

                    set iteration = iteration - 1
                    exitwhen (iteration < 1)
                endloop
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("PandaPawKnockBack", "PANDA_PAW_KNOCK_BACK")
    static real array AREA_RANGE
    static real array DAMAGE_PER_BUFF
    static real array DURATION
    static Group ENUM_GROUP
    static real PICK_OFFSET
    static string SPECIAL_EFFECT_PATH
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    Unit caster
    real damagePerBuff
    Group targetGroup
    Timer updateTimer

    //! runtextmacro LinkToStruct("PandaPawKnockBack", "Target")

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

        local Group targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer

        call this.ClearTargetGroup(targetGroup)

        call this.deallocate()
        call durationTimer.Destroy()
        call targetGroup.Destroy()
        call updateTimer.Destroy()
    endmethod

    static method Update takes nothing returns nothing
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster
        local real damagePerBuff = this.damagePerBuff
        local Group targetGroup = this.targetGroup

        loop
            set target = targetGroup.FetchFirst()
            exitwhen (target == NULL)

            call thistype.ENUM_GROUP.AddUnit(target)

            call this.Target.Move(caster, damagePerBuff, target)
        endloop

        loop
            set target = thistype.ENUM_GROUP.FetchFirst()
            exitwhen (target == NULL)

            call targetGroup.AddUnit(target)
        endloop
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (Math.AngleDifference(Math.AtanByDeltas(target.Position.Y.Get() - TEMP_REAL2, target.Position.X.Get() - TEMP_REAL), TEMP_REAL3) > Math.QUARTER_ANGLE) then
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

        return true
    endmethod

    static method Start takes real angle, Unit caster, integer level, real targetX, real targetY returns nothing
        local Timer durationTimer
        local Unit target
        local Group targetGroup
        local thistype this
        local Timer updateTimer

        call Spot.CreateEffect(targetX, targetY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

        set targetX = targetX + thistype.PICK_OFFSET * Math.Cos(angle)
        set targetY = targetY + thistype.PICK_OFFSET * Math.Sin(angle)

        set TEMP_REAL = targetX
        set TEMP_REAL2 = targetY
        set TEMP_REAL3 = angle
        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, PandaPaw.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set durationTimer = Timer.Create()
            set targetGroup = Group.Create()
            set this = thistype.allocate()
            set updateTimer = Timer.Create()

            set this.caster = caster
            set this.damagePerBuff = thistype.DAMAGE_PER_BUFF[level]
            set this.targetGroup = targetGroup
            set this.updateTimer = updateTimer
            call durationTimer.SetData(this)
            call updateTimer.SetData(this)

            loop
                call targetGroup.AddUnit(target)
                call this.Target.Start(angle, level, target, targetX, targetY)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop

            call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)

            call durationTimer.Start(thistype.DURATION[level], false, function thistype.Ending)
        endif
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_PandaPaw_KnockBack.j

        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

        call thistype(NULL).Target.Init()
    endmethod
endstruct

//! runtextmacro BaseStruct("PandaPaw", "PANDA_PAW")
    static real array ACCELERATION
    static real ANIMATION_INCREMENT
    static real ARRIVAL_TOLERANCE
    static Buff DUMMY_BUFF
    static real DUMMY_UNIT_DURATION
    static real DUMMY_UNIT_OFFSET
    static real EFFECT_INTERVAL
    static real array LENGTH
    static real array LENGTH_ADD
    static real array SPEED
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    static Spell THIS_SPELL

    real angle
    real animationAdd
    Timer effectTimer
    real length
    real lengthAdd
    integer level
    Timer moveTimer
    real targetX
    real targetY

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local Timer effectTimer = this.effectTimer
        local Timer moveTimer = this.moveTimer

        call effectTimer.Destroy()
        call moveTimer.Destroy()
        call target.Animation.Speed.Subtract(thistype.ANIMATION_INCREMENT)
        call target.Invulnerability.Subtract(UNIT.Invulnerability.NONE_BUFF)
        call target.Stun.Subtract(UNIT.Stun.NONE_BUFF)
    endmethod

    static method DoEffect takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

        local real acceleration = this.lengthAdd / thistype.UPDATE_TIME / thistype.UPDATE_TIME
        local real angle = this.angle
        local Unit caster = this
        local real p = this.length / thistype.UPDATE_TIME / acceleration
        local real targetX = this.targetX
        local real targetY = this.targetY

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real casterZ = caster.Position.Z.Get()
        local DummyUnit dummyUnit = DummyUnit.Create(caster.Type.Get().self, casterX + thistype.DUMMY_UNIT_OFFSET * Math.Cos(angle), casterY + thistype.DUMMY_UNIT_OFFSET * Math.Sin(angle), casterZ, angle)

        local real dur = -p + Math.Sqrt(p * p + 2 * Math.DistanceByDeltasWithZ(targetX - casterX, targetY - casterY, Spot.GetHeight(targetX, targetY) - casterZ) / acceleration)

        if (dur > 0.3) then
            call caster.Animation.Set(Animation.ATTACK)
            call caster.Animation.Queue(Animation.STAND)
        endif
        call dummyUnit.Abilities.AddBySelf(DummyUnit.LOCUST_SPELL_ID)
        call dummyUnit.DestroyTimed.Start(thistype.DUMMY_UNIT_DURATION)
        call dummyUnit.VertexColor.Timed.Subtract(255., 255., 255., 255., thistype.DUMMY_UNIT_DURATION)
    endmethod

    static method Move takes nothing returns nothing
        local real angleLengthXYZ
        local real lengthXY
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this
        local real length = this.length + this.lengthAdd
        local real targetX = this.targetX
        local real targetY = this.targetY
        local real targetZ = Spot.GetHeight(targetX, targetY)

        local real x = caster.Position.X.Get()
        local real y = caster.Position.Y.Get()
        local real z = caster.Position.Z.Get()

        local real dX = targetX - x
        local real dY = targetY - y
        local real dZ = targetZ - z

        local real angleXY = Math.AtanByDeltas(dY, dX)
        local real d = Math.DistanceByDeltasWithZ(dX, dY, dZ)

        local boolean reachesTarget = (d < length + thistype.ARRIVAL_TOLERANCE)

        if (reachesTarget) then
            set x = targetX
            set y = targetY
            set z = targetZ
        else
            set angleLengthXYZ = Math.AtanByDeltas(dZ, Math.DistanceByDeltas(dX, dY))

            set lengthXY = length * Math.Cos(angleLengthXYZ)

            set x = x + lengthXY * Math.Cos(angleXY)
            set y = y + lengthXY * Math.Sin(angleXY)
            set z = z + length * Math.Sin(angleLengthXYZ)
            call caster.Facing.Set(angleXY)
        endif

        call caster.Position.Set(x, y, z)

        if (reachesTarget) then
            call caster.Buffs.Remove(thistype.DUMMY_BUFF)

            call PandaPawKnockBack.Start(angleXY, caster, this.level, targetX, targetY)
        else
            set this.angle = angleXY
            set this.length = length
        endif
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Timer durationTimer = Timer.Create()
        local Timer effectTimer = Timer.Create()
        local integer level = BUFF.Event.GetLevel()
        local Timer moveTimer = Timer.Create()
        local Unit target = UNIT.Event.GetTrigger()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()

        local real angle = target.CastAngle(targetX - target.Position.X.Get(), targetY - target.Position.Y.Get())
        local thistype this = target

        set this.angle = angle
        set this.effectTimer = effectTimer
        set this.length = thistype.LENGTH[level]
        set this.lengthAdd = thistype.LENGTH_ADD[level]
        set this.level = level
        set this.moveTimer = moveTimer
        set this.targetX = targetX
        set this.targetY = targetY
        call effectTimer.SetData(this)
        call moveTimer.SetData(this)

        call target.Animation.Speed.Add(thistype.ANIMATION_INCREMENT)
        call target.Invulnerability.Add(UNIT.Invulnerability.NONE_BUFF)
        call target.Stun.Add(UNIT.Stun.NONE_BUFF)

        call effectTimer.Start(thistype.EFFECT_INTERVAL, true, function thistype.DoEffect)

        call moveTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration

        //! import obj_PandaPaw.j

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            set iteration = thistype.THIS_SPELL.GetLevelsAmount()

            loop
                set thistype.LENGTH[iteration] = thistype.SPEED[iteration] * thistype.UPDATE_TIME
                set thistype.LENGTH_ADD[iteration] = thistype.ACCELERATION[iteration] * thistype.UPDATE_TIME * thistype.UPDATE_TIME

                set iteration = iteration - 1
                exitwhen (iteration < 1)
            endloop

        call PandaPawKnockBack.Init()

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct