//! runtextmacro Folder("Tomes")
	//! runtextmacro Struct("Agi")
	    eventMethod Event_ItemUse
	        local Unit whichUnit = params.Unit.GetTrigger()

	        call whichUnit.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

			call whichUnit.Agility.Base.Add(1)
	    endmethod

		static method Init takes nothing returns nothing
			call Tomes.Create(thistype.THIS_ITEM, function thistype.Event_ItemUse)
		endmethod
	endstruct

	//! runtextmacro Struct("Int")
	    eventMethod Event_ItemUse
	        local Unit whichUnit = params.Unit.GetTrigger()

	        call whichUnit.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

			call whichUnit.Intelligence.Base.Add(1)
	    endmethod

		static method Init takes nothing returns nothing
			call Tomes.Create(thistype.THIS_ITEM, function thistype.Event_ItemUse)
		endmethod
	endstruct

	//! runtextmacro Struct("Str")
	    eventMethod Event_ItemUse
	        local Unit whichUnit = params.Unit.GetTrigger()

	        call whichUnit.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

			call whichUnit.Strength.Base.Add(1)
	    endmethod

		static method Init takes nothing returns nothing
			call Tomes.Create(thistype.THIS_ITEM, function thistype.Event_ItemUse)
		endmethod
	endstruct
endscope

//! runtextmacro BaseStruct("Tomes", "TOMES")
    //! runtextmacro GetKey("KEY")

    //! runtextmacro CreateList("ALL")

    CustomDrop drop

	//! runtextmacro LinkToStruct("Tomes", "Agi")
	//! runtextmacro LinkToStruct("Tomes", "Int")
	//! runtextmacro LinkToStruct("Tomes", "Str")

    eventMethod Event_Drop
        local Event dropEvent = Event.GetTrigger()
        local Unit whichUnit = params.Unit.GetTrigger()

        local thistype this = dropEvent.Data.Integer.Get(KEY)

        local ItemType whichItem = this

        call Item.Create(whichItem, whichUnit.Position.X.Get(), whichUnit.Position.Y.Get())
    endmethod

    static method RandomForUnit takes Unit target returns nothing
        local thistype this = thistype.ALL_RandomAll()

        call target.Drop.Add(this.drop)
    endmethod

    static method Create takes ItemType whichItem, code action returns nothing
        local thistype this = whichItem

        local Event dropEvent = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Drop)

        set this.drop = CustomDrop.Create(dropEvent, null, null, NULL)

        call dropEvent.Data.Integer.Set(KEY, this)
        call whichItem.Event.Add(Event.Create(UNIT.Items.Events.Use.DUMMY_EVENT_TYPE, EventPriority.MISC, action))

        call thistype.ALL_Add(this)
    endmethod

    initMethod Init of Misc
        call thistype(NULL).Agi.Init()
        call thistype(NULL).Int.Init()
        call thistype(NULL).Str.Init()
    endmethod
endstruct