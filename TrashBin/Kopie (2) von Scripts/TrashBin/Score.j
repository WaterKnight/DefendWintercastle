//! runtextmacro Folder("Infoboard")
    //! runtextmacro Struct("User")
        //! runtextmacro GetKey("KEY")

        integer row

        static method GetRow takes User whichPlayer returns integer
            local thistype this = whichPlayer.GetId()

            return this.row
        endmethod

        static method SetRow takes User whichPlayer, integer row returns nothing
            local thistype this = whichPlayer.GetId()

            set this.row = row
        endmethod

        static method Update takes User whichPlayer returns nothing
            local Unit whichPlayerHero

            if (whichPlayer.SlotState.Get() != PlayerSlotState.EMPTY) then
                set whichPlayerHero = whichPlayer.Hero.Get()

                if (whichPlayerHero == NULL) then
                    call Infoboard.BOARD.SetValue(GetRow(whichPlayer), 1, "inactive")
                elseif (whichPlayerHero.Type.Is(UNIT.Type.DEAD)) then
                    call Infoboard.BOARD.SetValue(GetRow(whichPlayer), 1, "dead " + Real.ToIntString(HeroRevival(whichPlayerHero.Data.Integer.Get(HeroRevival.KEY)).ghost.Mana.Get()))// (" + Integer.ToString( Real.ToInt(HeroRevival.GetByWhichUnit(whichPlayerHero).durationTimer.GetRemaining()) ) + ")")
                else
                    call Infoboard.BOARD.SetValue(GetRow(whichPlayer), 1, "active")
                endif
            endif
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Score", "SCORE")
    static Multiboard BOARD = NULL
    static integer CURRENT_ROUND_ROW
    static integer LEVEL_ROW

    //! runtextmacro LinkToStruct("Score", "User")

    static method Event_HeroPick takes nothing returns nothing
        local User whichPlayer = USER.Event.GetTrigger()
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.Event.Add(DROP_EVENT)
        call whichUnit.Event.Add(MOVE_EVENT)
        call whichUnit.Event.Add(PICK_UP_EVENT)

        call thistype(NULL).User.Update(whichPlayer)
    endmethod

    static method Event_LevelStart takes nothing returns nothing
        local Level whichLevel = LEVEL.Event.GetTrigger()
        local boolean array flags
        local integer iteration = 0
        local integer iteration2

        if (whichLevel.IsBonus()) then
            call BOARD.SetValue(LEVEL_ROW, 1, "Level: " + whichLevel.GetBonusCaption())
        else
            call BOARD.SetValue(LEVEL_ROW, 1, "Level: " + I2S( whichLevel.GetIndex() + 1 ))
        endif
        loop
            if (whichLevel.GetIndex() <= Level.ALL_COUNT) then
                set iteration2 = 0

                set flags[0] = whichLevel.IsMelee()
                set flags[1] = whichLevel.IsRanged()
                set flags[2] = whichLevel.IsMagician()
                set flags[4] = whichLevel.IsInvis()
                set flags[5] = whichLevel.IsRunner()
                set flags[6] = whichLevel.IsMagicImmune()
                set flags[7] = whichLevel.IsKamikaze()
                set flags[8] = whichLevel.IsBoss()
                if (whichLevel.IsBoss()) then
                    call BOARD.SetIcon(CURRENT_ROUND_ROW + iteration, 0, QUESTION_MARK_PATH)
                elseif (whichLevel.IsBoss() and (iteration == 1)) then
                    call BOARD.SetIcon(CURRENT_ROUND_ROW + iteration, 0, QUESTION_MARK_PATH)
                else
                    call BOARD.SetIcon(CURRENT_ROUND_ROW + iteration, 0, whichLevel.GetIconPath())
                endif

                loop
                    exitwhen (iteration2 > 8)
                    if (flags[iteration2]) then
                        call BOARD.SetIcon(CURRENT_ROUND_ROW + iteration, 1 + iteration2, CHECK_PATH)
                    else
                        call BOARD.SetIcon(CURRENT_ROUND_ROW + iteration, 1 + iteration2, CROSS_PATH)
                    endif
                    if (iteration2 == 2) then
                        set iteration2 = iteration2 + 2
                    else
                        set iteration2 = iteration2 + 1
                    endif
                endloop
            endif

            set iteration = iteration + 1
            set whichLevel = whichLevel.GetNext()
            exitwhen (iteration > 1)
        endloop
    endmethod

    static method Event_ActStart takes nothing returns nothing
        local Act whichAct = ACT.Event.GetTrigger()

        if (whichAct.IsBonus()) then
            call BOARD.SetValue(LEVEL_ROW, 0, "Chapter: " + whichAct.GetBonusCaption())
        else
            call BOARD.SetValue(LEVEL_ROW, 0, "Chapter: " + Integer.ToString( whichAct.GetIndex() ))
        endif
    endmethod

    static method Event_AfterIntro takes nothing returns nothing
        if (USER.Event.GetTrigger().IsLocal()) then
        call BJDebugMsg("infoboard")
            call BOARD.Show()
        endif
    endmethod

    static method Event_Start takes nothing returns nothing
        local integer count
        local integer iteration = 0
        local integer iteration2
        local User specificPlayer
        local Unit specificPlayerHero
        local PlayerSlotState specificPlayerSlotState
        local string stringValue

        set BOARD = Multiboard.Create(-1, 13)

        set count = BOARD.GetRowCount() + 1
        call BOARD.SetRowCount(count)
        if (Meteorite.THIS_UNIT != NULL) then
            call BOARD.SetTitle(Meteorite.GetInfoboardTitle())
        endif
        call BOARD.SetValue(count, 0, String.Color.GOLD + "Players" + String.Color.RESET)
        call BOARD.SetWidth(count, 0, 0.06)
        call BOARD.SetValue(count, 1, String.Color.GOLD + "Status" + String.Color.RESET)
        call BOARD.SetWidth(count, 1, 0.04)
        call BOARD.SetValue(count, 2, String.Color.GOLD + "Items in Inventory" + String.Color.RESET)
        call BOARD.SetWidth(count, 2, 0.1)
        call BOARD.ColumnSpan.SetWidth(count, 3, BOARD.GetColumnCount(), 0.)

        set count = BOARD.GetRowCount() + 1
        call BOARD.SetRowCount(count)
        call BOARD.SetValue(count, 0, "=================================================")
        call BOARD.SetWidth(count, 0, 0.2)
        call BOARD.ColumnSpan.SetWidth(count, 1, BOARD.GetColumnCount(), 0.)

        set count = BOARD.GetRowCount() + 1

        loop
            exitwhen (iteration > User.MAX_HUMAN_ID)

            set specificPlayer = User.GetFromId(iteration)

            set specificPlayerSlotState = specificPlayer.SlotState.Get()

            if ( specificPlayerSlotState != PlayerSlotState.EMPTY ) then
                set iteration2 = MAX_INVENTORY_SIZE - 1
                set specificPlayerHero = specificPlayer.Hero.Get()
                call BOARD.SetRowCount(count)
                call BOARD.SetWidth(count, 0, 0.06)
                call BOARD.SetWidth(count, 1, 0.04)
                loop
                    call BOARD.SetWidth(count, 2 + iteration2 * 2, 0.007)
                    call BOARD.SetWidth(count, 2 + iteration2 * 2 + 1, 0.012)

                    set iteration2 = iteration2 - 1
                    exitwhen (iteration2 < 0)
                endloop
                //call BOARD.ColumnSpan.SetWidth(count, 2 + 6 * 2, BOARD.GetColumnCount(), 0.)
                call INFOBOARD.User.SetRow(specificPlayer, count)
                call INFOBOARD.User.Update(specificPlayer)
                if ( specificPlayerSlotState == PlayerSlotState.PLAYING ) then
                    set stringValue = specificPlayer.GetColorString()
                else
                    set stringValue = "|cff7F7F7F"
                endif

                call BOARD.SetValue(count, 0, stringValue + specificPlayer.GetName() + String.Color.RESET)

                set count = count + 1
            else
                call INFOBOARD.User.SetRow(specificPlayer, -1)
            endif
            set iteration = iteration + 1
        endloop

        set count = BOARD.GetRowCount() + 1

        call BOARD.SetRowCount(count)
        call BOARD.SetWidth(count, 0, 0.2)
        call BOARD.ColumnSpan.SetWidth(count, 1, BOARD.GetColumnCount(), 0.)

        set count = BOARD.GetRowCount() + 1
        call BOARD.SetRowCount(count)
        call BOARD.SetWidth(count, 0, 0.1)
        call BOARD.ColumnSpan.SetWidth(count, 1, 9, 0.01)
        call BOARD.SetIcon(count, 1, "ReplaceableTextures\\CommandButtons\\BTNOrcMeleeUpOne.blp")
        call BOARD.SetIcon(count, 2, "ReplaceableTextures\\CommandButtons\\BTNImprovedBows.blp")
        call BOARD.SetIcon(count, 3, "ReplaceableTextures\\CommandButtons\\BTNStaffOfNegation.blp")
        call BOARD.SetIcon(count, 5, "ReplaceableTextures\\CommandButtons\\BTNInvisibility.blp")
        call BOARD.SetIcon(count, 6, "ReplaceableTextures\\CommandButtons\\BTNBootsOfSpeed.blp")
        call BOARD.SetIcon(count, 7, "ReplaceableTextures\\CommandButtons\\BTNGenericSpellImmunity.blp")
        call BOARD.SetIcon(count, 8, "ReplaceableTextures\\CommandButtons\\BTNSelfDestruct.blp")
        call BOARD.SetIcon(count, 9, "ReplaceableTextures\\CommandButtons\\BTNReincarnation.blp")
        call BOARD.ColumnSpan.SetWidth(count, 10, BOARD.GetColumnCount(), 0.)

        set count = BOARD.GetRowCount() + 1

        set CURRENT_ROUND_ROW = count
        call BOARD.SetRowCount(count)
        call BOARD.SetValue(count, 0, "This round")
        call BOARD.SetWidth(count, 0, 0.1)
        call BOARD.ColumnSpan.SetWidth(count, 1, 8, 0.01)
        call BOARD.ColumnSpan.SetWidth(count, 9, BOARD.GetColumnCount(), 0.)

        set count = BOARD.GetRowCount() + 1

        call BOARD.SetRowCount(count)
        call BOARD.SetValue(count, 0, "Next round")
        call BOARD.SetWidth(count, 0, 0.1)
        call BOARD.ColumnSpan.SetWidth(count, 1, 8, 0.01)
        call BOARD.ColumnSpan.SetWidth(count, 9, BOARD.GetColumnCount(), 0.)

        set count = BOARD.GetRowCount() + 1

        call BOARD.SetRowCount(count)

        set count = BOARD.GetRowCount() + 1

        set LEVEL_ROW = count
        call BOARD.SetRowCount(count)
        call BOARD.SetValue(count, 0, "Chapter: " + Integer.ToString( Act.CURRENT.GetIndex() + 1 ))
        call BOARD.SetWidth(count, 0, 0.1)
        call BOARD.SetValue(count, 1, "Level: " + Integer.ToString( Level.CURRENT.GetIndex() + 1 ))
        call BOARD.SetWidth(count, 1, 0.1)

        set count = BOARD.GetRowCount() + 1

        call BOARD.SetRowCount(count)
        call BOARD.SetValue(count, 0, "=================================================")
        call BOARD.SetWidth(count, 0, 0.2)
        call BOARD.ColumnSpan.SetWidth(count, 1, BOARD.GetColumnCount(), 0.)

        set CHARGES_CHANGE_EVENT = Event.Create(ITEM.ChargesAmount.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ChargesChange)
        set DROP_EVENT = Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Drop)
        set MOVE_EVENT = Event.Create(UNIT.Items.Events.MoveInInventory.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Move)
        set PICK_UP_EVENT = Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_PickUp)
        call Event.Create(Act.START_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ActStart).AddToStatics()
        call Event.Create(AfterIntro.FOR_PLAYER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_AfterIntro).AddToStatics()
        call Event.Create(HeroSelection.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_HeroPick).AddToStatics()
        call Event.Create(Level.START_EVENT_TYPE, EventPriority.MISC2, function thistype.Event_LevelStart).AddToStatics()
    endmethod

    static method Init takes nothing returns nothing
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
    endmethod
endstruct