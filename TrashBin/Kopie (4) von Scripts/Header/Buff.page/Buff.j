//! runtextmacro Folder("Buff")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Buff", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("Buff", "Boolean", "boolean")
        endstruct

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Buff", "Integer", "integer")
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
        //! runtextmacro LinkToStruct("Data", "String")

        //! runtextmacro Data_Implement("Buff")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro CreateAnyStaticStateDefault("LEVEL", "Level", "integer", "0")
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "Buff", "NULL")

        //! runtextmacro Event_Implement("Buff")
    endstruct

    //! runtextmacro Struct("TargetEffects")
        //! runtextmacro GetKeyArray("ATTACH_POINTS_KEY_ARRAY")
        //! runtextmacro GetKeyArray("LEVELS_KEY_ARRAY")
        //! runtextmacro GetKeyArray("PATHS_KEY_ARRAY")

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
            call Buff(this).Data.String.Table.Add(ATTACH_POINTS_KEY_ARRAY, attachPoint)
            call Buff(this).Data.Integer.Table.Add(LEVELS_KEY_ARRAY, level)
            call Buff(this).Data.String.Table.Add(PATHS_KEY_ARRAY, path)

            call Effect.PreloadPath(path)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Buff", "BUFF")
    //! runtextmacro GetKey("KEY")
    static thistype TEMP

    //! runtextmacro LinkToStruct("Buff", "Data")
    //! runtextmacro LinkToStruct("Buff", "Event")
    //! runtextmacro LinkToStruct("Buff", "Id")
    //! runtextmacro LinkToStruct("Buff", "TargetEffects")

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

        call this.SetDummySpellId(spellId)
        call this.SetHidden(false)
        call this.SetLostOnDeath(false)
        call this.SetLostOnDispel(false)
        call this.SetName(name)
        call this.SetShowCountdown(false)

        call this.Id.Event_Create()

        call InitBuff(self)
        call InitAbility(spellId)

        return this
    endmethod

    //! runtextmacro GetKeyArray("INIT_KEY_ARRAY")

    static method AddInit takes code c returns nothing
        call Trigger.AddObjectInit(INIT_KEY_ARRAY, c)
    endmethod

    static method CreateHidden takes string name returns thistype
        local thistype this = thistype.allocate()

        call this.SetHidden(true)
        call this.SetLostOnDeath(false)
        call this.SetLostOnDispel(false)
        call this.SetName(name + " (hidden)")

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        call Trigger.RunObjectInits(thistype.INIT_KEY_ARRAY)
    endmethod
endstruct