//! runtextmacro Folder("Doppelganger")
    //! runtextmacro Struct("BigBoom")
        static Group ENUM_GROUP
        static BoolExpr TARGET_FILTER

        condMethod TargetConditions
            local Unit target = UNIT.Event.Native.GetFilter()

            if target.Classes.Contains(UnitClass.DEAD) then
                return false
            endif
            if target.IsAllyOf(User.TEMP) then
                return false
            endif

            return true
        endmethod

        eventMethod Event_SpellEffect
            local Unit caster = params.Unit.GetTrigger()
            local integer level = params.Spell.GetLevel()

            local Unit realCaster = Doppelganger.GetCasterFromIllusion(caster)

			local real casterX = caster.Position.X.Get()
			local real casterY = caster.Position.Y.Get() 

			local SpotEffectWithSize sfx = Spot.CreateEffectWithSize(casterX, casterY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW, caster.Scale.Get())

			call sfx.AddScale(4., 0.25)

			call sfx.DestroyTimed.Start(1.)

			set sfx = Spot.CreateEffectWithSize(casterX, casterY, thistype.SPECIAL_EFFECT2_PATH, EffectLevel.LOW, caster.Scale.Get())

			call sfx.AddScale(4., 0.25)

			call sfx.DestroyTimed.Start(1.)

			//local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, casterX, casterY, caster.Position.Z.Get(), 0.)

			//call dummyUnit.Scale.Timed.Add(4., 0.25)

			//call dummyUnit.DestroyTimed.Start(1.)

            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

            if (realCaster == NULL) then
                set realCaster = caster
            endif

            local Unit target = thistype.ENUM_GROUP.FetchFirst()

            if (target != NULL) then
                local real damage = thistype.DAMAGE[level]
                local real igniteHeroDuration = thistype.IGNITE_HERO_DURATION[level]
                local real igniteNormDuration = thistype.IGNITE_DURATION[level]

                loop
                	local real igniteDuration

					if target.Classes.Contains(UnitClass.HERO) then
						set igniteDuration = igniteHeroDuration
					else
						set igniteDuration = igniteNormDuration
					endif

                    call target.Buffs.Timed.StartEx(thistype.IGNITION_BUFF, level, realCaster, igniteDuration)

                    call realCaster.DamageUnitBySpell(target, damage, false, false)

                    set target = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (target == NULL)
                endloop
            endif

            call caster.Kill()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
            call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
            call UNIT.Ignited.NORMAL_BUFF.Variants.Add(thistype.IGNITION_BUFF)
        endmethod
    endstruct

    //! runtextmacro Struct("FireBuff")
        static Event DAMAGE_EVENT

        UnitAttackSplash splash

        eventMethod Event_Damage
            local Unit target = params.Unit.GetDamager()
            local Unit victim = params.Unit.GetTrigger()

            local thistype this = target

            call victim.Effects.Create("Abilities\\Weapons\\LordofFlameMissile\\LordofFlameMissile.mdl", AttachPoint.CHEST, EffectLevel.NORMAL).Destroy()
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            call target.Event.Remove(DAMAGE_EVENT)

            call target.Attack.Splash.Destroy(this.splash)
        endmethod

        eventMethod Event_BuffGain
            local integer level = params.Buff.GetLevel()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            set this.splash = target.Attack.Splash.Create(thistype.AREA_RANGE[level], thistype.DAMAGE_FACTOR[level])
            call target.Event.Add(DAMAGE_EVENT)
        endmethod

        static method Add takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct

    //! runtextmacro Struct("IceBuff")
        static Event DAMAGE_EVENT

        real buffDuration
        integer level

        eventMethod Event_Damage
            local Unit target = params.Unit.GetDamager()
            local Unit victim = params.Unit.GetTrigger()

            local thistype this = target

            call victim.Buffs.Timed.Start(thistype.COLDNESS_BUFF, this.level, this.buffDuration)
            call victim.Effects.Create("Abilities\\Weapons\\LichMissile\\LichMissile.mdl", AttachPoint.CHEST, EffectLevel.NORMAL).Destroy()
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            call target.Event.Remove(DAMAGE_EVENT)
        endmethod

        eventMethod Event_BuffGain
            local integer level = params.Buff.GetLevel()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            set this.buffDuration = thistype.DURATION[level]
            set this.level = level
            call target.Event.Add(DAMAGE_EVENT)
        endmethod

        static method Add takes integer level, Unit target returns nothing
            call target.Buffs.Add(thistype.DUMMY_BUFF, level)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call UNIT.Cold.NORMAL_BUFF.Variants.Add(thistype.COLDNESS_BUFF)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Doppelganger", "DOPPELGANGER")
    //! runtextmacro GetKey("KEY")
    static Event ILLUSION_DESTROY_EVENT

    real angle
    Timer delayTimer
    real duration
    Unit illusion
    real illusionDamageFactor
    integer level
    real startX
    real startY
    real targetX
    real targetY

    //! runtextmacro LinkToStruct("Doppelganger", "BigBoom")
    //! runtextmacro LinkToStruct("Doppelganger", "FireBuff")
    //! runtextmacro LinkToStruct("Doppelganger", "IceBuff")

    static method GetCasterFromIllusion takes Unit illusion returns Unit
        return illusion.Data.Integer.Get(KEY)
    endmethod

    eventMethod Event_IllusionDestroy
        local Unit illusion = params.Unit.GetTrigger()

        local thistype this = illusion.Data.Integer.Get(KEY)

        local Unit caster = this
        local Timer delayTimer = this.delayTimer

        set this.illusion = NULL
        call delayTimer.Destroy()
        call illusion.Data.Integer.Remove(KEY)
        call illusion.Event.Remove(ILLUSION_DESTROY_EVENT)

        call caster.Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod CasterImpact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local real x = dummyMissile.Position.X.Get()
        local real y = dummyMissile.Position.Y.Get()

        local Unit caster = this

        call dummyMissile.DummyUnit.Get().DestroyInstantly()

        call dummyMissile.Destroy()

        call caster.Transport.Subtract()

        call caster.Position.SetXYZ(x, y, Spot.GetHeight(x, y))

        call thistype(NULL).FireBuff.Add(level, caster)
    endmethod

    eventMethod IllusionImpact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local real x = dummyMissile.Position.X.Get()
        local real y = dummyMissile.Position.Y.Get()

        local Unit caster = this
        local integer level = this.level

        call dummyMissile.DummyUnit.Get().DestroyInstantly()

        call dummyMissile.Destroy()

        local Unit illusion = Unit.CreateIllusion(caster.Type.Get(), caster.Owner.Get(), x, y, caster.Facing.Get(), this.duration, thistype.ILLUSION_DEATH_EFFECT_PATH)

        set this.illusion = illusion
        call illusion.Data.Integer.Set(KEY, this)
        call illusion.Event.Add(ILLUSION_DESTROY_EVENT)

        call illusion.Abilities.Clear()
        call HeroSpell.ClearAtUnit(illusion)

        call illusion.Abilities.AddWithLevel(thistype(NULL).BigBoom.THIS_SPELL, level)
        call illusion.Buffs.Add(thistype.ILLUSION_BUFF, level)
        call illusion.Damage.Relative.Invisible.Set(this.illusionDamageFactor)
        call illusion.Level.SetNoArt(caster.Level.Get())

        call thistype(NULL).IceBuff.Add(level, illusion)
    endmethod

    timerMethod Delay
        local thistype this = Timer.GetExpired().GetData()

        local real angle = this.angle
        local Unit caster = this
        local real startX = this.startX
        local real startY = this.startY
        local real targetX = this.targetX
        local real targetY = this.targetY

        local real dX = targetX - startX
        local real dY = targetY - startY

        local real d = Math.Max(thistype.MIN_RANGE, Math.DistanceByDeltas(dX, dY) - thistype.MIN_RANGE)

        set angle = angle - Math.QUARTER_ANGLE

        set targetX = startX + d * Math.Cos(angle)
        set targetY = startY + d * Math.Sin(angle)

		local Missile dummyMissile = Missile.Create()

        call dummyMissile.Acceleration.Set(500.)
        call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)//.AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
        call dummyMissile.Impact.SetAction(function thistype.CasterImpact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(800.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)

        set angle = angle + Math.HALF_ANGLE
        set dummyMissile = Missile.Create()

        set targetX = startX + d * Math.Cos(angle)
        set targetY = startY + d * Math.Sin(angle)

        call dummyMissile.Acceleration.Set(500.)
        call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)//.AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
        call dummyMissile.Impact.SetAction(function thistype.IllusionImpact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(800.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)
    endmethod

    eventMethod Event_BuffLose
        local Unit caster = params.Unit.GetTrigger()

        local thistype this = caster

        local Unit illusion = this.illusion

        if (illusion != NULL) then
            call illusion.Kill()
        endif
    endmethod

    eventMethod Event_BuffGain
        local EventResponse castParams = params.Buff.GetData()
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Buff.GetLevel()

        local real targetX = castParams.Spot.GetTargetX()
        local real targetY = castParams.Spot.GetTargetY()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local thistype this = caster

		local Timer delayTimer = Timer.Create()

        set this.angle = caster.CastAngle(targetX - casterX, targetY - casterY)
        set this.delayTimer = delayTimer
        set this.duration = thistype.DURATION[level]
        set this.illusion = NULL
        set this.illusionDamageFactor = thistype.ILLUSION_DAMAGE_FACTOR[level]
        set this.level = level
        set this.startX = casterX
        set this.startY = casterY
        set this.targetX = targetX
        set this.targetY = targetY
        call delayTimer.SetData(this)

        call caster.Transport.Add()

        call delayTimer.Start(0.5, false, function thistype.Delay)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()

        call Spot.CreateEffectWithSize(caster.Position.X.Get(), caster.Position.Y.Get(), thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW, caster.Scale.Get()).Destroy()

        call caster.Buffs.AddFreshEx(thistype.DUMMY_BUFF, params.Spell.GetLevel(), params)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ILLUSION_DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_IllusionDestroy)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).BigBoom.Init()
        call thistype(NULL).FireBuff.Init()
        call thistype(NULL).IceBuff.Init()
    endmethod
endstruct