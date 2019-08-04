//! runtextmacro Folder("ItemType")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("ItemType", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("ItemType", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("ItemType", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("ItemType")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "ItemType", "NULL")

        //! runtextmacro Event_Implement("ItemType")
    endstruct

    //! runtextmacro Struct("Abilities")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

        method Count takes nothing returns integer
            return ItemType(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns Spell
            return ItemType(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method GetLevel takes Spell whichSpell returns integer
            return ItemType(this).Data.Integer.Get(KEY_ARRAY_DETAIL + whichSpell)
        endmethod

        method AddWithLevel takes Spell whichSpell, integer level returns nothing
            call ItemType(this).Data.Integer.Table.Add(KEY_ARRAY, whichSpell)
            call ItemType(this).Data.Integer.Set(KEY_ARRAY_DETAIL + whichSpell, level)
        endmethod

        method Add takes Spell whichSpell returns nothing
            call this.AddWithLevel(whichSpell, 1)
        endmethod
    endstruct

    //! runtextmacro Struct("ChargesAmount")
        //! runtextmacro CreateSimpleAddState("integer", "0")
    endstruct

    //! runtextmacro Struct("Classes")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        method Count takes nothing returns integer
            return ItemType(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns ItemClass
            return ItemType(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Add takes ItemClass value returns nothing
            call ItemType(this).Data.Integer.Table.Add(KEY_ARRAY, value)
        endmethod
    endstruct

    //! runtextmacro Struct("Preload")
        method Event_Create takes nothing returns nothing
            call RemoveItem(CreateItem(ItemType(this).self, 0., 0.))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("ItemType", "ITEM_TYPE")
    //! runtextmacro GetKey("KEY")

    integer self

    //! runtextmacro LinkToStruct("ItemType", "Abilities")
    //! runtextmacro LinkToStruct("ItemType", "ChargesAmount")
    //! runtextmacro LinkToStruct("ItemType", "Classes")
    //! runtextmacro LinkToStruct("ItemType", "Data")
    //! runtextmacro LinkToStruct("ItemType", "Event")
    //! runtextmacro LinkToStruct("ItemType", "Id")

    //! runtextmacro CreateAnyState("icon", "Icon", "string")

    static method GetFromSelf takes integer self returns thistype
        return Memory.IntegerKeys.GetInteger(self, KEY)
    endmethod

    method GetName takes nothing returns string
        return GetObjectName(this.self)
    endmethod

    method GetSelf takes nothing returns integer
        return this.self
    endmethod

    //! runtextmacro GetKeyArray("INIT_KEY_ARRAY")

    static method AddInit takes code c returns nothing
        call Trigger.AddObjectInit(INIT_KEY_ARRAY, c)
    endmethod

    static method CreateFromSelf takes integer self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self
        call Memory.IntegerKeys.SetInteger(self, KEY, this)

        call this.ChargesAmount.Event_Create()
        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
//        call Trigger.RunObjectInits(thistype.INIT_KEY_ARRAY)
    endmethod
endstruct