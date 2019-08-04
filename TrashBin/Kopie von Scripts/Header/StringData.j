//! runtextmacro Folder("StringData")
    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_StringKey_Type_Table_Implement("Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_StringKey_Type_Implement("Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_StringKey_Implement()
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            static method GetChat takes nothing returns string
                return GetEventPlayerChatString()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        static string CHAT

        //! runtextmacro LinkToStruct("Event", "Native")

        static method GetChat takes nothing returns string
            return thistype.CHAT
        endmethod

        static method SetChat takes string self returns nothing
            set thistype.CHAT = self
        endmethod

        method Count takes string self, integer whichType, integer priority returns integer
            return StringData.Data.Integer.Table.Count(self, Event.GetKey(whichType, priority))
        endmethod

        method Get takes string self, integer whichType, integer priority, integer index returns Event
            return StringData.Data.Integer.Table.Get(self, Event.GetKey(whichType, priority), index)
        endmethod

        method Remove takes string self, Event whichEvent returns nothing
            call StringData.Data.Integer.Table.Remove(self, Event.GetKey(whichEvent.GetType(), whichEvent.GetPriority()), whichEvent)
        endmethod

        method Add takes string self, Event whichEvent returns nothing
            call StringData.Data.Integer.Table.Add(self, Event.GetKey(whichEvent.GetType(), whichEvent.GetPriority()), whichEvent)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("StringData", "STRING_DATA")
    //! runtextmacro LinkToStaticStruct("StringData", "Data")
    //! runtextmacro LinkToStaticStruct("StringData", "Event")

    static method Init takes nothing returns nothing
    endmethod
endstruct