//! runtextmacro Folder("PandaPaw")
    //! runtextmacro Folder("Arrival")
        //! runtextmacro Struct("Target")
            static Event DEATH_EVENT
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
            static real array LENGTH
            static real array Z_ADD_ADD
            static real array Z_ADD_START

			real damage
            PandaPaw parent
            real xAdd
            real yAdd
            real zAdd
            real zAddAdd

            method Ending takes PandaPaw parent, Unit target, UnitList targetGroup returns nothing
                call this.deallocate()
                if target.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                    call target.Event.Remove(DEATH_EVENT)
                endif
                call target.Data.Integer.Remove(KEY_ARRAY_DETAIL + parent)
                call targetGroup.Remove(target)
            endmethod

            method EndingByParent takes Unit target, UnitList targetGroup returns nothing
                local PandaPaw parent = this

                set this = target.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)

                call this.Ending(parent, target, targetGroup)
            endmethod

            eventMethod Event_Death
                local Unit target = params.Unit.GetTrigger()

                local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    local PandaPaw parent = this.parent

                    call this.Ending(parent, target, parent.targetGroup)

                    set iteration = iteration - 1
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                endloop

                call PandaPaw(NULL).Arrival.ENUM_GROUP.RemoveUnit(target)
            endmethod

            method Move takes Unit caster, Unit target returns nothing
                set this = target.Data.Integer.Get(KEY_ARRAY_DETAIL + this)

                local real zAdd = this.zAdd + this.zAddAdd

                set this.zAdd = zAdd
                call target.Position.X.Add(this.xAdd)
                call target.Position.Y.Add(this.yAdd)
                call target.Position.Z.Add(zAdd)

                if ((zAdd < 0.) and (target.Position.Z.Get() < Spot.GetHeight(target.Position.X.Get(), target.Position.Y.Get()) + thistype.IMPACT_TOLERANCE)) then
                    local integer level = this.parent.level

                    call target.Effects.Create(thistype.IMPACT_EFFECT_PATH, thistype.IMPACT_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

                    call target.Position.Nudge()

					local real stunDuration

					if target.Classes.Contains(UnitClass.HERO) then
						set stunDuration = thistype.STUN_HERO_DURATION[level]
					else
						set stunDuration = thistype.STUN_DURATION[level]
					endif

					call target.Stun.AddTimedBy(UNIT.Stun.NORMAL_BUFF, stunDuration)

                    call caster.DamageUnitBySpell(target, this.damage, true, true)
                endif
            endmethod

			enumMethod Move_Enum
				local PandaPaw parent = params.GetData()

				call thistype(parent).Move(parent.caster, params.Unit.GetTrigger())
			endmethod

			static method MoveByParent takes PandaPaw parent returns nothing
				call parent.targetGroup.DoEx(function thistype.Move_Enum, parent)
			endmethod

            method Start takes real angle, integer level, Unit target, real targetX, real targetY returns nothing
                local PandaPaw parent = this

                set angle = Math.LimitAngle(Math.AtanByDeltas(target.Position.Y.Get() - targetY, target.Position.X.Get() - targetX), angle - thistype.MAX_ANGLE_OFFSET, angle + thistype.MAX_ANGLE_OFFSET)

                set this = thistype.allocate()

                set this.damage = thistype.DAMAGE[level] + thistype.DAMAGE_ATTACK_DAMAGE_MOD[level] * parent.whichInstance.GetDamageMod()
                set this.parent = parent
                set this.xAdd = thistype.LENGTH[level] * Math.Cos(angle)
                set this.yAdd = thistype.LENGTH[level] * Math.Sin(angle)
                set this.zAdd = thistype.Z_ADD_START[level]
                set this.zAddAdd = thistype.Z_ADD_ADD[level]
                if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
                    call target.Event.Add(DEATH_EVENT)
                endif
                call target.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)

                local integer iteration = PandaPaw.THIS_SPELL.GetLevelsAmount()

                loop
                    set thistype.LENGTH[iteration] = thistype.MAX_LENGTH[iteration] / PandaPaw(NULL).Arrival.DURATION[iteration] * PandaPaw(NULL).Arrival.UPDATE_TIME
                    set thistype.Z_ADD_ADD[iteration] = -8. * thistype.MAX_Z[iteration] / PandaPaw(NULL).Arrival.DURATION[iteration] / PandaPaw(NULL).Arrival.DURATION[iteration] * PandaPaw(NULL).Arrival.UPDATE_TIME * PandaPaw(NULL).Arrival.UPDATE_TIME

                    set thistype.Z_ADD_START[iteration] = -PandaPaw(NULL).Arrival.DURATION[iteration] * thistype.Z_ADD_ADD[iteration] / 2 / PandaPaw(NULL).Arrival.UPDATE_TIME

                    set iteration = iteration - 1
                    exitwhen (iteration < 1)
                endloop
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Arrival")
        static Group ENUM_GROUP
        static BoolExpr TARGET_FILTER
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

        //! runtextmacro LinkToStruct("Arrival", "Target")

        timerMethod Update
            call thistype.FOR_EACH_LIST_Set()

            loop
                local thistype this = thistype.FOR_EACH_LIST_FetchFirst()

                exitwhen (this == NULL)

                local PandaPaw parent = this

                local Unit caster = parent.caster
                local UnitList targetGroup = parent.targetGroup

				local Unit target

				call thistype(NULL).Target.MoveByParent(parent)
                /*loop
                    set target = targetGroup.FetchFirst()
                    exitwhen (target == NULL)

                    call thistype.ENUM_GROUP.AddUnit(target)

                    call this.Target.Move(caster, target)
                endloop

                loop
                    set target = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (target == NULL)

                    call targetGroup.Add(target)
                endloop*/
            endloop
        endmethod

        method ClearTargetGroup takes UnitList targetGroup returns nothing
            loop
                local Unit target = targetGroup.GetFirst()
                exitwhen (target == NULL)

                call this.Target.EndingByParent(target, targetGroup)
            endloop
        endmethod

        timerMethod Ending
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local PandaPaw parent = PandaPaw(this)

            local UnitList targetGroup = parent.targetGroup
            local SpellInstance whichInstance = parent.whichInstance

            call this.ClearTargetGroup(targetGroup)

            call durationTimer.Destroy()
            call targetGroup.Destroy()

            if thistype.ACTIVE_LIST_Remove(this) then
                call thistype.UPDATE_TIMER.Destroy()
            endif

			call whichInstance.Refs.Subtract()
        endmethod

        condMethod Conditions
            local Unit target = UNIT.Event.Native.GetFilter()

            if (Math.AngleDifference(Math.AtanByDeltas(target.Position.Y.Get() - TEMP_REAL2, target.Position.X.Get() - TEMP_REAL), TEMP_REAL3) > Math.QUARTER_ANGLE) then
                return false
            endif

            if target.Classes.Contains(UnitClass.DEAD) then
                return false
            endif
            if target.Classes.Contains(UnitClass.STRUCTURE) then
                return false
            endif
            if target.IsAllyOf(User.TEMP) then
                return false
            endif

            return true
        endmethod

        method Start takes real angle, Unit caster, integer level, real targetX, real targetY, SpellInstance whichInstance returns nothing
            local PandaPaw parent = this

			call Ubersplat.Create(thistype.DUMMY_UBERSPLAT, targetX, targetY, 255, 255, 255, 127, false, false).DestroyTimed.Start(5.)
            call Spot.CreateEffect(targetX, targetY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

            set targetX = targetX + thistype.PICK_OFFSET * Math.Cos(angle)
            set targetY = targetY + thistype.PICK_OFFSET * Math.Sin(angle)

            set TEMP_REAL = targetX
            set TEMP_REAL2 = targetY
            set TEMP_REAL3 = angle
            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, PandaPaw.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

            local Unit target = thistype.ENUM_GROUP.FetchFirst()
			local UnitList targetGroup = parent.targetGroup

            if (target == NULL) then
                call targetGroup.Destroy()
            else
                local Timer durationTimer = Timer.Create()

                call durationTimer.SetData(this)

                loop
                    call targetGroup.Add(target)
                    call this.Target.Start(angle, level, target, targetX, targetY)

                    set target = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (target == NULL)
                endloop

                if thistype.ACTIVE_LIST_Add(this) then
                    call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                endif

                call durationTimer.Start(thistype.DURATION[level], false, function thistype.Ending)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
            set thistype.UPDATE_TIMER = Timer.Create()

            call thistype(NULL).Target.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Leech")
        eventMethod Event_Unlearn
            call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        eventMethod Event_Learn
            call params.Unit.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, params.Spell.GetLevel())
        endmethod

        static method Init takes nothing returns nothing
            call PandaPaw.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.CHANGE_LEVEL_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
            call PandaPaw.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
            call PandaPaw.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("PandaPaw", "PANDA_PAW")
    static real array LENGTH
    static real array LENGTH_ADD
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    real angle
    real animationAdd
    Unit caster
    Timer effectTimer
    real length
    real lengthAdd
    integer level
    Timer moveTimer
    UnitList targetGroup
    real targetX
    real targetY
    SpellInstance whichInstance

    //! runtextmacro LinkToStruct("PandaPaw", "Arrival")
    //! runtextmacro LinkToStruct("PandaPaw", "Leech")

    timerMethod DoEffect
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

    timerMethod Move        
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

        if reachesTarget then
            set x = targetX
            set y = targetY
            set z = targetZ
        else
            local real angleLengthXYZ = Math.AtanByDeltas(dZ, Math.DistanceByDeltas(dX, dY))

            local real lengthXY = length * Math.Cos(angleLengthXYZ)

            set x = x + lengthXY * Math.Cos(angleXY)
            set y = y + lengthXY * Math.Sin(angleXY)
            set z = z + length * Math.Sin(angleLengthXYZ)
            call caster.Facing.Set(angleXY)
        endif

        call caster.Position.Set(x, y, z)

        if reachesTarget then
            local SpellInstance whichInstance = this.whichInstance

			call whichInstance.Refs.Add()

            call caster.Buffs.Remove(thistype.DUMMY_BUFF)

            call this.Arrival.Start(angleXY, caster, this.level, targetX, targetY, whichInstance)
        else
            set this.angle = angleXY
            set this.length = length
        endif
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Timer effectTimer = this.effectTimer
        local Timer moveTimer = this.moveTimer
        local SpellInstance whichInstance = this.whichInstance

        call effectTimer.Destroy()
        call moveTimer.Destroy()
        call target.Animation.Speed.Subtract(thistype.ANIMATION_INC)
        call whichInstance.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local EventResponse castParams = params.Buff.GetData()
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()
        local SpellInstance whichInstance = SpellInstance.Create(target, thistype.THIS_SPELL)

        local real targetX = castParams.Spot.GetTargetX()
        local real targetY = castParams.Spot.GetTargetY()

        local real angle = target.CastAngle(targetX - target.Position.X.Get(), targetY - target.Position.Y.Get())

        local thistype this = target

        local Timer durationTimer = Timer.Create()
        local Timer effectTimer = Timer.Create()
		local Timer moveTimer = Timer.Create()

        set this.angle = angle
        set this.caster = target
        set this.effectTimer = effectTimer
        set this.length = thistype.LENGTH[level]
        set this.lengthAdd = thistype.LENGTH_ADD[level]
        set this.level = level
        set this.moveTimer = moveTimer
        set this.targetGroup = UnitList.Create()
        set this.targetX = targetX
        set this.targetY = targetY
        set this.whichInstance = whichInstance
        call effectTimer.SetData(this)
        call moveTimer.SetData(this)

        call target.Animation.Speed.Add(thistype.ANIMATION_INC)

        call effectTimer.Start(thistype.EFFECT_INTERVAL, true, function thistype.DoEffect)

        call moveTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)
    endmethod

    eventMethod Event_SpellEffect
        call params.Unit.GetTrigger().Buffs.AddFreshEx(thistype.DUMMY_BUFF, params.Spell.GetLevel(), params)
    endmethod

    initMethod Init of Spells_Hero
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set thistype.LENGTH[iteration] = thistype.SPEED[iteration] * thistype.UPDATE_TIME
            set thistype.LENGTH_ADD[iteration] = thistype.ACCELERATION[iteration] * thistype.UPDATE_TIME * thistype.UPDATE_TIME

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop

        call thistype(NULL).Arrival.Init()
        call thistype(NULL).Leech.Init()
    endmethod
endstruct