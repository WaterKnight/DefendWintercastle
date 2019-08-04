//! runtextmacro BaseStruct("TorchLight", "TORCH_LIGHT")
    static Event DAMAGE_EVENT
    static BoolExpr TARGET_FILTER

    Timer updateTimer

    static method AddIgnited takes Unit caster, integer level, Unit target returns nothing
        local real duration

        if target.Classes.Contains(UnitClass.HERO) then
            set duration = thistype.HERO_DURATION
        else
            set duration = thistype.DURATION
        endif

        call target.Buffs.Timed.StartEx(thistype.IGNITION_BUFF, level, caster, duration)
    endmethod

    static method Conditions takes Unit target returns boolean
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif

        return true
    endmethod

    eventMethod Event_Damage
        local Unit target = params.Unit.GetTrigger()

        if not thistype.Conditions(target) then
            return
        endif

        call thistype(NULL).AddIgnited(params.Unit.GetDamager(), params.Spell.GetLevel(), target)
    endmethod

    condMethod TargetConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if not thistype.Conditions(target) then
            return false
        endif
        if target.Ignited.Is() then
            return false
        endif
        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.IsEnemyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    timerMethod Update
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this

        set User.TEMP = target.Owner.Get()

        local Unit target2 = GROUP.EnumUnits.InRange.WithCollision.GetNearest(target.Position.X.Get(), target.Position.Y.Get(), target.Attack.Range.Get(), thistype.TARGET_FILTER)

        if (target2 != NULL) then
            call target.Order.UnitTarget(Order.ATTACK, target2)
        endif
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Timer updateTimer = this.updateTimer

        call target.Event.Remove(DAMAGE_EVENT)
        call updateTimer.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

		local Timer updateTimer = Timer.Create()

        set this.updateTimer = updateTimer
        call target.Event.Add(DAMAGE_EVENT)
        call updateTimer.SetData(this)

        call updateTimer.Start(0.5, true, function thistype.Update)
    endmethod

    eventMethod Event_Unlearn
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_Learn
        call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Misc
        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
        call UNIT.Ignited.NORMAL_BUFF.Variants.Add(thistype.IGNITION_BUFF)
    endmethod
endstruct