//! runtextmacro BaseStruct("RigorMortis", "RIGOR_MORTIS")
    static Event DEATH_EVENT
    static Event REVIVE_EVENT

    Timer durationTimer
    integer level
    SpotEffect specialEffect
    real targetX
    real targetY

    method Ending takes Timer durationTimer, Unit target returns nothing
        local SpotEffect specialEffect = this.specialEffect

        call durationTimer.Pause()
        call specialEffect.Destroy()
        call target.Event.Remove(REVIVE_EVENT)
    endmethod

    static method EndingByTimer takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local integer level = this.level
        local Unit target = this

        call this.Ending(durationTimer, target)

        call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call target.Hero.Revive(this.targetX, this.targetY)

        call target.Invisibility.AddTimed(thistype.INVISIBILITY_DURATION)
        call target.Life.Set(target.MaxLife.GetAll() * thistype.LIFE_FACTOR[level])
        call target.Mana.Set(target.MaxMana.GetAll() * thistype.MANA_FACTOR[level] - thistype.THIS_SPELL.GetManaCost(level))
    endmethod

    static method Event_Revive takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call this.Ending(this.durationTimer, target)
    endmethod

    static method Event_Death takes nothing returns nothing
        local integer level
        local Unit target = UNIT.Event.GetTrigger()
        local real targetX
        local real targetY
        local thistype this

        if (UNIT.Event.GetKiller() == NULL) then
            return
        endif

        if (target.Revival.Is()) then
            return
        endif

        set this = target

        set level = this.level

        if (target.Mana.Get() < thistype.THIS_SPELL.GetManaCost(level)) then
            return
        endif

        set targetX = target.Position.X.Get()
        set targetY = target.Position.Y.Get()

        set this.specialEffect = Spot.CreateEffect(targetX, targetY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW)
        set this.targetX = targetX
        set this.targetY = targetY
        call target.Event.Add(REVIVE_EVENT)

        call target.Abilities.Cooldown.Start(thistype.THIS_SPELL)
        call target.Revival.Set(true)

        call this.durationTimer.Start(DELAY, false, function thistype.EndingByTimer)
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local Timer durationTimer = this.durationTimer

        call durationTimer.Destroy()
        call target.Event.Remove(DEATH_EVENT)
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        set this.durationTimer = Timer.Create()
        set this.level = level
        call durationTimer.SetData(this)
        call target.Event.Add(DEATH_EVENT)
    endmethod

    static method Event_CooldownEnding takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Event_CooldownStart takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()

        call caster.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
        call caster.Life.Add(caster.MaxLife.GetAll() * thistype.LIFE_FACTOR[level])
        call caster.Mana.Add(caster.MaxMana.GetAll() * thistype.MANA_FACTOR[level])
    endmethod

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        set thistype.REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Revive)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Cooldown.ENDING_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_CooldownEnding))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Cooldown.START_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_CooldownStart))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
    endmethod
endstruct