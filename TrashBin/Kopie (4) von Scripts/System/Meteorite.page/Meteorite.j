//! runtextmacro BaseStruct("Meteorite", "METEORITE")
    static constant string CAST_EFFECT_ATTACH_POINT = AttachPoint.ORIGIN
    static constant string CAST_EFFECT_PATH = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl"
    static Timer DELAY_TIMER
    static boolean GAME_OVER
    static EventType GAME_OVER_EVENT_TYPE
    static real LAST_LIFE_AMOUNT
    static Event LIFE_EVENT
    static constant real MAX_LIFE_FACTOR = 0.5
    static constant real SCALE_FACTOR_MIN = 0.4
    static Unit THIS_UNIT = NULL
    static UnitType THIS_UNIT_TYPE
    static Announcement WARNING_ANNOUNCEMENT
    static Sound WARNING_SOUND

    static method GameOver_TriggerEvents takes nothing returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local integer priority

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = Event.CountAtStatics(thistype.GAME_OVER_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.SetSubjectId(0)

                call Event.GetFromStatics(thistype.GAME_OVER_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    static method Defeat takes nothing returns nothing
        local string array captions
        local string captionResult
        local integer iteration = 0
        local CineFilter newCineFilter = CineFilter.Create()
        local Dialog newDialog = Dialog.Create()

        set captions[0] = "Leave this grim place"
        set captions[1] = "I can see the light"
        set captions[2] = "It's too late"
        set captions[3] = "The world descends into eternal ice"
        set captions[4] = "Eternal fail shall befall you"
        set thistype.GAME_OVER = true

        loop
            exitwhen (iteration > User.MAX_HUMAN_INDEX)

            if (User.GetLocal() == User.ALL[iteration]) then
                set captionResult = captions[Math.RandomI(0, 4)]
            endif

            set iteration = iteration + 1
        endloop

        call DialogButton.Create(newDialog, "I am okay with that", 0)
        call newDialog.SetTitle("Wintercastle has fallen!")

        call DialogButton.CreateQuit(newDialog, true, captionResult, 0)

        call newDialog.Display(User.ANY, true)

        call newCineFilter.SetColorEnd(0, 128, 128, Real.ToInt(0.3 * 255))
        call newCineFilter.SetTexture("ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp")

        call newCineFilter.Start(10., User.ANY)

        call thistype.GameOver_TriggerEvents()
    endmethod

    static method Event_Death takes nothing returns nothing
        call thistype.Defeat()
    endmethod

    static method GetInfoboardTitle takes nothing returns string
        local real relativeLife = thistype.THIS_UNIT.Life.Get() * 100. / thistype.THIS_UNIT.MaxLife.GetAll()
        local string result = "Meteorite is at: "

        if (relativeLife < 0.25) then
            set result = result + String.Color.MALUS
        endif

        return (result + Integer.ToString(Real.ToInt(relativeLife)) + Char.PERCENT)
    endmethod

    static method Update takes nothing returns nothing
        local real lastLifeAmount = thistype.LAST_LIFE_AMOUNT
        local real lifeAmount = thistype.THIS_UNIT.Life.Get()
        local real relativeLife

        local boolean damaged = (lifeAmount < lastLifeAmount)

        if (damaged) then
            call thistype.THIS_UNIT.Event.Remove(LIFE_EVENT)

            call thistype.THIS_UNIT.MaxLife.Subtract((lastLifeAmount - lifeAmount) * thistype.MAX_LIFE_FACTOR)

            call thistype.THIS_UNIT.Event.Add(LIFE_EVENT)
        endif

        set relativeLife = lifeAmount / thistype.THIS_UNIT.MaxLife.GetAll()

        set thistype.LAST_LIFE_AMOUNT = lifeAmount
        if (Infoboard.THIS_BOARD != NULL) then
            call Infoboard.THIS_BOARD.SetTitle(thistype.GetInfoboardTitle())
            call thistype.THIS_UNIT.VertexColor.Set(255., relativeLife * 255., relativeLife * 255., 255.)
        endif

        call thistype.THIS_UNIT.Scale.Set(thistype.THIS_UNIT_TYPE.Scale.Get() * ((1. - thistype.SCALE_FACTOR_MIN) * relativeLife + thistype.SCALE_FACTOR_MIN))

        if (damaged) then
            //call Game.DisplayTextTimed(User.ANY, String.Color.MALUS + "Warning:" + String.Color.RESET + " The meteorite is under attack (" + String.Color.GOLD + Real.ToIntString(relativeLife * 100.) + Char.PERCENT + String.Color.RESET + " of " + String.Color.GOLD + Real.ToIntString(thistype.THIS_UNIT.MaxLife.GetAll()) + String.Color.RESET + " hitpoints left)", 10.)
            call thistype.WARNING_ANNOUNCEMENT.StartTimed(5.)
            //if (relativeLife < 0.35) then
                call thistype.WARNING_SOUND.Play()
            //endif
        endif
    endmethod

    static method Event_Cast takes nothing returns nothing
        call UNIT.Event.GetTrigger().Effects.Create(thistype.CAST_EFFECT_PATH, thistype.CAST_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()
    endmethod

    static method Event_Damage takes nothing returns nothing
        local Unit damager = UNIT.Event.GetDamager()

        if (damager.Abilities.GetLevel(MeteoriteProtection.THIS_SPELL) == 0) then
            call damager.Kill()
        endif
    endmethod

    static method Event_Life takes nothing returns nothing
        call thistype.Update()
    endmethod

    static method Event_Create takes nothing returns nothing
        set thistype.LIFE_EVENT = Event.Create(UNIT.Life.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Life)
        set thistype.THIS_UNIT = UNIT.Event.GetTrigger()
        set thistype.WARNING_ANNOUNCEMENT = Announcement.Create(10)
        set thistype.WARNING_SOUND = Sound.Create("Sound\\Interface\\Warning.wav", false, false, false, 10, 10, SoundEax.DEFAULT)

        set thistype.LAST_LIFE_AMOUNT = THIS_UNIT.Life.Get()
        call thistype.THIS_UNIT.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Cast))
        call thistype.THIS_UNIT.Event.Add(Event.Create(UNIT.Damage.Events.TARGET_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Damage))
        call thistype.THIS_UNIT.Event.Add(Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death))
        call thistype.THIS_UNIT.Event.Add(LIFE_EVENT)

        if (Infoboard.THIS_BOARD != NULL) then
            call Infoboard.THIS_BOARD.SetTitle(Meteorite.GetInfoboardTitle())
        endif
        call thistype.THIS_UNIT.Classes.Add(UnitClass.UNDECAYABLE)
        call thistype.WARNING_SOUND.SetVolume(0.5)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.GAME_OVER = false
        set thistype.GAME_OVER_EVENT_TYPE = EventType.Create()
        set thistype.THIS_UNIT_TYPE = UnitType.METEORITE

        call thistype.THIS_UNIT_TYPE.Event.Add(Event.Create(Unit.CREATE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Create))
    endmethod
endstruct