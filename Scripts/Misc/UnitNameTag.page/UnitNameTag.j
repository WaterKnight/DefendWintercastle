//! runtextmacro BaseStruct("UnitNameTag", "UNIT_NAME_TAG")
    static Event CREATE_EVENT
    static Event DESTROY_EVENT

    TextTag whichTag

    eventMethod Event_Destroy
        local Unit whichUnit = params.Unit.GetTrigger()

        local thistype this = whichUnit

        local TextTag whichTag = this.whichTag

        call whichUnit.Event.Remove(DESTROY_EVENT)

        call whichTag.Destroy()
    endmethod

    eventMethod Event_Create
        local TextTag whichTag = TextTag.Create(TextTag.GetFreeId())

        if (whichTag == NULL) then
            return
        endif

        local UnitType whichType = params.UnitType.GetTrigger()
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichTag.Position.Set(whichUnit.Position.X.Get() + whichUnit.Outpact.X.Get(true), whichUnit.Position.Y.Get() + whichUnit.Outpact.Y.Get(true), whichUnit.Position.Z.Get() + whichUnit.Outpact.Z.Get(true))
        call whichTag.Position.SetCentered()
        call whichTag.Text.Set(String.Color.Gradient(whichType.GetName(), "ff77ffff", String.Color.DWC), TextTag.STANDARD_SIZE * 1.15)

        local thistype this = whichUnit

        set this.whichTag = whichTag

        call whichUnit.Event.Add(DESTROY_EVENT)
    endmethod

    static method Create takes UnitType whichType returns nothing
        call whichType.Event.Add(CREATE_EVENT)
    endmethod

    initMethod Init of Misc
        set thistype.CREATE_EVENT = Event.Create(Unit.CREATE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Create)
        set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Destroy)

        call thistype.Create(GarbageCollector.SHOP)
        call thistype.Create(Library.SHOP)
        call thistype.Create(Pharmacy.SHOP)
        call thistype.Create(HorseRide.SHOP)
        call thistype.Create(Tavern.SHOP)
    endmethod
endstruct