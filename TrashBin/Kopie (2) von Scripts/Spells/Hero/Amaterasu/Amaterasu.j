//! runtextmacro Folder("Amaterasu")
    //! runtextmacro Struct("Target")
        static Buff DUMMY_BUFF
        static real DURATION

        //! import "Spells\Hero\Amaterasu\Target\obj.j"

        static method Start takes Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, thistype.DURATION)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayDamage.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Amaterasu", "AMATERASU")
    static Buff DUMMY_BUFF
    static real array DAMAGE
    static real DAMAGE_AIR_FACTOR
    static real array DAMAGE_ALL
    static Group ENUM_GROUP
    static real INTERVAL
    static real array LIFE_INCREMENT
    static BoolExpr TARGET_FILTER

    static Spell THIS_SPELL

    //! import "Spells\Hero\Amaterasu\obj_Amaterasu.j"

    real areaRange
    real damage
    Timer intervalTimer
    integer level
    real lifeAdd
    real targetX
    real targetY

    //! runtextmacro LinkToStruct("Amaterasu", "Target")

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local Timer intervalTimer = this.intervalTimer
        local real lifeAdd = this.lifeAdd

        call target.MaxLife.Bonus.Subtract(lifeAdd)
        call intervalTimer.Destroy()
    endmethod

    static method Event_EndCast takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif

        if (target.Buffs.Contains(thistype(NULL).Target.DUMMY_BUFF)) then
            return false
        endif

        return true
    endmethod

    static method Interval takes nothing returns nothing
        local real damage
        local Unit target2
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this

        /*if (Math.RandomI(0, 1) == 0) then
            call Spot.CreateRipple(this.targetX, this.targetY, target.CollisionSize.Get(true), this.areaRange + 100., 128., 3.)
            call SPOT.DeformNova.Create(this.targetX, this.targetY, 64., this.areaRange + 100., 200.)
        endif*/

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(this.targetX, this.targetY, this.areaRange, thistype.TARGET_FILTER)

        set target2 = thistype.ENUM_GROUP.FetchFirst()

        if (target2 != NULL) then
            set damage = this.damage

            loop
                call thistype(NULL).Target.Start(target2)

                if (target2.Classes.Contains(UnitClass.GROUND)) then
                    call target.DamageUnitBySpell(target2, damage, false, false)
                else
                    call target.DamageUnitBySpell(target2, damage * thistype.DAMAGE_AIR_FACTOR, false, false)
                endif

                set target2 = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target2 == NULL)
            endloop
        endif
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Timer intervalTimer = Timer.Create()
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local real lifeAdd = thistype.LIFE_INCREMENT[level]
        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()
        local thistype this = target

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.damage = thistype.DAMAGE[level]
        set this.intervalTimer = intervalTimer
        set this.lifeAdd = lifeAdd
        set this.targetX = targetX
        set this.targetY = targetY
        call intervalTimer.SetData(this)
        call target.MaxLife.Bonus.Add(lifeAdd)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration

        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\LiquidFire\\Liquidfire.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Voodoo\\VoodooAura.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)

        call thistype(NULL).Target.Init()

        set iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set thistype.DAMAGE[iteration] = thistype.DAMAGE_ALL[iteration] / Real.ToInt(thistype.THIS_SPELL.GetChannelTime(iteration) / thistype(NULL).Target.DURATION)

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop
    endmethod
endstruct