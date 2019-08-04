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

    static method Create takes Rectangle whichRect, integer whichType returns thistype
        local thistype this = thistype.allocate()

        set this.self = AddWeatherEffect(whichRect.self, whichType)

        return this
    endmethod

    static method Event_AfterIntro takes nothing returns nothing
        if (USER.Event.GetTrigger().IsLocal()) then
            call thistype.MOON.Show()
        endif
    endmethod

    static method Event_Start takes nothing returns nothing
        call Event.Create(AfterIntro.FOR_PLAYER_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_AfterIntro).AddToStatics()
    endmethod

    static method Init takes nothing returns nothing
        call Event.Create(EventType.START, EventPriority.HEADER, function thistype.Event_Start).AddToStatics()

        //Moon
        set thistype.MOON = thistype.Create(Rectangle.WORLD, 'LRma')
    endmethod
endstruct