//! runtextmacro BaseStruct("Announcement", "ANNOUNCEMENT")
    static Timer RESET_TIMER

    static thistype CURRENT

    integer value

    static method Reset takes nothing returns nothing
        set thistype.CURRENT = NULL
        call User.ANY.State.Set(PLAYER_STATE_RESOURCE_FOOD_USED, 0)
    endmethod

    method Start takes nothing returns nothing
        if (thistype.CURRENT == this) then
            return
        endif

        set thistype.CURRENT = this
        call User.ANY.State.Set(PLAYER_STATE_RESOURCE_FOOD_USED, this.value + 1)
    endmethod

    method StartTimed takes real duration returns nothing
        call this.Start()

        call thistype.RESET_TIMER.Start(duration, false, function thistype.Reset)
    endmethod

    static method Create takes integer value returns thistype
        local thistype this = thistype.allocate()

        set this.value = value

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.CURRENT = NULL
        set thistype.RESET_TIMER = Timer.Create()
    endmethod
endstruct

//! runtextmacro BaseStruct("GameMessage", "GAME_MESSAGE")
    static boolean INITIALIZED = false

    boolean destroyTimed
    Timer durationTimer
    boolean exists
    User forWhichPlayer
    string text

    static method UpdateDisplay takes User forWhichPlayer returns nothing
        local integer iteration
        local player p
        local thistype this

        if (forWhichPlayer.IsLocal() == false) then
            return
        endif

        if (thistype.ALL_COUNT > ARRAY_EMPTY + 4) then
            set thistype.ALL[ARRAY_MIN].exists = false
            call thistype.ALL[ARRAY_MIN].RemoveFromListSorted()
        endif

        set iteration = Math.MaxI(ARRAY_MIN, thistype.ALL_COUNT + 1 - 4)
        set p = GetLocalPlayer()
        call ClearTextMessages()

        loop
            set this = thistype.ALL[iteration]

            if (this.destroyTimed) then
                call DisplayTimedTextToPlayer(p, -0.1, 1.2, Math.Max(0.001, this.durationTimer.GetRemaining() - 3.), this.text)
            else
                call DisplayTimedTextToPlayer(p, -0.1, 1.2, 0., this.text)
            endif

            set iteration = iteration + 1
            exitwhen (iteration > thistype.ALL_COUNT)
        endloop

        set p = null
    endmethod

    method Destroy takes nothing returns nothing
        local Timer durationTimer = this.durationTimer
        local User forWhichPlayer = this.forWhichPlayer

        call this.deallocate()
        call durationTimer.Destroy()

        if (forWhichPlayer.IsLocal()) then
            if (this.exists) then
                call this.RemoveFromListSorted()
            endif
        endif

        call thistype.UpdateDisplay(forWhichPlayer)
    endmethod

    static method EndingByTimer takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

        call this.Destroy()
    endmethod

    method DestroyTimed takes real duration returns nothing
        set this.destroyTimed = true

        call this.durationTimer.Start(duration, false, function thistype.EndingByTimer)
    endmethod

    static method Create takes string text, User forWhichPlayer returns thistype
        local Timer durationTimer = Timer.Create()
        local thistype this = thistype.allocate()

        set this.destroyTimed = false
        set this.durationTimer = durationTimer
        set this.exists = true
        set this.forWhichPlayer = forWhichPlayer
        set this.text = text
        call durationTimer.SetData(this)

        if (forWhichPlayer.IsLocal()) then
            call this.AddToList()
        endif

        call thistype.UpdateDisplay(forWhichPlayer)

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.INITIALIZED = true
    endmethod
endstruct

//! runtextmacro BaseStruct("CineFilter", "CINE_FILTER")
    //! runtextmacro CreateAnyState("texture", "Texture", "string")
    //! runtextmacro CreateAnyState("whichBlendMode", "BlendMode", "blendmode")
    //! runtextmacro CreateAnyState("whichTexMapFlags", "TexMapFlags", "texmapflags")

    //! runtextmacro CreateAnyState("redEnd", "RedEnd", "integer")
    //! runtextmacro CreateAnyState("greenEnd", "GreenEnd", "integer")
    //! runtextmacro CreateAnyState("blueEnd", "BlueEnd", "integer")
    //! runtextmacro CreateAnyState("alphaEnd", "AlphaEnd", "integer")

    //! runtextmacro CreateAnyState("redStart", "RedStart", "integer")
    //! runtextmacro CreateAnyState("greenStart", "GreenStart", "integer")
    //! runtextmacro CreateAnyState("blueStart", "BlueStart", "integer")
    //! runtextmacro CreateAnyState("alphaStart", "AlphaStart", "integer")

    //! runtextmacro CreateAnyState("uMaxEnd", "UMaxEnd", "real")
    //! runtextmacro CreateAnyState("uMinEnd", "UMinEnd", "real")
    //! runtextmacro CreateAnyState("vMaxEnd", "VMaxEnd", "real")
    //! runtextmacro CreateAnyState("vMinEnd", "VMinEnd", "real")

    //! runtextmacro CreateAnyState("uMaxStart", "UMaxStart", "real")
    //! runtextmacro CreateAnyState("uMinStart", "UMinStart", "real")
    //! runtextmacro CreateAnyState("vMaxStart", "VMaxStart", "real")
    //! runtextmacro CreateAnyState("vMinStart", "VMinStart", "real")

    method SetColorEnd takes integer red, integer green, integer blue, integer alpha returns nothing
        call this.SetRedEnd(red)
        call this.SetGreenEnd(green)
        call this.SetBlueEnd(blue)
        call this.SetAlphaEnd(alpha)
    endmethod

    method SetColorStart takes integer red, integer green, integer blue, integer alpha returns nothing
        call this.SetRedStart(red)
        call this.SetGreenStart(green)
        call this.SetBlueStart(blue)
        call this.SetAlphaStart(alpha)
    endmethod

    method SetUVEnd takes real minU, real minV, real maxU, real maxV returns nothing
        call this.SetUMaxEnd(maxU)
        call this.SetUMinEnd(minU)
        call this.SetVMaxEnd(maxV)
        call this.SetVMinEnd(minV)
    endmethod

    method SetUVStart takes real minU, real minV, real maxU, real maxV returns nothing
        call this.SetUMaxStart(maxU)
        call this.SetUMinStart(minU)
        call this.SetVMaxStart(maxV)
        call this.SetVMinStart(minV)
    endmethod

    method Ending takes User whichPlayer returns nothing
        if (whichPlayer.IsLocal() == false) then
            return
        endif

        call DisplayCineFilter(false)
    endmethod

    method Start takes real duration, User whichPlayer returns nothing
        if (whichPlayer.IsLocal() == false) then
            return
        endif

        call SetCineFilterBlendMode(this.GetBlendMode())
        call SetCineFilterEndColor(this.redEnd, this.greenEnd, this.blueEnd, this.alphaEnd)
        call SetCineFilterEndUV(this.uMinEnd, this.vMinEnd, this.uMaxEnd, this.vMaxEnd)
        call SetCineFilterStartColor(this.redStart, this.greenStart, this.blueStart, this.alphaStart)
        call SetCineFilterStartUV(this.uMinStart, this.vMinStart, this.uMaxStart, this.vMaxStart)
        call SetCineFilterTexMapFlags(this.GetTexMapFlags())
        call SetCineFilterTexture(this.GetTexture())

        call SetCineFilterDuration(duration)

        call DisplayCineFilter(true)
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        call this.SetBlendMode(BLEND_MODE_BLEND)
        call this.SetColorEnd(255, 255, 255, 255)
        call this.SetColorStart(0, 0, 0, 0)
        call this.SetTexMapFlags(TEXMAP_FLAG_NONE)
        call this.SetTexture(null)
        call this.SetUVEnd(0., 0., 1., 1.)
        call this.SetUVStart(0., 0., 1., 1.)

        return this
    endmethod
endstruct

//! runtextmacro StaticStruct("Cinematic")
    static method EndScene takes nothing returns nothing
        call EndCinematicScene()
    endmethod

    static method SetScene takes integer unitId, playercolor color, string name, string text, real sceneDuration, real voiceDuration returns nothing
        call SetCinematicScene(unitId, color, name, text, sceneDuration, voiceDuration)
    endmethod
endstruct

