//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("GhostSword", "GHOST_SWORD")
    static Event DAMAGE_EVENT
    static real array DAMAGE_FACTOR
    static string DEATH_EFFECT_ATTACH_POINT
    static string DEATH_EFFECT_PATH
    static Buff DUMMY_BUFF
    static real array DURATION
    static real array STOLEN_MANA
    static string SUMMON_EFFECT_ATTACH_POINT
    static string SUMMON_EFFECT_PATH
    static real SUMMON_OFFSET
    static UnitType array SUMMON_UNIT_TYPES
    static integer array SUMMONS_AMOUNT
    static string VICTIM_EFFECT_ATTACH_POINT
    static string VICTIM_EFFECT_PATH

    static Spell THIS_SPELL

    real damageFactor
    real stolenMana

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        //call Spot.CreateEffect(target.Position.X.Get(), target.Position.Y.Get(), thistype.DEATH_EFFECT_PATH, EffectLevel.LOW)
        call target.Effects.Create(thistype.DEATH_EFFECT_PATH, thistype.DEATH_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
        call target.Event.Remove(DAMAGE_EVENT)
    endmethod

    static method Event_Damage takes nothing returns nothing
        local Unit target = UNIT.Event.GetDamager()
        local Unit victim = UNIT.Event.GetTrigger()

        local thistype this = target

        local real stolenMana = Math.Min(victim.Mana.Get(), this.stolenMana)

        if (stolenMana > 0.) then
            call victim.Effects.Create(thistype.VICTIM_EFFECT_PATH, thistype.VICTIM_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
            call victim.Mana.Subtract(stolenMana)

            call target.DamageUnitBySpell(victim, stolenMana * this.damageFactor, true, false)
        endif
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        set this.damageFactor = thistype.DAMAGE_FACTOR[level]
        set this.stolenMana = thistype.STOLEN_MANA[level]

        //call Spot.CreateEffect(target.Position.X.Get(), target.Position.Y.Get(), thistype.SUMMON_EFFECT_PATH, EffectLevel.LOW).Destroy()
        call target.Effects.Create(thistype.SUMMON_EFFECT_PATH, thistype.SUMMON_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
        call target.Event.Add(DAMAGE_EVENT)
    endmethod

    static method StartSword takes User casterOwner, real x, real y, real angle, integer level returns nothing
        local Unit sword = Unit.CreateSummon(thistype.SUMMON_UNIT_TYPES[level], casterOwner, x, y, angle, thistype.DURATION[level])

        call sword.Buffs.Add(thistype.DUMMY_BUFF, level)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()

        local real angle = caster.Facing.Get()
        local User casterOwner = caster.Owner.Get()
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local integer iteration = thistype.SUMMONS_AMOUNT[level]
        local real targetX = casterX + thistype.SUMMON_OFFSET * Math.Cos(angle)
        local real targetY = casterY + thistype.SUMMON_OFFSET * Math.Sin(angle)

        loop
            call thistype.StartSword(casterOwner, targetX, targetY, angle, level)

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_GhostSword.j

        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Undead\\OrbOfDeath\\OrbOfDeathMissile.mdl", AttachPoint.WEAPON, EffectLevel.LOW)

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct