//! runtextmacro BaseStruct("UnitNameTag", "UNIT_NAME_TAG")
    static Event CREATE_EVENT

    static method Event_Create takes nothing returns nothing
        local thistype this
        local TextTag whichTag = TextTag.Create(TextTag.GetFreeId())
        local UnitType whichType
        local Unit whichUnit

        if (whichTag == NULL) then
            return
        endif

        set whichType = UNIT_TYPE.Event.GetTrigger()
        set whichUnit = UNIT.Event.GetTrigger()

        set this = whichType

        call whichTag.Position.Set(whichUnit.Position.X.Get() + whichUnit.Outpact.X.Get(true), whichUnit.Position.Y.Get() + whichUnit.Outpact.Y.Get(true), whichUnit.Position.Z.Get() + whichUnit.Outpact.Z.Get(true))
        call whichTag.Position.SetCentered()
        call whichTag.Text.Set(String.Color.Gradient(whichType.GetName(), "ff77ffff", String.Color.DWC), TextTag.STANDARD_SIZE * 1.15)
    endmethod

    static method Create takes UnitType whichType returns thistype
        local thistype this = whichType

        call whichType.Event.Add(CREATE_EVENT)

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.CREATE_EVENT = Event.Create(Unit.CREATE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Create)

        call thistype.Create(UnitType.GARBAGE_COLLECTOR)
        call thistype.Create(UnitType.LIBRARY)
        call thistype.Create(UnitType.PHARMACY)
        call thistype.Create(UnitType.RIDE_SHOP)
        call thistype.Create(UnitType.TAVERN)
    endmethod
endstruct