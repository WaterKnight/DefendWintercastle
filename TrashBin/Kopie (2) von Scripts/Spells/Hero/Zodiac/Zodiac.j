//! runtextmacro Folder("Zodiac")
    //! runtextmacro Struct("Missile")
        //! runtextmacro DummyUnit_CreateSimpleType("/", "dZod", "Zodiac", "DUMMY_UNIT_ID", "units\\nightelf\\OwlSCOUT\\OwlSCOUT.mdl")

        Unit caster
        integer level

        static method Impact takes nothing returns nothing
            local Missile dummyMissile = MISSILE.Event.GetTrigger()
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local Unit caster = this.caster
            local integer level = this.level

            call this.deallocate()
            call dummyMissile.Destroy()

            call Zodiac.Start(caster, level, target)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local Missile dummyMissile = Missile.Create()
            local thistype this = thistype.allocate()

            set this.caster = caster
            set this.level = level

            call dummyMissile.Arc.SetByPerc(0.4)
            call dummyMissile.CollisionSize.Set(32.)
            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(900.)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToUnit.Start(target, false)
        endmethod
    endstruct

    //! runtextmacro Struct("SpeedBuff")
        static Buff DUMMY_BUFF
        static real array SPEED_RELATIVE_INCREMENT

        //! import "Spells\Hero\Zodiac\SpeedBuff\obj.j"

        real speedAdd

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local real speedAdd = this.speedAdd

            call target.LifeRegeneration.Relative.Subtract(Zodiac.LIFE_REGEN_ADD)
            call target.Movement.Speed.RelativeA.Subtract(speedAdd)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real speedAdd = thistype.SPEED_RELATIVE_INCREMENT[level]
            local thistype this = target

            set this.speedAdd = speedAdd

            call target.LifeRegeneration.Relative.Add(Zodiac.LIFE_REGEN_ADD)
            call target.Movement.Speed.RelativeA.Add(speedAdd)
        endmethod

        static method Init takes nothing returns nothing
            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "ZBS", "Zodiac", "5", "false", "ReplaceableTextures\\CommandButtons\\BTNRacoon.blp", "You got the mobility of a rabbit.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDispel(true)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Units\\NightElf\\Owl\\Owl.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Zodiac", "ZODIAC")
    static real array ARMOR_INCREMENT
    static Buff DUMMY_BUFF
    static real array DURATION
    static real array HEAL
    static real HEAL_SPELL_POWER_MOD_FACTOR
    static real LIFE_REGEN_ADD
    static string SPECIAL_EFFECT_PATH

    static Spell THIS_SPELL

    //! import "Spells\Hero\Zodiac\obj.j"

    real armorAdd

    //! runtextmacro LinkToStruct("Zodiac", "Missile")
    //! runtextmacro LinkToStruct("Zodiac", "SpeedBuff")

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local real armorAdd = this.armorAdd

        call target.Armor.Bonus.Subtract(armorAdd)
        call target.LifeRegeneration.Relative.Subtract(thistype.LIFE_REGEN_ADD)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local real armorAdd = thistype.ARMOR_INCREMENT[level]
        local thistype this = target

        set this.armorAdd = armorAdd

        call target.Armor.Bonus.Add(armorAdd)
        call target.LifeRegeneration.Relative.Add(thistype.LIFE_REGEN_ADD)
    endmethod

    static method Start takes Unit caster, integer level, Unit target returns nothing
        call Spot.CreateEffect(target.Position.X.Get(), target.Position.Y.Get(), thistype.SPECIAL_EFFECT_PATH, EffectLevel.NORMAL).Destroy()

        call target.Buffs.Timed.Start(thistype(NULL).DUMMY_BUFF, level, thistype.DURATION[level])

        call caster.HealBySpell(target, thistype.HEAL[level] + caster.SpellPower.GetAll() * thistype.HEAL_SPELL_POWER_MOD_FACTOR)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()

        if (caster == target) then
            call target.Buffs.Timed.Start(thistype(NULL).SpeedBuff.DUMMY_BUFF, level, thistype.DURATION[level])
        else
            call thistype(NULL).Missile.Start(caster, level, target)
        endif
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "ZoB", "Zodiac", "5", "false", "ReplaceableTextures\\CommandButtons\\BTNRacoon.blp", "Animal friends of nature protect this unit.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDispel(true)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Units\\NightElf\\Owl\\Owl.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)

        call thistype(NULL).SpeedBuff.Init()
    endmethod
endstruct