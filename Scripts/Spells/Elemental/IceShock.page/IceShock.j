//! runtextmacro BaseStruct("IceShock", "ICE_SHOCK")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif
        if target.MagicImmunity.Try() then
            return false
        endif

        return true
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()
 
 		call Spot.CreateEffect(targetX, targetY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()
 
        local User casterOwner = caster.Owner.Get()

        set User.TEMP = casterOwner

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

		call thistype.ENUM_GROUP.RemoveUnit(target)

		local real duration

    	if target.Classes.Contains(UnitClass.HERO) then
    		set duration = thistype.FROST_HERO_DURATION[level]
    	else
            set duration = thistype.FROST_DURATION[level]
    	endif

		call target.Buffs.Timed.Start(thistype.FROST_BUFF, level, duration)

		call caster.DamageUnitBySpell(target, thistype.PRIMARY_DAMAGE[level], true, false)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = thistype.SECONDARY_DAMAGE[level]

            loop
            	if target.Classes.Contains(UnitClass.HERO) then
            		set duration = thistype.COLDNESS_HERO_DURATION[level]
            	else
                    set duration = thistype.COLDNESS_DURATION[level]
            	endif
            	
            	call target.Buffs.Timed.Start(thistype.COLDNESS_BUFF, level, duration)
            	
                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    initMethod Init of Spells_Elemental
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        
        call UNIT.Cold.NORMAL_BUFF.Variants.Add(thistype.COLDNESS_BUFF)
        call UNIT.Frost.NORMAL_BUFF.Variants.Add(thistype.FROST_BUFF)
    endmethod
endstruct