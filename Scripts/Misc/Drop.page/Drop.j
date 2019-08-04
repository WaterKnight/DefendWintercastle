//! runtextmacro BaseStruct("Drop", "DROP")
    static constant real AREA_RANGE = 1000.
    static Group ENUM_GROUP
    static real SUPPLY_FACTOR = 1.
    static BoolExpr TARGET_FILTER

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Owner.Get().Hero.Get() != target) then
            return false
        endif

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if (target.Owner.Get().Team.Get() != Team.DEFENDERS) then
            return false
        endif

        return true
    endmethod

    //! runtextmacro GetKeyArray("TAG_KEY_ARRAY")

    static method AddExp takes Unit target, real amount returns nothing
        local TextTag tag = target.AddJumpingTextTagWithValue(TAG_KEY_ARRAY + target, amount)

        call tag.Text.Set(String.Color.Do(Char.PLUS + Integer.ToString(Real.ToInt(tag.GetValue())), "ff8b008b"), 0.02)

        call target.Exp.Add(amount)
    endmethod

	//! runtextmacro GetKeyArray("HEAL_TAG_KEY_ARRAY")

    static method DoHeal takes Unit target, real val returns nothing
		if target.Classes.Contains(UnitClass.DEAD) then
			return
		endif
		if target.Classes.Contains(UnitClass.MECHANICAL) then
			return
		endif
		if target.Classes.Contains(UnitClass.STRUCTURE) then
			return
		endif
		if target.Classes.Contains(UnitClass.WARD) then
			return
		endif

        if (val <= 0) then
            return
        endif

		call target.Effects.Create(thistype.HEAL_EFFECT_PATH, thistype.HEAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        local TextTag tag = target.AddJumpingTextTagWithValue(HEAL_TAG_KEY_ARRAY + target, val)

        call tag.Text.Set(String.Color.Do(Char.PLUS + Integer.ToString(Real.ToInt(tag.GetValue())), "ffd45e19"), 0.02)

        call target.Life.Add(val)
        call target.Mana.Add(val)
        call target.Stamina.Add(val)
    endmethod

    eventMethod Exp_Event_Death
        local Unit killer = params.Unit.GetKiller()

        if (killer == NULL) then
            return
        endif

        local User killerOwner = killer.Owner.Get()
        local Unit whichUnit = params.Unit.GetTrigger()

        if whichUnit.IsAllyOf(killerOwner) then
            return
        endif
        if (killerOwner.Team.Get() != Team.DEFENDERS) then
            return
        endif

		local real amount = whichUnit.Type.Get().Drop.Exp.Get()

		call thistype.DoHeal(killer, amount * 0.25)

		set killer = killerOwner.Hero.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(whichUnit.Position.X.Get(), whichUnit.Position.Y.Get(), thistype.AREA_RANGE, thistype.TARGET_FILTER)

		local integer pickedAmount = thistype.ENUM_GROUP.Count()

		local real killerBonus

		if (killer == NULL) then
			set killerBonus = 0.
		else
            set killerBonus = 0.4 - 0.05 * pickedAmount
        endif

		local real shared

		if (pickedAmount <= 0) then
			set shared = 0.
		else
        	set shared = (1. - killerBonus) / pickedAmount
        endif

		if (killer != NULL) then
			if thistype.ENUM_GROUP.ContainsUnit(killer) then
				call thistype.AddExp(killer, (shared + killerBonus) * amount)
				
				call thistype.ENUM_GROUP.RemoveUnit(killer)
			else
				call thistype.AddExp(killer, killerBonus * amount)
			endif
		endif

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call thistype.AddExp(target, shared * amount)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method GetDrop takes Unit killer, Unit whichUnit returns integer
        return Real.ToInt(whichUnit.Drop.Supply.Get())
    endmethod

    eventMethod Supply_Event_Death
        local Unit killer = params.Unit.GetKiller()
        local Unit whichUnit = params.Unit.GetTrigger()

        if (killer == NULL) then
            return
        endif

        if (whichUnit.Owner.Get().Team.Get() != Team.ATTACKERS) then
            return
        endif

        local User killerOwner = killer.Owner.Get()

        if (killerOwner.Team.Get() != Team.DEFENDERS) then
            return
        endif
        if (killerOwner == User.CASTLE) then
            return
        endif

        local integer drop = Real.ToInt(thistype.GetDrop(killer, whichUnit) * thistype.SUPPLY_FACTOR)

        if (drop <= 0) then
            return
        endif

        call killerOwner.State.Add(PLAYER_STATE_RESOURCE_GOLD, drop)
        if (drop > whichUnit.Type.Get().Drop.Supply.Get()) then
            call whichUnit.AddJumpingTextTagEx(String.Color.Do(Char.PLUS + Integer.ToString(drop), String.Color.GOLD), 1.15 * TextTag.STANDARD_SIZE, TextTag.GetFreeId(), false, false)
        else
            call whichUnit.AddJumpingTextTagEx(String.Color.Do(Char.PLUS + Integer.ToString(drop), String.Color.GOLD), 1. * TextTag.STANDARD_SIZE, TextTag.GetFreeId(), false, false)
        endif
    endmethod

    static method AddSupplyFactor takes real value returns nothing
        set thistype.SUPPLY_FACTOR = thistype.SUPPLY_FACTOR + value
    endmethod

    static method SubtractSupplyFactor takes real value returns nothing
        set thistype.SUPPLY_FACTOR = thistype.SUPPLY_FACTOR - value
    endmethod

    initMethod Init of Misc
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Exp_Event_Death).AddToStatics()
        call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Supply_Event_Death).AddToStatics()
    endmethod
endstruct