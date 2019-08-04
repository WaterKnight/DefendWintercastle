//! runtextmacro Folder("BatSwarm")
    //! runtextmacro Struct("Missile")
        eventMethod Impact
            local Missile dummyMissile = params.Missile.GetTrigger()

            local SpellInstance whichInstance = dummyMissile.GetData()

            call dummyMissile.Destroy()

            call BatSwarm.Start(whichInstance)

            call whichInstance.Refs.Subtract()
        endmethod

        static method Start takes SpellInstance whichInstance returns nothing
            local Missile dummyMissile = Missile.Create()

            call whichInstance.Refs.Add()

            call dummyMissile.Arc.SetByPerc(0.4)
            call dummyMissile.CollisionSize.Set(32.)
            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(whichInstance)
            call dummyMissile.Speed.Set(900.)
            call dummyMissile.Position.SetFromUnit(whichInstance.GetCaster())

            call dummyMissile.GoToUnit.Start(whichInstance.GetTargetUnit(), null)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("BatSwarm", "BAT_SWARM")
    static BoolExpr TARGET_FILTER

    Unit caster
    real damage
    real heal
    Unit target

    //! runtextmacro LinkToStruct("BatSwarm", "Missile")

    eventMethod ImpactTarget
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local real heal = this.heal
        local Unit target = this.target

        call this.deallocate()
        call dummyMissile.Destroy()

        call caster.HealBySpell(target, heal)
    endmethod

    eventMethod ImpactEnemy
        local Missile dummyMissile = params.Missile.GetTrigger()
        local Unit enemy = params.Unit.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local Unit target = this.target

        call dummyMissile.Destroy()

        if not enemy.Classes.Contains(UnitClass.DEAD) then
            call enemy.Effects.Create(thistype.ENEMY_EFFECT_PATH, thistype.ENEMY_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

            call caster.DamageUnitBySpell(enemy, this.damage, false, false)
        endif

        if not target.IsAllyOf(caster.Owner.Get()) then
            call this.deallocate()

            return
        endif

        set dummyMissile = Missile.Create()

        call dummyMissile.Arc.SetByPerc(0.06)
        call dummyMissile.CollisionSize.Set(8.)
        call dummyMissile.DummyUnit.Create(thistype.TARGET_DUMMY_UNIT_ID, 1.5)
        call dummyMissile.Impact.SetAction(function thistype.ImpactTarget)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(500.)
        call dummyMissile.Position.SetFromUnit(enemy)

        call dummyMissile.GoToUnit.Start(caster, null)
    endmethod

    condMethod TargetConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if UnitList.TEMP.Contains(target) then
            return false
        endif
        if (target == Unit.TEMP) then
            return false
        endif
        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if target.Classes.Contains(UnitClass.WARD) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    static method Start takes SpellInstance whichInstance returns nothing
        local Unit caster = whichInstance.GetCaster()
        local integer level = whichInstance.GetLevel()
        local Unit target = whichInstance.GetTargetUnit()

        local User casterOwner = caster.Owner.Get()

    	local Sound shieldSound = Sound.CreateFromType(thistype.SHIELD_SOUND)

		call shieldSound.AttachToUnitAndPlay(target)

		call shieldSound.Destroy(true)

        if target.IsAllyOf(casterOwner) then
            call target.Buffs.Timed.Start(UNIT.MagicImmunity.SpellShield.NORMAL_BUFF, level, thistype.SPELL_SHIELD_DURATION[level])
        else
            call target.Buffs.Timed.Start(thistype.ECLIPSE_BUFF, level, thistype.ECLIPSE_DURATION[level])
        endif

		local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()
		local UnitList enemyGroup = UnitList.Create()
		local integer iteration = thistype.MAX_ENEMIES_AMOUNT[level]

        loop
            exitwhen (iteration < 1)

            set User.TEMP = casterOwner
			set UnitList.TEMP = enemyGroup
            set Unit.TEMP = target

            local Unit enemy = GROUP.EnumUnits.InRange.WithCollision.GetNearest(targetX, targetY, areaRange, thistype.TARGET_FILTER)

            exitwhen (enemy == NULL)

            local thistype this = thistype.allocate()

			local Missile dummyMissile = Missile.Create()

            set this.caster = caster
            set this.damage = thistype.DAMAGE[level]
            set this.heal = thistype.HEAL[level]
            set this.target = target
            call enemyGroup.Add(enemy)

            call dummyMissile.Arc.SetByPerc(0.06)
            call dummyMissile.CollisionSize.Set(8.)
            call dummyMissile.DummyUnit.Create(thistype.ENEMY_DUMMY_UNIT_ID, 0.5).PlayerColor.Set(casterOwner.GetColor())
            call dummyMissile.Impact.SetAction(function thistype.ImpactEnemy)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(500.)
            call dummyMissile.Position.SetFromUnit(target)

            call dummyMissile.GoToUnit.Start(enemy, null)

            set iteration = iteration - 1
        endloop

        call enemyGroup.Destroy()
    endmethod

    eventMethod Event_SpellEffect
    	local SpellInstance whichInstance = params.SpellInstance.GetTrigger()

		if (whichInstance.GetTargetUnit() == whichInstance.GetCaster()) then
            call thistype.Start(whichInstance)
        else
            call thistype(NULL).Missile.Start(whichInstance)
        endif
    endmethod

    initMethod Init of Spells_Artifacts
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call UNIT.Eclipse.NORMAL_BUFF.Variants.Add(thistype.ECLIPSE_BUFF)
    endmethod
endstruct