//! runtextmacro Folder("Game")
    //! runtextmacro Struct("FloatState")
        static method Get takes fgamestate whichState returns real
            return GetFloatGameState(whichState)
        endmethod

        static method Set takes fgamestate whichState, real value returns nothing
            call SetFloatGameState(whichState, value)
        endmethod

        static method Add takes fgamestate whichState, real value returns nothing
            call SetFloatGameState(whichState, Get(whichState) + value)
        endmethod
    endstruct

    //! runtextmacro Struct("TimeOfDay")
        static real SCALE

        method Get takes nothing returns real
            return Game.FloatState.Get(GAME_STATE_TIME_OF_DAY)
        endmethod

        method GetScale takes nothing returns real
            return thistype.SCALE
        endmethod

        method Set takes real time returns nothing
            call Game.FloatState.Set(GAME_STATE_TIME_OF_DAY, time)
        endmethod

        method SetScale takes real scale returns nothing
            set thistype.SCALE = scale
            call SetTimeOfDayScale(scale)
        endmethod

        method Suspend takes boolean flag returns nothing
            call SuspendTimeOfDay(flag)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.SCALE = GetTimeOfDayScale()
        endmethod
    endstruct
endscope

function ClearTextMessages_Wrapped takes nothing returns nothing
    call ClearTextMessages()
endfunction

function PingMinimap_Wrapped takes real x, real y, real duration returns nothing
    call PingMinimap(x, y, duration)
endfunction

//! runtextmacro StaticStruct("Game")
    //! runtextmacro LinkToStaticStruct("Game", "FloatState")
    //! runtextmacro LinkToStaticStruct("Game", "TimeOfDay")

    static method ClearTextMessages takes User whichPlayer returns nothing
        if (whichPlayer.IsLocal()) then
            call ClearTextMessages_Wrapped()
        endif
    endmethod

    static method DisplayInterface takes User whichPlayer, boolean flag, real duration returns nothing
        if (whichPlayer.IsLocal()) then
            call ShowInterface(flag, duration)
        endif
    endmethod

    static method DisplayTextTimed takes User whichPlayer, string text, real duration returns GameMessage
        local GameMessage result = GameMessage.Create(text, whichPlayer)

        call result.DestroyTimed(duration)

        return result
    endmethod

    static method DebugMsg takes string text returns GameMessage
        if (GameMessage.INITIALIZED == false) then
            call BJDebugMsg("Debug (uninit): " + text)
        endif

        return thistype.DisplayTextTimed(User.ANY, "Debug: " + text, 15.)
    endmethod

    static method DisplaySpeech takes UnitType speaker, string text, real duration returns GameMessage
        return thistype.DisplayTextTimed(User.ANY, String.Color.GOLD + speaker.GetName() + ": " + String.Color.RESET + text, duration)
    endmethod

    static method EnableControl takes User whichPlayer, boolean flag returns nothing
        if (whichPlayer.IsLocal()) then
            call EnableUserControl(flag)
        endif
    endmethod

    static method EnableTimeOfDay takes boolean flag returns nothing
        call SuspendTimeOfDay(flag == false)
    endmethod

    static method PingMinimap takes real x, real y, real duration returns nothing
        call PingMinimap_Wrapped(x, y, duration)
    endmethod

    static method PingMinimapColored takes real x, real y, integer red, integer green, integer blue, real duration returns nothing
        call PingMinimapEx(x, y, duration, red, green, blue, false)
    endmethod

    static method DisplaySpeechFromUnit takes Unit speaker, string text, real duration returns nothing
        call thistype.DisplayTextTimed(User.ANY, String.Color.GOLD + speaker.GetName() + ": " + String.Color.RESET + text, duration)
        call thistype.PingMinimap(speaker.Position.X.Get(), speaker.Position.Y.Get(), 1.)
        call speaker.Flash(255, 255, 255, 255)
    endmethod

    static method Init takes nothing returns nothing
        call thistype(NULL).TimeOfDay.Init()

        call Announcement.Init()
        call GameMessage.Init()
        call Ping.Init()
        call PingColor.Init()
    endmethod
endstruct

//! runtextmacro BaseStruct("PingColor", "PING_COLOR")
    static thistype array UNUSED
    static integer UNUSED_COUNT = ARRAY_EMPTY

    static thistype BLUE
    static thistype GREEN
    static thistype RED
    static thistype YELLOW

    boolean used

    //! runtextmacro CreateAnyState("name", "Name", "string")

    //! runtextmacro CreateAnyState("red", "Red", "integer")
    //! runtextmacro CreateAnyState("green", "Green", "integer")
    //! runtextmacro CreateAnyState("blue", "Blue", "integer")

    static method RandomUnused takes nothing returns thistype
        if (thistype.UNUSED_COUNT == ARRAY_EMPTY) then
            return NULL
        endif

        return thistype.UNUSED[Math.RandomI(ARRAY_MIN, thistype.UNUSED_COUNT)]
    endmethod

    method SetUsed takes boolean value returns nothing
        local integer iteration
        local boolean oldValue = this.used

        if (value == oldValue) then
            return
        endif

        set this.used = value
        if (value) then
            set iteration = thistype.UNUSED_COUNT

            loop
                exitwhen (thistype.UNUSED[iteration] == this)
                set iteration = iteration - 1
            endloop

            set thistype.UNUSED[iteration] = thistype.UNUSED[thistype.UNUSED_COUNT]

            set thistype.UNUSED_COUNT = thistype.UNUSED_COUNT - 1
        else
            set thistype.UNUSED_COUNT = thistype.UNUSED_COUNT + 1

            set thistype.UNUSED[thistype.UNUSED_COUNT] = this
        endif
    endmethod

    static method Create takes string name, integer red, integer green, integer blue returns thistype
        local thistype this = thistype.allocate()

        set this.used = false
        call this.SetName(String.Color.Do(name, String.Color.GetFrom255(red, green, blue, 255)))

        call this.SetRed(red)
        call this.SetGreen(green)
        call this.SetBlue(blue)

        set thistype.UNUSED_COUNT = thistype.UNUSED_COUNT + 1

        set thistype.UNUSED[thistype.UNUSED_COUNT] = this

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.BLUE = thistype.Create("Blue", 0, 0, 255)
        set thistype.GREEN = thistype.Create("Green", 0, 255, 0)
        set thistype.YELLOW = thistype.Create("Yellow", 255, 255, 0)
    endmethod
endstruct

//! runtextmacro BaseStruct("Ping", "PING")
    //! runtextmacro GetKey("KEY")
    static constant real UPDATE_TIME = 3 * 32 * FRAME_UPDATE_TIME
    static Timer UPDATE_TIMER

    integer red
    integer green
    integer blue

    boolean show
    real x
    real y

    //! runtextmacro CreateAnyState("whichColor", "Color", "PingColor")

    method Destroy takes nothing returns nothing
        local PingColor whichColor = this.whichColor

        if (whichColor != NULL) then
            call whichColor.SetUsed(false)
        endif

        call this.deallocate()
        if (this.RemoveFromList()) then
            call thistype.UPDATE_TIMER.Pause()
        endif
    endmethod

    method Hide takes nothing returns nothing
        set this.show = false
    endmethod

    method Show takes nothing returns nothing
        set this.show = true
        call Game.PingMinimapColored(this.x, this.y, this.red, this.green, this.blue, thistype.UPDATE_TIME)
    endmethod

    static method Update takes nothing returns nothing
        local integer iteration = thistype.ALL_COUNT
        local thistype this

        loop
            set this = thistype.ALL[iteration]

            if (show) then
                call Game.PingMinimapColored(this.x, this.y, this.red, this.green, this.blue, thistype.UPDATE_TIME)
            endif

            set iteration = iteration - 1
            exitwhen (iteration < ARRAY_MIN)
        endloop
    endmethod

    method Start takes nothing returns nothing
        if (this.AddToList()) then
            call thistype.UPDATE_TIMER.Start(UPDATE_TIME, true, function thistype.Update)
        endif
    endmethod

    static method Create takes real x, real y, PingColor whichColor returns thistype
        local thistype this = thistype.allocate()

        set this.red = whichColor.GetRed()
        set this.green = whichColor.GetGreen()
        set this.blue = whichColor.GetBlue()

        set this.whichColor = whichColor
        set this.x = x
        set this.y = y

        call whichColor.SetUsed(true)

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.UPDATE_TIMER = Timer.Create()
    endmethod
endstruct