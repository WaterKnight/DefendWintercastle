//! runtextmacro BaseStruct("Ride", "RIDE")
    //! runtextmacro Buff_CreateSimpleType("/", "bRiB", "Ride", "DUMMY_BUFF", "false", "ReplaceableTextures\\CommandButtons\\BTNAnimalWarTraining.blp", "Elevated evasion chance and movement speed.", "ARiB", "BUFF_SPELL_ID")
    static real array DURATION
    static real array EVASION_CHANCE_INCREMENT
    static real array SPEED_INCREMENT

    static Spell THIS_SPELL

    real evasionChanceAdd
    real speedAdd

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local real evasionChanceAdd = this.evasionChanceAdd
        local real speedAdd = this.speedAdd

        call target.EvasionChance.Subtract(evasionChanceAdd)
        //call target.Ghost.Subtract()
        //call target.Invisibility.Subtract()
        call target.Movement.Speed.BonusA.Subtract(speedAdd)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local real evasionChanceAdd = EVASION_CHANCE_INCREMENT[level]
        local real speedAdd = SPEED_INCREMENT[level]
        local thistype this = target

        set this.evasionChanceAdd = evasionChanceAdd
        set this.speedAdd = speedAdd
        call target.EvasionChance.Add(evasionChanceAdd)
        //call target.Ghost.Add()
        //call target.Invisibility.Add()
        call target.Movement.Speed.BonusA.Add(speedAdd)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        local integer level = caster.Abilities.GetLevel(THIS_SPELL)

        call caster.Buffs.Timed.Start(DUMMY_BUFF, level, DURATION[level])
    endmethod

    static method Init takes nothing returns nothing
        call thistype.DUMMY_BUFF_Init()

        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.DUMMY_BUFF.SetLostOnDispel(true)
        call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Items\\AIsp\\SpeedTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)

        set THIS_SPELL = Spell.CreateFromSelf('A03Y')

        call THIS_SPELL.SetOrder(Order.WIND_WALK)
        call THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)

        //! runtextmacro CreateHeroSpell("/", "THIS_SPELL", "Ri", "ReplaceableTextures\\CommandButtons\\BTNAnimalWarTraining.blp", "", "Ride", "", "SPELL_TYPE_SECOND", "5")

        set DURATION[1] = 10.
        set DURATION[2] = 15.
        set DURATION[3] = 20.
        set EVASION_CHANCE_INCREMENT[1] = 0.3
        set EVASION_CHANCE_INCREMENT[2] = 0.4
        set EVASION_CHANCE_INCREMENT[3] = 0.55
        set SPEED_INCREMENT[1] = 150.
        set SPEED_INCREMENT[2] = 150.
        set SPEED_INCREMENT[3] = 150.
        call THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct