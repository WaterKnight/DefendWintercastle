//! runtextmacro BaseStruct("BurningSpirit2", "BURNING_SPIRIT_2")
    static real ATTACK_RATE_INCREMENT
    static real CRITICAL_CHANCE_INCREMENT
    static Buff DUMMY_BUFF
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dBSp", "Burning Spirit", "DUMMY_UNIT_ID", "Other\\FireTail\\FireTail.mdl")
    static real DURATION
    static real SPEED_RELATIVE_INCREMENT

    static Spell THIS_SPELL

    Unit caster
    integer level
    Unit target

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Attack.Speed.BonusA.Subtract(thistype.ATTACK_RATE_INCREMENT)
        call target.CriticalChance.Subtract(thistype.CRITICAL_CHANCE_INCREMENT)
        call target.Movement.Speed.RelativeA.Subtract(thistype.SPEED_RELATIVE_INCREMENT)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Attack.Speed.BonusA.Add(thistype.ATTACK_RATE_INCREMENT)
        call target.CriticalChance.Add(thistype.CRITICAL_CHANCE_INCREMENT)
        call target.Movement.Speed.RelativeA.Add(thistype.SPEED_RELATIVE_INCREMENT)
    endmethod

    static method Impact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this.target

        call this.deallocate()
        call dummyMissile.Destroy()

        call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Missile dummyMissile = Missile.Create()
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()
        local thistype this = thistype.allocate()

        set this.caster = caster
        set this.level = level
        set this.target = target

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(900.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToUnit.Start(target, false)
    endmethod

    static method Init takes nothing returns nothing
        //! import "obj_BurningSpiritMeteorite.j"

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "Bu2", "Burning Spirit", "1", "true", "ReplaceableTextures\\CommandButtons\\BTNIncinerate.blp", "This unit is heated up. Attack rate, movement speed and critical chance are increased.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDispel(true)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustSpecial.mdl", AttachPoint.HAND_LEFT, EffectLevel.LOW)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustSpecial.mdl", AttachPoint.HAND_RIGHT, EffectLevel.NORMAL)

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct