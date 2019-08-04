//! runtextmacro Folder("SpearOfTheDefender")
    //! runtextmacro Struct("Buff")
        static Unit CASTER
        static constant real DAMAGE = 50.
        static constant real DURATION = 10.
        static constant integer INTERVALS_AMOUNT = 10
        static constant string TARGET_EFFECT_ATTACH_POINT = AttachPoint.CHEST

        static constant real DAMAGE_PER_INTERVAL = thistype.DAMAGE / thistype.INTERVALS_AMOUNT
        static constant real INTERVAL = thistype.DURATION / thistype.INTERVALS_AMOUNT

        Unit caster
        Timer intervalTimer

        timerMethod Interval
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            call target.Effects.Create(target.Blood.Get(), thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).DestroyTimed.Start(2.)

            call this.caster.DamageUnit(target, thistype.DAMAGE_PER_INTERVAL, false)
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            local Timer intervalTimer = this.intervalTimer

            call intervalTimer.Destroy()
        endmethod

        eventMethod Event_BuffGain
            local Unit caster = thistype.CASTER
            local Timer intervalTimer = Timer.Create()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            set this.caster = caster
            set this.intervalTimer = intervalTimer
            call intervalTimer.SetData(this)

            call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        endmethod

        static method Start takes Unit caster, Unit target returns nothing
            set thistype.CASTER = caster

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, thistype.DURATION)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SpearOfTheDefender", "SPEAR_OF_THE_DEFENDER")
    static constant real ARMOR_INCREMENT = 0.2
    static constant real ATTACK_RATE_INCREMENT = -0.2
    static Event DAMAGE_EVENT
    static constant real DAMAGE_INCREMENT = 50.
    //! runtextmacro GetKey("KEY")
    static constant real MANA_INCREMENT = 30.

    //! runtextmacro LinkToStruct("SpearOfTheDefender", "Buff")

    eventMethod Event_Damage
        local Unit caster = params.Unit.GetDamager()
        local Unit target = params.Unit.GetTrigger()

        call thistype(NULL).Buff.Start(caster, target)
    endmethod

    eventMethod Event_Drop
        local Unit whichUnit = params.Unit.GetTrigger()

        local integer amount = (whichUnit.Data.Integer.Get(KEY) - 1)

        call whichUnit.Armor.Relative.Subtract(thistype.ARMOR_INCREMENT)
        call whichUnit.Attack.Speed.BonusA.Subtract(thistype.ATTACK_RATE_INCREMENT)
        call whichUnit.Damage.Bonus.Subtract(thistype.DAMAGE_INCREMENT)
        call whichUnit.Data.Integer.Set(KEY, amount)
        if (amount == HASH_TABLE.Integer.DEFAULT_VALUE) then
            call whichUnit.Event.Add(DAMAGE_EVENT)
        endif
    endmethod

    eventMethod Event_PickUp
        local Unit whichUnit = params.Unit.GetTrigger()

        local integer amount = (whichUnit.Data.Integer.Get(KEY) + 1)

        call whichUnit.Armor.Relative.Add(thistype.ARMOR_INCREMENT)
        call whichUnit.Attack.Speed.BonusA.Add(thistype.ATTACK_RATE_INCREMENT)
        call whichUnit.Damage.Bonus.Add(thistype.DAMAGE_INCREMENT)
        call whichUnit.Data.Integer.Set(KEY, amount)
        if (amount == HASH_TABLE.Integer.DEFAULT_VALUE + 1) then
            call whichUnit.Event.Add(DAMAGE_EVENT)
        endif
    endmethod

    initMethod Init of Items_Act3
        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Damage)
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))

        call thistype(NULL).Buff.Init()
    endmethod
endstruct