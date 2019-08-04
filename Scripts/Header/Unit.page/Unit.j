//! runtextmacro Folder("BJUnit")
    //! textmacro BJUnit_CreateStateWithPermanentAbilities takes name, factor
        method Set takes unit self, real amount, real oldAmount returns nothing
            local integer packet
            local integer packetLevel

			set amount = amount * $factor$
			set oldAmount = oldAmount * $factor$

            if (amount * oldAmount <= 0.) then
                if (oldAmount < 0.) then
                    set packetLevel = thistype.DECREASING_SPELLS_MAX

                    loop
                        call UnitRemoveAbility(self, thistype.DECREASING_SPELLS_ID[packetLevel])

                        set packetLevel = packetLevel - 1
                        exitwhen (packetLevel < ARRAY_MIN)
                    endloop
                else
                    set packetLevel = thistype.INCREASING_SPELLS_MAX

                    loop
                        call UnitRemoveAbility(self, thistype.INCREASING_SPELLS_ID[packetLevel])

                        set packetLevel = packetLevel - 1
                        exitwhen (packetLevel < ARRAY_MIN)
                    endloop
                endif
                if (amount < 0.) then
                    set amount = -amount

                    set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), thistype.DECREASING_SPELLS_MAX)

                    loop
                        exitwhen (amount < 1.)

                        set packet = thistype.PACKETS[packetLevel]

                        if (packet <= amount) then
                            set amount = amount - packet
                            call UnitAddAbility(self, thistype.DECREASING_SPELLS_ID[packetLevel])
                        endif

                        set packetLevel = packetLevel - 1
                    endloop
                else
                    set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), thistype.INCREASING_SPELLS_MAX)

                    loop
                        exitwhen (amount < 1.)

                        set packet = thistype.PACKETS[packetLevel]

                        if (packet <= amount) then
                            set amount = amount - packet
                            call UnitAddAbility(self, thistype.INCREASING_SPELLS_ID[packetLevel])
                        endif

                        set packetLevel = packetLevel - 1
                    endloop
                endif
            else
                set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), thistype.DECREASING_SPELLS_MAX)

                if (amount < 0.) then
                    set amount = -amount

                    loop
                        exitwhen (packetLevel < ARRAY_MIN)

                        set packet = thistype.PACKETS[packetLevel]

                        if (packet <= amount) then
                            set amount = amount - packet
                            call UnitAddAbility(self, thistype.DECREASING_SPELLS_ID[packetLevel])
                        else
                            call UnitRemoveAbility(self, thistype.DECREASING_SPELLS_ID[packetLevel])
                        endif

                        set packetLevel = packetLevel - 1
                    endloop
                else
                    set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), thistype.INCREASING_SPELLS_MAX)

                    loop
                        exitwhen (packetLevel < ARRAY_MIN)

                        set packet = thistype.PACKETS[packetLevel]

                        if (packet <= amount) then
                            set amount = amount - packet
                            //call DebugEx("$name$: "+GetUnitName(self)+";"+B2S( UnitAddAbility(self, thistype.INCREASING_SPELLS_ID[packetLevel]) ))
                        else
                            call UnitRemoveAbility(self, thistype.INCREASING_SPELLS_ID[packetLevel])
                        endif

                        set packetLevel = packetLevel - 1
                    endloop
                endif
            endif
        endmethod
    //! endtextmacro

    //! runtextmacro Folder("Armor")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro BJUnit_CreateStateWithPermanentAbilities("ArmorBonus", "1")

            static method Init takes nothing returns nothing
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Armor")
        //! runtextmacro LinkToStaticStruct("Armor", "Bonus")

        static method Init takes nothing returns nothing
            call thistype(NULL).Bonus.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Attack")
        //! runtextmacro Folder("Speed")
            //! runtextmacro Struct("BonusA")
                //! runtextmacro BJUnit_CreateStateWithPermanentAbilities("AttackSpeedBonus", "100")

                static method Init takes nothing returns nothing
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Speed")
            //! runtextmacro LinkToStaticStruct("Speed", "BonusA")

            static method Init takes nothing returns nothing
                call thistype(NULL).BonusA.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Attack")
        //! runtextmacro LinkToStaticStruct("Attack", "Speed")

        static method Init takes nothing returns nothing
            call thistype(NULL).Speed.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Damage")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro BJUnit_CreateStateWithPermanentAbilities("DamageBonus", "1")

            static method Init takes nothing returns nothing
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Damage")
        static item array DECREASING_ITEMS
        static item array INCREASING_ITEMS

        //! runtextmacro LinkToStaticStruct("Damage", "Bonus")

        method Add takes unit self, real amount returns nothing
            local boolean hasInventory = (UnitInventorySize(self) > 0)
            local integer packet
            local integer packetLevel

            if not hasInventory then
                call UnitAddAbility(self, Unit.HERO_INVENTORY_SPELL_ID)
            endif

            if (amount < 0) then
                set amount = -amount
                set packetLevel = thistype.DECREASING_ITEMS_MAX

                loop
                    exitwhen (amount < 1)

                    set packet = PACKETS[packetLevel]

                    loop
                        exitwhen (amount < packet)

                        call UnitAddItem(self, thistype.DECREASING_ITEMS[packetLevel])

//                        call SetWidgetLife(thistype.DECREASING_ITEMS[packetLevel], 1.)

                        set amount = amount - packet
                    endloop

                    set packetLevel = packetLevel - 1
                endloop
            else
                set packetLevel = thistype.INCREASING_ITEMS_MAX

                loop
                    exitwhen (amount < 1)

                    set packet = thistype.PACKETS[packetLevel]

                    loop
                        exitwhen (amount < packet)

                        call UnitAddItem(self, thistype.INCREASING_ITEMS[packetLevel])

//                        call SetWidgetLife(thistype.INCREASING_ITEMS[packetLevel], 1.)

                        set amount = amount - packet
                    endloop

                    set packetLevel = packetLevel - 1
                endloop
            endif

            if not hasInventory then
                call UnitRemoveAbility(self, Unit.HERO_INVENTORY_SPELL_ID)
            endif
        endmethod

        static method Init takes nothing returns nothing
            local integer iteration = thistype.DECREASING_ITEMS_MAX

            loop
                exitwhen (iteration < 0)

                set thistype.DECREASING_ITEMS[iteration] = CreateItem('Idd0' + iteration, 0., 0.)

                set iteration = iteration - 1
            endloop

            set iteration = thistype.INCREASING_ITEMS_MAX

            loop
                exitwhen (iteration < 0)

                set thistype.INCREASING_ITEMS[iteration] = CreateItem('Iid0' + iteration, 0., 0.)

                set iteration = iteration - 1
            endloop

            call thistype(NULL).Bonus.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Movement")
    endstruct

	//! runtextmacro Folder("Hero")
		//! runtextmacro Folder("Agility")
	        //! runtextmacro Struct("BonusA")
	            //! runtextmacro BJUnit_CreateStateWithPermanentAbilities("AgilityBonus", "1")
	
	            static method Init takes nothing returns nothing
	            endmethod
	        endstruct
		endscope

		//! runtextmacro Struct("Agility")
			//! runtextmacro LinkToStaticStruct("Agility", "BonusA")

			static method Init takes nothing returns nothing
				call thistype.BonusA.Init()
			endmethod
		endstruct

		//! runtextmacro Folder("Intelligence")
	        //! runtextmacro Struct("BonusA")
	            //! runtextmacro BJUnit_CreateStateWithPermanentAbilities("IntelligenceBonus", "1")
	
	            static method Init takes nothing returns nothing
	            endmethod
	        endstruct
		endscope

		//! runtextmacro Struct("Intelligence")
			//! runtextmacro LinkToStaticStruct("Intelligence", "BonusA")

			static method Init takes nothing returns nothing
				call thistype.BonusA.Init()
			endmethod
		endstruct

		//! runtextmacro Folder("Strength")
	        //! runtextmacro Struct("BonusA")
	            //! runtextmacro BJUnit_CreateStateWithPermanentAbilities("StrengthBonus", "1")
	
	            static method Init takes nothing returns nothing
	            endmethod
	        endstruct
		endscope

		//! runtextmacro Struct("Strength")
			//! runtextmacro LinkToStaticStruct("Strength", "BonusA")

			static method Init takes nothing returns nothing
				call thistype.BonusA.Init()
			endmethod
		endstruct
	endscope

    //! runtextmacro Struct("Hero")
    	//! runtextmacro LinkToStaticStruct("Hero", "Agility")
    	//! runtextmacro LinkToStaticStruct("Hero", "Intelligence")
    	//! runtextmacro LinkToStaticStruct("Hero", "Strength")

		static method Init takes nothing returns nothing
			call thistype.Agility.Init()
			call thistype.Intelligence.Init()
			call thistype.Strength.Init()
		endmethod
    endstruct
endscope

//! runtextmacro StaticStruct("BJUnit")
    //! runtextmacro LinkToStaticStruct("BJUnit", "Armor")
    //! runtextmacro LinkToStaticStruct("BJUnit", "Attack")
    //! runtextmacro LinkToStaticStruct("BJUnit", "Damage")
    //! runtextmacro LinkToStaticStruct("BJUnit", "Hero")
    //! runtextmacro LinkToStaticStruct("BJUnit", "Movement")

    static method Init takes nothing returns nothing
        call thistype(NULL).Armor.Init()
        call thistype(NULL).Attack.Init()
        call thistype(NULL).Damage.Init()
        call thistype(NULL).Hero.Init()
    endmethod
endstruct

//! runtextmacro BaseStruct("UnitAttackSplash", "UNIT_ATTACK_SPLASH")
    //! runtextmacro CreateAnyState("areaRange", "AreaRange", "real")
    //! runtextmacro CreateAnyState("damageFactor", "DamageFactor", "real")

    method Destroy takes nothing returns nothing
        call this.deallocate()
    endmethod

    static method Create takes real areaRange, real damageFactor returns thistype
        local thistype this = thistype.allocate()

        set this.areaRange = areaRange
        set this.damageFactor = damageFactor

        return this
    endmethod
endstruct

//! runtextmacro Folder("UnitClass")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitClass", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("UnitClass", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("UnitClass")
    endstruct
endscope

//! runtextmacro BaseStruct("UnitClass", "UNIT_CLASS")
    static thistype AIR
    static thistype DEAD
    static thistype GROUND
    static thistype HERO
    static thistype ILLUSION
    static thistype MECHANICAL
    static thistype NEUTRAL
    static thistype STRUCTURE
    static thistype SUMMON
    static thistype UNDECAYABLE
    static thistype UPGRADED
    static thistype WARD

    //! runtextmacro CreateAnyState("name", "Name", "string")

    //! runtextmacro LinkToStruct("UnitClass", "Data")
    //! runtextmacro LinkToStruct("UnitClass", "Id")

    static method Create takes string name returns thistype
        local thistype this = thistype.allocate()

        call this.SetName(name)

        call this.AddToList()

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.AIR = thistype.Create("air")
        set thistype.DEAD = thistype.Create("dead")
        set thistype.GROUND = thistype.Create("ground")
        set thistype.HERO = thistype.Create("hero")
        set thistype.ILLUSION = thistype.Create("illusion")
        set thistype.MECHANICAL = thistype.Create("mechanical")
        set thistype.NEUTRAL = thistype.Create("neutral")
        set thistype.STRUCTURE = thistype.Create("structure")
        set thistype.SUMMON = thistype.Create("summon")
        set thistype.UNDECAYABLE = thistype.Create("undecayable")
        set thistype.UPGRADED = thistype.Create("upgraded")
        set thistype.WARD = thistype.Create("ward")
    endmethod
endstruct

//! runtextmacro Folder("UnitTypePool")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitTypePool", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("UnitTypePool", "Integer", "integer")
        endstruct

        //! runtextmacro Struct("Real")
            //! runtextmacro Data_Type_Implement("UnitTypePool", "Real", "real")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")

        //! runtextmacro Data_Implement("UnitTypePool")
    endstruct
endscope

//! runtextmacro BaseStruct("UnitTypePool", "UNIT_TYPE_POOL")
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    //! runtextmacro GetKeyArray("WEIGHT_KEY_ARRAY_DETAIL")

    real weightAll

    //! runtextmacro LinkToStruct("UnitTypePool", "Data")
    //! runtextmacro LinkToStruct("UnitTypePool", "Id")

    method Random takes nothing returns UnitType
        local integer iteration = Memory.IntegerKeys.Table.STARTED
        local real random = Math.Random(0., this.weightAll)
        local real typeRandom = 0.
        local UnitType whichType

        loop
            set whichType = this.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            set typeRandom = typeRandom + this.Data.Real.Get(WEIGHT_KEY_ARRAY_DETAIL + whichType)

            exitwhen (random <= typeRandom)

            set iteration = iteration + 1
        endloop

        return whichType
    endmethod

    method AddType takes UnitType whichType, real weight returns nothing
        set this.weightAll = this.weightAll + weight
        call this.Data.Integer.Table.Add(KEY_ARRAY, whichType)
        call this.Data.Real.Set(WEIGHT_KEY_ARRAY_DETAIL + whichType, weight)
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        set this.weightAll = 0.
        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro Folder("Unit")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKey("KEY")
        //! runtextmacro GetKeyArray("PARENT_KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState_NotStart("integer")

        static method GetParent takes integer value returns Unit
            return Memory.IntegerKeys.GetInteger(PARENT_KEY_ARRAY + value, KEY)
        endmethod

        method Event_Create takes nothing returns nothing
            local integer value = GetHandleId(Unit(this).self)

            call this.Set(value)
            call Memory.IntegerKeys.SetInteger(PARENT_KEY_ARRAY + value, KEY, this)
        endmethod
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("Unit", "Boolean", "boolean")

            //! runtextmacro Data_Boolean_Implement("Unit")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Unit", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Unit", "Integer", "integer")

            //! runtextmacro Data_Integer_Implement("Unit")
        endstruct

        //! runtextmacro Folder("Real")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Unit", "Real", "real")
            endstruct
        endscope

        //! runtextmacro Struct("Real")
            //! runtextmacro LinkToStruct("Real", "Table")

            //! runtextmacro Data_Type_Implement("Unit", "Real", "real")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")

        //! runtextmacro Data_Implement("Unit")
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Combination")
            method Remove takes EventCombination whichCombination returns nothing
                local integer iteration = whichCombination.Events.Count()

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    call Unit(this).Event.Remove(whichCombination.Events.Get(iteration))

                    set iteration = iteration - 1
                endloop

                set iteration = whichCombination.Pairs.Count()

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    local EventPair thisPair = whichCombination.Pairs.Get(iteration)

                    call Unit(this).Event.Remove(thisPair.GetNegativeEvent())
                    call Unit(this).Event.Remove(thisPair.GetPositiveEvent())

                    set iteration = iteration - 1
                endloop

                call whichCombination.Subjects.Remove(Unit(this).Id.Get())
            endmethod

            method Add takes EventCombination whichCombination returns nothing
                local integer iteration = whichCombination.Events.Count()

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    call Unit(this).Event.Add(whichCombination.Events.Get(iteration))

                    set iteration = iteration - 1
                endloop

                set iteration = whichCombination.Pairs.Count()

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    local EventPair thisPair = whichCombination.Pairs.Get(iteration)

                    call Unit(this).Event.Add(thisPair.GetNegativeEvent())
                    call Unit(this).Event.Add(thisPair.GetPositiveEvent())

                    set iteration = iteration - 1
                endloop

                call whichCombination.Subjects.Add(Unit(this).Id.Get())
            endmethod
        endstruct

        //! runtextmacro Struct("Counted")
            static Event DESTROY_EVENT
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

            method Ending takes Event whichEvent, boolean byDestroy returns nothing
                if byDestroy then
                    call Unit(this).Data.Integer.Remove(KEY_ARRAY_DETAIL + whichEvent)
                endif
                if Unit(this).Data.Integer.Table.Remove(KEY_ARRAY, whichEvent) then
                    call Unit(this).Event.Remove(DESTROY_EVENT)
                endif
                call Unit(this).Event.Remove(whichEvent)
            endmethod

            method Subtract takes Event whichEvent returns nothing
                if Unit(this).Data.Integer.Subtract(KEY_ARRAY_DETAIL + whichEvent, 1) then
                    call this.Ending(whichEvent, false)
                endif
            endmethod

            eventMethod Event_Destroy
                local thistype parentThis = params.Unit.GetTrigger()

                loop
                    local Event whichEvent = Unit(parentThis).Data.Integer.Table.GetFirst(KEY_ARRAY)
                    exitwhen (whichEvent == NULL)

                    call parentThis.Ending(whichEvent, true)
                endloop
            endmethod

            method Add takes Event whichEvent returns nothing
                if Unit(this).Data.Integer.Add(KEY_ARRAY_DETAIL + whichEvent, 1) then
                    if Unit(this).Data.Integer.Table.Add(KEY_ARRAY, whichEvent) then
                        call Unit(this).Event.Add(DESTROY_EVENT)
                    endif
                    call Unit(this).Event.Add(whichEvent)
                endif
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            endmethod
        endstruct

        function GetAttacker_Wrapped takes nothing returns unit
            return GetAttacker()
        endfunction

        //! runtextmacro Struct("Native")
            //! textmacro Unit_Event_Native_CreateResponse takes name, source
                static method Get$name$ takes nothing returns Unit
                    local unit self = $source$()

                    if (GetUnitAbilityLevel(self, DummyUnit.LOCUST_SPELL_ID) > 0) then
                        set self = null

                        return STRUCT_INVALID
                    endif

                    local Unit result = Unit.GetFromSelf(self)

                    set self = null

                    return result
                endmethod
            //! endtextmacro

            //! runtextmacro Unit_Event_Native_CreateResponse("AcquiredTarget", "GetEventTargetUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("Attacker", "GetAttacker_Wrapped")
            //! runtextmacro Unit_Event_Native_CreateResponse("Damager", "GetEventDamageSource")
            //! runtextmacro Unit_Event_Native_CreateResponse("Enum", "GetEnumUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("Filter", "GetFilterUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("Killer", "GetKillingUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("OrderTarget", "GetOrderTargetUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("Purchaser", "GetBuyingUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("SpellTarget", "GetSpellTargetUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("Trigger", "GetTriggerUnit")
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Combination")
        //! runtextmacro LinkToStruct("Event", "Counted")
        //! runtextmacro LinkToStruct("Event", "Native")

        //! runtextmacro Event_Implement("Unit")

        static method Init takes nothing returns nothing
            call thistype(NULL).Counted.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Abilities")
        //! runtextmacro Struct("Cooldown")
            static Event DESTROY_EVENT
            static EventType ENDING_EVENT_TYPE
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
            static EventType START_EVENT_TYPE

            Timer durationTimer
            Unit parent
            Spell whichSpell

            method Is takes Spell whichSpell returns boolean
                return (whichSpell.Data.Integer.Get(KEY_ARRAY_DETAIL + this) != NULL)
            endmethod

            static method Ending_TriggerEvents takes Unit parent, Spell whichSpell returns nothing
                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.Spell.SetTrigger(whichSpell)
                call params.Unit.SetTrigger(parent)

				local EventResponse spellParams = EventResponse.Create(whichSpell.Id.Get())

                call spellParams.Spell.SetTrigger(whichSpell)
                call spellParams.Unit.SetTrigger(parent)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = whichSpell.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call whichSpell.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run(spellParams)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
                call spellParams.Destroy()
            endmethod

            method Ending takes Timer durationTimer, Unit parent, Spell whichSpell returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                if parent.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                    call parent.Event.Remove(DESTROY_EVENT)
                endif
                call parent.Data.Integer.Remove(KEY_ARRAY_DETAIL + whichSpell)
                if whichSpell.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                    //call whichSpell.Event.Remove(COOLDOWN_EVENT)
                endif
                call whichSpell.Data.Integer.Remove(KEY_ARRAY_DETAIL + parent)

                call thistype.Ending_TriggerEvents(parent, whichSpell)
            endmethod

            method EndingByParent takes Spell whichSpell returns nothing
                local Unit parent = this
                local integer whichSpellSelf = whichSpell.self

                set this = parent.Data.Integer.Get(KEY_ARRAY_DETAIL + whichSpell)

                if (this == NULL) then
                    return
                endif

                local integer level = parent.Abilities.GetLevel(whichSpell)

                call parent.Order.Events.Lock()

                call parent.Abilities.RemoveBySelf(whichSpellSelf)
                call parent.Abilities.AddBySelf(whichSpellSelf)
                call parent.Abilities.SetLevelBySelf(whichSpellSelf, level)

                call parent.Order.Events.Unlock()

                call this.Ending(this.durationTimer, parent, whichSpell)
            endmethod

            timerMethod EndingByTimer
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                call this.Ending(durationTimer, this.parent, this.whichSpell)
            endmethod

            eventMethod Event_Destroy
                local Unit parent = params.Unit.GetTrigger()

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.Ending(this.durationTimer, parent, this.whichSpell)

                    set iteration = iteration - 1
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                endloop
            endmethod

            static method Start_TriggerEvents takes Unit parent, Spell whichSpell returns nothing
                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.Spell.SetTrigger(whichSpell)
                call params.Unit.SetTrigger(parent)

				local EventResponse spellParams = EventResponse.Create(whichSpell.Id.Get())

                call spellParams.Spell.SetTrigger(whichSpell)
                call spellParams.Unit.SetTrigger(parent)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.START_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED) 

                        call parent.Event.Get(thistype.START_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = whichSpell.Event.Count(thistype.START_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED) 

                        call whichSpell.Event.Get(thistype.START_EVENT_TYPE, priority, iteration2).Run(spellParams)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
                call spellParams.Destroy()
            endmethod

            method StartEx takes Spell whichSpell returns nothing
                local Unit parent = this

                local real duration = whichSpell.GetCooldown(parent.Abilities.GetLevel(whichSpell))

                if (duration == 0.) then
                    return
                endif

                set this = thistype.allocate()

				local Timer durationTimer = Timer.Create()

                set this.durationTimer = durationTimer
                set this.parent = parent
                set this.whichSpell = whichSpell
                call durationTimer.SetData(this)
                if parent.Data.Integer.Table.Add(KEY_ARRAY, this) then
                    call parent.Event.Add(DESTROY_EVENT)
                endif
                call parent.Data.Integer.Set(KEY_ARRAY_DETAIL + whichSpell, this)
                if whichSpell.Data.Integer.Table.Add(KEY_ARRAY, this) then
                    //call whichSpell.Event.Add(COOLDOWN_EVENT)
                endif
                call whichSpell.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)

                call thistype.Start_TriggerEvents(parent, whichSpell)
            endmethod

            method Start takes Spell whichSpell returns nothing
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.ENDING_EVENT_TYPE = EventType.Create()
                set thistype.START_EVENT_TYPE = EventType.Create()
            endmethod
        endstruct

        //! runtextmacro Folder("Events")
            //! runtextmacro Struct("Begin")
                static EventType DUMMY_EVENT_TYPE
                static Trigger DUMMY_TRIGGER
                static UnitList REG_GROUP

                static method TriggerEvents takes Unit caster, integer level, Unit targetUnit, real targetX, real targetY, Spell whichSpell returns nothing
                    local EventResponse casterParams = EventResponse.Create(caster.Id.Get())

                    call casterParams.Spell.SetLevel(level)
                    call casterParams.Spell.SetTrigger(whichSpell)
                    call casterParams.Spot.SetTargetX(targetX)
                    call casterParams.Spot.SetTargetY(targetY)
                    call casterParams.Unit.SetTarget(targetUnit)
                    call casterParams.Unit.SetTrigger(caster)

					local EventResponse spellParams = EventResponse.Create(whichSpell.Id.Get())

                    call spellParams.Spell.SetLevel(level)
                    call spellParams.Spell.SetTrigger(whichSpell)
                    call spellParams.Spot.SetTargetX(targetX)
                    call spellParams.Spot.SetTargetY(targetY)
                    call spellParams.Unit.SetTarget(targetUnit)
                    call spellParams.Unit.SetTrigger(caster)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichSpell.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichSpell.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(casterParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = caster.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call caster.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(spellParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call casterParams.Destroy()
                    call spellParams.Destroy()
                endmethod

                condTrigMethod TrigConds
                    if not thistype.REG_GROUP.Contains(UNIT.Event.Native.GetTrigger()) then
                        return false
                    endif
                    if (SPELL.Event.Native.GetCast() == NULL) then
                        return false
                    endif

                    return true
                endmethod

                trigMethod Trig
                    local Unit caster = UNIT.Event.Native.GetTrigger()
                    local Unit targetUnit = UNIT.Event.Native.GetSpellTarget()
                    local real targetX = SPOT.Event.Native.GetSpellTargetX()
                    local real targetY = SPOT.Event.Native.GetSpellTargetY()
                    local Spell whichSpell = SPELL.Event.Native.GetCast()

                    local integer level = caster.Abilities.GetLevel(whichSpell)

                    call thistype.TriggerEvents(caster, level, targetUnit, targetX, targetY, whichSpell)
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.REG_GROUP.Remove(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.REG_GROUP.Add(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                    set thistype.REG_GROUP = UnitList.Create()

                    call thistype.DUMMY_TRIGGER.AddConditions(function thistype.TrigConds)
                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_SPELL_CAST, null)
                endmethod
            endstruct

            //! runtextmacro Folder("Effect")
                //! runtextmacro Struct("Channeling")
                    static constant real ANIMATION_TIME = 0.25
                    static Timer ANIMATION_TIMER
                    //! runtextmacro GetKeyArray("CASTER_KEY_ARRAY")
                    static real DURATION
                    static Event DEATH_EVENT
                    static Event ORDER_EVENT
                    static Event ORDER_POINT_EVENT
                    static Event ORDER_TARGET_EVENT
                    static Event STUN_EVENT
                    static Event TARGET_DEATH_EVENT
                    static Event TARGET_DESTROY_EVENT
                    static Event UNLEARN_EVENT
                    static SpellInstance WHICH_INSTANCE

                    //! runtextmacro CreateList("ACTIVE_LIST")
                    //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

                    Timer durationTimer
                    boolean running
                    SpellInstance whichInstance

                    method Is takes nothing returns boolean
                        return this.running
                    endmethod

                    method Animate takes nothing returns nothing
                        local Unit caster = this

                        local SpellInstance whichInstance = this.whichInstance

                        if (whichInstance.GetSpell().GetTargetType() != Spell.TARGET_TYPE_IMMEDIATE) then
                            local real angle = caster.CastAngle(whichInstance.GetCurrentTargetX() - caster.Position.X.Get(), whichInstance.GetCurrentTargetY() - caster.Position.Y.Get())

                            if (caster.Facing.Get() != angle) then
                                call caster.Facing.Set(angle)
                            endif
                        endif
                    endmethod

                    timerMethod AnimateByTimer
                        call thistype.FOR_EACH_LIST_Set()

                        loop
                            local thistype this = thistype.FOR_EACH_LIST_FetchFirst()

                            exitwhen (this == NULL)

                            call this.Animate()
                        endloop
                    endmethod

                    eventMethod Event_Death
                        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
                    endmethod

                    eventMethod Event_Order
                        local Unit caster = params.Unit.GetTrigger()
                        local Order whichOrder = params.Order.GetTrigger()

                        if (whichOrder == Order.HOLD_POSITION) then
                            call caster.Buffs.Remove(thistype.DUMMY_BUFF)
                        elseif (whichOrder == Order.SMART) then
                            local User casterOwner = caster.Owner.Get()

                            if ((caster.Selection.CountAtPlayer(casterOwner) == Memory.IntegerKeys.Table.STARTED) and (caster.Selection.GetFromPlayer(casterOwner, Memory.IntegerKeys.Table.STARTED) == caster)) then
                                call caster.Buffs.Remove(thistype.DUMMY_BUFF)
                            endif
                        endif
                    endmethod

                    eventMethod Event_Stun
                        local Unit caster = params.Unit.GetTrigger()

                        if (params.Order.GetTrigger() == Order.STUNNED) then
                            call caster.Buffs.Remove(thistype.DUMMY_BUFF)
                        endif
                    endmethod

					eventMethod Event_Unlearn
						local Unit caster = params.Unit.GetTrigger()
						local Spell whichSpell = params.Spell.GetTrigger()
						
						local thistype this = caster
						
						if (this.whichInstance.GetSpell() == whichSpell) then
							call caster.Buffs.Remove(thistype.DUMMY_BUFF)
						endif
					endmethod

                    static method TargetEnding takes Unit target returns nothing
                        local integer iteration = target.Data.Integer.Table.Count(CASTER_KEY_ARRAY)

                        loop
                            local Unit caster = target.Data.Integer.Table.Get(CASTER_KEY_ARRAY, iteration)

                            call caster.Buffs.Remove(thistype.DUMMY_BUFF)

                            set iteration = iteration - 1
                            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                        endloop
                    endmethod

                    eventMethod Event_TargetDeath
                        call thistype.TargetEnding(params.Unit.GetTrigger())
                    endmethod

                    eventMethod Event_TargetDestroy
                        call thistype.TargetEnding(params.Unit.GetTrigger())
                    endmethod

                    eventMethod Event_BuffLose
                        local Unit caster = params.Unit.GetTrigger()

                        local thistype this = caster

                        local Timer durationTimer = this.durationTimer
                        local SpellInstance whichInstance = this.whichInstance

                        local boolean completed = (durationTimer.GetRemaining() < 0.1)
                        local Unit target = whichInstance.GetTargetUnit()

                        call durationTimer.Destroy()
                        if thistype.ACTIVE_LIST_Remove(this) then
                            call thistype.ANIMATION_TIMER.Pause()
                        endif

                        set this.running = false
                        call caster.Event.Remove(DEATH_EVENT)
                        call caster.Event.Remove(ORDER_EVENT)
                        call caster.Event.Remove(ORDER_POINT_EVENT)
                        call caster.Event.Remove(ORDER_TARGET_EVENT)
                        call caster.Event.Remove(STUN_EVENT)
                        call caster.Event.Remove(UNLEARN_EVENT)
                        if (target != NULL) then
                            if target.Data.Integer.Table.Remove(CASTER_KEY_ARRAY, caster) then
                                call target.Event.Remove(TARGET_DEATH_EVENT)
                                call target.Event.Remove(TARGET_DESTROY_EVENT)
                            endif
                        endif

                        call caster.Animation.Reset()
                        call caster.Attack.Add()
                        call caster.Movement.Add()

                        call caster.Bars.EndChannel()

                        call UNIT.Abilities.Events.Finish.Start(whichInstance, completed)

                        call whichInstance.Refs.Subtract()
                    endmethod

                    eventMethod Event_BuffGain
                        local Unit caster = params.Unit.GetTrigger()
                        local real duration = thistype.DURATION
                        local SpellInstance whichInstance = thistype.WHICH_INSTANCE

                        local Unit target = whichInstance.GetTargetUnit()

                        local thistype this = caster

						local Timer durationTimer = Timer.Create()

                        set this.durationTimer = durationTimer
                        set this.running = true
                        set this.whichInstance = whichInstance
                        call caster.Event.Add(DEATH_EVENT)
                        call caster.Event.Add(ORDER_EVENT)
                        call caster.Event.Add(ORDER_POINT_EVENT)
                        call caster.Event.Add(ORDER_TARGET_EVENT)
                        call caster.Event.Add(STUN_EVENT)
                        call caster.Event.Add(UNLEARN_EVENT)
                        if (target != NULL) then
                            if target.Data.Integer.Table.Add(CASTER_KEY_ARRAY, caster) then
                                call target.Event.Add(TARGET_DEATH_EVENT)
                                call target.Event.Add(TARGET_DESTROY_EVENT)
                            endif
                        endif

                        call durationTimer.Start(duration + 0.01, false, null)
                        call Unit(this).Animation.Loop.Start(whichInstance.GetSpell().GetAnimation())
                        call Unit(this).Attack.Subtract()
                        call Unit(this).Movement.Subtract()
                        call whichInstance.Refs.Add()

                        if thistype.ACTIVE_LIST_Add(this) then
                            call thistype.ANIMATION_TIMER.Start(thistype.ANIMATION_TIME, true, function thistype.AnimateByTimer)
                        endif

                        call this.Animate()

                        call caster.Bars.StartChannel(duration)
                    endmethod

                    static method Start takes SpellInstance whichInstance returns nothing
                        local real duration = whichInstance.GetSpell().GetChannelTime(whichInstance.GetLevel())

                        if (duration == 0.) then
                            return
                        endif

                        call whichInstance.GetCaster().Buffs.Remove(thistype.DUMMY_BUFF)

                        set thistype.DURATION = duration
                        set thistype.WHICH_INSTANCE = whichInstance

                        call whichInstance.GetCaster().Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
                    endmethod

                    method Event_Create takes nothing returns nothing
                        set this.running = false
                    endmethod

                    initMethod Buff_Init of Header_Buffs
                        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                    endmethod

                    static method Init takes nothing returns nothing
                        set thistype.ANIMATION_TIMER = Timer.Create()
                        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
                        set thistype.ORDER_EVENT = Event.Create(UNIT.Order.Events.Gain.Immediate.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Order)
                        set thistype.ORDER_POINT_EVENT = Event.Create(UNIT.Order.Events.Gain.Point.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Order)
                        set thistype.ORDER_TARGET_EVENT = Event.Create(UNIT.Order.Events.Gain.Target.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Order)
                        set thistype.STUN_EVENT = Event.Create(UNIT.Order.Events.Gain.Target.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Stun)
                        set thistype.TARGET_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TargetDeath)
                        set thistype.TARGET_DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TargetDestroy)
                        set thistype.UNLEARN_EVENT = Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Unlearn)
                    endmethod
                endstruct
            endscope

            //! runtextmacro Struct("Effect")
                static EventType DUMMY_EVENT_TYPE
                static Trigger DUMMY_TRIGGER
                //! runtextmacro GetKeyArray("KEY_ARRAY")
                static EventType PRE_EVENT_TYPE
                static Trigger PRE_TRIGGER
                static UnitList REG_GROUP

                boolean inventoryUse
                SpellInstance whichInstance

                //! runtextmacro LinkToStruct("Effect", "Channeling")

                static method TriggerEvents takes SpellInstance whichInstance, Item fromWhichItem returns nothing
                    local Unit caster = whichInstance.GetCaster()
                    local integer level = whichInstance.GetLevel()
                    local Item targetItem = whichInstance.GetTargetItem()
                    local Unit targetUnit = whichInstance.GetTargetUnit()
                    local real targetX = whichInstance.GetTargetX()
                    local real targetY = whichInstance.GetTargetY()
                    local Spell whichSpell = whichInstance.GetSpell()

                    local EventResponse casterParams = EventResponse.Create(caster.Id.Get())

                    call casterParams.Item.SetTarget(targetItem)
                    call casterParams.Item.SetTrigger(fromWhichItem)
                    call casterParams.Spell.SetLevel(level)
                    call casterParams.Spell.SetTrigger(whichSpell)
                    call casterParams.SpellInstance.SetTrigger(whichInstance)
                    call casterParams.Spot.SetTargetX(targetX)
                    call casterParams.Spot.SetTargetY(targetY)
                    call casterParams.Unit.SetTarget(targetUnit)
                    call casterParams.Unit.SetTrigger(caster)

					local EventResponse spellParams = EventResponse.Create(whichSpell.Id.Get())

                    call spellParams.Item.SetTarget(targetItem)
                    call spellParams.Item.SetTrigger(fromWhichItem)
                    call spellParams.Spell.SetLevel(level)
                    call spellParams.Spell.SetTrigger(whichSpell)
                    call spellParams.SpellInstance.SetTrigger(whichInstance)
                    call spellParams.Spot.SetTargetX(targetX)
                    call spellParams.Spot.SetTargetY(targetY)
                    call spellParams.Unit.SetTarget(targetUnit)
                    call spellParams.Unit.SetTrigger(caster)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(casterParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = caster.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call caster.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(casterParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = whichSpell.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichSpell.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(spellParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call casterParams.Destroy()
                    call spellParams.Destroy()
                endmethod

                static method Start takes SpellInstance whichInstance, Item fromWhichItem returns nothing
                    local Unit caster = whichInstance.GetCaster()
                    local integer level = whichInstance.GetLevel()
                    local Unit targetUnit = whichInstance.GetTargetUnit()
                    local Spell whichSpell = whichInstance.GetSpell()

                    local boolean hasTargetUnit = (targetUnit != NULL)

                    local thistype this = caster

                    call thistype(NULL).Channeling.Start(whichInstance)

                    call caster.Abilities.Cooldown.StartEx(whichSpell)

                    call caster.Mana.SubtractNoNative(whichSpell.GetManaCost(level))

					local boolean isNotCasterAlly

                    if hasTargetUnit then
                        set isNotCasterAlly = not caster.IsAllyOf(targetUnit.Owner.Get())
                    endif

                    if caster.Classes.Contains(UnitClass.HERO) then
                        call caster.AddJumpingTextTagEx2(String.Color.Do(whichInstance.GetSpell().GetName(), "ff00ffff"), S2R(SetVar.GetValDef("size", "0.021")), TextTag.GetFreeId(), false, -caster.CollisionSize.Get(true), 0.)
                    endif

                    call thistype.TriggerEvents(whichInstance, fromWhichItem)

                    if hasTargetUnit then
                        if isNotCasterAlly then
                            set UNIT.Damage.Events.IGNORE_NEXT = true
                        endif
                    endif

                    call whichInstance.Destroy()

                    set this.whichInstance = NULL
                endmethod

                condTrigMethod TrigConds
                    local Unit caster = UNIT.Event.Native.GetTrigger()

                    if (caster == NULL) then
                        return false
                    endif

                    if (caster.Abilities.GetLevelBySelf(Spell.PARALLEL_CAST_BUFF_ID) > 0) then
                        call caster.Buffs.RemoveBySelf(Spell.PARALLEL_CAST_BUFF_ID)
                    endif

                    if not thistype.REG_GROUP.Contains(caster) then
                        return false
                    endif
                    if (SPELL.Event.Native.GetCast() == NULL) then
                        return false
                    endif

                    return true
                endmethod

                static integer array TARGET_TYPE_DUMMY_CAST_SPELL_IDS

                trigMethod Trig
                    local Unit caster = UNIT.Event.Native.GetTrigger()

                    local thistype this = caster

                    local SpellInstance whichInstance = this.whichInstance

                    if (whichInstance == NULL) then
                        return
                    endif

                    if this.inventoryUse then
                        return
                    endif

                    local integer targetType = whichInstance.GetSpell().GetTargetType()

                    local integer dummyCastSpellId = thistype.TARGET_TYPE_DUMMY_CAST_SPELL_IDS[targetType]

                    if (dummyCastSpellId != 0) then
                        call caster.Abilities.AddBySelf(dummyCastSpellId)
                        //call caster.Owner.Get().EnableAbilityBySelf(dummyCastSpellId, true)

                        local OrderInstance dummyOrderData = OrderInstance.Create()

                        call dummyOrderData.SetOrder(Order.CHANNEL)
                        call dummyOrderData.SetTargetType(targetType)
                        call dummyOrderData.SetTargetUnit(whichInstance.GetTargetUnit())
                        call dummyOrderData.SetTargetX(whichInstance.GetTargetX())
                        call dummyOrderData.SetTargetY(whichInstance.GetTargetY())

                        //call caster.Order.DoNoTrig(dummyOrderData)

                        call dummyOrderData.Destroy()

                        //call caster.Owner.Get().EnableAbilityBySelf(dummyCastSpellId, false)
                    endif

                    call thistype.Start(whichInstance, NULL)
                endmethod

                method StartByItem takes SpellInstance whichInstance, Item whichItem returns nothing
                    call thistype.Start(whichInstance, whichItem)
                endmethod

                static method PreTriggerEvents takes SpellInstance whichInstance returns nothing
                    local Unit caster = whichInstance.GetCaster()
                    local integer level = whichInstance.GetLevel()
                    local Item targetItem = whichInstance.GetTargetItem()
                    local Unit targetUnit = whichInstance.GetTargetUnit()
                    local real targetX = whichInstance.GetTargetX()
                    local real targetY = whichInstance.GetTargetY()
                    local Spell whichSpell = whichInstance.GetSpell()

                    local EventResponse casterParams = EventResponse.Create(caster.Id.Get())

                    call casterParams.Item.SetTarget(targetItem)
                    call casterParams.Spell.SetLevel(level)
                    call casterParams.Spell.SetTrigger(whichSpell)
                    call casterParams.SpellInstance.SetTrigger(whichInstance)
                    call casterParams.Spot.SetTargetX(targetX)
                    call casterParams.Spot.SetTargetY(targetY)
                    call casterParams.Unit.SetTarget(targetUnit)
                    call casterParams.Unit.SetTrigger(caster)

					local EventResponse spellParams = EventResponse.Create(whichSpell.Id.Get())

                    call spellParams.Item.SetTarget(targetItem)
                    call spellParams.Spell.SetLevel(level)
                    call spellParams.Spell.SetTrigger(whichSpell)
                    call spellParams.SpellInstance.SetTrigger(whichInstance)
                    call spellParams.Spot.SetTargetX(targetX)
                    call spellParams.Spot.SetTargetY(targetY)
                    call spellParams.Unit.SetTarget(targetUnit)
                    call spellParams.Unit.SetTrigger(caster)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = caster.Event.Count(thistype.PRE_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call caster.Event.Get(thistype.PRE_EVENT_TYPE, priority, iteration2).Run(casterParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = whichSpell.Event.Count(thistype.PRE_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichSpell.Event.Get(thistype.PRE_EVENT_TYPE, priority, iteration2).Run(spellParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call casterParams.Destroy()
                    call spellParams.Destroy()
                endmethod

                method GetSpellInstance takes nothing returns SpellInstance
                    return this.whichInstance
                endmethod

                trigMethod PreTrig
                    local Unit caster = UNIT.Event.Native.GetTrigger()
                    local Spell whichSpell = SPELL.Event.Native.GetCast()

                    local Order casterOrder = caster.Order.Get()

                    local thistype this = caster

                    local SpellInstance whichInstance = SpellInstance.Create(caster, whichSpell)

					local integer level

                    if casterOrder.IsInventoryUse() then
                        set level = caster.Items.GetFromSlot(casterOrder.GetInventoryIndex()).Abilities.GetLevel(whichSpell)

                        set this.inventoryUse = true
                    else
                        set level = caster.Abilities.GetLevel(whichSpell)

                        set this.inventoryUse = false
                    endif

                    set this.whichInstance = whichInstance

                    local real targetX = SPOT.Event.Native.GetSpellTargetX()
                    local real targetY = SPOT.Event.Native.GetSpellTargetY()

					local Item targetItem
					local Unit targetUnit

					if (whichInstance.GetSpell().GetTargetType() == Spell.TARGET_TYPE_IMMEDIATE) then
						set targetItem = NULL
						set targetUnit = NULL
					else
						set targetItem = ITEM.Event.Native.GetSpellTarget()
						set targetUnit = UNIT.Event.Native.GetSpellTarget()
					endif

                    call whichInstance.SetAngle(caster.CastAngle(targetX - caster.Position.X.Get(), targetY - caster.Position.Y.Get()))
                    call whichInstance.SetLevel(level)
                    call whichInstance.SetTargetItem(targetItem)
                    call whichInstance.SetTargetUnit(targetUnit)
                    call whichInstance.SetTargetX(targetX)
                    call whichInstance.SetTargetY(targetY)

                    call thistype.PreTriggerEvents(whichInstance)
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.REG_GROUP.Remove(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    set this.whichInstance = NULL
                    call thistype.REG_GROUP.Add(this)

                    call this.Channeling.Event_Create()
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                    set thistype.PRE_EVENT_TYPE = EventType.Create()
                    set thistype.PRE_TRIGGER = Trigger.CreateFromCode(function thistype.PreTrig)
                    set thistype.REG_GROUP = UnitList.Create()

                    call thistype.DUMMY_TRIGGER.AddConditions(function thistype.TrigConds)
                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_SPELL_ENDCAST, null)
                    call thistype.PRE_TRIGGER.AddConditions(function thistype.TrigConds)
                    call thistype.PRE_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_SPELL_EFFECT, null)

                    set thistype.TARGET_TYPE_DUMMY_CAST_SPELL_IDS[Spell.TARGET_TYPE_IMMEDIATE] = thistype.IMMEDIATE_DUMMY_SPELL_ID
                    set thistype.TARGET_TYPE_DUMMY_CAST_SPELL_IDS[Spell.TARGET_TYPE_POINT] = thistype.POINT_DUMMY_SPELL_ID
                    set thistype.TARGET_TYPE_DUMMY_CAST_SPELL_IDS[Spell.TARGET_TYPE_POINT_OR_UNIT] = thistype.POINT_OR_UNIT_DUMMY_SPELL_ID
                    set thistype.TARGET_TYPE_DUMMY_CAST_SPELL_IDS[Spell.TARGET_TYPE_UNIT] = thistype.UNIT_DUMMY_SPELL_ID

                    call thistype(NULL).Channeling.Init()
                endmethod
            endstruct

            //! runtextmacro Struct("Finish")
                static EventType DUMMY_EVENT_TYPE
                static EventType SUCCESS_EVENT_TYPE

                static method TriggerEvents takes SpellInstance whichInstance, boolean channelComplete returns nothing
                    local Unit caster = whichInstance.GetCaster()
                    local integer level = whichInstance.GetLevel()
                    local Item targetItem = whichInstance.GetTargetItem()
                    local Unit targetUnit = whichInstance.GetTargetUnit()
                    local real targetX = whichInstance.GetTargetX()
                    local real targetY = whichInstance.GetTargetY()
                    local Spell whichSpell = whichInstance.GetSpell()

                    local EventResponse casterParams = EventResponse.Create(caster.Id.Get())

                    call casterParams.Spell.SetChannelComplete(channelComplete)
                    call casterParams.Spell.SetLevel(level)
                    call casterParams.Spell.SetTrigger(whichSpell)
                    call casterParams.SpellInstance.SetTrigger(whichInstance)
                    call casterParams.Unit.SetTrigger(caster)

					local EventResponse spellParams = EventResponse.Create(whichSpell.Id.Get())

                    call spellParams.Spell.SetChannelComplete(channelComplete)
                    call spellParams.Spell.SetLevel(level)
                    call spellParams.Spell.SetTrigger(whichSpell)
                    call spellParams.SpellInstance.SetTrigger(whichInstance)
                    call spellParams.Unit.SetTrigger(caster)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichSpell.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichSpell.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(spellParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = whichSpell.Event.Count(thistype.SUCCESS_EVENT_TYPE, priority)

                        if channelComplete then
                            loop
                                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                                call whichSpell.Event.Get(thistype.SUCCESS_EVENT_TYPE, priority, iteration2).Run(spellParams)

                                set iteration2 = iteration2 - 1
                            endloop
                        endif

                        set iteration2 = caster.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call caster.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(casterParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call casterParams.Destroy()
                    call spellParams.Destroy()
                endmethod

                static method Start takes SpellInstance whichInstance, boolean channelComplete returns nothing
                    call thistype.TriggerEvents(whichInstance, channelComplete)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.SUCCESS_EVENT_TYPE = EventType.Create()
                endmethod
            endstruct

            //! runtextmacro Struct("Learn")
                static EventType CHANGE_LEVEL_EVENT_TYPE
                static EventType DUMMY_EVENT_TYPE
                static Trigger DUMMY_TRIGGER
                static UnitList REG_GROUP

                method ChangeLevel_TriggerEvents takes Spell whichSpell, integer level returns nothing
                    local EventResponse spellParams = EventResponse.Create(whichSpell.Id.Get())

                    call spellParams.Spell.SetLevel(level)
                    call spellParams.Spell.SetTrigger(whichSpell)
                    call spellParams.Unit.SetTrigger(this)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichSpell.Event.Count(thistype.CHANGE_LEVEL_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichSpell.Event.Get(thistype.CHANGE_LEVEL_EVENT_TYPE, priority, iteration2).Run(spellParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call spellParams.Destroy()
                endmethod

                method ChangeLevel takes Spell whichSpell, integer level returns nothing
                    call this.ChangeLevel_TriggerEvents(whichSpell, level)
                endmethod

                method TriggerEvents takes integer level, Spell whichSpell returns nothing
                    local EventResponse spellParams = EventResponse.Create(whichSpell.Id.Get())

                    call spellParams.Spell.SetLevel(level)
                    call spellParams.Spell.SetTrigger(whichSpell)
                    call spellParams.Unit.SetTrigger(this)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichSpell.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichSpell.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(spellParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call spellParams.Destroy()
                endmethod

                method Start takes Spell whichSpell returns nothing
                    local integer level = Unit(this).Abilities.GetLevel(whichSpell)

                    call this.TriggerEvents(level, whichSpell)
                endmethod

                static method TrigConds takes Unit parent returns boolean
                    if not thistype.REG_GROUP.Contains(parent) then
                        return false
                    endif

                    return true
                endmethod

                trigMethod Trig
                    local Unit parent = UNIT.Event.Native.GetTrigger()

                    if not thistype.TrigConds(parent) then
                        return
                    endif

                    call parent.SkillPoints.UpdateByLearn()

                    call thistype(parent).Start(SPELL.Event.Native.GetLearned())
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.REG_GROUP.Remove(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.REG_GROUP.Add(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.CHANGE_LEVEL_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                    set thistype.REG_GROUP = UnitList.Create()

                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_HERO_SKILL, null)
                endmethod
            endstruct

            //! runtextmacro Struct("Unlearn")
                static EventType DUMMY_EVENT_TYPE

                method TriggerEvents takes Spell whichSpell returns nothing
                	local Unit parent = this

                    local EventResponse params = EventResponse.Create(parent.Id.Get())

                    call params.Spell.SetTrigger(whichSpell)
                    call params.Unit.SetTrigger(parent)

                    local EventResponse spellParams = EventResponse.Create(whichSpell.Id.Get())

                    call spellParams.Spell.SetTrigger(whichSpell)
                    call spellParams.Unit.SetTrigger(parent)

                    local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = whichSpell.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichSpell.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(spellParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

					call params.Destroy()
                    call spellParams.Destroy()
                endmethod

                method Start takes Spell whichSpell returns nothing
                    call this.TriggerEvents(whichSpell)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Events")
            //! runtextmacro LinkToStruct("Events", "Begin")
            //! runtextmacro LinkToStruct("Events", "Effect")
            //! runtextmacro LinkToStruct("Events", "Finish")
            //! runtextmacro LinkToStruct("Events", "Learn")
            //! runtextmacro LinkToStruct("Events", "Unlearn")

            method Event_Destroy takes nothing returns nothing
                call this.Begin.Event_Destroy()
                call this.Effect.Event_Destroy()
                call this.Learn.Event_Destroy()
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Begin.Event_Create()
                call this.Effect.Event_Create()
                call this.Learn.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                call thistype(NULL).Begin.Init()
                call thistype(NULL).Finish.Init()
                call thistype(NULL).Learn.Init()
                call thistype(NULL).Unlearn.Init()
                
                call thistype(NULL).Effect.Init()
            endmethod
        endstruct

        //! runtextmacro Struct("AutoCast")
            static EventType DUMMY_EVENT_TYPE

            Spell val

            method Get takes nothing returns Spell
                return this.val
            endmethod

            method TriggerEvents takes Spell sourceSpell, Spell whichSpell returns nothing
                local Unit parent = this

                local EventResponse parentParams = EventResponse.Create(parent.Id.Get())

                call parentParams.Spell.SetSource(sourceSpell)
                call parentParams.Spell.SetTrigger(whichSpell)
                call parentParams.Unit.SetTrigger(this)

                local EventResponse spellParams = EventResponse.Create(whichSpell.Id.Get())

                call spellParams.Spell.SetSource(sourceSpell)
                call spellParams.Spell.SetTrigger(whichSpell)
                call spellParams.Unit.SetTrigger(this)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = whichSpell.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call whichSpell.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(spellParams)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(parentParams)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call parentParams.Destroy()
                call spellParams.Destroy()
            endmethod

            method Set takes Spell whichSpell returns nothing
                local Spell oldVal = this.Get()

                if (whichSpell == oldVal) then
                    return
                endif

                set this.val = whichSpell

                call this.TriggerEvents(oldVal, whichSpell)
            endmethod

            method Change takes Spell whichSpell returns nothing
                if (whichSpell == NULL) then
                    if (this.Get() != NULL) then
                        if Unit(this).Order.ImmediateNoTrig(whichSpell.GetAutoCastOrderOff()) then
                            call this.Set(NULL)
                        endif
                    endif
                else
                    if Unit(this).Order.ImmediateNoTrig(whichSpell.GetAutoCastOrderOn()) then
                        call this.Set(whichSpell)
                    endif
                endif
            endmethod

            method Event_Create takes nothing returns nothing
                set this.val = NULL
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DUMMY_EVENT_TYPE = EventType.Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Abilities")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("LEVEL_KEY_ARRAY_DETAIL")

        //! runtextmacro LinkToStruct("Abilities", "AutoCast")
        //! runtextmacro LinkToStruct("Abilities", "Cooldown")
        //! runtextmacro LinkToStruct("Abilities", "Events")

        method Count takes nothing returns integer
            return Unit(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns Spell
            return Unit(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

       method GetFromOrder takes Order whichOrder returns Spell
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local Spell whichSpell = this.Get(iteration)

                if ((whichSpell.GetOrder() == whichOrder) or (whichSpell.GetAutoCastOrderOff() == whichOrder) or (whichSpell.GetAutoCastOrderOn() == whichOrder)) then
                    return whichSpell
                endif

                set iteration = iteration - 1
            endloop

            return NULL
        endmethod

        method GetLevelBySelf takes integer spellSelf returns integer
            return GetUnitAbilityLevel(Unit(this).self, spellSelf)
        endmethod

        method GetLevel takes Spell whichSpell returns integer
            return Unit(this).Data.Integer.Get(LEVEL_KEY_ARRAY_DETAIL + whichSpell)
        endmethod

        method Contains takes Spell whichSpell returns boolean
            return (this.GetLevel(whichSpell) > 0)
        endmethod

        method RemoveBySelf takes integer spellSelf returns nothing
            call UnitRemoveAbility(Unit(this).self, spellSelf)
        endmethod

        method AddBySelf takes integer spellSelf returns nothing
            call UnitAddAbility(Unit(this).self, spellSelf)
            call UnitMakeAbilityPermanent(Unit(this).self, true, spellSelf)
        endmethod

        method SetLevelBySelf takes integer spellSelf, integer level returns nothing
            if (level == 0) then
                call this.RemoveBySelf(spellSelf)

                return
            endif

            if (this.GetLevelBySelf(spellSelf) == 0) then
                call this.AddBySelf(spellSelf)
            endif

            call SetUnitAbilityLevel(Unit(this).self, spellSelf, level)
        endmethod

        method Remove takes Spell whichSpell returns nothing
            if not this.Contains(whichSpell) then
                return
            endif

            if (whichSpell.self != 0) then
                call this.RemoveBySelf(whichSpell.self)
            endif

            call Unit(this).Data.Integer.Table.Remove(KEY_ARRAY, whichSpell)
            call Unit(this).Data.Integer.Remove(LEVEL_KEY_ARRAY_DETAIL + whichSpell)

            call this.Events.Unlearn.Start(whichSpell)
        endmethod

        method StartCooldown takes Spell whichSpell returns nothing
            call this.Cooldown.StartEx(whichSpell)
        endmethod

        method AddWithLevel takes Spell whichSpell, integer level returns nothing
            call this.SetLevel(whichSpell, level)
        endmethod

        method Add takes Spell whichSpell returns nothing
            call this.AddWithLevel(whichSpell, 1)
        endmethod

        method SetLevel takes Spell whichSpell, integer level returns nothing
            local boolean added

            if (level == 0) then
                call this.Remove(whichSpell)

                return
            endif

            set added = not this.Contains(whichSpell)

            if added then
                if (whichSpell.self != 0) then
                    call this.AddBySelf(whichSpell.self)
                endif

                call Unit(this).Data.Integer.Table.Add(KEY_ARRAY, whichSpell)
                call Unit(this).Data.Integer.Set(LEVEL_KEY_ARRAY_DETAIL + whichSpell, level)

                call this.Events.Learn.Start(whichSpell)

                return
            endif

            call Unit(this).Data.Integer.Set(LEVEL_KEY_ARRAY_DETAIL + whichSpell, level)
            call this.SetLevelBySelf(whichSpell.self, level)

            call this.Events.Learn.ChangeLevel(whichSpell, level)
        endmethod

        method AddLevel takes Spell whichSpell, integer value returns nothing
            call this.SetLevel(whichSpell, this.GetLevel(whichSpell) + value)
        endmethod

        method Replace takes Spell oldSpell, Spell newSpell returns nothing
            local integer level = this.GetLevel(oldSpell)

            if (level > 0) then
                call this.Remove(oldSpell)

                call this.SetLevel(newSpell, level)
            endif
        endmethod

        method Refresh takes Spell whichSpell returns nothing
            call this.Cooldown.EndingByParent(whichSpell)
        endmethod

        method RefreshAll takes nothing returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Refresh(this.Get(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        method Clear takes nothing returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Remove(this.Get(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        eventMethod Event_TypeChange
            local UnitType sourceType = params.UnitType.GetSource()
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            if Unit(this).Classes.Contains(UnitClass.HERO) then
                return
            endif

            call this.Clear()

            local integer iteration = targetType.Abilities.Count()

            loop
                exitwhen (iteration < ARRAY_MIN)

                local Spell whichSpell = targetType.Abilities.Get(iteration)

                call this.AddLevel(whichSpell, targetType.Abilities.GetLevel(whichSpell))

                set iteration = iteration - 1
            endloop
        endmethod

        method Event_Create takes nothing returns nothing
            local Spell whichSpell
            local UnitType thisType = Unit(this).Type.Get()

            local integer iteration = thisType.Abilities.Count()

            call this.AutoCast.Event_Create()

            loop
                exitwhen (iteration < ARRAY_MIN)

                set whichSpell = thisType.Abilities.Get(iteration)

                call this.AddLevel(whichSpell, thisType.Abilities.GetLevel(whichSpell))

                set iteration = iteration - 1
            endloop

            call this.Events.Event_Create()

            set iteration = thisType.Abilities.Hero.Count()

            loop
                exitwhen (iteration < ARRAY_MIN)

                call HeroSpell.AddToUnit(thisType.Abilities.Hero.Get(iteration), this)

                set iteration = iteration - 1
            endloop
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            call thistype(NULL).AutoCast.Init()
            call thistype(NULL).Cooldown.Init()
            call thistype(NULL).Events.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Effects")
        method Create takes string modelPath, string attachPoint, EffectLevel level returns UnitEffect
            return UnitEffect.Create(this, modelPath, attachPoint, level)
        endmethod
    endstruct

    //! runtextmacro Struct("Sounds")
        method Create takes SoundType whichSoundType returns UnitSound
            return UnitSound.Create(this, whichSoundType)
        endmethod
    endstruct

    //! runtextmacro Struct("Attachments")
        method Add takes string path, string attachPoint, EffectLevel level returns nothing
            call Unit(this).Effects.Create(path, attachPoint, level)
        endmethod

        eventMethod Event_TypeChange
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            local integer iteration = targetType.Attachments.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Add(targetType.Attachments.GetPath(iteration), targetType.Attachments.GetAttachPoint(iteration), targetType.Attachments.GetLevel(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        method Event_Create takes nothing returns nothing
            local UnitType parentType = Unit(this).Type.Get()

            local integer iteration = parentType.Attachments.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Add(parentType.Attachments.GetPath(iteration), parentType.Attachments.GetAttachPoint(iteration), parentType.Attachments.GetLevel(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Folder("Buffs")
        //! runtextmacro Folder("Events")
            //! runtextmacro Struct("ChangeLevel")
                static EventType DUMMY_EVENT_TYPE

                method TriggerEvents takes Buff whichBuff, integer oldLevel, integer level, integer data returns nothing
                    local EventResponse buffParams = EventResponse.Create(whichBuff.Id.Get())

                    call buffParams.Buff.SetData(data)
                    call buffParams.Buff.SetLevel(level)
                    call buffParams.Buff.SetSourceLevel(oldLevel)
                    call buffParams.Buff.SetTrigger(whichBuff)
                    call buffParams.Unit.SetTrigger(this)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichBuff.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichBuff.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(buffParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call buffParams.Destroy()
                endmethod

                method Start takes Buff whichBuff, integer oldLevel, integer level, integer data returns nothing
                    local UnitModSet modSet = whichBuff.UnitModSets.Get(oldLevel)

                    if (modSet != NULL) then
                        call Unit(this).ModSets.Remove(modSet)
                    endif

                    set modSet = whichBuff.UnitModSets.Get(level)

                    if (modSet != NULL) then
                        call Unit(this).ModSets.Add(modSet)
                    endif

                    call this.TriggerEvents(whichBuff, oldLevel, level, data)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                endmethod
            endstruct

            //! runtextmacro Struct("Gain")
                static EventType DUMMY_EVENT_TYPE

                method TriggerEvents takes Buff whichBuff, integer level, integer data returns nothing
                    local EventResponse buffParams = EventResponse.Create(whichBuff.Id.Get())

                    call buffParams.Buff.SetData(data)
                    call buffParams.Buff.SetLevel(level)
                    call buffParams.Buff.SetTrigger(whichBuff)
                    call buffParams.Unit.SetTrigger(this)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichBuff.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichBuff.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(buffParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call buffParams.Destroy()
                endmethod

                method Start takes Buff whichBuff, integer level, integer data returns nothing
                    local UnitModSet modSet = whichBuff.UnitModSets.Get(level)

                    if (modSet != NULL) then
                        call Unit(this).ModSets.Add(modSet)
                    endif

                    call this.TriggerEvents(whichBuff, level, data)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                endmethod
            endstruct

            //! runtextmacro Struct("Lose")
                static EventType DUMMY_EVENT_TYPE

                method TriggerEvents takes Buff whichBuff, integer level returns nothing
                    local Unit parent = this

                    local EventResponse buffParams = EventResponse.Create(whichBuff.Id.Get())

                    call buffParams.Buff.SetLevel(level)
                    call buffParams.Buff.SetTrigger(whichBuff)
                    call buffParams.Unit.SetTrigger(parent)

					local EventResponse params = EventResponse.Create(parent.Id.Get())

                    call params.Buff.SetLevel(level)
                    call params.Buff.SetTrigger(whichBuff)
                    call params.Unit.SetTrigger(parent)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = whichBuff.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichBuff.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(buffParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call buffParams.Destroy()
                    call params.Destroy()
                endmethod

                method Start takes Buff whichBuff, integer level returns nothing
                    local UnitModSet modSet = whichBuff.UnitModSets.Get(level)

                    if (modSet != NULL) then
                        call Unit(this).ModSets.Remove(modSet)
                    endif

                    call this.TriggerEvents(whichBuff, level)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Events")
            //! runtextmacro LinkToStruct("Events", "ChangeLevel")
            //! runtextmacro LinkToStruct("Events", "Gain")
            //! runtextmacro LinkToStruct("Events", "Lose")

            static method Init takes nothing returns nothing
                call thistype(NULL).ChangeLevel.Init()
                call thistype(NULL).Gain.Init()
                call thistype(NULL).Lose.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Timed")
            //! runtextmacro Struct("Countdown")
                static Event DEATH_EVENT
                //! runtextmacro GetKey("KEY")
                //! runtextmacro GetKeyArray("KEY_ARRAY")
                //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
                static constant integer SHOW_FROM = 3

                integer count
                Timer countdownTimer
                Timer durationTimer
                boolean firstCount
                Unit parent
                Buff whichBuff

                method Ending takes Timer durationTimer, Unit parent returns nothing
                    local Timer countdownTimer = this.countdownTimer
                    local Buff whichBuff = this.whichBuff

                    call this.deallocate()
                    call countdownTimer.Destroy()
                    call durationTimer.Destroy()
                    if parent.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                        call parent.Event.Remove(DEATH_EVENT)
                    endif
                    call parent.Data.Integer.Remove(KEY_ARRAY_DETAIL + whichBuff)
                endmethod

                timerMethod EndingByTimer
                    local Timer durationTimer = Timer.GetExpired()

                    local thistype this = durationTimer.GetData()

                    call this.Ending(durationTimer, this.parent)
                endmethod

                method EndingByParent takes Buff whichBuff returns nothing
                    local Unit parent = this

                    set this = parent.Data.Integer.Get(KEY_ARRAY_DETAIL + whichBuff)

                    if (this != NULL) then
                        call this.Ending(this.durationTimer, parent)
                    endif
                endmethod

                eventMethod Event_Death
                    local Unit parent = params.Unit.GetTrigger()

                    local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                    loop
                        local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                        call this.Ending(this.durationTimer, parent)

                        set iteration = iteration - 1
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                    endloop
                endmethod

                method Interval takes nothing returns nothing
                    local integer count = this.count
                    local boolean firstCount = this.firstCount

                    if firstCount then
                        set this.firstCount = false
                        call this.parent.AddRisingTextTag(String.Color.Do(this.whichBuff.GetName() + " vanishes in " + Char.BREAK + Integer.ToString(count), "ff00ffff"), 0.022, 120., 1., 2., TextTag.GetFreeId())
                    else
                        call this.parent.AddRisingTextTag(String.Color.Do(Integer.ToString(count), "ff00ffff"), 0.022, 120., 1., 2., TextTag.GetFreeId())
                    endif

                    set this.count = count - 1
                endmethod

                timerMethod IntervalByTimer
                    local thistype this = Timer.GetExpired().GetData()

                    call this.Interval()
                endmethod

                static method StartCountdown takes nothing returns nothing
                    //call Timer.GetExpired().Start(1., true, function thistype.IntervalByTimer)
                endmethod

                method Start takes Buff whichBuff, real duration returns nothing
                    local Unit parent = this

                    set this = parent.Data.Integer.Get(KEY_ARRAY_DETAIL + whichBuff)

                    if (this != NULL) then
                        call this.Ending(this.durationTimer, parent)
                    endif

                    /*if (duration <= thistype.SHOW_FROM) then
                        return
                    endif*/

                    local integer count = Math.MinI(Real.ToInt(duration), thistype.SHOW_FROM)
                    local Timer countdownTimer = Timer.Create()
                    local Timer durationTimer = Timer.Create()
                    set this = thistype.allocate()

                    local real countdownStart = duration - count - 1.

                    set this.count = count
                    set this.countdownTimer = countdownTimer
                    set this.durationTimer = durationTimer
                    set this.firstCount = true
                    set this.parent = parent
                    set this.whichBuff = whichBuff
                    call countdownTimer.SetData(this)
                    call durationTimer.SetData(this)
                    if parent.Data.Integer.Table.Add(KEY_ARRAY, this) then
                        call parent.Event.Add(DEATH_EVENT)
                    endif
                    call parent.Data.Integer.Set(KEY_ARRAY_DETAIL + whichBuff, this)

                    call countdownTimer.Start(countdownStart, false, function thistype.StartCountdown)

                    if (countdownStart < 0.) then
                        call this.Interval()
                    endif

                    //call durationTimer.Start(duration - countdownStart - 1.+0.01, false, function thistype.EndingByTimer)
                    call durationTimer.Start(duration - 1+0.01, false, function thistype.EndingByTimer)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Timed")
            static Event DEATH_EVENT
            static constant real INFINITE = -1.
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
            static Event LOSE_EVENT

            //! runtextmacro LinkToStruct("Timed", "Countdown")

            Timer durationTimer
            Unit parent
            BuffRef whichBuffRef

            method Get takes Buff whichBuff, integer level returns BuffRef
                return Memory.IntegerKeys.D2.GetInteger(KEY, this, whichBuff, level, NULL)
            endmethod

            method GetRemainingDuration takes Buff whichBuff, integer level returns real
                set this = this.Get(whichBuff, level)

                if (this == NULL) then
                    return 0.
                endif

                return this.durationTimer.GetRemaining()
            endmethod

            method Destroy takes nothing returns nothing
                local Timer durationTimer = this.durationTimer
                local Unit parent = this.parent
                local BuffRef whichBuffRef = this.whichBuffRef

                local integer level = whichBuffRef.level
                local Buff whichBuff = whichBuffRef.whichBuff

                call this.deallocate()
                call durationTimer.Destroy()

                call Memory.IntegerKeys.D2.RemoveInteger(KEY, parent, whichBuff, level, NULL)

                call thistype(parent).Countdown.EndingByParent(whichBuff)

                if parent.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                    call parent.Event.Remove(DEATH_EVENT)
                    call parent.Event.Remove(LOSE_EVENT)
                endif

                call whichBuffRef.Destroy()

                call whichBuffRef.SubtractRef()
            endmethod

            timerMethod EndingByTimer
                local thistype this = Timer.GetExpired().GetData()

                call this.Destroy()
            endmethod

            method EndingByParentWithLevel takes Buff whichBuff, integer level returns nothing
                local Unit parent = this

                set this = thistype(parent).Get(whichBuff, level)

                if (this != NULL) then
                    call this.Destroy()
                endif
            endmethod

            method EndingByParent takes Buff whichBuff returns nothing
                call this.EndingByParentWithLevel(whichBuff, 1)
            endmethod

            eventMethod Event_Lose
                local integer level = params.Buff.GetLevel()
                local Unit parent = params.Unit.GetTrigger()
                local Buff whichBuff = params.Buff.GetTrigger()

                local thistype this = thistype(parent).Get(whichBuff, level)

                if (this != NULL) then
                    call this.Destroy()
                endif
            endmethod

            eventMethod Event_Death
                local Unit parent = params.Unit.GetTrigger()

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.Destroy()

                    set iteration = iteration - 1
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                endloop
            endmethod

            method AddTime takes Buff whichBuff, real duration returns nothing
                local Unit parent = this

                set this = thistype(parent).Get(whichBuff, Unit(this).Buffs.GetLevel(whichBuff))

                local Timer durationTimer = this.durationTimer
                call thistype(parent).Countdown.EndingByParent(whichBuff)

                set duration = duration + durationTimer.GetRemaining()

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)

                if not whichBuff.IsHidden() then
                    if (parent.Classes.Contains(UnitClass.HERO) or whichBuff.IsShowCountdown()) then
                        call thistype(parent).Countdown.Start(whichBuff, duration)
                    endif
                endif
            endmethod

            method StartEx takes Buff whichBuff, integer level, integer data, real duration returns BuffRef
                local Unit parent = this

                set this = this.Get(whichBuff, level)

				local Timer durationTimer
				local BuffRef whichBuffRef

                if (this == NULL) then
                    set whichBuffRef = parent.Buffs.CreateWithLevel(whichBuff, level, data)

                    if (whichBuffRef == NULL) then
                        return NULL
                    endif

                    set durationTimer = Timer.Create()
                    set this = thistype.allocate()

                    set this.durationTimer = durationTimer
                    set this.parent = parent
                    set this.whichBuffRef = whichBuffRef

                    call durationTimer.SetData(this)
                    call Memory.IntegerKeys.D2.SetInteger(KEY, parent, whichBuff, level, NULL, this)

                    call durationTimer.Start(duration, false, function thistype.EndingByTimer)

                    if parent.Data.Integer.Table.Add(KEY_ARRAY, this) then
                        call parent.Event.Add(DEATH_EVENT)
                        call parent.Event.Add(LOSE_EVENT)
                    endif

                    call whichBuffRef.AddRef()
                else
                    set durationTimer = this.durationTimer

                    if (duration > durationTimer.GetRemaining()) then
                        call durationTimer.Start(duration, false, function thistype.EndingByTimer)
                    endif

                    return NULL
                endif

                if not whichBuff.IsHidden() then
                    if (duration != thistype.INFINITE) then
                        if (parent.Classes.Contains(UnitClass.HERO) or whichBuff.IsShowCountdown()) then
                            call thistype(parent).Countdown.Start(whichBuff, duration)
                        endif
                    endif
                endif

                return whichBuffRef
            endmethod

            method Start takes Buff whichBuff, integer level, real duration returns BuffRef
                return this.StartEx(whichBuff, level, NULL, duration)
            endmethod

            method DoWithLevel takes Buff whichBuff, integer level, integer data, real duration returns BuffRef
                return this.StartEx(whichBuff, level, data, duration)
            endmethod

            method Do takes Buff whichBuff, integer data, real duration returns BuffRef
                return this.DoWithLevel(whichBuff, 1, data, duration)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
                set thistype.LOSE_EVENT = Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Lose)

                call thistype(NULL).Countdown.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Buffs")
        static Event DEATH_EVENT
        static Event DESTROY_EVENT
        static constant string DISPEL_EFFECT_ATTACH_POINT = AttachPoint.ORIGIN
        static constant string DISPEL_EFFECT_PATH = "Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl"
        //! runtextmacro GetKey("EFFECTS_KEY")
        static constant real INFINITE_DURATION = -1.
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
        //! runtextmacro GetKeyArray("LEVELS_KEY_ARRAY_DETAIL")
        //! runtextmacro GetKey("LOOP_SOUNDS_KEY")

        //! runtextmacro LinkToStruct("Buffs", "Events")
        //! runtextmacro LinkToStruct("Buffs", "Timed")

        method Contains takes Buff whichBuff returns boolean
            return Unit(this).Data.Integer.Contains(KEY_ARRAY_DETAIL + whichBuff)
        endmethod

        method Count takes nothing returns integer
            return Unit(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns Buff
            return Unit(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method GetRemainingDuration takes Buff whichBuff, integer level returns real
            local real result

            if not this.Contains(whichBuff) then
                return 0.
            endif

            set result = this.Timed.GetRemainingDuration(whichBuff, level)

            if (result == 0.) then
                return thistype.INFINITE_DURATION
            endif

            return result
        endmethod

        method CountVisible takes nothing returns integer
            local integer iteration = this.Count()
            local integer result = Memory.IntegerKeys.Table.EMPTY

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                if not this.Get(iteration).IsHidden() then
                    set result = result + 1
                endif

                set iteration = iteration - 1
            endloop

            return result
        endmethod

        method CountVisibleEx takes boolean negative, boolean positive returns integer
            local boolean isPositive
            local integer iteration = this.Count()
            local integer result = Memory.IntegerKeys.Table.EMPTY
            local Buff whichBuff

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set whichBuff = this.Get(iteration)

                if not whichBuff.IsHidden() then
                    set isPositive = whichBuff.IsPositive()

                    if ((negative and not isPositive) or (positive and isPositive)) then
                        set result = result + 1
                    endif
                endif

                set iteration = iteration - 1
            endloop

            return result
        endmethod

        method GetVisible takes integer index returns Buff
            local integer count = this.Count()
            local Buff current
            local integer found = Memory.IntegerKeys.Table.EMPTY
            local integer iteration = Memory.IntegerKeys.Table.STARTED

            loop
                exitwhen (iteration > count)

                set current = this.Get(iteration)

                if not current.IsHidden() then
                    set found = found + 1

                    if (found == index) then
                        return current
                    endif
                endif

                set iteration = iteration + 1
            endloop

            return NULL
        endmethod

        method GetLevel takes Buff whichBuff returns integer
            return Unit(this).Data.Integer.Get(LEVELS_KEY_ARRAY_DETAIL + whichBuff)
        endmethod

        method RemoveBySelf takes integer buffId returns nothing
            call Unit(this).Abilities.RemoveBySelf(buffId)
        endmethod

//! runtextmacro GetKey("LOCAL_REFS_KEY")

        method Remove [autoExec] takes Buff whichBuff returns boolean
            if not this.Contains(whichBuff) then
                return false
            endif

            local integer dummySpellId = whichBuff.GetDummySpellId()
            local integer level = this.GetLevel(whichBuff)

            if (dummySpellId != 0) then
                call Unit(this).Abilities.RemoveBySelf(dummySpellId)
                call Unit(this).Abilities.RemoveBySelf(whichBuff.self)
            endif

            call Unit(this).Data.Integer.Remove(KEY_ARRAY_DETAIL + whichBuff)
            call Unit(this).Data.Integer.Remove(LEVELS_KEY_ARRAY_DETAIL + whichBuff)

call Memory.IntegerKeys.D2.Table.ClearIntegers(LOCAL_REFS_KEY, this, whichBuff, NULL)

            if Unit(this).Data.Integer.Table.Remove(KEY_ARRAY, whichBuff) then
                call Unit(this).Event.Remove(DEATH_EVENT)
                call Unit(this).Event.Remove(DESTROY_EVENT)
            endif

            local UnitEffect whichEffect = Memory.IntegerKeys.D2.Table.FetchFirstInteger(EFFECTS_KEY, this, whichBuff, NULL)

            loop
                exitwhen (whichEffect == NULL)

                call whichEffect.Destroy()

                set whichEffect = Memory.IntegerKeys.D2.Table.FetchFirstInteger(EFFECTS_KEY, this, whichBuff, NULL)
            endloop

            local UnitSound whichSound = Memory.IntegerKeys.D2.Table.FetchFirstInteger(LOOP_SOUNDS_KEY, this, whichBuff, NULL)

            loop
                exitwhen (whichSound == NULL)

                call whichSound.Destroy()

                set whichSound = Memory.IntegerKeys.D2.Table.FetchFirstInteger(LOOP_SOUNDS_KEY, this, whichBuff, NULL)
            endloop

            call BuffRef.Event_BuffLose(whichBuff, this)

            call this.Events.Lose.Start(whichBuff, level)

            local integer iteration = whichBuff.Variants.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                //call BuffRef.Event_BuffLose(whichBuff, this)
                call this.Remove(whichBuff.Variants.Get(iteration))

                set iteration = iteration - 1
            endloop

            call this.RemoveVariantParents(whichBuff)

            return true
        endmethod

        method AddRaw [autoExec] takes Buff whichBuff, integer level, integer data returns boolean
            if this.Contains(whichBuff) then
                local integer oldLevel = this.GetLevel(whichBuff)

                if (level != oldLevel) then
                    call Unit(this).Data.Integer.Set(LEVELS_KEY_ARRAY_DETAIL + whichBuff, level)

                    call this.Events.ChangeLevel.Start(whichBuff, oldLevel, level, data)
                endif

                return false
            endif

            if Unit(this).IsDestroyed() then
                return false
            endif

            if (whichBuff.IsLostOnDeath() and Unit(this).Classes.Contains(UnitClass.DEAD)) then
                return false
            endif

            if Unit(this).Data.Integer.Table.Add(KEY_ARRAY, whichBuff) then
                call Unit(this).Event.Add(DEATH_EVENT)
                call Unit(this).Event.Add(DESTROY_EVENT)
            endif
            call Unit(this).Data.Integer.Add(KEY_ARRAY_DETAIL + whichBuff, 1)
            call Unit(this).Data.Integer.Set(LEVELS_KEY_ARRAY_DETAIL + whichBuff, level)

            local integer dummySpellId = whichBuff.GetDummySpellId()

            if (dummySpellId != 0) then
                call Unit(this).Abilities.AddBySelf(dummySpellId)

                call Unit(this).Abilities.SetLevelBySelf(dummySpellId, level)
            endif

            local integer iteration

			if whichBuff.TargetEffects.IsShownOnApply() then
				set iteration = whichBuff.TargetEffects.Count()

	            loop
	                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
	
	                call Memory.IntegerKeys.D2.Table.AddInteger(EFFECTS_KEY, this, whichBuff, NULL, Unit(this).Effects.Create(whichBuff.TargetEffects.GetPath(iteration), whichBuff.TargetEffects.GetAttachPoint(iteration), whichBuff.TargetEffects.GetLevel(iteration)))
	
	                set iteration = iteration - 1
	            endloop
            endif

            set iteration = whichBuff.LoopSounds.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
//call DebugEx("create sound "+I2S(whichBuff.LoopSounds.Get(iteration)))
                call Memory.IntegerKeys.D2.Table.AddInteger(LOOP_SOUNDS_KEY, this, whichBuff, NULL, Unit(this).Sounds.Create(whichBuff.LoopSounds.Get(iteration)))

                set iteration = iteration - 1
            endloop

            call this.AddVariantParents(whichBuff, level, data)

            call this.Events.Gain.Start(whichBuff, level, data)

            return true
        endmethod

        method SetLevel takes Buff whichBuff, integer level, integer data returns nothing
            local integer oldLevel = this.GetLevel(whichBuff)

            if (oldLevel == level) then
                return
            endif

            if (level > 0) then
                call this.AddRaw(whichBuff, level, data)
            else
                call this.Remove(whichBuff)
            endif
        endmethod

        method Dispel takes boolean negative, boolean positive, boolean useUI returns integer
            if useUI then
                call Unit(this).Effects.Create(thistype.DISPEL_EFFECT_PATH, thistype.DISPEL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
            endif

            local integer count = 0
            local integer iteration = this.Count()

            loop
                local Buff whichBuff = this.Get(iteration)

                if whichBuff.IsLostOnDispel() then
                    if whichBuff.IsPositive() then
                        if positive then
                            set count = count + 1
                            call this.Remove(whichBuff)
                        endif
                    else
                        if negative then
                            set count = count + 1
                            call this.Remove(whichBuff)
                        endif
                    endif
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop

            //call this.Dispel_TriggerEvents(negative, positive)

            return count
        endmethod

        method Steal takes Unit target, boolean negative, boolean positive, integer level returns nothing
            local thistype targetThis = target

			local integer count = ARRAY_EMPTY
			local real array duration
            local integer iteration = targetThis.Count()
            local Buff array temp

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local Buff current = targetThis.Get(iteration)

                if (not current.IsHidden() and ((current.IsPositive() and positive) or (not current.IsPositive() and negative)) and (target.Buffs.GetLevel(current) <= level)) then
                    set count = count + 1

                    set duration[count] = target.Buffs.GetRemainingDuration(current, target.Buffs.GetLevel(current))
                    set temp[count] = current
                    call target.Buffs.Remove(current)
                endif

                set iteration = iteration - 1
            endloop

            loop
                exitwhen (count < ARRAY_MIN)

                call this.AddWithDuration(temp[count], level, NULL, duration[count])

                set count = count - 1
            endloop
        endmethod

        eventMethod Event_Death
            local thistype this = params.Unit.GetTrigger()

            local integer iteration = this.Count()

            loop
                local Buff whichBuff = this.Get(iteration)

                if whichBuff.IsLostOnDeath() then
                    call this.Remove(whichBuff)
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        eventMethod Event_Destroy
            local thistype this = params.Unit.GetTrigger()

            local integer iteration = this.Count()

            loop
                local Buff whichBuff = this.Get(iteration)

                call this.Remove(whichBuff)

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method Create takes Buff whichBuff, integer data returns BuffRef
            local BuffRef whichRef = BuffRef.Create(whichBuff, this, data)

            return whichRef
        endmethod

        method CreateWithLevel takes Buff whichBuff, integer level, integer data returns BuffRef
            local BuffRef whichRef = BuffRef.CreateWithLevel(whichBuff, level, this, data)

            return whichRef
        endmethod

        //! runtextmacro GetKey("VARIANT_REFS_KEY")

        method RemoveVariantParents takes Buff whichBuff returns nothing
            local BuffRef whichRef = Memory.IntegerKeys.D2.Table.FetchFirstInteger(VARIANT_REFS_KEY, this, whichBuff, NULL)

            loop
                exitwhen (whichRef == NULL)

                call whichRef.Destroy()

                set whichRef = Memory.IntegerKeys.D2.Table.FetchFirstInteger(VARIANT_REFS_KEY, this, whichBuff, NULL)
            endloop
        endmethod

        method AddVariantParents takes Buff whichBuff, integer level, integer data returns nothing
            local integer iteration = whichBuff.Variants.CountParents()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call Memory.IntegerKeys.D2.Table.AddInteger(VARIANT_REFS_KEY, this, whichBuff, NULL, this.CreateWithLevel(whichBuff.Variants.GetParent(iteration), level, data))

                set iteration = iteration - 1
            endloop
        endmethod

        method Subtract takes Buff whichBuff returns boolean
        //if whichBuff==HackNSlay(NULL).Target.DUMMY_BUFF or whichBuff==UNIT.Transport.DUMMY_BUFF then
          //  set Memory.TEST=true
        //endif
            local BuffRef whichRef = Memory.IntegerKeys.D2.Table.FetchFirstInteger(LOCAL_REFS_KEY, this, whichBuff, NULL)
        //if whichBuff==HackNSlay(NULL).Target.DUMMY_BUFF or whichBuff==UNIT.Transport.DUMMY_BUFF then
          //  set Memory.TEST=false
        //endif
            if (whichRef == NULL) then
                return false
            endif
if whichBuff!=whichRef.whichBuff then
	call DebugEx(I2S(LOCAL_REFS_KEY)+"\t\t subtract CORRUPT buffref"+whichBuff.GetName()+";"+I2S(whichBuff)+";"+I2S(whichRef)+";"+I2S(whichRef.whichBuff))
endif
            call whichRef.Destroy()

            return true
        endmethod

        method AddEx takes Buff whichBuff, integer level, integer data returns boolean
//call DebugEx("addex "+I2S(BuffRef(186).whichBuff))
            local BuffRef whichRef = this.CreateWithLevel(whichBuff, level, data)

            if (whichRef == NULL) then
                return false
            endif
//if whichBuff!=whichRef.whichBuff then
	//call DebugEx("\tadd CORRUPT buffref "+whichBuff.GetName()+";"+I2S(whichBuff)+";"+I2S(whichRef))
//else
	//call DebugEx("\tadd buffref "+whichBuff.GetName()+";"+I2S(whichBuff)+";"+I2S(whichRef))
//endif

            call Memory.IntegerKeys.D2.Table.AddInteger(LOCAL_REFS_KEY, this, whichBuff, NULL, whichRef)

            return true
        endmethod

        method Add takes Buff whichBuff, integer level returns boolean
            return this.AddEx(whichBuff, level, NULL)
        endmethod

        method AddFresh takes Buff whichBuff, integer level returns boolean
            call this.Remove(whichBuff)

            return this.Add(whichBuff, level)
        endmethod

        method AddFreshEx takes Buff whichBuff, integer level, integer data returns boolean
            call this.Remove(whichBuff)

            return this.AddEx(whichBuff, level, data)
        endmethod

        method AddWithDuration takes Buff whichBuff, integer level, integer data, real duration returns BuffRef
            if (duration == thistype.INFINITE_DURATION) then
                return this.CreateWithLevel(whichBuff, level, data)
            endif

            return this.Timed.DoWithLevel(whichBuff, level, data, duration)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
            set thistype.DESTROY_EVENT = Event.Create(UNIT.DESTROY_EVENT_TYPE, EventPriority.HEADER_TOP, function thistype.Event_Destroy)

            call thistype(NULL).Events.Init()

            call thistype(NULL).Timed.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("ModSets")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        method Remove takes UnitModSet val returns nothing
            call Unit(this).Data.Integer.Table.Remove(KEY_ARRAY, val)

            call val.RemoveFromUnit(this)
        endmethod

        method Add takes UnitModSet val returns nothing
            call Unit(this).Data.Integer.Table.Add(KEY_ARRAY, val)

            call val.AddToUnit(this)
        endmethod
    endstruct

    //! runtextmacro Folder("Items")
        //! runtextmacro Folder("Events")
            //! runtextmacro Struct("Gain")
                static EventType DUMMY_EVENT_TYPE
                static Trigger DUMMY_TRIGGER
                static boolean IGNORE_NEXT = false
                static UnitList REG_GROUP

                method TriggerEvents takes Item whichItem, integer whichSlot returns nothing
                    local Unit parent = this

                    local ItemType whichItemType = whichItem.Type.Get()

                    local EventResponse itemTypeParams = EventResponse.Create(whichItemType.Id.Get())

                    call itemTypeParams.Item.SetTrigger(whichItem)
                    call itemTypeParams.Item.SetTriggerSlot(whichSlot)
                    call itemTypeParams.ItemType.SetTrigger(whichItemType)
                    call itemTypeParams.Unit.SetTrigger(parent)

					local EventResponse params = EventResponse.Create(parent.Id.Get())

                    call params.Item.SetTrigger(whichItem)
                    call params.Item.SetTriggerSlot(whichSlot)
                    call params.ItemType.SetTrigger(whichItemType)
                    call params.Unit.SetTrigger(parent)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichItemType.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichItemType.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(itemTypeParams)

                            if not parent.Items.Contains(whichItem) then
                                return
                            endif

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                            if not parent.Items.Contains(whichItem) then
                                return
                            endif

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call itemTypeParams.Destroy()
                    call params.Destroy()
                endmethod

                static method TrigConds takes Unit parent returns boolean
                    if not thistype.REG_GROUP.Contains(parent) then
                        return false
                    endif

                    return true
                endmethod

                trigMethod Trig
                    local Unit parent = UNIT.Event.Native.GetTrigger()

                    if not thistype.TrigConds(parent) then
                        return
                    endif

                    if thistype.IGNORE_NEXT then
                        set thistype.IGNORE_NEXT = false

                        return
                    endif

                    local Item whichItem = ITEM.Event.Native.GetTrigger()

                    if (whichItem == NULL) then
                        return
                    endif

                    if whichItem.Classes.Contains(ItemClass.POWER_UP) then
                        call parent.Items.Events.Use.StartByPowerUp(whichItem)

                        return
                    endif

                    local integer whichSlot = parent.Items.AddOnlySave(whichItem)

                    call thistype(parent).TriggerEvents(whichItem, whichSlot)
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.REG_GROUP.Remove(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.REG_GROUP.Add(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                    set thistype.REG_GROUP = UnitList.Create()

                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_PICKUP_ITEM, null)
                endmethod
            endstruct

            //! runtextmacro Struct("Lose")
                static EventType DUMMY_EVENT_TYPE
                static Trigger DUMMY_TRIGGER
                static boolean IGNORE_NEXT = false
                static UnitList REG_GROUP

                method TriggerEvents takes Item whichItem, integer whichSlot returns nothing
                    local Unit parent = this

                    local ItemType whichItemType = whichItem.Type.Get()

                    local EventResponse itemTypeParams = EventResponse.Create(whichItemType.Id.Get())

                    call itemTypeParams.Item.SetTrigger(whichItem)
                    call itemTypeParams.Item.SetTriggerSlot(whichSlot)
                    call itemTypeParams.ItemType.SetTrigger(whichItemType)
                    call itemTypeParams.Unit.SetTrigger(parent)

					local EventResponse params = EventResponse.Create(parent.Id.Get())

                    call params.Item.SetTrigger(whichItem)
                    call params.Item.SetTriggerSlot(whichSlot)
                    call params.ItemType.SetTrigger(whichItemType)
                    call params.Unit.SetTrigger(parent)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichItemType.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichItemType.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(itemTypeParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call itemTypeParams.Destroy()
                    call params.Destroy()
                endmethod

                static method TrigConds takes Unit parent returns boolean
                    if not thistype.REG_GROUP.Contains(parent) then
                        return false
                    endif

                    return true
                endmethod

                trigMethod Trig                    
                    local Unit parent = UNIT.Event.Native.GetTrigger()

                    if not thistype.TrigConds(parent) then
                        return
                    endif

                    if thistype.IGNORE_NEXT then
                        set thistype.IGNORE_NEXT = false

                        return
                    endif

                    local Item whichItem = ITEM.Event.Native.GetTrigger()

                    if (whichItem == NULL) then
                        return
                    endif

                    local integer whichSlot = parent.Items.RemoveOnlySave(whichItem)

                    call thistype(parent).TriggerEvents(whichItem, whichSlot)
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.REG_GROUP.Remove(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.REG_GROUP.Add(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                    set thistype.REG_GROUP = UnitList.Create()

                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_DROP_ITEM, null)
                endmethod
            endstruct

            //! runtextmacro Struct("MoveInInventory")
                static EventType DUMMY_EVENT_TYPE
                //! runtextmacro GetKey("KEY")
                static Event ORDER_EVENT

                static method TriggerEvents takes Item whichItem, integer whichSlot, Item targetItem, integer targetSlot, Unit whichUnit returns nothing
                    local EventResponse unitParams = EventResponse.Create(whichUnit.Id.Get())

                    call unitParams.Item.SetTarget(targetItem)
                    call unitParams.Item.SetTargetSlot(targetSlot)
                    call unitParams.Item.SetTrigger(whichItem)
                    call unitParams.Item.SetTriggerSlot(whichSlot)
                    call unitParams.Unit.SetTrigger(whichUnit)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichUnit.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichUnit.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(unitParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call unitParams.Destroy()
                endmethod

                eventMethod Event_Order
                    local Item sourceItem = params.Item.GetTarget()
                    local integer targetSlot = params.Order.GetTrigger().Data.Integer.Get(KEY)
                    local Unit whichUnit = params.Unit.GetTrigger()

                    local integer sourceSlot = whichUnit.Items.GetSlot(sourceItem)
                    local Item targetItem = whichUnit.Items.GetFromSlot(targetSlot)

                    call whichUnit.Items.SetSlotOnlySave(sourceItem, targetSlot)
                    if (targetItem != NULL) then
                        call whichUnit.Items.SetSlotOnlySave(targetItem, sourceSlot)
                    endif

                    call thistype.TriggerEvents(sourceItem, sourceSlot, targetItem, targetSlot, whichUnit)
                endmethod

                static method Create takes Order whichOrder, integer slot returns nothing
                    call whichOrder.Data.Integer.Set(KEY, slot)
                    call whichOrder.Event.Add(ORDER_EVENT)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.ORDER_EVENT = Event.Create(UNIT.Order.Events.Gain.Target.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Order)

                    call thistype.Create(Order.MOVE_ITEM_TO_SLOT_0, 0)
                    call thistype.Create(Order.MOVE_ITEM_TO_SLOT_1, 1)
                    call thistype.Create(Order.MOVE_ITEM_TO_SLOT_2, 2)
                    call thistype.Create(Order.MOVE_ITEM_TO_SLOT_3, 3)
                    call thistype.Create(Order.MOVE_ITEM_TO_SLOT_4, 4)
                    call thistype.Create(Order.MOVE_ITEM_TO_SLOT_5, 5)
                endmethod
            endstruct

            //! runtextmacro Struct("Sell")
                static EventType DUMMY_EVENT_TYPE
                static Trigger DUMMY_TRIGGER
                static UnitList REG_GROUP

                method TriggerEvents takes Unit purchaser, Item whichItem returns nothing
                    local ItemType whichItemType = whichItem.Type.Get()

                    local EventResponse itemTypeParams = EventResponse.Create(whichItemType.Id.Get())

                    call itemTypeParams.Item.SetTrigger(whichItem)
                    call itemTypeParams.ItemType.SetTrigger(whichItemType)
                    call itemTypeParams.Unit.SetTarget(purchaser)
                    call itemTypeParams.Unit.SetTrigger(this)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichItemType.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichItemType.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(itemTypeParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call itemTypeParams.Destroy()
                endmethod

                static method TrigConds takes Unit parent returns boolean
                    if not thistype.REG_GROUP.Contains(parent) then
                        return false
                    endif

                    return true
                endmethod

                trigMethod Trig
                    local Unit shop = UNIT.Event.Native.GetTrigger()

                    if not thistype.TrigConds(shop) then
                        return
                    endif

                    local Unit purchaser = UNIT.Event.Native.GetPurchaser()
                    local Item whichItem = Item.CreateFromSelf(GetSoldItem())

                    call purchaser.Effects.Create("Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL).Destroy()

                    call thistype(shop).TriggerEvents(purchaser, whichItem)
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.REG_GROUP.Remove(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.REG_GROUP.Add(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)

                    set thistype.REG_GROUP = UnitList.Create()

                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_SELL_ITEM, null)
                endmethod
            endstruct

            //! runtextmacro Struct("Use")
                static EventType DUMMY_EVENT_TYPE
                static Trigger DUMMY_TRIGGER
                static boolean IGNORE_NEXT = false
                static UnitList REG_GROUP
                static Buff SCROLL_COOLDOWN_BUFF

                method TriggerSpells_Enum takes Item whichItem, Spell whichSpell, integer level, Item targetItem, Unit targetUnit, real targetX, real targetY returns nothing
                    local SpellInstance whichInstance = SpellInstance.Create(this, whichSpell)

                    call whichInstance.SetLevel(level)
                    call whichInstance.SetTargetItem(targetItem)
                    call whichInstance.SetTargetUnit(targetUnit)
                    call whichInstance.SetTargetX(targetX)
                    call whichInstance.SetTargetY(targetY)

                    call Unit(this).Abilities.Events.Effect.StartByItem(whichInstance, whichItem)
                endmethod

                method TriggerSpells takes Item whichItem returns nothing
                    local integer iteration = whichItem.Abilities.Count()
                    local integer level
                    local SpellInstance triggerInstance = Unit(this).Abilities.Events.Effect.GetSpellInstance()
                    local Spell whichSpell

                    local Item targetItem = triggerInstance.GetTargetItem()
                    local Unit targetUnit = triggerInstance.GetTargetUnit()
                    local real targetX = triggerInstance.GetTargetX()
                    local real targetY = triggerInstance.GetTargetY()

                    loop
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                        set whichSpell = whichItem.Abilities.Get(iteration)

                        set level = whichItem.Abilities.GetLevel(whichSpell)

                        call this.TriggerSpells_Enum(whichItem, whichSpell, level, targetItem, targetUnit, targetX, targetY)

                        set iteration = iteration - 1
                    endloop
                endmethod

                method TriggerEvents takes Item whichItem returns nothing
                    local ItemType whichItemType = whichItem.Type.Get()

                    local EventResponse itemTypeParams = EventResponse.Create(whichItemType.Id.Get())

                    call itemTypeParams.Item.SetTrigger(whichItem)
                    call itemTypeParams.ItemType.SetTrigger(whichItemType)
                    call itemTypeParams.Unit.SetTrigger(this)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichItemType.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichItemType.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(itemTypeParams)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call itemTypeParams.Destroy()

                    call this.TriggerSpells(whichItem)
                endmethod

                static method TrigConds takes Unit parent returns boolean
                    if not thistype.REG_GROUP.Contains(parent) then
                        return false
                    endif

                    return true
                endmethod

                method Start takes Item whichItem returns nothing
                    local boolean isScroll = whichItem.Classes.Contains(ItemClass.SCROLL)

                    if (not isScroll or not Unit(this).Buffs.Contains(thistype.SCROLL_COOLDOWN_BUFF)) then
                        call this.TriggerEvents(whichItem)
                    endif

                    if isScroll then
                        call Unit(this).Buffs.Timed.Start(thistype.SCROLL_COOLDOWN_BUFF, 1, 0.01)

                        call whichItem.ChargesAmount.Update()
                    elseif whichItem.Classes.Contains(ItemClass.POWER_UP) then
                        call whichItem.Destroy()
                    else
                        if (whichItem.ChargesAmount.Get() > 0) then
                            call whichItem.ChargesAmount.Subtract(1)
                        endif
                    endif
                endmethod

                method StartByPowerUp takes Item whichItem returns nothing
                    //call this.TriggerSpells(whichItem)

                    call this.Start(whichItem)
                endmethod

                trigMethod Trig
                    local Unit parent = UNIT.Event.Native.GetTrigger()

                    if not thistype.TrigConds(parent) then
                        return
                    endif

                    local Item whichItem = ITEM.Event.Native.GetTrigger()

                    call thistype(parent).Start(whichItem)
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.REG_GROUP.Remove(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.REG_GROUP.Add(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                    set thistype.REG_GROUP = UnitList.Create()
                    set thistype.SCROLL_COOLDOWN_BUFF = Buff.CreateHidden(thistype.NAME)

                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_USE_ITEM, null)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Events")
            //! runtextmacro LinkToStruct("Events", "Gain")
            //! runtextmacro LinkToStruct("Events", "Lose")
            //! runtextmacro LinkToStruct("Events", "MoveInInventory")
            //! runtextmacro LinkToStruct("Events", "Sell")
            //! runtextmacro LinkToStruct("Events", "Use")

            method Event_Destroy takes nothing returns nothing
                call this.Gain.Event_Destroy()
                call this.Lose.Event_Destroy()
                call this.Sell.Event_Destroy()
                call this.Use.Event_Destroy()
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Gain.Event_Create()
                call this.Lose.Event_Create()
                call this.Sell.Event_Create()
                call this.Use.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                call thistype(NULL).Gain.Init()
                call thistype(NULL).Lose.Init()
                call thistype(NULL).MoveInInventory.Init()
                call thistype(NULL).Sell.Init()
                call thistype(NULL).Use.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Items")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
        //! runtextmacro GetKeyArray("SLOT_KEY_ARRAY_DETAIL")

        //! runtextmacro LinkToStruct("Items", "Events")

        method GetFromSlot takes integer slot returns Item
            return Unit(this).Data.Integer.Get(KEY_ARRAY_DETAIL + slot)
        endmethod

        method GetInventorySize takes nothing returns integer
            return UnitInventorySize(Unit(this).self)
        endmethod

        method GetFirstFreeIndex takes nothing returns integer
            local integer inventorySize = this.GetInventorySize() - 1
            local integer iteration = 0

            loop
                exitwhen (iteration > inventorySize)

                if (this.GetFromSlot(iteration) == NULL) then
                    return iteration
                endif

                set iteration = iteration + 1
            endloop

            return -1
        endmethod

        method GetFirstOfType takes ItemType whichType returns Item
            local integer inventorySize = this.GetInventorySize() - 1
            local integer iteration = 0
            local Item thisItem

            loop
                exitwhen (iteration > inventorySize)

                set thisItem = this.GetFromSlot(iteration)

                if (thisItem.Type.Get() == whichType) then
                    return thisItem
                endif

                set iteration = iteration + 1
            endloop

            return NULL
        endmethod

        method GetSlot takes Item whichItem returns integer
            local integer result = Unit(this).Data.Integer.Get(SLOT_KEY_ARRAY_DETAIL + whichItem)

            if (result == HASH_TABLE.Integer.DEFAULT_VALUE) then
                return -1
            endif

            return (result - HASH_TABLE.Integer.DEFAULT_VALUE - 1)
        endmethod

        method Contains takes Item whichItem returns boolean
            return (this.GetSlot(whichItem) != -1)
        endmethod

        method RemoveOnlySave takes Item whichItem returns integer
            if not whichItem.Classes.Contains(ItemClass.POWER_UP) then
                local integer whichSlot = this.GetSlot(whichItem)

                call Unit(this).Data.Integer.Remove(KEY_ARRAY_DETAIL + whichSlot)
                call Unit(this).Data.Integer.Remove(SLOT_KEY_ARRAY_DETAIL + whichItem)
                call whichItem.SetSlot(-1)

                return whichSlot
            endif

            return -1
        endmethod

        method Remove takes Item whichItem returns nothing
            call this.RemoveOnlySave(whichItem)

            call whichItem.Position.Set(Unit(this).Position.X.Get(), Unit(this).Position.Y.Get())
        endmethod

        method SetSlotOnlySave takes Item whichItem, integer slot returns nothing
            call Unit(this).Data.Integer.Remove(KEY_ARRAY_DETAIL + this.GetSlot(whichItem))
            call Unit(this).Data.Integer.Remove(SLOT_KEY_ARRAY_DETAIL + whichItem)

            call Unit(this).Data.Integer.Set(KEY_ARRAY_DETAIL + slot, whichItem)
            call Unit(this).Data.Integer.Set(SLOT_KEY_ARRAY_DETAIL + whichItem, HASH_TABLE.Integer.DEFAULT_VALUE + 1 + slot)
            call whichItem.SetSlot(slot)
        endmethod

        method SetSlot takes Item whichItem, integer slot returns nothing
            call this.SetSlotOnlySave(whichItem, slot)

            call UnitDropItemSlot(Unit(this).self, whichItem.self, slot)
        endmethod

        method AddOnlySave takes Item whichItem returns integer
            if whichItem.Classes.Contains(ItemClass.POWER_UP) then
                return -1
            endif

            local integer whichSlot = this.GetFirstFreeIndex()

            call Unit(this).Data.Integer.Set(KEY_ARRAY_DETAIL + whichSlot, whichItem)
            call Unit(this).Data.Integer.Set(SLOT_KEY_ARRAY_DETAIL + whichItem, HASH_TABLE.Integer.DEFAULT_VALUE + 1 + whichSlot)
            call whichItem.SetSlot(whichSlot)

            return whichSlot
        endmethod

        method Add takes Item whichItem returns nothing
            call UnitAddItem(Unit(this).self, whichItem.self)
        endmethod

        method AddPowerup takes nothing returns nothing
        endmethod

        method Create takes ItemType whichType, boolean test returns nothing
            call this.Add(Item.Create(whichType, Unit(this).Position.X.Get(), Unit(this).Position.Y.Get()))
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Events.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Events.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Classes")
        static Event DESTROY_EVENT

        UnitList dummyGroup

        method Contains takes UnitClass whichType returns boolean
            return thistype(whichType).dummyGroup.Contains(this)
        endmethod

        method IsNative takes unittype whichUnitType returns boolean
            return IsUnitType(Unit(this).self, whichUnitType)
        endmethod

        method Remove takes UnitClass whichType returns nothing
            static if DEBUG then
                if not this.Contains(whichType) then
                    call DebugEx(thistype.NAME + ": cannot remove class " + whichType.GetName() + " from " + Unit(this).GetName())

                    return
                endif
            endif

            call thistype(whichType).dummyGroup.Remove(this)
        endmethod

        method RemoveNative takes unittype whichUnitType returns nothing
            call UnitRemoveType(Unit(this).self, whichUnitType)
        endmethod

        method Clear takes nothing returns nothing
            local integer iteration = UnitClass.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                if this.Contains(UnitClass.ALL[iteration]) then
                    call this.Remove(UnitClass.ALL[iteration])
                endif

                set iteration = iteration - 1
            endloop
        endmethod

        method Add takes UnitClass whichType returns nothing
            static if DEBUG then
                if this.Contains(whichType) then
                    call DebugEx(thistype.NAME + ": " + Unit(this).GetName() + " is already of class " + whichType.GetName())

                    return
                endif
            endif

            call thistype(whichType).dummyGroup.Add(this)
        endmethod

        method AddIllusion takes nothing returns nothing
            local integer iteration = Unit(this).Abilities.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call Unit(this).Abilities.Remove(Unit(this).Abilities.Get(iteration))

                set iteration = iteration - 1
            endloop
            call this.Add(UnitClass.ILLUSION)
        endmethod

        method AddNative takes unittype whichUnitType returns nothing
            call UnitAddType(Unit(this).self, whichUnitType)
        endmethod

        eventMethod Event_TypeChange
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            local integer iteration = targetType.Classes.Count()

            call this.Clear()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Add(targetType.Classes.Get(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        eventMethod Event_Destroy
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            call parent.Event.Remove(thistype.DESTROY_EVENT)

            call this.Clear()
        endmethod

        method Event_Create takes nothing returns nothing
            local UnitType thisType = Unit(this).Type.Get()

            local integer iteration = thisType.Classes.Count()

            call Unit(this).Event.Add(thistype.DESTROY_EVENT)

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Add(thisType.Classes.Get(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        static method Create takes UnitClass whichClass returns thistype
            local thistype this = whichClass

            set this.dummyGroup = UnitList.Create()

            return this
        endmethod

        static method Init takes nothing returns nothing
            local integer iteration = UnitClass.ALL_COUNT

            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            loop
                exitwhen (iteration < ARRAY_MIN)

                call thistype.Create(UnitClass.ALL[iteration])

                set iteration = iteration - 1
            endloop
        endmethod
    endstruct

    //! runtextmacro Struct("Type")
        static EventType DUMMY_EVENT_TYPE

        UnitType value

        //! textmacro Unit_Type_CreateChangerAbility takes doExternal, var, raw, sourceType, targetType, morphType
            static integer $var$ = '$raw$'

            /*$doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
                //! i function set(field, value)
                    //! i makechange(current, field, value)
                //! i end

                //! i function setl(field, level, value)
                    //! i makechange(current, field, level, value)
                //! i end

                //! i setobjecttype("abilities")

                //! i morphType = "$morphType$"

                //! i if ((morphType == "") or (morphType == "normal")) then
                    //! i createobject("Abrf", "$raw$")

                    //! i set("anam", "Unit Type Changer Ability")
                    //! i set("ansf", "($sourceType$ to $targetType$)")
                    //! i set("areq", "")

                    //! i setl("Emeu", 1, "$sourceType$")
                    //! i setl("Eme1", 1, "$targetType$")
                //! i elseif (morphType == "corporal") then
                    //! i createobject("Acpf", "$raw$")

                    //! i set("anam", "Unit Type Changer Ability")
                    //! i set("ansf", "($sourceType$ to $targetType$)")

                    //! i setl("Emeu", 1, "$sourceType$")
                    //! i setl("Eme1", 1, "$targetType$")
                //! i elseif (morphType == "corporalRevert") then
                    //! i createobject("Aetf", "$raw$")

                    //! i set("anam", "Unit Type Changer Ability")
                    //! i set("ansf", "($sourceType$ to $targetType$)")

                    //! i setl("Emeu", 1, "$sourceType$")
                    //! i setl("Eme1", 1, "$targetType$")
                //! i end
            $doExternal$//! endexternalblock*/
        //! endtextmacro

        method Get takes nothing returns UnitType
            return this.value
        endmethod

        method TriggerEvents takes UnitType sourceType, UnitType targetType returns nothing
        	local Unit parent = this
        	
            local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

            call params.Unit.SetTrigger(parent)
            call params.UnitType.SetSource(sourceType)
            call params.UnitType.SetTarget(targetType)
            call params.UnitType.SetTrigger(targetType)

            local EventResponse parentParams = EventResponse.Create(parent.Id.Get())

            call parentParams.Unit.SetTrigger(parent)
            call parentParams.UnitType.SetSource(sourceType)
            call parentParams.UnitType.SetTarget(targetType)
            call parentParams.UnitType.SetTrigger(targetType)

            local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(parentParams)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
            call parentParams.Destroy()
        endmethod

        method Set takes UnitType targetType returns nothing
            local UnitType sourceType = this.Get()

            set this.value = targetType

            if ((sourceType == NULL) or (sourceType == targetType)) then
                return
            endif

            call this.TriggerEvents(sourceType, targetType)
        endmethod

        method SetWithChangerAbility takes UnitType targetType, integer abil returns nothing
            call Unit(this).Abilities.AddBySelf(abil)

            call Unit(this).Abilities.RemoveBySelf(abil)

            call this.Set(targetType)
        endmethod

        trigMethod UpgradeFinishTrig
            local thistype this = Unit.GetFromSelf(GetTriggerUnit())

            call this.Set(UnitType.GetFromSelf(GetUnitTypeId(GetTriggerUnit())))

            call Unit(this).Stop()
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = UnitType.GetFromSelf(GetUnitTypeId(Unit(this).self))
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DUMMY_EVENT_TYPE = EventType.Create()
            call Trigger.CreateFromCode(function thistype.UpgradeFinishTrig).RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_UPGRADE_FINISH, null)
        endmethod
    endstruct

    //! textmacro CreateSimpleUnitTimedAction takes actionFunction
        Timer durationTimer
        Unit whichUnit

        static method Ending takes Timer durationTimer, Unit parent returns nothing
            local thistype this = durationTimer.GetData()

            call this.deallocate()
            call durationTimer.Destroy()
            call parent.Data.Integer.Remove(KEY)
        endmethod

        static method CancelByParent takes Unit parent returns nothing
            local thistype this = parent.Data.Integer.Get(KEY)

            call this.Ending(this.durationTimer, parent)
        endmethod

        timerMethod EndingByTimer
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local Unit parent = this.parent

            call this.Ending(durationTimer, parent)

            call parent.$actionFunction$()
        endmethod

        method Start takes real timeOut returns nothing
            local Unit parent = this

            set this = thistype.allocate()

			local Timer durationTimer = Timer.Create()

            set this.durationTimer = durationTimer
            set this.parent = parent
            call durationTimer.SetData(this)
            call parent.Data.Integer.Set(KEY, this)

            call durationTimer.Start(timeOut, false, function thistype.EndingByTimer)
        endmethod
    //! endtextmacro

    //! textmacro Unit_CreateStateWithPermanentAbilities takes name, waitForSelection
        static constant boolean WAIT_FOR_SELECTION = $waitForSelection$

        real value

        method Get takes nothing returns real
            return this.value
        endmethod

        static if $waitForSelection$ then
            static Event SELECTION_EVENT

            real nativeValue
            boolean waitForSelection

            method SetNative takes real value, real oldValue returns nothing
                set this.nativeValue = value

                call BJUnit.$name$.Set(Unit(this).self, value, oldValue)
            endmethod

            eventMethod Event_Selection
                local thistype this = params.Unit.GetTrigger()

                set this.waitForSelection = false
                call Unit(this).Event.Remove(SELECTION_EVENT)

                call this.SetNative(this.Get(), this.nativeValue)
            endmethod

            method SetDisplay takes real value returns nothing
                local real nativeValue = this.nativeValue

                set this.value = value

                if (value == nativeValue) then
                    if this.waitForSelection then
                        set this.waitForSelection = false
                        call Unit(this).Event.Remove(SELECTION_EVENT)
                    endif

                    return
                endif

                if Unit(this).Selection.IsEmpty() then
                    if not this.waitForSelection then
                        set this.waitForSelection = true
                        call Unit(this).Event.Add(SELECTION_EVENT)
                    endif
                else
                    call this.SetNative(value, nativeValue)
                endif
            endmethod
        else
            method SetDisplay takes real value returns nothing
                local real oldValue = this.Get()

                set this.value = value
                call BJUnit.$name$.Set(Unit(this).self, value, oldValue)
            endmethod
        endif

        method AddOnlySave takes real value returns nothing
            set this.value = this.Get() + value
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0.
            static if $waitForSelection$ then
                set this.nativeValue = 0.
                set this.waitForSelection = false
            endif
        endmethod
    //! endtextmacro

    //! runtextmacro Struct("Color")
        //! runtextmacro CreateSimpleAddState_OnlyGet("playercolor")

        method Set takes playercolor value returns nothing
            set this.value = value
            call SetUnitColor(Unit(this).self, value)
        endmethod

        method Update takes nothing returns nothing
            call SetUnitColor(Unit(this).self, this.Get())
        endmethod
    endstruct

    //! runtextmacro Struct("Owner")
        static EventType DUMMY_EVENT_TYPE

        User owner

        method Get takes nothing returns User
            return this.owner
        endmethod

        method TriggerEvents takes User value, User oldValue
            local Unit parent = this

            local EventResponse params = EventResponse.Create(parent.Id.Get())

            call params.Unit.SetTrigger(this)
            call params.User.SetSource(oldValue)
            call params.User.SetTarget(value)
            call params.User.SetTrigger(value)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
        endmethod

		method SetNative takes User value, boolean doColor
			if (GetOwningPlayer(Unit(this).self) == value.self) then
				return
			endif

            if not GetPlayerAlliance(value.self, GetLocalPlayer(), ALLIANCE_SHARED_CONTROL) then
                //call SelectUnit(Unit(this).self, false)
            endif

			call SetUnitOwner(Unit(this).self, value.self, doColor)
		endmethod

        method Set takes User value
            local User oldValue = this.Get()

            set this.owner = value
            if Unit(this).Madness.Is() then
                call this.SetNative(User.NEUTRAL_AGGRESSIVE, true)
            else
                call this.SetNative(value, true)
            endif

            call Unit(this).Color.Set(value.GetColor())

            if (value == oldValue) then
                return
            endif

            call this.TriggerEvents(value, oldValue)
        endmethod

		method Update takes nothing returns nothing
			call this.Set(this.Get())
		endmethod

        method Event_Create takes User value returns nothing
            set this.owner = value

            call Unit(this).Color.Set(value.GetColor())
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DUMMY_EVENT_TYPE = EventType.Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Armor")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).Armor.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_TypeChange
                local UnitType sourceType = params.UnitType.GetSource()
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.Add(targetType.Armor.Get() - sourceType.Armor.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = Unit(this).Type.Get().Armor.Get()
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Folder("Bonus")
            //! runtextmacro Struct("Displayed")
                //! runtextmacro Unit_CreateStateWithPermanentAbilities("Armor.Bonus", "true")

				method Set takes real val returns nothing
					call this.SetDisplay(val)
				endmethod

                method Update takes nothing returns nothing
                    call this.Set(Unit(this).Armor.Base.Get() * (Unit(this).Armor.Relative.Get() - 1) + Unit(this).Armor.Bonus.Get())
                endmethod

                static method Init takes nothing returns nothing
                    static if thistype.WAIT_FOR_SELECTION then
                        set thistype.SELECTION_EVENT = Event.Create(UNIT.Selection.START_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Selection)
                    endif
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Bonus")
            static UnitState STATE

            //! runtextmacro LinkToStruct("Bonus", "Displayed")

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).Armor.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.

                call this.Displayed.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)

                call thistype(NULL).Displayed.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("IgnoreDamage")
            //! runtextmacro Struct("Relative")
                //! runtextmacro CreateSimpleAddState("real", "0.")
            endstruct
        endscope

        //! runtextmacro Struct("IgnoreDamage")
            //! runtextmacro LinkToStruct("IgnoreDamage", "Relative")

            //! runtextmacro CreateSimpleAddState_NotStart("real")

            method Event_Create takes nothing returns nothing
                call this.Relative.Event_Create()
            endmethod
        endstruct

        //! runtextmacro Folder("Relative")
            //! runtextmacro Struct("Invisible")
                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    call Unit(this).Armor.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                method Event_Create takes nothing returns nothing
                    set this.value = 1.
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Relative")
        	static UnitState STATE

            //! runtextmacro LinkToStruct("Relative", "Invisible")

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).Armor.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 1.

                call Invisible.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct

        //! runtextmacro Struct("Resistance")
            static UnitState STATE

            //! runtextmacro CreateSimpleAddState("real", "0.")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct

        //! runtextmacro Struct("Spell")
        	static UnitState STATE

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

			//! runtextmacro CreateSimpleAddState_NotStart("real")

			method Event_Create
				set this.value = 0.
			endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct

        //! runtextmacro Struct("TypeA")
            //! runtextmacro CreateSimpleAddState("integer", "Unit(this).Type.Get().Armor.Type.Get()")

            eventMethod Event_TypeChange
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.Set(targetType.Armor.Type.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Armor")
        //! runtextmacro LinkToStruct("Armor", "Base")
        //! runtextmacro LinkToStruct("Armor", "Bonus")
        //! runtextmacro LinkToStruct("Armor", "IgnoreDamage")
        //! runtextmacro LinkToStruct("Armor", "Relative")
        //! runtextmacro LinkToStruct("Armor", "Resistance")
        //! runtextmacro LinkToStruct("Armor", "Spell")
        //! runtextmacro LinkToStruct("Armor", "TypeA")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        real visVal
        real visBonusVal

        static method GetDamageFactor takes real value returns real
            if (value < 0.) then
                return (2. - Math.Power((1. - Attack.ARMOR_REDUCTION_FACTOR), -value))
            endif

            return (1. / (1. + Attack.ARMOR_REDUCTION_FACTOR * value))
        endmethod

        method GetVisible takes nothing returns real
            return this.visVal
        endmethod

        method GetVisibleBonus takes nothing returns real
            return this.visBonusVal
        endmethod

        method Set takes real value returns nothing
            set this.value = value

            call this.Bonus.Displayed.Update()
        endmethod

        method Update takes nothing returns nothing
            local real baseVal = this.Base.Get()
            local real relVal = this.Relative.Get()
            local real bonusVal = this.Bonus.Get()

            set this.visVal = baseVal * relVal + bonusVal
            set this.visBonusVal = baseVal * (relVal - 1) + bonusVal
            call this.Set(baseVal * relVal * this.Relative.Invisible.Get() + bonusVal)
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0.
            set this.visVal = 0.
            set this.visBonusVal = 0.

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()
            call this.IgnoreDamage.Event_Create()
            call this.Relative.Event_Create()
            call this.Resistance.Event_Create()
            call this.Spell.Event_Create()
            call this.TypeA.Event_Create()

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Base.Init()
            call thistype(NULL).Bonus.Init()
            call thistype(NULL).Relative.Init()
            call thistype(NULL).Resistance.Init()
            call thistype(NULL).Spell.Init()
            call thistype(NULL).TypeA.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Attack")
        //! runtextmacro Folder("Events")
            //! runtextmacro Struct("Acquire2")
                static Event DESTROY_EVENT
                static EventType DUMMY_EVENT_TYPE

                Timer delayTimer
                boolean running
                Unit target

                method Ending takes Timer delayTimer, Unit parent returns nothing
                    local Unit target = this.target

                    call delayTimer.Destroy()

                    set this.running = false

                    call target.Refs.Subtract()
                endmethod

                eventMethod Event_Destroy
                    local Unit parent = params.Unit.GetTrigger()

                    local thistype this = parent

                    call parent.Event.Remove(DESTROY_EVENT)

                    if this.running then
                        call this.Ending(this.delayTimer, parent)
                    endif
                endmethod

                method TriggerEvents takes Unit target returns nothing
                    local Unit parent = this

                    local EventResponse params = EventResponse.Create(parent.Id.Get())

                    call params.Unit.SetTarget(target)
                    call params.Unit.SetTrigger(this)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = Unit(this).Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call params.Destroy()
                endmethod

                timerMethod EndingByTimer
                    local Timer delayTimer = Timer.GetExpired()

                    local thistype this = delayTimer.GetData()

                    call this.Ending(delayTimer, this)

                    call this.TriggerEvents(target)
                endmethod

                method Start takes Unit target returns nothing
                    local Timer delayTimer = Timer.Create()

                    if this.running then
                        call this.Ending(this.delayTimer, this)
                    endif

                    set this.delayTimer = delayTimer
                    set this.running = true
                    set this.target = target
                    call delayTimer.SetData(this)

                    call target.Refs.Add()

                    call delayTimer.Start(0.01, false, function thistype.EndingByTimer)
                endmethod

                method Event_Create takes nothing returns nothing
                    set this.running = false
                    call Unit(this).Event.Add(DESTROY_EVENT)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                endmethod
            endstruct

            //! runtextmacro Struct("Ground")
                static Event ATTACK_EVENT
                static Trigger DAMAGE_TRIGGER
                static Event DESTROY_EVENT
                static EventType DUMMY_EVENT_TYPE
                static Event DUMMY_UNIT_DESTROY_EVENT
                static constant real DURATION_TOLERANCE = 2.
                static Group ENUM_GROUP
                static UnitList ENUM_GROUP2
                //! runtextmacro GetKey("KEY")
                //! runtextmacro GetKeyArray("KEY_ARRAY")
                static constant real MAX_DURATION = 30.
                static BoolExpr TARGET_FILTER

                Unit parent

                method DealPhysical_Single takes Unit target, real amount, integer whichType returns nothing
                    set amount = amount * (1. - target.Armor.IgnoreDamage.Relative.Get())

                    set amount = amount * UNIT.Armor.GetDamageFactor(target.Armor.Get())

                    set amount = amount * Attack.Get(whichType, target.Armor.TypeA.Get())

                    call target.Death.Explosion.Add()

                    call Unit(this).DamageUnit(target, amount, false)

                    call target.Death.Explosion.Subtract()
                endmethod

                condMethod Conditions
                    local Unit target = UNIT.Event.Native.GetFilter()

                    if (not TEMP_BOOLEAN and target.IsAllyOf(User.TEMP)) then
                        return false
                    endif

                    if target.Classes.Contains(UnitClass.DEAD) then
                        return false
                    endif
                    if not target.Classes.Contains(UnitClass.GROUND) then
                        return false
                    endif

                    return true
                endmethod

                method DealPhysical takes real x, real y returns nothing
                    local boolean affectsAlly = Unit(this).Attack.Splash.TargetFlag.Is(TargetFlag.ALLY)
                    local real damageAmount = Unit(this).Damage.Get() + Unit(this).Damage.Bonus.Get()
                    local integer damageSides = Unit(this).Damage.Sides.Get()
                    local integer damageType = Unit(this).Damage.TypeA.Get()
                    local integer iteration = Unit(this).Damage.Dices.Get()
                    local integer iterationEnd = Unit(this).Attack.Splash.Count()
                    local User parentOwner = Unit(this).Owner.Get()
                    local real rangeDamageAmount
                    local UnitAttackSplash splash
                    local Unit target
                    local real array targetFactorAll

                    loop
                        exitwhen (iteration < 1)

                        set damageAmount = damageAmount + Math.RandomI(1, damageSides)

                        set iteration = iteration - 1
                    endloop

                    set damageAmount = damageAmount * Unit(this).Damage.Relative.Get() * Unit(this).Damage.Relative.Invisible.Get()
                    set iteration = Memory.IntegerKeys.Table.STARTED

                    loop
                        exitwhen (iteration > iterationEnd)

                        set splash = Unit(this).Attack.Splash.Get(iteration)

                        set TEMP_BOOLEAN = affectsAlly
                        set User.TEMP = parentOwner

                        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, splash.GetAreaRange(), thistype.TARGET_FILTER)

                        loop
                            set target = thistype.ENUM_GROUP.FetchFirst()

                            exitwhen (target == NULL)

                            if not thistype.ENUM_GROUP2.Contains(target) then
                                set targetFactorAll[target] = 0.
                                call thistype.ENUM_GROUP2.Add(target)
                            endif

                            set targetFactorAll[target] = targetFactorAll[target] + splash.GetDamageFactor()
                        endloop

                        set iteration = iteration + 1
                    endloop

                    loop
                        set target = thistype.ENUM_GROUP2.FetchFirst()

                        exitwhen (target == NULL)

                        call this.DealPhysical_Single(target, damageAmount * targetFactorAll[target], damageType)
                    endloop
                endmethod

                method TriggerEvents takes real x, real y returns nothing
                    local Unit parent = this

                    local EventResponse params = EventResponse.Create(parent.Id.Get())

                    call params.Spot.SetTargetX(x)
                    call params.Spot.SetTargetY(y)
                    call params.Unit.SetTrigger(this)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call params.Destroy()

                    call this.DealPhysical(x, y)
                endmethod

                eventMethod Event_Destroy
                    local Unit parent = params.Unit.GetTrigger()

                    call parent.Event.Remove(ATTACK_EVENT)
                    call parent.Event.Remove(DESTROY_EVENT)
                endmethod

                method Ending takes DummyUnit dummyUnit, Unit parent returns nothing
                    call this.deallocate()

                    call dummyUnit.Data.Integer.Remove(KEY)
                    call dummyUnit.Event.Remove(DUMMY_UNIT_DESTROY_EVENT)
                    call parent.Data.Integer.Table.Remove(KEY_ARRAY, this)

                    call parent.Refs.Subtract()
                endmethod

                eventMethod Event_DummyUnitDestroy
                    local DummyUnit dummyUnit = params.DummyUnit.GetTrigger()

                    local thistype this = dummyUnit.Data.Integer.Get(KEY)

                    call this.Ending(dummyUnit, this.parent)
                endmethod

                trigMethod DamageTrig
                    local DummyUnit dummyUnit = DUMMY_UNIT.Event.Native.GetTrigger()
                    local Unit parent = UNIT.Event.Native.GetDamager()

                    local thistype this = dummyUnit.Data.Integer.Get(KEY)

                    if (parent != this.parent) then
                        return
                    endif

                    local real x = dummyUnit.Position.X.Get()
                    local real y = dummyUnit.Position.Y.Get()

                    call this.Ending(dummyUnit, parent)

                    call thistype(parent).TriggerEvents(x, y)
                endmethod

                eventMethod Event_Attack
                    local Unit target = params.Unit.GetTarget()
                    local Unit parent = params.Unit.GetTrigger()

                    local real targetX = target.Position.X.Get()
                    local real targetY = target.Position.Y.Get()

					local thistype this = thistype.allocate()

                    local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, targetX, targetY, 0., 0.)

                    set this.parent = parent
                    call thistype.DAMAGE_TRIGGER.RegisterEvent.DummyUnit(dummyUnit, EVENT_UNIT_DAMAGED)
                    call dummyUnit.Data.Integer.Set(KEY, this)
                    call dummyUnit.Event.Add(DUMMY_UNIT_DESTROY_EVENT)
                    call parent.Data.Integer.Table.Add(KEY_ARRAY, this)
                    call parent.Refs.Add()

                    call dummyUnit.DestroyTimed.Start(Math.DistanceByDeltas(targetX - parent.Position.X.Get(), targetY - parent.Position.Y.Get()) / parent.Attack.Missile.Speed.Get() + thistype.DURATION_TOLERANCE)
                endmethod

                eventMethod Event_TypeChange
                    local Unit parent = params.Unit.GetTrigger()
                    local UnitType sourceType = params.UnitType.GetSource()
                    local UnitType targetType = params.UnitType.GetTrigger()

                    local boolean hasArtillery = (targetType.Attack.Get() == Attack.ARTILLERY)

                    if ((sourceType.Attack.Get() == Attack.ARTILLERY) == hasArtillery) then
                        return
                    endif

                    if hasArtillery then
                        call parent.Event.Add(ATTACK_EVENT)
                        call parent.Event.Add(DESTROY_EVENT)
                    else
                        call parent.Event.Remove(ATTACK_EVENT)
                        call parent.Event.Remove(DESTROY_EVENT)
                    endif
                endmethod

                eventMethod Event_Create
                    local Unit parent = params.Unit.GetTrigger()

                    if (parent.Attack.GetType() == Attack.ARTILLERY) then
                        call parent.Event.Add(ATTACK_EVENT)
                        call parent.Event.Add(DESTROY_EVENT)
                    endif
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DAMAGE_TRIGGER = Trigger.CreateFromCode(function thistype.DamageTrig)
                    set thistype.ATTACK_EVENT = Event.Create(UNIT.Attack.Events.DUMMY_EVENT_TYPE, EventPriority.EVENTS, function thistype.Event_Attack)
                    set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.EVENTS, function thistype.Event_Destroy)
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_UNIT_DESTROY_EVENT = Event.Create(DummyUnit.DESTROY_EVENT_TYPE, EventPriority.EVENTS, function thistype.Event_DummyUnitDestroy)
                    set thistype.ENUM_GROUP = Group.Create()
                    set thistype.ENUM_GROUP2 = UnitList.Create()
                    set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
                    //call Event.Create(Unit.CREATE_EVENT_TYPE, EventPriority.EVENTS, function thistype.Event_Create).AddToStatics()
                    call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Events")
            static EventType ACQUIRE_EVENT_TYPE
            static Trigger ACQUIRE_TRIGGER

            static EventType DUMMY_EVENT_TYPE
            static Trigger DUMMY_TRIGGER

            static EventType OFFENDED_EVENT_TYPE
            static UnitList OFFENDED_REG_GROUP
            static EventType OFFENDED_REVERSED_EVENT_TYPE
            static Trigger OFFENDED_TRIGGER

            //! runtextmacro LinkToStruct("Events", "Acquire2")
            //! runtextmacro LinkToStruct("Events", "Ground")

            method TriggerEvents takes Unit target returns nothing
                local Unit parent = this

                local UnitType parentType = parent.Type.Get()

                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.Unit.SetTarget(target)
                call params.Unit.SetTrigger(this)

				local EventResponse typeParams = EventResponse.Create(parentType.Id.Get())

                call typeParams.Unit.SetTarget(target)
                call typeParams.Unit.SetTrigger(this)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = parentType.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parentType.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(typeParams)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
                call typeParams.Destroy()
            endmethod

            trigMethod Trig
                local Unit parent = UNIT.Event.Native.GetTrigger()
                local Unit target = UNIT.Event.Native.GetAcquiredTarget()

                call thistype(parent).TriggerEvents(target)
            endmethod

            method Acquire_TriggerEvents takes Unit target returns nothing
                local Unit parent = this

                local UnitType parentType = parent.Type.Get()

                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.Unit.SetTarget(target)
                call params.Unit.SetTrigger(this)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.ACQUIRE_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.ACQUIRE_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
            endmethod

            trigMethod AcquireTrig
                local Unit parent = UNIT.Event.Native.GetTrigger()
                local Unit target = UNIT.Event.Native.GetAcquiredTarget()

                if (target.IsEnemyOf(parent.Owner.Get()) and (target.Order.Get() == NULL)) then
                    call parent.Order.UnitTarget(Order.ATTACK, target)
                endif

                call thistype(parent).Acquire_TriggerEvents(target)

                call thistype(parent).Acquire2.Start(target)
            endmethod

            method Offended_TriggerEvents takes Unit attacker returns nothing
                local Unit parent = this

                local EventResponse attackerParams = EventResponse.Create(attacker.Id.Get())

                call attackerParams.Unit.SetTarget(this)
                call attackerParams.Unit.SetTrigger(attacker)

				local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.Unit.SetTarget(attacker)
                call params.Unit.SetTrigger(this)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = attacker.Event.Count(thistype.OFFENDED_REVERSED_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call attacker.Event.Get(thistype.OFFENDED_REVERSED_EVENT_TYPE, priority, iteration2).Run(attackerParams)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = parent.Event.Count(thistype.OFFENDED_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.OFFENDED_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call attackerParams.Destroy()
                call params.Destroy()
            endmethod

            static method OffendedTrigConds takes Unit parent returns boolean
                if not thistype.OFFENDED_REG_GROUP.Contains(parent) then
                    return false
                endif

                return true
            endmethod

            trigMethod OffendedTrig
                local Unit parent = UNIT.Event.Native.GetTrigger()

                if not thistype.OffendedTrigConds(parent) then
                    return
                endif

                call thistype(parent).Offended_TriggerEvents(UNIT.Event.Native.GetAttacker())
            endmethod

            method Event_Destroy takes nothing returns nothing
                call thistype.OFFENDED_REG_GROUP.Remove(this)
            endmethod

            method Event_Create takes nothing returns nothing
                call thistype.ACQUIRE_TRIGGER.RegisterEvent.Unit(this, EVENT_UNIT_ACQUIRED_TARGET)

                call thistype.DUMMY_TRIGGER.RegisterEvent.Unit(this, EVENT_UNIT_TARGET_IN_RANGE)

                call thistype.OFFENDED_REG_GROUP.Add(this)

                call this.Acquire2.Event_Create()

                call this.Ground.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                set thistype.ACQUIRE_EVENT_TYPE = EventType.Create()
                set thistype.ACQUIRE_TRIGGER = Trigger.CreateFromCode(function thistype.AcquireTrig)

                set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)

                set thistype.OFFENDED_EVENT_TYPE = EventType.Create()
                set thistype.OFFENDED_REG_GROUP = UnitList.Create()
                set thistype.OFFENDED_REVERSED_EVENT_TYPE = EventType.Create()
                set thistype.OFFENDED_TRIGGER = Trigger.CreateFromCode(function thistype.OffendedTrig)

                call thistype.OFFENDED_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_ATTACKED, null)

                call thistype(NULL).Acquire2.Init()
                call thistype(NULL).Ground.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Missile")
            //! runtextmacro Struct("Speed")
                method Get takes nothing returns real
                    return Unit(this).Type.Get().Attack.Missile.Speed.Get()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Missile")
            //! runtextmacro LinkToStruct("Missile", "Speed")
        endstruct

        //! runtextmacro Struct("Range")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().Attack.Range.Get()")
        endstruct

        //! runtextmacro Folder("Speed")
            //! runtextmacro Struct("BaseA")
                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    call Unit(this).Attack.Speed.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                eventMethod Event_TypeChange
                    local UnitType sourceType = params.UnitType.GetSource()
                    local UnitType targetType = params.UnitType.GetTrigger()
                    local thistype this = params.Unit.GetTrigger()

                    call this.Add(targetType.Attack.Speed.Get() - sourceType.Attack.Speed.Get())
                endmethod

                method Event_Create takes nothing returns nothing
                    set this.value = Unit(this).Type.Get().Attack.Speed.Get()
                endmethod

                static method Init takes nothing returns nothing
                    call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
                endmethod
            endstruct

            //! runtextmacro Folder("BonusA")
                //! runtextmacro Struct("DisplayedA")
                    //! runtextmacro Unit_CreateStateWithPermanentAbilities("Attack.Speed.BonusA", "false")

					method Set takes real val returns nothing
						call this.SetDisplay(val)
					endmethod

                    method Update takes nothing returns nothing
                        call this.Set(Unit(this).Attack.Speed.BonusA.Get())
                    endmethod

                    method UpdateOnlySave takes nothing returns nothing
                        set this.value = Unit(this).Attack.Speed.BonusA.Get()
                    endmethod

                    static method Init takes nothing returns nothing
                        static if thistype.WAIT_FOR_SELECTION then
                            set thistype.SELECTION_EVENT = Event.Create(UNIT.Selection.START_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Selection)
                        endif
                    endmethod
                endstruct
            endscope

            //! runtextmacro Struct("BonusA")
                static UnitState STATE

                //! runtextmacro LinkToStruct("BonusA", "DisplayedA")

                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    call this.DisplayedA.Update()

                    call Unit(this).Attack.Speed.Update()
                endmethod

                method AddOnlySave takes real value returns nothing
                    set this.value = this.Get() + value

                    call this.DisplayedA.UpdateOnlySave()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                eventMethod Event_State
                    call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
                endmethod

                method Event_Create takes nothing returns nothing
                    set this.value = 0.

                    call this.DisplayedA.Event_Create()
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)

                    call thistype(NULL).DisplayedA.Init()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Speed")
            //! runtextmacro LinkToStruct("Speed", "BaseA")
            //! runtextmacro LinkToStruct("Speed", "BonusA")

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value
            endmethod

            method Update takes nothing returns nothing
                call this.Set(this.BaseA.Get() + this.BonusA.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                call this.BaseA.Event_Create()
                call this.BonusA.Event_Create()

                call this.Update()
            endmethod

            static method Init takes nothing returns nothing
                call thistype(NULL).BaseA.Init()
                call thistype(NULL).BonusA.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Splash")
            //! runtextmacro Struct("TargetFlag")
                //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

                method Is takes integer whichFlag returns boolean
                    return Unit(this).Type.Get().Attack.Splash.TargetFlag.Is(whichFlag)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Splash")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro GetKeyArray("TYPE_BOUND_KEY_ARRAY")

            //! runtextmacro LinkToStruct("Splash", "TargetFlag")

            method Count takes nothing returns integer
                return Unit(this).Data.Integer.Table.Count(KEY_ARRAY)
            endmethod

            method Get takes integer index returns UnitAttackSplash
                return Unit(this).Data.Integer.Table.Get(KEY_ARRAY, index)
            endmethod

            method GetMaxAreaRange takes nothing returns real
                local integer iteration = this.Count()
                local real result = 0.

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    set result = Math.Max(result, this.Get(iteration).GetAreaRange())

                    set iteration = iteration - 1
                endloop

                return result
            endmethod

            method Destroy takes UnitAttackSplash splash returns nothing
                call Unit(this).Data.Integer.Table.Remove(KEY_ARRAY, splash)

                call splash.Destroy()
            endmethod

            method Create takes real areaRange, real damageFactor returns UnitAttackSplash
                local UnitAttackSplash splash = UnitAttackSplash.Create(areaRange, damageFactor)

                call Unit(this).Data.Integer.Table.Add(KEY_ARRAY, splash)

                return splash
            endmethod

            eventMethod Event_TypeChange
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                local integer iteration = Unit(this).Data.Integer.Table.Count(TYPE_BOUND_KEY_ARRAY)

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    local UnitAttackSplash splash = Unit(this).Data.Integer.Table.Get(TYPE_BOUND_KEY_ARRAY, iteration)

                    call splash.Destroy()

                    set iteration = iteration - 1
                endloop

                call Unit(this).Data.Integer.Table.Clear(TYPE_BOUND_KEY_ARRAY)

                set iteration = targetType.Attack.Splash.Count()

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    call Unit(this).Data.Integer.Table.Add(TYPE_BOUND_KEY_ARRAY, this.Create(targetType.Attack.Splash.GetAreaRange(iteration), targetType.Attack.Splash.GetDamageFactor(iteration)))

                    set iteration = iteration - 1
                endloop
            endmethod

            method Event_Create takes nothing returns nothing
                local UnitType thisType = Unit(this).Type.Get()

                local integer iteration = thisType.Attack.Splash.Count()

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    call Unit(this).Data.Integer.Table.Add(TYPE_BOUND_KEY_ARRAY, this.Create(thisType.Attack.Splash.GetAreaRange(iteration), thisType.Attack.Splash.GetDamageFactor(iteration)))

                    set iteration = iteration - 1
                endloop

                //call this.TargetFlags.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Attack")
    	static UnitState DISABLE_STATE

        //! runtextmacro LinkToStruct("Attack", "Events")
        //! runtextmacro LinkToStruct("Attack", "Missile")
        //! runtextmacro LinkToStruct("Attack", "Range")
        //! runtextmacro LinkToStruct("Attack", "Speed")
        //! runtextmacro LinkToStruct("Attack", "Splash")

        //! runtextmacro CreateSimpleFlagState_NotStart()

        method GetType takes nothing returns Attack
            return Unit(this).Type.Get().Attack.Get()
        endmethod

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)

            call parent.Abilities.RemoveBySelf(thistype.DISABLE_SPELL_ID)
            call parent.Abilities.RemoveBySelf(thistype.ICON_SPELL_ID)
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)

            call parent.Abilities.AddBySelf(thistype.DISABLE_SPELL_ID)
            call parent.Abilities.AddBySelf(thistype.ICON_SPELL_ID)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DISABLE_BUFF, 1)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DISABLE_BUFF)
        endmethod

        method DisableTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DISABLE_BUFF, 1, duration)
        endmethod

        method Change takes boolean val returns nothing
            if val then
                call this.Add()
            else
                call this.Subtract()
            endif
        endmethod

        eventMethod Event_Disable_State
            call thistype(params.Unit.GetTrigger()).Change(not params.Bool.GetVal())
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(true)

            call this.Events.Event_Create()
            call this.Range.Event_Create()
            call this.Speed.Event_Create()
            call this.Splash.Event_Create()
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DISABLE_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DISABLE_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call thistype.NORMAL_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.NORMAL_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod

        static method Init takes nothing returns nothing
        	set thistype.DISABLE_STATE = UnitState.Create(thistype.NAME, function thistype.Event_Disable_State)

            call thistype(NULL).Events.Init()
            call thistype(NULL).Speed.Init()
            call thistype(NULL).Splash.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Blood")
        //! runtextmacro CreateSimpleAddState_NotAdd("string", "Unit(this).Type.Get().Blood.Get()")

        eventMethod Event_TypeChange
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            call this.Set(targetType.Blood.Get())
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Struct("BloodExplosion")
        //! runtextmacro CreateAnyState("summon", "Summon", "string")
        //! runtextmacro CreateAnyState("value", "", "string")

        eventMethod Event_TypeChange
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            call this.Set(targetType.BloodExplosion.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(Unit(this).Type.Get().BloodExplosion.Get())
            call this.SetSummon(null)
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Struct("CollisionSize")
        real value

        method Get takes boolean useScale returns real
            if useScale then
                return (this.value * Unit(this).Scale.Get())
            endif

            return this.value
        endmethod

        method GetSquare takes boolean useScale returns real
            return (this.Get(useScale) * this.Get(useScale))
        endmethod

        method Set takes real value returns nothing
            set this.value = value
        endmethod

        method Add takes real value, boolean useScale returns nothing
            call this.Set(this.Get(false) + value)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart("Unit(this).Type.Get().CollisionSize.Get()")

        eventMethod Event_TypeChange
            local UnitType sourceType = params.UnitType.GetSource()
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            call this.Add(targetType.CollisionSize.Get() - sourceType.CollisionSize.Get(), true)
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Folder("CriticalChanceDefense")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).CriticalChanceDefense.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).CriticalChanceDefense.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("CriticalChanceDefense")
        //! runtextmacro LinkToStruct("CriticalChanceDefense", "Base")
        //! runtextmacro LinkToStruct("CriticalChanceDefense", "Bonus")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Set takes real value returns nothing
            set this.value = value
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() + this.Bonus.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0.

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()

            call this.Update()
        endmethod
    endstruct

    //! runtextmacro Folder("CriticalChance")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).CriticalChance.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            static UnitState STATE

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).CriticalChance.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("CriticalChance")
        static constant real CHANCE_EXPONENT = 0.1
        static constant real CHANCE_FACTOR = 1.
        static constant real DAMAGE_FACTOR = 2.
        static EventType DUMMY_EVENT_TYPE

        //! runtextmacro LinkToStruct("CriticalChance", "Base")
        //! runtextmacro LinkToStruct("CriticalChance", "Bonus")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method VsUnit takes Unit target returns real
            //return (1. - 1. / (1. + thistype.CHANCE_FACTOR * Math.Power(1. + this.Get() - target.CriticalChanceDefense.Get(), thistype.CHANCE_EXPONENT) - 1.))
            return Math.Limit((this.Get() - target.CriticalChanceDefense.Get()) / 100, 0., 1.)
        endmethod

        method Random takes Unit target returns boolean
            if (Unit(this).Invisibility.Is() and not Unit(this).Invisibility.Reveal.Is()) then
                return true
            endif
            if target.Sleep.Is() then
                return true
            endif

            return (Math.Random(0., 1.) <= this.VsUnit(target))
        endmethod

		method Do_TriggerEvents takes Unit target, real amount returns nothing
			local Unit parent = this

            local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

            call params.Unit.SetTrigger(parent)
            call params.Unit.SetTarget(target)

			local EventResponse parentParams = EventResponse.Create(parent.Id.Get())

            call parentParams.Unit.SetTrigger(parent)
            call parentParams.Unit.SetTarget(target)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(parentParams)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
            call parentParams.Destroy()
		endmethod

		method Do takes Unit target, real amount returns real
			set amount = amount * thistype.DAMAGE_FACTOR

			call this.Do_TriggerEvents(target, amount)

			return amount
		endmethod

        method Set takes real value returns nothing
            set this.value = value
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() + this.Bonus.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0.

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
        	set thistype.DUMMY_EVENT_TYPE = EventType.Create()

            call thistype(NULL).Bonus.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Death")
        //! runtextmacro Struct("Explosion")
            static BoolExpr TARGET_FILTER

            condTrigMethod Conditions
                local Unit target = UNIT.Event.Native.GetFilter()

                if target.Classes.Contains(UnitClass.DEAD) then
                    return false
                endif
                if not target.Classes.Contains(UnitClass.GROUND) then
                    return false
                endif
                if target.IsAllyOf(User.TEMP) then
                    return false
                endif

                return true
            endmethod

            method SpawnBloodExplosion takes real x, real y returns nothing
                local string modelPath = Unit(this).BloodExplosion.Get()

                if (modelPath != null) then
                    //call SpotEffectWithSize.Create(x, y, modelPath, EffectLevel.LOW, Unit(this).Scale.Get()).DestroyTimed.Start(5.)
                    call SpotEffectWithSize.Create(x, y, thistype.COMMON_BLOOD_EXPLOSION_PATH, EffectLevel.LOW, Unit(this).Scale.Get()).Destroy()
                endif
            endmethod

            method SpawnBloodExplosionSummon takes real x, real y returns nothing
                local string modelPath = Unit(this).BloodExplosion.GetSummon()

                if (modelPath != null) then
                    call SpotEffectWithSize.Create(x, y, modelPath, EffectLevel.LOW, Unit(this).Scale.Get()).DestroyTimed.Start(5.)
                endif
            endmethod

            method Do takes Unit killer returns nothing
                local real damage = Unit(this).MaxLife.Get() * thistype.DAMAGE_LIFE_FACTOR
                local User killerOwner = killer.Owner.Get()

                local real x = Unit(this).Position.X.Get()
                local real y = Unit(this).Position.Y.Get()

                call this.SpawnBloodExplosion(x, y)

                /*if ((killerOwner.Team.Get() != Team.DEFENDERS) or (killerOwner == User.CASTLE) or (killerOwner == User.CASTLE_CONTROLABLE)) then
                    return
                endif*/
                if (killerOwner.Team.Get() != Team.DEFENDERS) then
                    return
                endif

				local Group explosionGroup = Group.Create()

				set User.TEMP = killer.Owner.Get()

                call explosionGroup.EnumUnits.InRange.WithCollision.Do(x, y, Unit(this).CollisionSize.Get(true) * 5, thistype.TARGET_FILTER)

				local integer count = explosionGroup.Count()

				if (count > 0) then
					set damage = damage / count

	                loop
	                    local Unit target = explosionGroup.FetchFirst()
	                    exitwhen (target == NULL)
	
	                    call killer.DamageUnit(target, damage, false)
	                endloop
                endif
            endmethod

            method Subtract takes nothing returns nothing
                call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
            endmethod

            method Add takes nothing returns nothing
                call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
            endmethod

            method Try takes Unit killer returns nothing
                if this.Is() then
                    call this.Do(killer)
                elseif Unit(this).Classes.Contains(UnitClass.SUMMON) then
                    call this.SpawnBloodExplosionSummon(Unit(this).Position.X.Get(), Unit(this).Position.Y.Get())
                endif
            endmethod

            //! runtextmacro CreateSimpleFlagState_NotStart()

            eventMethod Event_BuffLose
                local Unit parent = params.Unit.GetTrigger()

                local thistype this = parent

                call this.Set(false)
            endmethod

            eventMethod Event_BuffGain
                local Unit parent = params.Unit.GetTrigger()

                local thistype this = parent

                call this.Set(true)
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Set(false)
            endmethod

            initMethod Buff_Init of Header_Buffs
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            endmethod

            static method Init takes nothing returns nothing
                set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
            endmethod
        endstruct

        //! runtextmacro Struct("Events")
            static EventType BEFORE_EVENT_TYPE
            static EventType DUMMY_EVENT_TYPE
            static Trigger DUMMY_TRIGGER
            static Unit DYING_UNIT
            static Unit KILLER
            static EventType KILLER_EVENT_TYPE
            static boolean NEXT_DECAYS_INSTANTLY = false
            static UnitList REG_GROUP

            method Before_TriggerEvents takes Unit killer returns nothing
                local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

                call params.Unit.SetKiller(killer)
                call params.Unit.SetTrigger(this)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = Event.CountAtStatics(thistype.BEFORE_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.GetFromStatics(thistype.BEFORE_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
            endmethod

            method Before_Event_Life takes Unit killer returns nothing
                call this.Before_TriggerEvents(killer)

                set thistype.KILLER = killer
            endmethod

            method TriggerEvents takes Unit killer returns nothing
                local Unit parent = this

                local EventResponse killerParams = EventResponse.Create(killer.Id.Get())

                call killerParams.Unit.SetTarget(parent)
                call killerParams.Unit.SetTrigger(killer)

				local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

                call params.Unit.SetKiller(killer)
                call params.Unit.SetTrigger(parent)

				local EventResponse unitParams = EventResponse.Create(parent.Id.Get())

                call unitParams.Unit.SetKiller(killer)
                call unitParams.Unit.SetTrigger(parent)

                local Event array eventsToRun
                local integer eventsToRunCount = ARRAY_EMPTY
                local integer array eventsToRunType
				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        set eventsToRunCount = eventsToRunCount + 1

                        set eventsToRun[eventsToRunCount] = Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2)
                        set eventsToRunType[eventsToRunCount] = 0

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = killer.Event.Count(thistype.KILLER_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        set eventsToRunCount = eventsToRunCount + 1

                        set eventsToRun[eventsToRunCount] = killer.Event.Get(thistype.KILLER_EVENT_TYPE, priority, iteration2)
                        set eventsToRunType[eventsToRunCount] = 1

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        set eventsToRunCount = eventsToRunCount + 1

                        set eventsToRun[eventsToRunCount] = parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2)
                        set eventsToRunType[eventsToRunCount] = 2

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                set iteration = ARRAY_MIN

                loop
                    exitwhen (iteration > eventsToRunCount)

                    if (eventsToRunType[iteration] == 0) then
                        if eventsToRun[iteration].IsStatic() then
                            call eventsToRun[iteration].Run(params)

                            if not Unit(this).Classes.Contains(UnitClass.DEAD) then
                                return
                            endif
                        endif
                    elseif (eventsToRunType[iteration] == 1) then
                        if killer.Event.Contains(eventsToRun[iteration]) then
                            call eventsToRun[iteration].Run(killerParams)

                            if not Unit(this).Classes.Contains(UnitClass.DEAD) then
                                return
                            endif
                        endif
                    else
                        if parent.Event.Contains(eventsToRun[iteration]) then
                            call eventsToRun[iteration].Run(unitParams)

                            if not parent.Classes.Contains(UnitClass.DEAD) then
                                return
                            endif
                        endif
                    endif

                    set iteration = iteration + 1
                endloop

                call killerParams.Destroy()
                call params.Destroy()
                call unitParams.Destroy()
            endmethod

            method TriggerEvents2 takes Unit killer returns nothing
                local Unit parent = this

                local EventResponse killerParams = EventResponse.Create(killer.Id.Get())

                call killerParams.Unit.SetTarget(this)
                call killerParams.Unit.SetTrigger(killer)

				local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

                call params.Unit.SetKiller(killer)
                call params.Unit.SetTrigger(this)

				local EventResponse unitParams = EventResponse.Create(parent.Id.Get())

                call unitParams.Unit.SetKiller(killer)
                call unitParams.Unit.SetTrigger(this)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = killer.Event.Count(thistype.KILLER_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call killer.Event.Get(thistype.KILLER_EVENT_TYPE, priority, iteration2).Run(killerParams)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(unitParams)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call killerParams.Destroy()
                call params.Destroy()
                call unitParams.Destroy()
            endmethod

            method Start takes Unit killer returns nothing
                local boolean decaysInstantly = thistype.NEXT_DECAYS_INSTANTLY

                call Unit(this).Refs.Add()

                if decaysInstantly then
                    set thistype.NEXT_DECAYS_INSTANTLY = false
                endif

                call Unit(this).Classes.Add(UnitClass.DEAD)

                if ((Unit(this).Classes.Contains(UnitClass.HERO) and not Unit(this).Classes.Contains(UnitClass.ILLUSION)) or Unit(this).Classes.Contains(UnitClass.UNDECAYABLE)) then
                    call this.TriggerEvents(killer)
                else
                    local real decayDuration = Unit(this).Decay.Duration.Get()

                    set decaysInstantly = (decaysInstantly or Unit(this).Death.Explosion.Is() or (decayDuration == 0.))

                    if decaysInstantly then
                        call Unit(this).Death.Explosion.Try(killer)

                        call this.TriggerEvents(killer)

                        if not Unit(this).IsDestroyed() then
                            call Unit(this).Decay.Do()
                        endif
                    else
                        call Unit(this).Decay.Timed.Start(decayDuration)

                        call this.TriggerEvents(killer)
                    endif
                endif

                call Unit(this).Drop.Exp.DoHeal(killer)

                call Unit(this).Refs.Subtract()
            endmethod

            static method TrigConds takes Unit parent returns boolean
                if not thistype.REG_GROUP.Contains(parent) then
                    return false
                endif

                return true
            endmethod

            trigMethod Trig
                local Unit parent = UNIT.Event.Native.GetTrigger()

                if not thistype.TrigConds(parent) then
                    return
                endif

                local Unit killer = thistype.KILLER

                set thistype.KILLER = NULL

                call thistype(parent).Start(killer)
            endmethod

            method Event_Destroy takes nothing returns nothing
                call thistype.REG_GROUP.Remove(this)
            endmethod

            method Event_Create takes nothing returns nothing
                call thistype.REG_GROUP.Add(this)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.BEFORE_EVENT_TYPE = EventType.Create()
                set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                set thistype.KILLER_EVENT_TYPE = EventType.Create()
                set thistype.REG_GROUP = UnitList.Create()

                call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_DEATH, null)
            endmethod
        endstruct
        
        //! runtextmacro Struct("Protection")
        	//! runtextmacro GetKeyArray("KEY_ARRAY")
        	static constant string TRY_TEXT = "Immortal!!"
        	
	        //! runtextmacro CreateSimpleFlagState_NotStart()        

	        method Try takes nothing returns boolean
	            if not this.Is() then
	                return false
	            endif
	
	            call Unit(this).AddJumpingTextTag(String.Color.Do(thistype.TRY_TEXT, "ff777777"), 0.02, KEY_ARRAY + this)
	
	            return true
	        endmethod
	
	        eventMethod Event_BuffLose
	            local Unit parent = params.Unit.GetTrigger()
	
	            call thistype(parent).Set(false)
	        endmethod
	
	        eventMethod Event_BuffGain
	            local Unit parent = params.Unit.GetTrigger()
	
	            call thistype(parent).Set(true)
	        endmethod
	
	        method Subtract takes nothing returns nothing
	            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
	        endmethod
	
	        method Add takes nothing returns nothing
	            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
	        endmethod
	
	        method Event_Create takes nothing returns nothing
	            call this.Set(false)
	        endmethod
	
	        initMethod Buff_Init of Header_Buffs
	            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
	            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
	        endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Death")
        //! runtextmacro LinkToStruct("Death", "Events")
        //! runtextmacro LinkToStruct("Death", "Explosion")
        //! runtextmacro LinkToStruct("Death", "Protection")

        method Event_Destroy takes nothing returns nothing
            call this.Events.Event_Destroy()
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Events.Event_Create()
            call this.Protection.Event_Create()
        endmethod

        method Do takes Unit killer returns nothing
        	if this.Protection.Try() then
                return
            endif
            
            set thistype(NULL).Events.KILLER = killer

            call KillUnit(Unit(this).self)
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Events.Init()
            call thistype(NULL).Explosion.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Decay")
        //! runtextmacro Struct("Duration")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().Decay.Duration.Get()")

            eventMethod Event_TypeChange
                local UnitType sourceType = params.UnitType.GetSource()
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.Add(targetType.Decay.Duration.Get() - sourceType.Decay.Duration.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Events")
            static Trigger DUMMY_TRIGGER
            static UnitList REG_GROUP
            static unit array TIMER_UNIT

            condTrigMethod TrigConds
                if not thistype.REG_GROUP.Contains(UNIT.Event.Native.GetFilter()) then
                    return false
                endif

                return true
            endmethod

            timerMethod Delay
                local Timer dummyTimer = Timer.GetExpired()

                call Unit.GetFromSelf(thistype.TIMER_UNIT[dummyTimer]).Decay.Suspend(true)

                call dummyTimer.Destroy()
            endmethod

            trigMethod Trig
                local Timer dummyTimer = Timer.Create()

                set thistype.TIMER_UNIT[dummyTimer] = UNIT.Event.Native.GetTrigger().self

                call dummyTimer.Start(0., false, function thistype.Delay)
            endmethod

            method Event_Destroy takes nothing returns nothing
                call thistype.REG_GROUP.Remove(this)
            endmethod

            method Event_Create takes nothing returns nothing
                call thistype.REG_GROUP.Add(this)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                set thistype.REG_GROUP = UnitList.Create()

                call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_DECAY, function thistype.TrigConds)
            endmethod
        endstruct

        //! runtextmacro Struct("Timed")
            static Event DESTROY_EVENT
            //! runtextmacro GetKey("KEY")
            static Event REVIVE_EVENT

            Timer durationTimer
            Unit parent

            method Ending takes Timer durationTimer, Unit parent returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                call parent.Data.Integer.Remove(KEY)
                call parent.Event.Remove(DESTROY_EVENT)
                call parent.Event.Remove(REVIVE_EVENT)
            endmethod

            timerMethod EndingByTimer
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                local Unit parent = this.parent

                call this.Ending(durationTimer, parent)

                call parent.Decay.Do()
            endmethod

            eventMethod Event_Destroy
                local Unit parent = params.Unit.GetTrigger()

                local thistype this = parent.Data.Integer.Get(KEY)

                call this.Ending(this.durationTimer, parent)
            endmethod

            eventMethod Event_Revive
                local Unit parent = params.Unit.GetTrigger()

                local thistype this = parent.Data.Integer.Get(KEY)

                call this.Ending(this.durationTimer, parent)
            endmethod

            method Start takes real duration returns nothing
                local Unit parent = this

                set this = thistype.allocate()

				local Timer durationTimer = Timer.Create()

                set this.durationTimer = durationTimer
                set this.parent = parent
                call durationTimer.SetData(this)
                call parent.Data.Integer.Set(KEY, this)
                call parent.Event.Add(DESTROY_EVENT)
                call parent.Event.Add(REVIVE_EVENT)

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Decay")
        //! runtextmacro LinkToStruct("Decay", "Duration")
        //! runtextmacro LinkToStruct("Decay", "Events")
        //! runtextmacro LinkToStruct("Decay", "Timed")

        method Do takes nothing returns nothing
            call Unit(this).Destroy()
        endmethod

        method Suspend takes boolean flag returns nothing
            call UnitSuspendDecay(Unit(this).self, flag)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Duration.Event_Create()
            call this.Events.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Duration.Init()
            call thistype(NULL).Events.Init()
            call thistype(NULL).Timed.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Display")
        method Update takes nothing returns nothing
            call Unit(this).Abilities.AddBySelf(thistype.DUMMY_SPELL_ID)
            call Unit(this).Abilities.RemoveBySelf(thistype.DUMMY_SPELL_ID)
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Folder("Drop")
        //! runtextmacro Struct("Exp")
            //! runtextmacro CreateSimpleAddState("integer", "Unit(this).Type.Get().Drop.Exp.Get()")

            method DoHeal takes Unit target returns nothing
            return
            	if (this == NULL) then
                    return
                endif
                if (target == NULL) then
                    return
                endif

                if (target.Owner.Get().Team.Get() != Team.DEFENDERS) then
                    return
                endif
                if target.IsAllyOf(Unit(this).Owner.Get()) then
                    return
                endif

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
                
                local real val = this.Get()

                if (val <= 0) then
                    return
                endif

                call target.Life.Add(val)
                call target.Mana.Add(val)
                call target.Stamina.Add(val)
            endmethod

            eventMethod Event_TypeChange
                local UnitType sourceType = params.UnitType.GetSource()
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.Add(targetType.Drop.Exp.Get() - sourceType.Drop.Exp.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Supply")
            //! runtextmacro CreateSimpleAddState("integer", "Unit(this).Type.Get().Drop.Supply.Get()")

            eventMethod Event_TypeChange
                local UnitType sourceType = params.UnitType.GetSource()
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.Add(targetType.Drop.Supply.Get() - sourceType.Drop.Supply.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Drop")
        static Event DESTROY_EVENT
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro LinkToStruct("Drop", "Exp")
        //! runtextmacro LinkToStruct("Drop", "Supply")

        eventMethod Event_Destroy
            local Unit parent = params.Unit.GetTrigger()

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            call parent.Event.Remove(DESTROY_EVENT)
            loop
                local CustomDrop value = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call parent.Event.Remove(value.GetEvent())

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop

            call parent.Data.Integer.Table.Clear(KEY_ARRAY)
        endmethod

        method Add takes CustomDrop value returns nothing
            if Unit(this).Data.Integer.Table.Add(KEY_ARRAY, value) then
                call Unit(this).Event.Add(DESTROY_EVENT)
            endif
            call Unit(this).Event.Add(value.GetEvent())
            call Unit(this).Effects.Create(value.GetEffectPath(), value.GetEffectAttachPoint(), value.GetEffectLevel())
        endmethod

        method Clear takes nothing returns nothing
            local Unit parent = this

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            if (iteration < Memory.IntegerKeys.Table.STARTED) then
                return
            endif

            call parent.Event.Remove(DESTROY_EVENT)
            loop
                local CustomDrop value = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call parent.Event.Remove(value.GetEvent())

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop

            call parent.Data.Integer.Table.Clear(KEY_ARRAY)
        endmethod

        eventMethod Event_TypeChange
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            call this.Clear()

			local integer iteration = targetType.Drop.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Add(targetType.Drop.Get(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        method Event_Create takes nothing returns nothing
            local UnitType whichType = Unit(this).Type.Get()

            local integer iteration = whichType.Drop.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Add(whichType.Drop.Get(iteration))

                set iteration = iteration - 1
            endloop

            call this.Exp.Event_Create()
            call this.Supply.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            call thistype(NULL).Exp.Init()
            call thistype(NULL).Supply.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Evasion")
        static constant string TRY_TEXT = "patzer"

        //! runtextmacro CreateSimpleFlagCountState_NotStart()

        method Try takes Unit target returns boolean
            if not thistype(target).Is() then
                return false
            endif
            if target.Sleep.Is() then
                return false
            endif
            if Unit(this).Invisibility.Is() then
                return false
            endif

            if (Math.Random(0., 1.) > Unit(this).EvasionChance.VsUnit(target)) then
                return false
            endif

            call Unit(this).AddRisingTextTag(String.Color.Do(thistype.TRY_TEXT, "dfffdfdf"), 0.02, 140., 0., 1.5, TextTag.GetFreeId())
            call target.Effects.Create("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", AttachPoint.CHEST, EffectLevel.NORMAL).Destroy()

            return true
        endmethod

        method Event_Create takes nothing returns nothing
            if (Unit(this).Classes.Contains(UnitClass.STRUCTURE) or Unit(this).Classes.Contains(UnitClass.WARD)) then
                call this.Set(0)
            else
                call this.Set(1)
            endif
        endmethod
    endstruct

    //! runtextmacro Folder("EvasionChanceDefense")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).EvasionChanceDefense.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            static UnitState STATE

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).EvasionChanceDefense.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("EvasionChanceDefense")
        //! runtextmacro LinkToStruct("EvasionChanceDefense", "Base")
        //! runtextmacro LinkToStruct("EvasionChanceDefense", "Bonus")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Set takes real value returns nothing
            set this.value = value
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() + this.Bonus.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0.

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Bonus.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("EvasionChance")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).EvasionChance.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            static UnitState STATE
            
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).EvasionChance.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("EvasionChance")
        static constant real CHANCE_EXPONENT = 0.1
        static constant real CHANCE_FACTOR = 1.
        static constant real MAX = 0.5
        static constant real MIN = 0.05

        //! runtextmacro LinkToStruct("EvasionChance", "Base")
        //! runtextmacro LinkToStruct("EvasionChance", "Bonus")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method VsUnit takes Unit target returns real
            //return Math.Limit(1. - 1. / (1. + CHANCE_FACTOR * (Math.Power(1. + thistype(target).Get() - Unit(this).EvasionChanceDefense.Get(), thistype.CHANCE_EXPONENT) - 1.)), thistype.MIN, thistype.MAX)
            return Math.Limit((thistype(target).Get() - Unit(this).EvasionChanceDefense.Get()) / 100, thistype.MIN, thistype.MAX)
        endmethod

        method Set takes real value returns nothing
            set this.value = value
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() + this.Bonus.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0.

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()

            call this.Update()
        endmethod
        
        static method Init takes nothing returns nothing
            call thistype(NULL).Bonus.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Impact")
        //! runtextmacro Struct("X")
            real value

            method Get takes boolean useScale returns real
                if useScale then
                    return (this.value * Unit(this).Scale.Get())
                endif

                return this.value
            endmethod

            method Set takes real value returns nothing
                set this.value = value
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get(false) + value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyStart("0.")
        endstruct

        //! runtextmacro Struct("Y")
            real value

            method Get takes boolean useScale returns real
                if useScale then
                    return (this.value * Unit(this).Scale.Get())
                endif

                return this.value
            endmethod

            method Set takes real value returns nothing
                set this.value = value
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get(false) + value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyStart("0.")
        endstruct

        //! runtextmacro Struct("Z")
            real value

            method Get takes boolean useScale returns real
                if useScale then
                    return (this.value * Unit(this).Scale.Get())
                endif

                return this.value
            endmethod

            method Set takes real value returns nothing
                set this.value = value
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get(false) + value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyStart("Unit(this).Type.Get().Impact.Z.Get()")

            method Event_TypeChange takes UnitType sourceType, UnitType targetType returns nothing
                call this.Add(targetType.Impact.Z.Get() - sourceType.Impact.Z.Get())
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Impact")
        //! runtextmacro LinkToStruct("Impact", "X")
        //! runtextmacro LinkToStruct("Impact", "Y")
        //! runtextmacro LinkToStruct("Impact", "Z")

        eventMethod Event_TypeChange
            local UnitType sourceType = params.UnitType.GetSource()
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            call this.Z.Event_TypeChange(sourceType, targetType)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.X.Event_Create()
            call this.Y.Event_Create()
            call this.Z.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Struct("Exp")
        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Set takes real value returns nothing
            set this.value = value

            call SetHeroXP(Unit(this).self, Real.ToInt(value), false)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd("real", "GetHeroXP(Unit(this).self)")
    endstruct

    //! runtextmacro Folder("Outpact")
        //! runtextmacro Struct("X")
            real value

            method Get takes boolean useScale returns real
                if useScale then
                    return (this.value * Unit(this).Scale.Get())
                endif

                return this.value
            endmethod

            method Set takes real value returns nothing
                set this.value = value
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get(false) + value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyStart("0.")
        endstruct

        //! runtextmacro Struct("Y")
            real value

            method Get takes boolean useScale returns real
                if useScale then
                    return (this.value * Unit(this).Scale.Get())
                endif

                return this.value
            endmethod

            method Set takes real value returns nothing
                set this.value = value
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get(false) + value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyStart("60.")
        endstruct

        //! runtextmacro Struct("Z")
            real value

            method Get takes boolean useScale returns real
                if useScale then
                    return (this.value * Unit(this).Scale.Get())
                endif

                return this.value
            endmethod

            method Set takes real value returns nothing
                set this.value = value
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get(false) + value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyStart("Unit(this).Type.Get().Outpact.Z.Get()")

            method Event_TypeChange takes UnitType sourceType, UnitType targetType returns nothing
                call this.Add(targetType.Outpact.Z.Get() - sourceType.Outpact.Z.Get())
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Outpact")
        //! runtextmacro LinkToStruct("Outpact", "X")
        //! runtextmacro LinkToStruct("Outpact", "Y")
        //! runtextmacro LinkToStruct("Outpact", "Z")

        eventMethod Event_TypeChange
            local UnitType sourceType = params.UnitType.GetSource()
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            call this.Z.Event_TypeChange(sourceType, targetType)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.X.Event_Create()
            call this.Y.Event_Create()
            call this.Z.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Struct("LifeLeech")
        static UnitState STATE

        //! runtextmacro CreateSimpleAddState("real", "0.")

        eventMethod Event_State
            call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
        endmethod

        method Do takes Unit target returns nothing
            local Unit parent = this

            if target.IsAllyOf(parent) then
                return
            endif

            local real val = this.Get()

            if (val <= 0.) then
                return
            endif

            call parent.AddRisingTextTag(String.Color.Do(Char.PLUS + Integer.ToString(Real.ToInt(val)), "ffc80000"), 0.02, 80., 0., 3., TextTag.GetFreeId())
            call parent.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

            call parent.Life.Add(val)
        endmethod

        method DoWithVal takes Unit target, real val returns nothing
            local Unit parent = this

            if target.IsAllyOf(parent) then
                return
            endif

            if (val <= 0.) then
                return
            endif

            call parent.AddRisingTextTag(String.Color.Do(Char.PLUS + Integer.ToString(Real.ToInt(val)), "ffc80000"), 0.02, 80., 0., 3., TextTag.GetFreeId())
            call parent.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

            call parent.Life.Add(val)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
        endmethod
    endstruct

    //! runtextmacro Struct("ManaLeech")
        static UnitState STATE

        //! runtextmacro CreateSimpleAddState("real", "0.")

        eventMethod Event_State
            call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
        endmethod

        method Do takes Unit target returns nothing
            local Unit parent = this

            if target.IsAllyOf(parent) then
                return
            endif

            local real val = this.Get()

            if (val <= 0.) then
                return
            endif

            call parent.AddRisingTextTag(String.Color.Do(Char.PLUS + Integer.ToString(Real.ToInt(val)), "ffc80000"), 0.02, 80., 0., 3., TextTag.GetFreeId())
            call parent.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

            call parent.Mana.Add(val)
        endmethod

        method DoWithVal takes Unit target, real val returns nothing
            local Unit parent = this

            if target.IsAllyOf(parent) then
                return
            endif

            if (val <= 0.) then
                return
            endif

            call parent.AddRisingTextTag(String.Color.Do(Char.PLUS + Integer.ToString(Real.ToInt(val)), "ffc80000"), 0.02, 80., 0., 3., TextTag.GetFreeId())
            call parent.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

            call parent.Mana.Add(val)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
        endmethod
    endstruct

    //! textmacro Unit_CreateStateWithTemporaryAbilities takes name
        real value

        method Get takes nothing returns real
            return this.value
        endmethod

        method AddNative takes integer amount returns nothing
            local integer neededMaxPacketsAmount
            local integer packetAbil

            if (amount < 0) then
                set amount = -amount

                set neededMaxPacketsAmount = amount div thistype.DEC_MAX_PACKET

                set amount = amount - neededMaxPacketsAmount * thistype.DEC_MAX_PACKET

                loop
                    exitwhen (neededMaxPacketsAmount < 1)

                    call Unit(this).Abilities.AddBySelf(thistype.DEC_MAX_PACKET_RAW)

                    call Unit(this).Abilities.SetLevelBySelf(thistype.DEC_MAX_PACKET_RAW, 2)

                    call Unit(this).Abilities.RemoveBySelf(thistype.DEC_MAX_PACKET_RAW)

                    set neededMaxPacketsAmount = neededMaxPacketsAmount - 1
                endloop

                set packetAbil = thistype.DEC_RAWS[amount]

                call Unit(this).Abilities.AddBySelf(packetAbil)

                call Unit(this).Abilities.SetLevelBySelf(packetAbil, 2)

                call Unit(this).Abilities.RemoveBySelf(packetAbil)
            else
                set neededMaxPacketsAmount = amount div thistype.INC_MAX_PACKET

                set amount = amount - neededMaxPacketsAmount * thistype.INC_MAX_PACKET

                loop
                    exitwhen (neededMaxPacketsAmount < 1)

                    call Unit(this).Abilities.AddBySelf(thistype.INC_MAX_PACKET_RAW)

                    call Unit(this).Abilities.SetLevelBySelf(thistype.INC_MAX_PACKET_RAW, 2)

                    call Unit(this).Abilities.RemoveBySelf(thistype.INC_MAX_PACKET_RAW)

                    set neededMaxPacketsAmount = neededMaxPacketsAmount - 1
                endloop

                set packetAbil = thistype.INC_RAWS[amount]

                call Unit(this).Abilities.AddBySelf(packetAbil)

                call Unit(this).Abilities.SetLevelBySelf(packetAbil, 2)

                call Unit(this).Abilities.RemoveBySelf(packetAbil)
            endif
        endmethod

        method Set takes real value returns nothing
            local real oldValue = this.value

            if (oldValue == value) then
                return
            endif

            set this.value = value
            call this.AddNative(Real.ToInt(value - oldValue))

            static if thistype.SetEx.exists then
                if (oldValue != 0.) then
                    call this.SetEx(oldValue, value)
                endif
            endif
        endmethod
    //! endtextmacro

    //! textmacro Unit_CreateStateWithTemporaryAbilities2 takes name
        real value

        method Get takes nothing returns real
            return this.value
        endmethod

        method AddNative takes real amount returns nothing
            local integer packet
            local integer packetLevel

            if (amount < 0) then
                set amount = -amount

                set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(amount)), thistype.DECREASING_SPELLS_MAX)

                loop
                    exitwhen (amount < 1)

                    set packet = thistype.PACKETS[packetLevel]

                    loop
                        exitwhen (amount < packet)

                        call Unit(this).Abilities.AddBySelf(thistype.DECREASING_SPELL_ID)

                        call Unit(this).Abilities.SetLevelBySelf(thistype.DECREASING_SPELL_ID, 2 + packetLevel)

                        call Unit(this).Abilities.RemoveBySelf(thistype.DECREASING_SPELL_ID)

                        set amount = amount - packet
                    endloop

                    set packetLevel = packetLevel - 1
                endloop
            else
                set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(amount)), thistype.INCREASING_SPELLS_MAX)

                loop
                    exitwhen (amount < 1)

                    set packet = thistype.PACKETS[packetLevel]

                    loop
                        exitwhen (amount < packet)

                        call Unit(this).Abilities.AddBySelf(thistype.INCREASING_SPELL_ID)

                        call Unit(this).Abilities.SetLevelBySelf(thistype.INCREASING_SPELL_ID, 2 + packetLevel)

                        call Unit(this).Abilities.RemoveBySelf(thistype.INCREASING_SPELL_ID)

                        set amount = amount - packet
                    endloop

                    set packetLevel = packetLevel - 1
                endloop
            endif
        endmethod

        method Set takes real value returns nothing
            local real oldValue = this.value

            if (oldValue == value) then
                return
            endif

            set this.value = value
            call this.AddNative(value - oldValue)

            static if thistype.SetEx.exists then
                if (oldValue != 0.) then
                    call this.SetEx(oldValue, value)
                endif
            endif
        endmethod
    //! endtextmacro

    //! runtextmacro Struct("Invulnerability")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static UnitState STATE
        static constant string TRY_TEXT = "Invulnerable!!"

        //! runtextmacro CreateSimpleFlagState_NotStart()

        method Try takes nothing returns boolean
            if not this.Is() then
                return false
            endif

            call Unit(this).AddJumpingTextTag(String.Color.Do(thistype.TRY_TEXT, "ffff0000"), 0.02, KEY_ARRAY + this)

            return true
        endmethod

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        method Change takes boolean val returns nothing
            if val then
                call this.Add()
            else
                call this.Subtract()
            endif
        endmethod

        eventMethod Event_State
            call thistype(params.Unit.GetTrigger()).Change(params.Bool.GetVal())
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))

            call thistype.DUMMY_BUFF.Variants.Add(thistype.NORMAL_BUFF)
        endmethod

        static method Init takes nothing returns nothing
        	set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
        endmethod
    endstruct

    //! runtextmacro Folder("Damage")
        //! runtextmacro Folder("Base")
            //! runtextmacro Struct("Displayed")
                static constant boolean WAIT_FOR_SELECTION = true

                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                static if thistype.WAIT_FOR_SELECTION then
                    static Event SELECTION_EVENT

                    real nativeValue
                    boolean waitForSelection

                    method SetNative takes real value, real oldValue returns boolean
                        if IsUnitPaused(Unit(this).self) then
                            return false
                        endif

                        set this.nativeValue = value

                        call UNIT.Items.Events.Gain.DUMMY_TRIGGER.Disable()
                        call UNIT.Items.Events.Lose.DUMMY_TRIGGER.Disable()

                        call BJUnit.Damage.Add(Unit(this).self, Real.ToInt(value) - Real.ToInt(oldValue))

                        call UNIT.Items.Events.Gain.DUMMY_TRIGGER.Enable()
                        call UNIT.Items.Events.Lose.DUMMY_TRIGGER.Enable()

                        return true
                    endmethod

                    eventMethod Event_Selection
                        local thistype this = params.Unit.GetTrigger()

                        if this.SetNative(this.Get(), this.nativeValue) then
                            set this.waitForSelection = false
                            call Unit(this).Event.Remove(SELECTION_EVENT)
                        endif
                    endmethod

                    method Set takes real value returns nothing
                        local real nativeValue = this.nativeValue

                        set this.value = value

                        if (value == nativeValue) then
                            if this.waitForSelection then
                                set this.waitForSelection = false
                                call Unit(this).Event.Remove(SELECTION_EVENT)
                            endif

                            return
                        endif

                        if Unit(this).Selection.IsEmpty() then
                            if not this.waitForSelection then
                                set this.waitForSelection = true
                                call Unit(this).Event.Add(SELECTION_EVENT)
                            endif
                        else
                            call this.SetNative(value, nativeValue)
                        endif
                    endmethod
                else
                    method Set takes real value returns nothing
                        local real oldValue = this.value

                        set this.value = value

                        call UNIT.Items.Events.Gain.DUMMY_TRIGGER.Disable()
                        call UNIT.Items.Events.Lose.DUMMY_TRIGGER.Disable()

                        call BJUnit.Damage.Add(Unit(this).self, Real.ToInt(value) - Real.ToInt(oldValue))

                        call UNIT.Items.Events.Gain.DUMMY_TRIGGER.Enable()
                        call UNIT.Items.Events.Lose.DUMMY_TRIGGER.Enable()
                    endmethod
                endif

                method Update takes nothing returns nothing
                    //call this.Set(Unit(this).Damage.Base.Get() * (Unit(this).Damage.Relative.Get() - 1) + Unit(this).Damage.Bonus.Get())
                    call this.Set(Unit(this).Damage.Base.Get())
                endmethod

                method Event_TypeChange takes UnitType targetType returns nothing
                    static if thistype.WAIT_FOR_SELECTION then
                        set this.nativeValue = targetType.Damage.GetBJ()
                        set this.waitForSelection = false
                    endif
                endmethod

                method Event_Create takes nothing returns nothing
                    local UnitType thisType = Unit(this).Type.Get()

                    set this.value = thisType.Damage.Get()
                    static if thistype.WAIT_FOR_SELECTION then
                        set this.nativeValue = thisType.Damage.GetBJ()
                        set this.waitForSelection = false
                    endif
                endmethod

                static method Init takes nothing returns nothing
                    //call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
                    static if thistype.WAIT_FOR_SELECTION then
                        set thistype.SELECTION_EVENT = Event.Create(UNIT.Selection.START_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Selection)
                    endif
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Base")
            //! runtextmacro LinkToStruct("Base", "Displayed")

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call this.Displayed.Update()

                call Unit(this).Damage.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_TypeChange
                local UnitType sourceType = params.UnitType.GetSource()
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.Displayed.Event_TypeChange(targetType)

                call this.Add(targetType.Damage.Get() - sourceType.Damage.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = Unit(this).Type.Get().Damage.Get()

                call this.Displayed.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

                call thistype(NULL).Displayed.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Bonus")
            //! runtextmacro Struct("Displayed")
                //! runtextmacro Unit_CreateStateWithPermanentAbilities("Damage.Bonus", "true")

				method Set takes real val returns nothing
					call this.SetDisplay(val)
				endmethod

                method Update takes nothing returns nothing
                    call this.Set(Unit(this).Damage.Base.Get() * (Unit(this).Damage.Relative.Get() - 1) + Unit(this).Damage.Bonus.Get())
                endmethod

                static method Init takes nothing returns nothing
                    static if thistype.WAIT_FOR_SELECTION then
                        set thistype.SELECTION_EVENT = Event.Create(UNIT.Selection.START_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Selection)
                    endif
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Bonus")
        	static UnitState STATE

            //! runtextmacro LinkToStruct("Bonus", "Displayed")

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).Damage.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.

                call this.Displayed.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
            	set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)

                call thistype(NULL).Displayed.Init()
            endmethod
        endstruct

        //! runtextmacro Struct("Delay")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().Damage.Delay.Get()")
        endstruct

        //! runtextmacro Struct("Dices")
            //! runtextmacro CreateSimpleAddState("integer", "Unit(this).Type.Get().Damage.Dices.Get()")

            eventMethod Event_TypeChange
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.Set(targetType.Damage.Dices.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Events")
            static EventType ATTACKER_EDIT_EVENT_TYPE
            static EventType ATTACKER_EVENT_TYPE
            static Trigger DUMMY_TRIGGER
            static boolean IGNORE_NEXT = false
            static boolean SPELL_NEXT = false
            static BoolExpr SPLASH_FILTER
            static Group SPLASH_GROUP
            static UnitList SPLASH_GROUP2
            static EventType TARGET_EDIT_EVENT_TYPE
            static EventType TARGET_EVENT_TYPE
            //! runtextmacro GetKeyArray("TEXT_TAG_KEY_ARRAY")

            method TriggerEvents takes real amount, Unit target, boolean isSpell returns real
                local Unit parent = this

                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.Real.SetDamage(amount)
                call params.Unit.SetDamager(parent)
                call params.Unit.SetTarget(target)
                call params.Unit.SetTrigger(target)

				local EventResponse targetParams = EventResponse.Create(target.Id.Get())

                call targetParams.Real.SetDamage(amount)
                call targetParams.Unit.SetDamager(parent)
                call targetParams.Unit.SetTrigger(target)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = target.Event.Count(thistype.TARGET_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call target.Event.Get(thistype.TARGET_EVENT_TYPE, priority, iteration2).Run(targetParams)

                        call params.Real.SetDamage(targetParams.Real.GetDamage())

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = parent.Event.Count(thistype.ATTACKER_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.ATTACKER_EVENT_TYPE, priority, iteration2).Run(params)

                        call targetParams.Real.SetDamage(params.Real.GetDamage())

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
                call targetParams.Destroy()

                set amount = params.Real.GetDamage()

                return amount
            endmethod

            condMethod SplashConditions
                local Unit target = UNIT.Event.Native.GetFilter()

                if thistype.SPLASH_GROUP2.Contains(target) then
                    return false
                endif

                if (not TEMP_BOOLEAN and target.IsAllyOf(User.TEMP)) then
                    return false
                endif

                if target.Classes.Contains(UnitClass.DEAD) then
                    return false
                endif
                if not target.Classes.Contains(UnitClass.GROUND) then
                    return false
                endif

                return true
            endmethod

            method DealSplash_Single takes Unit target, real amount, integer whichType returns nothing
                set amount = amount * (1. - target.Armor.IgnoreDamage.Relative.Get())

                set amount = amount * UNIT.Armor.GetDamageFactor(target.Armor.Get())

                set amount = amount * Attack.Get(whichType, target.Armor.TypeA.Get())

                call Unit(this).DamageUnit(target, amount, false)
            endmethod

            method DealSplash takes real damageAmount, integer damageType, real x, real y, Unit primaryTarget returns nothing
                local integer iterationEnd = Unit(this).Attack.Splash.Count()

                if (iterationEnd < Memory.IntegerKeys.Table.STARTED) then
                    return
                endif

                local boolean affectsAlly = Unit(this).Attack.Splash.TargetFlag.Is(TargetFlag.ALLY)
                local User parentOwner = Unit(this).Owner.Get()
                call thistype.SPLASH_GROUP2.Add(primaryTarget)

				local integer iteration = Memory.IntegerKeys.Table.STARTED

                loop
                    local UnitAttackSplash splash = Unit(this).Attack.Splash.Get(iteration)

                    set TEMP_BOOLEAN = affectsAlly
                    set User.TEMP = parentOwner

                    call thistype.SPLASH_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, splash.GetAreaRange(), thistype.SPLASH_FILTER)

                    local Unit target = thistype.SPLASH_GROUP.FetchFirst()

                    if (target != NULL) then
                        local real rangeDamageAmount = damageAmount * splash.GetDamageFactor()

                        loop
                            call thistype.SPLASH_GROUP2.Add(target)

                            call this.DealSplash_Single(target, rangeDamageAmount, damageType)

                            set target = thistype.SPLASH_GROUP.FetchFirst()
                            exitwhen (target == NULL)
                        endloop
                    endif

                    set iteration = iteration + 1
                    exitwhen (iteration > iterationEnd)
                endloop

                call thistype.SPLASH_GROUP2.Clear()
            endmethod

            method VsUnit takes Unit target, boolean triggerEvents, real amount returns nothing
                local real armorAmount = target.Armor.Get()
                local boolean crit = false
                local integer damageType = Unit(this).Damage.TypeA.Get()
                local real dealtAmount
                local TextTag oldTextTag
                local Unit parent = this
                local real targetX = target.Position.X.Get()
                local real targetY = target.Position.Y.Get()

                local integer iteration = parent.Damage.Dices.Get()
                local integer sides = parent.Damage.Sides.Get()

                if parent.Evasion.Try(target) then
                    return
                endif
                if target.Invulnerability.Try() then
                    return
                endif

                loop
                    exitwhen (iteration < 1)

                    set amount = amount + Math.RandomI(1, sides)

                    set iteration = iteration - 1
                endloop

                set amount = amount * (1. - target.Armor.IgnoreDamage.Relative.Get())

                set amount = amount * UNIT.Armor.GetDamageFactor(target.Armor.Get())

                set amount = amount * Attack.Get(parent.Damage.TypeA.Get(), target.Armor.TypeA.Get())

                set crit = parent.CriticalChance.Random(target)

                set amount = this.TriggerEvents(amount, target, false)

                set dealtAmount = parent.DamageUnit(target, amount, false)

                if crit then
                    set dealtAmount = parent.CriticalChance.Do(target, dealtAmount)

                    if (dealtAmount > 0.) then
                        call target.ReplaceRisingTextTagIfMinorValue(String.Color.Do(Real.ToIntString(dealtAmount) + Char.EXCLAMATION_MARK, parent.Owner.Get().GetColorString()), Math.Linear(dealtAmount, target.MaxLife.Get() / 2., 0.024, 0.028), 160., 0., 1., TEXT_TAG_KEY_ARRAY + target, dealtAmount / 2)
                    endif
                else
                    if (dealtAmount > 0.) then
                        call target.ReplaceRisingTextTagIfMinorValue(String.Color.Do(Real.ToIntString(dealtAmount), parent.Owner.Get().GetColorString()), Math.Linear(dealtAmount, target.MaxLife.Get() / 2., 0.016, 0.022), 160., 0., 1., TEXT_TAG_KEY_ARRAY + target, dealtAmount / 2)
                    endif
                endif

                call parent.LifeLeech.Do(target)
                call parent.ManaLeech.Do(target)

                call this.DealSplash(amount, damageType, targetX, targetY, target)
            endmethod

            trigMethod Trig
                local Unit parent = UNIT.Event.Native.GetDamager()
                local boolean isSpell = thistype.SPELL_NEXT
                local Unit target = UNIT.Event.Native.GetTrigger()

                if ((parent == STRUCT_INVALID) or (TRIGGER.Event.Native.GetDamage() == 0.) or (parent.Attack.GetType() == Attack.ARTILLERY)) then
                    set thistype.IGNORE_NEXT = true
                endif

                set thistype.SPELL_NEXT = false
                if thistype.IGNORE_NEXT then
                    set thistype.IGNORE_NEXT = false
                else
                    if isSpell then
                        call thistype(parent).TriggerEvents(0., target, true)
                    else
                        call thistype(parent).VsUnit(target, true, parent.Damage.Get())
                    endif
                endif
            endmethod

            method Event_Create takes nothing returns nothing
                call thistype.DUMMY_TRIGGER.RegisterEvent.Unit(this, EVENT_UNIT_DAMAGED)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.ATTACKER_EDIT_EVENT_TYPE = EventType.Create()
                set thistype.ATTACKER_EVENT_TYPE = EventType.Create()
                set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                set thistype.SPLASH_FILTER = BoolExpr.GetFromFunction(function thistype.SplashConditions)
                set thistype.SPLASH_GROUP = Group.Create()
                set thistype.SPLASH_GROUP2 = UnitList.Create()
                set thistype.TARGET_EDIT_EVENT_TYPE = EventType.Create()
                set thistype.TARGET_EVENT_TYPE = EventType.Create()
            endmethod
        endstruct

        //! runtextmacro Folder("Relative")
            //! runtextmacro Struct("Invisible")
                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    call Unit(this).Damage.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                method Event_Create takes nothing returns nothing
                    set this.value = 1.
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Relative")
            static UnitState STATE

            //! runtextmacro LinkToStruct("Relative", "Invisible")

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).Damage.Bonus.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 1.

                call Invisible.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct

        //! runtextmacro Struct("Sides")
            //! runtextmacro CreateSimpleAddState("integer", "Unit(this).Type.Get().Damage.Sides.Get()")

            eventMethod Event_TypeChange
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.Set(targetType.Damage.Sides.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("SpellRelative")
            //! runtextmacro CreateSimpleAddState("real", "1.")
        endstruct

        //! runtextmacro Struct("TypeA")
            //! runtextmacro CreateSimpleAddState("integer", "Unit(this).Type.Get().Damage.Type.Get()")

            eventMethod Event_TypeChange
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.Set(targetType.Damage.Type.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Damage")
        real visVal
        real visBonusVal

        //! runtextmacro LinkToStruct("Damage", "Base")
        //! runtextmacro LinkToStruct("Damage", "Bonus")
        //! runtextmacro LinkToStruct("Damage", "Delay")
        //! runtextmacro LinkToStruct("Damage", "Dices")
        //! runtextmacro LinkToStruct("Damage", "Events")
        //! runtextmacro LinkToStruct("Damage", "Relative")
        //! runtextmacro LinkToStruct("Damage", "Sides")
        //! runtextmacro LinkToStruct("Damage", "SpellRelative")
        //! runtextmacro LinkToStruct("Damage", "TypeA")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method GetVisible takes nothing returns real
            return this.visVal
        endmethod

        method GetVisibleBonus takes nothing returns real
            return this.visBonusVal
        endmethod

        method Set takes real value returns nothing
            set this.value = value

            call this.Bonus.Displayed.Update()
        endmethod

        method Update takes nothing returns nothing
            local real baseVal = this.Base.Get()
            local real bonusVal = this.Bonus.Get()
            local real relVal = this.Relative.Get()

            set this.visVal = baseVal * relVal + bonusVal
            set this.visBonusVal = baseVal * (relVal - 1) + bonusVal
            call this.Set(baseVal * relVal * this.Relative.Invisible.Get() + bonusVal)
        endmethod

        method Do takes Unit target, real amount, boolean triggerEvents returns real
            if target.Invulnerability.Try() then
                return 0.
            endif

            set amount = amount * (1. - target.Armor.Resistance.Get())

            if (amount > 0.) then
                if triggerEvents then
                    set amount = this.Events.TriggerEvents(amount, target, false)
                endif

                set amount = Math.Min(amount, target.Life.Get())
                call UnitDamageTarget(Unit(this).self, target.self, 0., false, false, null, null, null)

                set UNIT.Life.DAMAGE_SOURCE = this

                call target.Life.Subtract(amount)

                return amount
            endif

            return 0.
        endmethod

        method DoBySpell takes Unit target, real amount, boolean magical, boolean triggerEvents returns real
            local boolean crit = false

            if (amount > 0.) then
                if magical then
                    if target.MagicImmunity.Try() then
                        return 0.
                    endif

                    set amount = amount * Unit(this).SpellPower.GetDamageFactor(target.SpellPower.Get() - Unit(this).SpellPower.Get()) * (1. - target.Armor.Spell.Get()) * Math.Random(0.9, 1.1)
                else
                    set amount = amount * Unit(this).Armor.GetDamageFactor(target.Armor.Get())
                endif

                if (not magical and Unit(this).CriticalChance.Random(target)) then
                    set amount = amount * UNIT.CriticalChance.DAMAGE_FACTOR
                    set crit = true
                endif
            endif

            set amount = this.Do(target, amount, triggerEvents)

            call Unit(this).SpellVamp.Do(amount, crit)

            return amount
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0.

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()
            call this.Delay.Event_Create()
            call this.Dices.Event_Create()
            call this.Events.Event_Create()
            call this.Relative.Event_Create()
            call this.Sides.Event_Create()
            call this.SpellRelative.Event_Create()
            call this.TypeA.Event_Create()

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Base.Init()
            call thistype(NULL).Bonus.Init()
            call thistype(NULL).Dices.Init()
            call thistype(NULL).Events.Init()
            call thistype(NULL).Relative.Init()
            call thistype(NULL).Sides.Init()
            call thistype(NULL).TypeA.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("MagicImmunity")
        //! runtextmacro Struct("SpellShield")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            static constant string TRY_TEXT = "Blocked!!"

            //! runtextmacro CreateSimpleFlagState_NotStart()

            method Try takes nothing returns boolean
                if not this.Is() then
                    return false
                endif

                call Unit(this).AddJumpingTextTag(String.Color.Do(thistype.TRY_TEXT, "d4e019aa"), 0.02, KEY_ARRAY + this)
                call Unit(this).Effects.Create("Abilities\\Spells\\Other\\HealingSpray\\HealBottleMissile.mdl", AttachPoint.CHEST, EffectLevel.LOW).Destroy()

                call Unit(this).Buffs.Remove(Unit(this).Data.Integer.Table.Get(KEY_ARRAY, Memory.IntegerKeys.Table.STARTED))

                return true
            endmethod

            eventMethod Event_BuffLose
                local Buff whichBuff = params.Buff.GetData()
                local Unit parent = params.Unit.GetTrigger()

                local thistype this = parent

                call this.Set(false)

                call parent.Data.Integer.Table.Remove(KEY_ARRAY, whichBuff)
            endmethod

            eventMethod Event_BuffGain
                local Buff whichBuff = params.Buff.GetData()
                local Unit parent = params.Unit.GetTrigger()

                local thistype this = parent

                call this.Set(true)

                call parent.Data.Integer.Table.Add(KEY_ARRAY, whichBuff)
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Set(false)
            endmethod

            initMethod Buff_Init of Header_Buffs
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))

                call thistype.DUMMY_BUFF.Variants.Add(thistype.NORMAL_BUFF)
            endmethod

            static method Init takes nothing returns nothing
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("MagicImmunity")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static UnitState STATE
        static constant string TRY_TEXT = "Magic immune!!"

        //! runtextmacro LinkToStruct("MagicImmunity", "SpellShield")

        //! runtextmacro CreateSimpleFlagState_NotStart()

        method Try takes nothing returns boolean
            if not this.Is() then
                return this.SpellShield.Try()
            endif

            call Unit(this).AddJumpingTextTag(String.Color.Do(thistype.TRY_TEXT, "d4e019aa"), 0.02, KEY_ARRAY + this)

            return true
        endmethod

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.NORMAL_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.NORMAL_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.NORMAL_BUFF, 1, duration)
        endmethod

        method Change takes boolean val returns nothing
            if val then
                call this.Add()
            else
                call this.Subtract()
            endif
        endmethod

        eventMethod Event_State
            call thistype(params.Unit.GetTrigger()).Change(params.Bool.GetVal())
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)

            call this.SpellShield.Event_Create()
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))

            call thistype.DUMMY_BUFF.Variants.Add(thistype.NORMAL_BUFF)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            
            call thistype(NULL).SpellShield.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Scale")
        //! runtextmacro Struct("Bonus")
            static UnitState STATE

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).Scale.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct

        //! runtextmacro Struct("Timed")
            static Event DESTROY_EVENT
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
            static Timer UPDATE_TIMER

            static UnitState STATE

            real scaleAdd
            Timer durationTimer
            Unit parent

            timerMethod Update
                local integer iteration = thistype.ALL_COUNT

                loop
                    local thistype this = thistype.ALL[iteration]

                    call this.parent.Scale.AddSimple(this.scaleAdd)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endmethod

            method Ending takes Timer durationTimer, Unit parent returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                if parent.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                    call parent.Event.Remove(DESTROY_EVENT)
                endif
                if this.RemoveFromList() then
                    call thistype.UPDATE_TIMER.Pause()
                endif
            endmethod

            eventMethod Event_Destroy
                local Unit parent = params.Unit.GetTrigger()

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.Ending(this.durationTimer, parent)

                    set iteration = iteration - 1
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                endloop
            endmethod

            timerMethod EndingByTimer
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                call this.Ending(durationTimer, this.parent)

                call this.parent.Scale.Update()
            endmethod

            method Add takes real scale, real duration returns nothing
                local Unit parent = this

                if (duration == 0.) then
                    call Unit(this).Scale.Add(scale)

                    return
                endif

                local integer wavesAmount = Real.ToInt(duration / thistype.UPDATE_TIME)

				set this = thistype.allocate()

				local Timer durationTimer = Timer.Create()

                set this.durationTimer = durationTimer
                set this.parent = parent
                set this.scaleAdd = scale / wavesAmount
                call durationTimer.SetData(this)
                if parent.Data.Integer.Table.Add(KEY_ARRAY, this) then
                    call parent.Event.Add(DESTROY_EVENT)
                endif

                if this.AddToList() then
                    call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                endif

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)
            endmethod

            method Subtract takes real scale, real duration returns nothing
                call this.Add(-scale, duration)
            endmethod

            //! runtextmacro GetKey("STATE_SCALE_KEY")
            //! runtextmacro GetKey("STATE_DURATION_KEY")

            eventMethod Event_State
                //local real scale = params.Dynamic.GetReal(STATE_SCALE_KEY)
                //local real dur = params.Dynamic.GetReal(STATE_DURATION_KEY)
                
                local UnitMod mod = params.UnitMod.GetTrigger()
                
                local real scale = thistype(mod).mod_scale
                local real dur = thistype(mod).mod_dur

                if not params.Bool.GetAdded() then
                    set scale = -scale
                endif

                call thistype(params.Unit.GetTrigger()).Add(scale, dur)
            endmethod

            real mod_scale
            real mod_dur

            eventMethod Event_ModLose
                local UnitMod mod = params.UnitMod.GetTrigger()

                call thistype(params.Unit.GetTrigger()).Subtract(thistype(mod).mod_scale, thistype(mod).mod_dur)
            endmethod

            eventMethod Event_ModGain
                local UnitMod mod = params.UnitMod.GetTrigger()

                call thistype(params.Unit.GetTrigger()).Add(thistype(mod).mod_scale, thistype(mod).mod_dur)
            endmethod

            method CreateMod takes real scale, real dur returns UnitMod
                local UnitMod mod = UnitMod.Create(thistype.STATE, function thistype.Event_ModGain, function thistype.Event_ModLose)

                set thistype(mod).mod_scale = scale
                set thistype(mod).mod_dur = dur

                return mod
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.UPDATE_TIMER = Timer.Create()

                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Scale")
        static Event MODDED_DEATH_EVENT
        static Event MODDED_REVIVE_EVENT

        //! runtextmacro LinkToStruct("Scale", "Bonus")
        //! runtextmacro LinkToStruct("Scale", "Timed")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method GetAll takes nothing returns real
            return (this.Get() + this.Bonus.Get())
        endmethod

        method UpdateSimple takes nothing returns nothing
            local real val = this.GetAll()

            call SetUnitScale(Unit(this).self, val, val, val)
        endmethod

        eventMethod Event_Modded_Death
            call thistype(params.Unit.GetTrigger()).UpdateSimple()
        endmethod

        eventMethod Event_Modded_Revive
            call thistype(params.Unit.GetTrigger()).Update()
        endmethod

        eventMethod Event_Modded_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            call Unit(this).Event.Remove(MODDED_DEATH_EVENT)
            call Unit(this).Event.Remove(MODDED_REVIVE_EVENT)
        endmethod

        eventMethod Event_Modded_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            call Unit(this).Event.Add(MODDED_DEATH_EVENT)
            call Unit(this).Event.Add(MODDED_REVIVE_EVENT)
        endmethod

        Timer trans_delayTimer

        timerMethod Trans_Delay
            local thistype this = Timer.GetExpired().GetData()

            call Unit(this).Buffs.Remove(thistype.TRANS_BUFF)

            call this.UpdateSimple()
        endmethod

        eventMethod Event_Trans_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            local Timer delayTimer = this.trans_delayTimer

            call delayTimer.Destroy()
        endmethod

        eventMethod Event_Trans_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            local Timer delayTimer = Timer.Create()

            set this.trans_delayTimer = delayTimer
            call delayTimer.SetData(this)

            call delayTimer.Start(1.01, false, function thistype.Trans_Delay)
        endmethod

        method Update takes nothing returns nothing
            local real valD = this.GetAll() - Unit(this).Type.Get().Scale.Get()

            call Unit(this).Buffs.RemoveBySelf(thistype.DUMMY_BUFF_ID)

            if (valD == 0) then
                call Unit(this).Buffs.Remove(thistype.MODDED_BUFF)

                call this.UpdateSimple()

                return
            endif

            if Unit(this).Classes.Contains(UnitClass.DEAD) then
                call this.UpdateSimple()

                return
            endif

            local integer dummySpellId = thistype.DUMMY_SPELLS_ID[Math.LimitI(Real.ToInt(((valD) - thistype.MIN) / thistype.STEP_SIZE), thistype.MIN_INDEX, thistype.MAX_INDEX)]

            call DummyUnit.WORLD_CASTER.Abilities.AddBySelf(dummySpellId)

            call DummyUnit.WORLD_CASTER.Order.UnitTargetInstantly(Order.BLOOD_LUST, this)

            call DummyUnit.WORLD_CASTER.Abilities.RemoveBySelf(dummySpellId)

            call this.UpdateSimple()

            call Unit(this).Buffs.Add(thistype.MODDED_BUFF, 1)
            call Unit(this).Buffs.Add(thistype.TRANS_BUFF, 1)
            
            call Unit(this).Selection.UpdateCircle()
        endmethod

        method SetSimple takes real val returns nothing
            set this.value = val

            call this.UpdateSimple()
        endmethod

        method Set takes real val returns nothing
            set this.value = val

            call this.Update()
        endmethod

        method AddSimple takes real val returns nothing
            call this.SetSimple(this.Get() + val)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAddSub("real")

        eventMethod Event_TypeChange
            local UnitType sourceType = params.UnitType.GetSource()
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            call this.Add(targetType.Scale.Get() - sourceType.Scale.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = Unit(this).Type.Get().Scale.Get()

            call this.Bonus.Event_Create()
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.MODDED_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Modded_BuffGain))
            call thistype.MODDED_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Modded_BuffLose))

            call thistype.TRANS_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Trans_BuffGain))
            call thistype.TRANS_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Trans_BuffLose))
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            set thistype.MODDED_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Modded_Death)
            set thistype.MODDED_REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Modded_Revive)

            call thistype(NULL).Bonus.Init()
            call thistype(NULL).Timed.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("VertexColor")
        //! runtextmacro Struct("Red")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().VertexColor.Red.Get()")
        endstruct

        //! runtextmacro Struct("Green")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().VertexColor.Green.Get()")
        endstruct

        //! runtextmacro Struct("Blue")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().VertexColor.Blue.Get()")
        endstruct

        //! runtextmacro Struct("Alpha")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().VertexColor.Alpha.Get()")
        endstruct

        //! runtextmacro Struct("Timed")
            static Event DESTROY_EVENT
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            static UnitState STATE
            //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "16")
            static Timer UPDATE_TIMER

            real bonusRedPerInterval
            real bonusGreenPerInterval
            real bonusBluePerInterval
            real bonusAlphaPerInterval
            Timer durationTimer
            Unit parent

            method Ending takes Timer durationTimer, Unit parent returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                if parent.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                    call parent.Event.Remove(DESTROY_EVENT)
                endif
                if this.RemoveFromList() then
                    call thistype.UPDATE_TIMER.Pause()
                endif
            endmethod

            eventMethod Event_Destroy
                local Unit parent = params.Unit.GetTrigger()

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.Ending(this.durationTimer, parent)

                    set iteration = iteration - 1
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                endloop
            endmethod

            timerMethod EndingByTimer
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                call this.Ending(durationTimer, this.parent)
            endmethod

            static method Update takes nothing returns nothing
                local integer iteration = thistype.ALL_COUNT

                loop
                    local thistype this = thistype.ALL[iteration]

                    call this.parent.VertexColor.Add(this.bonusRedPerInterval, this.bonusGreenPerInterval, this.bonusBluePerInterval, this.bonusAlphaPerInterval)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endmethod

            method Add takes real red, real green, real blue, real alpha, real duration returns nothing
                local Unit parent = this

                if (duration == 0.) then
                    call Unit(this).VertexColor.Add(red, green, blue, alpha)

                    return
                endif

				local integer wavesAmount = Real.ToInt(duration / UPDATE_TIME)

                set this = thistype.allocate()

				local Timer durationTimer = Timer.Create()

                set this.bonusRedPerInterval = red / wavesAmount
                set this.bonusGreenPerInterval = green / wavesAmount
                set this.bonusBluePerInterval = blue / wavesAmount
                set this.bonusAlphaPerInterval = alpha / wavesAmount
                set this.durationTimer = durationTimer
                set this.parent = parent
                call durationTimer.SetData(this)
                if parent.Data.Integer.Table.Add(KEY_ARRAY, this) then
                    call parent.Event.Add(DESTROY_EVENT)
                endif

                if this.AddToList() then
                    call thistype.UPDATE_TIMER.Start(UPDATE_TIME, true, function thistype.Update)
                endif

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)
            endmethod

            method Subtract takes real red, real green, real blue, real alpha, real duration returns nothing
                call this.Add(-red, -green, -blue, -alpha, duration)
            endmethod

	        real mod_red
	        real mod_green
	        real mod_blue
	        real mod_alpha
	        real mod_duration

	        eventMethod Event_State	
				local UnitMod mod = params.UnitMod.GetTrigger()
	
				local real red = thistype(mod).mod_red
				local real green = thistype(mod).mod_green
				local real blue = thistype(mod).mod_blue
				local real alpha = thistype(mod).mod_alpha
				local real duration = thistype(mod).mod_duration
	
	            if params.Bool.GetAdded() then
	                call thistype(params.Unit.GetTrigger()).Add(red, green, blue, alpha, duration)
	            else
	                call thistype(params.Unit.GetTrigger()).Subtract(red, green, blue, alpha, duration)
	            endif
	        endmethod

	        eventMethod Event_ModLose
	            local UnitMod mod = params.UnitMod.GetTrigger()
	
	            call thistype(params.Unit.GetTrigger()).Subtract(thistype(mod).mod_red, thistype(mod).mod_green, thistype(mod).mod_blue, thistype(mod).mod_alpha, thistype(mod).mod_duration)
	        endmethod
	
	        eventMethod Event_ModGain
	            local UnitMod mod = params.UnitMod.GetTrigger()
	
	            call thistype(params.Unit.GetTrigger()).Add(thistype(mod).mod_red, thistype(mod).mod_green, thistype(mod).mod_blue, thistype(mod).mod_alpha, thistype(mod).mod_duration)
	        endmethod
	
	        method CreateMod takes real red, real green, real blue, real alpha, real duration returns UnitMod
	            local UnitMod mod = UnitMod.Create(thistype.STATE, function thistype.Event_ModGain, function thistype.Event_ModLose)
	
	            set thistype(mod).mod_red = red
	            set thistype(mod).mod_green = green
	            set thistype(mod).mod_blue = blue
	            set thistype(mod).mod_alpha = alpha
	            set thistype(mod).mod_duration = duration
	
	            return mod
	        endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
                set thistype.UPDATE_TIMER = Timer.Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("VertexColor")
        static Event DESTROY_EVENT
        //! runtextmacro GetKey("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static UnitState STATE

        //! runtextmacro GetKeyArray("RED_KEY_ARRAY_DETAIL")
        //! runtextmacro GetKeyArray("GREEN_KEY_ARRAY_DETAIL")
        //! runtextmacro GetKeyArray("BLUE_KEY_ARRAY_DETAIL")
        //! runtextmacro GetKeyArray("ALPHA_KEY_ARRAY_DETAIL")

        //! runtextmacro LinkToStruct("VertexColor", "Red")
        //! runtextmacro LinkToStruct("VertexColor", "Green")
        //! runtextmacro LinkToStruct("VertexColor", "Blue")
        //! runtextmacro LinkToStruct("VertexColor", "Alpha")

        //! runtextmacro LinkToStruct("VertexColor", "Timed")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method GetRedForPlayer takes User whichPlayer returns real
            return Unit(this).Data.Real.Get(RED_KEY_ARRAY_DETAIL + whichPlayer)
        endmethod

        method GetGreenForPlayer takes User whichPlayer returns real
            return Unit(this).Data.Real.Get(GREEN_KEY_ARRAY_DETAIL + whichPlayer)
        endmethod

        method GetBlueForPlayer takes User whichPlayer returns real
            return Unit(this).Data.Real.Get(BLUE_KEY_ARRAY_DETAIL + whichPlayer)
        endmethod

        method GetAlphaForPlayer takes User whichPlayer returns real
            return Unit(this).Data.Real.Get(ALPHA_KEY_ARRAY_DETAIL + whichPlayer)
        endmethod

        method Set takes real red, real green, real blue, real alpha returns nothing
            local User whichPlayer = User.GetLocal()

            call this.Red.Set(red)
            call this.Green.Set(green)
            call this.Blue.Set(blue)
            call this.Alpha.Set(alpha)
            if Unit(this).Invisibility.Is() then
                set alpha = UNIT.Invisibility.ALPHA
            endif

            call SetUnitVertexColor(Unit(this).self, Real.ToInt(red + this.GetRedForPlayer(whichPlayer)), Real.ToInt(green + this.GetGreenForPlayer(whichPlayer)), Real.ToInt(blue + this.GetBlueForPlayer(whichPlayer)), Real.ToInt(alpha + this.GetAlphaForPlayer(whichPlayer)))
        endmethod

        eventMethod Event_Destroy
            local Unit parent = params.Unit.GetTrigger()
            local User whichPlayer

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            call parent.Event.Remove(DESTROY_EVENT)
            loop
                set whichPlayer = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call parent.Data.Integer.Table.Remove(KEY_ARRAY, whichPlayer)
                call parent.Data.Integer.Remove(RED_KEY_ARRAY_DETAIL + whichPlayer)
                call parent.Data.Integer.Remove(GREEN_KEY_ARRAY_DETAIL + whichPlayer)
                call parent.Data.Integer.Remove(BLUE_KEY_ARRAY_DETAIL + whichPlayer)
                call parent.Data.Integer.Remove(ALPHA_KEY_ARRAY_DETAIL + whichPlayer)
                call whichPlayer.Data.Integer.Remove(KEY)

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method SetForPlayer takes real red, real green, real blue, real alpha, User whichPlayer returns nothing
            if not whichPlayer.Data.Boolean.Is(KEY) then
                call whichPlayer.Data.Boolean.Add(KEY)
                if Unit(this).Data.Integer.Table.Add(KEY_ARRAY, whichPlayer) then
                    call Unit(this).Event.Add(DESTROY_EVENT)
                endif
            endif
            call Unit(this).Data.Real.Set(RED_KEY_ARRAY_DETAIL + whichPlayer, red)
            call Unit(this).Data.Real.Set(GREEN_KEY_ARRAY_DETAIL + whichPlayer, green)
            call Unit(this).Data.Real.Set(BLUE_KEY_ARRAY_DETAIL + whichPlayer, blue)
            call Unit(this).Data.Real.Set(ALPHA_KEY_ARRAY_DETAIL + whichPlayer, alpha)
            call SetUnitVertexColor(Unit(this).self, Real.ToInt(this.Red.Get() + red), Real.ToInt(this.Green.Get() + green), Real.ToInt(this.Blue.Get() + blue), Real.ToInt(this.Alpha.Get() + alpha))
        endmethod

        method Add takes real red, real green, real blue, real alpha returns nothing
            call this.Set(this.Red.Get() + red, this.Green.Get() + green, this.Blue.Get() + blue, this.Alpha.Get() + alpha)
        endmethod

        method AddForPlayer takes real red, real green, real blue, real alpha, User whichPlayer returns nothing
            call this.SetForPlayer(this.GetRedForPlayer(whichPlayer) + red, this.GetGreenForPlayer(whichPlayer) + green, this.GetBlueForPlayer(whichPlayer) + blue, this.GetAlphaForPlayer(whichPlayer) + alpha, whichPlayer)
        endmethod

        method Subtract takes real red, real green, real blue, real alpha returns nothing
            call this.Add(-red, -green, -blue, -alpha)
        endmethod

        method SubtractForPlayer takes real red, real green, real blue, real alpha, User whichPlayer returns nothing
            call this.AddForPlayer(-red, -green, -blue, -alpha, whichPlayer)
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Red.Get(), this.Green.Get(), this.Blue.Get(), this.Alpha.Get())
        endmethod

        //! runtextmacro GetKey("STATE_RED_KEY")
        //! runtextmacro GetKey("STATE_GREEN_KEY")
        //! runtextmacro GetKey("STATE_BLUE_KEY")
        //! runtextmacro GetKey("STATE_ALPHA_KEY")

        real mod_red
        real mod_green
        real mod_blue
        real mod_alpha

        eventMethod Event_State
            //local real red = params.Dynamic.GetReal(STATE_RED_KEY)
            //local real green = params.Dynamic.GetReal(STATE_GREEN_KEY)
            //local real blue = params.Dynamic.GetReal(STATE_BLUE_KEY)
            //local real alpha = params.Dynamic.GetReal(STATE_ALPHA_KEY)

			local UnitMod mod = params.UnitMod.GetTrigger()

			local real red = thistype(mod).mod_red
			local real green = thistype(mod).mod_green
			local real blue = thistype(mod).mod_blue
			local real alpha = thistype(mod).mod_alpha

            if params.Bool.GetAdded() then
                call thistype(params.Unit.GetTrigger()).Add(red, green, blue, alpha)
            else
                call thistype(params.Unit.GetTrigger()).Subtract(red, green, blue, alpha)
            endif
        endmethod

        eventMethod Event_ModLose
            local UnitMod mod = params.UnitMod.GetTrigger()

            call thistype(params.Unit.GetTrigger()).Subtract(thistype(mod).mod_red, thistype(mod).mod_green, thistype(mod).mod_blue, thistype(mod).mod_alpha)
        endmethod

        eventMethod Event_ModGain
            local UnitMod mod = params.UnitMod.GetTrigger()

            call thistype(params.Unit.GetTrigger()).Add(thistype(mod).mod_red, thistype(mod).mod_green, thistype(mod).mod_blue, thistype(mod).mod_alpha)
        endmethod

        method CreateMod takes real red, real green, real blue, real alpha returns UnitMod
            local UnitMod mod = UnitMod.Create(thistype.STATE, function thistype.Event_ModGain, function thistype.Event_ModLose)

            set thistype(mod).mod_red = red
            set thistype(mod).mod_green = green
            set thistype(mod).mod_blue = blue
            set thistype(mod).mod_alpha = alpha

            return mod
        endmethod

        eventMethod Event_TypeChange
            local UnitType sourceType = params.UnitType.GetSource()
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            call this.Add(targetType.VertexColor.Red.Get() - sourceType.VertexColor.Red.Get(), targetType.VertexColor.Green.Get() - sourceType.VertexColor.Green.Get(), targetType.VertexColor.Blue.Get() - sourceType.VertexColor.Blue.Get(), targetType.VertexColor.Alpha.Get() - sourceType.VertexColor.Alpha.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            local UnitType thisType = Unit(this).Type.Get()

            set this.Red.value = thisType.VertexColor.Red.Get()
            set this.Green.value = thisType.VertexColor.Green.Get()
            set this.Blue.value = thisType.VertexColor.Blue.Get()
            set this.Alpha.value = thisType.VertexColor.Alpha.Get()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)

            call thistype(NULL).Timed.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Cold")
        //! runtextmacro CreateSimpleFlagState_NotStart()

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

	//! runtextmacro Struct("Frost")
		eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()
            
            call parent.BloodExplosion.Set(parent.Type.Get().BloodExplosion.Get())
        endmethod
        
		eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call parent.BloodExplosion.Set(thistype.SPECIAL_EFFECT_PATH)
        endmethod
            
        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call thistype.DUMMY_BUFF.Variants.Add(thistype.NORMAL_BUFF)
            
            call UNIT.Cold.DUMMY_BUFF.Variants.Add(thistype.DUMMY_BUFF)
            call UNIT.Death.Explosion.DUMMY_BUFF.Variants.Add(thistype.DUMMY_BUFF)
            call UNIT.Stun.DUMMY_BUFF.Variants.Add(thistype.DUMMY_BUFF)
        endmethod

        static method Init takes nothing returns nothing
        endmethod
	endstruct

    //! runtextmacro Folder("Invisibility")
        //! runtextmacro Struct("Reveal")
            static constant real STANDARD_DURATION = 2.

            //! runtextmacro CreateSimpleFlagState_NotStart()

            eventMethod Event_BuffLose
                local Unit parent = params.Unit.GetTrigger()

                call thistype(parent).Set(false)

                if parent.Invisibility.Is() then
                    call parent.Abilities.AddBySelf(UNIT.Invisibility.DUMMY_SPELL_ID)
                endif
            endmethod

            eventMethod Event_BuffGain
                local Unit parent = params.Unit.GetTrigger()

                call thistype(parent).Set(true)

                if parent.Invisibility.Is() then
                    call parent.Abilities.RemoveBySelf(UNIT.Invisibility.DUMMY_SPELL_ID)
                    call parent.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

                    call SetUnitVertexColor(parent.self, Real.ToInt(parent.VertexColor.Red.Get()), Real.ToInt(parent.VertexColor.Green.Get()), Real.ToInt(parent.VertexColor.Blue.Get()), UNIT.Invisibility.ALPHA)
                endif
            endmethod

            method Subtract takes nothing returns nothing
                call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
            endmethod

            method Add takes nothing returns nothing
                call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
            endmethod

            method AddTimed takes real duration returns nothing
                call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Set(false)
            endmethod

            initMethod Buff_Init of Header_Buffs
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            endmethod

            static method Init takes nothing returns nothing
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Invisibility")
        static constant integer ALPHA = 128
        static Event ATTACK_EVENT
        static Event CAST_EVENT
        static EventType ENDING_EVENT_TYPE

        Timer attackTimer

        //! runtextmacro LinkToStruct("Invisibility", "Reveal")

        //! runtextmacro CreateSimpleFlagState_NotStart()
        //! runtextmacro CreateAnyFlagState("perm", "Perm")

        method Ending_TriggerEvents takes nothing returns nothing
            local Unit parent = this

            local EventResponse params = EventResponse.Create(parent.Id.Get())

            call params.Unit.SetTrigger(this)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = parent.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call parent.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
        endmethod

        timerMethod EndingByAttackTimer
            local thistype this = Timer.GetExpired().GetData()

            local Unit parent = this

			if this.IsPerm() then
				return
			endif

            call this.Reveal.AddTimed(UNIT.Invisibility.Reveal.STANDARD_DURATION)

            call parent.Buffs.Remove(thistype.TIMED_BUFF)
        endmethod

        eventMethod Event_Attack
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            call this.attackTimer.Start(parent.Damage.Delay.Get() + 0.01, false, function thistype.EndingByAttackTimer)
        endmethod

        eventMethod Event_Cast
            local Unit parent = params.Unit.GetTrigger()

            call parent.Buffs.Remove(thistype.TIMED_BUFF)
        endmethod

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            call this.Set(false)

            call parent.Event.Remove(ATTACK_EVENT)
            call parent.Event.Remove(CAST_EVENT)
            call this.attackTimer.Destroy()

            call parent.Abilities.RemoveBySelf(thistype.DUMMY_SPELL_ID)
            call parent.Classes.RemoveNative(UNIT_TYPE_PEON)

            call parent.VertexColor.Update()

            call this.Ending_TriggerEvents()
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            call this.Set(true)

            local Timer attackTimer = Timer.Create()

            set this.attackTimer = attackTimer
            call attackTimer.SetData(this)
            call parent.Event.Add(ATTACK_EVENT)
            call parent.Event.Add(CAST_EVENT)

			call parent.Classes.AddNative(UNIT_TYPE_PEON)

            if not this.Reveal.Is() then
                call parent.Abilities.AddBySelf(thistype.DUMMY_SPELL_ID)
            endif

			if not parent.Classes.Contains(UnitClass.DEAD) then
				call parent.Order.Deaggravate()
			endif
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.TIMED_BUFF, 1, duration)
        endmethod

        eventMethod Event_PermBuffLose
            local Unit parent = params.Unit.GetTrigger()

			call thistype(parent).SetPerm(false)

            call thistype(parent).Subtract()
        endmethod

        eventMethod Event_PermBuffGain
            local Unit parent = params.Unit.GetTrigger()

			call thistype(parent).SetPerm(true)

            call thistype(parent).Add()
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
            call this.SetPerm(false)

            call this.Reveal.Event_Create()
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call thistype.TIMED_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.TIMED_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call thistype.PERM_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_PermBuffGain))
            call thistype.PERM_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_PermBuffLose))
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ATTACK_EVENT = Event.Create(UNIT.Attack.Events.OFFENDED_REVERSED_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Attack)
            set thistype.CAST_EVENT = Event.Create(UNIT.Abilities.Events.Begin.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Cast)
            set thistype.ENDING_EVENT_TYPE = EventType.Create()

            call thistype(NULL).Reveal.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Ghost")
        static UnitState STATE

        //! runtextmacro CreateSimpleFlagState_NotStart()

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)

            call parent.Abilities.RemoveBySelf(thistype.DUMMY_SPELL_ID)

            call parent.VertexColor.Update()
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)

            call parent.Abilities.AddBySelf(thistype.DUMMY_SPELL_ID)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method Change takes boolean val returns nothing
            if val then
                call this.Add()
            else
                call this.Subtract()
            endif
        endmethod

        eventMethod Event_State
            call thistype(params.Unit.GetTrigger()).Change(params.Bool.GetVal())
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod

        static method Init takes nothing returns nothing
            set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
        endmethod
    endstruct

    //! runtextmacro Struct("HealAbility")
        static UnitState BONUS_STATE

        //! runtextmacro CreateSimpleAddState("real", "1.")

        eventMethod Event_State
            call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
        endmethod

        static method Init takes nothing returns nothing
            set thistype.BONUS_STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
        endmethod
    endstruct

    //! runtextmacro Folder("MaxLife")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxLife.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = Unit(this).Type.Get().Life.Get()
            endmethod

            static method Init takes nothing returns nothing
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            static UnitState STATE

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxLife.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxLife.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("MaxLife")
        //! runtextmacro LinkToStruct("MaxLife", "Base")
        //! runtextmacro LinkToStruct("MaxLife", "Bonus")
        //! runtextmacro LinkToStruct("MaxLife", "Relative")

        method SetEx takes real oldValue, real value returns nothing
            local real curLife = Unit(this).Life.Get()

            if (curLife == 0.) then
                return
            endif

            call Unit(this).Life.Set(curLife / oldValue * value)
        endmethod

        //! runtextmacro Unit_CreateStateWithTemporaryAbilities("MaxLife")

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method UpdateByNative takes nothing returns nothing
            set this.value = GetUnitState(Unit(this).self, UNIT_STATE_MAX_LIFE)

            call this.Update()
        endmethod

        eventMethod Event_TypeChange
            local UnitType sourceType = params.UnitType.GetSource()
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            //set this.nativeValue = targetType.Life.GetBJ()
            set this.value = this.Get() + targetType.Life.GetBJ() - sourceType.Life.GetBJ()

			call this.Base.Add(targetType.Life.Get() - sourceType.Life.Get())

			call Unit(this).Life.UpdateByNative()
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = Unit(this).Type.Get().Life.GetBJ()

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
        	call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            call thistype(NULL).Base.Init()
            call thistype(NULL).Bonus.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Life")
        static Unit DAMAGE_SOURCE = NULL
        static EventType DUMMY_EVENT_TYPE
        static constant real LIMIT_OF_DEATH = 0.405

        static constant real IMMORTAL = thistype.LIMIT_OF_DEATH + 1.

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        static method TriggerEvents takes Unit parent, real oldValue, real value returns nothing
            local EventResponse params = EventResponse.Create(parent.Id.Get())

            call params.Unit.SetTrigger(parent)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    local Event whichEvent = parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2)

                    if whichEvent.Limit.Is() then
                        local limitop limitOperator = whichEvent.Limit.GetOperator()
                        local integer limitValue = whichEvent.Limit.GetValue()

                        if (Math.Compare(value, limitOperator, limitValue) and not Math.Compare(oldValue, limitOperator, limitValue)) then
                            call whichEvent.Run(params)
                        endif
                    else
                        call whichEvent.Run(params)
                    endif

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
        endmethod

        method TriggerBeforeDeathEvent takes nothing returns nothing
            local Unit killer = thistype.DAMAGE_SOURCE

            set thistype.DAMAGE_SOURCE = NULL

            call Unit(this).Death.Events.Before_Event_Life(killer)
        endmethod

        method Set takes real value returns nothing
            local real oldValue = this.Get()

            local boolean causesDeath = (not Unit(this).Classes.Contains(UnitClass.DEAD) and (value < thistype.LIMIT_OF_DEATH))

            set value = Math.Limit(value, 0., Unit(this).MaxLife.Get())

            set this.value = value
            if causesDeath then
                if Unit(this).Death.Protection.Try() then
                    set causesDeath = false
                    set value = thistype.IMMORTAL
                else
                    call this.TriggerBeforeDeathEvent()
                endif
            endif

            //call SetUnitState(Unit(this).self, UNIT_STATE_LIFE, value)
            call SetWidgetLife(Unit(this).self, value)

            call thistype.TriggerEvents(this, oldValue, value)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

        method Event_Create takes nothing returns nothing
            local real value = Unit(this).MaxLife.Get()

            set this.value = value
            call SetWidgetLife(Unit(this).self, value)
        endmethod

        method UpdateByNative takes nothing returns nothing
            call this.Set(GetUnitState(Unit(this).self, UNIT_STATE_LIFE))
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DUMMY_EVENT_TYPE = EventType.Create()
        endmethod
    endstruct

    //! runtextmacro Folder("LifeRegeneration")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).LifeRegeneration.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_TypeChange
                local UnitType sourceType = params.UnitType.GetSource()
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.Add(targetType.LifeRegeneration.Get() - sourceType.LifeRegeneration.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = Unit(this).Type.Get().LifeRegeneration.Get()
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            static UnitState STATE

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).LifeRegeneration.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct

        //! runtextmacro Struct("Disablement")
        	static UnitState STATE

            //! runtextmacro CreateSimpleFlagState_NotStart()

            eventMethod Event_BuffLose
                local Unit parent = params.Unit.GetTrigger()

                call thistype(parent).Set(false)

                if (parent.LifeRegeneration.Get() > 0.) then
                    call parent.LifeRegeneration.Activate()
                endif
            endmethod

            eventMethod Event_BuffGain
                local Unit parent = params.Unit.GetTrigger()

                call thistype(parent).Set(true)

                call parent.LifeRegeneration.Deactivate()
            endmethod

            method Subtract takes nothing returns nothing
                call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
            endmethod

            method Add takes nothing returns nothing
                call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
            endmethod

	        method Change takes boolean val returns nothing
	            if val then
	                call this.Add()
	            else
	                call this.Subtract()
	            endif
	        endmethod
	
	        eventMethod Event_State
	            call thistype(params.Unit.GetTrigger()).Change(not params.Bool.GetVal())
	        endmethod

            eventMethod Event_Death
                call thistype(params.Unit.GetTrigger()).Add()
            endmethod

            eventMethod Event_Revive
                call thistype(params.Unit.GetTrigger()).Subtract()
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Set(false)
            endmethod

            initMethod Buff_Init of Header_Buffs
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            endmethod

            static method Init takes nothing returns nothing
            	set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
                call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death).AddToStatics()
                call Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
        	static UnitState STATE

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).LifeRegeneration.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("LifeRegeneration")
        static constant real INTERVAL = 1.5
        static Timer INTERVAL_TIMER

        //! runtextmacro LinkToStruct("LifeRegeneration", "Base")
        //! runtextmacro LinkToStruct("LifeRegeneration", "Bonus")
        //! runtextmacro LinkToStruct("LifeRegeneration", "Disablement")
        //! runtextmacro LinkToStruct("LifeRegeneration", "Relative")

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")
        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Disable takes nothing returns nothing
            call this.Disablement.Add()
        endmethod

        method Enable takes nothing returns nothing
            call this.Disablement.Subtract()
        endmethod

        timerMethod Interval
            call thistype.FOR_EACH_LIST_Set()

            loop
                local thistype this = thistype.FOR_EACH_LIST_FetchFirst()
                exitwhen (this == NULL)

                call Unit(this).Life.Add(this.Get() * thistype.INTERVAL)
            endloop
        endmethod

        method Activate takes nothing returns nothing
            if thistype.ACTIVE_LIST_Add(this) then
                call thistype.INTERVAL_TIMER.Start(thistype.INTERVAL, true, function thistype.Interval)
            endif
        endmethod

        method Deactivate takes nothing returns nothing
            if thistype.ACTIVE_LIST_Remove(this) then
                call thistype.INTERVAL_TIMER.Pause()
            endif
        endmethod

        eventMethod Event_Destroy
            local thistype this = params.Unit.GetTrigger()

            call this.Deactivate()
        endmethod

        eventMethod Event_Death
            call thistype(params.Unit.GetTrigger()).Disable()
        endmethod

        eventMethod Event_Revive
            call thistype(params.Unit.GetTrigger()).Enable()
        endmethod

        method Set takes real value returns nothing
            local real oldValue = this.value

            set this.value = value

            if ((oldValue > 0.) == (value > 0.)) then
                return
            endif

            if Unit(this).Buffs.Contains(thistype(NULL).Disablement.DUMMY_BUFF) then
                return
            endif

            if (value > 0.) then
                call this.Activate()
            else
                call this.Deactivate()
            endif
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0.

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()
            call this.Disablement.Event_Create()
            call this.Relative.Event_Create()

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.INTERVAL_TIMER = Timer.Create()
            call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death).AddToStatics()
            call Event.Create(UNIT.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy).AddToStatics()
            call Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive).AddToStatics()

            call thistype(NULL).Base.Init()
            call thistype(NULL).Bonus.Init()
            call thistype(NULL).Disablement.Init()
            call thistype(NULL).Relative.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("MaxMana")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxMana.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = Unit(this).Type.Get().Mana.Get()
            endmethod

            static method Init takes nothing returns nothing
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            static UnitState STATE

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxMana.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxMana.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("MaxMana")
        //! runtextmacro LinkToStruct("MaxMana", "Base")
        //! runtextmacro LinkToStruct("MaxMana", "Bonus")
        //! runtextmacro LinkToStruct("MaxMana", "Relative")

        method SetEx takes real oldValue, real value returns nothing
            if (Unit(this).Mana.Get() == 0.) then
                return
            endif

            call Unit(this).Mana.Set(Unit(this).Mana.Get() / oldValue * value)
        endmethod

        //! runtextmacro Unit_CreateStateWithTemporaryAbilities("MaxMana")

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        eventMethod Event_TypeChange
            local UnitType sourceType = params.UnitType.GetSource()
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            //set this.nativeValue = targetType.Mana.GetBJ()
            set this.value = this.Get() + targetType.Mana.GetBJ() - sourceType.Mana.GetBJ()

			call this.Base.Add(targetType.Mana.Get() - sourceType.Mana.Get())

			call Unit(this).Mana.UpdateByNative()
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = Unit(this).Type.Get().Mana.GetBJ()

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
        	call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            call thistype(NULL).Base.Init()
            call thistype(NULL).Bonus.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Mana")
        static EventType DUMMY_EVENT_TYPE

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        static method TriggerEvents takes Unit parent, real oldValue, real value returns nothing
            local EventResponse params = EventResponse.Create(parent.Id.Get())

            call params.Unit.SetTrigger(parent)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    local Event whichEvent = parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2)

                    local limitop limitOperator = whichEvent.Limit.GetOperator()
                    local integer limitValue = whichEvent.Limit.GetValue()

                    if (Math.Compare(value, limitOperator, limitValue) and not Math.Compare(oldValue, limitOperator, limitValue)) then
                        call whichEvent.Run(params)
                    endif

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
        endmethod

        method Set takes real value returns nothing
            local real oldValue = this.Get()

            set value = Math.Limit(value, 0., Unit(this).MaxMana.Get())

            set this.value = value
            call SetUnitState(Unit(this).self, UNIT_STATE_MANA, value)

            call thistype.TriggerEvents(this, oldValue, value)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

        method Event_Create takes nothing returns nothing
            local real value = Unit(this).MaxMana.Get()

            set this.value = value
            call SetUnitState(Unit(this).self, UNIT_STATE_MANA, value)
        endmethod

        method SubtractNoNative takes real value returns nothing
            local real oldValue = this.Get()

            set value = Math.Limit(oldValue - value, 0., Unit(this).MaxMana.Get())

            set this.value = value

            call thistype.TriggerEvents(this, oldValue, value)
        endmethod

        method UpdateByNative takes nothing returns nothing
            call this.Set(GetUnitState(Unit(this).self, UNIT_STATE_MANA))
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DUMMY_EVENT_TYPE = EventType.Create()
        endmethod
    endstruct

    //! runtextmacro Folder("ManaRegeneration")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).ManaRegeneration.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_TypeChange
                local UnitType sourceType = params.UnitType.GetSource()
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.Add(targetType.ManaRegeneration.Get() - sourceType.ManaRegeneration.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = Unit(this).Type.Get().ManaRegeneration.Get()
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            static UnitState STATE

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).ManaRegeneration.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct

        //! runtextmacro Struct("Disablement")
        	static UnitState STATE

            //! runtextmacro CreateSimpleFlagState_NotStart()

            eventMethod Event_BuffLose
                local Unit parent = params.Unit.GetTrigger()

                call thistype(parent).Set(false)

                if (parent.ManaRegeneration.Get() > 0.) then
                    call parent.ManaRegeneration.Activate()
                endif
            endmethod

            eventMethod Event_BuffGain
                local Unit parent = params.Unit.GetTrigger()

                call thistype(parent).Set(true)

                call parent.ManaRegeneration.Deactivate()
            endmethod

            method Subtract takes nothing returns nothing
                call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
            endmethod

            method Add takes nothing returns nothing
                call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
            endmethod

	        method Change takes boolean val returns nothing
	            if val then
	                call this.Add()
	            else
	                call this.Subtract()
	            endif
	        endmethod
	
	        eventMethod Event_State
	            call thistype(params.Unit.GetTrigger()).Change(not params.Bool.GetVal())
	        endmethod

            eventMethod Event_Death
                call thistype(params.Unit.GetTrigger()).Add()
            endmethod

            eventMethod Event_Revive
                call thistype(params.Unit.GetTrigger()).Subtract()
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Set(false)
            endmethod

            initMethod Buff_Init of Header_Buffs
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            endmethod

            static method Init takes nothing returns nothing
            	set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
                call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death).AddToStatics()
                call Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
        	static UnitState STATE

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).ManaRegeneration.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("ManaRegeneration")
        static constant real INTERVAL = 1.5
        static Timer INTERVAL_TIMER

        //! runtextmacro LinkToStruct("ManaRegeneration", "Base")
        //! runtextmacro LinkToStruct("ManaRegeneration", "Bonus")
        //! runtextmacro LinkToStruct("ManaRegeneration", "Disablement")
        //! runtextmacro LinkToStruct("ManaRegeneration", "Relative")

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")
        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Disable takes nothing returns nothing
            call this.Disablement.Add()
        endmethod

        method Enable takes nothing returns nothing
            call this.Disablement.Subtract()
        endmethod

        timerMethod Interval
            call thistype.FOR_EACH_LIST_Set()

            loop
                local thistype this = thistype.FOR_EACH_LIST_FetchFirst()
                exitwhen (this == NULL)

                call Unit(this).Mana.Add(this.Get() * thistype.INTERVAL)
            endloop
        endmethod

        method Activate takes nothing returns nothing
            if thistype.ACTIVE_LIST_Add(this) then
                call thistype.INTERVAL_TIMER.Start(thistype.INTERVAL, true, function thistype.Interval)
            endif
        endmethod

        method Deactivate takes nothing returns nothing
            if thistype.ACTIVE_LIST_Remove(this) then
                call thistype.INTERVAL_TIMER.Pause()
            endif
        endmethod

        eventMethod Event_Destroy
            local thistype this = params.Unit.GetTrigger()

            call this.Deactivate()
        endmethod

        eventMethod Event_Death
            call thistype(params.Unit.GetTrigger()).Disable()
        endmethod

        eventMethod Event_Revive
            call thistype(params.Unit.GetTrigger()).Enable()
        endmethod

        method Set takes real value returns nothing
            local real oldValue = this.value

            set this.value = value

            if ((oldValue > 0.) == (value > 0.)) then
                return
            endif

            if Unit(this).Buffs.Contains(thistype(NULL).Disablement.DUMMY_BUFF) then
                return
            endif

            if (value > 0.) then
                call this.Activate()
            else
                call this.Deactivate()
            endif
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0.

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()
            call this.Disablement.Event_Create()
            call this.Relative.Event_Create()

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.INTERVAL_TIMER = Timer.Create()
            call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death).AddToStatics()
            call Event.Create(UNIT.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy).AddToStatics()
            call Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive).AddToStatics()

            call thistype(NULL).Base.Init()
            call thistype(NULL).Bonus.Init()
            call thistype(NULL).Disablement.Init()
            call thistype(NULL).Relative.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Movement")
        //! runtextmacro Folder("Events")
            //! runtextmacro Struct("Interval")
                //! runtextmacro GetKeyArray("KEY_ARRAY")
                //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
                static Event MOVE_ENDING_EVENT
                static Event MOVE_START_EVENT

                real interval
                Timer intervalTimer
                Unit parent
                Event whichEvent
                real x
                real y

                eventMethod Event_Move_Ending
                    local Unit parent = params.Unit.GetTrigger()

                    local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                    loop
                        local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                        call this.intervalTimer.Pause()

                        set iteration = iteration - 1
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                    endloop
                endmethod

                timerMethod Interval
                    local thistype this = Timer.GetExpired().GetData()

                    local Unit parent = this.parent

                    local real parentX = parent.Position.X.Get()
                    local real parentY = parent.Position.Y.Get()

                    local EventResponse params = EventResponse.Create(parent.Id.Get())

                    call params.Real.SetDistanceSquare(Math.DistanceSquareByDeltas(parentX - this.x, parentY - this.y))
                    call params.Unit.SetTrigger(parent)

                    set this.x = parentX
                    set this.y = parentY

                    call this.whichEvent.Run(params)

                    call params.Destroy()
                endmethod

                eventMethod Event_Move_Start
                    local Unit parent = params.Unit.GetTrigger()

                    local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                    loop
                        local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                        set this.x = parent.Position.X.Get()
                        set this.y = parent.Position.Y.Get()

                        call this.intervalTimer.Start(this.interval, true, function thistype.Interval)

                        set iteration = iteration - 1
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                    endloop
                endmethod

                method Remove takes Event whichEvent returns nothing
                    local Unit parent = this

                    set this = whichEvent.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)

                    if (this == NULL) then
                        call DebugEx("not listed " + whichEvent.GetName() + ";" + parent.GetName() + ";" + I2S(parent))

                        return
                    endif

                    local Timer intervalTimer = this.intervalTimer

                    call this.deallocate()
                    call intervalTimer.Destroy()
                    call whichEvent.Data.Integer.Remove(KEY_ARRAY_DETAIL + parent)
                    if parent.Data.Integer.Table.Remove(KEY_ARRAY, this) then
//                        call parent.Event.Remove(MOVE_ENDING_EVENT)
//                        call parent.Event.Remove(MOVE_START_EVENT)
                        call parent.Movement.Events.Unreg(MOVE_ENDING_EVENT)
                        call parent.Movement.Events.Unreg(MOVE_START_EVENT)
                    endif
                endmethod

                method Add takes Event whichEvent, real interval returns nothing
                    local Unit parent = this

					set this = whichEvent.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)

					if (this != NULL) then
						call DebugEx("already listed " + whichEvent.GetName() + ";" + parent.GetName())

						return
					endif

                    set this = thistype.allocate()

					local Timer intervalTimer = Timer.Create()

                    set this.interval = interval
                    set this.intervalTimer = intervalTimer
                    set this.parent = parent
                    set this.whichEvent = whichEvent
                    call intervalTimer.SetData(this)
                    if parent.Data.Integer.Table.Add(KEY_ARRAY, this) then
//                        call parent.Event.Add(MOVE_ENDING_EVENT)
//                        call parent.Event.Add(MOVE_START_EVENT)
                        call parent.Movement.Events.Reg(MOVE_ENDING_EVENT)
                        call parent.Movement.Events.Reg(MOVE_START_EVENT)
                    endif
                    call whichEvent.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.MOVE_ENDING_EVENT = Event.Create(UNIT.Movement.Events.ENDING_EVENT_TYPE, EventPriority.EVENTS, function thistype.Event_Move_Ending)
                    set thistype.MOVE_START_EVENT = Event.Create(UNIT.Movement.Events.START_EVENT_TYPE, EventPriority.EVENTS, function thistype.Event_Move_Start)
                endmethod
            endstruct

        	//! runtextmacro Struct("EnterRegion")
            	static Event REGION_DESTROY_EVENT
            	static Event ADD_RECT_EVENT
                static EventType DUMMY_EVENT_TYPE
                static Group ENUM_GROUP


				UnitList inGroup
                UnitList regGroup

                condTrigMethod TrigConditions
                    return true
                endmethod

				method TriggerEvents takes Unit parent
                    if not this.regGroup.Contains(parent) then
                        return
                    endif

					local Region whichRegion = this

                    local EventResponse params = EventResponse.Create(whichRegion.Id.Get())

					call params.Region.SetTrigger(whichRegion)
                    call params.Unit.SetTrigger(parent)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichRegion.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichRegion.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call params.Destroy()
				endmethod

				method Do takes Region whichRegion
					local Unit parent = this

					set this = whichRegion

					if this.inGroup.Contains(parent) then
						call DebugEx("Already contains unit " + parent.GetName())

						return
					endif

					call this.inGroup.Add(parent)

					call thistype(whichRegion).TriggerEvents(parent)
				endmethod

                trigMethod Trig
                    local Unit parent = UNIT.Event.Native.GetTrigger()
                    local Region whichRegion = REGION.Event.Native.GetTrigger()

                    call thistype(parent).Do(whichRegion)
                endmethod

				enumMethod AddRect_Enum
					local thistype this = params.GetData()
					local Unit parent = params.Unit.GetTrigger()

					if this.inGroup.Contains(parent) then
						return
					endif

					local Region whichRegion = this

					if not whichRegion.ContainsUnit(parent) then
						return
					endif

					call thistype(parent).Do(whichRegion)
				endmethod

				eventMethod Event_AddRect
					local Region whichRegion = params.Region.GetTrigger()
					local Rectangle whichRect = params.Rect.GetTrigger()

					local thistype this = whichRegion

					call thistype.ENUM_GROUP.EnumUnits.InRect.Do(whichRect, NULL)

					call thistype.ENUM_GROUP.DoEx(function thistype.AddRect_Enum, this)
				endmethod

                method Reg2 takes Region whichRegion returns nothing
                    local Unit parent = this

                    set this = whichRegion

                    call this.regGroup.Add(parent)
                endmethod

                method Unreg takes Region whichRegion returns nothing
                    local Unit parent = this

                    set this = whichRegion

                    call this.regGroup.Remove(parent)
                endmethod

				eventMethod Event_RegionDestroy
					local Region whichRegion = params.Region.GetTrigger()

					call whichRegion.Clear()

					call whichRegion.Event.Remove(REGION_DESTROY_EVENT)
					call whichRegion.Event.Remove(ADD_RECT_EVENT)
				endmethod

                static method InitRegion takes Region whichRegion returns nothing
                    local thistype this = whichRegion

                    set this.regGroup = UnitList.Create()

					call whichRegion.Event.Add(REGION_DESTROY_EVENT)
					call whichRegion.Event.Add(ADD_RECT_EVENT)

                    call Trigger.CreateFromCode(function thistype.Trig).RegisterEvent.EnterRegion(whichRegion, function thistype.TrigConditions)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.ENUM_GROUP = Group.Create()

					set thistype.ADD_RECT_EVENT = Event.Create(Region.ADD_RECT_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_AddRect)
					set thistype.REGION_DESTROY_EVENT = Event.Create(Region.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_RegionDestroy)
                endmethod
        	endstruct

            //! runtextmacro Struct("Region")
            	static Rectangle DUMMY_RECT
            	static Event REGION_DESTROY_EVENT
            	static Event ADD_RECT_EVENT
            	static Event REMOVE_RECT_EVENT
            	static Event PARENT_DESTROY_EVENT
                static Group ENUM_GROUP
                //! runtextmacro GetKeyArray("KEY_ARRAY")
                static EventType ENTER_EVENT_TYPE
                static EventType LEAVE_EVENT_TYPE

				UnitList inGroup
                UnitList regGroup

                condTrigMethod TrigConditions
                    return true
                endmethod

				method Enter_TriggerEvents takes Unit parent
                    if not this.regGroup.Contains(parent) then
                        //return
                    endif

					local Region whichRegion = this

                    local EventResponse params = EventResponse.Create(whichRegion.Id.Get())

					call params.Region.SetTrigger(whichRegion)
                    call params.Unit.SetTrigger(parent)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichRegion.Event.Count(thistype.ENTER_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichRegion.Event.Get(thistype.ENTER_EVENT_TYPE, priority, iteration2).Run(params)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call params.Destroy()
				endmethod

				method Enter takes Region whichRegion
					local Unit parent = this

					set this = whichRegion

					if this.inGroup.Contains(parent) then
						call DebugEx("Already contains unit " + parent.GetName())

						return
					endif

					call this.inGroup.Add(parent)
					if parent.Data.Integer.Table.Add(KEY_ARRAY, this) then
						call parent.Event.Add(PARENT_DESTROY_EVENT)
					endif

					call thistype(whichRegion).Enter_TriggerEvents(parent)
				endmethod

                trigMethod EnterTrig
                    local Unit parent = UNIT.Event.Native.GetTrigger()
                    local Region whichRegion = REGION.Event.Native.GetTrigger()

					if (parent == STRUCT_INVALID) then
						return
					endif

                    call thistype(parent).Enter(whichRegion)
                endmethod

				method Leave_TriggerEvents takes Unit parent
                    if not this.regGroup.Contains(parent) then
                        //return
                    endif

					local Region whichRegion = this

                    local EventResponse params = EventResponse.Create(whichRegion.Id.Get())

					call params.Region.SetTrigger(whichRegion)
                    call params.Unit.SetTrigger(parent)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichRegion.Event.Count(thistype.LEAVE_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichRegion.Event.Get(thistype.LEAVE_EVENT_TYPE, priority, iteration2).Run(params)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call params.Destroy()
				endmethod

				method Leave takes Region whichRegion
					local Unit parent = this

					set this = whichRegion

					if not this.inGroup.Contains(parent) then
						call DebugEx("Does not contain unit " + parent.GetName())

						return
					endif

					call this.inGroup.Remove(parent)
					if parent.Data.Integer.Table.Remove(KEY_ARRAY, this) then
						call parent.Event.Remove(PARENT_DESTROY_EVENT)
					endif

					call thistype(whichRegion).Leave_TriggerEvents(parent)
				endmethod

                trigMethod LeaveTrig
                    local Unit parent = UNIT.Event.Native.GetTrigger()
                    local Region whichRegion = REGION.Event.Native.GetTrigger()

					if (parent == STRUCT_INVALID) then
						return
					endif

                    call thistype(parent).Leave(whichRegion)
                endmethod

				enumMethod AddRect_Enum
					local thistype this = params.GetData()
					local Unit parent = params.Unit.GetTrigger()

					if this.inGroup.Contains(parent) then
						return
					endif

					local Region whichRegion = this

					if not whichRegion.ContainsUnit(parent) then
						return
					endif

					call thistype(parent).Enter(whichRegion)
				endmethod

				eventMethod Event_AddRect
					local Region whichRegion = params.Region.GetTrigger()
					local Rectangle whichRect = params.Rect.GetTrigger()

					local thistype this = whichRegion

					call thistype.DUMMY_RECT.Set(whichRect.minX - 32, whichRect.minY - 32, whichRect.maxX + 32, whichRect.maxY + 32)

					call thistype.ENUM_GROUP.EnumUnits.InRect.Do(thistype.DUMMY_RECT, NULL)

					call thistype.ENUM_GROUP.DoEx(function thistype.AddRect_Enum, this)
				endmethod

				enumMethod RemoveRect_Enum
					local thistype this = params.GetData()
					local Unit parent = params.Unit.GetTrigger()

					if not this.inGroup.Contains(parent) then
						return
					endif

					local Region whichRegion = this

					if whichRegion.ContainsUnit(parent) then
						return
					endif

					call thistype(parent).Leave(whichRegion)
				endmethod

				eventMethod Event_RemoveRect
					local Region whichRegion = params.Region.GetTrigger()
					local Rectangle whichRect = params.Rect.GetTrigger()

					local thistype this = whichRegion

					call thistype.DUMMY_RECT.Set(whichRect.minX - 32, whichRect.minY - 32, whichRect.maxX + 32, whichRect.maxY + 32)

					call thistype.ENUM_GROUP.EnumUnits.InRect.Do(thistype.DUMMY_RECT, NULL)

					call thistype.ENUM_GROUP.DoEx(function thistype.RemoveRect_Enum, this)
				endmethod

                method Reg takes Region whichRegion returns nothing
                    local Unit parent = this

                    set this = whichRegion

                    call this.regGroup.Add(parent)
                endmethod

                method Unreg takes Region whichRegion returns nothing
                    local Unit parent = this

                    set this = whichRegion

                    call this.regGroup.Remove(parent)
                endmethod

				eventMethod Event_ParentDestroy
					local Unit parent = params.Unit.GetTrigger()

					local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

					loop
						local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

						//call this.inGroup.Remove(parent)
						call thistype(parent).Leave(this)

						set iteration = iteration - 1
						exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
					endloop
				endmethod

				eventMethod Event_RegionDestroy
					local Region whichRegion = params.Region.GetTrigger()

					local thistype this = whichRegion

					call whichRegion.Clear()

					call whichRegion.Event.Remove(REGION_DESTROY_EVENT)
					call whichRegion.Event.Remove(ADD_RECT_EVENT)
					call whichRegion.Event.Remove(REMOVE_RECT_EVENT)

					call this.inGroup.Destroy()
					call this.regGroup.Destroy()
				endmethod

                static method InitRegion takes Region whichRegion returns nothing
                    local thistype this = whichRegion

					set this.inGroup = UnitList.Create()
                    set this.regGroup = UnitList.Create()

					call whichRegion.Event.Add(REGION_DESTROY_EVENT)
					call whichRegion.Event.Add(ADD_RECT_EVENT)
					call whichRegion.Event.Add(REMOVE_RECT_EVENT)

                    call Trigger.CreateFromCode(function thistype.EnterTrig).RegisterEvent.EnterRegion(whichRegion, function thistype.TrigConditions)
                    call Trigger.CreateFromCode(function thistype.LeaveTrig).RegisterEvent.LeaveRegion(whichRegion, function thistype.TrigConditions)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.ENTER_EVENT_TYPE = EventType.Create()
                    set thistype.LEAVE_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_RECT = Rectangle.Create(0, 0, 0, 0)
                    set thistype.ENUM_GROUP = Group.Create()

					set thistype.ADD_RECT_EVENT = Event.Create(Region.ADD_RECT_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_AddRect)
					set thistype.REMOVE_RECT_EVENT = Event.Create(Region.REMOVE_RECT_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_RemoveRect)
					set thistype.REGION_DESTROY_EVENT = Event.Create(Region.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_RegionDestroy)
					set thistype.PARENT_DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_ParentDestroy)
                endmethod
            endstruct

            //! runtextmacro Struct("LeaveRegion")
            	static Event REGION_DESTROY_EVENT
            	static Event REMOVE_RECT_EVENT
                static EventType DUMMY_EVENT_TYPE
                static Group ENUM_GROUP

				UnitList inGroup
                UnitList regGroup

                condTrigMethod TrigConditions
                    return true
                endmethod

				method TriggerEvents takes Unit parent
                    if not this.regGroup.Contains(parent) then
                        return
                    endif

					local Region whichRegion = this

                    local EventResponse params = EventResponse.Create(whichRegion.Id.Get())

					call params.Region.SetTrigger(whichRegion)
                    call params.Unit.SetTrigger(parent)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = whichRegion.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call whichRegion.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call params.Destroy()
				endmethod

				method Do takes Region whichRegion
					local Unit parent = this

					set this = whichRegion

					if not this.inGroup.Contains(parent) then
						call DebugEx("Does not contain unit " + parent.GetName())

						return
					endif

					call this.inGroup.Remove(parent)

					call thistype(whichRegion).TriggerEvents(parent)
				endmethod

                trigMethod Trig
                    local Unit parent = UNIT.Event.Native.GetTrigger()
                    local Region whichRegion = REGION.Event.Native.GetTrigger()

                    call thistype(parent).Do(whichRegion)
                endmethod

				enumMethod RemoveRect_Enum
					local thistype this = params.GetData()
					local Unit parent = params.Unit.GetTrigger()

					if not this.inGroup.Contains(parent) then
						return
					endif

					local Region whichRegion = this

					if whichRegion.ContainsUnit(parent) then
						return
					endif

					call thistype(parent).Do(whichRegion)
				endmethod

				eventMethod Event_RemoveRect
					local Region whichRegion = params.Region.GetTrigger()
					local Rectangle whichRect = params.Rect.GetTrigger()

					local thistype this = whichRegion

					call thistype.ENUM_GROUP.EnumUnits.InRect.Do(whichRect, NULL)

					call thistype.ENUM_GROUP.DoEx(function thistype.RemoveRect_Enum, this)
				endmethod

                method Reg2 takes Region whichRegion returns nothing
                    local Unit parent = this

                    set this = whichRegion

                    call this.regGroup.Add(parent)
                endmethod

                method Unreg takes Region whichRegion returns nothing
                    local Unit parent = this

                    set this = whichRegion

                    call this.regGroup.Remove(parent)
                endmethod

				eventMethod Event_RegionDestroy
					local Region whichRegion = params.Region.GetTrigger()

					call whichRegion.Clear()

					call whichRegion.Event.Remove(REGION_DESTROY_EVENT)
					call whichRegion.Event.Remove(REMOVE_RECT_EVENT)
				endmethod

                static method InitRegion takes Region whichRegion returns nothing
                    local thistype this = whichRegion

                    set this.regGroup = UnitList.Create()

					call whichRegion.Event.Add(REGION_DESTROY_EVENT)
					call whichRegion.Event.Add(REMOVE_RECT_EVENT)

                    call Trigger.CreateFromCode(function thistype.Trig).RegisterEvent.LeaveRegion(whichRegion, function thistype.TrigConditions)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.ENUM_GROUP = Group.Create()

					set thistype.REMOVE_RECT_EVENT = Event.Create(Region.REMOVE_RECT_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_RemoveRect)
					set thistype.REGION_DESTROY_EVENT = Event.Create(Region.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_RegionDestroy)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Events")
            static Trigger DUMMY_TRIGGER
            static EventType ENDING_EVENT_TYPE
            static UnitList ENUM_GROUP
            static UnitList EVENT_GROUP
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
            static UnitList MOVING_GROUP
            static EventType START_EVENT_TYPE
            static constant real THRESHOLD = 0.1
            //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "16")
            static Timer UPDATE_TIMER

            static constant real THRESHOLD_SQUARE = (thistype.THRESHOLD * thistype.THRESHOLD)

            real x
            real y

            //! runtextmacro LinkToStruct("Events", "Interval")
            //! runtextmacro LinkToStruct("Events", "Region")

            method GetOldX takes nothing returns real
                return this.x
            endmethod

            method GetOldY takes nothing returns real
                return this.y
            endmethod

            method Ending_TriggerEvents takes real distanceSquare returns nothing                
                local Unit parent = this

                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.Real.SetDistanceSquare(distanceSquare)
                call params.Unit.SetTrigger(parent)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
            endmethod

            method Start_TriggerEvents takes real distanceSquare returns nothing                
                local Unit parent = this

                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.Real.SetDistanceSquare(distanceSquare)
                call params.Unit.SetTrigger(parent)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.START_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.START_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
            endmethod

            timerMethod Trig
                loop
                    local Unit parent = thistype.EVENT_GROUP.FetchFirst()
                    exitwhen (parent == NULL)

                    local thistype this = parent
                    local real x = parent.Position.X.Get()
                    local real y = parent.Position.Y.Get()

                    local real distanceSquare = Math.DistanceSquareByDeltas(x - this.x, y - this.y)

                    call thistype.ENUM_GROUP.Add(parent)
                    if thistype.MOVING_GROUP.Contains(parent) then
                        if (distanceSquare < thistype.THRESHOLD_SQUARE) then
                            call thistype.MOVING_GROUP.Remove(parent)

                            call this.Ending_TriggerEvents(distanceSquare)
                        //else
                            //call this.Interval_TriggerEvents(distanceSquare)
                        endif

                        set this.x = x
                        set this.y = y
                    else
                        if (distanceSquare > thistype.THRESHOLD_SQUARE) then
                            set this.x = x
                            set this.y = y
                            call thistype.MOVING_GROUP.Add(parent)

                            call this.Start_TriggerEvents(distanceSquare)
                        endif
                    endif
                endloop

                call thistype.EVENT_GROUP.AddGroupClear(thistype.ENUM_GROUP)
            endmethod

            method SetStatus takes boolean moving returns nothing
                if (moving == thistype.MOVING_GROUP.Contains(this)) then
                    return
                endif

                if moving then
                    call thistype.MOVING_GROUP.Add(this)
                else
                    call thistype.MOVING_GROUP.Remove(this)
                endif
            endmethod

            method Reg takes Event whichEvent returns nothing
                local Unit parent = this

				if not parent.Data.Integer.Add(KEY_ARRAY_DETAIL + whichEvent, 1) then
					return
				endif

				call parent.Event.Add(whichEvent)

                if not parent.Data.Integer.Add(KEY, 1) then
                    return
                endif

                if thistype.EVENT_GROUP.IsEmpty() then
                    call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Trig)
                endif

                set this.x = parent.Position.X.Get()
                set this.y = parent.Position.Y.Get()
                call thistype.EVENT_GROUP.Add(parent)
            endmethod

            method RegWithInterval takes Event whichEvent, real interval returns nothing
                call this.Interval.Add(whichEvent, interval)

                call this.Reg(whichEvent)
            endmethod

            method Unreg takes Event whichEvent returns nothing
                local Unit parent = this

				if not parent.Data.Integer.Subtract(KEY_ARRAY_DETAIL + whichEvent, 1) then
					return
				endif

				call parent.Event.Remove(whichEvent)

                if not parent.Data.Integer.Subtract(KEY, 1) then
                    return
                endif

                call thistype.EVENT_GROUP.Remove(parent)

                if thistype.EVENT_GROUP.IsEmpty() then
                    call thistype.UPDATE_TIMER.Pause()
                endif

                //call this.Interval.Remove(whichEvent)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DUMMY_TRIGGER = Trigger.Create()
                set thistype.ENDING_EVENT_TYPE = EventType.Create()
                set thistype.ENUM_GROUP = UnitList.Create()
                set thistype.EVENT_GROUP = UnitList.Create()
                set thistype.MOVING_GROUP = UnitList.Create()
                set thistype.START_EVENT_TYPE = EventType.Create()
                set thistype.UPDATE_TIMER = Timer.Create()

                call thistype.DUMMY_TRIGGER.AddCode(function thistype.Trig)

                //call thistype(NULL).EnterRegion.Init()
                call thistype(NULL).Interval.Init()
                //call thistype(NULL).LeaveRegion.Init()
                call thistype(NULL).Region.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Speed")
            //! runtextmacro Struct("BaseA")
                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    call Unit(this).Movement.Speed.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                eventMethod Event_TypeChange
                    local UnitType sourceType = params.UnitType.GetSource()
                    local UnitType targetType = params.UnitType.GetTrigger()
                    local thistype this = params.Unit.GetTrigger()

                    call this.Add(targetType.Speed.Get() - sourceType.Speed.Get())
                endmethod

                method Event_Create takes nothing returns nothing
                    set this.value = Unit(this).Type.Get().Speed.Get()
                endmethod

                static method Init takes nothing returns nothing
                    call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
                endmethod
            endstruct

            //! runtextmacro Struct("BonusA")
                static UnitState STATE
                static constant real ZERO_CAP = 0.1

                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    set value = (value + Unit(this).Movement.Speed.BaseA.Get()) * (Unit(this).Movement.Speed.RelativeA.Get() - 1.)

                    if (Math.Abs(value) < thistype.ZERO_CAP) then
                        set value = 0.
                    endif

					local integer abilityLevel

                    if (value > 0.) then
                        set abilityLevel = 3
                    else
                        set abilityLevel = 1 + B2I(value < 0.)
                    endif

                    call Unit(this).Movement.Speed.Update()

                    call Unit(this).Abilities.SetLevelBySelf(thistype.DUMMY_SPELL_ID, abilityLevel)

                    call Unit(this).Display.Update()
                endmethod

                method Event_Create takes nothing returns nothing
                    set this.value = 0.
                    call Unit(this).Abilities.AddBySelf(thistype.STORAGE_SPELL_ID)
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                eventMethod Event_State
                    call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
                endmethod

                static method Init takes nothing returns nothing
                    call User.ANY.EnableAbilityBySelf(thistype.STORAGE_SPELL_ID, false)

                    set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
                endmethod
            endstruct

            //! runtextmacro Struct("RelativeA")
                static UnitState STATE

                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    call Unit(this).Movement.Speed.BonusA.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                eventMethod Event_State
                    call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
                endmethod

                method Event_Create takes nothing returns nothing
                    set this.value = 1.
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Speed")
            static constant real LOWER_CAP = 100.
            static constant real UPPER_CAP = 522.
            static constant real STAMINA_FACTOR_MAX = 1.2
            static constant real STAMINA_FACTOR_MIN = 0.6

            real bonusVal

            //! runtextmacro LinkToStruct("Speed", "BaseA")
            //! runtextmacro LinkToStruct("Speed", "BonusA")
            //! runtextmacro LinkToStruct("Speed", "RelativeA")

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method GetBonus takes nothing returns real
                return this.bonusVal
            endmethod

            method StaminaReduce takes real value returns real
                if (Unit(this).MaxStamina.Get() > 0) then
                    set value = thistype.LOWER_CAP + (value - thistype.LOWER_CAP) * ((thistype.STAMINA_FACTOR_MAX - thistype.STAMINA_FACTOR_MIN) * Unit(this).Stamina.GetFactor() + thistype.STAMINA_FACTOR_MIN)
                endif

                set value = Math.Max(thistype.LOWER_CAP, value)
                set value = Math.Min(value, thistype.UPPER_CAP)

                return value
            endmethod

            method UpdateNative takes nothing returns nothing
                call SetUnitMoveSpeed(Unit(this).self, this.StaminaReduce(this.Get()) - Math.Sign(this.GetBonus()))
            endmethod

            method Set takes real val returns nothing
                local real bonusVal = value - this.BaseA.Get()
                local real typeVal = Unit(this).Type.Get().Speed.Get()

                set this.bonusVal = bonusVal
                set this.value = val

				set val = this.StaminaReduce(val)

                call SetUnitMoveSpeed(Unit(this).self, val - Math.Sign(bonusVal))
                if (typeVal > 0) then
                    call SetUnitTimeScale(Unit(this).self, val / typeVal)
                endif
            endmethod

            method Update takes nothing returns nothing
                call this.Set(this.BaseA.Get() * this.RelativeA.Get() + this.BonusA.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.

                call this.BaseA.Event_Create()
                call this.BonusA.Event_Create()
                call this.RelativeA.Event_Create()

                call this.Update()
            endmethod

            static method Init takes nothing returns nothing
            	call thistype(NULL).BaseA.Init()
                call thistype(NULL).BonusA.Init()
                call thistype(NULL).RelativeA.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Movement")
    	static UnitState DISABLE_STATE
        static constant integer MOVE_SPELL_ID = BJUnit.Movement.MOVE_ID

        //! runtextmacro LinkToStruct("Movement", "Events")
        //! runtextmacro LinkToStruct("Movement", "Speed")

        //! runtextmacro CreateSimpleFlagState_NotStart()

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)

            call SetUnitPropWindow(parent.self, 60.)
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)

            call SetUnitPropWindow(parent.self, 0.)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DISABLE_BUFF, 1)
        endmethod

        method SubtractTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DISABLE_BUFF, 1, duration)
        endmethod

        method RemovePermanently takes nothing returns nothing
            call this.Subtract()

            call Unit(this).Abilities.RemoveBySelf(thistype.MOVE_SPELL_ID)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DISABLE_BUFF)
        endmethod

        method Change takes boolean val returns nothing
            if val then
                call this.Add()
            else
                call this.Subtract()
            endif
        endmethod

        eventMethod Event_Disable_State
            call thistype(params.Unit.GetTrigger()).Change(not params.Bool.GetVal())
        endmethod

        eventMethod Event_TypeChange
            local UnitType sourceType = params.UnitType.GetSource()
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            local boolean hasSpeed = (targetType.Speed.Get() > 0.)

            if ((sourceType.Speed.Get() > 0.) == hasSpeed) then
                if not hasSpeed then
                    call this.RemovePermanently()
                endif

                return
            endif

            if hasSpeed then
                call this.Add()
            else
                call this.RemovePermanently()
            endif
        endmethod

        method Event_Create takes nothing returns nothing
            if (Unit(this).Type.Get().Speed.Get() > 0.) then
                call this.Set(true)
            else
                call this.RemovePermanently()
            endif

            call this.Speed.Event_Create()
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DISABLE_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DISABLE_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod

        static method Init takes nothing returns nothing
        	set thistype.DISABLE_STATE = UnitState.Create(thistype.NAME, function thistype.Event_Disable_State)
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            call thistype(NULL).Events.Init()
            call thistype(NULL).Speed.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Order")
        //! runtextmacro Folder("Events")
            //! runtextmacro Struct("Lose")
                static Event DESTROY_EVENT
                static UnitList ENUM_GROUP
                static UnitList REG_GROUP
                static UnitList UPDATE_GROUP
                //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "16")
                static Timer UPDATE_TIMER

                method Unreg takes nothing returns nothing
                    call thistype.REG_GROUP.Remove(this)
                    call Unit(this).Event.Remove(DESTROY_EVENT)

                    if not thistype.UPDATE_GROUP.Contains(this) then
                        return
                    endif

                    call thistype.UPDATE_GROUP.Remove(this)

                    if thistype.UPDATE_GROUP.IsEmpty() then
                        call thistype.UPDATE_TIMER.Pause()
                    endif
                endmethod

                eventMethod Event_Destroy
                    call thistype(params.Unit.GetTrigger()).Unreg()
                endmethod

                method TriggerEvents takes nothing returns nothing
                    local Unit parent = this
                endmethod

                method Start takes nothing returns nothing
                    call Unit(this).Order.ResetData()

                    call this.TriggerEvents()
                endmethod

                timerMethod Update
                    loop
                        local Unit parent = thistype.UPDATE_GROUP.FetchFirst()
                        exitwhen (parent == NULL)

                        if (parent.Order.GetNative() == NULL) then
                            call thistype(parent).Start()
                        else
                            call thistype.ENUM_GROUP.Add(parent)
                        endif
                    endloop

                    if thistype.ENUM_GROUP.IsEmpty() then
                        call thistype.UPDATE_TIMER.Pause()
                    else
                        call thistype.UPDATE_GROUP.AddGroupClear(thistype.ENUM_GROUP)
                    endif
                endmethod

                method AddToUpdateGroup takes nothing returns nothing
                    if thistype.UPDATE_GROUP.Contains(this) then
                        return
                    endif

                    if thistype.UPDATE_GROUP.IsEmpty() then
                        call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                    endif

                    call thistype.UPDATE_GROUP.Add(this)
                endmethod

                method StartByGain takes OrderInstance newData returns nothing
                    if not thistype.REG_GROUP.Contains(this) then
                        return
                    endif

					if newData.GetOrder().IsParallel() then
						return
					endif

                    call this.Start()

                    call Unit(this).Order.SetData(newData)

                    call this.AddToUpdateGroup()
                endmethod

                method Reg takes nothing returns nothing
                    call thistype.REG_GROUP.Add(this)
                    call Unit(this).Event.Add(DESTROY_EVENT)

                    if (Unit(this).Order.GetNative() == NULL) then
                        return
                    endif

                    call this.AddToUpdateGroup()
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                    set thistype.ENUM_GROUP = UnitList.Create()
                    set thistype.REG_GROUP = UnitList.Create()
                    set thistype.UPDATE_GROUP = UnitList.Create()
                    set thistype.UPDATE_TIMER = Timer.Create()
                endmethod
            endstruct

            //! runtextmacro Folder("Gain")
                //! runtextmacro Struct("Immediate")
                    //! runtextmacro GetKeyArray("CANCEL_ITEM_USAGE_KEY_ARRAY")
                    static EventType DUMMY_EVENT_TYPE
                    static Trigger DUMMY_TRIGGER

                    method TriggerEvents takes OrderInstance data returns nothing
                    	local Unit parent = this

                        local Order whichOrder = data.GetOrder()

                        local EventResponse orderParams = EventResponse.Create(whichOrder.Id.Get())

                        call orderParams.Order.SetTrigger(whichOrder)
                        call orderParams.Unit.SetTrigger(parent)

						local EventResponse params = EventResponse.Create(parent.Id.Get())

                        call params.Order.SetTrigger(whichOrder)
                        call params.Unit.SetTrigger(parent)

						local integer iteration = EventPriority.ALL_COUNT

                        loop
                            exitwhen (iteration < ARRAY_MIN)

                            local EventPriority priority = EventPriority.ALL[iteration]

                            local integer iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                            loop
                                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                                call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                                set iteration2 = iteration2 - 1
                            endloop

                            set iteration2 = whichOrder.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                            loop
                                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                                call whichOrder.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(orderParams)

                                set iteration2 = iteration2 - 1
                            endloop

                            set iteration = iteration - 1
                        endloop

                        call orderParams.Destroy()
                        call params.Destroy()
                    endmethod

                    method Start takes OrderInstance data returns nothing
                        local Order whichOrder = data.GetOrder()

						local Spell triggerSpell = Unit(this).Abilities.GetFromOrder(whichOrder)

                        local boolean cancel = false

                        if (triggerSpell != NULL) then
                            if (triggerSpell.GetAutoCastOrderOff() == whichOrder) then
                                call Unit(this).Abilities.AutoCast.Set(NULL)
                            elseif (triggerSpell.GetAutoCastOrderOn() == whichOrder) then
                                call Unit(this).Abilities.AutoCast.Set(triggerSpell)
                            else
                                local BoolExpr orderConditions = triggerSpell.GetOrderConditions()

                                if (orderConditions != NULL) then
                                    local EventResponse params = EventResponse.Create(EventResponse.DIRECT_SUBJECT_ID)

                                    call params.Order.SetTrigger(whichOrder)
                                    call params.Unit.SetTrigger(this)
                                    call params.Spell.SetLevel(Unit(this).Abilities.GetLevel(triggerSpell))
                                    call params.Spell.SetTrigger(triggerSpell)

                                    if not orderConditions.RunWithParams(params) then
                                        call Unit(this).Stop()

                                        set cancel = true
                                    endif

                                    call params.Destroy()

                                    if cancel then
                                        return
                                    endif
                                endif
                            endif
                        endif

                        if whichOrder.IsInventoryUse() then
                            local User parentOwner = Unit(this).Owner.Get()
                            local Item triggerItem = Unit(this).Items.GetFromSlot(whichOrder.GetInventoryIndex())

                            local integer goldCost = triggerItem.Type.Get().UsageGoldCost.Get()

                            if (goldCost > parentOwner.State.Get(PLAYER_STATE_RESOURCE_GOLD)) then
                                call triggerItem.RecreateSelf(this)

                                call Unit(this).AddJumpingTextTag(String.Color.Do("Not enough gold!", String.Color.MALUS), 0.022, CANCEL_ITEM_USAGE_KEY_ARRAY + this)

                                return
                            endif

                            call parentOwner.State.Subtract(PLAYER_STATE_RESOURCE_GOLD, goldCost)

                            if (triggerItem.Classes.Contains(ItemClass.SCROLL) and Unit(this).Stun.Is()) then
                                call Unit(this).Items.Events.Use.TriggerEvents(triggerItem)
                            endif
                        endif

                        call Unit(this).Order.Events.Lose.StartByGain(data)

                        call this.TriggerEvents(data)
                    endmethod

                    boolean locked
                    OrderInstance lockData

                    method Unlock takes nothing returns nothing
                        set this.locked = false

                        local OrderInstance data = this.lockData

                        if (data == NULL) then
                            return
                        endif

                        set this.lockData = NULL

                        call this.Start(data)
                    endmethod

                    method Lock takes nothing returns nothing
                        set this.locked = true
                    endmethod

                    trigMethod Trig
                        local thistype this = UNIT.Event.Native.GetTrigger()
                        local Order whichOrder = ORDER.Event.Native.GetTrigger()

                        local OrderInstance data = OrderInstance.Create()

                        call data.SetOrder(whichOrder)

                        call data.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)

                        if this.locked then
                            if (this.lockData != NULL) then
                                call this.lockData.Destroy()
                            endif

                            set this.lockData = data

                            return
                        endif

                        if Unit(this).Transport.Is() then
                            return
                        endif

                        call this.Start(data)
                    endmethod

                    method Reg takes nothing returns nothing
                        set this.lockData = NULL
                        set this.locked = false

                        call thistype.DUMMY_TRIGGER.RegisterEvent.Unit(this, EVENT_UNIT_ISSUED_ORDER)
                    endmethod

                    static method Init takes nothing returns nothing
                        set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                        set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                    endmethod
                endstruct

                //! runtextmacro Struct("Point")
                    static EventType DUMMY_EVENT_TYPE
                    static Trigger DUMMY_TRIGGER

                    method TriggerEvents takes OrderInstance data returns nothing
                    	local Unit parent = this

                        local Order whichOrder = data.GetOrder()
                        local real targetX = data.GetTargetX()
                        local real targetY = data.GetTargetY()

                        local EventResponse orderParams = EventResponse.Create(whichOrder.Id.Get())

                        call orderParams.Order.SetTrigger(whichOrder)
                        call orderParams.Spot.SetTargetX(targetX)
                        call orderParams.Spot.SetTargetY(targetY)
                        call orderParams.Unit.SetTrigger(parent)

						local EventResponse params = EventResponse.Create(parent.Id.Get())

                        call params.Order.SetTrigger(whichOrder)
                        call params.Spot.SetTargetX(targetX)
                        call params.Spot.SetTargetY(targetY)
                        call params.Unit.SetTrigger(parent)

						local integer iteration = EventPriority.ALL_COUNT

                        loop
                            exitwhen (iteration < ARRAY_MIN)

                            local EventPriority priority = EventPriority.ALL[iteration]

                            local integer iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                            loop
                                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                                call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                                set iteration2 = iteration2 - 1
                            endloop

                            set iteration2 = whichOrder.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                            loop
                                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                                call whichOrder.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(orderParams)

                                set iteration2 = iteration2 - 1
                            endloop

                            set iteration = iteration - 1
                        endloop

                        call orderParams.Destroy()
                        call params.Destroy()
                    endmethod

                    method Start takes OrderInstance data returns nothing
                        call Unit(this).Order.Events.Lose.StartByGain(data)

                        call this.TriggerEvents(data)
                    endmethod

                    boolean locked
                    OrderInstance lockData

                    method Unlock takes nothing returns nothing
                        set this.locked = false

                        local OrderInstance data = this.lockData

                        if (data == NULL) then
                            return
                        endif

                        set this.lockData = NULL

                        call this.Start(data)
                    endmethod

                    method Lock takes nothing returns nothing
                        set this.locked = true
                    endmethod

                    trigMethod Trig
                        local real targetX = SPOT.Event.Native.GetOrderTargetX()
                        local real targetY = SPOT.Event.Native.GetOrderTargetY()
                        local thistype this = UNIT.Event.Native.GetTrigger()
                        local Order whichOrder = ORDER.Event.Native.GetTrigger()

                        local OrderInstance data = OrderInstance.Create()

                        call data.SetOrder(whichOrder)
                        call data.SetTargetX(targetX)
                        call data.SetTargetY(targetY)

                        call data.SetTargetType(Spell.TARGET_TYPE_POINT)

                        if this.locked then
                            if (this.lockData != NULL) then
                                call this.lockData.Destroy()
                            endif

                            set this.lockData = data

                            return
                        endif

                        call this.Start(data)
                    endmethod

                    method Reg takes nothing returns nothing
                        set this.lockData = NULL
                        set this.locked = false

                        call thistype.DUMMY_TRIGGER.RegisterEvent.Unit(this, EVENT_UNIT_ISSUED_POINT_ORDER)
                    endmethod

                    static method Init takes nothing returns nothing
                        set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                        set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                    endmethod
                endstruct

                //! runtextmacro Struct("Target")
                    static EventType DUMMY_EVENT_TYPE
                    static Trigger DUMMY_TRIGGER
                    static EventType TARGET_EVENT_TYPE

                    method TriggerEvents takes OrderInstance data returns nothing
                    	local Unit parent = this

                        local Order whichOrder = data.GetOrder()
                        local Item targetItem = data.GetTargetItem()
                        local Unit targetUnit = data.GetTargetUnit()

                        local EventResponse orderParams = EventResponse.Create(whichOrder.Id.Get())

                        call orderParams.Item.SetTarget(targetItem)
                        call orderParams.Order.SetTrigger(whichOrder)
                        call orderParams.Unit.SetTarget(targetUnit)
                        call orderParams.Unit.SetTrigger(parent)

						local EventResponse params = EventResponse.Create(parent.Id.Get())

                        call params.Item.SetTarget(targetItem)
                        call params.Order.SetTrigger(whichOrder)
                        call params.Unit.SetTarget(targetUnit)
                        call params.Unit.SetTrigger(parent)

						local EventResponse targetUnitParams = EventResponse.Create(targetUnit.Id.Get())

                        call targetUnitParams.Item.SetTarget(targetItem)
                        call targetUnitParams.Order.SetTrigger(whichOrder)
                        call targetUnitParams.Unit.SetTarget(parent)
                        call targetUnitParams.Unit.SetTrigger(targetUnit)

						local integer iteration = EventPriority.ALL_COUNT

                        loop
                            exitwhen (iteration < ARRAY_MIN)

                            local EventPriority priority = EventPriority.ALL[iteration]

                            local integer iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                            loop
                                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                                call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                                set iteration2 = iteration2 - 1
                            endloop

                            set iteration2 = whichOrder.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                            loop
                                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                                call whichOrder.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(orderParams)

                                set iteration2 = iteration2 - 1
                            endloop

                            set iteration2 = targetUnit.Event.Count(thistype.TARGET_EVENT_TYPE, priority)

                            loop
                                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                                call targetUnit.Event.Get(thistype.TARGET_EVENT_TYPE, priority, iteration2).Run(targetUnitParams)

                                set iteration2 = iteration2 - 1
                            endloop

                            set iteration = iteration - 1
                        endloop

                        call orderParams.Destroy()
                        call params.Destroy()
                        call targetUnitParams.Destroy()
                    endmethod

                    method Start takes OrderInstance data returns nothing
                        call Unit(this).Order.Events.Lose.StartByGain(data)

                        call this.TriggerEvents(data)
                    endmethod

                    boolean locked
                    OrderInstance lockData

                    method Unlock takes nothing returns nothing
                        set this.locked = false

                        local OrderInstance data = this.lockData

                        if (data == NULL) then
                            return
                        endif

                        set this.lockData = NULL

                        call this.Start(data)
                    endmethod

                    method Lock takes nothing returns nothing
                        set this.locked = true
                    endmethod

                    trigMethod Trig
                        local Item targetItem = ITEM.Event.Native.GetOrderTarget()
                        local Unit targetUnit = UNIT.Event.Native.GetOrderTarget()
                        local thistype this = UNIT.Event.Native.GetTrigger()
                        local Order whichOrder = ORDER.Event.Native.GetTrigger()

                        local OrderInstance data = OrderInstance.Create()

                        call data.SetOrder(whichOrder)
                        call data.SetTargetItem(targetItem)
                        call data.SetTargetUnit(targetUnit)

                        call data.SetTargetType(Spell.TARGET_TYPE_UNIT)

                        if this.locked then
                            if (this.lockData != NULL) then
                                call this.lockData.Destroy()
                            endif

                            set this.lockData = data

                            return
                        endif

                        call this.Start(data)
                    endmethod

                    method Reg takes nothing returns nothing
                        set this.lockData = NULL
                        set this.locked = false

                        call thistype.DUMMY_TRIGGER.RegisterEvent.Unit(this, EVENT_UNIT_ISSUED_TARGET_ORDER)
                    endmethod

                    static method Init takes nothing returns nothing
                        set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                        set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                        set thistype.TARGET_EVENT_TYPE = EventType.Create()
                    endmethod
                endstruct
            endscope

            //! runtextmacro Struct("Gain")
                //! runtextmacro LinkToStruct("Gain", "Immediate")
                //! runtextmacro LinkToStruct("Gain", "Point")
                //! runtextmacro LinkToStruct("Gain", "Target")

                method Event_Create takes nothing returns nothing
                    call this.Immediate.Reg()
                    call this.Point.Reg()
                    call this.Target.Reg()
                endmethod

                static method Init takes nothing returns nothing
                    call thistype(NULL).Immediate.Init()
                    call thistype(NULL).Point.Init()
                    call thistype(NULL).Target.Init()
                endmethod
            endstruct

            //! runtextmacro Struct("Idle")
                static Event DESTROY_EVENT
                static EventType ENDING_EVENT_TYPE
                static EventType INTERVAL_EVENT_TYPE
                //! runtextmacro GetKeyArray("KEY_ARRAY")
                static EventType START_EVENT_TYPE
                static constant real UPDATE_TIME = 0.75
                static Timer UPDATE_TIMER

                //! runtextmacro CreateList("ACTIVE_LIST")
                //! runtextmacro CreateList("EVENT_LIST")
                //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")
                //! runtextmacro CreateList("IDLING_LIST")

                method Ending_TriggerEvents takes nothing returns nothing                    
                    local Unit parent = this

                    local EventResponse params = EventResponse.Create(parent.Id.Get())

                    call params.Unit.SetTrigger(this)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = parent.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call parent.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run(params)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call params.Destroy()
                endmethod

                method Interval_TriggerEvents takes nothing returns nothing
                    local Unit parent = this

                    local EventResponse params = EventResponse.Create(parent.Id.Get())

                    call params.Unit.SetTrigger(this)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = parent.Event.Count(thistype.INTERVAL_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call parent.Event.Get(thistype.INTERVAL_EVENT_TYPE, priority, iteration2).Run(params)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call params.Destroy()
                endmethod

                method Start_TriggerEvents takes nothing returns nothing
                    local Unit parent = this

                    local EventResponse params = EventResponse.Create(parent.Id.Get())

                    call params.Unit.SetTrigger(this)

					local integer iteration = EventPriority.ALL_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local EventPriority priority = EventPriority.ALL[iteration]

                        local integer iteration2 = parent.Event.Count(thistype.START_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call parent.Event.Get(thistype.START_EVENT_TYPE, priority, iteration2).Run(params)

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call params.Destroy()
                endmethod

                timerMethod Update
                    call thistype.FOR_EACH_LIST_Set()

                    loop
                        local thistype this = thistype.FOR_EACH_LIST_FetchFirst()
                        exitwhen (this == NULL)

                        if thistype.IDLING_LIST_Contains(this) then
                            if (Unit(this).Order.GetNative() == NULL) then
                                call this.Interval_TriggerEvents()
                            else
                                call thistype.IDLING_LIST_Remove(this)

                                call this.Ending_TriggerEvents()
                            endif
                        else
                            if (Unit(this).Order.GetNative() == NULL) then
                                call thistype.IDLING_LIST_Add(this)

                                call this.Start_TriggerEvents()
                            endif
                        endif
                    endloop
                endmethod

                method Reg takes Event whichEvent returns nothing
                    if Unit(this).Data.Integer.Table.Add(KEY_ARRAY, whichEvent) then
                        call Unit(this).Event.Add(DESTROY_EVENT)

                        call thistype.EVENT_LIST_Add(this)
                        if not Unit(this).Classes.Contains(UnitClass.DEAD) then
                            if thistype.ACTIVE_LIST_Add(this) then
                                call UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                            endif
                        endif
                    endif
                    call Unit(this).Event.Add(whichEvent)
                endmethod

                method Unreg takes Event whichEvent returns nothing
                    if Unit(this).Data.Integer.Table.Remove(KEY_ARRAY, whichEvent) then
                        call thistype.EVENT_LIST_Remove(this)
                        call Unit(this).Event.Remove(DESTROY_EVENT)

                        if thistype.ACTIVE_LIST_Remove(this) then
                            call thistype.UPDATE_TIMER.Pause()
                        endif
                    endif
                    call Unit(this).Event.Remove(whichEvent)
                endmethod

                eventMethod Event_Death
                    local thistype this = params.Unit.GetTrigger()

                    if not thistype.EVENT_LIST_Contains(this) then
                        return
                    endif

                    call thistype.ACTIVE_LIST_Remove(this)
                    if thistype.IDLING_LIST_Contains(this) then
                        call thistype.IDLING_LIST_Remove(this)

                        call this.Ending_TriggerEvents()
                    endif
                endmethod

                eventMethod Event_Revive
                    local thistype this = params.Unit.GetTrigger()

                    if not thistype.EVENT_LIST_Contains(this) then
                        return
                    endif

                    call thistype.ACTIVE_LIST_Add(this)
                    call thistype.IDLING_LIST_Add(this)

                    call this.Start_TriggerEvents()
                endmethod

                eventMethod Event_Destroy
                    local Unit parent = params.Unit.GetTrigger()

                    local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                    loop
                        call thistype(parent).Unreg(parent.Data.Integer.Table.Get(KEY_ARRAY, iteration))

                        set iteration = iteration - 1
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                    endloop
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                    set thistype.ENDING_EVENT_TYPE = EventType.Create()
                    set thistype.INTERVAL_EVENT_TYPE = EventType.Create()
                    set thistype.START_EVENT_TYPE = EventType.Create()
                    set thistype.UPDATE_TIMER = Timer.Create()
                    call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death).AddToStatics()
                    call Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive).AddToStatics()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Events")
            //! runtextmacro LinkToStruct("Events", "Gain")
            //! runtextmacro LinkToStruct("Events", "Idle")
            //! runtextmacro LinkToStruct("Events", "Lose")

            method Unlock takes nothing returns nothing
                call this.Gain.Immediate.Unlock()
                call this.Gain.Point.Unlock()
                call this.Gain.Target.Unlock()
            endmethod

            method Lock takes nothing returns nothing
                call this.Gain.Immediate.Lock()
                call this.Gain.Point.Lock()
                call this.Gain.Target.Lock()
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Gain.Event_Create()
                call this.Lose.Reg()
            endmethod

            static method Init takes nothing returns nothing
                call thistype(NULL).Gain.Init()
                call thistype(NULL).Idle.Init()
                call thistype(NULL).Lose.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Order")
        OrderInstance data

        //! runtextmacro LinkToStruct("Order", "Events")

        method Get takes nothing returns Order
            return this.data.GetOrder()
        endmethod

        method GetData takes nothing returns OrderInstance
            return this.data
        endmethod

        method GetNative takes nothing returns Order
            return Order.GetFromSelf(GetUnitCurrentOrder(Unit(this).self))
        endmethod

        method AddImmediate takes Order whichOrder returns nothing
        endmethod

        method Immediate takes Order whichOrder returns boolean
            if not IssueImmediateOrderById(Unit(this).self, whichOrder.self) then
                return false
            endif

            return true
        endmethod

        method ImmediateNoTrig takes Order whichOrder returns boolean
            call thistype(NULL).Events.Gain.Immediate.DUMMY_TRIGGER.Disable()

            local boolean result = this.Immediate(whichOrder)

            call thistype(NULL).Events.Gain.Immediate.DUMMY_TRIGGER.Enable()

            return result
        endmethod

        method ImmediateBySpell takes Spell whichSpell returns boolean
            return this.Immediate(whichSpell.GetOrder())
        endmethod

        method PointTarget takes Order whichOrder, real x, real y returns boolean
            if not IssuePointOrderById(Unit(this).self, whichOrder.self, x, y) then
                return false
            endif

            return true
        endmethod

        method PointTargetNoTrig takes Order whichOrder, real x, real y returns boolean
            call thistype(NULL).Events.Gain.Point.DUMMY_TRIGGER.Disable()

            local boolean result = this.PointTarget(whichOrder, x, y)

            call thistype(NULL).Events.Gain.Point.DUMMY_TRIGGER.Enable()

            return result
        endmethod

        method PointTargetBySpell takes Spell whichSpell, real x, real y returns boolean
            return this.PointTarget(whichSpell.GetOrder(), x, y)
        endmethod

        method UnitTarget takes Order whichOrder, Unit target returns boolean
            if not IssueTargetOrderById(Unit(this).self, whichOrder.self, Unit(target).self) then
                return false
            endif

            return true
        endmethod

        method UnitTargetNoTrig takes Order whichOrder, Unit target returns boolean
            call thistype(NULL).Events.Gain.Target.DUMMY_TRIGGER.Disable()

            local boolean result = this.UnitTarget(whichOrder, target)

            call thistype(NULL).Events.Gain.Target.DUMMY_TRIGGER.Enable()

            return result
        endmethod

        method UnitTargetBySpell takes Spell whichSpell, Unit target returns boolean
            return this.UnitTarget(whichSpell.GetOrder(), target)
        endmethod

        method ItemTarget takes Order whichOrder, Item target returns boolean
            if not IssueTargetOrderById(Unit(this).self, whichOrder.self, Item(target).self) then
                return false
            endif

            return true
        endmethod

        method ItemTargetNoTrig takes Order whichOrder, Item target returns boolean
            call thistype(NULL).Events.Gain.Target.DUMMY_TRIGGER.Disable()

            local boolean result = this.ItemTarget(whichOrder, target)

            call thistype(NULL).Events.Gain.Target.DUMMY_TRIGGER.Enable()

            return result
        endmethod

        method Do takes OrderInstance data returns nothing
            local integer targetType = data.GetTargetType()
            local Item targetItem = data.GetTargetItem()
            local Unit targetUnit = data.GetTargetUnit()
            local Order whichOrder = data.GetOrder()
            local real x = data.GetTargetX()
            local real y = data.GetTargetY()

            if (targetType == Spell.TARGET_TYPE_IMMEDIATE) then
                call this.Immediate(whichOrder)
            elseif (targetType == Spell.TARGET_TYPE_POINT) then
                call this.PointTarget(whichOrder, x, y)
            else
                if (targetUnit != NULL) then
                    call this.UnitTarget(whichOrder, targetUnit)
                elseif (targetItem != NULL) then
                    call this.ItemTarget(whichOrder, targetItem)
                else
                    call this.PointTarget(whichOrder, x, y)
                endif
            endif
        endmethod

        method DoNoTrig takes OrderInstance data returns nothing
            local integer targetType = data.GetTargetType()
            local Unit targetUnit = data.GetTargetUnit()
            local Order whichOrder = data.GetOrder()
            local real x = data.GetTargetX()
            local real y = data.GetTargetY()

            if (targetType == Spell.TARGET_TYPE_IMMEDIATE) then
                call this.ImmediateNoTrig(whichOrder)
            elseif (targetType == Spell.TARGET_TYPE_POINT) then
                call this.PointTargetNoTrig(whichOrder, x, y)
            else
                if (targetUnit == NULL) then
                    call this.PointTargetNoTrig(whichOrder, x, y)
                else
                    call this.UnitTargetNoTrig(whichOrder, targetUnit)
                endif
            endif
        endmethod

		method Restore
            local OrderInstance data = this.GetData()

            if (data == NULL) then
                return
            endif

			call this.DoNoTrig(data)
		endmethod

		method Deaggravate
			/*call parent.Abilities.AddBySelf(thistype.WINDWALK_SPELL_ID)

			call InfoEx(B2S( parent.Order.ImmediateNoTrig(Order.WINDWALK) ) + " " + GetObjectName(thistype.WINDWALK_SPELL_ID) + " "+GetObjectName(thistype.WINDWALK_BUFF_ID))

			call parent.Abilities.RemoveBySelf(thistype.WINDWALK_SPELL_ID)
			call parent.Buffs.RemoveBySelf(thistype.WINDWALK_BUFF_ID)

			call parent.Order.Restore()*/

            local OrderInstance data = this.GetData()

            if (data == NULL) then
                return
            endif

			local Order whichOrder = data.GetOrder()

			if (whichOrder == Order.ATTACK) then
				local Unit targetUnit = data.GetTargetUnit()

				if (targetUnit != NULL) then
					call this.UnitTarget(Order.MOVE, targetUnit)

					return
				endif

				local Unit targetItem = data.GetTargetItem()

				if (targetItem != NULL) then
					call this.ItemTarget(Order.MOVE, targetItem)

					return
				endif

				return
			endif

			local Unit target = data.GetTargetUnit()

			if (whichOrder == Order.SMART) then
				set targetUnit = data.GetTargetUnit()

				if (targetUnit != NULL) then
					if targetUnit.IsEnemyOf(Unit(this).Owner.Get()) then
						call this.UnitTarget(Order.MOVE, targetUnit)
					endif
				endif
			endif
		endmethod

        method Update takes nothing returns nothing
            local OrderInstance data = this.GetData()

            if (data == NULL) then
                return
            endif

            call this.Do(data)
        endmethod

        method Spell takes Spell whichSpell, Unit target, real x, real y returns boolean
            local integer targetType = whichSpell.GetTargetType()

            if (targetType == Spell.TARGET_TYPE_IMMEDIATE) then
                return this.ImmediateBySpell(whichSpell)
            elseif (targetType == Spell.TARGET_TYPE_POINT) then
                return this.PointTargetBySpell(whichSpell, x, y)
            else
                if (target == NULL) then
                    return this.PointTargetBySpell(whichSpell, x, y)
                endif
            endif

            return this.UnitTargetBySpell(whichSpell, target)
        endmethod

        method ResetData takes nothing returns nothing
            local OrderInstance data = this.GetData()

            if (data == NULL) then
                return
            endif

            set this.data = NULL

            call data.Destroy()
        endmethod

        method SetData takes OrderInstance val returns nothing
            set this.data = val
        endmethod

        static Event DESTROY_EVENT

        eventMethod Event_Destroy
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            call parent.Event.Remove(DESTROY_EVENT)

            call this.ResetData()
        endmethod

        method Event_Create takes nothing returns nothing
            set this.data = NULL

            call Unit(this).Event.Add(DESTROY_EVENT)

            call this.Events.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)

            call thistype(NULL).Events.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Banish")
        static Event REVIVE_EVENT

        //! runtextmacro CreateSimpleFlagState_NotStart()

        eventMethod Event_Revive
            call DummyUnit.WORLD_CASTER.Order.UnitTargetInstantly(Order.BANISH, params.Unit.GetTrigger())
        endmethod

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)

            call parent.Event.Remove(REVIVE_EVENT)

            call parent.Buffs.RemoveBySelf(thistype.BAN_BUFF_ID)
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)

            call parent.Event.Add(REVIVE_EVENT)

            call DummyUnit.WORLD_CASTER.Order.UnitTargetInstantly(Order.BANISH, parent)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))

            call thistype.DUMMY_BUFF.Variants.Add(thistype.NORMAL_BUFF)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive)

            call DummyUnit.WORLD_CASTER.Abilities.AddBySelf(thistype.BAN_SPELL_ID)
        endmethod
    endstruct

    //! runtextmacro Struct("Madness")
        //! runtextmacro CreateSimpleFlagState_NotStart()

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)

            call parent.Owner.Update()
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)

            call parent.Owner.SetNative(User.NEUTRAL_AGGRESSIVE, false)

			call parent.Stop()
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))

            call thistype.DUMMY_BUFF.Variants.Add(thistype.NORMAL_BUFF)
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Struct("Eclipse")
        //! runtextmacro CreateSimpleFlagState_NotStart()

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Struct("Whirl")
        static Event REVIVE_EVENT

        //! runtextmacro CreateSimpleFlagState_NotStart()

        eventMethod Event_Revive
            call DummyUnit.WORLD_CASTER.Order.UnitTargetInstantly(Order.CYCLONE, params.Unit.GetTrigger())
        endmethod

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)

            call parent.Event.Remove(REVIVE_EVENT)

            call parent.Buffs.RemoveBySelf(thistype.CYCLONE_BUFF_EXTRA_ID)
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)

            call parent.Event.Add(REVIVE_EVENT)

            //call DummyUnit.WORLD_CASTER.Order.UnitTargetInstantly(Order.CYCLONE, parent)
            
            local real x = parent.Position.X.Get()
            local real y = parent.Position.Y.Get()

            call UnitAddType(parent.self, UNIT_TYPE_SAPPER)
            call DummyUnit.WORLD_CASTER.Order.UnitTargetInstantly(Order.IMPALE, parent)
            call UnitRemoveType(parent.self, UNIT_TYPE_SAPPER)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))

            call thistype.DUMMY_BUFF.Variants.Add(thistype.NORMAL_BUFF)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive)

            call DummyUnit.WORLD_CASTER.Abilities.AddBySelf(thistype.CYCLONE_SPELL_ID)
            call DummyUnit.WORLD_CASTER.Abilities.AddBySelf(thistype.IMPALE_SPELL_ID)
        endmethod
    endstruct

    //! runtextmacro Struct("Facing")
        static real STANDARD = Math.SOUTH_ANGLE

        method Get takes nothing returns real
            return (GetUnitFacing(Unit(this).self) * Math.DEG_TO_RAD)
        endmethod

        method Set takes real value returns nothing
            call SetUnitFacing(Unit(this).self, value * Math.RAD_TO_DEG)
        endmethod

        method SetToUnit takes Unit target returns nothing
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()
            local real thisX = Unit(this).Position.X.Get()
            local real thisY = Unit(this).Position.Y.Get()

            if ((targetX != thisX) or (targetY != thisY)) then
                call this.Set(Math.AtanByDeltas(targetY - thisY, targetX - thisX))
            endif
        endmethod
    endstruct

    //! runtextmacro Struct("Bleeding")
        static constant real INTERVAL = 1.

        static constant real REL_DMG_PER_INTERVAL = thistype.REL_DMG_PER_SECOND * thistype.INTERVAL
        static constant real REL_DMG_HERO_PER_INTERVAL = thistype.REL_DMG_HERO_PER_SECOND * thistype.INTERVAL

        Unit caster
        Timer intervalTimer

        //! runtextmacro CreateSimpleFlagState_NotStart()

        timerMethod Interval
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            call target.Effects.Create(target.Blood.Get(), AttachPoint.CHEST, EffectLevel.NORMAL).Destroy()

            if target.Classes.Contains(UnitClass.HERO) then
                call this.caster.DamageUnitBySpell(target, thistype.REL_DMG_HERO_PER_INTERVAL * target.MaxLife.Get(), false, false)
            else
                call this.caster.DamageUnitBySpell(target, thistype.REL_DMG_PER_INTERVAL * target.MaxLife.Get(), false, false)
            endif
        endmethod

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            call this.Set(false)

            call this.intervalTimer.Destroy()

            call parent.Invisibility.Reveal.Subtract()
        endmethod

        eventMethod Event_BuffGain
            local Unit caster = params.Buff.GetData()
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            call this.Set(true)

			local Timer intervalTimer = Timer.Create()

            set this.caster = caster
            set this.intervalTimer = intervalTimer
            call intervalTimer.SetData(this)

            call parent.Invisibility.Reveal.Add()

            call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

			//call UNIT.Invisibility.Reveal.DUMMY_BUFF.Variants.Add(thistype.DUMMY_BUFF)

            call thistype.DUMMY_BUFF.Variants.Add(thistype.NORMAL_BUFF)
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Struct("Ignited")
        static constant real INTERVAL = 1.

        static constant real REL_DMG_PER_INTERVAL = thistype.REL_DMG_PER_SECOND * thistype.INTERVAL
        static constant real REL_DMG_HERO_PER_INTERVAL = thistype.REL_DMG_HERO_PER_SECOND * thistype.INTERVAL

        Unit caster
        Timer intervalTimer

        //! runtextmacro CreateSimpleFlagState_NotStart()

        timerMethod Interval
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            if target.Classes.Contains(UnitClass.HERO) then
                call this.caster.DamageUnitBySpell(target, thistype.REL_DMG_HERO_PER_INTERVAL * target.MaxLife.Get(), true, false)
            else
                call this.caster.DamageUnitBySpell(target, thistype.REL_DMG_PER_INTERVAL * target.MaxLife.Get(), true, false)
            endif
        endmethod

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            call this.Set(false)

            call this.intervalTimer.Destroy()

            call parent.Invisibility.Reveal.Subtract()
        endmethod

        eventMethod Event_BuffGain
            local Unit caster = params.Buff.GetData()
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            call this.Set(true)

			local Timer intervalTimer = Timer.Create()

            set this.caster = caster
            set this.intervalTimer = intervalTimer
            call intervalTimer.SetData(this)

            call parent.Invisibility.Reveal.Add()

            call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call thistype.DUMMY_BUFF.Variants.Add(thistype.NORMAL_BUFF)
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Struct("Knockup")
        static constant real DURATION = 1.

        method Start takes nothing returns nothing
            local real dur = thistype.DURATION
            local real height = 250. * 32. / (16. + Unit(this).CollisionSize.Get(true))

            local real acc = -8 * height / dur / dur//-100

            local real speed = -acc / 2 * dur//height / dur - acc / 2 * dur

            call Unit(this).Position.Timed.Accelerated.AddIn(0., 0., speed, 0., 0., acc, dur)
        endmethod

        initMethod Buff_Init of Header_Buffs
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Struct("Pathing")
        //! runtextmacro CreateSimpleFlagState_NotStart()

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)

            call SetUnitPathing(parent.self, true)
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)

            call SetUnitPathing(parent.self, false)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Update takes nothing returns nothing
            call SetUnitPathing(Unit(this).self, this.Is())
        endmethod

        eventMethod Event_TypeChange
            call thistype(params.Unit.GetTrigger()).Update()
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(true)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Struct("Poisoned")
        //! runtextmacro CreateSimpleFlagState_NotStart()

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call thistype.DUMMY_BUFF.Variants.Add(thistype.NORMAL_BUFF)
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Folder("Revival")
        //! runtextmacro Struct("Able")
            //! runtextmacro CreateSimpleFlagCountState("Boolean.ToInt(Unit(this).Type.Get().Revivalable.Is())")

            eventMethod Event_TypeChange
                local UnitType sourceType = params.UnitType.GetSource()
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.AddValue(Boolean.ToInt(targetType.Revivalable.Is()) - Boolean.ToInt(sourceType.Revivalable.Is()))
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Events")
            static EventType DUMMY_EVENT_TYPE
            static Trigger DUMMY_TRIGGER

            method TriggerEvents takes nothing returns nothing
                local Unit parent = this

                local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

                call params.Unit.SetTrigger(this)

				local EventResponse unitParams = EventResponse.Create(parent.Id.Get())

                call unitParams.Unit.SetTrigger(this)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(unitParams)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
                call unitParams.Destroy()
            endmethod

            method Start takes nothing returns nothing
                call this.TriggerEvents()
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DUMMY_EVENT_TYPE = EventType.Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Revival")
        //! runtextmacro LinkToStruct("Revival", "Able")
        //! runtextmacro LinkToStruct("Revival", "Events")

        //! runtextmacro CreateSimpleFlagState_NotStart()

        method Do takes nothing returns boolean
            if not this.Able.Is() then
                return false
            endif
            if not Unit(this).Classes.IsNative(UNIT_TYPE_DEAD) then
                return false
            endif

            local boolean isStructure = Unit(this).Classes.IsNative(UNIT_TYPE_STRUCTURE)
            local User thisOwner = Unit(this).Owner.Get()

            call DummyUnit.WORLD_CASTER.Owner.Set(thisOwner)
            call DummyUnit.WORLD_CASTER.Position.X.Set(Unit(this).Position.X.Get())
            call DummyUnit.WORLD_CASTER.Position.Y.Set(Unit(this).Position.Y.Get())
            call Unit(this).Classes.AddNative(UNIT_TYPE_TAUREN)
            call UnitShareVision(Unit(this).self, thisOwner.self, true)

            local boolean result = DummyUnit.WORLD_CASTER.Order.Immediate(Order.ANCESTRAL_SPIRIT)

            call DummyUnit.WORLD_CASTER.Owner.Set(User.DUMMY)
            call Unit(this).Classes.RemoveNative(UNIT_TYPE_TAUREN)

            if result then
                if isStructure then
                    call ShowUnit(Unit(this).self, false)
                endif
                call this.Set(false)
                call Unit(this).Classes.Remove(UnitClass.DEAD)

                if isStructure then
                    call ShowUnit(Unit(this).self, true)
                endif

                call Unit(this).Life.Set(Unit(this).MaxLife.Get())

                call this.Events.Start()

                return true
            endif

            return false
        endmethod

        method Event_Create takes nothing returns nothing
            set this.flag = false

            call this.Able.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call DummyUnit.WORLD_CASTER.Abilities.AddBySelf(thistype.DUMMY_SPELL_ID)

            call thistype(NULL).Able.Init()
            call thistype(NULL).Events.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Silence")
        static Event REVIVE_EVENT

        //! runtextmacro CreateSimpleFlagState_NotStart()

        eventMethod Event_Revive
            call DummyUnit.WORLD_CASTER.Order.UnitTargetInstantly(Order.SOULBURN, params.Unit.GetTrigger())
        endmethod

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)

            call parent.Event.Remove(REVIVE_EVENT)

            call parent.Buffs.RemoveBySelf(thistype.SIL_BUFF_ID)
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)

            call parent.Event.Add(REVIVE_EVENT)

            call DummyUnit.WORLD_CASTER.Order.UnitTargetInstantly(Order.SOULBURN, parent)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))

            call thistype.DUMMY_BUFF.Variants.Add(thistype.NORMAL_BUFF)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive)

            call DummyUnit.WORLD_CASTER.Abilities.AddBySelf(thistype.SIL_SPELL_ID)
        endmethod
    endstruct

    //! runtextmacro Struct("Sleep")
        static Event DAMAGE_EVENT
        static EventType ENDING_EVENT_TYPE

        //! runtextmacro CreateSimpleFlagState_NotStart()

        eventMethod Event_Damage
            call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        method Ending_TriggerEvents takes nothing returns nothing
            local Unit parent = this

            local EventResponse params = EventResponse.Create(parent.Id.Get())

            call params.Unit.SetTrigger(this)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = parent.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call parent.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
        endmethod

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)

            call parent.Event.Remove(DAMAGE_EVENT)

            call parent.Stun.Subtract()

            call parent.Buffs.RemoveBySelf(thistype.PAUSE_BUFF_ID)
            call parent.Buffs.RemoveBySelf(thistype.SLEEP_BUFF_ID)

            call thistype(parent).Ending_TriggerEvents()
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            call thistype(parent).Set(true)

            call parent.Event.Add(DAMAGE_EVENT)

            call parent.Stun.Add()
            call DummyUnit.WORLD_CASTER.Order.UnitTargetInstantly(Order.SLEEP, parent)

            call parent.Buffs.RemoveBySelf(thistype.PAUSE_BUFF_ID)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AbortTimed takes nothing returns nothing
            call Unit(this).Buffs.Timed.EndingByParent(thistype.DUMMY_BUFF)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Do(thistype.DUMMY_BUFF, NULL, duration)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))

            call thistype.DUMMY_BUFF.Variants.Add(thistype.NORMAL_BUFF)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.TARGET_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Damage)
            set thistype.ENDING_EVENT_TYPE = EventType.Create()

            call DummyUnit.WORLD_CASTER.Abilities.AddBySelf(thistype.SLEEP_SPELL_ID)
        endmethod
    endstruct

    //! runtextmacro Folder("Stun")
        //! runtextmacro Struct("Cancel")
            static Event DEATH_EVENT
            //! runtextmacro GetKey("KEY")

            Timer delayTimer
            Unit parent

            method Ending takes Timer delayTimer, Unit parent returns nothing
                call this.deallocate()
                call delayTimer.Destroy()
                call parent.Data.Integer.Remove(KEY)
                call parent.Event.Remove(DEATH_EVENT)
                call parent.Buffs.RemoveBySelf(UNIT.Stun.STUN_BUFF_ID)
            endmethod

            eventMethod Event_Death
                local Unit parent = params.Unit.GetTrigger()

                local thistype this = parent.Data.Integer.Get(KEY)

                call this.Ending(this.delayTimer, parent)
            endmethod

            timerMethod EndingByTimer
                local Timer delayTimer = Timer.GetExpired()

                local thistype this = delayTimer.GetData()

                call this.Ending(delayTimer, this.parent)
            endmethod

            eventMethod Event_Order
                local Unit parent = params.Unit.GetTrigger()
                local thistype this = parent.Data.Integer.Get(KEY)

                if not parent.Stun.Is() then
                    if (parent.Data.Integer.Get(KEY) == NULL) then
                        set this = thistype.allocate()

                        local Timer delayTimer = Timer.Create()

                        set this.delayTimer = delayTimer
                        set this.parent = parent
                        call delayTimer.SetData(this)
                        call parent.Data.Integer.Set(KEY, this)
                        call parent.Event.Add(DEATH_EVENT)

                        call delayTimer.Start(0., false, function thistype.EndingByTimer)
                    endif
                endif
            endmethod

            static method Init takes nothing returns nothing
                set DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Order)
                call Order.STUNNED.Event.Add(Event.Create(UNIT.Order.Events.Gain.Target.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Order))
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Stun")
        static UnitState STATE

        //! runtextmacro LinkToStruct("Stun", "Cancel")

        //! runtextmacro CreateSimpleFlagState_NotStart()

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(false)

            call parent.Buffs.RemoveBySelf(thistype.STUN_BUFF_ID)
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Set(true)

            call DummyUnit.WORLD_CASTER.Order.UnitTargetInstantly(Order.THUNDER_BOLT, parent)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        method AddTimedBy takes Buff whichBuff, real duration returns nothing
            call Unit(this).Buffs.Timed.Start(whichBuff, 1, duration)
        endmethod

        method Change takes boolean val returns nothing
            if val then
                call this.Add()
            else
                call this.Subtract()
            endif
        endmethod

        eventMethod Event_State
            call thistype(params.Unit.GetTrigger()).Change(params.Bool.GetVal())
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))

            call thistype.DUMMY_BUFF.Variants.Add(thistype.NORMAL_BUFF)
        endmethod

        static method Init takes nothing returns nothing
            call DummyUnit.WORLD_CASTER.Abilities.AddBySelf(thistype.STUN_SPELL_ID)

            set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)

            call thistype(NULL).Cancel.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Animation")
        //! runtextmacro Struct("Loop")
            static Event DEATH_EVENT
            //! runtextmacro GetKey("KEY")
            //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "32")
            static Timer UPDATE_TIMER

            Unit parent
            string whichAnimation

            timerMethod Update
                local integer iteration = thistype.ALL_COUNT

                loop
                    local thistype this = thistype.ALL[iteration]

                    call this.parent.Animation.Queue(this.whichAnimation)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endmethod

            method Ending takes Unit parent returns nothing
                call this.deallocate()
                call parent.Data.Integer.Remove(KEY)
                call parent.Event.Remove(DEATH_EVENT)
                if this.RemoveFromList() then
                    call thistype.UPDATE_TIMER.Pause()
                endif

                call this.parent.Animation.Reset()
            endmethod

            method Abort takes nothing returns nothing
                local Unit parent = this

                set this = parent.Data.Integer.Get(KEY)

                if (this != NULL) then
                    call this.Ending(parent)
                endif
            endmethod

            eventMethod Event_Death
                local Unit parent = params.Unit.GetTrigger()

                local thistype this = parent.Data.Integer.Get(KEY)

                call this.Ending(parent)
            endmethod

            method Start takes string whichAnimation returns nothing
                local Unit parent = this

                call thistype(parent).Abort()

                set this = thistype.allocate()

                set this.parent = parent
                set this.whichAnimation = whichAnimation
                call parent.Data.Integer.Set(KEY, this)
                call parent.Event.Add(DEATH_EVENT)

                if this.AddToList() then
                    call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                endif

                call parent.Animation.Set(whichAnimation)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
                set thistype.UPDATE_TIMER = Timer.Create()
            endmethod
        endstruct

        //! runtextmacro Struct("Speed")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value
                call SetUnitTimeScale(Unit(this).self, value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd("real", "1.")
        endstruct
    endscope

    //! runtextmacro Struct("Animation")
        static constant string ALTERNATE = "alternate"
        static constant string ATTACK = "attack"
        static constant string BIRTH = "birth"
        static constant string MORPH = "morph"
        static constant string SPELL = "spell"
        static constant string SPELL_SLAM = "spell slam"
        static constant string STAND = "stand"
        static constant string SWIM = "swim"
        static constant string WORK = "work"

        //! runtextmacro LinkToStruct("Animation", "Loop")
        //! runtextmacro LinkToStruct("Animation", "Speed")

        method Remove takes string whichAnimation returns nothing
            call AddUnitAnimationProperties(Unit(this).self, whichAnimation, false)

            call Unit(this).Color.Update()
        endmethod

        method Queue takes string whichAnimation returns nothing
            call QueueUnitAnimation(Unit(this).self, whichAnimation)
        endmethod

        method Set takes string whichAnimation returns nothing
            call SetUnitAnimation(Unit(this).self, whichAnimation)
        endmethod

        method Reset takes nothing returns nothing
            call this.Loop.Abort()

            call this.Set(Animation.STAND)
            call this.Queue(Animation.STAND)
        endmethod

        method Add takes string whichAnimation returns nothing
            call AddUnitAnimationProperties(Unit(this).self, whichAnimation, true)

            call Unit(this).Color.Update()
        endmethod

        method SetByIndex takes integer whichAnimation returns nothing
            call SetUnitAnimationByIndex(Unit(this).self, whichAnimation)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Speed.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Loop.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("SkillPoints")
        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method AddNative takes integer value returns nothing
            if (value == 0) then
                return
            endif

            call UnitModifySkillPoints(Unit(this).self, value)
        endmethod

        method Set takes integer value returns nothing
            local integer oldValue = this.Get()

            set this.value = value
            call UnitModifySkillPoints(Unit(this).self, value - oldValue)
        endmethod

        method UpdateByLearn takes nothing returns nothing
            set this.value = GetHeroSkillPoints(Unit(this).self) - 1
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("integer")

        method Event_Create takes nothing returns nothing
            set this.value = 0

            call this.AddNative(-GetHeroSkillPoints(Unit(this).self))
        endmethod
    endstruct

    //! runtextmacro Folder("SpellPower")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).SpellPower.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_TypeChange
                local UnitType sourceType = params.UnitType.GetSource()
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.Add(targetType.SpellPower.Get() - sourceType.SpellPower.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = Unit(this).Type.Get().SpellPower.Get()
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            static UnitState STATE

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).SpellPower.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            static UnitState STATE

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).SpellPower.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("SpellPower")
        static constant real SCALE_FACTOR = 1. / 10.

        //! runtextmacro LinkToStruct("SpellPower", "Base")
        //! runtextmacro LinkToStruct("SpellPower", "Bonus")
        //! runtextmacro LinkToStruct("SpellPower", "Relative")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        real bonusVal

        method GetBonus takes nothing returns real
            return this.bonusVal
        endmethod

        static method GetDamageFactor takes real value returns real
            if (value < 0.) then
                return (2. - Math.Power((1. - Attack.ARMOR_REDUCTION_FACTOR), -value * thistype.SCALE_FACTOR))
            endif

            return (1. / (1. + Attack.ARMOR_REDUCTION_FACTOR * value * thistype.SCALE_FACTOR))
        endmethod

        method Set takes real value returns nothing
            set this.bonusVal = value - this.Base.Get()
            set this.value = value
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.bonusVal = 0.
            set this.value = 0.

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Base.Init()
            call thistype(NULL).Bonus.Init()
            call thistype(NULL).Relative.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("SpellVamp")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).SpellVamp.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_TypeChange
                local UnitType sourceType = params.UnitType.GetSource()
                local UnitType targetType = params.UnitType.GetTrigger()
                local thistype this = params.Unit.GetTrigger()

                call this.Add(targetType.SpellVamp.Get() - sourceType.SpellVamp.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = Unit(this).Type.Get().SpellVamp.Get()
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            static UnitState STATE

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).SpellVamp.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            static UnitState STATE

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).SpellVamp.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("SpellVamp")
        //! runtextmacro LinkToStruct("SpellVamp", "Base")
        //! runtextmacro LinkToStruct("SpellVamp", "Bonus")
        //! runtextmacro LinkToStruct("SpellVamp", "Relative")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        real bonusAllVal

        method GetBonusAll takes nothing returns real
            return this.bonusAllVal
        endmethod

        //! runtextmacro GetKeyArray("TEXT_TAG_KEY_ARRAY")

        method Do takes real amount, boolean crit returns nothing
            set amount = amount * this.Get()

            if (amount <= 0.) then
                return
            endif

//            call Unit(this).CreateSpellTextTag(target, magical, amount, crit)

            call Unit(this).ReplaceRisingTextTagIfMinorValue(String.Color.Gradient("~" + Real.ToIntString(amount) + String.If(crit, Char.EXCLAMATION_MARK) + "~", Unit(this).Owner.Get().GetColorString(), String.Color.LIGHT_SEA_GREEN), Math.Linear(amount, Unit(this).MaxLife.Get() / 2., 0.016, 0.022), 160., 0., 1., thistype.TEXT_TAG_KEY_ARRAY + this, amount / 2)

            call Unit(this).Life.Add(amount)
        endmethod

        method Set takes real value returns nothing
            set this.bonusAllVal = value - this.Base.Get()
            set this.value = value
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.bonusAllVal = 0.
            set this.value = 0.

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Base.Init()
            call thistype(NULL).Bonus.Init()
            call thistype(NULL).Relative.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("MaxRage")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxRage.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxRage.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxRage.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("MaxRage")
        //! runtextmacro LinkToStruct("MaxRage", "Base")
        //! runtextmacro LinkToStruct("MaxRage", "Bonus")
        //! runtextmacro LinkToStruct("MaxRage", "Relative")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Set takes real value returns nothing
            local real oldValue = this.Get()

            set this.value = value

            if (oldValue == 0.) then
                return
            endif

            call Unit(this).Rage.Set(Unit(this).Rage.Get() / oldValue * value)
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0.

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()

            call this.Update()
        endmethod
    endstruct

    //! runtextmacro Struct("Rage")
    	static Event ATTACK_EVENT
        static Event DESTROY_EVENT

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Set takes real value returns nothing
            local real max = Unit(this).MaxRage.Get()
            local real oldValue = this.Get()

            set value = Math.Limit(value, 0., Unit(this).MaxRage.Get())

            set this.value = value

            call Unit(this).CriticalChance.Bonus.Add(value - oldValue)
            call Unit(this).EvasionChance.Bonus.Add(value - oldValue)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

        eventMethod Event_Attack
        	local Unit parent = params.Unit.GetTrigger()

            call thistype(parent).Add(1)
        endmethod

        eventMethod Event_Destroy
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

			call parent.Event.Remove(ATTACK_EVENT)
            call parent.Event.Remove(DESTROY_EVENT)
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = Unit(this).MaxRage.Get()
            call Unit(this).Event.Add(ATTACK_EVENT)
            call Unit(this).Event.Add(DESTROY_EVENT)
        endmethod

        static method Init takes nothing returns nothing
        	set thistype.ATTACK_EVENT = Event.Create(UNIT.Attack.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Attack)
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
        endmethod
    endstruct

    //! runtextmacro Folder("RageRegeneration")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).RageRegeneration.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = -1.
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            static UnitState STATE

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).RageRegeneration.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).RageRegeneration.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("RageRegeneration")
        static Event DESTROY_EVENT
        static constant real UPDATE_TIME = 0.25
        static Timer UPDATE_TIMER

        real valuePerUpdate

        //! runtextmacro LinkToStruct("RageRegeneration", "Base")
        //! runtextmacro LinkToStruct("RageRegeneration", "Bonus")
        //! runtextmacro LinkToStruct("RageRegeneration", "Relative")

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        eventMethod Event_Destroy
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            if thistype.ACTIVE_LIST_Remove(this) then
                call thistype.UPDATE_TIMER.Pause()
            endif
            call parent.Event.Remove(DESTROY_EVENT)
        endmethod

        timerMethod UpdateByTimer
            call thistype.FOR_EACH_LIST_Set()

            loop
                local thistype this = thistype.FOR_EACH_LIST_FetchFirst()

                exitwhen (this == NULL)

                call Unit(this).Rage.Add(this.valuePerUpdate)
            endloop
        endmethod

        method Set takes real value returns nothing
            set this.value = value
            set this.valuePerUpdate = value * thistype.UPDATE_TIME
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            call Unit(this).Event.Add(DESTROY_EVENT)

            if thistype.ACTIVE_LIST_Add(this) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.UpdateByTimer)
            endif

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            set thistype.UPDATE_TIMER = Timer.Create()

            call thistype(NULL).Bonus.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("MaxStamina")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxStamina.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 200.
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxStamina.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxStamina.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("MaxStamina")
        //! runtextmacro LinkToStruct("MaxStamina", "Base")
        //! runtextmacro LinkToStruct("MaxStamina", "Bonus")
        //! runtextmacro LinkToStruct("MaxStamina", "Relative")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Set takes real value returns nothing
            local real oldValue = this.Get()

            set this.value = value

            if (oldValue == 0.) then
                return
            endif

            call Unit(this).Stamina.Set(Unit(this).Stamina.Get() / oldValue * value)
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0.

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()

            call this.Update()
        endmethod
    endstruct

    //! runtextmacro Folder("Stamina")
        //! runtextmacro Struct("Exhaustion")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            static constant real SPEED_REL_INC = -0.5
            static constant string TEXT = "exhausted"

            eventMethod Event_BuffLose
                //call params.Unit.GetTrigger().Movement.Speed.RelativeA.Subtract(thistype.SPEED_REL_INC)
            endmethod

            eventMethod Event_BuffGain
                //call params.Unit.GetTrigger().Movement.Speed.RelativeA.Add(thistype.SPEED_REL_INC)
            endmethod

            method Subtract takes nothing returns nothing
                call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
            endmethod

            method Add takes nothing returns nothing
                call Unit(this).AddJumpingTextTag(String.Color.Do(thistype.TEXT, String.Color.WHITE), 0.021, KEY_ARRAY + this)
                call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
            endmethod

            initMethod Buff_Init of Header_Buffs
                //call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                //call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            endmethod

            static method Init takes nothing returns nothing
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Stamina")
        static Event DESTROY_EVENT
        static real EXHAUSTION_LIMIT = 0.2
        static constant real INTERVAL = 0.125
        static constant real LOST_VALUE_PER_SECOND = 20.
        static Event MOVE_EVENT

        static constant real LOST_VALUE_PER_INTERVAL = thistype.LOST_VALUE_PER_SECOND * thistype.INTERVAL

        //! runtextmacro LinkToStruct("Stamina", "Exhaustion")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method GetFactor takes nothing returns real
            local real max = Unit(this).MaxStamina.Get()

            if (max > 0) then
                return (this.Get() / max)
            endif

            return 1.
        endmethod

        method Set takes real value returns nothing
            local real max = Unit(this).MaxStamina.Get()
            local real oldValue = this.Get()

            set value = Math.Limit(value, 0., Unit(this).MaxStamina.Get())

            set this.value = value

            call Unit(this).Movement.Speed.UpdateNative()

            if (max <= 0) then
                return
            endif

            if (((value / max) > thistype.EXHAUSTION_LIMIT) == ((oldValue / max) > thistype.EXHAUSTION_LIMIT)) then
                return
            endif

            if ((value / max) > thistype.EXHAUSTION_LIMIT) then
                call this.Exhaustion.Subtract()
            else
                call this.Exhaustion.Add()
            endif
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

        eventMethod Event_Move
            local thistype this = params.Unit.GetTrigger()

            local real value = Math.Max(0., this.Get() - thistype.LOST_VALUE_PER_INTERVAL)

            call this.Set(value)
        endmethod

        eventMethod Event_Destroy
            local Unit parent = params.Unit.GetTrigger()

            call parent.Event.Remove(DESTROY_EVENT)
            call parent.Movement.Events.Interval.Remove(MOVE_EVENT)
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = Unit(this).MaxStamina.Get()
            call Unit(this).Event.Add(DESTROY_EVENT)
            call Unit(this).Movement.Events.Interval.Add(MOVE_EVENT, thistype.INTERVAL)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            set thistype.MOVE_EVENT = Event.Create(NULL, NULL, function thistype.Event_Move)

            call thistype(NULL).Exhaustion.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("StaminaRegeneration")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).StaminaRegeneration.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 25.
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            static UnitState STATE

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).StaminaRegeneration.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            eventMethod Event_State
                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            static method Init takes nothing returns nothing
                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).StaminaRegeneration.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("StaminaRegeneration")
        static Event DESTROY_EVENT
        static Event MOVE_ENDING_EVENT
        static Event MOVE_START_EVENT
        static constant real UPDATE_TIME = 0.25
        static Timer UPDATE_TIMER

        real valuePerUpdate

        //! runtextmacro LinkToStruct("StaminaRegeneration", "Base")
        //! runtextmacro LinkToStruct("StaminaRegeneration", "Bonus")
        //! runtextmacro LinkToStruct("StaminaRegeneration", "Relative")

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        timerMethod UpdateByTimer
            call thistype.FOR_EACH_LIST_Set()

            loop
                local thistype this = thistype.FOR_EACH_LIST_FetchFirst()

                exitwhen (this == NULL)

                call Unit(this).Stamina.Add(this.valuePerUpdate)
            endloop
        endmethod

        eventMethod Event_MoveEnding
            call thistype.ACTIVE_LIST_Add(params.Unit.GetTrigger())
        endmethod

        eventMethod Event_MoveStart
            call thistype.ACTIVE_LIST_Remove(params.Unit.GetTrigger())
        endmethod

        method Set takes real value returns nothing
            set this.value = value
            set this.valuePerUpdate = value * thistype.UPDATE_TIME
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        eventMethod Event_Destroy
            local Unit parent = params.Unit.GetTrigger()

            if thistype.ACTIVE_LIST_Remove(parent) then
                call thistype.UPDATE_TIMER.Pause()
            endif
            call parent.Event.Remove(DESTROY_EVENT)
            call parent.Movement.Events.Unreg(MOVE_ENDING_EVENT)
            call parent.Movement.Events.Unreg(MOVE_START_EVENT)
        endmethod

        method Event_Create takes nothing returns nothing
            call Unit(this).Event.Add(DESTROY_EVENT)
            call Unit(this).Movement.Events.Reg(MOVE_ENDING_EVENT)
            call Unit(this).Movement.Events.Reg(MOVE_START_EVENT)

            if thistype.ACTIVE_LIST_Add(this) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.UpdateByTimer)
            endif

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            set thistype.MOVE_ENDING_EVENT = Event.Create(UNIT.Movement.Events.ENDING_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_MoveEnding)
            set thistype.MOVE_START_EVENT = Event.Create(UNIT.Movement.Events.START_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_MoveStart)
            set thistype.UPDATE_TIMER = Timer.Create()

            call thistype(NULL).Bonus.Init()
        endmethod
    endstruct

	//! runtextmacro Folder("Bars")
		//! runtextmacro Struct("ExpiringCondition")
			/*method SetDisplayedBuff takes Buff whichBuff returns nothing
				call parent.Abilities.AddBySelf(thistype(whichBuff).buff_)
			endmethod

			eventMethod BuffGain
				call parent.Order.Immediate.DoNoTrig(Order.AVATAR)
			endmethod

			method Add takes real time returns nothing
				local Queue vals = this.vals

				if (this.vals == NULL) then
					set vals = Queue.Create()

					set this.vals = vals
				endif

				set this = Timer.Create()

				call vals.Add(this)
			endmethod

			method Event_Create takes nothing returns nothing
				set this.vals = NULL
			endmethod*/
		endstruct
	endscope

    //! runtextmacro Struct("Bars")
        static Event CAST_EVENT
        static Event DESTROY_EVENT
        static Event END_CAST_EVENT
        static constant real DISPLAY_MAX = 0.15
        static constant real DISPLAY_MAX_TRESHOLD = 0.9
        static constant real DISPLAY_MIN = 1.
        static constant real DISPLAY_MIN_TRESHOLD = 0.7
        static constant real HEIGHT = 175.
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")
        static Timer UPDATE_TIMER
        static constant real WIDTH = 60.

        static constant real UPDATE_LENGTH = 0.5 * thistype.UPDATE_TIME

        //static constant real DISPLAY_ELEV = 1 / (thistype.DISPLAY_MIN_TRESHOLD - thistype.DISPLAY_MAX_TRESHOLD)
        static constant real DISPLAY_ELEV = (thistype.DISPLAY_MAX - thistype.DISPLAY_MIN) / (thistype.DISPLAY_MAX_TRESHOLD - thistype.DISPLAY_MIN_TRESHOLD)
        //static constant real DISPLAY_OFFSET = 1 / (1 - (thistype.DISPLAY_MIN_TRESHOLD / thistype.DISPLAY_MAX_TRESHOLD))
        static constant real DISPLAY_OFFSET = (thistype.DISPLAY_MIN / thistype.DISPLAY_MIN_TRESHOLD - thistype.DISPLAY_MAX / thistype.DISPLAY_MAX_TRESHOLD) / (1 / thistype.DISPLAY_MIN_TRESHOLD - 1 / thistype.DISPLAY_MAX_TRESHOLD)

        lightning channelBar
        lightning channelJuice
        Timer channelTimer

        //lightning lifeBar
        //real lifeDisplayed
        //lightning lifeJuice

        lightning manaBar
        real manaDisplayed
        lightning manaJuice

        lightning rageBar
        real rageDisplayed
        lightning rageJuice

        lightning staminaBar
        real staminaDisplayed
        lightning staminaJuice

		//! runtextmacro LinkToStruct("Bars", "ExpiringCondition")

        timerMethod Update
            local real angle = GetCameraField(CAMERA_FIELD_ROTATION) - Math.QUARTER_ANGLE

            local real xPart = Math.Cos(angle)
            local real yPart = Math.Sin(angle)

			local integer iteration = thistype.ALL_COUNT

            loop
                local thistype this = thistype.ALL[iteration]

                if Unit(this).Classes.Contains(UnitClass.DEAD) then
                    //set this.lifeDisplayed = 0.
                    set this.manaDisplayed = 0.
                    set this.staminaDisplayed = 0.
                    /*call MoveLightningEx(this.lifeBar, false, 0., 0., 0., 0., 0., 0.)
                    call MoveLightningEx(this.lifeJuice, false, 0., 0., 0., 0., 0., 0.)*/
                    call MoveLightningEx(this.manaBar, false, 0., 0., 0., 0., 0., 0.)
                    call MoveLightningEx(this.manaJuice, false, 0., 0., 0., 0., 0., 0.)
                    call MoveLightningEx(this.staminaBar, false, 0., 0., 0., 0., 0., 0.)
                    call MoveLightningEx(this.staminaJuice, false, 0., 0., 0., 0., 0., 0.)
                else
                    local real height = Unit(this).Position.Z.Get() + thistype.HEIGHT * Unit(this).Scale.Get()
                    local real x = Unit(this).Position.X.Get()
                    local real xOffset = thistype.WIDTH * xPart
                    local real y = Unit(this).Position.Y.Get()
                    local real yOffset = thistype.WIDTH * yPart

					local real oldRelative
                    local real relative
                    local real val
                    local real maxVal

					set relative = this.channelTimer.GetTimeout()

                    if (relative > 0.) then
                        set relative = this.channelTimer.GetRemaining() / relative

                        call MoveLightningEx(this.channelBar, false, x - xOffset*1.5, y - yOffset*1.5, height+75, x + xOffset*1.5, y + yOffset*1.5, height+75)
                        call SetLightningColor(this.channelBar, 1., 1., 1., 1.)
                        call MoveLightningEx(this.channelJuice, false, x - xOffset*1.5, y - yOffset*1.5, height+75, x + (relative * 2 - 1) * xOffset*1.5, y + (relative * 2 - 1) * yOffset*1.5, height+75)
                        call SetLightningColor(this.channelJuice, 0., 0.75, 1., 1.)
                    endif

                    /*
					set oldRelative = this.lifeDisplayed
					set maxVal = Unit(this).MaxLife.Get()
					set val = Unit(this).Life.Get()

					if (maxVal > 0.) then
                    	set relative = val / maxVal
                    else
                        set relative = 0.
                    endif

					if (relative > oldRelative) then
						set relative = Math.Min(oldRelative + thistype.UPDATE_LENGTH, relative)
					else
						set relative = Math.Max(oldRelative - thistype.UPDATE_LENGTH, relative)
					endif

                    set this.lifeDisplayed = relative

                    if (relative > thistype.DISPLAY_MAX_TRESHOLD) then
                        call MoveLightningEx(this.lifeBar, false, 0., 0., 0., 0., 0., 0.)
                        call MoveLightningEx(this.lifeJuice, false, 0., 0., 0., 0., 0., 0.)
                    else
                        call MoveLightningEx(this.lifeBar, false, x - xOffset, y - yOffset, height+25, x + xOffset, y + yOffset, height+25)
                        call SetLightningColor(this.lifeBar, 1., 1., 1., Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                        call MoveLightningEx(this.lifeJuice, false, x - xOffset, y - yOffset, height+25, x + (relative * 2 - 1) * xOffset, y + (relative * 2 - 1) * yOffset, height+25)
                        call SetLightningColor(this.lifeJuice, 0., 1., 0., Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                    endif
                    */

					set oldRelative = this.manaDisplayed
					set maxVal = Unit(this).MaxMana.Get()
					set val = Unit(this).Mana.Get()

					if (maxVal > 0.) then
                    	set relative = val / maxVal
                    else
                        set relative = 0.
                    endif

					if (relative > oldRelative) then
						set relative = Math.Min(oldRelative + thistype.UPDATE_LENGTH, relative)
					else
						set relative = Math.Max(oldRelative - thistype.UPDATE_LENGTH, relative)
					endif

                    set this.manaDisplayed = relative

                    if (relative > thistype.DISPLAY_MAX_TRESHOLD) then
                        call MoveLightningEx(this.manaBar, false, 0., 0., 0., 0., 0., 0.)
                        call MoveLightningEx(this.manaJuice, false, 0., 0., 0., 0., 0., 0.)
                    else
                        call MoveLightningEx(this.manaBar, false, x - xOffset, y - yOffset, height+50, x + xOffset, y + yOffset, height+50)
                        call SetLightningColor(this.manaBar, 1., 1., 1., Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                        call MoveLightningEx(this.manaJuice, false, x - xOffset, y - yOffset, height+50, x + (relative * 2 - 1) * xOffset, y + (relative * 2 - 1) * yOffset, height+50)
                        call SetLightningColor(this.manaJuice, 1., 0., 1., Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                    endif

					/*
					set oldRelative = this.rageDisplayed
					set maxVal = Unit(this).MaxRage.Get()
					set val = Unit(this).Rage.Get()

					if (maxVal > 0.) then
                    	set relative = val / maxVal
                    else
                        set relative = 0.
                    endif

					if (relative > oldRelative) then
						set relative = Math.Min(oldRelative + thistype.UPDATE_LENGTH, relative)
					else
						set relative = Math.Max(oldRelative - thistype.UPDATE_LENGTH, relative)
					endif

                    set this.rageDisplayed = relative

                    if (relative > thistype.DISPLAY_MAX_TRESHOLD) then
                        call MoveLightningEx(this.rageBar, false, 0., 0., 0., 0., 0., 0.)
                        call MoveLightningEx(this.rageJuice, false, 0., 0., 0., 0., 0., 0.)
                    else
                        call MoveLightningEx(this.rageBar, false, x - xOffset, y - yOffset, height, x + xOffset, y + yOffset, height)
                        call SetLightningColor(this.rageBar, 1., 1., 1., Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                        call MoveLightningEx(this.rageJuice, false, x - xOffset, y - yOffset, height, x + (relative * 2 - 1) * xOffset, y + (relative * 2 - 1) * yOffset, height)
                        call SetLightningColor(this.rageJuice, 0.83, 0.37, 0.1, Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                    endif
                    */

					set oldRelative = this.staminaDisplayed
					set maxVal = Unit(this).MaxStamina.Get()
					set val = Unit(this).Stamina.Get()

					if (maxVal > 0.) then
                    	set relative = val / maxVal
                    else
                        set relative = 0.
                    endif

					if (relative > oldRelative) then
						set relative = Math.Min(oldRelative + thistype.UPDATE_LENGTH, relative)
					else
						set relative = Math.Max(oldRelative - thistype.UPDATE_LENGTH, relative)
					endif

                    set this.staminaDisplayed = relative

                    if (relative > thistype.DISPLAY_MAX_TRESHOLD) then
                        call MoveLightningEx(this.staminaBar, false, 0., 0., 0., 0., 0., 0.)
                        call MoveLightningEx(this.staminaJuice, false, 0., 0., 0., 0., 0., 0.)
                    else
                        call MoveLightningEx(this.staminaBar, false, x - xOffset, y - yOffset, height, x + xOffset, y + yOffset, height)
                        call SetLightningColor(this.staminaBar, 1., 1., 1., Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                        call MoveLightningEx(this.staminaJuice, false, x - xOffset, y - yOffset, height, x + (relative * 2 - 1) * xOffset, y + (relative * 2 - 1) * yOffset, height)
                        call SetLightningColor(this.staminaJuice, 1., 1., 0., Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                    endif
                endif

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        eventMethod Event_Destroy
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            if this.RemoveFromList() then
                call thistype.UPDATE_TIMER.Pause()
            endif
            call parent.Event.Remove(CAST_EVENT)
            call parent.Event.Remove(DESTROY_EVENT)
            call parent.Event.Remove(END_CAST_EVENT)
            call this.channelTimer.Destroy()
            call DestroyLightning(this.channelBar)
            call DestroyLightning(this.channelJuice)
            //call DestroyLightning(this.lifeBar)
            //call DestroyLightning(this.lifeJuice)
            call DestroyLightning(this.manaBar)
            call DestroyLightning(this.manaJuice)
            call DestroyLightning(this.rageBar)
            call DestroyLightning(this.rageJuice)
            call DestroyLightning(this.staminaBar)
            call DestroyLightning(this.staminaJuice)
        endmethod

        method EndChannel takes nothing returns nothing
            call MoveLightningEx(this.channelBar, false, 0., 0., 0., 0., 0., 0.)
            call MoveLightningEx(this.channelJuice, false, 0., 0., 0., 0., 0., 0.)
            call this.channelTimer.Abort()
        endmethod

        eventMethod Event_EndCast
            //call thistype(params.Unit.GetTrigger()).EndChannel()
        endmethod

        method StartChannel takes real duration returns nothing
            call this.channelTimer.Start(duration, false, null)
        endmethod

        eventMethod Event_SpellEffect
            /*local real duration = params.Spell.GetTrigger().GetChannelTime(params.Spell.GetLevel())

            if (duration == 0.) then
                return
            endif

            call thistype(params.Unit.GetTrigger()).StartChannel(duration)*/
        endmethod

        method Event_Create takes nothing returns nothing
            set this.channelBar = AddLightningEx(thistype.BAR_ID, false, 0., 0., 0., 0., 0., 0.)
            set this.channelJuice = AddLightningEx(thistype.JUICE_ID, false, 0., 0., 0., 0., 0., 0.)
            set this.channelTimer = Timer.Create()
            //set this.lifeBar = AddLightningEx(thistype.BAR_ID, false, 0., 0., 0., 0., 0., 0.)
            //set this.lifeDisplayed = 0.
            //set this.lifeJuice = AddLightningEx(thistype.JUICE_ID, false, 0., 0., 0., 0., 0., 0.)
            set this.manaBar = AddLightningEx(thistype.BAR_ID, false, 0., 0., 0., 0., 0., 0.)
            set this.manaDisplayed = 0.
            set this.manaJuice = AddLightningEx(thistype.JUICE_ID, false, 0., 0., 0., 0., 0., 0.)
            set this.rageBar = AddLightningEx(thistype.BAR_ID, false, 0., 0., 0., 0., 0., 0.)
            set this.rageDisplayed = 0.
            set this.rageJuice = AddLightningEx(thistype.JUICE_ID, false, 0., 0., 0., 0., 0., 0.)
            set this.staminaBar = AddLightningEx(thistype.BAR_ID, false, 0., 0., 0., 0., 0., 0.)
            set this.staminaDisplayed = 0.
            set this.staminaJuice = AddLightningEx(thistype.JUICE_ID, false, 0., 0., 0., 0., 0., 0.)

            call Unit(this).Event.Add(CAST_EVENT)
            call Unit(this).Event.Add(DESTROY_EVENT)
            call Unit(this).Event.Add(END_CAST_EVENT)

            if this.AddToList() then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.CAST_EVENT = Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.HEADER_TOP, function thistype.Event_SpellEffect)
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            set thistype.END_CAST_EVENT = Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_EndCast)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("TimedLife")
        Timer durationTimer

        timerMethod EndingByTimer
            local thistype this = Timer.GetExpired().GetData()

            local Unit parent = this

            call parent.Buffs.Remove(thistype.DUMMY_BUFF)

            call parent.Kill()
        endmethod

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

            local Timer durationTimer = this.durationTimer

            call durationTimer.Destroy()
        endmethod

        eventMethod Event_BuffGain
            local real duration = TEMP_REAL
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

			local Timer durationTimer = Timer.Create()

            set this.durationTimer = durationTimer
            call durationTimer.SetData(this)

            call UnitApplyTimedLife(parent.self, 'RTLF', duration + 0.01)

            call durationTimer.Start(duration, false, function thistype.EndingByTimer)
        endmethod

        method Stop takes nothing returns nothing
            call Unit(this).Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        method Start takes real duration returns nothing
            set TEMP_REAL = duration

            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Struct("Transport")
    	static EventType ENDING_EVENT_TYPE
    	static EventType START_EVENT_TYPE

        DummyUnit dummyUnit
        Unit transporter

        //! runtextmacro CreateSimpleFlagState_NotStart()

        method SetPosition takes real x, real y returns nothing
            call this.dummyUnit.Position.SetXY(x, y)
        endmethod

        method Ending_TriggerEvents takes nothing returns nothing
            local Unit parent = this

            local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

            call params.Unit.SetTrigger(this)

			local EventResponse unitParams = EventResponse.Create(parent.Id.Get())

            call unitParams.Unit.SetTrigger(this)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = Event.CountAtStatics(thistype.ENDING_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Event.GetFromStatics(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration2 = parent.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call parent.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run(unitParams)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
            call unitParams.Destroy()
        endmethod

        eventMethod Event_BuffLose
            local Unit parent = params.Unit.GetTrigger()

            local thistype this = parent

			call this.Set(false)

			local Unit transporter = this.transporter

			if (transporter == NULL) then
	            local DummyUnit dummyUnit = this.dummyUnit
	
	            /*call ShowUnit(parent.self, true)*/
	
	            call dummyUnit.Kill()
	
	            call dummyUnit.DestroyInstantly()
	        else
				call parent.Position.SetWithCollision(transporter.Position.X.Get(), transporter.Position.Y.Get())
            endif

			if IsUnitHidden(parent.self) then
				call ShowUnit(parent.self, true)
			endif

			call this.Ending_TriggerEvents()

            call parent.Selection.Update()
        endmethod

        method Start_TriggerEvents takes nothing returns nothing            
            local Unit parent = this

            local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

            call params.Unit.SetTrigger(this)

			local EventResponse unitParams = EventResponse.Create(parent.Id.Get())

            call unitParams.Unit.SetTrigger(this)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = Event.CountAtStatics(thistype.START_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Event.GetFromStatics(thistype.START_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration2 = parent.Event.Count(thistype.START_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call parent.Event.Get(thistype.START_EVENT_TYPE, priority, iteration2).Run(unitParams)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
            call unitParams.Destroy()
        endmethod

        eventMethod Event_BuffGain
            local Unit parent = params.Unit.GetTrigger()
            local Unit transporter = params.Buff.GetData()

			local thistype this = parent

			local DummyUnit dummyUnit = NULL
			local boolean success = true

			if (transporter == NULL) then
	            set dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, parent.Position.X.Get(), parent.Position.Y.Get(), 0., 0.)
	
	            /*call ShowUnit(parent.self, false)
	            //call parent.Select(parent.Owner.Get(), false)*/
	
	            call dummyUnit.Abilities.AddBySelf(thistype.CARGO_SPELL_ID)
	            call dummyUnit.Abilities.AddBySelf(thistype.LOAD_IN_SPELL_ID)
	            call dummyUnit.Owner.Set(parent.Owner.Get())
	
	            if not dummyUnit.Order.UnitTarget(Order.LOAD, parent) then
	                call DebugEx(thistype.NAME + ": cannot load in " + parent.GetName())
	
	                //call ShowUnit(parent.self, false)

	                set success = false
	            endif
            else
                local User parentOwner = parent.Owner.Get()
                local User prevOwner = transporter.Owner.Get()

	            call transporter.Abilities.AddBySelf(thistype.CARGO_SPELL_ID)
	            call transporter.Abilities.AddBySelf(thistype.LOAD_IN_SPELL_ID)
	            call transporter.Owner.Set(parentOwner)

				call parentOwner.EnableAbilityBySelf(thistype.LOAD_IN_SPELL_ID, true)

				if not transporter.Order.UnitTarget(Order.LOAD, parent) then
					call DebugEx(thistype.NAME + ": cannot load in " + parent.GetName() + " (transporter="+transporter.GetName()+")")

					set success = false
				endif

				call parentOwner.EnableAbilityBySelf(thistype.LOAD_IN_SPELL_ID, false)

				call transporter.Owner.Set(prevOwner)
            endif

			if success then
				set this.dummyUnit = dummyUnit
				set this.transporter = transporter

				call this.Set(true)
			else
				call parent.Buffs.Remove(thistype.DUMMY_BUFF)
			endif

			call this.Start_TriggerEvents()
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTo takes Unit transporter returns nothing
            call Unit(this).Buffs.AddEx(thistype.DUMMY_BUFF, 1, transporter)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(false)
        endmethod

        initMethod Buff_Init of Header_Buffs
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod

        static method Init takes nothing returns nothing
        	set thistype.ENDING_EVENT_TYPE = EventType.Create()
        	set thistype.START_EVENT_TYPE = EventType.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("Hero")
        //! runtextmacro LinkToStruct("Unit", "Agility")
        //! runtextmacro LinkToStruct("Unit", "Intelligence")
        //! runtextmacro LinkToStruct("Unit", "Level")
        //! runtextmacro LinkToStruct("Unit", "SkillPoints")
        //! runtextmacro LinkToStruct("Unit", "Strength")

        method Revive takes real x, real y returns nothing
            call Unit(this).Classes.Remove(UnitClass.DEAD)
            call Unit(this).Revival.Set(false)

            call ReviveHero(Unit(this).self, x, y, false)

            call Unit(this).Revival.Events.Start()
        endmethod

        method SelectSpell takes Spell whichSpell, boolean useSkillPoints returns nothing
            if not useSkillPoints then
                call this.SkillPoints.Add(1)
            endif

            call SelectHeroSkill(Unit(this).self, HeroSpell.GetLearnerSpellId(whichSpell, Unit(this).Abilities.GetLevel(whichSpell) + 1))
        endmethod
    endstruct

    //! runtextmacro Folder("Position")
        //! runtextmacro Folder("Timed")
            //! runtextmacro Struct("Accelerated")
                method AddIn takes real xAdd, real yAdd, real zAdd, real xAddAdd, real yAddAdd, real zAddAdd, real duration
                    call TranslationAccelerated.CreateIn(this, xAdd, yAdd, zAdd, xAddAdd, yAddAdd, zAddAdd, duration)
                endmethod

                method AddForNoCheck takes real xAdd, real yAdd, real zAdd, real xAddAdd, real yAddAdd, real zAddAdd, real duration
					call TranslationAccelerated.CreateForNoCheck(this, xAdd, yAdd, zAdd, xAddAdd, yAddAdd, zAddAdd, duration)
                endmethod

                method AddFor takes real xAdd, real yAdd, real zAdd, real xAddAdd, real yAddAdd, real zAddAdd, real duration
					call TranslationAccelerated.CreateFor(this, xAdd, yAdd, zAdd, xAdd, yAddAdd, zAddAdd, duration)
                endmethod

                method AddForMundane takes real xSpeed, real ySpeed, real zSpeed, real xAcc, real yAcc, real zAcc, real duration
					call TranslationAccelerated.CreateForMundane(this, xSpeed, ySpeed, zSpeed, xAcc, yAcc, zAcc, duration)
                endmethod

                method AddSpeedDirection takes real speed, real acceleration, real angle, real duration
                    call TranslationAccelerated.CreateSpeedDirection(this, speed, acceleration, angle, duration)
                endmethod

                method AddKnockback takes real speed, real acceleration, real angle, real duration
					call KnockbackAccelerated.Create(this, speed, acceleration, angle, duration)
                endmethod

                static method Init
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Timed")
            //! runtextmacro LinkToStruct("Timed", "Accelerated")

            method AddNoCheck takes real xAdd, real yAdd, real zAdd, real duration
            	call Translation.CreateNoCheck(this, xAdd, yAdd, zAdd, duration)
            endmethod

            method Add takes real xAdd, real yAdd, real zAdd, real duration
                call Translation.Create(this, xAdd, yAdd, zAdd, duration)
            endmethod

            method AddSpeedDirection takes real speed, real angle, real duration
                call Translation.CreateSpeedDirection(this, speed, angle, duration)
            endmethod

            method AddKnockback takes real speed, real angle, real duration
                call Knockback.Create(this, speed, angle, duration)
            endmethod

            method Set takes real x, real y, real z, real duration
                call Translation.CreateTo(this, x - Unit(this).Position.X.Get(), y - Unit(this).Position.Y.Get(), z - Unit(this).Position.Z.Get(), duration)
            endmethod

            method SetXY takes real x, real y, real duration
                call Translation.CreateToXY(this, x, y, duration)
            endmethod

            static method Init
                call thistype(NULL).Accelerated.Init()

				call Translation.Init()
            endmethod
        endstruct

        //! runtextmacro Struct("X")
            method Get takes nothing returns real
                return GetUnitX(Unit(this).self)
            endmethod

            method Set takes real val returns nothing
            	if Knockback.Event_Move(this, val, Unit(this).Position.Y.Get()) then
                    return
                endif
            	if KnockbackAccelerated.Event_Move(this, val, Unit(this).Position.Y.Get()) then
                    return
                endif

                if ((val < WORLD_MIN_X) or (val > WORLD_MAX_X)) then
                    call DebugEx(thistype.NAME + " out of bounds " + Unit(this).GetName() + " " + R2S(val))

                    return
                endif

                call SetUnitX(Unit(this).self, val)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")
        endstruct

        //! runtextmacro Struct("Y")
            method Get takes nothing returns real
                return GetUnitY(Unit(this).self)
            endmethod

            method Set takes real val returns nothing
            	if Knockback.Event_Move(this, Unit(this).Position.X.Get(), val) then
                    return
                endif
            	if KnockbackAccelerated.Event_Move(this, Unit(this).Position.X.Get(), val) then
                    return
                endif

                if ((val < WORLD_MIN_Y) or (val > WORLD_MAX_Y)) then
                    call DebugEx(thistype.NAME + " out of bounds " + Unit(this).GetName() + " " + R2S(val))

                    return
                endif

                call SetUnitY(Unit(this).self, val)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")
        endstruct

        //! runtextmacro Struct("Z")
            method GetFlyHeight takes nothing returns real
                return GetUnitFlyHeight(Unit(this).self)
            endmethod

            method SetFlyHeight takes real z
                call SetUnitFlyHeight(Unit(this).self, z, 0.)
            endmethod

            method GetByCoords takes real x, real y returns real
                return (Spot.GetHeight(x, y) + this.GetFlyHeight())
            endmethod

            method SetByCoords takes real x, real y, real z
                call SetUnitFlyHeight(Unit(this).self, z - Spot.GetHeight(x, y), 0.)
            endmethod

            method Get takes nothing returns real
                return this.GetByCoords(Unit(this).Position.X.Get(), Unit(this).Position.Y.Get())
            endmethod

            method Set takes real z
                call this.SetByCoords(Unit(this).Position.X.Get(), Unit(this).Position.Y.Get(), z)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create
                call Unit(this).Abilities.AddBySelf(BJUnit.Z_ENABLER_SPELL_ID)
                call Unit(this).Abilities.RemoveBySelf(BJUnit.Z_ENABLER_SPELL_ID)
            endmethod

            static method Init
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Position")
        //! runtextmacro LinkToStruct("Position", "Timed")

        //! runtextmacro LinkToStruct("Position", "X")
        //! runtextmacro LinkToStruct("Position", "Y")
        //! runtextmacro LinkToStruct("Position", "Z")

        method DistToLine takes real sourceX, real sourceY, real length, real angle, real widthStart, real widthEnd returns real
            return Math.Max(0., Math.Shapes.DistToLine(sourceX, sourceY, length, angle, widthStart, widthEnd, this.X.Get(), this.Y.Get()) - Unit(this).CollisionSize.Get(true))
        endmethod

        method InLine takes real sourceX, real sourceY, real length, real angle, real widthStart, real widthEnd returns boolean
            return (this.DistToLine(sourceX, sourceY, length, angle, widthStart, widthEnd) == 0.)
        endmethod

        method InRangeWithCollision takes real x, real y, real radius returns boolean
            local real dX = x - Unit(this).Position.X.Get()
            local real dY = y - Unit(this).Position.Y.Get()

            set radius = (radius + Unit(this).CollisionSize.Get(true))

            return (dX * dX + dY * dY < radius * radius)
        endmethod

        method InRangeWithCollisionWithZ takes real x, real y, real z, real radius returns boolean
            local real dX = x - this.X.Get()
            local real dY = y - this.Y.Get()
            local real dZ = z - this.Z.Get()

            set radius = (radius + Unit(this).CollisionSize.Get(true))

            return (dX * dX + dY * dY + dZ * dZ < radius * radius)
        endmethod

        method Set takes real x, real y, real z returns nothing
            call this.X.Set(x)
            call this.Y.Set(y)

            call this.Z.SetByCoords(x, y, z)
        endmethod

        method SetWithCollision takes real x, real y returns nothing
            call SetUnitPosition(Unit(this).self, x, y)
        endmethod

        method SetXY takes real x, real y returns nothing
            call this.X.Set(x)
            call this.Y.Set(y)
            call this.Z.SetByCoords(x, y, this.Z.Get())
        endmethod

        method Nudge takes nothing returns nothing
            local Lightning effectLightning
            local real sourceX = this.X.Get()
            local real sourceY = this.Y.Get()

            local item dummyItem = CreateItem(thistype.NUDGE_ITEM_ID, sourceX, sourceY)

            local real targetX = GetWidgetX(dummyItem)
            local real targetY = GetWidgetY(dummyItem)

            local real d = Math.DistanceByDeltas(targetX - sourceX, targetY - sourceY)

            call RemoveItem(dummyItem)

            set dummyItem = null

            if (d < 1.) then
                return
            endif

            local real duration = d / 150.
//            set duration = 0.4

            call this.Timed.Accelerated.AddIn(targetX - sourceX, targetY - sourceY, 0., 0., 0., 0., duration)
//            call this.Timed.AddSpeedDirection(400., Math.AngleBetweenCoords(sourceX, sourceY, targetX, targetY), duration)

            set effectLightning = Lightning.Create(thistype.NUDGE_BOLT)

            call effectLightning.FromSpotToUnit.Start(targetX, targetY, Spot.GetHeight(targetX, targetY), this)

            call effectLightning.DestroyTimed.Start(duration)
        endmethod

        method SetXYWithTerrainWalkableCollision takes real x, real y returns nothing
            if Spot.IsWalkable(x, y) then
                call this.X.Set(x)
                call this.Y.Set(y)
            endif
        endmethod

        method SetXYZ takes real x, real y, real z returns nothing
            call this.X.Set(x)
            call this.Y.Set(y)

            call this.Z.SetByCoords(x, y, z)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Z.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Z.Init()

            call thistype(NULL).Timed.Init()
        endmethod
    endstruct

	//! runtextmacro Folder("Selection")
		//! runtextmacro Struct("Circle")
			static Event DESTROY_EVENT
			//! runtextmacro GetKey("KEY")
			//! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

			UnitEffect dummyEffect
			Unit parent
			User whichPlayer

			method Ending takes nothing returns nothing
				call this.dummyEffect.Data.Integer.Remove(KEY)
				call this.whichPlayer.Data.Integer.Remove(KEY_ARRAY_DETAIL + this.parent)

				//call this.dummyEffect.Event.Remove(DESTROY_EVENT)

				call this.deallocate()
			endmethod

			method Destroy takes User whichPlayer returns nothing
				local Unit parent = this

				set this = whichPlayer.Data.Integer.Get(KEY_ARRAY_DETAIL + this)

	        	local UnitEffect dummyEffect = this.dummyEffect

				call this.Ending()

				call dummyEffect.Destroy()
			endmethod

			eventMethod Event_Destroy
				local thistype this = params.UnitEffect.GetTrigger().Data.Integer.Get(KEY) 

				call this.Ending()
			endmethod

			method Create takes User whichPlayer returns nothing
				local Unit parent = this

				local string effectPath

				if whichPlayer.IsLocal() then
					set effectPath = thistype.DUMMY_EFFECT_PATH[whichPlayer.GetNativeIndex() + 1]
				else
					set effectPath = ""
				endif

				set this = thistype.allocate()

                local UnitEffect dummyEffect = parent.Effects.Create(effectPath, thistype.DUMMY_EFFECT_ATTACH_POINT, EffectLevel.LOW)

                set this.dummyEffect = dummyEffect
                set this.parent = parent
                set this.whichPlayer = whichPlayer
                call dummyEffect.Data.Integer.Set(KEY, this)
                call whichPlayer.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)

				//call dummyEffect.Event.Add(DESTROY_EVENT)
			endmethod

			static method Init takes nothing returns nothing
				//set thistype.DESTROY_EVENT = Event.Create(UnitEffect.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
			endmethod
		endstruct
	endscope

    //! runtextmacro Struct("Selection")
        static Event DEATH_EVENT
        static Event DESTROY_EVENT
        static EventType ENDING_EVENT_TYPE
        static Trigger ENDING_TRIGGER
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static Event OWNER_CHANGE_EVENT
        static EventType REPEAT_EVENT_TYPE
        static EventType START_EVENT_TYPE
        static Trigger START_TRIGGER

		//! runtextmacro LinkToStruct("Selection", "Circle")

		method Contains takes User whichPlayer returns boolean
			return Unit(this).Data.Integer.Table.Contains(KEY_ARRAY, whichPlayer)
		endmethod

        method Count takes nothing returns integer
            return Unit(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method CountAtPlayer takes User whichPlayer returns integer
            return whichPlayer.Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method IsEmpty takes nothing returns boolean
            return Unit(this).Data.Integer.Table.IsEmpty(KEY_ARRAY)
        endmethod

        method GetFromPlayer takes User whichPlayer, integer index returns Unit
            return whichPlayer.Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Ending_TriggerEvents takes User whichPlayer returns nothing
            local Unit parent = this

            local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

            call params.Unit.SetTrigger(this)
            call params.User.SetTrigger(whichPlayer)

			local EventResponse unitParams = EventResponse.Create(parent.Id.Get())

            call unitParams.Unit.SetTrigger(this)
            call unitParams.User.SetTrigger(whichPlayer)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = Event.CountAtStatics(thistype.ENDING_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Event.GetFromStatics(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration2 = parent.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call parent.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run(unitParams)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
            call unitParams.Destroy()
        endmethod

        method Ending takes User whichPlayer returns nothing
			call this.Circle.Destroy(whichPlayer)

            call whichPlayer.Data.Integer.Table.Remove(KEY_ARRAY, this)
            if Unit(this).Data.Integer.Table.Remove(KEY_ARRAY, whichPlayer) then
                call Unit(this).Event.Remove(DEATH_EVENT)
                call Unit(this).Event.Remove(DESTROY_EVENT)
                call Unit(this).Event.Remove(OWNER_CHANGE_EVENT)
            endif

            call this.Ending_TriggerEvents(whichPlayer)
        endmethod

        trigMethod EndingTrig
            call thistype(UNIT.Event.Native.GetTrigger()).Ending(USER.Event.Native.GetTrigger())
        endmethod

		static method EndParent takes Unit parent returns nothing
            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                call thistype(parent).Ending(parent.Data.Integer.Table.Get(KEY_ARRAY, iteration))

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
		endmethod

        eventMethod Event_Death
            local Unit parent = params.Unit.GetTrigger()

            call thistype.EndParent(parent)
        endmethod

        eventMethod Event_Destroy
            local Unit parent = params.Unit.GetTrigger()

            call thistype.EndParent(parent)
        endmethod

		eventMethod Event_OwnerChange
			local User targetOwner = params.User.GetTarget()
			local Unit parent = params.Unit.GetTrigger()

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            loop
            	local User whichPlayer = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            	if not GetPlayerAlliance(targetOwner.self, whichPlayer.self, ALLIANCE_SHARED_CONTROL) then
                	call thistype(parent).Ending(whichPlayer)
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
		endmethod

        method Repeat_TriggerEvents takes User whichPlayer returns nothing
            local Unit parent = this

            local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

            call params.Unit.SetTrigger(this)
            call params.User.SetTrigger(whichPlayer)

			local EventResponse unitParams = EventResponse.Create(parent.Id.Get())

            call unitParams.Unit.SetTrigger(this)
            call unitParams.User.SetTrigger(whichPlayer)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = Event.CountAtStatics(thistype.REPEAT_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Event.GetFromStatics(thistype.REPEAT_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration2 = parent.Event.Count(thistype.REPEAT_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call parent.Event.Get(thistype.REPEAT_EVENT_TYPE, priority, iteration2).Run(unitParams)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
            call unitParams.Destroy()
        endmethod

        method Start_TriggerEvents takes User whichPlayer returns nothing
            local Unit parent = this

            local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

            call params.Unit.SetTrigger(this)
            call params.User.SetTrigger(whichPlayer)

			local EventResponse unitParams = EventResponse.Create(parent.Id.Get())

            call unitParams.Unit.SetTrigger(this)
            call unitParams.User.SetTrigger(whichPlayer)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = Event.CountAtStatics(thistype.START_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Event.GetFromStatics(thistype.START_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration2 = parent.Event.Count(thistype.START_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call parent.Event.Get(thistype.START_EVENT_TYPE, priority, iteration2).Run(unitParams)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
            call unitParams.Destroy()
        endmethod

        method Start takes User whichPlayer returns nothing
        	local Unit parent = this

            if not whichPlayer.Data.Integer.Table.Contains(KEY_ARRAY, parent) then
                call whichPlayer.Data.Integer.Table.Add(KEY_ARRAY, parent)
                if parent.Data.Integer.Table.Add(KEY_ARRAY, whichPlayer) then
                    call parent.Event.Add(DEATH_EVENT)
                    call parent.Event.Add(DESTROY_EVENT)
                    call parent.Event.Add(OWNER_CHANGE_EVENT)
                endif

                call this.Start_TriggerEvents(whichPlayer)

                call this.Circle.Create(whichPlayer)
            endif

            call this.Repeat_TriggerEvents(whichPlayer)
        endmethod

        trigMethod StartTrig
            call thistype(UNIT.Event.Native.GetTrigger()).Start(USER.Event.Native.GetTrigger())
        endmethod

		DummyUnit dummyUnit

		method Update takes nothing returns nothing
			local Unit parent = this

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            loop
            	exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

            	local User whichPlayer = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

				if not parent.IsSelected(whichPlayer) then
					call parent.Select(whichPlayer, true)
                endif

                set iteration = iteration - 1
            endloop
		endmethod

		method UpdateCircle takes nothing returns nothing
			//call this.dummyUnit.Scale.Set(Unit(this).CollisionSize.Get(true) / 100)
		endmethod

		method Event_Create takes nothing returns nothing
			//set dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, 0., 0., 0., 0.)
			
			//set this.dummyUnit = dummyUnit
			
			//call dummyUnit.FollowUnit.Start(this, false, false, 0, 0, 0)
			
			call this.UpdateCircle()
		endmethod

        static method Init takes nothing returns nothing
        	set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            set thistype.ENDING_EVENT_TYPE = EventType.Create()
            set thistype.ENDING_TRIGGER = Trigger.CreateFromCode(function thistype.EndingTrig)
            set thistype.OWNER_CHANGE_EVENT = Event.Create(UNIT.Owner.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_OwnerChange)
            set thistype.REPEAT_EVENT_TYPE = EventType.Create()
            set thistype.START_EVENT_TYPE = EventType.Create()
            set thistype.START_TRIGGER = Trigger.CreateFromCode(function thistype.StartTrig)

            call thistype.ENDING_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_DESELECTED, null)
            call thistype.START_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_SELECTED, null)

			call thistype(NULL).Circle.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("SightRange")
        //! runtextmacro Struct("Base")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).SightRange.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = Unit(this).Type.Get().SightRange.Get()
            endmethod

            static method Init takes nothing returns nothing
            endmethod
        endstruct

        //! runtextmacro Struct("Bonus")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).SightRange.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).SightRange.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("SightRange")
        //! runtextmacro LinkToStruct("SightRange", "Base")
        //! runtextmacro LinkToStruct("SightRange", "Bonus")
        //! runtextmacro LinkToStruct("SightRange", "Relative")

        //! runtextmacro Unit_CreateStateWithTemporaryAbilities("SightRange")

        method Update takes nothing returns nothing
            call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        eventMethod Event_TypeChange
            local UnitType sourceType = params.UnitType.GetSource()
            local UnitType targetType = params.UnitType.GetTrigger()
            local thistype this = params.Unit.GetTrigger()

            //set this.nativeValue = targetType.SightRange.GetBJ()
            set this.value = this.Get() + targetType.SightRange.GetBJ() - sourceType.SightRange.GetBJ()

			call this.Base.Add(targetType.SightRange.Get() - sourceType.SightRange.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = Unit(this).Type.Get().SightRange.GetBJ()

            call this.Base.Event_Create()
            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
        	call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            call thistype(NULL).Base.Init()
        endmethod
    endstruct

    ///! runtextmacro Folder("Hero")
        globals
            constant real DAMAGE_BONUS_PER_HERO_ATTRIBUTE_POINT = 0.3
            constant real PRIMARY_ATTRIBUTE_FACTOR = 1.25
        endglobals

        //! textmacro CreateHeroAttribute takes name
            real value

            method Get takes nothing returns real
                return this.value
            endmethod

            method Set takes real amount returns nothing
                local real oldAmount = this.Get()

                set this.value = amount

				local real amount2 = amount - oldAmount
                local integer packet
                local integer packetLevel

                if (amount * oldAmount <= 0.) then
                    if (oldAmount < 0.) then
                        set packetLevel = DECREASING_SPELLS_MAX

                        loop
                            call Unit(this).Abilities.RemoveBySelf(thistype.DECREASING_SPELLS_ID[packetLevel])

                            set packetLevel = packetLevel - 1
                            exitwhen (packetLevel < ARRAY_MIN)
                        endloop
                    else
                        set packetLevel = INCREASING_SPELLS_MAX

                        loop
                            call Unit(this).Abilities.RemoveBySelf(thistype.INCREASING_SPELLS_ID[packetLevel])

                            set packetLevel = packetLevel - 1
                            exitwhen (packetLevel < ARRAY_MIN)
                        endloop
                    endif
                    if (amount < 0.) then
                        set amount2 = -amount

                        set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), DECREASING_SPELLS_MAX)

                        loop
                            exitwhen (amount2 < 1)

                            set packet = PACKETS[packetLevel]

                            if (packet <= amount2) then
                                call Unit(this).Abilities.AddBySelf(thistype.DECREASING_SPELLS_ID[packetLevel])
                                set amount2 = amount2 - packet
                            endif

                            set packetLevel = packetLevel - 1
                        endloop
                    else
                        set amount2 = amount
                        set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), INCREASING_SPELLS_MAX)

                        loop
                            exitwhen (amount2 < 1.)

                            set packet = PACKETS[packetLevel]

                            if (packet <= amount2) then
                                call Unit(this).Abilities.AddBySelf(thistype.INCREASING_SPELLS_ID[packetLevel])
                                set amount2 = amount2 - packet
                            endif

                            set packetLevel = packetLevel - 1
                        endloop
                    endif
                else
                    set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), DECREASING_SPELLS_MAX)

                    if (amount < 0.) then
                        set amount2 = -amount

                        loop
                            exitwhen (packetLevel < ARRAY_MIN)

                            set packet = PACKETS[packetLevel]

                            if (packet <= amount2) then
                                call Unit(this).Abilities.AddBySelf(thistype.DECREASING_SPELLS_ID[packetLevel])
                                set amount2 = amount2 - packet
                            else
                                call Unit(this).Abilities.RemoveBySelf(thistype.DECREASING_SPELLS_ID[packetLevel])
                            endif

                            set packetLevel = packetLevel - 1
                        endloop
                    else
                        set amount2 = amount
                        set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), INCREASING_SPELLS_MAX)

                        loop
                            exitwhen (packetLevel < ARRAY_MIN)

                            set packet = PACKETS[packetLevel]

                            if (packet <= amount2) then
                                call Unit(this).Abilities.AddBySelf(thistype.INCREASING_SPELLS_ID[packetLevel])
                                set amount2 = amount2 - packet
                            else
                                call Unit(this).Abilities.RemoveBySelf(thistype.INCREASING_SPELLS_ID[packetLevel])
                            endif

                            set packetLevel = packetLevel - 1
                        endloop
                    endif
                endif

                call Unit(this).$name$.AddBonuses(Real.ToInt(amount) - oldAmount, true)
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get() + value)
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            method Subtract takes real value returns nothing
                call this.Set(this.Get() - value)
            endmethod
        //! endtextmacro

        //! runtextmacro Folder("Level")
            //! runtextmacro Struct("Events")
                static Trigger DUMMY_TRIGGER
                static boolean IGNORE_NEXT = false
                static UnitList REG_GROUP

                static method TrigConds takes Unit parent returns boolean
                    if not thistype.REG_GROUP.Contains(parent) then
                        return false
                    endif

                    return true
                endmethod

                trigMethod Trig
                    local Unit parent = UNIT.Event.Native.GetTrigger()

                    if not thistype.TrigConds(parent) then
                        return
                    endif

                    if thistype.IGNORE_NEXT then
                        set thistype.IGNORE_NEXT = false

                        return
                    endif

                    call parent.Level.SetByEvent()
                endmethod

                method Event_Destroy takes nothing returns nothing
                    if not thistype.REG_GROUP.Contains(this) then
                        return
                    endif

                    call thistype.REG_GROUP.Remove(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.REG_GROUP.Add(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                    set thistype.REG_GROUP = UnitList.Create()

                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_HERO_LEVEL, null)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Level")
            static integer array EXP_MIN

            //! runtextmacro LinkToStruct("Level", "Events")

            //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

            method GetHeroLvl takes nothing returns integer
                return GetHeroLevel(Unit(this).self)
            endmethod

            method AddBonuses takes integer oldValue, integer value returns nothing
                local UnitType thisType = Unit(this).Type.Get()

                call Unit(this).Exp.Set(thistype.EXP_MIN[ARRAY_MIN + value])

                set value = value - oldValue

				call Unit(this).Scale.Add(value * thistype.SCALE_PER_LEVEL)
                call Unit(this).Agility.Base.Add(value * thisType.Hero.Agility.PerLevel.Get())
                call Unit(this).Armor.Base.Add(value * thisType.Hero.ArmorPerLevel.Get())
                call Unit(this).Intelligence.Base.Add(value * thisType.Hero.Intelligence.PerLevel.Get())
                call Unit(this).SkillPoints.Add(value)
                call Unit(this).Strength.Base.Add(value * thisType.Hero.Strength.PerLevel.Get())
            endmethod

            method SetByEvent takes nothing returns nothing
                local integer oldValue = this.Get()
                local integer value = this.GetHeroLvl()

                set this.value = value

                call UnitModifySkillPoints(Unit(this).self, oldValue - value)

                if (value == 0) then
                    return
                endif

                call this.AddBonuses(oldValue, value)
            endmethod

            method Set takes integer value returns nothing
                local integer oldValue = this.Get()

                if (value != oldValue) then
                    call SetHeroLevel(Unit(this).self, value, true)
                endif
            endmethod

            method SetNoArt takes integer value returns nothing
                local integer oldValue = this.Get()

                if (value != oldValue) then
                    call SetHeroLevel(Unit(this).self, value, false)
                endif
            endmethod

            method Add takes integer value returns nothing
                call this.Set(this.Get() + value)
            endmethod

            method Event_Create takes nothing returns nothing
                local integer value = this.GetHeroLvl()

                call Unit(this).SkillPoints.Set(1)

                set this.value = value
                call this.AddBonuses(1, value)

                call this.Events.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                set thistype.EXP_MIN[ARRAY_MIN + 1] = 0
                set thistype.EXP_MIN[ARRAY_MIN + 2] = 150
                set thistype.EXP_MIN[ARRAY_MIN + 3] = 400
                set thistype.EXP_MIN[ARRAY_MIN + 4] = 750
                set thistype.EXP_MIN[ARRAY_MIN + 5] = 1200
                set thistype.EXP_MIN[ARRAY_MIN + 6] = 1750
                set thistype.EXP_MIN[ARRAY_MIN + 7] = 2400
                set thistype.EXP_MIN[ARRAY_MIN + 8] = 3150
                set thistype.EXP_MIN[ARRAY_MIN + 9] = 4000
                set thistype.EXP_MIN[ARRAY_MIN + 10] = 4950
                set thistype.EXP_MIN[ARRAY_MIN + 11] = 6000
                set thistype.EXP_MIN[ARRAY_MIN + 12] = 7150
                set thistype.EXP_MIN[ARRAY_MIN + 13] = 8400
                set thistype.EXP_MIN[ARRAY_MIN + 14] = 9750
                set thistype.EXP_MIN[ARRAY_MIN + 15] = 11200
                set thistype.EXP_MIN[ARRAY_MIN + 16] = 12750
                set thistype.EXP_MIN[ARRAY_MIN + 17] = 14400
                set thistype.EXP_MIN[ARRAY_MIN + 18] = 16150
                set thistype.EXP_MIN[ARRAY_MIN + 19] = 18000
                set thistype.EXP_MIN[ARRAY_MIN + 20] = 19950

                call thistype(NULL).Events.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Agility")
            //! runtextmacro Struct("Base")
                static constant integer ATTRIBUTE_AGILITY = 1

                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method AddBonuses takes real amount returns nothing
                    if (Unit(this).Type.Get().Hero.PrimaryAttribute.Get() == thistype.ATTRIBUTE_AGILITY) then
                        set amount = PRIMARY_ATTRIBUTE_FACTOR * amount
                    endif

                    call Unit(this).Attack.Speed.BaseA.Add(amount * UNIT.Agility.ATTACK_SPEED_BONUS)
                    //call Unit(this).CriticalChance.Base.Add(amount * UNIT.Agility.CRITICAL_BONUS)
                    //call Unit(this).EvasionChance.Base.Add(amount * UNIT.Agility.EVASION_BONUS)
                    call Unit(this).MaxRage.Base.Add(amount * UNIT.Agility.RAGE_BONUS)
                endmethod

                method Set takes real value returns nothing
                    local integer oldValueI = Real.ToInt(this.Get())

                    local integer valueI = Real.ToInt(value)

                    set this.value = value

                    call SetHeroAgi(Unit(this).self, valueI, true)
                    call this.AddBonuses(valueI - oldValueI)

                    call Unit(this).Agility.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                eventMethod Event_TypeChange
                    local UnitType sourceType = params.UnitType.GetSource()
                    local UnitType targetType = params.UnitType.GetTrigger()
                    local thistype this = params.Unit.GetTrigger()

                    call this.Add(targetType.Hero.Agility.Get() - sourceType.Hero.Agility.Get())
                endmethod

                method Event_Create takes nothing returns nothing
                    local real value = Unit(this).Type.Get().Hero.Agility.Get()

                    local integer valueI = Real.ToInt(value)

                    set this.value = value

                    call SetHeroAgi(Unit(this).self, valueI, true)
                    call this.AddBonuses(valueI)
                endmethod

                static method Init takes nothing returns nothing
                    call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
                endmethod
            endstruct

            //! runtextmacro Folder("Bonus")
                //! runtextmacro Struct("Displayed")
                    static constant integer ATTRIBUTE_AGILITY = 1

                    method AddBonuses takes real amount returns nothing
                        if (Unit(this).Type.Get().Hero.PrimaryAttribute.Get() == thistype.ATTRIBUTE_AGILITY) then
                            set amount = PRIMARY_ATTRIBUTE_FACTOR * amount
                        endif

                        call Unit(this).Attack.Speed.BonusA.AddOnlySave(amount * UNIT.Agility.ATTACK_SPEED_BONUS)
                        //call Unit(this).CriticalChance.Bonus.Add(amount * UNIT.Agility.CRITICAL_BONUS)
                        //call Unit(this).EvasionChance.Bonus.Add(amount * UNIT.Agility.EVASION_BONUS)
                        call Unit(this).MaxRage.Bonus.Add(amount * UNIT.Agility.RAGE_BONUS)
                    endmethod

					//! runtextmacro Unit_CreateStateWithPermanentAbilities("Hero.Agility.BonusA", "true")

                    method Set takes real value returns nothing
                    	local integer oldValueI = Real.ToInt(this.Get())

                    	local integer valueI = Real.ToInt(value)

                        call this.SetDisplay(value)

						call this.AddBonuses(valueI - oldValueI)
                    endmethod

                    method Update takes nothing returns nothing
                        call this.Set(Unit(this).Agility.Base.Get() * (Unit(this).Agility.Relative.Get() - 1) + Unit(this).Agility.Bonus.Get())
                    endmethod

	                static method Init takes nothing returns nothing
	                    static if thistype.WAIT_FOR_SELECTION then
	                        set thistype.SELECTION_EVENT = Event.Create(UNIT.Selection.START_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Selection)
	                    endif
	                endmethod
                endstruct
            endscope

            //! runtextmacro Struct("Bonus")
                //! runtextmacro LinkToStruct("Bonus", "Displayed")

                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    call Unit(this).Agility.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                method Event_Create takes nothing returns nothing
                    set this.value = 0.

                    call this.Displayed.Event_Create()
                endmethod

				static method Init takes nothing returns nothing
					call thistype(NULL).Displayed.Init()
				endmethod
            endstruct

            //! runtextmacro Struct("Relative")
            	static UnitState STATE

                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    call Unit(this).Agility.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

	            eventMethod Event_State
	                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
	            endmethod

                method Event_Create takes nothing returns nothing
                    set this.value = 1.
                endmethod

	            static method Init takes nothing returns nothing
	                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
	            endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Agility")
            //! runtextmacro LinkToStruct("Agility", "Base")
            //! runtextmacro LinkToStruct("Agility", "Bonus")
            //! runtextmacro LinkToStruct("Agility", "Relative")

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

				call this.Bonus.Displayed.Update()
            endmethod

            method Update takes nothing returns nothing
                call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.

                call this.Base.Event_Create()
                call this.Bonus.Event_Create()
                call this.Relative.Event_Create()

                call this.Base.Update()
                call this.Bonus.Displayed.Update()

                call this.Update()
            endmethod

            static method Init takes nothing returns nothing
                call thistype(NULL).Base.Init()
                call thistype(NULL).Bonus.Init()
                call thistype(NULL).Relative.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Intelligence")
            //! runtextmacro Struct("Base")
                static constant integer ATTRIBUTE_INTELLIGENCE = 2

                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method AddBonuses takes real amount returns nothing
                    if (Unit(this).Type.Get().Hero.PrimaryAttribute.Get() == thistype.ATTRIBUTE_INTELLIGENCE) then
                        set amount = PRIMARY_ATTRIBUTE_FACTOR * amount
                    endif

                    call Unit(this).ManaRegeneration.Base.Add(amount * UNIT.Intelligence.MANA_REGEN_BONUS)
                    call Unit(this).MaxMana.Base.Add(amount * UNIT.Intelligence.MAX_MANA_BONUS)
                    call Unit(this).SpellPower.Base.Add(amount * UNIT.Intelligence.SPELL_POWER_BONUS)
                endmethod

                method Set takes real value returns nothing
                    local integer oldValueI = Real.ToInt(this.Get())

                    local integer valueI = Real.ToInt(value)

                    set this.value = value

                    call SetHeroInt(Unit(this).self, valueI, true)
                    call this.AddBonuses(valueI - oldValueI)

                    call Unit(this).Intelligence.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                eventMethod Event_TypeChange
                    local UnitType sourceType = params.UnitType.GetSource()
                    local UnitType targetType = params.UnitType.GetTrigger()
                    local thistype this = params.Unit.GetTrigger()

                    call this.Add(targetType.Hero.Intelligence.Get() - sourceType.Hero.Intelligence.Get())
                endmethod

                method Event_Create takes nothing returns nothing
                    local real value = Unit(this).Type.Get().Hero.Intelligence.Get()

                    local integer valueI = Real.ToInt(value)

                    set this.value = value

                    call SetHeroInt(Unit(this).self, valueI, true)
                    call this.AddBonuses(valueI)
                endmethod

                static method Init takes nothing returns nothing
                    call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
                endmethod
            endstruct

            //! runtextmacro Folder("Bonus")
                //! runtextmacro Struct("Displayed")
                    static constant integer ATTRIBUTE_INTELLIGENCE = 2

                    method AddBonuses takes real amount returns nothing
                        if (Unit(this).Type.Get().Hero.PrimaryAttribute.Get() == thistype.ATTRIBUTE_INTELLIGENCE) then
                            set amount = PRIMARY_ATTRIBUTE_FACTOR * amount
                        endif

                        call Unit(this).ManaRegeneration.Bonus.Add(amount * UNIT.Intelligence.MANA_REGEN_BONUS)
                        call Unit(this).MaxMana.Bonus.Add(amount * UNIT.Intelligence.MAX_MANA_BONUS)
                        call Unit(this).SpellPower.Bonus.Add(amount * UNIT.Intelligence.SPELL_POWER_BONUS)
                    endmethod

					//! runtextmacro Unit_CreateStateWithPermanentAbilities("Hero.Intelligence.BonusA", "true")

                    method Set takes real value returns nothing
                    	local integer oldValueI = Real.ToInt(this.Get())

                    	local integer valueI = Real.ToInt(value)

                        call this.SetDisplay(value)

						call this.AddBonuses(valueI - oldValueI)
                    endmethod

                    method Update takes nothing returns nothing
                        call this.Set(Unit(this).Intelligence.Base.Get() * (Unit(this).Intelligence.Relative.Get() - 1) + Unit(this).Intelligence.Bonus.Get())
                    endmethod

	                static method Init takes nothing returns nothing
	                    static if thistype.WAIT_FOR_SELECTION then
	                        set thistype.SELECTION_EVENT = Event.Create(UNIT.Selection.START_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Selection)
	                    endif
	                endmethod
                endstruct
            endscope

            //! runtextmacro Struct("Bonus")
                //! runtextmacro LinkToStruct("Bonus", "Displayed")

                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    call Unit(this).Intelligence.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                method Event_Create takes nothing returns nothing
                    set this.value = 0.

                    call this.Displayed.Event_Create()
                endmethod

				static method Init takes nothing returns nothing
					call thistype(NULL).Displayed.Init()
				endmethod
            endstruct

            //! runtextmacro Struct("Relative")
            	static UnitState STATE

                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    call Unit(this).Intelligence.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

	            eventMethod Event_State
	                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
	            endmethod

                method Event_Create takes nothing returns nothing
                    set this.value = 1.
                endmethod

	            static method Init takes nothing returns nothing
	                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
	            endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Intelligence")
            //! runtextmacro LinkToStruct("Intelligence", "Base")
            //! runtextmacro LinkToStruct("Intelligence", "Bonus")
            //! runtextmacro LinkToStruct("Intelligence", "Relative")

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

				call this.Bonus.Displayed.Update()
            endmethod

            method Update takes nothing returns nothing
                call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.

                call this.Base.Event_Create()
                call this.Bonus.Event_Create()
                call this.Relative.Event_Create()

                call this.Base.Update()
                call this.Bonus.Displayed.Update()

                call this.Update()
            endmethod

            static method Init takes nothing returns nothing
                call thistype(NULL).Base.Init()
                call thistype(NULL).Bonus.Init()
                call thistype(NULL).Relative.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Strength")
            //! runtextmacro Struct("Base")
                static constant integer ATTRIBUTE_STRENGTH = 3

                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method AddBonuses takes real amount returns nothing
                    if (Unit(this).Type.Get().Hero.PrimaryAttribute.Get() == thistype.ATTRIBUTE_STRENGTH) then
                        set amount = PRIMARY_ATTRIBUTE_FACTOR * amount
                    endif

                    call Unit(this).Damage.Base.Add(amount * UNIT.Strength.DAMAGE_BONUS)
                    call Unit(this).LifeRegeneration.Base.Add(amount * UNIT.Strength.LIFE_REGEN_BONUS)
                    call Unit(this).MaxLife.Base.Add(amount * UNIT.Strength.MAX_LIFE_BONUS)
                endmethod

                method Set takes real value returns nothing
                    local integer oldValueI = Real.ToInt(this.Get())

                    local integer valueI = Real.ToInt(value)

                    set this.value = value

                    call SetHeroStr(Unit(this).self, valueI, true)
                    call this.AddBonuses(valueI - oldValueI)

                    call Unit(this).Strength.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                eventMethod Event_TypeChange
                    local UnitType sourceType = params.UnitType.GetSource()
                    local UnitType targetType = params.UnitType.GetTrigger()
                    local thistype this = params.Unit.GetTrigger()

                    call this.Add(targetType.Hero.Strength.Get() - sourceType.Hero.Strength.Get())
                endmethod

                method Event_Create takes nothing returns nothing
                    local real value = Unit(this).Type.Get().Hero.Strength.Get()

                    local integer valueI = Real.ToInt(value)

                    set this.value = value

                    call SetHeroStr(Unit(this).self, valueI, true)
                    call this.AddBonuses(valueI)
                endmethod

                static method Init takes nothing returns nothing
                    call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
                endmethod
            endstruct

            //! runtextmacro Folder("Bonus")
                //! runtextmacro Struct("Displayed")
                    static constant integer ATTRIBUTE_STRENGTH = 3

                    method AddBonuses takes real amount returns nothing
                        if (Unit(this).Type.Get().Hero.PrimaryAttribute.Get() == thistype.ATTRIBUTE_STRENGTH) then
                            set amount = PRIMARY_ATTRIBUTE_FACTOR * amount
                        endif

                        call Unit(this).Damage.Bonus.Add(amount * UNIT.Strength.DAMAGE_BONUS)
                        call Unit(this).LifeRegeneration.Bonus.Add(amount * UNIT.Strength.LIFE_REGEN_BONUS)
                        call Unit(this).MaxLife.Bonus.Add(amount * UNIT.Strength.MAX_LIFE_BONUS)
                    endmethod

					//! runtextmacro Unit_CreateStateWithPermanentAbilities("Hero.Strength.BonusA", "true")

                    method Set takes real value returns nothing
                    	local integer oldValueI = Real.ToInt(this.Get())

                    	local integer valueI = Real.ToInt(value)

                        call this.SetDisplay(value)

						call this.AddBonuses(valueI - oldValueI)
                    endmethod

                    method Update takes nothing returns nothing
                        call this.Set(Unit(this).Strength.Base.Get() * (Unit(this).Strength.Relative.Get() - 1) + Unit(this).Strength.Bonus.Get())
                    endmethod

	                static method Init takes nothing returns nothing
	                    static if thistype.WAIT_FOR_SELECTION then
	                        set thistype.SELECTION_EVENT = Event.Create(UNIT.Selection.START_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Selection)
	                    endif
	                endmethod
                endstruct
            endscope

            //! runtextmacro Struct("Bonus")
                //! runtextmacro LinkToStruct("Bonus", "Displayed")

                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    call Unit(this).Strength.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                method Event_Create takes nothing returns nothing
                    set this.value = 0.

                    call this.Displayed.Event_Create()
                endmethod

				static method Init takes nothing returns nothing
					call thistype(NULL).Displayed.Init()
				endmethod
            endstruct

            //! runtextmacro Struct("Relative")
            	static UnitState STATE

                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    call Unit(this).Strength.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

	            eventMethod Event_State
	                call thistype(params.Unit.GetTrigger()).Add(params.Real.GetVal())
	            endmethod

                method Event_Create takes nothing returns nothing
                    set this.value = 1.
                endmethod

	            static method Init takes nothing returns nothing
	                set thistype.STATE = UnitState.Create(thistype.NAME, function thistype.Event_State)
	            endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Strength")
            //! runtextmacro LinkToStruct("Strength", "Base")
            //! runtextmacro LinkToStruct("Strength", "Bonus")
            //! runtextmacro LinkToStruct("Strength", "Relative")

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

				call this.Bonus.Displayed.Update()
            endmethod

            method Update takes nothing returns nothing
                call this.Set(this.Base.Get() * this.Relative.Get() + this.Bonus.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.

                call this.Base.Event_Create()
                call this.Bonus.Event_Create()
                call this.Relative.Event_Create()

                call this.Base.Update()
                call this.Bonus.Displayed.Update()

                call this.Update()
            endmethod

            static method Init takes nothing returns nothing
                call thistype(NULL).Base.Init()
                call thistype(NULL).Bonus.Init()
                call thistype(NULL).Relative.Init()
            endmethod
        endstruct
    //endscope

    //! runtextmacro Struct("Refs")
        boolean waiting

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method CheckForDestroy takes nothing returns boolean
            if (this.Get() > 0) then
                set this.waiting = true

                return false
            endif

            return true
        endmethod

        method Subtract takes nothing returns nothing
            local integer value = this.Get() - 1

            set this.value = value

            if ((value == 0) and this.waiting) then
                call Unit(this).Destroy()
            endif
        endmethod

        method Add takes nothing returns nothing
            set this.value = this.Get() + 1
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0
            set this.waiting = false
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Unit", "UNIT")
    static EventType CREATE_EVENT_TYPE
    static Trigger CREATE_EXECUTE_TRIGGER
    static Trigger CREATE_FROM_SELF_EXECUTE_TRIGGER
    static boolean CREATE_TRIGGER_EVENTS = true
    static EventType DESTROY_EVENT_TYPE
    static Trigger DESTROY_EXECUTE_TRIGGER
    static BoolExpr ENUM_OF_TYPE_FILTER
    static EventType HEALED_EVENT_TYPE
    //! runtextmacro GetKey("KEY")
    static constant string SUMMON_EFFECT_PATH = "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl"
    static thistype TEMP
    static thistype TEMP2
    static thistype array TEMPS

    static thistype ARURUW
    static thistype DRAKUL
    static thistype JOTA
    static thistype KERA
    static thistype LIZZY
    static thistype ROCKETEYE
    static thistype SMOKEALOT
    static thistype STORMY
    static thistype TAJRAN

    boolean destroyed
    unit self

    //! runtextmacro LinkToStruct("Unit", "Abilities")
    //! runtextmacro LinkToStruct("Unit", "Animation")
    //! runtextmacro LinkToStruct("Unit", "Armor")
    //! runtextmacro LinkToStruct("Unit", "Attachments")
    //! runtextmacro LinkToStruct("Unit", "Attack")
    //! runtextmacro LinkToStruct("Unit", "Banish")
    //! runtextmacro LinkToStruct("Unit", "Bars")
    //! runtextmacro LinkToStruct("Unit", "Bleeding")
    //! runtextmacro LinkToStruct("Unit", "Blood")
    //! runtextmacro LinkToStruct("Unit", "BloodExplosion")
    //! runtextmacro LinkToStruct("Unit", "Buffs")
    //! runtextmacro LinkToStruct("Unit", "Classes")
    //! runtextmacro LinkToStruct("Unit", "Cold")
    //! runtextmacro LinkToStruct("Unit", "CollisionSize")
    //! runtextmacro LinkToStruct("Unit", "Color")
    //! runtextmacro LinkToStruct("Unit", "CriticalChance")
    //! runtextmacro LinkToStruct("Unit", "CriticalChanceDefense")
    //! runtextmacro LinkToStruct("Unit", "Damage")
    //! runtextmacro LinkToStruct("Unit", "Data")
    //! runtextmacro LinkToStruct("Unit", "Death")
    //! runtextmacro LinkToStruct("Unit", "Decay")
    //! runtextmacro LinkToStruct("Unit", "Display")
    //! runtextmacro LinkToStruct("Unit", "Drop")
    //! runtextmacro LinkToStruct("Unit", "Effects")
    //! runtextmacro LinkToStruct("Unit", "Eclipse")
    //! runtextmacro LinkToStruct("Unit", "Evasion")
    //! runtextmacro LinkToStruct("Unit", "EvasionChance")
    //! runtextmacro LinkToStruct("Unit", "EvasionChanceDefense")
    //! runtextmacro LinkToStruct("Unit", "Event")
    //! runtextmacro LinkToStruct("Unit", "Facing")
    //! runtextmacro LinkToStruct("Unit", "Frost")
    //! runtextmacro LinkToStruct("Unit", "Ghost")
    //! runtextmacro LinkToStruct("Unit", "HealAbility")
    //! runtextmacro LinkToStruct("Unit", "Id")
    //! runtextmacro LinkToStruct("Unit", "Impact")
    //! runtextmacro LinkToStruct("Unit", "Ignited")
    //! runtextmacro LinkToStruct("Unit", "Invisibility")
    //! runtextmacro LinkToStruct("Unit", "Invulnerability")
    //! runtextmacro LinkToStruct("Unit", "Items")
    //! runtextmacro LinkToStruct("Unit", "Knockup")
    //! runtextmacro LinkToStruct("Unit", "Life")
    //! runtextmacro LinkToStruct("Unit", "LifeLeech")
    //! runtextmacro LinkToStruct("Unit", "LifeRegeneration")
    //! runtextmacro LinkToStruct("Unit", "Madness")
    //! runtextmacro LinkToStruct("Unit", "MagicImmunity")
    //! runtextmacro LinkToStruct("Unit", "Mana")
    //! runtextmacro LinkToStruct("Unit", "ManaLeech")
    //! runtextmacro LinkToStruct("Unit", "ManaRegeneration")
    //! runtextmacro LinkToStruct("Unit", "MaxLife")
    //! runtextmacro LinkToStruct("Unit", "MaxMana")
    //! runtextmacro LinkToStruct("Unit", "MaxRage")
    //! runtextmacro LinkToStruct("Unit", "MaxStamina")
    //! runtextmacro LinkToStruct("Unit", "ModSets")
    //! runtextmacro LinkToStruct("Unit", "Movement")
    //! runtextmacro LinkToStruct("Unit", "Outpact")
    //! runtextmacro LinkToStruct("Unit", "Order")
    //! runtextmacro LinkToStruct("Unit", "Owner")
    //! runtextmacro LinkToStruct("Unit", "Pathing")
    //! runtextmacro LinkToStruct("Unit", "Poisoned")
    //! runtextmacro LinkToStruct("Unit", "Position")
    //! runtextmacro LinkToStruct("Unit", "Rage")
    //! runtextmacro LinkToStruct("Unit", "RageRegeneration")
    //! runtextmacro LinkToStruct("Unit", "Refs")
    //! runtextmacro LinkToStruct("Unit", "Revival")
    //! runtextmacro LinkToStruct("Unit", "Scale")
    //! runtextmacro LinkToStruct("Unit", "Selection")
    //! runtextmacro LinkToStruct("Unit", "SightRange")
    //! runtextmacro LinkToStruct("Unit", "Silence")
    //! runtextmacro LinkToStruct("Unit", "SkillPoints")
    //! runtextmacro LinkToStruct("Unit", "Sleep")
	//! runtextmacro LinkToStruct("Unit", "Sounds")
    //! runtextmacro LinkToStruct("Unit", "SpellPower")
    //! runtextmacro LinkToStruct("Unit", "SpellVamp")
    //! runtextmacro LinkToStruct("Unit", "Stamina")
    //! runtextmacro LinkToStruct("Unit", "StaminaRegeneration")
    //! runtextmacro LinkToStruct("Unit", "Stun")
    //! runtextmacro LinkToStruct("Unit", "TimedLife")
    //! runtextmacro LinkToStruct("Unit", "Transport")
    //! runtextmacro LinkToStruct("Unit", "Type")
    //! runtextmacro LinkToStruct("Unit", "VertexColor")
	//! runtextmacro LinkToStruct("Unit", "Whirl")

    //Hero
    //! runtextmacro LinkToStruct("Unit", "Exp")
    //! runtextmacro LinkToStruct("Unit", "Hero")
    //! runtextmacro LinkToStruct("Unit", "Agility")
    //! runtextmacro LinkToStruct("Unit", "Level")
    //! runtextmacro LinkToStruct("Unit", "Intelligence")
    //! runtextmacro LinkToStruct("Unit", "Strength")

    static method GetFromId takes integer id returns thistype
        return thistype(NULL).Id.GetParent(id)
    endmethod

    static method GetFromSelf takes unit self returns thistype
        return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
    endmethod

    static method GetFromSelfSecured takes unit self returns thistype
        if (self == null) then
            return NULL
        endif

        return thistype.GetFromSelf(self)
    endmethod

    method GetName takes nothing returns string
        return GetUnitName(this.self)
    endmethod

    method GetNameEx takes nothing returns string
        return (GetUnitName(this.self) + "(" + I2S(this) + ")")
    endmethod

    method GetProperName takes nothing returns string
        return GetHeroProperName(this.self)
    endmethod

    method GetSelf takes nothing returns unit
        return this.self
    endmethod

    method CastAngle takes real dX, real dY returns real
        if (Math.DistanceSquareByDeltas(dX, dY) < 1.) then
            return this.Facing.Get()
        endif

        return Math.AtanByDeltas(dY, dX)
    endmethod

    method IsAllyOf takes User whichPlayer returns boolean
        return IsUnitAlly(this.self, whichPlayer.self)
    endmethod

    method IsDestroyed takes nothing returns boolean
        return this.destroyed
    endmethod

    method IsEnemyOf takes User whichPlayer returns boolean
        return IsUnitEnemy(this.self, whichPlayer.self)
    endmethod

    method IsSelected takes User whichPlayer returns boolean
        return IsUnitSelected(this.self, whichPlayer.self)
    endmethod

    method Destroy_TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

        call params.Unit.SetTrigger(this)

		local EventResponse unitParams = EventResponse.Create(this.Id.Get())

        call unitParams.Unit.SetTrigger(this)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = Event.CountAtStatics(thistype.DESTROY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.GetFromStatics(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration2 = this.Event.Count(thistype.DESTROY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run(unitParams)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
        call unitParams.Destroy()

        call this.Abilities.Events.Event_Destroy()
        call this.Attack.Events.Event_Destroy()
        call this.Death.Event_Destroy()
        call this.Decay.Events.Event_Destroy()
        call this.Items.Events.Event_Destroy()
        call this.Level.Events.Event_Destroy()
    endmethod

	destroyMethod Destroy [autoExec]
        local unit self = this.self

        call UnitList.WORLD.Remove(this)

        call this.Abilities.Clear()

        call this.Destroy_TriggerEvents()

        call Memory.IntegerKeys.RemoveIntegerByHandle(self, KEY)
        call RemoveUnit(self)

        set self = null
	endmethod

    execMethod Destroy_Executed
        local thistype this = thistype.TEMP

        if this.destroyed then
            return
        endif

        local unit self = this.self

        set this.destroyed = true
        call UnitList.WORLD.Remove(this)

        call this.Abilities.Clear()

        call this.Destroy_TriggerEvents()

        if not this.Refs.CheckForDestroy() then
            call ShowUnit(this.self, false)

            return
        endif

        call this.deallocate()
        call Memory.IntegerKeys.RemoveIntegerByHandle(self, KEY)
        call RemoveUnit(self)

        set self = null
    endmethod

    method Destroy2 takes nothing returns nothing
        set thistype.TEMP = this

        call thistype.DESTROY_EXECUTE_TRIGGER.Run()
    endmethod

    method AddJumpingTextTag takes string text, real fontSize, integer id returns TextTag
        local real x = this.Position.X.Get()
        local real y = this.Position.Y.Get()

        return TEXT_TAG.CreateJumping.Create(text, fontSize, x, y, this.Position.Z.GetByCoords(x, y) + this.Outpact.Z.Get(true), id)
    endmethod

    method AddJumpingTextTagEx2 takes string text, real fontSize, integer id, boolean vertical, real offsetX, real offsetY returns TextTag
        local real x = this.Position.X.Get() + offsetX
        local real y = this.Position.Y.Get() + offsetY

        local real z = this.Position.Z.GetByCoords(x, y)

        if vertical then
            set text = String.Reconcat(text, Char.BREAK)
        endif

        return TEXT_TAG.CreateJumping.Create(text, fontSize, x, y, z, id)
    endmethod

    method AddJumpingTextTagEx takes string text, real fontSize, integer id, boolean useOutpact, boolean useScale returns TextTag
        local real x = this.Position.X.Get()
        local real y = this.Position.Y.Get()

        local real z = this.Position.Z.GetByCoords(x, y)

        if useOutpact then
            set z = z + this.Outpact.Z.Get(useScale)
        endif
        if useScale then
            set fontSize = fontSize * this.Scale.Get()
        endif

        return TEXT_TAG.CreateJumping.Create(text, fontSize, x, y, z, id)
    endmethod

    method AddMovingTextTag takes string text, real fontSize, real speedX, real speedY, real speedZ, real fadePoint, real duration, integer id returns TextTag
        local real x = this.Position.X.Get()
        local real y = this.Position.Y.Get()

        return TEXT_TAG.CreateMoving.Create(text, fontSize, x, y, this.Position.Z.GetByCoords(x, y) + this.Outpact.Z.Get(true), speedX, speedY, speedZ, fadePoint, duration, id)
    endmethod

    method AddRisingTextTag takes string text, real fontSize, real speedZ, real fadePoint, real duration, integer id returns TextTag
        local real x = this.Position.X.Get()
        local real y = this.Position.Y.Get()

        return TEXT_TAG.CreateRising.Create(text, fontSize, x, y, this.Position.Z.GetByCoords(x, y) + this.Outpact.Z.Get(true), speedZ, fadePoint, duration, id)
    endmethod

    method ReplaceRisingTextTagIfMinorValue takes string text, real fontSize, real speedZ, real fadePoint, real duration, integer id, real value returns TextTag
        local TextTag old = TextTag.GetFromId(id)

        if ((old == NULL) or (old.GetValue() < value)) then
            if (old != NULL) then
                call old.Destroy()
            endif

            set old = this.AddRisingTextTag(text, fontSize, speedZ, fadePoint, duration, id)

            call old.SetValue(value)
        endif

        return old
    endmethod

    //! runtextmacro GetKeyArray("SPELL_TEXT_TAG_KEY_ARRAY")

    method CreateSpellTextTag takes Unit target, boolean magical, real val, boolean crit returns nothing
        if (val <= 0.) then
            return
        endif

        if magical then
            call target.ReplaceRisingTextTagIfMinorValue(String.Color.Gradient("~" + Real.ToIntString(val) + String.If(crit, Char.EXCLAMATION_MARK) + "~", Unit(this).Owner.Get().GetColorString(), String.Color.MAGENTA), Math.Linear(val, target.MaxLife.Get() / 2., 0.016, 0.022), 160., 0., 1., thistype.SPELL_TEXT_TAG_KEY_ARRAY + target, val / 2)
        else
            call target.ReplaceRisingTextTagIfMinorValue(String.Color.Do(Real.ToIntString(val) + String.If(crit, Char.EXCLAMATION_MARK), Unit(this).Owner.Get().GetColorString()), Math.Linear(val, target.MaxLife.Get() / 2., 0.016, 0.022), 160., 0., 1., thistype.SPELL_TEXT_TAG_KEY_ARRAY + target, val / 2)
        endif
    endmethod

    method AddStateB takes UnitState whichState, boolean val returns nothing
        call whichState.RunB(this, val)
    endmethod

    method SubtractStateB takes UnitState whichState, boolean val returns nothing
        call this.AddStateB(whichState, not val)
    endmethod

    method AddState takes UnitState whichState, real value returns nothing
        call whichState.Run(this, value)
    endmethod

    method SubtractState takes UnitState whichState, real value returns nothing
        call this.AddState(whichState, -value)
    endmethod

    method ChangeType takes UnitType targetType returns nothing
        call this.Type.Set(targetType)
    endmethod

    method DamageUnit takes Unit target, real amount, boolean triggerEvents returns real
        return this.Damage.Do(target, amount, triggerEvents)
    endmethod

    static method EnumOfType_Conditions takes nothing returns boolean
        if (UNIT.Event.Native.GetFilter().Type.Get() != UnitType.TEMP) then
            return false
        endif

        return true
    endmethod

    static method EnumOfType takes UnitType whichType, code action returns nothing
        local Group dummyGroup = Group.Create()

        set UnitType.TEMP = whichType

        call dummyGroup.EnumUnits.InRect.Do(Rectangle.WORLD, thistype.ENUM_OF_TYPE_FILTER)

        call dummyGroup.Do(action)

        call dummyGroup.Destroy()
    endmethod

    method DamageUnitBySpell takes Unit target, real amount, boolean magical, boolean triggerEvents returns real
        return this.Damage.DoBySpell(target, amount, magical, triggerEvents)
    endmethod

    method HealBySpell_TriggerEvents takes Unit target, real amount returns nothing
        local EventResponse targetParams = EventResponse.Create(target.Id.Get())

        call targetParams.Real.SetHealedAmount(amount)
        call targetParams.Unit.SetTrigger(target)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = target.Event.Count(thistype.HEALED_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call target.Event.Get(thistype.HEALED_EVENT_TYPE, priority, iteration2).Run(targetParams)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call targetParams.Destroy()
    endmethod

    method AddJumpingTextTagWithValue takes integer id, real value returns TextTag
        local TextTag old = TextTag.GetFromId(id)

        if (old == NULL) then
            set old = TEXT_TAG.CreateJumping.Create(null, 0.02, this.Position.X.Get(), this.Position.Y.Get(), this.Position.Z.Get() + this.Outpact.Z.Get(true), id)

            call old.SetValue(value)
        else
            call old.SetValue(old.GetValue() + value)
        endif

        return old
    endmethod

    //! runtextmacro GetKeyArray("HEAL_KEY_ARRAY")

    method HealBySpell takes Unit target, real amount returns nothing
        if (amount < 1.) then
            return
        endif

        set amount = amount * thistype(NULL).SpellPower.GetDamageFactor(-this.SpellPower.Get()) * target.HealAbility.Get() * Math.Random(0.9, 1.1)

        local TextTag tag = target.AddJumpingTextTagWithValue(HEAL_KEY_ARRAY + target, amount)

        call tag.Text.Set(String.Color.Do(Char.PLUS + Integer.ToString(Real.ToInt(tag.GetValue())), "ff00c800"), 0.02)

        call target.Life.Add(amount)

        call this.HealBySpell_TriggerEvents(target, amount)
    endmethod

    //! runtextmacro GetKeyArray("BURN_MANA_KEY_ARRAY")

    method BurnManaBySpell takes Unit target, real amount returns nothing
        local TextTag tag

        if (amount < 1.) then
            return
        endif

        set tag = target.AddJumpingTextTagWithValue(BURN_MANA_KEY_ARRAY + target, amount)

        call tag.Text.Set(String.Color.Do(Char.MINUS + Real.ToIntString(tag.GetValue()), "ffffff00"), 0.02)

        call target.Mana.Subtract(amount)
    endmethod

    //! runtextmacro GetKeyArray("HEAL_MANA_KEY_ARRAY")

    method HealManaBySpell takes Unit target, real amount returns nothing
        if (amount < 1.) then
            return
        endif

        local TextTag tag = target.AddJumpingTextTagWithValue(HEAL_MANA_KEY_ARRAY + target, amount)

        call tag.Text.Set(String.Color.Do(Char.PLUS + Integer.ToString(Real.ToInt(tag.GetValue())), "ffaa55ff"), 0.02)

        call target.Mana.Add(amount)
    endmethod

    //! runtextmacro GetKeyArray("HEAL_STAMINA_KEY_ARRAY")

    method HealStaminaBySpell takes Unit target, real amount returns nothing
        local TextTag tag

        if (amount < 1.) then
            return
        endif

        set tag = target.AddJumpingTextTagWithValue(HEAL_STAMINA_KEY_ARRAY + target, amount)

        call tag.Text.Set(String.Color.Do(Char.PLUS + Integer.ToString(Real.ToInt(tag.GetValue())), "ffffff00"), 0.02)

        call target.Stamina.Add(amount)
    endmethod

    method Kill takes nothing returns nothing
        call this.Death.Do(NULL)
    endmethod

    method KillBy takes Unit killer returns nothing
        call this.Death.Do(killer)
    endmethod

    method KillInstantly takes nothing returns nothing
        set thistype(NULL).Death.Events.NEXT_DECAYS_INSTANTLY = true

        call this.Kill()
    endmethod

    method ApplyTimedLife takes real duration returns nothing
        call this.TimedLife.Start(duration)
    endmethod

    method Flash takes integer red, integer green, integer blue, integer alpha returns nothing
        call AddIndicator(this.self, red, green, blue, alpha)
    endmethod

    method Revive takes nothing returns nothing
        if this.Classes.Contains(UnitClass.HERO) then
            call this.Hero.Revive(this.Position.X.Get(), this.Position.Y.Get())
        else
            call this.Revival.Do()
        endif
    endmethod

    method Select takes User whichPlayer, boolean flag returns nothing
        if whichPlayer.IsLocal() then
            call SelectUnit(this.self, flag)
        endif
    endmethod

    method SetSummon takes real duration returns nothing
        if (duration >= 0.) then
            call this.BloodExplosion.SetSummon(thistype.SUMMON_EFFECT_PATH)
            call this.Classes.Add(UnitClass.SUMMON)
            call this.Decay.Duration.Set(0.)

            call this.ApplyTimedLife(duration)
        endif
    endmethod

    method Ping takes boolean debugMsg returns nothing
        local real x = this.Position.X.Get()
        local real y = this.Position.Y.Get()

        if debugMsg then
            call InfoEx("ping unit " + this.GetName() + " at " + R2S(x) + ";" + R2S(y))
        endif
        call PingMinimapEx(x, y, 5, Math.RandomI(0, 255), Math.RandomI(0, 255), Math.RandomI(0, 255), true)
    endmethod

    method Whereabouts takes nothing returns nothing
        call InfoEx("whereabouts of " + this.GetName() + "(" + I2S(this) + ")")
        call InfoEx(Char.TAB + "position: " + R2S(this.Position.X.Get()) + ";" + R2S(this.Position.Y.Get()) + ";" + R2S(this.Position.Z.Get()))
        call InfoEx(Char.TAB + "scale: " + R2S(this.Scale.Get()))
        call InfoEx(Char.TAB + "vertex color: " + R2S(this.VertexColor.Red.Get()) + ";" + R2S(this.VertexColor.Green.Get()) + ";" + R2S(this.VertexColor.Blue.Get()) + ";" + R2S(this.VertexColor.Alpha.Get()))
        call this.Ping(false)
    endmethod

    method Stop takes nothing returns nothing
        local real angle = this.Facing.Get()

        if this.Order.PointTargetNoTrig(Order.MOVE, this.Position.X.Get() + 0.01 * Math.Cos(angle), this.Position.Y.Get() + 0.01 * Math.Sin(angle)) then
            return
        endif

        call this.Order.ImmediateNoTrig(Order.STOP)
    endmethod

    method Create_TriggerEvents takes nothing returns nothing
        local UnitType thisType = this.Type.Get()

        local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

        call params.Unit.SetTrigger(this)
        call params.UnitType.SetTrigger(thisType)

		local EventResponse unitParams = EventResponse.Create(this.Id.Get())

        call unitParams.Unit.SetTrigger(this)
        call unitParams.UnitType.SetTrigger(thisType)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = Event.CountAtStatics(thistype.CREATE_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.GetFromStatics(thistype.CREATE_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration2 = thisType.Event.Count(thistype.CREATE_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call thisType.Event.Get(thistype.CREATE_EVENT_TYPE, priority, iteration2).Run(unitParams)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
        call unitParams.Destroy()
    endmethod

    static method CreateBasic takes User owner, unit self returns thistype
    	local UnitType thisType = UnitType.GetFromSelf(GetUnitTypeId(self))

        local thistype this = thistype.GetFromSelf(self)

		local ObjThread thread = ObjThread.Create("Unit.CreateBasic: " + owner.GetName()+";"+GetUnitName(self)+";"+I2S(this)+";"+thisType.GetName())

        if (this != HASH_TABLE.Integer.DEFAULT_VALUE) then
            call DebugEx("Unit.CreateBasic: unit " + this.GetName() + " already registered")

            return this
        endif

        static if DEBUG then
            if (thisType == NULL) then
                call DebugEx("Unit.CreateBasic: null type")
                //call Game.DebugMsg("Unit.CreateBasic: NULL type ("+I2S(GetUnitTypeId(self))+";"+GetObjectName(GetUnitTypeId(self))+";"+GetUnitName(self) + ")")

                return NULL
            endif
        endif

call thread.AddMark("A")
        set this = thistype.allocate()

        set this.destroyed = false
        set this.self = self
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        call UnitList.WORLD.Add(this)

        call this.Id.Event_Create()

        call this.Refs.Event_Create()
call thread.AddMark("B")
        call this.Animation.Event_Create()
        call this.CriticalChance.Event_Create()
        call this.CriticalChanceDefense.Event_Create()
        call this.EvasionChance.Event_Create()
        call this.EvasionChanceDefense.Event_Create()
        call this.Exp.Event_Create()
        call this.Ghost.Event_Create()
        call this.HealAbility.Event_Create()
        call this.Invisibility.Event_Create()
        call this.Invulnerability.Event_Create()
        call this.LifeLeech.Event_Create()
        call this.Madness.Event_Create()
        call this.MagicImmunity.Event_Create()
        call this.ManaLeech.Event_Create()
        call this.Owner.Event_Create(owner)
        call this.Pathing.Event_Create()
        call this.Position.Event_Create()
        call this.Silence.Event_Create()
        call this.Stun.Event_Create()
        call this.Transport.Event_Create()
        call this.Type.Event_Create()

call thread.AddMark("C")
        call this.Abilities.Event_Create()
call thread.AddMark("C2")
        call this.Armor.Event_Create()
call thread.AddMark("C3")
        call this.Attachments.Event_Create()
call thread.AddMark("C4")
        call this.Attack.Event_Create()
call thread.AddMark("C5")
        call this.Blood.Event_Create()
call thread.AddMark("C6")
        call this.BloodExplosion.Event_Create()
call thread.AddMark("C7")
        call this.Classes.Event_Create()
call thread.AddMark("C8")
        call this.CollisionSize.Event_Create()
call thread.AddMark("C9")
        call this.Damage.Event_Create()
call thread.AddMark("C10")
        call this.Death.Event_Create() 
call thread.AddMark("C11")
        call this.Decay.Event_Create()
call thread.AddMark("C12")
        call this.Drop.Event_Create()
call thread.AddMark("C13")
        call this.Evasion.Event_Create()
call thread.AddMark("C14")
        call this.Impact.Event_Create()
call thread.AddMark("C15")
        call this.Revival.Event_Create()
call thread.AddMark("C16")
        call this.SightRange.Event_Create()
call thread.AddMark("C17")
        call this.SpellPower.Event_Create()
call thread.AddMark("C18")
        call this.SpellVamp.Event_Create()

call thread.AddMark("D")
        call this.LifeRegeneration.Event_Create()
        call this.ManaRegeneration.Event_Create()
        call this.MaxLife.Event_Create()
        call this.MaxMana.Event_Create()
        call this.Movement.Event_Create()
        call this.Outpact.Event_Create()
        call this.Scale.Event_Create()
        call this.VertexColor.Event_Create()

call thread.AddMark("E")
        call this.Banish.Event_Create()
        call this.Bleeding.Event_Create()
        call this.Cold.Event_Create()
        call this.Eclipse.Event_Create()
        call this.Ignited.Event_Create()
        call this.Poisoned.Event_Create()
        call this.Selection.Event_Create()
        call this.Whirl.Event_Create()

        local boolean isHero = this.Classes.Contains(UnitClass.HERO)

call thread.AddMark("F")
        if isHero then
			call this.Armor.Spell.Add(0.3)
call thread.AddMark("F1")
            call this.MaxStamina.Event_Create()
            call this.StaminaRegeneration.Event_Create()
call thread.AddMark("F2")
            call this.Agility.Event_Create()
            call this.Intelligence.Event_Create()
            call this.Strength.Event_Create()
call thread.AddMark("F3")
            call this.SkillPoints.Event_Create()
call thread.AddMark("F4")
            call this.Level.Event_Create()
call thread.AddMark("F5")
            call this.Stamina.Event_Create()
call thread.AddMark("F6")
            call this.Bars.Event_Create()
call thread.AddMark("F7")
        else
call thread.AddMark("F8")
            if not this.Classes.Contains(UnitClass.WARD) then
call thread.AddMark("F9")
                call this.Effects.Create("Units\\Aura.mdx", AttachPoint.ORIGIN, EffectLevel.NORMAL)
call thread.AddMark("F10")
                call this.Color.Update()
call thread.AddMark("F11")
            endif
        endif

call thread.AddMark("G")
        call this.Life.Event_Create()
        call this.Mana.Event_Create()
call thread.AddMark("H")
        call this.Items.Event_Create()
        call thread.AddMark("H2")
        call this.Order.Event_Create()
call thread.AddMark("I")

        if thistype.CREATE_TRIGGER_EVENTS then
            call this.Create_TriggerEvents()
        endif
call thread.AddMark("J")
        call thread.Destroy()

        return this
    endmethod

    execMethod CreateFromSelf_Executed
        set thistype.TEMP = thistype.CreateBasic(User.GetFromSelf(GetOwningPlayer(UNIT.self)), UNIT.self)
    endmethod

    static method CreateFromSelf takes unit self returns thistype
        set UNIT.self = self

        call thistype.CREATE_FROM_SELF_EXECUTE_TRIGGER.Run()

        if (thistype.TEMP == NULL) then
            call RemoveUnit(self)
        endif

        return thistype.TEMP
    endmethod

    execMethod Create_Executed
        set thistype.TEMP = thistype.CreateBasic(User.TEMP, CreateUnit(User.TEMP.self, UnitType.TEMP.self, TEMP_REAL, TEMP_REAL2, TEMP_REAL3 * Math.RAD_TO_DEG))
    endmethod

    static method Create takes UnitType whichType, User whichPlayer, real x, real y, real angle returns thistype
        set TEMP_REAL = x
        set TEMP_REAL2 = y
        set TEMP_REAL3 = angle
        set User.TEMP = whichPlayer
        set UnitType.TEMP = whichType

        call thistype.CREATE_EXECUTE_TRIGGER.Run()

        return thistype.TEMP
    endmethod

    static method CreateSummon takes UnitType whichType, User whichPlayer, real x, real y, real angle, real duration returns thistype
        local thistype this = thistype.Create(whichType, whichPlayer, x, y, angle)

		call SpotEffectWithSize.Create(x, y, thistype.SUMMON_EFFECT_PATH, EffectLevel.LOW, this.Scale.Get()).Destroy()

        call this.Animation.Set(UNIT.Animation.BIRTH)

        call this.Animation.Queue(UNIT.Animation.STAND)
        call this.SetSummon(duration)

        return this
    endmethod

    static method CreateIllusion takes UnitType whichType, User whichPlayer, real x, real y, real angle, real duration, string deathEffectPath returns thistype
        set thistype.CREATE_TRIGGER_EVENTS = false

        local Unit this = thistype.Create(whichType, whichPlayer, x, y, angle)

        set thistype.CREATE_TRIGGER_EVENTS = true

        call this.Armor.Relative.Invisible.Add(-0.5)
        call this.Classes.AddIllusion()
        call this.Damage.Relative.Invisible.Add(-1.)
        call this.VertexColor.AddForPlayer(-191., -191., 0., 0., whichPlayer)

        call this.SetSummon(duration)

        call this.BloodExplosion.SetSummon(deathEffectPath)

        call this.Create_TriggerEvents()

        return this
    endmethod

    /*enumMethod InitPreplaced_Enum
        local unit enumUnitSelf = GetEnumUnit()

        if (GetUnitTypeId(enumUnitSelf) == 0) then
            call RemoveUnit(enumUnitSelf)

            set enumUnitSelf = null

            return
        endif

        local Unit enumUnit = thistype.GetFromSelf(enumUnitSelf)

        if (enumUnit == NULL) then
            set enumUnit = thistype.CreateFromSelf(enumUnitSelf)
        endif

        if (enumUnit == NULL) then
            return
        endif

        call enumUnit.Buffs.Timed.Start(thistype(NULL).Invulnerability.NORMAL_BUFF, 1, 10.)
        call enumUnit.Stop()
    endmethod

    initMethod InitPreplaced of Preplaced
        local group enumGroup = CreateGroup()

        call GroupEnumUnitsInRect(enumGroup, Rectangle.WORLD.self, null)

        call ForGroup(enumGroup, function thistype.InitPreplaced_Enum)

        call DestroyGroup(enumGroup)

        set enumGroup = null
    endmethod*/

	static method CreateFromPreplaced takes preplaced p returns thistype
		local UnitType whichType = UnitType.GetFromSelf(p.typeId)

		if (whichType == NULL) then
			if (p.waygateTarget != NULL) then
				local unit u = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), p.typeId, p.x, p.y, p.angle)

				call WaygateSetDestination(u, p.waygateTarget.x, p.waygateTarget.y)
				call WaygateActivate(u, true)
				call ShowUnit(u, false)

				set u = null
			endif

			return NULL
		endif

		return Unit.Create(whichType, User.GetFromNativeIndex(p.ownerIndex), p.x, p.y, p.angle)
	endmethod

	initMethod DoPreplaced of Preplaced
		local integer i = preplaced.UNITS_Count()

		loop
			exitwhen (i < ARRAY_MIN)

			local preplaced p = preplaced.UNITS_Get(i)

			if p.enabled then
				local Unit u = Unit.CreateFromPreplaced(p)

				if (u != NULL) then
        			call u.Buffs.Timed.Start(thistype(NULL).Invulnerability.NORMAL_BUFF, 1, 10.)
        			call u.Stop()
        		endif
        	endif

			set i = i - 1
		endloop
	endmethod

    static method Init2 takes nothing returns nothing
        call thistype(NULL).Abilities.Init()
        call thistype(NULL).Armor.Init()
        call thistype(NULL).Bleeding.Init()
        call thistype(NULL).Damage.Init()
        call thistype(NULL).Ignited.Init()
        call thistype(NULL).Knockup.Init()
        call thistype(NULL).Movement.Init()
        call thistype(NULL).Scale.Init()
        call thistype(NULL).Stamina.Init()
        call thistype(NULL).TimedLife.Init()

        call thistype(NULL).Attack.Init()
        call thistype(NULL).Banish.Init()
        call thistype(NULL).Bars.Init()
        call thistype(NULL).Cold.Init()
        call thistype(NULL).Eclipse.Init()
        call thistype(NULL).Frost.Init()
        call thistype(NULL).Ghost.Init()
        call thistype(NULL).Invisibility.Init()
        call thistype(NULL).Invulnerability.Init()
        call thistype(NULL).Items.Init()
        call thistype(NULL).LifeRegeneration.Init()
        call thistype(NULL).MagicImmunity.Init()
        call thistype(NULL).ManaRegeneration.Init()
        call thistype(NULL).Pathing.Init()
        call thistype(NULL).Poisoned.Init()
        call thistype(NULL).Silence.Init()
        call thistype(NULL).Sleep.Init()
        call thistype(NULL).StaminaRegeneration.Init()
        call thistype(NULL).Stun.Init()
        call thistype(NULL).Transport.Init()

        call thistype(NULL).Whirl.Init()

        call UnitType.Init()
        call UnitTypePool.Init()
    endmethod

    initMethod Init of Header_6
        call BJUnit.Init()

        call UnitClass.Init()
        call UnitState.Init()

        set thistype.CREATE_EVENT_TYPE = EventType.Create()
        set thistype.CREATE_EXECUTE_TRIGGER = Trigger.CreateFromCode(function thistype.Create_Executed)
        set thistype.CREATE_FROM_SELF_EXECUTE_TRIGGER = Trigger.CreateFromCode(function thistype.CreateFromSelf_Executed)
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()
        set thistype.DESTROY_EXECUTE_TRIGGER = Trigger.CreateFromCode(function thistype.Destroy_Executed)
        set thistype.ENUM_OF_TYPE_FILTER = BoolExpr.GetFromFunction(function thistype.EnumOfType_Conditions)
        set thistype.HEALED_EVENT_TYPE = EventType.Create()
        //call Event.Create(EventType.START, EventPriority.HEADER, function thistype.Event_Start).AddToStatics()

        call thistype(NULL).Type.Init()

        call thistype(NULL).Attachments.Init()
        call thistype(NULL).Blood.Init()
        call thistype(NULL).BloodExplosion.Init()
        call thistype(NULL).Classes.Init()
        call thistype(NULL).CollisionSize.Init()
        call thistype(NULL).CriticalChance.Init()
        call thistype(NULL).Death.Init()
        call thistype(NULL).Display.Init()
        call thistype(NULL).Drop.Init()
        call thistype(NULL).EvasionChance.Init()
        call thistype(NULL).EvasionChanceDefense.Init()
        call thistype(NULL).Event.Init()
        call thistype(NULL).HealAbility.Init()
        call thistype(NULL).Impact.Init()
        call thistype(NULL).Level.Init()
        call thistype(NULL).Life.Init()
        call thistype(NULL).LifeLeech.Init()
        call thistype(NULL).Madness.Init()
        call thistype(NULL).Mana.Init()
        call thistype(NULL).ManaLeech.Init()
        call thistype(NULL).MaxLife.Init()
        call thistype(NULL).MaxMana.Init()
        call thistype(NULL).Outpact.Init()
        call thistype(NULL).Owner.Init()
        call thistype(NULL).Revival.Init()
        call thistype(NULL).SightRange.Init()
        call thistype(NULL).SpellPower.Init()
        call thistype(NULL).SpellVamp.Init()
        call thistype(NULL).VertexColor.Init()

        call thistype(NULL).Animation.Init()
        call thistype(NULL).Buffs.Init()
        call thistype(NULL).Decay.Init()
        call thistype(NULL).Order.Init()
        call thistype(NULL).Position.Init()
        call thistype(NULL).Selection.Init()

        call thistype(NULL).Agility.Init()
        call thistype(NULL).Intelligence.Init()
        call thistype(NULL).Strength.Init()

        call Code.Run(function thistype.Init2)
    endmethod
endstruct

//! runtextmacro BaseStruct("UnitState", "UNIT_STATE")
    //! runtextmacro CreateAnyState("action", "Action", "Trigger")
    //! runtextmacro CreateAnyState("name", "Name", "string")

    method RunB takes Unit target, boolean val returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.DIRECT_SUBJECT_ID)

        call params.Bool.SetVal(val)
        call params.Unit.SetTrigger(target)

        call this.GetAction().RunWithParams(params)

        call params.Destroy()
    endmethod

    method Run takes Unit target, real amount returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.DIRECT_SUBJECT_ID)

        call params.Real.SetVal(amount)
        call params.Unit.SetTrigger(target)

        call this.GetAction().RunWithParams(params)

        call params.Destroy()
    endmethod

    method RunWithParams takes Unit target, EventResponse params, boolean add returns nothing
        call params.Bool.SetAdded(add)
        call params.Unit.SetTrigger(target)

        call this.GetAction().RunWithParams(params)
    endmethod

    static method Create takes string name, code actionFunction returns thistype
        local thistype this = thistype.allocate()

        call this.SetAction(Trigger.CreateFromCode(actionFunction))
        call this.SetName(name)

        return this
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro BaseStruct("UnitMod", "UNIT_MOD")
    //! runtextmacro CreateAnyState("whichState", "State", "UnitState")

    //! runtextmacro CreateAnyState("gainAction", "GainAction", "Trigger")
    //! runtextmacro CreateAnyState("loseAction", "LoseAction", "Trigger")

    method RemoveFromUnit takes Unit target returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.DIRECT_SUBJECT_ID)

		call params.Unit.SetTrigger(target)
        call params.UnitMod.SetTrigger(this)

        call this.GetLoseAction().RunWithParams(params)

        call params.Destroy()
    endmethod

    method AddToUnit takes Unit target returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.DIRECT_SUBJECT_ID)

		call params.Unit.SetTrigger(target)
        call params.UnitMod.SetTrigger(this)

        call this.GetGainAction().RunWithParams(params)

        call params.Destroy()
    endmethod

    static method Create takes UnitState whichState, code gainFunc, code loseFunc returns thistype
        local thistype this = thistype.allocate()

        call this.SetState(whichState)

        call this.SetGainAction(Trigger.GetFromCode(gainFunc))
        call this.SetLoseAction(Trigger.GetFromCode(loseFunc))

        return this
    endmethod
endstruct

//! runtextmacro Folder("UnitModSet")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("UnitModSet", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitModSet", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("UnitModSet", "Integer", "integer")
        endstruct

        //! runtextmacro Folder("Real")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitModSet", "Real", "real")
            endstruct
        endscope

        //! runtextmacro Struct("Real")
            //! runtextmacro LinkToStruct("Real", "Table")

            //! runtextmacro Data_Type_Implement("UnitModSet", "Real", "real")
        endstruct

        //! runtextmacro Folder("String")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitModSet", "String", "string")
            endstruct
        endscope

        //! runtextmacro Struct("String")
            //! runtextmacro LinkToStruct("String", "Table")

            //! runtextmacro Data_Type_Implement("UnitModSet", "String", "string")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")
        //! runtextmacro LinkToStruct("Data", "String")

        //! runtextmacro Data_Implement("UnitModSet")
    endstruct

    //! runtextmacro Struct("BoolMods")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL_VAL")

        method Count takes nothing returns integer
            return UnitModSet(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns UnitState
            return UnitModSet(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method GetVal takes UnitState state returns boolean
            return UnitModSet(this).Data.Boolean.Get(KEY_ARRAY_DETAIL_VAL + state)
        endmethod

        method Clear takes nothing returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local UnitState state = this.Get(iteration)

                call UnitModSet(this).Data.Boolean.Remove(KEY_ARRAY_DETAIL_VAL + state)

                set iteration = iteration - 1
            endloop

            call UnitModSet(this).Data.Integer.Table.Clear(KEY_ARRAY)
        endmethod

        method ResetVal takes UnitState state, boolean val returns nothing
            call UnitModSet(this).Data.Boolean.Set(KEY_ARRAY_DETAIL_VAL + state, val)
        endmethod

        method Add takes UnitState state, boolean val returns nothing
        	if UnitModSet(this).Data.Integer.Table.Contains(KEY_ARRAY, state) then
                call DebugEx(thistype.NAME + ": "+I2S(this) + " already has " + state.GetName())

                return
            endif

            call UnitModSet(this).Data.Integer.Table.Add(KEY_ARRAY, state)
            call UnitModSet(this).Data.Boolean.Set(KEY_ARRAY_DETAIL_VAL + state, val)
        endmethod

        method RemoveFromUnit takes Unit target returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local UnitState state = this.Get(iteration)

                call target.SubtractStateB(state, this.GetVal(state))

                set iteration = iteration - 1
            endloop
        endmethod

        method AddToUnit takes Unit target returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local UnitState state = this.Get(iteration)

                call target.AddStateB(state, this.GetVal(state))

                set iteration = iteration - 1
            endloop
        endmethod
    endstruct

    //! runtextmacro Struct("RealMods")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL_VAL")

        method Count takes nothing returns integer
            return UnitModSet(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns UnitState
            return UnitModSet(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method GetVal takes UnitState state returns real
            return UnitModSet(this).Data.Real.Get(KEY_ARRAY_DETAIL_VAL + state)
        endmethod

        method Clear takes nothing returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local UnitState state = this.Get(iteration)

                call UnitModSet(this).Data.Real.Remove(KEY_ARRAY_DETAIL_VAL + state)

                set iteration = iteration - 1
            endloop

            call UnitModSet(this).Data.Integer.Table.Clear(KEY_ARRAY)
        endmethod

        method ResetVal takes UnitState state, real val returns nothing
            call UnitModSet(this).Data.Real.Set(KEY_ARRAY_DETAIL_VAL + state, val)
        endmethod

        method Add takes UnitState state, real val returns nothing
            call UnitModSet(this).Data.Integer.Table.Add(KEY_ARRAY, state)
            call UnitModSet(this).Data.Real.Set(KEY_ARRAY_DETAIL_VAL + state, val)
        endmethod

        method RemoveFromUnit takes Unit target returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local UnitState state = this.Get(iteration)

                call target.SubtractState(state, this.GetVal(state))

                set iteration = iteration - 1
            endloop
        endmethod

        method AddToUnit takes Unit target returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local UnitState state = this.Get(iteration)

                call target.AddState(state, this.GetVal(state))

                set iteration = iteration - 1
            endloop
        endmethod
    endstruct

    //! runtextmacro Struct("CustomMods")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL_VAL")

        method Count takes nothing returns integer
            return UnitModSet(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns UnitState
            return UnitModSet(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        //! runtextmacro GetKey("B_MODS_VAL_KEY")
        //! runtextmacro GetKey("I_MODS_VAL_KEY")
        //! runtextmacro GetKey("R_MODS_VAL_KEY")
        //! runtextmacro GetKey("S_MODS_VAL_KEY")

        //! runtextmacro GetKey("B_MODS_TABLE_KEY")
        //! runtextmacro GetKey("I_MODS_TABLE_KEY")
        //! runtextmacro GetKey("R_MODS_TABLE_KEY")
        //! runtextmacro GetKey("S_MODS_TABLE_KEY")

        //! textmacro UnitModSet_CustomMods_CreateType takes name, type, valKey, tableKey, conv
            method Get$name$ takes UnitState state, integer key returns $type$
                return Memory.IntegerKeys.D2.Get$name$($valKey$, this, state, key, NULL)
            endmethod

            method Clear$name$s takes UnitState state returns nothing
                local integer key = Memory.IntegerKeys.D2.Table.FetchFirstInteger($tableKey$, this, state, NULL)

                loop
                    exitwhen (key == NULL)

                    call Memory.IntegerKeys.D2.Remove$name$($valKey$, this, state, key, NULL)

                    set key = Memory.IntegerKeys.D2.Table.FetchFirstInteger($tableKey$, this, state, NULL)
                endloop
            endmethod

            method Reset$name$ takes UnitState state, integer key, $type$ val returns nothing
                call Memory.IntegerKeys.D2.Set$name$($valKey$, this, state, key, NULL, val)
            endmethod

            method Add$name$ takes UnitState state, integer key, $type$ val returns nothing
                call Memory.IntegerKeys.D2.Set$name$($valKey$, this, state, key, NULL, val)
                call Memory.IntegerKeys.D2.Table.AddInteger($tableKey$, this, state, NULL, key)
            endmethod

            method SetParams$name$s takes EventResponse params, UnitState state returns nothing
                local integer key = Memory.IntegerKeys.D2.Table.GetFirstInteger($tableKey$, this, state, NULL)

                loop
                    exitwhen (key == NULL)

                    call params.Dynamic.Set$name$(key, Memory.IntegerKeys.D2.Get$name$($valKey$, this, state, key, NULL))

                    set key = Memory.IntegerKeys.D2.Table.GetNextInteger($tableKey$, this, state, NULL, key)
                endloop
            endmethod
        //! endtextmacro

        //! runtextmacro UnitModSet_CustomMods_CreateType("Boolean", "boolean", "B_MODS_VAL_KEY", "B_MODS_TABLE_KEY", "B2S")
        //! runtextmacro UnitModSet_CustomMods_CreateType("Integer", "integer", "I_MODS_VAL_KEY", "I_MODS_TABLE_KEY", "I2S")
        //! runtextmacro UnitModSet_CustomMods_CreateType("Real", "real", "R_MODS_VAL_KEY", "R_MODS_TABLE_KEY", "R2S")
        //! runtextmacro UnitModSet_CustomMods_CreateType("String", "string", "S_MODS_VAL_KEY", "S_MODS_TABLE_KEY", "")

        method Clear takes nothing returns nothing
            local integer iteration = UnitModSet(this).Data.Integer.Table.Count(KEY_ARRAY)

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local UnitState state = UnitModSet(this).Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call this.ClearBooleans(state)
                call this.ClearIntegers(state)
                call this.ClearReals(state)
                call this.ClearStrings(state)

                set iteration = iteration - 1
            endloop

            call UnitModSet(this).Data.Integer.Table.Clear(KEY_ARRAY)
        endmethod

        method Add takes UnitState state returns nothing
            call UnitModSet(this).Data.Integer.Table.Add(KEY_ARRAY, state)
        endmethod

        method CreateParams takes UnitState state returns EventResponse
            local EventResponse params = EventResponse.Create(UnitModSet(this).Id.Get())

            call this.SetParamsBooleans(params, state)
            call this.SetParamsIntegers(params, state)
            call this.SetParamsReals(params, state)
            call this.SetParamsStrings(params, state)

            return params
        endmethod

        method RemoveFromUnit takes Unit target returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local UnitState state = this.Get(iteration)

                local EventResponse params = this.CreateParams(state)

                call state.RunWithParams(target, params, false)

                call params.Destroy()

                set iteration = iteration - 1
            endloop
        endmethod

        method AddToUnit takes Unit target returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local UnitState state = this.Get(iteration)

                local EventResponse params = this.CreateParams(state)

                call state.RunWithParams(target, params, true)

                call params.Destroy()

                set iteration = iteration - 1
            endloop
        endmethod
    endstruct

    //! runtextmacro Struct("Mods")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL_VAL")

        method Count takes nothing returns integer
            return UnitModSet(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns UnitState
            return UnitModSet(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Clear takes nothing returns nothing
            call UnitModSet(this).Data.Integer.Table.Clear(KEY_ARRAY)
        endmethod

        method Remove takes UnitMod val returns nothing
            call UnitModSet(this).Data.Integer.Table.Remove(KEY_ARRAY, val)
        endmethod

        method Add takes UnitMod val returns nothing
            call UnitModSet(this).Data.Integer.Table.Add(KEY_ARRAY, val)
        endmethod

        method RemoveFromUnit takes Unit target returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local UnitMod mod = this.Get(iteration)

                call mod.RemoveFromUnit(target)

                set iteration = iteration - 1
            endloop
        endmethod

        method AddToUnit takes Unit target returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local UnitMod mod = this.Get(iteration)

                call mod.AddToUnit(target)

                set iteration = iteration - 1
            endloop
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("UnitModSet", "UNIT_MOD_SET")
    static thistype TEMP

    //! runtextmacro LinkToStruct("UnitModSet", "Data")
    //! runtextmacro LinkToStruct("UnitModSet", "Id")

    //! runtextmacro LinkToStruct("UnitModSet", "BoolMods")
    //! runtextmacro LinkToStruct("UnitModSet", "RealMods")
    //! runtextmacro LinkToStruct("UnitModSet", "CustomMods")

    //! runtextmacro LinkToStruct("UnitModSet", "Mods")

    method RemoveFromUnit takes Unit target returns nothing
        call this.BoolMods.RemoveFromUnit(target)
        call this.RealMods.RemoveFromUnit(target)
        call this.CustomMods.RemoveFromUnit(target)

        call this.Mods.RemoveFromUnit(target)
    endmethod

    method AddToUnit takes Unit target returns nothing
        call this.BoolMods.AddToUnit(target)
        call this.RealMods.AddToUnit(target)
        call this.CustomMods.AddToUnit(target)

        call this.Mods.AddToUnit(target)
    endmethod

    method Destroy takes nothing returns nothing
        call this.BoolMods.Clear()
        call this.RealMods.Clear()
        call this.CustomMods.Clear()

        call this.Mods.Clear()

        call this.deallocate()
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        call this.Id.Event_Create()

        return this
    endmethod
endstruct

//! runtextmacro BaseStruct("BuffRef", "BUFF_REF")
    //! runtextmacro GetKey("KEY")

    integer refs

    integer data
    boolean destroyed
    integer level
    Unit target
    Buff whichBuff

    method CheckForDestroy takes nothing returns nothing
        if not this.destroyed then
            return
        endif
        if (this.refs > 0) then
            return
        endif

        call this.deallocate()
    endmethod

    method SubtractRef takes nothing returns nothing
        set this.refs = this.refs - 1
    endmethod

    method AddRef takes nothing returns nothing
        set this.refs = this.refs + 1
    endmethod

    method DestroyNoTrig takes nothing returns nothing
        local Unit target = this.target
        local Buff whichBuff = this.whichBuff

        if this.destroyed then
            return
        endif

        set this.destroyed = true
        set this.refs = this.refs - 1

        if (this.refs == 0) then
            call this.CheckForDestroy()
            //call this.deallocate()
        endif
//call DebugEx("destroyA "+I2S(this))
        call Memory.IntegerKeys.D2.Table.RemoveInteger(KEY, target, whichBuff, NULL, this)
//call DebugEx("destroyB "+I2S(this))
    endmethod

    method Destroy takes nothing returns nothing
        if this.destroyed then
            return
        endif

        call this.DestroyNoTrig()

        call target.Buffs.SetLevel(whichBuff, Memory.IntegerKeys.D2.Table.GetIntegersMaxPrio(KEY, target, whichBuff, NULL), this.data)
    endmethod

    static method Event_BuffLose takes Buff whichBuff, Unit target returns nothing
        local thistype this = Memory.IntegerKeys.D2.Table.GetFirstInteger(KEY, target, whichBuff, NULL)

        loop
            exitwhen (this == NULL)

            set this.refs = this.refs + 1

            call this.DestroyNoTrig()

            set this = Memory.IntegerKeys.D2.Table.GetFirstInteger(KEY, target, whichBuff, NULL)
        endloop
    endmethod

    static method CreateWithLevel takes Buff whichBuff, integer level, Unit target, integer data returns thistype
        local thistype this = thistype.allocate()

        set this.data = data
        set this.destroyed = false
        set this.level = level
        set this.refs = 0
        set this.target = target
        set this.whichBuff = whichBuff

        call Memory.IntegerKeys.D2.Table.AddIntegerWithPrio(KEY, target, whichBuff, NULL, this, level)

        call target.Buffs.SetLevel(whichBuff, Memory.IntegerKeys.D2.Table.GetIntegersMaxPrio(KEY, target, whichBuff, NULL), data)

        return this
    endmethod

    static method Create takes Buff whichBuff, Unit target, integer data returns thistype
        return thistype.CreateWithLevel(whichBuff, 1, target, data)
    endmethod
endstruct
