//! runtextmacro BaseStruct("Zodiac", "ZODIAC")
    static real array ARMOR_INCREMENT
    static real array ATTACK_RATE_INCREMENT
    static Event DEATH_EVENT
    //! runtextmacro Buff_CreateSimpleType("/", "bZoB", "Zodiac", "DUMMY_BUFF", "false", "ReplaceableTextures\\CommandButtons\\BTNRacoon.blp", "Animal friends of nature protect this unit.", "AZoB", "BUFF_SPELL_ID")
    static real array DURATION
    static real array HEAL
    //! runtextmacro GetKey("KEY")
    static constant string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl"
    static real array SPEED_INCREMENT
    static constant real SPELL_POWER_MOD_FACTOR = 1.
    static constant string TARGET_EFFECT_ATTACH_POINT = AttachPoint.HEAD
    static constant string TARGET_EFFECT_PATH = "Units\\NightElf\\Owl\\Owl.mdl"
    static Spell THIS_SPELL

    real armorAdd
    real attackRateAdd
    Timer durationTimer
    real speedAdd
    Unit target
    UnitEffect targetEffect

    method Ending takes Timer durationTimer, Unit target returns nothing
        local real armorAdd = this.armorAdd
        local real attackRateAdd = this.attackRateAdd
        local real speedAdd = this.speedAdd
        local UnitEffect targetEffect = this.targetEffect

        call this.deallocate()
        call durationTimer.Data.Integer.Remove(KEY)
        call durationTimer.Destroy()
        call target.Armor.Bonus.Subtract(armorAdd)
        call target.Attack.Speed.BonusA.Subtract(attackRateAdd)
        call target.Buffs.Remove(DUMMY_BUFF)
        call target.Data.Integer.Remove(KEY)
        call target.Event.Remove(DEATH_EVENT)
        call target.Movement.Speed.Subtract(speedAdd)
        call targetEffect.Destroy()
    endmethod

    static method Event_Death takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target.Data.Integer.Get(KEY)

        call this.Ending(this.durationTimer, target)
    endmethod

    static method EndingByTimer takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.Data.Integer.Get(KEY)

        call this.Ending(durationTimer, this.target)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        call target.Armor.Bonus.Add(armorAdd)
        call target.Attack.Speed.BonusA.Add(attackRateAdd)
        call target.Data.Integer.Set(KEY, this)
        call target.Movement.Speed.Add(speedAdd)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer durationTimer = Timer.Create()
        local Unit target = UNIT.Event.GetTarget()

        local integer level = caster.Abilities.GetLevel(THIS_SPELL)
        local thistype this = target.Data.Integer.Get(KEY)

        local real armorAdd = ARMOR_INCREMENT[level]
        local real attackRateAdd = ATTACK_RATE_INCREMENT[level]
        local real speedAdd = SPEED_INCREMENT[level]

        call Effect.Create(SPECIAL_EFFECT_PATH, target.Position.X.Get(), target.Position.Y.Get(), EffectLevel.NORMAL).Destroy()
        if (this != NULL) then
            call this.Ending(this.durationTimer, target)
        endif

        set this = thistype.allocate()
        set this.armorAdd = armorAdd
        set this.attackRateAdd = attackRateAdd
        set this.durationTimer = durationTimer
        set this.speedAdd = speedAdd
        set this.target = target
        set this.targetEffect = target.Effects.Create(TARGET_EFFECT_PATH, TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW)
        call durationTimer.Data.Integer.Set(KEY, this)
        call target.Armor.Bonus.Add(armorAdd)
        call target.Attack.Speed.BonusA.Add(attackRateAdd)
        call target.Buffs.Timed.Start(DUMMY_BUFF, level, DURATION[level])
        call target.Data.Integer.Set(KEY, this)
        call target.Event.Add(DEATH_EVENT)
        call target.Movement.Speed.Add(speedAdd)

        call durationTimer.Start(DURATION[level], false, function thistype.EndingByTimer)

        call caster.HealBySpell(target, HEAL[level] + caster.SpellPower.GetAll() * SPELL_POWER_MOD_FACTOR)
    endmethod

    static method Init takes nothing returns nothing
        call thistype.DUMMY_BUFF_Init()

        set THIS_SPELL = Spell.CreateFromSelf('A03Z')

        call THIS_SPELL.SetOrder(Order.DARK_CONVERSION)
        call THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)

        //! runtextmacro CreateHeroSpell("/", "THIS_SPELL", "Zo", "ReplaceableTextures\\CommandButtons\\BTNRacoon.blp", "", "Zodiac", "", "SPELL_TYPE_FIRST", "5")

        set ARMOR_INCREMENT[1] = 5.
        set ARMOR_INCREMENT[2] = 10.
        set ARMOR_INCREMENT[3] = 15.
        set ARMOR_INCREMENT[4] = 20.
        set ARMOR_INCREMENT[5] = 25.
        set ATTACK_RATE_INCREMENT[1] = 0.
        set ATTACK_RATE_INCREMENT[2] = 0.
        set ATTACK_RATE_INCREMENT[3] = 0.
        set ATTACK_RATE_INCREMENT[4] = 0.
        set ATTACK_RATE_INCREMENT[5] = 0.
        set DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        set DURATION[1] = 30.
        set DURATION[2] = 35.
        set DURATION[3] = 40.
        set DURATION[4] = 45.
        set DURATION[5] = 50.
        set HEAL[1] = 75.
        set HEAL[2] = 150.
        set HEAL[3] = 225.
        set HEAL[4] = 300.
        set HEAL[5] = 400.
        set SPEED_INCREMENT[1] = 0.25
        set SPEED_INCREMENT[2] = 0.35
        set SPEED_INCREMENT[3] = 0.4
        set SPEED_INCREMENT[4] = 0.45
        set SPEED_INCREMENT[5] = 0.5
        call THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct