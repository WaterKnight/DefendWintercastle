//! runtextmacro Folder("Infoboard")
    //! runtextmacro Struct("User")
        //! runtextmacro GetKey("KEY")

        integer row

        static method GetRow takes User whichPlayer returns integer
            local thistype this = whichPlayer

            return this.row
        endmethod

        static method SetRow takes User whichPlayer, integer row returns nothing
            local thistype this = whichPlayer

            set this.row = row
        endmethod

        static method Update takes User whichPlayer returns nothing
            local Unit whichPlayerHero

            if (whichPlayer.SlotState.Get() != PlayerSlotState.EMPTY) then
                set whichPlayerHero = whichPlayer.Hero.Get()

                if (whichPlayerHero == NULL) then
                    call Infoboard.THIS_BOARD.SetValue(GetRow(whichPlayer), 1, "inactive")
                elseif whichPlayerHero.Classes.Contains(UnitClass.DEAD) then
                    call Infoboard.THIS_BOARD.SetValue(GetRow(whichPlayer), 1, "dead " + Real.ToIntString(HeroRevival(whichPlayerHero.Data.Integer.Get(HeroRevival.KEY)).ghost.Mana.Get()))// (" + Integer.ToString( Real.ToInt(HeroRevival.GetByWhichUnit(whichPlayerHero).durationTimer.GetRemaining()) ) + ")")
                else
                    call Infoboard.THIS_BOARD.SetValue(GetRow(whichPlayer), 1, "active")
                endif
            endif
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Infoboard", "INFOBOARD")
    static Event CHARGES_CHANGE_EVENT
    static constant string CHECK_PATH = "ReplaceableTextures\\WorldEditUI\\Editor-Ally-HighPriority.blp"
    static constant string CROSS_PATH = "ReplaceableTextures\\WorldEditUI\\Editor-Ally-NoPriority.blp"
    static Event DROP_EVENT
    static Event MOVE_EVENT
    static Event PICK_UP_EVENT
    static constant string QUESTION_MARK_PATH = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOff.blp"

    static integer PLAYERS_COLUMN
    static integer STATUS_COLUMN
    static integer ITEMS_COLUMN

    static integer CHAPTER_ROW
    static integer CURRENT_ROUND_ROW
    static integer LEVEL_ROW

    static Multiboard THIS_BOARD = NULL

    //! runtextmacro LinkToStruct("Infoboard", "User")

    static method AttachItem takes Item whichItem, integer whichSlot, Unit whichUnit returns nothing
        local integer chargesAmount = whichItem.ChargesAmount.Get()
        local integer row = thistype(NULL).User.GetRow(whichUnit.Owner.Get())

        if (chargesAmount > 0) then
            call thistype.THIS_BOARD.SetValue(row, thistype.ITEMS_COLUMN + whichSlot * 2, Integer.ToString(chargesAmount))
        endif

        call thistype.THIS_BOARD.SetIcon(row, thistype.ITEMS_COLUMN + whichSlot * 2 + 1, whichItem.Type.Get().GetIcon())
    endmethod

    static method DettachItem takes Item whichItem, integer whichSlot, Unit whichUnit returns nothing
        local integer row = thistype(NULL).User.GetRow(whichUnit.Owner.Get())

        call thistype.THIS_BOARD.SetIcon(row, thistype.ITEMS_COLUMN + whichSlot * 2 + 1, null)
        call thistype.THIS_BOARD.SetValue(row, thistype.ITEMS_COLUMN + whichSlot * 2, null)
    endmethod

    eventMethod Event_ChargesChange
        local Item whichItem = params.Item.GetTrigger()
        local Unit whichUnit = params.Unit.GetTrigger()

        call thistype.AttachItem(whichItem, whichUnit.Items.GetSlot(whichItem), whichUnit)
    endmethod

    eventMethod Event_Drop
        local Item whichItem = params.Item.GetTrigger()

        if not whichItem.Event.Contains(CHARGES_CHANGE_EVENT) then
            return
        endif

        call thistype.DettachItem(whichItem, params.Item.GetTriggerSlot(), params.Unit.GetTrigger())
        call whichItem.Event.Remove(CHARGES_CHANGE_EVENT)
    endmethod

    eventMethod Event_Move
        local Item targetItem = params.Item.GetTarget()
        local integer targetSlot = params.Item.GetTargetSlot()
        local Item whichItem = params.Item.GetTrigger()
        local integer whichSlot = params.Item.GetTriggerSlot()
        local Unit whichUnit = params.Unit.GetTrigger()

        call thistype.AttachItem(whichItem, targetSlot, whichUnit)
        if (targetItem == NULL) then
            call thistype.DettachItem(whichItem, whichSlot, whichUnit)
        else
            call thistype.AttachItem(targetItem, whichSlot, whichUnit)
        endif
    endmethod

    eventMethod Event_PickUp
        local Item whichItem = params.Item.GetTrigger()

		call whichItem.Event.Add(CHARGES_CHANGE_EVENT)

        call thistype.AttachItem(whichItem, params.Item.GetTriggerSlot(), params.Unit.GetTrigger())
    endmethod

    eventMethod Event_HeroPick
        local User whichPlayer = params.User.GetTrigger()
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.Event.Add(DROP_EVENT)
        call whichUnit.Event.Add(MOVE_EVENT)
        call whichUnit.Event.Add(PICK_UP_EVENT)

        call thistype(NULL).User.Update(whichPlayer)
    endmethod

    static method GetLevelString takes nothing returns string
    	local Level curLevel = Level.CURRENT
        local string result = "Level: "

        if (curLevel == NULL) then
            return result
        endif

        if curLevel.IsBonus() then
            return result + curLevel.GetName()
        endif

        local Act curAct = Act.CURRENT

        if (curAct == NULL) then
            return result
        endif

        local integer count = 0
        local integer iteration = Memory.IntegerKeys.Table.STARTED

        loop
            exitwhen (iteration > curAct.LevelSets.Count())

            if (iteration > Memory.IntegerKeys.Table.STARTED) then
                set result = result + " | "
            endif

            local LevelSet whichSet = curAct.LevelSets.Get(iteration)
            local string whichSetString = ""

            local integer iteration2 = Memory.IntegerKeys.Table.STARTED

            loop
                exitwhen (iteration2 > whichSet.Levels.Count())

                local Level whichLevel = whichSet.Levels.Get(iteration2)

				local string add

                if SpawnWave.GetFromLevel(whichLevel).IsBoss() then
                    set add = "Boss"
                else
                    set add = Integer.ToString(count + 1)
                endif

                if (whichLevel == curLevel) then
                    set add = String.Color.Do(add, String.Color.BONUS)
                endif

                if (whichSetString == "") then
                    set whichSetString = whichSetString + add
                else
                    set whichSetString = whichSetString + " - " + add
                endif

                set count = count + 1

                set iteration2 = iteration2 + 1
            endloop

            set result = result + whichSetString

            set iteration = iteration + 1
        endloop

        return result
    endmethod

    eventMethod Event_LevelStart
        local Level whichLevel = params.Level.GetTrigger()

        call thistype.THIS_BOARD.SetValue(thistype.LEVEL_ROW, thistype.PLAYERS_COLUMN, thistype.GetLevelString())

		local integer iteration = 0

        loop
            if (whichLevel.GetIndex() <= Level.ALL_COUNT) then
                local SpawnWave whichWave = SpawnWave.GetFromLevel(whichLevel)

                if (whichWave == NULL) then
                    return
                endif

				local boolean array flags

                set flags[0] = whichWave.IsMelee()
                set flags[1] = whichWave.IsRanged()
                set flags[2] = whichWave.IsMagician()
                set flags[4] = whichWave.IsInvis()
                set flags[5] = whichWave.IsRunner()
                set flags[6] = whichWave.IsMagicImmune()
                set flags[7] = whichWave.IsKamikaze()
                set flags[8] = whichWave.IsBoss()

                if whichWave.IsBoss() then
                    call thistype.THIS_BOARD.SetIcon(thistype.CURRENT_ROUND_ROW + iteration, thistype.PLAYERS_COLUMN, thistype.QUESTION_MARK_PATH)
                elseif (whichWave.IsBoss() and (iteration == 1)) then
                    call thistype.THIS_BOARD.SetIcon(thistype.CURRENT_ROUND_ROW + iteration, thistype.PLAYERS_COLUMN, thistype.QUESTION_MARK_PATH)
                else
                    call thistype.THIS_BOARD.SetIcon(thistype.CURRENT_ROUND_ROW + iteration, thistype.PLAYERS_COLUMN, whichLevel.GetIcon())
                endif

				local integer iteration2 = 0

                loop
                    exitwhen (iteration2 > 8)

                    if flags[iteration2] then
                        call thistype.THIS_BOARD.SetIcon(thistype.CURRENT_ROUND_ROW + iteration, thistype.STATUS_COLUMN + iteration2, thistype.CHECK_PATH)
                    else
                        call thistype.THIS_BOARD.SetIcon(thistype.CURRENT_ROUND_ROW + iteration, thistype.STATUS_COLUMN + iteration2, thistype.CROSS_PATH)
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

    static method GetChapterString takes nothing returns string
        local Act curAct = Act.CURRENT
        local string result = "Chapter: "

        if (curAct == NULL) then
            return result
        endif

        return result + String.Color.Do(curAct.GetName(), String.Color.BONUS)
    endmethod

    eventMethod Event_ActStart
        call thistype.THIS_BOARD.SetValue(thistype.CHAPTER_ROW, thistype.PLAYERS_COLUMN, thistype.GetChapterString())
    endmethod

    eventMethod Event_AfterIntro
        call thistype.THIS_BOARD.Show(params.User.GetTrigger())
    endmethod

    static method GetNewRow takes nothing returns integer
        return thistype.THIS_BOARD.GetNewRow()
    endmethod

    eventMethod Event_Start
        set thistype.CHARGES_CHANGE_EVENT = Event.Create(ITEM.ChargesAmount.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ChargesChange)
        set thistype.DROP_EVENT = Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Drop)
        set thistype.MOVE_EVENT = Event.Create(UNIT.Items.Events.MoveInInventory.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Move)
        set thistype.PICK_UP_EVENT = Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_PickUp)

        call Event.Create(Act.START_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ActStart).AddToStatics()
        call Event.Create(AfterIntro.FOR_PLAYER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_AfterIntro).AddToStatics()
        call Event.Create(HeroSelection.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_HeroPick).AddToStatics()
        call Event.Create(Level.START_EVENT_TYPE, EventPriority.MISC2, function thistype.Event_LevelStart).AddToStatics()

        set thistype.THIS_BOARD = Multiboard.Create()

        local integer currentRow = thistype.GetNewRow()

        if (Meteorite.THIS_UNIT != NULL) then
            call thistype.THIS_BOARD.SetTitle(Meteorite.GetInfoboardTitle())
        endif

        set thistype.PLAYERS_COLUMN = thistype.THIS_BOARD.GetNewColumn()
        set thistype.STATUS_COLUMN = thistype.THIS_BOARD.GetNewColumn()
        set thistype.ITEMS_COLUMN = thistype.THIS_BOARD.GetNewColumn()

        call thistype.THIS_BOARD.SetValue(currentRow, thistype.PLAYERS_COLUMN, String.Color.Do("Players", String.Color.GOLD))
        call thistype.THIS_BOARD.SetWidth(currentRow, thistype.PLAYERS_COLUMN, 0.06)
        call thistype.THIS_BOARD.SetValue(currentRow, thistype.STATUS_COLUMN, String.Color.Do("Status", String.Color.GOLD))
        call thistype.THIS_BOARD.SetWidth(currentRow, thistype.STATUS_COLUMN, 0.04)
        call thistype.THIS_BOARD.SetValue(currentRow, thistype.ITEMS_COLUMN, String.Color.Do("Items in Inventory", String.Color.GOLD))
        call thistype.THIS_BOARD.SetWidth(currentRow, thistype.ITEMS_COLUMN, 0.1)

        //call thistype.THIS_BOARD.ColumnSpan.SetWidth(currentRow, thistype.ITEMS_COLUMN + 1, thistype.THIS_BOARD.GetColumnCount(), 0.)

        set currentRow = thistype.GetNewRow()

        call thistype.THIS_BOARD.SetValue(currentRow, thistype.PLAYERS_COLUMN, "=================================================")
        call thistype.THIS_BOARD.SetWidth(currentRow, thistype.PLAYERS_COLUMN, 0.2)
        call thistype.THIS_BOARD.ColumnSpan.SetWidth(currentRow, thistype.PLAYERS_COLUMN + 1, thistype.THIS_BOARD.GetColumnCount(), 0.)

        set currentRow = thistype.GetNewRow()

		local integer iteration = 0

        loop
            exitwhen (iteration > User.HUMANS_COUNT)

            local User curPlayer = User.HUMANS[iteration]

            local PlayerSlotState curPlayerSlotState = curPlayer.SlotState.Get()

            if (curPlayerSlotState != PlayerSlotState.EMPTY) then
                local Unit curPlayerHero = curPlayer.Hero.Get()

                set currentRow = thistype.GetNewRow()

                call thistype.THIS_BOARD.SetWidth(currentRow, thistype.PLAYERS_COLUMN, 0.06)
                call thistype.THIS_BOARD.SetWidth(currentRow, thistype.STATUS_COLUMN, 0.04)

				local integer iteration2 = MAX_INVENTORY_SIZE - 1

                loop
                    call thistype.THIS_BOARD.SetWidth(currentRow, thistype.ITEMS_COLUMN + iteration2 * 2, 0.007)
                    call thistype.THIS_BOARD.SetWidth(currentRow, thistype.ITEMS_COLUMN + iteration2 * 2 + 1, 0.012)

                    set iteration2 = iteration2 - 1
                    exitwhen (iteration2 < 0)
                endloop

                //call thistype.THIS_BOARD.ColumnSpan.SetWidth(currentRow, thistype.ITEMS_COLUMN + (MAX_INVENTORY_SIZE - 1) * 2 + 1, thistype.THIS_BOARD.GetColumnCount(), 0.)
                call thistype(NULL).User.SetRow(curPlayer, currentRow)
                call thistype(NULL).User.Update(curPlayer)

				local string stringValue

                if (curPlayerSlotState == PlayerSlotState.PLAYING) then
                    set stringValue = curPlayer.GetColorString()
                else
                    set stringValue = "ff7F7F7F"
                endif

                call thistype.THIS_BOARD.SetValue(currentRow, thistype.PLAYERS_COLUMN, String.Color.Do(curPlayer.GetName(), stringValue))
            else
                call INFOBOARD.User.SetRow(curPlayer, -1)
            endif

            set iteration = iteration + 1
        endloop

        set currentRow = thistype.GetNewRow()

        call thistype.THIS_BOARD.SetWidth(currentRow, thistype.PLAYERS_COLUMN, 0.2)
        call thistype.THIS_BOARD.ColumnSpan.SetWidth(currentRow, thistype.PLAYERS_COLUMN + 1, thistype.THIS_BOARD.GetColumnCount(), 0.)

        set currentRow = thistype.GetNewRow()

        call thistype.THIS_BOARD.SetWidth(currentRow, thistype.PLAYERS_COLUMN, 0.1)
        call thistype.THIS_BOARD.SetIcon(currentRow, thistype.PLAYERS_COLUMN + 1, "ReplaceableTextures\\CommandButtons\\BTNOrcMeleeUpOne.blp")
        call thistype.THIS_BOARD.SetIcon(currentRow, thistype.PLAYERS_COLUMN + 2, "ReplaceableTextures\\CommandButtons\\BTNImprovedBows.blp")
        call thistype.THIS_BOARD.SetIcon(currentRow, thistype.PLAYERS_COLUMN + 3, "ReplaceableTextures\\CommandButtons\\BTNStaffOfNegation.blp")
        call thistype.THIS_BOARD.SetIcon(currentRow, thistype.PLAYERS_COLUMN + 5, "ReplaceableTextures\\CommandButtons\\BTNInvisibility.blp")
        call thistype.THIS_BOARD.SetIcon(currentRow, thistype.PLAYERS_COLUMN + 6, "ReplaceableTextures\\CommandButtons\\BTNBootsOfSpeed.blp")
        call thistype.THIS_BOARD.SetIcon(currentRow, thistype.PLAYERS_COLUMN + 7, "ReplaceableTextures\\CommandButtons\\BTNGenericSpellImmunity.blp")
        call thistype.THIS_BOARD.SetIcon(currentRow, thistype.PLAYERS_COLUMN + 8, "ReplaceableTextures\\CommandButtons\\BTNSelfDestruct.blp")
        call thistype.THIS_BOARD.SetIcon(currentRow, thistype.PLAYERS_COLUMN + 9, "ReplaceableTextures\\CommandButtons\\BTNReincarnation.blp")
        call thistype.THIS_BOARD.ColumnSpan.SetWidth(currentRow, thistype.PLAYERS_COLUMN + 1, thistype.PLAYERS_COLUMN + 9, 0.01)
        call thistype.THIS_BOARD.ColumnSpan.SetWidth(currentRow, thistype.PLAYERS_COLUMN + 9 + 1, thistype.THIS_BOARD.GetColumnCount(), 0.)

        set thistype.CURRENT_ROUND_ROW = thistype.GetNewRow()

        call thistype.THIS_BOARD.SetValue(thistype.CURRENT_ROUND_ROW, thistype.PLAYERS_COLUMN, "This round")
        call thistype.THIS_BOARD.SetWidth(thistype.CURRENT_ROUND_ROW, thistype.PLAYERS_COLUMN, 0.1)
        call thistype.THIS_BOARD.ColumnSpan.SetWidth(thistype.CURRENT_ROUND_ROW, thistype.PLAYERS_COLUMN + 1, thistype.PLAYERS_COLUMN + 1 + 8, 0.01)
        call thistype.THIS_BOARD.ColumnSpan.SetWidth(thistype.CURRENT_ROUND_ROW, thistype.PLAYERS_COLUMN + 1 + 8 + 1, thistype.THIS_BOARD.GetColumnCount(), 0.)

        set currentRow = thistype.GetNewRow()

        call thistype.THIS_BOARD.SetValue(currentRow, thistype.PLAYERS_COLUMN, "Next round")
        call thistype.THIS_BOARD.SetWidth(currentRow, thistype.PLAYERS_COLUMN, 0.1)
        call thistype.THIS_BOARD.ColumnSpan.SetWidth(currentRow, thistype.PLAYERS_COLUMN + 1, thistype.PLAYERS_COLUMN + 1 + 8, 0.01)
        call thistype.THIS_BOARD.ColumnSpan.SetWidth(currentRow, thistype.PLAYERS_COLUMN + 1 + 8 + 1, thistype.THIS_BOARD.GetColumnCount(), 0.)

        set currentRow = thistype.GetNewRow()

        set thistype.CHAPTER_ROW = thistype.GetNewRow()

        call thistype.THIS_BOARD.SetValue(thistype.CHAPTER_ROW, thistype.PLAYERS_COLUMN, thistype.GetChapterString())
        call thistype.THIS_BOARD.SetWidth(thistype.CHAPTER_ROW, thistype.PLAYERS_COLUMN, 0.2)

        set thistype.LEVEL_ROW = thistype.GetNewRow()

        call thistype.THIS_BOARD.SetValue(thistype.LEVEL_ROW, thistype.PLAYERS_COLUMN, thistype.GetLevelString())
        call thistype.THIS_BOARD.SetWidth(thistype.LEVEL_ROW, thistype.PLAYERS_COLUMN, 0.2)
    endmethod

    initMethod Init of Misc
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
    endmethod
endstruct