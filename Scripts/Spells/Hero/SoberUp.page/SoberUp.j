//! runtextmacro Folder("SoberUp")
    //! runtextmacro Struct("HealMissile")
        integer amount
        Unit caster
        integer level

        eventMethod Impact
            local Missile dummyMissile = params.Missile.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local integer amount = this.amount
            local Unit caster = this.caster
            local integer level = this.level

			call this.deallocate_demount()
            call dummyMissile.Destroy()

            call SoberUp.DoHeal(caster, level, amount)
        endmethod

        static method Start takes Unit caster, integer level, Unit source, integer amount returns nothing
			local Missile dummyMissile = Missile.Create()

			local thistype this = thistype.allocate_mount(dummyMissile)

            set this.amount = amount
            set this.caster = caster
            set this.level = level

            call dummyMissile.Arc.SetByPerc(0.4)
            call dummyMissile.CollisionSize.Set(32.)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(600.)
            call dummyMissile.Position.SetFromUnit(source)

            call dummyMissile.GoToUnit.Start(caster, null)

            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1 + (amount * 0.2))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SoberUp", "SOBER_UP")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

	integer level
	real x
	real y

    //! runtextmacro LinkToStruct("SoberUp", "HealMissile")

    static method DoHeal takes Unit caster, integer level, integer amount returns nothing
        call caster.Effects.Create(thistype.HEAL_EFFECT_PATH, thistype.HEAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call caster.HealBySpell(caster, thistype.HEAL_PER_BUFF[level] * amount)
    endmethod

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif

        return true
    endmethod

	eventMethod Event_EndCast
        local Unit caster = params.Unit.GetTrigger()
        local boolean success = params.Spell.IsChannelComplete()
		
		local thistype this = caster

		local integer level = this.level
		local real x = this.x
		local real y = this.y
		
		local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)

		if not success then
			call caster.Abilities.Refresh(thistype.THIS_SPELL)
			call caster.Mana.Add(thistype.THIS_SPELL.GetManaCost(level))
			
			return
		endif

        call SpotEffectWithSize.Create(x, y, thistype.SHOCKWAVE_EFFECT_PATH, EffectLevel.NORMAL, areaRange / thistype.SHOCKWAVE_EFFECT_SCALE_SIZE).Destroy()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, areaRange, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local User casterOwner = caster.Owner.Get()
            local real damagePerBuff = thistype.DAMAGE_PER_BUFF[level]

            loop
            	local integer amount
            	
                if target.IsAllyOf(casterOwner) then
                    set amount = target.Buffs.Dispel(true, false, true)

                    if (amount > 0) then
                        call thistype(NULL).HealMissile.Start(caster, level, target, amount)
                    endif
                else
                    call target.Effects.Create(thistype.DAMAGE_EFFECT_PATH, thistype.DAMAGE_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

					local real banishDuration

					if target.Classes.Contains(UnitClass.HERO) then
						set banishDuration = thistype.BANISH_HERO_DURATION[level]
					else
						set banishDuration = thistype.BANISH_DURATION[level]
					endif

                    call target.Buffs.Timed.Start(thistype.BANISH_BUFF, level, banishDuration)

                    set amount = target.Buffs.CountVisibleEx(true, false)

                    if (amount > 0) then
                        call caster.DamageUnitBySpell(target, amount * damagePerBuff, true, false)
                    endif
                endif

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
	endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger() 
        local integer level = params.Spell.GetLevel()

		local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local real x = caster.Position.X.Get()
        local real y = caster.Position.Y.Get()

		call SpotEffectWithSize.Create(x, y, thistype.EXPLOSION_EFFECT_PATH, EffectLevel.LOW, areaRange / thistype.EXPLOSION_EFFECT_SCALE_SIZE).Destroy()
		
		local thistype this = caster

		set this.level = level
		set this.x = x
		set this.y = y
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call UNIT.Banish.NORMAL_BUFF.Variants.Add(thistype.BANISH_BUFF)
    endmethod
endstruct