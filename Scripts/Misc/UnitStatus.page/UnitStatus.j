//! runtextmacro BaseStruct("UnitStatus", "UNIT_STATUS")
    static Event ACQUIRE_EVENT
    static Unit LAST_TARGET
    static Unit array SELECTED_UNIT
    static constant real UPDATE_TIME = 0.125

    static integer LABEL_COLUMN
    static integer VALUE_COLUMN

    static integer ARMOR_ROW
    static integer ATTACK_SPEED_ROW
    static constant real BARS_UPDATE_LENGTH = (0.05 * 32) * thistype.UPDATE_TIME
    static integer CRITICAL_ROW
    static integer DAMAGE_ROW
    static integer EVASION_ROW
    static real LIFE_DISPLAYED = 0.
    static integer LIFE_REGENERATION_ROW
    static integer LIFE_ROW
    static constant integer LIFE_SEGMENTS_AMOUNT = 30
    static real MANA_DISPLAYED = 0.
    static integer MANA_REGENERATION_ROW
    static integer MANA_ROW
    static constant integer MANA_SEGMENTS_AMOUNT = 40
    static integer MOVEMENT_SPEED_ROW
    static integer NAME_ROW
    static integer SPELL_POWER_ROW
    static real STAMINA_DISPLAYED = 0.
    static integer STAMINA_REGENERATION_ROW
    static integer STAMINA_ROW
    static constant integer STAMINA_SEGMENTS_AMOUNT = 40
    static integer STATUS_LAST_BUFFS_COUNT = Memory.IntegerKeys.Table.EMPTY
    static integer STATUS_ROW

    static Multiboard THIS_BOARD

    eventMethod Event_TargetInRange
        if params.User.GetTrigger().IsLocal() then
            set thistype.LAST_TARGET = params.Unit.GetTarget()
        endif
    endmethod

    static method GetValueString takes real all, real bonus, integer decimals returns string
        local string color

        if (bonus < 0) then
            set color = String.Color.MALUS
        elseif (bonus > 0) then
            set color = String.Color.BONUS
        else
            set color = null
        endif

		local string result

        if (decimals == 0) then
            set result = Real.ToIntString(all)
        else
            set result = Real.ToStringWithDecimals(all, decimals)
        endif

        return String.Color.Do(result, color)
    endmethod

    static method UpdateArmor takes Unit whichUnit returns nothing
        call thistype.THIS_BOARD.SetValue(thistype.ARMOR_ROW, thistype.LABEL_COLUMN, "Armor: ")
        call thistype.THIS_BOARD.SetValue(thistype.ARMOR_ROW, thistype.VALUE_COLUMN, thistype.GetValueString(whichUnit.Armor.GetVisible(), whichUnit.Armor.GetVisibleBonus(), 1))
    endmethod

    static method UpdateAttackSpeed takes Unit whichUnit returns nothing
        call thistype.THIS_BOARD.SetValue(thistype.ATTACK_SPEED_ROW, thistype.LABEL_COLUMN, "Attack speed: ")
        call thistype.THIS_BOARD.SetValue(thistype.ATTACK_SPEED_ROW, thistype.VALUE_COLUMN, thistype.GetValueString(whichUnit.Attack.Speed.Get(), whichUnit.Attack.Speed.BonusA.Get(), 3))
    endmethod

    static method UpdateCritical takes Unit whichUnit returns nothing
        call thistype.THIS_BOARD.SetValue(thistype.CRITICAL_ROW, thistype.LABEL_COLUMN, "Critical: ")

        if (thistype.LAST_TARGET == NULL) then
            call thistype.THIS_BOARD.SetValue(thistype.CRITICAL_ROW, thistype.VALUE_COLUMN, thistype.GetValueString(whichUnit.CriticalChance.Get(), whichUnit.CriticalChance.Bonus.Get(), 0))
        else
            call thistype.THIS_BOARD.SetValue(thistype.CRITICAL_ROW, thistype.VALUE_COLUMN, thistype.GetValueString(whichUnit.CriticalChance.Get(), whichUnit.CriticalChance.Bonus.Get(), 0) + " (" + Real.ToIntString(whichUnit.CriticalChance.VsUnit(thistype.LAST_TARGET) * 100.) + Char.PERCENT + " vs " + thistype.LAST_TARGET.GetName() +")")
        endif
    endmethod

    static method UpdateDamage takes Unit whichUnit, UnitType whichUnitType returns nothing
        local real bonus = whichUnit.Damage.GetVisibleBonus()

        call thistype.THIS_BOARD.SetValue(thistype.DAMAGE_ROW, thistype.LABEL_COLUMN, "Damage: ")
        call thistype.THIS_BOARD.SetValue(thistype.DAMAGE_ROW, thistype.VALUE_COLUMN, thistype.GetValueString(whichUnit.Damage.GetVisible() + whichUnitType.Damage.Dices.Get(), bonus, 0) + " - " + thistype.GetValueString(whichUnit.Damage.GetVisible() + whichUnitType.Damage.Dices.Get() * whichUnitType.Damage.Sides.Get(), bonus, 0))
    endmethod

    static method UpdateEvasion takes Unit whichUnit returns nothing
        call thistype.THIS_BOARD.SetValue(thistype.EVASION_ROW, thistype.LABEL_COLUMN, "Evasion: ")

        if (thistype.LAST_TARGET == NULL) then
            call thistype.THIS_BOARD.SetValue(thistype.EVASION_ROW, thistype.VALUE_COLUMN, thistype.GetValueString(whichUnit.EvasionChance.Get(), whichUnit.EvasionChance.Bonus.Get(), 0))
        else
            call thistype.THIS_BOARD.SetValue(thistype.EVASION_ROW, thistype.VALUE_COLUMN, thistype.GetValueString(whichUnit.EvasionChance.Get(), whichUnit.EvasionChance.Bonus.Get(), 0) + " (" + Real.ToIntString(whichUnit.EvasionChance.VsUnit(thistype.LAST_TARGET) * 100.) + Char.PERCENT + " vs " + thistype.LAST_TARGET.GetName() +")")
        endif
    endmethod

    static method UpdateLife takes Unit whichUnit returns nothing
        local real maxValue = whichUnit.MaxLife.Get()

        if (maxValue < 1.) then
            set maxValue = 1.
        endif

        local real value = whichUnit.Life.Get()

        local real relative = value / maxValue

        set relative = thistype.LIFE_DISPLAYED + (relative - thistype.LIFE_DISPLAYED) * thistype.BARS_UPDATE_LENGTH

        set thistype.LIFE_DISPLAYED = relative

        local integer filledSegmentsAmount = Real.ToInt(relative * thistype.LIFE_SEGMENTS_AMOUNT)

        call thistype.THIS_BOARD.SetValue(thistype.LIFE_ROW, thistype.LABEL_COLUMN, String.Color.Do(String.Repeat("l", filledSegmentsAmount), String.IfElse(relative > 0.5, String.Color.RelativeTo(2. - 2. * relative, 1., 0., 1.), String.Color.RelativeTo(1., relative * 2., 0., 1.))) + String.Color.Do(String.Repeat("l", thistype.LIFE_SEGMENTS_AMOUNT - filledSegmentsAmount), String.Color.BLACK))
        call thistype.THIS_BOARD.SetValue(thistype.LIFE_ROW, thistype.VALUE_COLUMN, Real.ToIntString(value) + "/" + Real.ToIntString(maxValue))
    endmethod

    static method UpdateLifeRegeneration takes Unit whichUnit returns nothing
        call thistype.THIS_BOARD.SetValue(thistype.LIFE_REGENERATION_ROW, thistype.LABEL_COLUMN, "Life reg.: ")
        call thistype.THIS_BOARD.SetValue(thistype.LIFE_REGENERATION_ROW, thistype.VALUE_COLUMN, thistype.GetValueString(whichUnit.LifeRegeneration.Get(), whichUnit.LifeRegeneration.Bonus.Get(), 2))
    endmethod

    static method UpdateMana takes Unit whichUnit returns nothing
        local real maxValue = whichUnit.MaxMana.Get()

        if (maxValue < 1.) then
            set maxValue = 1.
        endif

        local real value = whichUnit.Mana.Get()

        local real relative = value / maxValue

        set relative = thistype.MANA_DISPLAYED + (relative - thistype.MANA_DISPLAYED) * thistype.BARS_UPDATE_LENGTH

        set thistype.MANA_DISPLAYED = relative

        local integer filledSegmentsAmount = Real.ToInt(relative * thistype.MANA_SEGMENTS_AMOUNT)

        call thistype.THIS_BOARD.SetValue(thistype.MANA_ROW, thistype.LABEL_COLUMN, String.Color.Do(String.Repeat("l", filledSegmentsAmount), String.Color.RelativeTo(Math.Max(relative, 0.5), 0., Math.Max(relative, 0.5), 1.)) + String.Color.Do(String.Repeat("l", thistype.LIFE_SEGMENTS_AMOUNT - filledSegmentsAmount), String.Color.BLACK))
        call thistype.THIS_BOARD.SetValue(thistype.MANA_ROW, thistype.VALUE_COLUMN, Real.ToIntString(value) + "/" + Real.ToIntString(maxValue))
    endmethod

    static method UpdateManaRegeneration takes Unit whichUnit returns nothing
        call thistype.THIS_BOARD.SetValue(thistype.MANA_REGENERATION_ROW, thistype.LABEL_COLUMN, "Mana reg.: ")
        call thistype.THIS_BOARD.SetValue(thistype.MANA_REGENERATION_ROW, thistype.VALUE_COLUMN, thistype.GetValueString(whichUnit.ManaRegeneration.Get(), whichUnit.ManaRegeneration.Bonus.Get(), 2))
    endmethod

    static method UpdateMovement takes Unit whichUnit returns nothing
        local real value = whichUnit.Movement.Speed.Get()

        local real realValue = whichUnit.Movement.Speed.StaminaReduce(value)

        local string valueString = thistype.GetValueString(value, whichUnit.Movement.Speed.GetBonus(), 0)

        if (realValue != value) then
            set valueString = valueString + " (" + String.Color.Do(Real.ToIntString(realValue), String.Color.GOLD) + ")"
        endif

        call thistype.THIS_BOARD.SetValue(thistype.MOVEMENT_SPEED_ROW, thistype.LABEL_COLUMN, "Move speed: ")
        call thistype.THIS_BOARD.SetValue(thistype.MOVEMENT_SPEED_ROW, thistype.VALUE_COLUMN, valueString)
    endmethod

    static method UpdateSpellPower takes Unit whichUnit returns nothing
        call thistype.THIS_BOARD.SetValue(thistype.SPELL_POWER_ROW, thistype.LABEL_COLUMN, "Spell power: ")
        call thistype.THIS_BOARD.SetValue(thistype.SPELL_POWER_ROW, thistype.VALUE_COLUMN, thistype.GetValueString(whichUnit.SpellPower.Get(), whichUnit.SpellPower.GetBonus(), 0))
    endmethod

    static method UpdateStamina takes Unit whichUnit returns nothing
        local real maxValue = whichUnit.MaxStamina.Get()

        if (maxValue < 1.) then
            set maxValue = 1.
        endif

        local real value = whichUnit.Stamina.Get()

        local real relative = value / maxValue

        set relative = thistype.STAMINA_DISPLAYED + (relative - thistype.STAMINA_DISPLAYED) * thistype.BARS_UPDATE_LENGTH

        set thistype.STAMINA_DISPLAYED = relative

        local integer filledSegmentsAmount = Real.ToInt(relative * thistype.STAMINA_SEGMENTS_AMOUNT)

        call thistype.THIS_BOARD.SetValue(thistype.STAMINA_ROW, thistype.LABEL_COLUMN, String.Color.Do(String.Repeat("l", filledSegmentsAmount), String.Color.RelativeTo(Math.Max(0.7, relative), Math.Max(0.7, relative), 0., 1.)) + String.Color.Do(String.Repeat("l", thistype.LIFE_SEGMENTS_AMOUNT - filledSegmentsAmount), String.Color.BLACK))
        call thistype.THIS_BOARD.SetValue(thistype.STAMINA_ROW, thistype.VALUE_COLUMN, Real.ToIntString(value) + "/" + Real.ToIntString(maxValue))
    endmethod

    static method UpdateStaminaRegeneration takes Unit whichUnit returns nothing
        call thistype.THIS_BOARD.SetValue(thistype.STAMINA_REGENERATION_ROW, thistype.LABEL_COLUMN, "Stamina reg.: ")
        call thistype.THIS_BOARD.SetValue(thistype.STAMINA_REGENERATION_ROW, thistype.VALUE_COLUMN, thistype.GetValueString(whichUnit.StaminaRegeneration.Get(), whichUnit.StaminaRegeneration.Bonus.Get(), 2))
    endmethod

    static method UpdateStatus takes Unit whichUnit returns nothing
        local integer count = whichUnit.Buffs.CountVisible()
        local integer iteration = thistype.STATUS_LAST_BUFFS_COUNT

        loop
            exitwhen (iteration <= count)

            call thistype.THIS_BOARD.SetIcon(thistype.STATUS_ROW, thistype.VALUE_COLUMN + iteration, null)
            call thistype.THIS_BOARD.SetWidth(thistype.STATUS_ROW, thistype.VALUE_COLUMN, 0.)

            set iteration = iteration - 1
        endloop

        set thistype.STATUS_LAST_BUFFS_COUNT = count

        call thistype.THIS_BOARD.SetValue(thistype.STATUS_ROW, thistype.LABEL_COLUMN, "Status: ")

        loop
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

            local Buff whichBuff = whichUnit.Buffs.GetVisible(iteration)

            call thistype.THIS_BOARD.SetIcon(thistype.STATUS_ROW, thistype.VALUE_COLUMN + iteration, whichBuff.GetIcon())
            call thistype.THIS_BOARD.SetWidth(thistype.STATUS_ROW, thistype.VALUE_COLUMN, 0.01)

            set iteration = iteration - 1
        endloop
    endmethod

    static method Update takes nothing returns nothing
        local User whichPlayer = User.GetLocal()
        local Unit whichUnit = thistype.SELECTED_UNIT[whichPlayer.GetIndex()]
        local UnitType whichUnitType = whichUnit.Type.Get()

        call thistype.UpdateArmor(whichUnit)
        call thistype.UpdateAttackSpeed(whichUnit)
        //call thistype.UpdateCritical(whichUnit)
        call thistype.UpdateDamage(whichUnit, whichUnitType)
        //call thistype.UpdateEvasion(whichUnit)
        call thistype.UpdateLife(whichUnit)
        call thistype.UpdateLifeRegeneration(whichUnit)
        call thistype.UpdateMana(whichUnit)
        call thistype.UpdateManaRegeneration(whichUnit)
        call thistype.UpdateMovement(whichUnit)
        call thistype.THIS_BOARD.SetValue(thistype.NAME_ROW, thistype.LABEL_COLUMN, String.Color.Do(whichUnit.GetName(), String.IfElse(whichUnit.IsAllyOf(whichPlayer) and (whichUnit.Owner.Get() != User.CASTLE), String.Color.GREEN, String.IfElse(whichUnit.IsEnemyOf(whichPlayer), String.Color.RED, String.Color.GOLD))))
        call thistype.UpdateSpellPower(whichUnit)
        call thistype.UpdateStamina(whichUnit)
        call thistype.UpdateStaminaRegeneration(whichUnit)
        call thistype.UpdateStatus(whichUnit)
    endmethod

    timerMethod UpdateByTimer
        call thistype.Update()
    endmethod

    static method SelectUnit takes User whichPlayer, Unit whichUnit returns nothing
        local integer whichPlayerIndex = whichPlayer.GetIndex()

        if (thistype.SELECTED_UNIT[whichPlayer] != NULL) then
            call whichUnit.Event.Counted.Subtract(ACQUIRE_EVENT)
        endif
        if whichPlayer.IsLocal() then
            set thistype.LAST_TARGET = NULL
        endif

        set thistype.SELECTED_UNIT[whichPlayerIndex] = whichUnit

        if (whichUnit == NULL) then
            return
        endif

        call whichUnit.Event.Counted.Add(ACQUIRE_EVENT)

    	set thistype.LIFE_DISPLAYED = Math.DivideInval(whichUnit.Life.Get(), whichUnit.MaxLife.Get(), 0.)
    	set thistype.MANA_DISPLAYED = Math.DivideInval(whichUnit.Mana.Get(), whichUnit.MaxMana.Get(), 0.)
    	set thistype.STAMINA_DISPLAYED = Math.DivideInval(whichUnit.Stamina.Get(), whichUnit.MaxStamina.Get(), 0.)
    endmethod

    eventMethod Event_Deselect
        local User whichPlayer = params.User.GetTrigger()
        local Unit whichUnit = params.Unit.GetTrigger()

        if (whichUnit.Selection.CountAtPlayer(whichPlayer) == Memory.IntegerKeys.Table.EMPTY) then
            set whichUnit = whichPlayer.Hero.Get()

            if (whichUnit != NULL) then
                if whichUnit.Classes.Contains(UnitClass.DEAD) then
                    set whichUnit = HeroRevival.GetGhostByUnit(whichUnit)
                endif

                call thistype.SelectUnit(whichPlayer, whichUnit)
            endif
        else
            call thistype.SelectUnit(whichPlayer, whichUnit.Selection.GetFromPlayer(whichPlayer, Memory.IntegerKeys.Table.STARTED))
        endif
    endmethod

    eventMethod Event_Select
        local User whichPlayer = params.User.GetTrigger()
        local Unit whichUnit = params.Unit.GetTrigger()

        call thistype.SelectUnit(whichPlayer, whichUnit)

        if whichPlayer.IsLocal() then
            call thistype.Update()
        endif
    endmethod

    static method GetNewRow takes nothing returns integer
        return thistype.THIS_BOARD.GetNewRow()
    endmethod

    eventMethod Event_HeroPick
        call thistype.THIS_BOARD.Show(params.User.GetTrigger())
    endmethod

    eventMethod Event_Start
        set thistype.ACQUIRE_EVENT = Event.Create(UNIT.Attack.Events.ACQUIRE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_TargetInRange)
        set thistype.THIS_BOARD = Multiboard.Create()
        call Event.Create(HeroSelection.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_HeroPick).AddToStatics()
        call Event.Create(UNIT.Selection.ENDING_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Deselect).AddToStatics()
        call Event.Create(UNIT.Selection.START_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Select).AddToStatics()

        set thistype.LABEL_COLUMN = thistype.THIS_BOARD.GetNewColumn()
        set thistype.VALUE_COLUMN = thistype.THIS_BOARD.GetNewColumn()

        set thistype.NAME_ROW = thistype.GetNewRow()

        call thistype.GetNewRow()

        set thistype.LIFE_ROW = thistype.GetNewRow()
        set thistype.LIFE_REGENERATION_ROW = thistype.GetNewRow()
        set thistype.MANA_ROW = thistype.GetNewRow()
        set thistype.MANA_REGENERATION_ROW = thistype.GetNewRow()
        set thistype.STAMINA_ROW = thistype.GetNewRow()
        set thistype.STAMINA_REGENERATION_ROW = thistype.GetNewRow()

        call thistype.GetNewRow()

        set thistype.DAMAGE_ROW = thistype.GetNewRow()
        set thistype.SPELL_POWER_ROW = thistype.GetNewRow()
        set thistype.ARMOR_ROW = thistype.GetNewRow()
        //set thistype.CRITICAL_ROW = thistype.GetNewRow()
        //set thistype.EVASION_ROW = thistype.GetNewRow()
        set thistype.ATTACK_SPEED_ROW = thistype.GetNewRow()
        set thistype.MOVEMENT_SPEED_ROW = thistype.GetNewRow()

        call thistype.GetNewRow()

        set thistype.STATUS_ROW = thistype.GetNewRow()

        call thistype.THIS_BOARD.Column.SetWidth(thistype.LABEL_COLUMN, 0.1)
        call thistype.THIS_BOARD.Column.SetWidth(thistype.VALUE_COLUMN, 0.1)
        call thistype.THIS_BOARD.SetTitle("Unit Status")

        call thistype.THIS_BOARD.SetWidth(thistype.LIFE_ROW, thistype.LABEL_COLUMN, 0.12)
        call thistype.THIS_BOARD.SetWidth(thistype.LIFE_ROW, thistype.VALUE_COLUMN, 0.08)
        call thistype.THIS_BOARD.SetWidth(thistype.MANA_ROW, thistype.LABEL_COLUMN, 0.12)
        call thistype.THIS_BOARD.SetWidth(thistype.MANA_ROW, thistype.VALUE_COLUMN, 0.08)
        call thistype.THIS_BOARD.SetWidth(thistype.NAME_ROW, thistype.LABEL_COLUMN, 0.2)
        call thistype.THIS_BOARD.SetWidth(thistype.NAME_ROW, thistype.VALUE_COLUMN, 0.)
        call thistype.THIS_BOARD.SetWidth(thistype.STAMINA_ROW, thistype.LABEL_COLUMN, 0.12)
        call thistype.THIS_BOARD.SetWidth(thistype.STAMINA_ROW, thistype.VALUE_COLUMN, 0.08)
        call thistype.THIS_BOARD.SetWidth(thistype.STATUS_ROW, thistype.VALUE_COLUMN, 0.01)

        call Timer.Create().Start(thistype.UPDATE_TIME, true, function thistype.UpdateByTimer)
    endmethod

    initMethod Init of Misc_2
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
    endmethod
endstruct