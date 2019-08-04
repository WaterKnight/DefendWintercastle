//! runtextmacro Folder("MagicBottle")
    //! runtextmacro Struct("Buff")
        static real array ATTACK_SPEED_INCREMENT
        static Buff DUMMY_BUFF
        static real array DURATION
        static real array MANA_INCREMENT
        static real array SPELL_POWER_INCREMENT
        static string TARGET_EFFECT_ATTACH_POINT
        static string TARGET_EFFECT_PATH

        //! import "Spells\Artifacts\MagicBottle\Buff\obj.j"

        real attackSpeedAdd
        real spellPowerAdd

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local real attackSpeedAdd = this.attackSpeedAdd
            local real spellPowerAdd = this.spellPowerAdd

            call target.Attack.Speed.BonusA.Subtract(attackSpeedAdd)
            call target.SpellPower.Bonus.Subtract(spellPowerAdd)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real attackSpeedAdd = thistype.ATTACK_SPEED_INCREMENT[level]
            local real spellPowerAdd = thistype.SPELL_POWER_INCREMENT[level]
            local thistype this = target

            set this.attackSpeedAdd = attackSpeedAdd
            set this.spellPowerAdd = spellPowerAdd

            call target.Attack.Speed.BonusA.Add(attackSpeedAdd)
            call target.SpellPower.Bonus.Add(spellPowerAdd)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local real manaAdd = thistype.MANA_INCREMENT[level]

            call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

            call caster.HealManaBySpell(target, manaAdd)

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "CrM", "Spell Potion", "1", "true", "ReplaceableTextures\\CommandButtons\\BTNMinorRejuvPotion.blp", "Increased spell power and attack speed.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.SetLostOnDispel(true)
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Human\\MagicSentry\\MagicSentryCaster.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("MagicBottle", "MAGIC_BOTTLE")
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dCMP", "Magic Bottle", "DUMMY_UNIT_ID", "Abilities\\Weapons\\DruidoftheTalonMissile\\DruidoftheTalonMissile.mdl")
    static real array STAMINA_INCREMENT
    static real STAMINA_RELATIVE_INCREMENT

    static Spell THIS_SPELL

    //! import "Spells\Artifacts\MagicBottle\obj.j"

    Unit caster
    integer level
    Unit target

    //! runtextmacro LinkToStruct("MagicBottle", "Buff")

    static method Impact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this.target

        call this.deallocate()
        call dummyMissile.Destroy()

        call thistype(NULL).Buff.Start(caster, level, target)
    endmethod

    static method StartTarget takes Unit caster, integer level, Unit target returns nothing
        local Missile dummyMissile = Missile.Create()
        local DummyUnit dummyUnit
        local thistype this = thistype.allocate()

        set this.caster = caster
        set this.level = level
        set this.target = target

        call dummyMissile.Arc.SetByPerc(0.06)
        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(900.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToUnit.Start(target, false)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()

        if (caster != target) then
            call thistype.StartTarget(caster, level, target)
        endif

        call thistype(NULL).Buff.Start(caster, level, caster)

        call target.Stamina.Add(target.MaxStamina.GetAll() * thistype.STAMINA_RELATIVE_INCREMENT + thistype.STAMINA_INCREMENT[level])
    endmethod

    static method Init takes nothing returns nothing
        //! runtextmacro Spell_Create("/", "THIS_SPELL", "AMaB", "Magic Bottle")

        //! runtextmacro Spell_SetTypes("/", "NORMAL", "ARTIFACT")

        //! runtextmacro Spell_SetAnimation("/", "spell")
        //! runtextmacro Spell_SetCooldown5("/", "16.", "16.", "16.", "16.", "16.")
        //! runtextmacro Spell_SetData5("/", "STAMINA_INCREMENT", "staminaIncrement", "25.", "35.", "45.", "55.", "60.")
        //! runtextmacro Spell_SetData("/", "STAMINA_RELATIVE_INCREMENT", "staminaRelativeIncrement", "0.05")
        //! runtextmacro Spell_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNPotionOfOmniscience.blp")
        //! runtextmacro Spell_SetManaCost5("/", "55", "75", "95", "115", "125")
        //! runtextmacro Spell_SetOrder("/", "sanctuary")
        //! runtextmacro Spell_SetRange5("/", "700.", "700.", "700.", "700.", "700.")
        //! runtextmacro Spell_SetTargets("/", "air,friend,ground,invulnerable,organic,self,vulnerable")
        //! runtextmacro Spell_SetTargetType("/", "UNIT")
        //! runtextmacro Spell_SetUberTooltipLv("/", "1", "A stimulating shake is thrown to an allied unit, temporarily boosting the target's spellpower by 15 and restoring 90 mana.|nLasts 9 seconds.")
        //! runtextmacro Spell_SetUberTooltipLv("/", "2", "A stimulating shake is thrown to an allied unit, temporarily boosting the target's spellpower by 25 and restoring 120 mana.|nLasts 9 seconds.")
        //! runtextmacro Spell_SetUberTooltipLv("/", "3", "A stimulating shake is thrown to an allied unit, temporarily boosting the target's spellpower by 35 and restoring 150 mana.|nLasts 9 seconds.")
        //! runtextmacro Spell_SetUberTooltipLv("/", "4", "A stimulating shake is thrown to an allied unit, temporarily boosting the target's spellpower by 45 and restoring 180 mana.|nLasts 9 seconds.")
        //! runtextmacro Spell_SetUberTooltipLv("/", "5", "A stimulating shake is thrown to an allied unit, temporarily boosting the target's spellpower by 55 and restoring 210 mana.|nLasts 9 seconds.")

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Buff.Init()
    endmethod
endstruct