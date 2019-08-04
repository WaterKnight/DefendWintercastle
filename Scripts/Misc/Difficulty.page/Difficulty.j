//! runtextmacro BaseStruct("Difficulty", "DIFFICULTY")
    static Group ENUM_GROUP
    //! runtextmacro GetKey("KEY")
    static Event LEAVE_EVENT
    static thistype SELECTED
    static BoolExpr TARGET_FILTER
    static Dialog THIS_DIALOG
    static User THIS_PLAYER

    static thistype EASY
    static thistype MEDIUM
    static thistype HARD
    static thistype TEST

    string caption
    Trigger initTrigger
    Trigger initUpTrigger
    Announcement whichAnnouncement

    //! runtextmacro CreateAnyState("damageFactor", "DamageFactor", "real")
    //! runtextmacro CreateAnyState("gold", "Gold", "integer")
    //! runtextmacro CreateAnyState("lifeFactor", "LifeFactor", "real")

    condMethod Conditions
        if (UNIT.Event.Native.GetFilter().Type.Get() != UnitType.TEMP) then
            return false
        endif

        return true
    endmethod

    static method AddAbility takes UnitType whichUnitType, Spell whichSpell returns nothing
        call whichUnitType.Abilities.Add(whichSpell)

        set UnitType.TEMP = whichUnitType

        call thistype.ENUM_GROUP.EnumUnits.All(thistype.TARGET_FILTER)

        loop
            local Unit target = thistype.ENUM_GROUP.FetchFirst()
            exitwhen (target == NULL)

            call target.Abilities.Add(whichSpell)
        endloop
    endmethod

    operatorMethod < takes thistype other returns boolean
        return (this.index < other.index)
    endmethod

    execMethod DoAnnouncement
        call thistype.SELECTED.whichAnnouncement.Start()
    endmethod

    execMethod EasyModifiers
    endmethod

    execMethod MediumModifiers
    endmethod

    execMethod MediumUpModifiers
        call Artifact.Start()

        //Act1
        //call thistype.AddAbility(UnitType.DEER, Boost.THIS_SPELL)
        call thistype.AddAbility(UnitType.FURBOLG_ORACLE, Purge.THIS_SPELL)
        call thistype.AddAbility(UnitType.MOONKIN, EnergyCharge.THIS_SPELL)

        //Act2
        //call thistype.AddAbility(UnitType.ASSASSIN, Boost.THIS_SPELL)
        call thistype.AddAbility(UnitType.ASSASSIN, Knockout.THIS_SPELL)
        call thistype.AddAbility(UnitType.AXE_FIGHTER, DeathAxe.THIS_SPELL)
        call thistype.AddAbility(UnitType.BALDUIR, Cleaver.THIS_SPELL)
        call thistype.AddAbility(UnitType.TAROG, Fireburst.THIS_SPELL)
    endmethod

    execMethod HardModifiers
    endmethod

    execMethod HardUpModifiers
        //Act1
        call thistype.AddAbility(UnitType.FURBOLG_ORACLE, Stampede.THIS_SPELL)
        call thistype.AddAbility(UnitType.GNOLL_MAGE, Purge.THIS_SPELL)
        call thistype.AddAbility(UnitType.SATYR, ChaosBall.THIS_SPELL)
        call UnitType.NAGAROSH.ManaRegeneration.Add(2.)
        call UnitType.TAROG.ManaRegeneration.Add(2.)

        //Act2
        call thistype.AddAbility(UnitType.ASSASSIN, Medipack.THIS_SPELL)
        call thistype.AddAbility(UnitType.BALDUIR, MutingShout.THIS_SPELL)
        call thistype.AddAbility(UnitType.CATAPULT, BurningOil.THIS_SPELL)
        call thistype.AddAbility(UnitType.RAIDER, ColdResistance.THIS_SPELL)
        call thistype.AddAbility(UnitType.SPEAR_SCOUT, BouncyBomb.THIS_SPELL)
    endmethod

    eventMethod Event_DialogClick
        local Dialog thisDialog = params.Dialog.GetTrigger()
        local DialogButton thisButton = params.Dialog.GetTriggerButton()

        local thistype this = thisButton.Data.Integer.Get(KEY)

        call thisDialog.Destroy()
        call thistype.THIS_PLAYER.Event.Remove(LEAVE_EVENT)

        set thistype.SELECTED = this
        call Game.DisplayTextTimed(User.ANY, this.caption, 30.)
        call User.ANY.State.Set(PLAYER_STATE_RESOURCE_GOLD, this.GetGold())

		local integer index = this.GetIndex()
		local integer iteration = ARRAY_MIN

        loop
            exitwhen (iteration >= index)

			if (thistype.ALL[iteration].initUpTrigger != NULL) then
            	call thistype.ALL[iteration].initUpTrigger.Run()
            endif

            set iteration = iteration + 1
        endloop

		local string infoMessage = "Enemies have " + String.Color.Do(Integer.ToString(Real.ToInt(this.GetDamageFactor() * 100)), String.Color.GOLD) + "% damage and " + String.Color.Do(Integer.ToString(Real.ToInt(this.GetLifeFactor() * 100)), String.Color.GOLD) + "% hitpoints."

        call Game.DisplayTextTimed(User.ANY, infoMessage, 30.)

		if (this.initTrigger != NULL) then
        	call this.initTrigger.Run()
        endif

		if (this.initUpTrigger != NULL) then
        	call this.initUpTrigger.Run()
        endif

        if not Artifact.STARTED then
            call Game.DisplayTextTimed(User.ANY, String.Color.Do("Artifacts are disabled.", String.Color.MALUS), 30.)
        endif

        call Act.Event_DifficultySet()
    endmethod

    eventMethod Event_Leave
        local integer iteration = ARRAY_MIN

        loop
            set thistype.THIS_PLAYER = User.ALL[iteration]

            exitwhen (thistype.THIS_PLAYER.SlotState.Get() == PlayerSlotState.PLAYING)

            set iteration = iteration + 1
        endloop

        call thistype.THIS_DIALOG.Display(thistype.THIS_PLAYER, true)
    endmethod

    static method Create takes string caption, code initFunction, code initUpFunction returns thistype
        local thistype this = thistype.allocate()

        set this.caption = caption
        set this.initTrigger = Trigger.CreateFromCode(initFunction)
        set this.initUpTrigger = Trigger.CreateFromCode(initUpFunction)
        call thistype.THIS_DIALOG.Buttons.Create(caption, 0).Data.Integer.Set(KEY, this)

        call this.AddToList()

        return this
    endmethod

    static method Start takes nothing returns nothing
        call Timer.GetExpired().Destroy()

        set thistype.ENUM_GROUP = Group.Create()

        set thistype.LEAVE_EVENT = Event.Create(User.LEAVE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Leave)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

        set thistype.THIS_DIALOG = Dialog.Create()

		local thistype this

        set this = thistype.Create("Castle visitor (easy)", function thistype.EasyModifiers, null)

        set thistype.EASY = this
        set this.whichAnnouncement = Announcement.Create(2)
        call this.SetDamageFactor(1.)
        call this.SetGold(500)
        call this.SetLifeFactor(1.)

        set this = thistype.Create("Vassal (medium)", function thistype.MediumModifiers, function thistype.MediumUpModifiers)

        set thistype.MEDIUM = this
        set this.whichAnnouncement = Announcement.Create(3)
        call this.SetDamageFactor(1.25)
        call this.SetGold(400)
        call this.SetLifeFactor(1.25)

        set this = thistype.Create("Knight (hard)", function thistype.HardModifiers, function thistype.HardUpModifiers)

        set thistype.HARD = this
        set this.whichAnnouncement = Announcement.Create(4)
        call this.SetDamageFactor(1.5)
        call this.SetGold(300)
        call this.SetLifeFactor(1.5)

        set this = thistype.Create("Penguin (Test mode)", null, null)

        set thistype.TEST = this
        set this.whichAnnouncement = Announcement.Create(5)
        call this.SetDamageFactor(0.75)
        call this.SetGold(1500)
        call this.SetLifeFactor(0.75)

		local integer iteration = ARRAY_MIN

        loop
            set thistype.THIS_PLAYER = User.ALL[iteration]

            exitwhen (THIS_PLAYER.SlotState.Get() == PlayerSlotState.PLAYING)

            set iteration = iteration + 1
        endloop

        call thistype.THIS_DIALOG.SetTitle("Declare yourself!")
        call thistype.THIS_PLAYER.Event.Add(LEAVE_EVENT)

        call thistype.THIS_DIALOG.Event.Add(Event.Create(Dialog.CLICK_EVENT_TYPE, EventPriority.MISC, function thistype.Event_DialogClick))

        call thistype.THIS_DIALOG.Display(thistype.THIS_PLAYER, true)
    endmethod
endstruct