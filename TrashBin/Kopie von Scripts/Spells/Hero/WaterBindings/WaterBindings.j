//! runtextmacro Spell_OpenScope("/")

//! runtextmacro Folder("WaterBindings")
    //! runtextmacro Spell_OpenScope("/")

    //! runtextmacro Struct("Lariat")
        static real array DAMAGE_PER_INTERVAL
        static real array DAMAGE_PER_SECOND
        static Buff DUMMY_BUFF
        static string EFFECT_LIGHTNING_PATH
        static real array INTERVAL
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        static Spell THIS_SPELL

        real damage
        Lightning effectLightning
        Timer intervalTimer
        Unit target

        static method Interval takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()

            local Unit caster = this

            call caster.DamageUnitBySpell(target, this.damage, true, false)
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit caster
            local Unit target = UNIT.Event.GetTrigger()
            local thistype this

            local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

            call target.Attack.Add()
            call target.Movement.Add()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                set caster = this

                call caster.Stop()

                set iteration = iteration - 1
            endloop
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            call target.Attack.Subtract()
            call target.Movement.Subtract()
        endmethod

        static method Event_EndCast takes nothing returns nothing
            local Unit caster = UNIT.Event.GetTrigger()
            local boolean success = SPELL.Event.IsChannelComplete()

            local thistype this = caster

            local Lightning effectLightning = this.effectLightning
            local Timer intervalTimer = this.intervalTimer
            local Unit target = this.target

            call effectLightning.Destroy()
            call intervalTimer.Destroy()
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Buffs.Remove(thistype.DUMMY_BUFF)
            endif

            if (success) then
                call caster.Order.UnitTarget(Order.ATTACK, target)
            endif
        endmethod

        static method Event_SpellEffect takes nothing returns nothing
            local Unit caster = UNIT.Event.GetTrigger()
            local Lightning effectLightning = Lightning.Create(thistype.EFFECT_LIGHTNING_PATH)
            local Timer intervalTimer = Timer.Create()
            local integer level = SPELL.Event.GetLevel()
            local Unit target = UNIT.Event.GetTarget()

            local thistype this = caster

            set this.damage = thistype.DAMAGE_PER_INTERVAL[level]
            set this.effectLightning = effectLightning
            set this.intervalTimer = intervalTimer
            set this.target = target
            call intervalTimer.SetData(this)
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Buffs.Add(thistype.DUMMY_BUFF, 1)
            endif

            call effectLightning.FromUnitToUnit.Start(caster, target)

            call intervalTimer.Start(thistype.INTERVAL[level], true, function thistype.Interval)
        endmethod

        static method Init takes nothing returns nothing
            local integer iteration

            //! import obj_WaterBindings_Lariat.j

            call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
            call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))

            set iteration = thistype.THIS_SPELL.GetLevelsAmount()

            loop
                set thistype.DAMAGE_PER_INTERVAL[iteration] = thistype.DAMAGE_PER_SECOND[iteration] * thistype.INTERVAL[iteration]

                set iteration = iteration - 1
                exitwhen (iteration < 1)
            endloop

                set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.SetLostOnDeath(true)

            //! runtextmacro Spell_Finalize("/")
        endmethod
    endstruct

    //! runtextmacro Struct("Summon")
        static real array DURATION
        static real OFFSET
        static UnitType array THIS_UNIT_TYPES

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local User casterOwner = caster.Owner.Get()
            local real casterX = caster.Position.X.Get()
            local real casterY = caster.Position.Y.Get()
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            local real angle = caster.CastAngle(targetX - casterX, targetY - casterY)

            local Unit summon = Unit.CreateSummon(thistype.THIS_UNIT_TYPES[level], casterOwner, casterX + thistype.OFFSET * Math.Cos(angle), casterY + thistype.OFFSET * Math.Sin(angle), angle, thistype.DURATION[level])

            call summon.Abilities.AddWithLevel(WATER_BINDINGS.Lariat.THIS_SPELL, level)

            call casterOwner.EnableAbility(WATER_BINDINGS.Lariat.THIS_SPELL, true)

            call summon.Order.UnitTargetBySpell(WATER_BINDINGS.Lariat.THIS_SPELL, target)

            call casterOwner.EnableAbility(WATER_BINDINGS.Lariat.THIS_SPELL, false)
        endmethod

        static method InitUnitTypes takes nothing returns nothing
            //1
            //! runtextmacro Unit_Create("/", "THIS_UNIT_TYPES[1]", "WB1", "Water Elemental (Level 1)", "false", "DEFENDER", "0.9")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "1.", "Ethereal")
            //! runtextmacro Unit_SetAttack("/", "MISSILE", "1.6", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\WaterElementalMissile\\WaterElementalMissile.mdl", "1300.", "0.15")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "PIERCE", "14", "2", "3", "0.4")
            //! runtextmacro Unit_SetDeathTime("/", "1.5")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSummonWaterElemental.blp")
            //! runtextmacro Unit_SetLife("/", "300.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\human\\WaterElemental\\WaterElemental.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "230.", "0.5", "2", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "0.9", "1.6")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "200.", "200.", "80.", "80.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "WaterElemental")
            //! runtextmacro Unit_SetSpellPower("/", "30.")
            //! runtextmacro Unit_SetVertexColor("/", "255", "255", "255", "255")

            //! runtextmacro Unit_Finalize("/")

            //2
            //! runtextmacro Unit_Create("/", "THIS_UNIT_TYPES[2]", "WB2", "Water Elemental (Level 2)", "false", "DEFENDER", "0.9")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "1.", "Ethereal")
            //! runtextmacro Unit_SetAttack("/", "MISSILE", "1.6", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\WaterElementalMissile\\WaterElementalMissile.mdl", "1300.", "0.15")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "PIERCE", "18", "2", "3", "0.4")
            //! runtextmacro Unit_SetDeathTime("/", "1.5")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSummonWaterElemental.blp")
            //! runtextmacro Unit_SetLife("/", "425.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\human\\WaterElemental\\WaterElemental.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "230.", "0.5", "2", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "0.9", "1.6")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "200.", "200.", "80.", "80.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "WaterElemental")
            //! runtextmacro Unit_SetSpellPower("/", "30.")
            //! runtextmacro Unit_SetVertexColor("/", "255", "255", "255", "255")

            //! runtextmacro Unit_Finalize("/")

            //3
            //! runtextmacro Unit_Create("/", "THIS_UNIT_TYPES[3]", "WB3", "Water Elemental (Level 3)", "false", "DEFENDER", "0.9")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Ethereal")
            //! runtextmacro Unit_SetAttack("/", "MISSILE", "1.6", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\WaterElementalMissile\\WaterElementalMissile.mdl", "1300.", "0.15")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "PIERCE", "22", "3", "3", "0.4")
            //! runtextmacro Unit_SetDeathTime("/", "1.5")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSummonWaterElemental.blp")
            //! runtextmacro Unit_SetLife("/", "550.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\human\\WaterElemental\\WaterElemental.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "230.", "0.5", "2", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "0.9", "1.6")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "200.", "200.", "80.", "80.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "WaterElemental")
            //! runtextmacro Unit_SetSpellPower("/", "30.")
            //! runtextmacro Unit_SetVertexColor("/", "255", "255", "255", "255")

            //! runtextmacro Unit_Finalize("/")

            //4
            //! runtextmacro Unit_Create("/", "THIS_UNIT_TYPES[4]", "WB4", "Water Elemental (Level 4)", "false", "DEFENDER", "0.9")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Ethereal")
            //! runtextmacro Unit_SetAttack("/", "MISSILE", "1.6", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\WaterElementalMissile\\WaterElementalMissile.mdl", "1300.", "0.15")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "PIERCE", "26", "3", "3", "0.4")
            //! runtextmacro Unit_SetDeathTime("/", "1.5")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSummonWaterElemental.blp")
            //! runtextmacro Unit_SetLife("/", "675.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\human\\WaterElemental\\WaterElemental.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "230.", "0.5", "2", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "0.9", "1.6")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "200.", "200.", "80.", "80.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "WaterElemental")
            //! runtextmacro Unit_SetSpellPower("/", "30.")
            //! runtextmacro Unit_SetVertexColor("/", "255", "255", "255", "255")

            //! runtextmacro Unit_Finalize("/")

            //5
            //! runtextmacro Unit_Create("/", "THIS_UNIT_TYPES[5]", "WB5", "Water Elemental (Level 5)", "false", "DEFENDER", "0.9")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "3.", "Ethereal")
            //! runtextmacro Unit_SetAttack("/", "MISSILE", "1.6", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\WaterElementalMissile\\WaterElementalMissile.mdl", "1300.", "0.15")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "PIERCE", "30", "3", "4", "0.4")
            //! runtextmacro Unit_SetDeathTime("/", "1.5")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSummonWaterElemental.blp")
            //! runtextmacro Unit_SetLife("/", "800.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\human\\WaterElemental\\WaterElemental.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "230.", "0.5", "2", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "0.9", "1.6")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "200.", "200.", "80.", "80.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "WaterElemental")
            //! runtextmacro Unit_SetSpellPower("/", "30.")
            //! runtextmacro Unit_SetVertexColor("/", "255", "255", "255", "255")

            //! runtextmacro Unit_Finalize("/")
        endmethod

        static method Init takes nothing returns nothing
            //! runtextmacro Spell_SetData5("/", "DURATION", "duration", "25.", "25.", "25.", "25.", "25.")
            //! runtextmacro Spell_SetData("/", "OFFSET", "offset", "75.")

            call thistype.InitUnitTypes()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("WaterBindings", "WATER_BINDINGS")
    static Spell THIS_SPELL

    //! runtextmacro LinkToStruct("WaterBindings", "Lariat")
    //! runtextmacro LinkToStruct("WaterBindings", "Summon")

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()

        call thistype(NULL).Summon.Start(caster, level, target)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_WaterBindings.j

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Summon.Init()

        //! runtextmacro Spell_Finalize("/")

        call thistype(NULL).Lariat.Init()
    endmethod
endstruct