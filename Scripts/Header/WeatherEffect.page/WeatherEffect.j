//! runtextmacro BaseStruct("WeatherType", "WEATHER_TYPE")
    //! runtextmacro CreateAnyState("self", "Self", "integer")

    static method Create takes integer self returns thistype
        local thistype this = thistype.allocate()

        call this.SetSelf(self)

        return this
    endmethod

    //! runtextmacro GetKeyArray("INIT_KEY_ARRAY")

    static method AddInit takes code c, string name returns nothing
        call Trigger.AddObjectInit(INIT_KEY_ARRAY, c, name)
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro BaseStruct("WeatherEffect", "WEATHER_EFFECT")
    static thistype MOON

    weathereffect self

    method Destroy takes nothing returns nothing
        local weathereffect self = this.self

        call this.deallocate()

        call RemoveWeatherEffect(self)

        set self = null
    endmethod

    method Hide takes nothing returns nothing
        call EnableWeatherEffect(this.self, false)
    endmethod

    method Show takes nothing returns nothing
        call EnableWeatherEffect(this.self, true)
    endmethod

    static method Create takes Rectangle whichRect, WeatherType whichType returns thistype
        local thistype this = thistype.allocate()

        set this.self = AddWeatherEffect(whichRect.self, whichType.GetSelf())

        return this
    endmethod

    eventMethod Event_AfterIntro
        if params.User.GetTrigger().IsLocal() then
            call thistype.MOON.Show()
        endif
    endmethod

    eventMethod Event_Start
        set thistype.MOON = thistype.Create(Rectangle.WORLD, thistype.MOON_TYPE)

        call Event.Create(AfterIntro.FOR_PLAYER_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_AfterIntro).AddToStatics()
    endmethod

    initMethod Init of Header_5
        call WeatherType.Init()

        call Event.Create(EventType.START, EventPriority.HEADER, function thistype.Event_Start).AddToStatics()
    endmethod
endstruct