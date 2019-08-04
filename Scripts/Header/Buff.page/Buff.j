//! runtextmacro Folder("Buff")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("Buff", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Buff", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Buff", "Integer", "integer")
        endstruct

        //! runtextmacro Folder("Real")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Buff", "Real", "real")
            endstruct
        endscope

        //! runtextmacro Struct("Real")
            //! runtextmacro LinkToStruct("Real", "Table")

            //! runtextmacro Data_Type_Implement("Buff", "Real", "real")
        endstruct

        //! runtextmacro Folder("String")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Buff", "String", "string")
            endstruct
        endscope

        //! runtextmacro Struct("String")
            //! runtextmacro LinkToStruct("String", "Table")

            //! runtextmacro Data_Type_Implement("Buff", "String", "string")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")
        //! runtextmacro LinkToStruct("Data", "String")

        //! runtextmacro Data_Implement("Buff")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro Event_Implement("Buff")
    endstruct

    //! runtextmacro Struct("TargetEffects")
        //! runtextmacro GetKeyArray("ATTACH_POINTS_KEY_ARRAY")
        //! runtextmacro GetKeyArray("LEVELS_KEY_ARRAY")
        //! runtextmacro GetKeyArray("PATHS_KEY_ARRAY")

		//! runtextmacro CreateAnyFlagState("shownOnApply", "ShownOnApply")

        method Count takes nothing returns integer
            return Buff(this).Data.String.Table.Count(PATHS_KEY_ARRAY)
        endmethod

        method GetAttachPoint takes integer index returns string
            return Buff(this).Data.String.Table.Get(ATTACH_POINTS_KEY_ARRAY, index)
        endmethod

        method GetLevel takes integer index returns integer
            return Buff(this).Data.Integer.Table.Get(LEVELS_KEY_ARRAY, index)
        endmethod

        method GetPath takes integer index returns string
            return Buff(this).Data.String.Table.Get(PATHS_KEY_ARRAY, index)
        endmethod

        method Add takes string path, string attachPoint, EffectLevel level returns nothing
            call Buff(this).Data.String.Table.AddMulti(ATTACH_POINTS_KEY_ARRAY, attachPoint)
            call Buff(this).Data.Integer.Table.AddMulti(LEVELS_KEY_ARRAY, level)
            call Buff(this).Data.String.Table.AddMulti(PATHS_KEY_ARRAY, path)

            call Effect.PreloadPath(path)
        endmethod

		method Event_Create takes nothing returns nothing
			call this.SetShownOnApply(true)
		endmethod
    endstruct

	//! runtextmacro Struct("LoopSounds")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        method Count takes nothing returns integer
            return Buff(this).Data.String.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns integer
            return Buff(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Add takes SoundType val returns nothing
            call Buff(this).Data.Integer.Table.AddMulti(KEY_ARRAY, val)
        endmethod
	endstruct

    //! runtextmacro Struct("Variants")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("PARENT_KEY_ARRAY")

        method Count takes nothing returns integer
            return Buff(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns Buff
            return Buff(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method CountParents takes nothing returns integer
            return Buff(this).Data.Integer.Table.Count(PARENT_KEY_ARRAY)
        endmethod

        method GetParent takes integer index returns Buff
            return Buff(this).Data.Integer.Table.Get(PARENT_KEY_ARRAY, index)
        endmethod

        method Add takes Buff child returns nothing
            local Buff parent = this

            call child.Data.Integer.Table.Add(PARENT_KEY_ARRAY, parent)
            call parent.Data.Integer.Table.Add(KEY_ARRAY, child)
        endmethod

        method Event_Create takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Struct("UnitMods")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL_VAL")

        method Count takes nothing returns integer
            return Buff(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns UnitState
            return Buff(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method GetVal takes UnitState state returns real
            return Buff(this).Data.Real.Get(KEY_ARRAY_DETAIL_VAL + state)
        endmethod

        method Add takes UnitState state, real val returns nothing
            call Buff(this).Data.Integer.Table.Add(KEY_ARRAY, state)
            call Buff(this).Data.Real.Set(KEY_ARRAY_DETAIL_VAL + state, val)
        endmethod
    endstruct

    //! runtextmacro Struct("UnitModSets")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

        method Get takes integer level returns UnitState
            return Buff(this).Data.Integer.Get(KEY_ARRAY_DETAIL + level)
        endmethod

        method Add takes integer level, UnitModSet val returns nothing
            call Buff(this).Data.Integer.Set(KEY_ARRAY_DETAIL + level, val)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Buff", "BUFF")
    //! runtextmacro GetKey("KEY")
    static thistype TEMP

    //! runtextmacro LinkToStruct("Buff", "Data")
    //! runtextmacro LinkToStruct("Buff", "Event")
    //! runtextmacro LinkToStruct("Buff", "Id")
    //! runtextmacro LinkToStruct("Buff", "LoopSounds")
    //! runtextmacro LinkToStruct("Buff", "TargetEffects")
    //! runtextmacro LinkToStruct("Buff", "UnitMods")
    //! runtextmacro LinkToStruct("Buff", "UnitModSets")
    //! runtextmacro LinkToStruct("Buff", "Variants")

    static method GetFromName takes string name returns thistype
        return StringData.Data.Integer.Get(name, KEY)
    endmethod

    static method GetFromSelf takes integer self returns thistype
        return Memory.IntegerKeys.GetInteger(self, KEY)
    endmethod

    //! runtextmacro CreateAnyState("dummySpellId", "DummySpellId", "integer")
    //! runtextmacro CreateAnyFlagState("hidden", "Hidden")
    //! runtextmacro CreateAnyState("icon", "Icon", "string")
    //! runtextmacro CreateAnyFlagState("lostOnDeath", "LostOnDeath")
    //! runtextmacro CreateAnyFlagState("lostOnDispel", "LostOnDispel")
    //! runtextmacro CreateAnyState("name", "Name", "string")
    //! runtextmacro CreateAnyFlagState("positive", "Positive")
    //! runtextmacro CreateAnyState("self", "Self", "integer")
    //! runtextmacro CreateAnyFlagState("showCountdown", "ShowCountdown")

    static method Create takes integer self, string name, integer spellId returns thistype
        local thistype this = thistype.allocate()

        set this.self = self
        call Memory.IntegerKeys.SetInteger(self, KEY, this)

		call this.Id.Event_Create()

        call this.SetDummySpellId(spellId)
        call this.SetHidden(false)
        call this.SetLostOnDeath(false)
        call this.SetLostOnDispel(false)
        call this.SetName(name)
        call this.SetShowCountdown(false)

		call this.TargetEffects.Event_Create()
        call this.Variants.Event_Create()

        call InitBuff(self)
        call InitAbility(spellId, true)

        call StringData.Data.Integer.Set(this.GetName(), KEY, this)

        call this.AddToList()

        return this
    endmethod

    //! runtextmacro GetKeyArray("INIT_KEY_ARRAY")

    static method AddInit takes code c, string name returns nothing
        call Trigger.AddObjectInit(INIT_KEY_ARRAY, c, name)
    endmethod

    static method CreateHidden takes string name returns thistype
        local thistype this = thistype.allocate()

		call this.Id.Event_Create()

        call this.SetHidden(true)
        call this.SetLostOnDeath(false)
        call this.SetLostOnDispel(false)
        call this.SetName(name + " (hidden)")

		call this.TargetEffects.Event_Create()
        call this.Variants.Event_Create()

        call StringData.Data.Integer.Set(this.GetName(), KEY, this)

        call this.AddToList()

        return this
    endmethod

    initMethod Init of Header_2
    endmethod
endstruct