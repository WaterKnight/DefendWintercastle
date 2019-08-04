//! runtextmacro Folder("TextTag")
    //! runtextmacro Struct("Position")
        boolean centered
        real x
        real y
        real z

        method GetX takes nothing returns real
            return this.x
        endmethod

        method SetIgnoreFloor takes real x, real y, real z returns nothing
            if (this.centered) then
                set x = x - String.Length(TextTag(this).Text.reducedValue) / 2 * 16.5//3.25
            endif

            call SetTextTagPos(TextTag(this).self, x, y, z - Spot.GetHeight(x, y))
        endmethod

        method SetX takes real x returns nothing
            set this.x = x
            call this.SetIgnoreFloor(this.x, this.y, z)
        endmethod

        method AddX takes real x returns nothing
            call this.SetX(this.GetX() + x)
        endmethod

        method GetY takes nothing returns real
            return this.y
        endmethod

        method SetY takes real y returns nothing
            set this.y = y
            call this.SetIgnoreFloor(this.x, this.y, z)
        endmethod

        method AddY takes real y returns nothing
            call this.SetY(this.GetY() + y)
        endmethod

        method GetZ takes nothing returns real
            return this.z
        endmethod

        method SetZ takes real z returns nothing
            set this.z = z
            call this.SetIgnoreFloor(this.x, this.y, z)
        endmethod

        method AddZ takes real z returns nothing
            call this.SetZ(this.GetZ() + z)
        endmethod

        method Set takes real x, real y, real z returns nothing
            set this.x = x
            set this.y = y
            set this.z = z
            call this.SetIgnoreFloor(x, y, z)
        endmethod

        method Add takes real x, real y, real z returns nothing
            call this.Set(this.GetX() + x, this.GetY() + y, this.GetZ() + z)
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.x, this.y, this.z)
        endmethod

        method SetCentered takes nothing returns nothing
            set this.centered = true

            call this.Update()
        endmethod

        method Event_Create takes nothing returns nothing
            set this.centered = false

            call this.Set(0., 0., 0.)
        endmethod
    endstruct

    //! runtextmacro Struct("Text")
        real fontSize
        string reducedValue
        string value

        method Set takes string text, real fontSize returns nothing
            set this.fontSize = fontSize
            set reducedValue = String.Reduce(text)
            set this.value = text
            call SetTextTagText(TextTag(this).self, text, fontSize)

            call TextTag(this).Position.Update()
        endmethod

        method SetFontSize takes real value returns nothing
            set this.fontSize = value
            call SetTextTagText(TextTag(this).self, this.value, value)
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = ""
        endmethod
    endstruct

    //! runtextmacro Struct("CreateJumping")
        static constant real DURATION = 1.5
        static constant real FONT_SIZE_FACTOR_BONUS_END = 0.
        static constant real FONT_SIZE_FACTOR_BONUS_PEAK = 0.25
        static constant real FONT_SIZE_FACTOR_START = 1.
        static constant real SPEED = 20.
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")
        static Timer UPDATE_TIMER
        static constant real Z_BONUS_END = 25.
        static constant real Z_BONUS_PEAK = 100.

        static constant real FONT_SIZE_FACTOR_BONUS_PEAK_PER_DURATION = thistype.FONT_SIZE_FACTOR_BONUS_PEAK / thistype.DURATION
        static constant real Z_BONUS_PEAK_PER_DURATION = thistype.Z_BONUS_PEAK / thistype.DURATION

        static constant real FONT_SIZE_FACTOR_SPEED = 2 / thistype.DURATION * (thistype.FONT_SIZE_FACTOR_BONUS_PEAK + SquareRoot(thistype.FONT_SIZE_FACTOR_BONUS_PEAK * (thistype.FONT_SIZE_FACTOR_BONUS_PEAK - thistype.FONT_SIZE_FACTOR_BONUS_END)))
        static constant real Z_SPEED = 2 / thistype.DURATION * (thistype.Z_BONUS_PEAK + SquareRoot(thistype.Z_BONUS_PEAK * (thistype.Z_BONUS_PEAK - thistype.Z_BONUS_END)))

        static constant real FONT_SIZE_FACTOR_ACCELERATION = -0.5 * thistype.FONT_SIZE_FACTOR_SPEED * thistype.FONT_SIZE_FACTOR_SPEED / thistype.FONT_SIZE_FACTOR_BONUS_PEAK
        static constant real Z_ACCELERATION = -0.5 * thistype.Z_SPEED * thistype.Z_SPEED / thistype.Z_BONUS_PEAK

        Timer durationTimer
        real fontSizeFactor
        real fontSizeFactorAdd
        real fontSizeFactorAddAdd
        real fontSizeStart
        boolean running
        real xAdd
        real yAdd
        real zAdd
        real zAddAdd

        method Ending takes Timer durationTimer returns nothing
            set this.running = false
            call durationTimer.Destroy()

            if (this.RemoveFromList()) then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        method EndingByParent takes nothing returns nothing
            if (this.running) then
                call this.Ending(this.durationTimer)
            endif
        endmethod

        static method EndingByTimer takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            call this.Ending(durationTimer)

            call TextTag(this).Destroy()
        endmethod

        static method Move takes nothing returns nothing
            local integer iteration = thistype.ALL_COUNT
            local thistype this
            local real zAdd

            loop
                set this = thistype.ALL[iteration]

                set fontSizeFactorAdd = this.fontSizeFactorAdd + this.fontSizeFactorAddAdd
                set zAdd = this.zAdd + this.zAddAdd

                set fontSizeFactor = this.fontSizeFactor + fontSizeFactorAdd

                set this.fontSizeFactor = fontSizeFactor
                set this.fontSizeFactorAdd = fontSizeFactorAdd
                set this.zAdd = zAdd
                call TextTag(this).Position.Add(this.xAdd, this.yAdd, zAdd)
                call TextTag(this).Text.SetFontSize(fontSizeFactor * this.fontSizeStart)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        static method Create takes string text, real fontSize, real x, real y, real z, integer id returns TextTag
            local real angle
            local Timer durationTimer
            local TextTag parent
            local thistype this

            set parent = TextTag.Create(id)

            if (parent == NULL) then
                return NULL
            endif

            set angle = Math.RandomAngle()
            set durationTimer = Timer.Create()
            set this = parent

            set this.fontSizeFactor = thistype.FONT_SIZE_FACTOR_START
            set this.fontSizeFactorAdd = thistype.FONT_SIZE_FACTOR_SPEED * thistype.UPDATE_TIME
            set this.fontSizeFactorAddAdd = thistype.FONT_SIZE_FACTOR_ACCELERATION * thistype.UPDATE_TIME * thistype.UPDATE_TIME
            set this.fontSizeStart = fontSize
            set this.xAdd = Math.Cos(angle) * thistype.SPEED * thistype.UPDATE_TIME
            set this.yAdd = Math.Sin(angle) * thistype.SPEED * thistype.UPDATE_TIME
            set this.zAdd = thistype.Z_SPEED * thistype.UPDATE_TIME
            set this.zAddAdd = thistype.Z_ACCELERATION * thistype.UPDATE_TIME * thistype.UPDATE_TIME
            set this.durationTimer = durationTimer
            set this.running = true
            call durationTimer.SetData(this)

            call parent.Position.Set(x, y, z)
            //            call parent.SetLifeSpan(thistype.DURATION + 0.01)
            call parent.SetPermanent(false)
            call parent.Text.Set(text, fontSize)

            if (this.AddToList()) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Move)
            endif

            call durationTimer.Start(thistype.DURATION, false, function thistype.EndingByTimer)

            return parent
        endmethod

        static method Init takes nothing returns nothing
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("CreateMoving")
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        real bonusXPerInterval
        real bonusYPerInterval
        real bonusZPerInterval
        Timer durationTimer
        boolean running

        method Ending takes Timer durationTimer returns nothing
            set this.running = false
            call durationTimer.Destroy()

            if (this.RemoveFromList()) then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        method EndingByParent takes nothing returns nothing
            if (this.running) then
                call this.Ending(this.durationTimer)
            endif
        endmethod

        static method EndingByTimer takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            call this.Ending(durationTimer)

            call TextTag(this).Destroy()
        endmethod

        static method Move takes nothing returns nothing
            local integer iteration = thistype.ALL_COUNT
            local thistype this

            loop
                set this = thistype.ALL[iteration]

                call TextTag(this).Position.Add(this.bonusXPerInterval, this.bonusYPerInterval, this.bonusZPerInterval)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        static method Create takes string text, real fontSize, real x, real y, real z, real speedX, real speedY, real speedZ, real fadePoint, real duration, integer id returns TextTag
            local Timer durationTimer
            local TextTag parent
            local thistype this

            if (duration == 0.) then
                return NULL
            endif

            set parent = TextTag.Create(id)

            if (parent == NULL) then
                return NULL
            endif

            set durationTimer = Timer.Create()
            set this = parent

            set this.bonusXPerInterval = speedX * thistype.UPDATE_TIME
            set this.bonusYPerInterval = speedY * thistype.UPDATE_TIME
            set this.bonusZPerInterval = speedZ * thistype.UPDATE_TIME
            set this.durationTimer = durationTimer
            set this.running = true
            call durationTimer.SetData(this)

            call parent.Position.Set(x, y, z)
            //            call parent.SetLifeSpan(duration + 0.01)
            call parent.SetPermanent(false)
            call parent.Text.Set(text, fontSize)

            if (this.AddToList()) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Move)
            endif

            call durationTimer.Start(duration, false, function thistype.EndingByTimer)

            return parent
        endmethod

        static method Init takes nothing returns nothing
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("CreateRising")
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        real bonusZPerInterval
        Timer durationTimer
        boolean running

        method Ending takes Timer durationTimer returns nothing
            set this.running = false
            call durationTimer.Destroy()

            if (this.RemoveFromList()) then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        method EndingByParent takes nothing returns nothing
            if (this.running) then
                call this.Ending(this.durationTimer)
            endif
        endmethod

        static method EndingByTimer takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            call this.Ending(durationTimer)

            call TextTag(this).Destroy()
        endmethod

        static method Move takes nothing returns nothing
            local integer iteration = thistype.ALL_COUNT
            local thistype this

            loop
                set this = thistype.ALL[iteration]

                call TextTag(this).Position.AddZ(this.bonusZPerInterval)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        static method Create takes string text, real fontSize, real x, real y, real z, real speedZ, real fadePoint, real duration, integer id returns TextTag
            local Timer durationTimer
            local TextTag parent
            local thistype this

            if (duration == 0.) then
                return NULL
            endif

            set parent = TextTag.Create(id)

            if (parent == NULL) then
                return NULL
            endif

            set durationTimer = Timer.Create()
            set this = parent

            set this.bonusZPerInterval = speedZ * thistype.UPDATE_TIME
            set this.durationTimer = durationTimer
            set this.running = true
            call durationTimer.SetData(this)

            call parent.Position.Set(x, y, z)
            call parent.SetFadePoint(fadePoint)
            //            call parent.SetLifeSpan(duration + 0.01)
            call parent.SetPermanent(false)
            call parent.Text.Set(text, fontSize)

            if (this.AddToList()) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Move)
            endif

            call durationTimer.Start(duration, false, function thistype.EndingByTimer)

            return parent
        endmethod

        static method Init takes nothing returns nothing
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("TextTag", "TEXT_TAG")
    static integer ALL_AMOUNT = 0
    //! runtextmacro GetKey("PARENT_KEY")
    static real STANDARD_SIZE = 0.023

    integer id
    texttag self

    //! runtextmacro LinkToStruct("TextTag", "CreateJumping")
    //! runtextmacro LinkToStruct("TextTag", "CreateMoving")
    //! runtextmacro LinkToStruct("TextTag", "CreateRising")
    //! runtextmacro LinkToStruct("TextTag", "Position")
    //! runtextmacro LinkToStruct("TextTag", "Text")

    //! runtextmacro CreateAnyState("value", "Value", "real")

    static method GetFreeId takes nothing returns integer
        return 0
    endmethod

    static method GetFromId takes integer id returns thistype
        return Memory.IntegerKeys.GetInteger(PARENT_KEY, id)
    endmethod

    method Destroy takes nothing returns nothing
        local integer id = this.id
        local texttag self = this.self

        set thistype.ALL_AMOUNT = thistype.ALL_AMOUNT - 1
        call this.CreateJumping.EndingByParent()
        call this.CreateMoving.EndingByParent()
        call this.CreateRising.EndingByParent()

        call this.deallocate()
        call DestroyTextTag(self)
        call Memory.IntegerKeys.RemoveInteger(PARENT_KEY, id)

        set self = null
    endmethod

    method SetFadePoint takes real value returns nothing
        call SetTextTagFadepoint(this.self, value)
    endmethod

    method SetLifeSpan takes real value returns nothing
        call SetTextTagLifespan(this.self, value)
    endmethod

    method SetPermanent takes boolean flag returns nothing
        call SetTextTagPermanent(this.self, flag)
    endmethod

    method LimitTextTagVisibilityToPlayer takes player whichPlayer returns nothing
        call SetTextTagVisibility(this.self, (GetLocalPlayer() == whichPlayer))
    endmethod

    static method Create takes integer id returns thistype
        local thistype this

        if ((id != 0) and (Memory.IntegerKeys.GetInteger(PARENT_KEY, id) != NULL)) then
            return NULL
            //call thistype(Memory.IntegerKeys.GetInteger(PARENT_KEY, id)).Destroy()
        endif

        if (thistype.ALL_AMOUNT == 100) then
            call Bug.Print(thistype.Create.name + ": limit exceeded")

            return NULL
        endif

        set this = thistype.allocate()
        set thistype.ALL_AMOUNT = thistype.ALL_AMOUNT + 1

        set this.id = id
        set this.self = CreateTextTag()
        call Memory.IntegerKeys.SetInteger(PARENT_KEY, id, this)

        call this.Text.Event_Create()

        call this.Position.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        call thistype(NULL).CreateJumping.Init()
        call thistype(NULL).CreateMoving.Init()
        call thistype(NULL).CreateRising.Init()
    endmethod
endstruct