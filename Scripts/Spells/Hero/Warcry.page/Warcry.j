//! runtextmacro Folder("Warcry")
    //! runtextmacro Struct("Target")
    	UnitModSet dmgMod

    	eventMethod Event_BuffLose
	        local Unit target = params.Unit.GetTrigger()

	        local thistype this = target

	        local UnitModSet dmgMod = this.dmgMod

	        call target.ModSets.Remove(dmgMod)

	        call dmgMod.Destroy()
    	endmethod

	    eventMethod Event_BuffGain
	    	local Unit caster = params.Buff.GetData()
	        local integer level = params.Buff.GetLevel()
	        local Unit target = params.Unit.GetTrigger()
	
			local thistype this = target
	
	        local UnitModSet dmgMod = UnitModSet.Create()

	        set this.dmgMod = dmgMod
	
	        call dmgMod.RealMods.Add(UNIT.Damage.Bonus.STATE, thistype.DMG_INC[level] + Math.Max(0, thistype.DMG_INC_PER_VIGOR[level] * caster.Strength.Get()))
	
	        call target.ModSets.Add(dmgMod)
	    endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
        	call target.Buffs.Remove(thistype.DUMMY_BUFF)

            call target.Buffs.Timed.StartEx(thistype.DUMMY_BUFF, level, caster, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
	        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
	        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Warcry", "WARCRY")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    //! runtextmacro LinkToStruct("Warcry", "Target")

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

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

		call Spot.CreateEffect(casterX, casterY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

        local real colSize = caster.CollisionSize.Get(true)

        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level) + colSize

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(casterX, casterY, areaRange, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real attackDisableDuration = thistype.ATTACK_DISABLE_DURATION[level]
            local User casterOwner = caster.Owner.Get()
            local real damageLifeFactor = thistype.DAMAGE_LIFE_FACTOR[level]

            loop
                local real d = Math.DistanceByDeltas(target.Position.X.Get() - casterX, target.Position.Y.Get() - casterY)

                local real rangeFactor = Math.Shapes.LinearFromCoords(colSize, thistype.RANGE_FACTOR_CLOSE, areaRange, thistype.RANGE_FACTOR_FAR, d)

                if target.IsAllyOf(casterOwner) then
                    call thistype(NULL).Target.Start(caster, level, target)
                else
                    if not target.MagicImmunity.Try() then
                        call target.Buffs.Timed.Start(UNIT.Attack.NORMAL_BUFF, level, attackDisableDuration)

                        call caster.DamageUnitBySpell(target, target.Life.Get() * damageLifeFactor * rangeFactor, true, false)
                    endif
                endif

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Target.Init()
    endmethod
endstruct