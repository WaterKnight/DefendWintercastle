//! runtextmacro StaticStruct("Boolean")
    static method ToInt takes boolean self returns integer
        if (self) then
            return 1
        endif

        return 0
    endmethod

    static method ToIntEx takes boolean self returns integer
        if (self) then
            return 1
        endif

        return -1
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro StaticStruct("Char")
    static constant string BREAK = "\n"
    static constant string EXCLAMATION_MARK = "!"
    static constant string MINUS = "-"
    static constant string PERCENT = "%"
    static constant string PLUS = "+"
    static constant string QUOTE = "\""

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro StaticStruct("Code")
    static hashtable CACHE = InitHashtable()
    static trigger DUMMY_TRIGGER = CreateTrigger()
    static triggeraction DUMMY_TRIGGER_ACTION = null
    static trigger LIST_DUMMY_TRIGGER = CreateTrigger()

    static force DUMMY_FORCE
    static trigger array TO_RUN
    static integer TO_RUN_COUNT = ARRAY_EMPTY
    static integer TO_RUN_ITERATION

    static method GetId takes code self returns integer
        return GetHandleId(Condition(self))
    endmethod

    static method ClearRunList takes nothing returns nothing
        call TriggerClearActions(thistype.LIST_DUMMY_TRIGGER)
    endmethod

    static method GetThreadName takes nothing returns string
        if (GetTriggeringTrigger() == null) then
            return I2S(Timer.GetFromSelf(GetExpiredTimer())) + "; native " + I2S(GetHandleId(GetExpiredTimer())) + " (timer)"
        endif

        return I2S(Trigger.GetFromSelf(GetTriggeringTrigger())) + "; native " + I2S(GetHandleId(GetTriggeringTrigger())) + " (trigger) event: " + I2S(GetHandleId(GetTriggerEventId()))
    endmethod

    static method AddToRunList takes code self returns nothing
        local trigger dummyTrigger = CreateTrigger()

        set thistype.TO_RUN_COUNT = thistype.TO_RUN_COUNT + 1

        set thistype.TO_RUN[thistype.TO_RUN_COUNT] = dummyTrigger

        call TriggerAddCondition(dummyTrigger, Condition(self))

        set dummyTrigger = null
        //call TriggerAddAction(thistype.LIST_DUMMY_TRIGGER, self)
    endmethod

    static method RunList_Executed takes nothing returns nothing
        call TriggerEvaluate(thistype.TO_RUN[thistype.TO_RUN_ITERATION])

        set thistype.TO_RUN_ITERATION = thistype.TO_RUN_ITERATION + 1

        if (thistype.TO_RUN_ITERATION > thistype.TO_RUN_COUNT) then
            call PauseTimer(GetExpiredTimer())
        endif
    endmethod

    static method RunList takes nothing returns nothing
        set thistype.TO_RUN_ITERATION = ARRAY_MIN

        if (thistype.TO_RUN_COUNT > ARRAY_EMPTY) then
            call TimerStart(CreateTimer(), 0.5, true, function thistype.RunList_Executed)
        endif
        //call thistype.AddToRunList(function thistype.ClearRunList)

        //call TriggerExecute(thistype.LIST_DUMMY_TRIGGER)
    endmethod

    static method Run takes code self returns nothing
        if (thistype.DUMMY_TRIGGER_ACTION != null) then
            call TriggerRemoveAction(thistype.DUMMY_TRIGGER, thistype.DUMMY_TRIGGER_ACTION)
        endif

        set thistype.DUMMY_TRIGGER_ACTION = TriggerAddAction(thistype.DUMMY_TRIGGER, self)

        call TriggerExecuteWait(thistype.DUMMY_TRIGGER)
    endmethod

    static method onInit takes nothing returns nothing
        set thistype.DUMMY_FORCE = CreateForce()

        //call ForceAddPlayer(thistype.DUMMY_FORCE, Player(0))
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro StaticStruct("Integer")
    static method ToBoolean takes integer self returns boolean
        if (self > 0) then
            return true
        endif

        return false
    endmethod

    static method ToString takes integer self returns string
        return I2S(self)
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro Folder("Real")
    //! runtextmacro Struct("Event")
        //! textmacro Real_Event_CreateResponse takes var, func
            static real $var$

            static method Get$func$ takes nothing returns real
                return thistype.$var$
            endmethod

            static method Set$func$ takes real self returns nothing
                set thistype.$var$ = self
            endmethod
        //! endtextmacro

        //! runtextmacro Real_Event_CreateResponse("TRIGGER", "Trigger")
    endstruct
endscope

//! runtextmacro StaticStruct("Real")
    //! runtextmacro LinkToStaticStruct("Real", "Event")

    static method Case takes string whichString, boolean flag returns string
        return StringCase(whichString, flag)
    endmethod

    static method ToInt takes real self returns integer
        return R2I(self)
    endmethod

    static method ToIntString takes real self returns string
        return Integer.ToString(thistype.ToInt(self))
    endmethod

    static method ToPercentString takes real self returns string
        return (Integer.ToString(thistype.ToInt(self)) + Char.PERCENT)
    endmethod

    static method ToString takes real self returns string
        return R2S(self)
    endmethod

    static method ToStringWithDecimals takes real self, integer decimals returns string
        local integer iteration
        local string result
        local integer selfI

        if (self == 0.) then
            return ("0." + String.Repeat("0", decimals))
        endif

        set iteration = decimals
        set selfI = Real.ToInt(self)

        loop
            exitwhen (iteration < 1)

            set self = self * 10

            set iteration = iteration - 1
        endloop

        set result = Integer.ToString(Real.ToInt(self))

        set result = (Integer.ToString(selfI) + "." + String.SubRightByWidth(result, decimals))

        return result
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro Folder("String")
    //! runtextmacro Struct("Color")
        static constant string RESET = "|r"
        static constant string START = "|c"

        static constant string BLACK = "ff000000"
        static constant string BONUS = "ff00ff00"
        static constant string DWC = "ff00bfff"
        static constant string GOLD = "ffffcc00"
        static constant string GREEN = "ff00ff00"
        static constant string LUMBER = "ff00c850"
        static constant string MAGENTA = "ffff00ff"
        static constant string MALUS = "ffff0000"
        static constant string RED = "ffff0000"
        static constant string WHITE = "ffffffff"

        static method GetRedPartDec takes string value returns integer
            return Math.Hex.ToDec(SubString(value, 2, 4))
        endmethod

        static method GetGreenPartDec takes string value returns integer
            return Math.Hex.ToDec(SubString(value, 4, 6))
        endmethod

        static method GetBluePartDec takes string value returns integer
            return Math.Hex.ToDec(SubString(value, 6, 8))
        endmethod

        static method GetAlphaPartDec takes string value returns integer
            return Math.Hex.ToDec(SubString(value, 0, 2))
        endmethod

        static method HexToColorHex takes string value returns string
            return (String.If(String.Length(value) == String.MIN_LENGTH, Math.Hex.MAP[0]) + value)
        endmethod

        static method RelativeTo takes real red, real green, real blue, real alpha returns string
            local string result = thistype.HexToColorHex(Math.Hex.FromDec(Real.ToInt(alpha * 255.)))

            set result = result + thistype.HexToColorHex(Math.Hex.FromDec(Real.ToInt(red * 255.)))

            set result = result + thistype.HexToColorHex(Math.Hex.FromDec(Real.ToInt(green * 255.)))

            set result = result + thistype.HexToColorHex(Math.Hex.FromDec(Real.ToInt(blue * 255.)))

            return result
        endmethod

        static method GetFrom255 takes real red, real green, real blue, real alpha returns string
            return thistype.RelativeTo(red / 255., green / 255., blue / 255., alpha / 255.)
        endmethod

        static method Do takes string self, string value returns string
            if (value == null) then
                return self
            endif

            return (thistype.START + value + self + thistype.RESET)
        endmethod

        static method Gradient takes string self, string startValue, string endValue returns string
            local integer length = String.Length(self)
            local string result = ""

            local integer end = length - String.START - 1

            local integer endRed = thistype.GetRedPartDec(endValue)
            local integer endGreen = thistype.GetGreenPartDec(endValue)
            local integer endBlue = thistype.GetBluePartDec(endValue)
            local integer endAlpha = thistype.GetAlphaPartDec(endValue)

            local integer currentRed = endRed
            local integer currentGreen = endGreen
            local integer currentBlue = endBlue
            local integer currentAlpha = endAlpha

            local integer addRed = (thistype.GetRedPartDec(startValue) - endRed) / length
            local integer addGreen = (thistype.GetGreenPartDec(startValue) - endGreen) / length
            local integer addBlue = (thistype.GetBluePartDec(startValue) - endBlue) / length
            local integer addAlpha = (thistype.GetAlphaPartDec(startValue)- endAlpha) / length

            local integer iteration = end - 1

            loop
                exitwhen (iteration < String.START + 1)

                set currentRed = currentRed + addRed
                set currentGreen = currentGreen + addGreen
                set currentBlue = currentBlue + addBlue
                set currentAlpha = currentAlpha + addAlpha

                set result = thistype.Do(String.Sub(self, iteration, iteration), thistype.GetFrom255(currentRed, currentGreen, currentBlue, currentAlpha)) + result

                set iteration = iteration - 1
            endloop

            set result = thistype.Do(String.Sub(self, String.START, String.START), startValue) + result
            set result = result + thistype.Do(String.Sub(self, end, end), endValue)

            return result
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct
endscope

//! runtextmacro StaticStruct("String")
    static constant integer MIN_LENGTH = 1
    static constant integer START = 0

    //! runtextmacro LinkToStaticStruct("String", "Color")

    static method Case takes string self, boolean flag returns string
        return StringCase(self, flag)
    endmethod

    static method If takes boolean flag, string self returns string
        if (flag) then
            return self
        endif

        return ""
    endmethod

    static method IfElse takes boolean flag, string self, string self2 returns string
        if (flag) then
            return self
        endif

        return self2
    endmethod

    static method Length takes string self returns integer
        return StringLength(self)
    endmethod

    static method Sub takes string self, integer start, integer end returns string
        return SubString(self, start, end + thistype.MIN_LENGTH)
    endmethod

    static method SubLeft takes string self, integer end returns string
        return thistype.Sub(self, 0, end)
    endmethod

    static method SubRight takes string self, integer start returns string
        return thistype.Sub(self, start, thistype.Length(self) - thistype.MIN_LENGTH)
    endmethod

    static method Find takes string self, string value, integer index returns integer
        local integer iteration = -1
        local integer length = thistype.Length(self)
        local integer valueLength = thistype.Length(value)

        loop
            exitwhen (index < 0)

            set iteration = iteration + 1

            loop
                exitwhen (thistype.Sub(self, iteration, iteration + valueLength - thistype.MIN_LENGTH) == value)

                if (iteration == length) then
                    return -1
                endif

                set iteration = iteration + 1
            endloop

            set index = index - 1
        endloop

        return iteration
    endmethod

    static method Reduce takes string self returns string
        local integer index = thistype.Find(self, thistype.Color.START, 0)

        if (index != -1) then
            return thistype.Reduce(thistype.SubLeft(self, index - 1) + thistype.SubRight(self, index + thistype.Length(thistype.Color.START) + 8))
        endif

        set index = thistype.Find(self, thistype.Color.RESET, 0)

        if (index != -1) then
            return thistype.Reduce(thistype.SubLeft(self, index - 1) + thistype.SubRight(self, index + thistype.Length(thistype.Color.RESET)))
        endif

        return self
    endmethod

    static method Repeat takes string self, integer amount returns string
        local string result = ""

        loop
            exitwhen (amount < 1)

            set result = result + self

            set amount = amount - 1
        endloop

        return result
    endmethod

    static method Unfind takes string self, string value, integer index returns integer
        local integer iteration = -1
        local integer length = thistype.Length(self)
        local integer valueLength = thistype.Length(value)

        loop
            exitwhen (index < 0)

            set iteration = iteration + 1

            loop
                exitwhen (thistype.Sub(self, iteration, iteration + valueLength - thistype.MIN_LENGTH) != value)

                if (iteration == length) then
                    return -1
                endif

                set iteration = iteration + 1
            endloop

            set index = index - 1
        endloop

        return iteration
    endmethod

    static method SubRightByWidth takes string self, integer width returns string
        local integer length = thistype.Length(self) - thistype.MIN_LENGTH

        return thistype.Sub(self, length - width + 1, length)
    endmethod

    static method ToIntHash takes string self returns integer
        return StringHash(self)
    endmethod

    static method ToReal takes string self returns real
        return S2R(self)
    endmethod

    static method Word takes string self, integer index returns string
        local integer pos

        set pos = thistype.Unfind(self, " ", 0)

        set self = thistype.SubRight(self, pos)

        set pos = thistype.Find(self, " ", 0)

        if (index == 0) then
            return thistype.SubLeft(self, pos - 1)
        endif

        set index = index - 1

        loop
            set self = thistype.SubRight(self, pos)

            set pos = thistype.Unfind(self, " ", 0)

            set self = thistype.SubRight(self, pos)

            set pos = thistype.Find(self, " ", 0)

            if (index == 0) then
                return thistype.SubLeft(self, pos - 1)
            endif

            set index = index - 1
            exitwhen (index < 0)
        endloop

        return null
    endmethod

    static method Init takes nothing returns nothing
        call thistype.Color.Init()
    endmethod
endstruct

//! runtextmacro StaticStruct("Primitive")
    static method Init takes nothing returns nothing
        call Boolean.Init()
        call Char.Init()
        call Code.Init()
        call Integer.Init()
        call Real.Init()
        call String.Init()
    endmethod
endstruct