//! runtextmacro BaseStruct("TorchLight", "TORCH_LIGHT")
    static Event DAMAGE_EVENT
    static Buff DUMMY_BUFF
    static BoolExpr TARGET_FILTER

    Timer updateTimer

    static method AddIgnited takes Unit caster, integer level, Unit target returns nothing
        local real duration

        if (target.Classes.Contains(UnitClass.HERO)) then
            set duration = thistype.HERO_DURATION
        else
            set duration = thistype.DURATION
        endif

        call target.Ignited.AddTimed(caster, duration)
    endmethod

    static method Conditions takes Unit target returns boolean
        if (target.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif

        return true
    endmethod

    static method Event_Damage takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        if (thistype.Conditions(target) == false) then
            return
        endif

        call thistype(NULL).AddIgnited(UNIT.Event.GetDamager(), SPELL.Event.GetLevel(), target)
    endmethod

    static method TargetConditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (thistype.Conditions(target) == false) then
            return false
        endif
        if (target.Buffs.Contains(UNIT.Ignited.DUMMY_BUFF)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.IsEnemyOf(User.TEMP) == false) then
            return false
        endif

        return true
    endmethod

    static method Update takes nothing returns nothing
        local Unit target2
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this

        set User.TEMP = target.Owner.Get()

        set target2 = GROUP.EnumUnits.InRange.WithCollision.GetNearest(target.Position.X.Get(), target.Position.Y.Get(), target.Attack.Range.Get(), thistype.TARGET_FILTER)

        if (target2 != NULL) then
            call target.Order.UnitTarget(Order.ATTACK, target2)
        endif
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local Timer updateTimer = this.updateTimer

        call target.Event.Remove(DAMAGE_EVENT)
        call updateTimer.Destroy()
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()
        local Timer updateTimer = Timer.Create()

        local thistype this = target

        set this.updateTimer = updateTimer
        call target.Event.Add(DAMAGE_EVENT)
        call updateTimer.SetData(this)

        call updateTimer.Start(0.5, true, function thistype.Update)
    endmethod

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
    endmethod
endstruct