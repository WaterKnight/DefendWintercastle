//! runtextmacro Folder("Doppelganger")
    //! runtextmacro Spell_OpenScope("/")

    //! runtextmacro Struct("BigBoom")
        static real array DAMAGE
        static Group ENUM_GROUP
        static real array IGNITE_DURATION
        static BoolExpr TARGET_FILTER

        static Spell THIS_SPELL

        //! import "Spells\Hero\Doppelganger\BigBoom\obj.j"

        static method TargetConditions takes nothing returns boolean
            local Unit target = UNIT.Event.Native.GetFilter()

            if (target.Classes.Contains(UnitClass.DEAD)) then
                return false
            endif
            if (target.IsAllyOf(User.TEMP)) then
                return false
            endif

            return true
        endmethod

        static method Event_SpellEffect takes nothing returns nothing
            local Unit caster = UNIT.Event.GetTrigger()
            local real damage
            local real igniteDuration
            local integer level = SPELL.Event.GetLevel()
            local Unit target

            call Spot.CreateEffect(caster.Position.X.Get(), caster.Position.Y.Get(), "Spells\\Doppelganger\\BigBoom.mdx", EffectLevel.LOW).Destroy()

            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

            set target = thistype.ENUM_GROUP.FetchFirst()

            if (target != NULL) then
                set damage = thistype.DAMAGE[level]
                set igniteDuration = thistype.IGNITE_DURATION[level]

                loop
                    call target.Ignited.AddTimed(caster, igniteDuration)

                    call caster.DamageUnitBySpell(target, damage, false, false)

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

            //! runtextmacro Spell_Finalize("/")
        endmethod
    endstruct

    //! runtextmacro Struct("FireBuff")
        static real array AREA_RANGE
        static Event DAMAGE_EVENT
        static real array DAMAGE_FACTOR
        static Buff DUMMY_BUFF
        static real array DURATION

        //! import "Spells\Hero\Doppelganger\FireBuff\obj.j"

        integer splashIndex

        static method Event_Damage takes nothing returns nothing
            local Unit target = UNIT.Event.GetDamager()
            local Unit victim = UNIT.Event.GetTrigger()

            local thistype this = target

            call victim.Effects.Create("Abilities\\Weapons\\LordofFlameMissile\\LordofFlameMissile.mdl", AttachPoint.CHEST, EffectLevel.NORMAL).Destroy()
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            call target.Event.Remove(DAMAGE_EVENT)

            call target.Attack.Splash.Subtract(this.splashIndex)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            set this.splashIndex = target.Attack.Splash.Add(thistype.AREA_RANGE[level], thistype.DAMAGE_FACTOR[level])
            call target.Event.Add(DAMAGE_EVENT)
        endmethod

        static method Add takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)

                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "DGF", "Fire Buff", "3", "true", "ReplaceableTextures\\CommandButtons\\BTNFire.blp", "This unit's attacks are smouldering. It deals splash damage.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.SetLostOnDeath(true)
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Items\\AIfb\\AIfbTarget.mdl", AttachPoint.WEAPON, EffectLevel.LOW)
        endmethod
    endstruct

    //! runtextmacro Struct("IceBuff")
        static real array BUFF_DURATION
        static Event DAMAGE_EVENT
        static Buff DUMMY_BUFF

        //! import "Spells\Hero\Doppelganger\IceBuff\obj.j"

        real buffDuration

        static method Event_Damage takes nothing returns nothing
            local Unit target = UNIT.Event.GetDamager()
            local Unit victim = UNIT.Event.GetTrigger()

            local thistype this = target

            call victim.Cold.AddTimed(this.buffDuration)
            call victim.Effects.Create("Abilities\\Weapons\\LichMissile\\LichMissile.mdl", AttachPoint.CHEST, EffectLevel.NORMAL).Destroy()
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            call target.Event.Remove(DAMAGE_EVENT)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            set this.buffDuration = thistype.BUFF_DURATION[level]
            call target.Event.Add(DAMAGE_EVENT)
        endmethod

        static method Add takes integer level, Unit target returns nothing
            call target.Buffs.Add(thistype.DUMMY_BUFF, level)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)

                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "DGC", "Cold Buff", "3", "true", "ReplaceableTextures\\CommandButtons\\BTNFrost.blp", "This unit's attacks are cold.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Items\\AIob\\AIobTarget.mdl", AttachPoint.WEAPON, EffectLevel.LOW)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Doppelganger", "DOPPELGANGER")
    static Buff DUMMY_BUFF
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dDoG", "Doppelganger", "DUMMY_UNIT_ID", "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageMissile.mdl")
    static real array DURATION
    //! runtextmacro GetKey("KEY")
    static Buff ILLUSION_BUFF
    static real array ILLUSION_DAMAGE_FACTOR
    static string ILLUSION_DEATH_EFFECT_PATH
    static Event ILLUSION_DESTROY_EVENT
    static real MIN_RANGE

    static Spell THIS_SPELL

    //! import "Spells\Hero\Doppelganger\obj.j"

    real duration
    Unit illusion
    real illusionDamageFactor
    integer level

    //! runtextmacro LinkToStruct("Doppelganger", "BigBoom")
    //! runtextmacro LinkToStruct("Doppelganger", "FireBuff")
    //! runtextmacro LinkToStruct("Doppelganger", "IceBuff")

    static method Event_IllusionDestroy takes nothing returns nothing
        local Unit illusion = UNIT.Event.GetTrigger()

        local thistype this = illusion.Data.Integer.Get(KEY)

        local Unit caster = this

        set this.illusion = NULL
        call illusion.Data.Integer.Remove(KEY)
        call illusion.Event.Remove(ILLUSION_DESTROY_EVENT)

        call caster.Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method CasterImpact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

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

    static method IllusionImpact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()
        local Unit illusion

        local thistype this = dummyMissile.GetData()
        local real x = dummyMissile.Position.X.Get()
        local real y = dummyMissile.Position.Y.Get()

        local Unit caster = this
        local integer level = this.level

        call dummyMissile.DummyUnit.Get().DestroyInstantly()

        call dummyMissile.Destroy()

        set illusion = Unit.CreateIllusion(caster.Type.Get(), caster.Owner.Get(), x, y, caster.Facing.Get(), this.duration, thistype.ILLUSION_DEATH_EFFECT_PATH)

        set this.illusion = illusion
        call illusion.Data.Integer.Set(KEY, this)
        call illusion.Event.Add(ILLUSION_DESTROY_EVENT)

        call illusion.Abilities.AddWithLevel(thistype(NULL).BigBoom.THIS_SPELL, level)
        call illusion.Buffs.Add(thistype.ILLUSION_BUFF, level)
        call illusion.Damage.Relative.Invisible.Set(this.illusionDamageFactor)

        call thistype(NULL).IceBuff.Add(level, illusion)
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        local thistype this = caster

        local Unit illusion = this.illusion

        if (illusion != NULL) then
            call illusion.Kill()
        endif
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Missile dummyMissile = Missile.Create()
        local integer level = BUFF.Event.GetLevel()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()

        local UnitType casterType = caster.Type.Get()
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local thistype this = caster

        local real dX = targetX - casterX
        local real dY = targetY - casterY

        local real angle = caster.CastAngle(dX, dY)
        local real d = Math.Max(thistype.MIN_RANGE, Math.DistanceByDeltas(dX, dY) - thistype.MIN_RANGE)

        set angle = angle - Math.QUARTER_ANGLE

        set targetX = casterX + d * Math.Cos(angle)
        set targetY = casterY + d * Math.Sin(angle)

        set this.duration = thistype.DURATION[level]
        set this.illusion = NULL
        set this.illusionDamageFactor = thistype.ILLUSION_DAMAGE_FACTOR[level]
        set this.level = level

        call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)//.AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
        call dummyMissile.Impact.SetAction(function thistype.CasterImpact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(1300.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)

        set angle = angle + Math.HALF_ANGLE
        set dummyMissile = Missile.Create()

        set targetX = casterX + d * Math.Cos(angle)
        set targetY = casterY + d * Math.Sin(angle)

        call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)//.AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
        call dummyMissile.Impact.SetAction(function thistype.IllusionImpact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(1300.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)

        call caster.Transport.Add()
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        call caster.Effects.Create("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", AttachPoint.ORIGIN, EffectLevel.LOW).Destroy()

        call caster.Buffs.AddFresh(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ILLUSION_DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_IllusionDestroy)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            //! runtextmacro Buff_Create("/", "ILLUSION_BUFF", "DGI", "Doppelganger", "3", "true", "ReplaceableTextures\\CommandButtons\\BTNDoom.blp", "Your vision play tricks on you. But the pain seems rather real.")

        call thistype(NULL).BigBoom.Init()
        call thistype(NULL).FireBuff.Init()
        call thistype(NULL).IceBuff.Init()
    endmethod
endstruct