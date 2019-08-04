//! runtextmacro Folder("StringData")
    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_StringKey_Type_Table_Implement("StringData", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_StringKey_Type_Implement("StringData", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_StringKey_Implement("StringData")
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            static method GetChat takes nothing returns string
                return GetEventPlayerChatString()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")

        method Count takes string self, EventType whichType, EventPriority priority returns integer
            return StringData.Data.Integer.Table.Count(self, Event.GetKeyFromTypePriority(whichType, priority))
        endmethod

        method Get takes string self, EventType whichType, EventPriority priority, integer index returns Event
            return StringData.Data.Integer.Table.Get(self, Event.GetKeyFromTypePriority(whichType, priority), index)
        endmethod

        method Remove takes string self, Event whichEvent returns nothing
            call StringData.Data.Integer.Table.Remove(self, whichEvent.GetKey(), whichEvent)
        endmethod

        method Add takes string self, Event whichEvent returns nothing
            call StringData.Data.Integer.Table.Add(self, whichEvent.GetKey(), whichEvent)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("StringData", "STRING_DATA")
    //! runtextmacro LinkToStaticStruct("StringData", "Data")
    //! runtextmacro LinkToStaticStruct("StringData", "Event")

    initMethod Init of Header
    endmethod
endstruct