//! runtextmacro Folder("EmphaticBite")
    //! runtextmacro Struct("Buff")
        real damageAdd

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            call target.Damage.Bonus.Subtract(this.damageAdd)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real damageAdd = thistype.DAMAGE_INCREMENT[level]
            local thistype this = target

            set this.damageAdd = damageAdd

            call target.Damage.Bonus.Add(damageAdd)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("EmphaticBite", "EMPHATIC_BITE")
    static real LENGTH
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")

    static Spell THIS_SPELL

    integer level
    Timer moveTimer
    real sourceX
    real sourceY
    Unit target
    real targetX
    real targetY
    SpellInstance whichInstance

    //! runtextmacro LinkToStruct("EmphaticBite", "Buff")

    static method Event_BuffLose takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        local thistype this = caster

        local Timer moveTimer = this.moveTimer
        local Unit target = this.target
        local SpellInstance whichInstance = this.whichInstance

        call moveTimer.Destroy()
        call whichInstance.Destroy()

        //call caster.Position.SetWithCollision(sourceX, sourceY)
        call caster.Stun.Subtract(UNIT.Stun.NONE_BUFF)
    endmethod

    static method Move takes nothing returns nothing
        local real angle
        local real d
        local real dealtDamage
        local real dX
        local real dY
        local real length = thistype.LENGTH
        local real newX
        local real newY
        local boolean reachesTarget
        local real spellPowerMod
        local real targetX
        local real targetY
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this
        local integer level = this.level
        local Unit target = this.target

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        if (target == NULL) then
            set targetX = this.targetX
            set targetY = this.targetY
        else
            set targetX = target.Position.X.Get()
            set targetY = target.Position.Y.Get()
        endif

        set dX = targetX - casterX
        set dY = targetY - casterY

        set d = Math.DistanceByDeltas(dX, dY)

        set angle = Math.AtanByDeltas(dY, dX)
        set reachesTarget = (d < length + HIT_RANGE)

        set newX = casterX + length * Math.Cos(angle)
        set newY = casterY + length * Math.Sin(angle)

        call caster.Position.X.Set(newX)
        call caster.Position.Y.Set(newY)

        if (reachesTarget) then
            set spellPowerMod = this.whichInstance.GetSpellPowerMod()

            call caster.Buffs.Remove(thistype.DUMMY_BUFF)

            if (target != NULL) then
                call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

                if (target.IsAllyOf(caster.Owner.Get())) then
                    call thistype(NULL).Buff.Start(level, target)
                else
                    call caster.DamageUnitBySpell(target, thistype.DAMAGE[level], true, true)

                    if (target.MagicImmunity.Try() == false) then
                        call target.Silence.AddTimed(thistype.SILENCE_DURATION, UNIT.Silence.NORMAL_BUFF)
                    endif
                endif

                call caster.HealBySpell(caster, thistype.HEAL[level] + spellPowerMod * thistype.HEAL_SPELL_POWER_MOD_FACTOR[level])
            endif
        endif
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Timer moveTimer = Timer.Create()
        local Unit caster = UNIT.Event.GetTrigger()
        local Unit target = Unit.TEMP

        local thistype this = caster
        local SpellInstance whichInstance = SpellInstance.Create(caster, thistype.THIS_SPELL)

        set this.level = level
        set this.moveTimer = moveTimer
        set this.sourceX = caster.Position.X.Get()
        set this.sourceY = caster.Position.Y.Get()
        set this.target = target
        set this.whichInstance = whichInstance
        call moveTimer.SetData(this)

        call caster.Animation.Set(Animation.ATTACK)
        call caster.Animation.Queue(Animation.STAND)
        call caster.Stun.Add(UNIT.Stun.NONE_BUFF)

        call moveTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        set Unit.TEMP = UNIT.Event.GetTarget()

        call UNIT.Event.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod
    
    static method Init takes nothing returns nothing
        set thistype.LENGTH = thistype.SPEED * thistype.UPDATE_TIME
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Buff.Init()
    endmethod
endstruct