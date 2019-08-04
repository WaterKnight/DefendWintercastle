//! runtextmacro Folder("RigorMortis")
    //! runtextmacro Struct("AfterBuff")
        static method Start takes Unit target, integer level returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.INVIS_DURATION)
        endmethod

        static method Init takes nothing returns nothing
            call UNIT.Ghost.DUMMY_BUFF.Variants.Add(thistype.DUMMY_BUFF)
            call UNIT.Invisibility.PERM_BUFF.Variants.Add(thistype.DUMMY_BUFF)
            call UNIT.Pathing.DUMMY_BUFF.Variants.Add(thistype.DUMMY_BUFF)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("RigorMortis", "RIGOR_MORTIS")
    static Event REVIVE_EVENT

    Timer durationTimer
    integer level
    SpotEffect specialEffect
    real targetLife
    real targetMana
    real targetX
    real targetY

    //! runtextmacro LinkToStruct("RigorMortis", "AfterBuff")

    method Ending takes Timer durationTimer, Unit target returns nothing
        local SpotEffect specialEffect = this.specialEffect

        call durationTimer.Pause()
        call specialEffect.Destroy()
        call target.Event.Remove(REVIVE_EVENT)
    endmethod

    timerMethod EndingByTimer
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local integer level = this.level
        local Unit target = this
        local real targetLife = this.targetLife
        local real targetMana = this.targetMana
        local real targetX = this.targetX
        local real targetY = this.targetY

        call this.Ending(durationTimer, target)

        call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call target.Hero.Revive(targetX, this.targetY)

//        call target.Invisibility.AddTimed(thistype.INVIS_DURATION)
        call target.Life.Set(targetLife)
        call target.Mana.Set(targetMana)
        call target.Select(target.Owner.Get(), true)

        call thistype(NULL).AfterBuff.Start(target, level)
    endmethod

    eventMethod Event_Revive
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        call this.Ending(this.durationTimer, target)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()

        local real targetX = caster.Position.X.Get()
        local real targetY = caster.Position.Y.Get()

		call Spot.CreateEffect(targetX, targetY, thistype.CAST_EFFECT_PATH, EffectLevel.NORMAL).Destroy()

        local thistype this = caster

		local Timer durationTimer = Timer.Create()

        set this.durationTimer = durationTimer
        set this.level = level
        set this.specialEffect = Spot.CreateEffect(targetX, targetY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW)
        set this.targetLife = caster.Life.Get() + caster.MaxLife.Get() * thistype.LIFE_FACTOR[level]
        set this.targetMana = caster.Mana.Get() + caster.MaxMana.Get() * thistype.MANA_FACTOR[level] - thistype.THIS_SPELL.GetManaCost(level)
        set this.targetX = targetX
        set this.targetY = targetY
        call caster.Event.Add(REVIVE_EVENT)
        call durationTimer.SetData(this)

        call caster.Abilities.Cooldown.Start(thistype.THIS_SPELL)
        call caster.Revival.Set(true)

        call durationTimer.Start(thistype.DELAY, false, function thistype.EndingByTimer)

        call caster.Kill()
    endmethod

    initMethod Init of Spells_Hero
        set thistype.REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Revive)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).AfterBuff.Init()
    endmethod
endstruct