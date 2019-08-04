//! runtextmacro Folder("GreenNova")
    //! runtextmacro Struct("Buff")
        static Buff DUMMY_BUFF
        static real DURATION

        //! import "Spells\Act1\GreenNova\Buff\obj.j"

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            call target.Attack.Add()
            call target.Movement.Add()
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            call target.Attack.Subtract()
            call target.Movement.Subtract()
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION)
        endmethod

        static method Init takes nothing returns nothing
                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "GrN", "Entangled", "1", "false", "ReplaceableTextures\\CommandButtons\\BTNEntanglingRoots.blp", "Unit is entangled.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.SetLostOnDispel(true)
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("GreenNova", "GREEN_NOVA")
    static real DURATION
    static real INTERVAL
    static Group ENUM_GROUP
    static real MAX_RADIUS
    static real RADIUS_ADD
    static string SPECIAL_EFFECT_PATH
    static real SPECIAL_EFFECT_PERIMETER_INTERVAL
    static BoolExpr TARGET_FILTER
    static integer WAVES_AMOUNT

    static Spell THIS_SPELL

    //! import "Spells\Act1\GreenNova\obj.j"

    real angle
    Unit caster
    Timer intervalTimer
    integer level
    real radius
    real radiusAdd
    real x
    real y

    //! runtextmacro LinkToStruct("GreenNova", "Buff")

    static method Ending takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local Timer intervalTimer = this.intervalTimer

        call durationTimer.Destroy()
        call intervalTimer.Destroy()
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.GROUND) == false) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif
        if (target.Position.InRangeWithCollision(TEMP_REAL2, TEMP_REAL3, TEMP_REAL)) then
            return false
        endif

        return true
    endmethod

    static method Interval takes nothing returns nothing
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local real angle = this.angle
        local integer level = this.level
        local real radius = this.radius + this.radiusAdd
        local real x = this.x
        local real y = this.y

        local real angleAdd = thistype.SPECIAL_EFFECT_PERIMETER_INTERVAL / radius
        local integer iteration = Real.ToInt(2 * Math.PI * radius / thistype.SPECIAL_EFFECT_PERIMETER_INTERVAL)

        set this.radius = radius

        loop
            call Spot.CreateEffect(x + radius * Math.Cos(angle), y + radius * Math.Sin(angle), thistype.SPECIAL_EFFECT_PATH, EffectLevel.Random(EffectLevel.LOW, EffectLevel.NORMAL)).Destroy()

            set iteration = iteration - 1
            exitwhen (iteration < 1)

            set angle = angle + angleAdd
        endloop

        set TEMP_REAL = radius - this.radiusAdd
        set TEMP_REAL2 = x
        set TEMP_REAL3 = y
        set User.TEMP = this.caster.Owner.Get()

        call ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, radius, thistype.TARGET_FILTER)

        loop
            set target = ENUM_GROUP.FetchFirst()
            exitwhen (target == NULL)

            call thistype(NULL).Buff.Start(level, target)
        endloop
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()
        local thistype this = thistype.allocate()

        set this.angle = caster.Facing.Get()
        set this.caster = caster
        set this.intervalTimer = intervalTimer
        set this.level = SPELL.Event.GetLevel()
        set this.radius = 0.
        set this.radiusAdd = thistype.RADIUS_ADD
        set this.x = caster.Position.X.Get()
        set this.y = caster.Position.Y.Get()
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)

        call durationTimer.Start(thistype.DURATION, false, function thistype.Ending)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DURATION = thistype.INTERVAL * thistype.WAVES_AMOUNT
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.RADIUS_ADD = thistype.MAX_RADIUS / thistype.WAVES_AMOUNT
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Buff.Init()
    endmethod
endstruct