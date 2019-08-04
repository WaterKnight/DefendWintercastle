//! runtextmacro Folder("WhiteStaff")
    //! runtextmacro Struct("Target")
        static method Init takes nothing returns nothing
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("WhiteStaff", "WHITE_STAFF")
    static real array MANA_HEAL

    boolean channeling
    Sound dummySound
    Lightning effectLightning
    Timer intervalTimer
    boolean onSummon
    real manaHeal
    Unit target
    BuffRef targetBuffRef

    //! runtextmacro LinkToStruct("WhiteStaff", "Target")

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        call caster.HealManaBySpell(caster, this.manaHeal)
    endmethod

    static method EndChannel takes Unit caster returns nothing
        local thistype this = caster

        local Lightning effectLightning = this.effectLightning
        local Timer intervalTimer = this.intervalTimer
        local boolean onSummon = this.onSummon
        local Unit target = this.target
        local BuffRef targetBuffRef = this.targetBuffRef

		call dummySound.Destroy(true)
        call effectLightning.Destroy()
        call intervalTimer.Destroy()

		if (targetBuffRef != NULL) then
        	call targetBuffRef.Destroy()
        endif

        if onSummon then
            call target.KillBy(caster)

            call target.Death.Explosion.Subtract()
        endif
    endmethod

    eventMethod Event_EndCast
        local Unit caster = params.Unit.GetTrigger()

        local thistype this = thistype(caster)

        if not this.channeling then
            return
        endif

        set this.channeling = false

        call thistype.EndChannel(caster)
    endmethod

    static method StartChannel takes Unit caster, integer level, Unit target returns nothing
        local thistype this = caster

        local Lightning effectLightning = Lightning.Create(thistype.BOLT)
        local Timer intervalTimer = Timer.Create()

        set this.channeling = true
        set this.dummySound = Sound.CreateFromType(thistype.DUMMY_SOUND)
        set this.effectLightning = effectLightning
        set this.intervalTimer = intervalTimer
        set this.manaHeal = thistype.MANA_HEAL[level]
        set this.target = target
        call intervalTimer.SetData(this)

		call dummySound.AttachToUnitAndPlay(caster)
        call effectLightning.FromUnitToUnit.Start(caster, target)

        if target.Classes.Contains(UnitClass.SUMMON) then
            set this.onSummon = true

            call target.Death.Explosion.Add()
            call target.Scale.Timed.Add(thistype.SUMMON_SCALE_ADD * target.Type.Get().Scale.Get(), thistype.THIS_SPELL.GetChannelTime(level))
        else
            set this.onSummon = false
        endif

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)

		if target.IsAllyOf(caster.Owner.Get()) then
        	set this.targetBuffRef = target.Buffs.CreateWithLevel(thistype(NULL).Target.DUMMY_BUFF, level, NULL)
        else
            set this.targetBuffRef = NULL
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        call thistype.StartChannel(caster, level, target)
    endmethod

    initMethod Init of Spells_Artifacts
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))

        local integer level = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            exitwhen (level < 1)

            set thistype.MANA_HEAL[level] = thistype.MANA_HEAL_PER_SECOND[level] * thistype.INTERVAL

            set level = level - 1
        endloop
        
        call thistype(NULL).Target.Init()
    endmethod
endstruct