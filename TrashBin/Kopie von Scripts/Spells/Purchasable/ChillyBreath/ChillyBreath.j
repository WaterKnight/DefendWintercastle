//! runtextmacro Spell_OpenScope("/")

//! runtextmacro Folder("ChillyBreath")
    //! runtextmacro Struct("Buff")
        static Buff DUMMY_BUFF
        static real array DURATION
        static real array SPEED_INCREMENT

        real speedAdd

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local real speedAdd = this.speedAdd

            call target.Cold.Subtract()
            call target.Movement.Speed.BonusA.Subtract(speedAdd)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real speedAdd = thistype.SPEED_INCREMENT[level]
            local thistype this = target

            set this.speedAdd = speedAdd
            call target.Cold.Add()
            call target.Movement.Speed.BonusA.Add(speedAdd)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            //! import obj_ChillyBreath_Buff.j

                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "ChB", "Cold and slowed", "5", "false", "ReplaceableTextures\\CommandButtons\\BTNBreathOfFrost.blp", "This unit was recently affected by a cold shiver. It has problems to do fast movements.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.SetLostOnDispel(true)
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl", AttachPoint.CHEST, EffectLevel.NORMAL)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("ChillyBreath", "CHILLY_BREATH")
    static real array DAMAGE
    static real array DURATION
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dChB", "Chilly Breath", "DUMMY_UNIT_ID", "Abilities\\Spells\\Other\\BreathOfFrost\\BreathOfFrostMissile.mdl")
    static constant real DUMMY_UNIT_STANDARD_DURATION = 0.35
    static real END_WIDTH
    static Group ENUM_GROUP
    static real array LENGTH
    static real array MAX_LENGTH
    static real array SPEED
    static real START_WIDTH
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    static Spell THIS_SPELL

    real angle
    Unit caster
    real damage
    DummyUnit dummyUnit
    real length
    real lengthAdd
    integer level
    real maxLength
    Group targetGroup
    Timer updateTimer
    real xAdd
    real yAdd

    //! runtextmacro LinkToStruct("ChillyBreath", "Buff")

    static method Ending takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local DummyUnit dummyUnit = this.dummyUnit
        local Timer updateTimer = this.updateTimer

        call this.deallocate()
        call dummyUnit.Destroy()
        call durationTimer.Destroy()
        call targetGroup.Destroy()
        call updateTimer.Destroy()
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
        local real damage
        local integer level
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local real angle = this.angle
        local Unit caster = this.caster
        local DummyUnit dummyUnit = this.dummyUnit
        local real lengthAdd = this.lengthAdd
        local real maxLength = this.maxLength
        local real oldLength = this.length
        local Group targetGroup = this.targetGroup

        local real length = oldLength + lengthAdd
        local real x = dummyUnit.Position.X.Get() + this.xAdd
        local real y = dummyUnit.Position.Y.Get() + this.yAdd

        local real widthEnd = thistype.START_WIDTH + (thistype.END_WIDTH - thistype.START_WIDTH) * (oldLength / maxLength)
        local real widthStart = thistype.START_WIDTH + (thistype.END_WIDTH - thistype.START_WIDTH) * (length / maxLength)

        set this.length = length
        call dummyUnit.Position.SetXY(x, y)

        set User.TEMP = caster.Owner.Get()
        set Group.TEMP = targetGroup

        call thistype.ENUM_GROUP.EnumUnits.InLine.WithCollision.Do(x, y, lengthAdd, angle, widthStart, widthEnd, thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set damage = this.damage
            set level = this.level

            loop
                call targetGroup.AddUnit(target)

                call thistype(NULL).Buff.Start(level, target)

                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Impact takes nothing returns nothing
        call MISSILE.Event.GetTrigger().Destroy()
    endmethod

    static method StartSideMissiles takes Unit source, real length, real speed, real angle, real timeScale returns nothing
        local Missile dummyMissile = Missile.Create()
        local DummyUnit dummyUnit
        local real sourceX = source.Position.X.Get()
        local real sourceY = source.Position.Y.Get()
        local real targetX
        local real targetY

        set angle = angle - Math.QUARTER_ANGLE / 3

        set targetX = sourceX + length * Math.Cos(angle)
        set targetY = sourceY + length * Math.Sin(angle)

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 0.4)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.Speed.Set(speed)
        call dummyMissile.Position.SetFromUnit(source)

        set dummyUnit = dummyMissile.DummyUnit.Get()

        call dummyUnit.SetTimeScale(timeScale)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))

        set angle = angle + 2 * Math.QUARTER_ANGLE / 3
        set dummyMissile = Missile.Create()

        set targetX = sourceX + length * Math.Cos(angle)
        set targetY = sourceY + length * Math.Sin(angle)

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 0.4).SetTimeScale(timeScale)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.Speed.Set(speed)
        call dummyMissile.Position.SetFromUnit(source)

        set dummyUnit = dummyMissile.DummyUnit.Get()

        call dummyUnit.SetTimeScale(timeScale)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer durationTimer = Timer.Create()
        local Sound effectSound = Sound.Create("Abilities\\Spells\\Other\\BreathOfFrost\\BreathOfFrost1.wav", true, false, false, 10, 10, SoundEax.SPELL)
        local integer level = SPELL.Event.GetLevel()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()
        local thistype this = thistype.allocate()
        local Timer updateTimer = Timer.Create()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real duration = thistype.DURATION[level]

        local real dX = targetX - casterX
        local real dY = targetY - casterY
        local real timeScale = thistype.DUMMY_UNIT_STANDARD_DURATION / duration

        local real angle = caster.CastAngle(dX, dY)
        local real d = Math.DistanceByDeltas(dX, dY)

        local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, casterX, casterY, caster.Position.Z.GetByCoords(casterX, casterY) + caster.Outpact.Z.Get(true), angle)

        set this.angle = angle
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.dummyUnit = dummyUnit
        set this.length = 0.
        set this.lengthAdd = thistype.LENGTH[level]
        set this.level = level
        set this.maxLength = thistype.MAX_LENGTH[level]
        set this.targetGroup = Group.Create()
        set this.updateTimer = updateTimer
        set this.xAdd = dX / d * thistype.LENGTH[level]
        set this.yAdd = dY / d * thistype.LENGTH[level]
        call durationTimer.SetData(this)
        call updateTimer.SetData(this)

        call dummyUnit.SetScale(0.75)
        call dummyUnit.SetTimeScale(timeScale)
        call effectSound.SetPositionAndPlay(casterX, casterY, Spot.GetHeight(casterX, casterY))

        call effectSound.Destroy(true)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)

        call durationTimer.Start(duration, false, function thistype.Ending)

        call thistype(NULL).StartSideMissiles(caster, thistype.MAX_LENGTH[level], thistype.SPEED[level], angle, timeScale)
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration

        //! import obj_ChillyBreath.j

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

        call thistype(NULL).Buff.Init()

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct