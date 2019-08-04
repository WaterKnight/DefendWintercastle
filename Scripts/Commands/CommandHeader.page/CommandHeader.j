//! runtextmacro BaseStruct("CommandHeader", "COMMAND_HEADER")
    //! runtextmacro GetKey("KEY")

    Trigger action

    condEventMethod Conditions
        local string input = params.String.GetChat()
        local string match = params.String.GetMatch()

        local boolean result = (String.Word(input, 0) == match)

        local string array args
        local integer argsC
        local string argsLine

        if result then
            set argsC = 0
            set argsLine = null

            loop
                exitwhen (String.Word(input, argsC + 1) == null)

                set argsC = argsC + 1
                set args[ARRAY_EMPTY + argsC] = String.Word(input, argsC)

                if (argsC == 1) then
                    set argsLine = args[ARRAY_EMPTY + argsC]
                else
                    set argsLine = argsLine + " " + args[ARRAY_EMPTY + argsC]
                endif
            endloop

            if (argsLine == null) then
                call InfoEx("execute " + match)
            else
                call InfoEx("execute " + match + " with " + argsLine)
            endif
        endif

        return result
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()

        local thistype this = StringData.Data.Integer.Get(params.String.GetMatch(), thistype.KEY)

        local integer repeatTokenPos = String.Find(input, "^", 0)

        if (repeatTokenPos != String.INVALID_INDEX) then
            local integer repeats = String.ToIntWithInvalid(String.SubRight(input, repeatTokenPos + 1), 0)

            call params.String.SetChat(String.SubLeft(input, repeatTokenPos - 1))

            call InfoEx("repeat " + I2S(repeats) + ": " + input)

            loop
                exitwhen (repeats < 1)

                call this.action.RunWithParams(params)

                set repeats = repeats - 1
            endloop

            return
        endif

        call this.action.Run()
    endmethod

    static method RegisterEvent takes string input, code actionFunc returns nothing
        local thistype this = thistype.allocate()

        local Event whichEvent = Event.Create(User.CHAT_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Chat)

        set this.action = Trigger.GetFromCode(actionFunc)
        call StringData.Data.Integer.Set(input, thistype.KEY, this)

        call whichEvent.SetConditions(BoolExpr.GetFromFunction(function thistype.Conditions))

        call StringData.Event.Add(input, whichEvent)
    endmethod
endstruct