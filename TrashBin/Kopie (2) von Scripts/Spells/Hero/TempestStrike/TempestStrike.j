//! runtextmacro Folder("TempestStrike")
    //! runtextmacro Struct("CriticalAttacks")
        static real array ATTACK_SPEED_INCREMENT
        static real array CRITICAL_INCREMENT
        static Buff DUMMY_BUFF
        static real DURATION

        //! import "Spells\Hero\TempestStrike\CriticalAttacks\obj.j"

        real attackSpeedAdd
        real criticalAdd

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local real attackSpeedAdd = this.attackSpeedAdd
            local real criticalAdd = this.criticalAdd

            call target.Attack.Speed.BonusA.Subtract(attackSpeedAdd)
            call target.CriticalChance.Bonus.Subtract(criticalAdd)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real attackSpeedAdd = thistype.ATTACK_SPEED_INCREMENT[level]
            local real criticalAdd = thistype.CRITICAL_INCREMENT[level]
            local thistype this = target

            set this.attackSpeedAdd = attackSpeedAdd
            set this.criticalAdd = criticalAdd
            call target.Attack.Speed.BonusA.Add(attackSpeedAdd)
            call target.CriticalChance.Bonus.Add(criticalAdd)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION)
        endmethod

        static method Init takes nothing returns nothing
            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "CrA", "Tempest Strike", "5", "true", "ReplaceableTextures\\CommandButtons\\BTNCleavingAttack.blp", "Does a lot of critical strikes.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDispel(true)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Spells\\TempestStrike\\Buff.mdx", AttachPoint.WEAPON, EffectLevel.LOW)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\IllidanMissile\\IllidanMissile.mdl", AttachPoint.WEAPON, EffectLevel.LOW)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("TempestStrike", "TEMPEST_STRIKE")
    static real array DAMAGE
    static Buff DUMMY_BUFF
    static real DURATION
    static Group ENUM_GROUP
    static real LENGTH
    static real SPEED_END
    static string TARGET_EFFECT_ATTACH_POINT
    static string TARGET_EFFECT_PATH
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")

    static Spell THIS_SPELL

    //! import "obj_TempestStrike.j"

    real damage
    integer level
    Group targetGroup
    Timer updateTimer

    //! runtextmacro LinkToStruct("TempestStrike", "CriticalAttacks")

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local integer level = this.level
        local Group targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer

        local boolean useBuff = (targetGroup.GetFirst() != NULL)

        call targetGroup.Destroy()
        call updateTimer.Destroy()

        call target.Animation.Queue(UNIT.Animation.STAND)
        call target.Ghost.Subtract()
        call target.Stun.Subtract(UNIT.Stun.NONE_BUFF)

        if (useBuff) then
            call thistype(NULL).CriticalAttacks.Start(level, target)
        endif
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

        return true
    endmethod

    static method Update takes nothing returns nothing
        local real damage
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        local Group targetGroup = this.targetGroup

        set Group.TEMP = targetGroup
        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set damage = this.damage
            set targetGroup = this.targetGroup

            loop
                call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
                call targetGroup.AddUnit(target)

                call caster.DamageUnitBySpell(target, damage, false, true)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()
        local Timer updateTimer = Timer.Create()

        local thistype this = target

        set this.damage = thistype.DAMAGE[level]
        set this.level = level
        set this.targetGroup = Group.Create()
        set this.updateTimer = updateTimer
        call updateTimer.SetData(this)

        call target.Abilities.Refresh(DeprivingShock.THIS_SPELL)
        call target.Effects.Create("Spells\\TempestStrike\\Afterburn2.mdx", AttachPoint.FOOT, EffectLevel.NORMAL).DestroyTimed.Start(thistype.DURATION)
        call target.Ghost.Add()
        call target.Position.Timed.Accelerated.AddSpeedDirection(2. * thistype.LENGTH / thistype.DURATION - thistype.SPEED_END, 2. / thistype.DURATION * (thistype.SPEED_END - thistype.LENGTH / thistype.DURATION), Math.AtanByDeltas(targetY - target.Position.Y.Get(), targetX - target.Position.X.Get()), thistype.DURATION)
        call target.Stun.Add(UNIT.Stun.NONE_BUFF)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, SPELL.Event.GetLevel(), thistype.DURATION)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)

        call thistype(NULL).CriticalAttacks.Init()
    endmethod
endstruct