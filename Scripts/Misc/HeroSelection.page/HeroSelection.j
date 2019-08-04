//! runtextmacro BaseStruct("Spirit", "SPIRIT")
	static Rectangle CENTER_RECT
	static real CENTER_X
	static real CENTER_Y
	static real CENTER_Z
	static Rectangle CHAMBER_RECT
	static Event DESTROY_EVENT
	//! runtextmacro GetKey("KEY")
	static Event LEAVE_EVENT
	//! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")
	static Timer UPDATE_TIMER

    //! runtextmacro CreateList("ACTIVE_LIST")
    //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

	real angleA
	real angleAAdd
	real angleB
	real angleBAdd
	Unit spirit
	User whichPlayer

	destroyMethod Destroy
		call this.spirit.Data.Integer.Remove(KEY)
		call this.spirit.Event.Remove(DESTROY_EVENT)
		call this.whichPlayer.Data.Integer.Remove(KEY)
		call this.whichPlayer.Event.Remove(LEAVE_EVENT)

		call this.spirit.Destroy()

		if thistype.ACTIVE_LIST_Remove(this) then
			call thistype.UPDATE_TIMER.Pause()
		endif
	endmethod

	eventMethod Impact
		local Missile dummyMissile = params.Missile.GetTrigger()
		local Unit target = params.Unit.GetTarget()

		local Unit spirit = dummyMissile.GetData()

		call dummyMissile.Destroy()

		call spirit.Silence.Subtract()

		if (target == NULL) then
			return
		endif

		local HeroSelection heroSelectionData = HeroSelection.GetFromUnit(target)

		if (heroSelectionData == NULL) then
			call target.Effects.Create(thistype.POSSESSION_DEFLECT_EFFECT_PATH, thistype.POSSESSION_DEFLECT_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

			local TextTag tag = target.AddJumpingTextTag(String.Color.Do("Target cannot be possessed", spirit.Owner.Get().GetColorString()), 0.03, TextTag.GetFreeId())

			return
		endif

		if (target.Owner.Get() != User.NEUTRAL_PASSIVE) then
			call target.Effects.Create(thistype.POSSESSION_DEFLECT_EFFECT_PATH, thistype.POSSESSION_DEFLECT_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

			call target.AddJumpingTextTag(String.Color.Do("Target already possessed", spirit.Owner.Get().GetColorString()), 0.03, TextTag.GetFreeId())

			return
		endif

		call target.Effects.Create(thistype.POSSESSION_EFFECT_PATH, thistype.POSSESSION_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

		call heroSelectionData.Select(spirit.Owner.Get())

		call spirit.Destroy()
	endmethod

	eventMethod Event_Possess
		local Unit spirit = params.Unit.GetTrigger()
		local Unit target = params.Unit.GetTarget()

		call spirit.Silence.Add()

		local Missile dummyMissile = Missile.Create()

        call dummyMissile.Arc.SetByPerc(0.06)
        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.POSSESSION_MISSILE_UNIT_ID, 1.5)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(spirit)
        call dummyMissile.Speed.Set(800.)
        call dummyMissile.Position.SetFromUnit(spirit)

        call dummyMissile.GoToUnit.Start(target, null)

		local Sound effectSound = Sound.CreateFromType(thistype.POSSESSION_SOUND)

		call effectSound.AttachToUnitAndPlay(spirit)

		call effectSound.Destroy(true)
	endmethod

	eventMethod Event_Destroy
		local Unit spirit = params.Unit.GetTrigger()

		local thistype this = spirit.Data.Integer.Get(KEY)

		call this.Destroy()
	endmethod

	eventMethod Event_Leave
		local thistype this = params.User.GetTrigger().Data.Integer.Get(KEY)

		call this.Destroy()
	endmethod

	method Update
		local real angleA = Math.Mod(this.angleA + this.angleAAdd, Math.FULL_ANGLE)
		local real angleB = Math.Mod(this.angleB + this.angleBAdd, Math.FULL_ANGLE)

		local real angleACos = Math.Cos(angleA)
		local real angleASin = Math.Sin(angleA)
		local real angleBCos = Math.Cos(angleB)
		local real angleBSin = Math.Sin(angleB)

		local real x = thistype.CENTER_X + thistype.DIST * angleACos * angleBSin
		local real y = thistype.CENTER_Y + thistype.DIST * angleASin * angleBSin
		local real z = thistype.CENTER_Z + thistype.DIST * angleBCos

		set this.angleA = angleA
		set this.angleB = angleB

		call this.spirit.Position.Set(x, y, z)
	endmethod

	timerMethod UpdateByTimer
        call thistype.FOR_EACH_LIST_Set()

        loop
            local thistype this = thistype.FOR_EACH_LIST_FetchFirst()

            exitwhen (this == NULL)

            call this.Update()
        endloop
	endmethod

	static method Create takes User whichPlayer
		local Unit spirit = Unit.Create(thistype.SPIRIT_UNIT_TYPE, whichPlayer, thistype.CENTER_X, thistype.CENTER_Y, thistype.CENTER_Z)

		local thistype this = thistype.allocate()

		local real angle = Math.RandomAngle()

		set this.angleA = Math.RandomAngle()
		set this.angleAAdd = Math.Cos(angle) * thistype.ANGLE_SPEED * thistype.UPDATE_TIME
		set this.angleB = Math.RandomAngle()
		set this.angleBAdd = Math.Sin(angle) * thistype.ANGLE_SPEED * thistype.UPDATE_TIME
		set this.spirit = spirit
		set this.whichPlayer = whichPlayer
		call spirit.Data.Integer.Set(KEY, this)
		call spirit.Event.Add(DESTROY_EVENT)
		call whichPlayer.Data.Integer.Set(KEY, this)
		call whichPlayer.Event.Add(LEAVE_EVENT)

		if thistype.ACTIVE_LIST_Add(this) then
			call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.UpdateByTimer)
		endif

		call spirit.Select(whichPlayer, true)

		call this.Update()
	endmethod

	eventMethod Event_Start
		local integer i = User.PLAYING_HUMANS_COUNT

		loop
			exitwhen (i < ARRAY_MIN)

			local User whichPlayer = User.PLAYING_HUMANS[i]

			call thistype.Create(whichPlayer)
			call Visibility.AddRect(whichPlayer, thistype.CHAMBER_RECT)

			set i = i - 1
		endloop
	endmethod

	trigMethod CenterTrig
		local Unit whichUnit = UNIT.Event.Native.GetTrigger()

		local User owner = whichUnit.Owner.Get()

		if (owner == User.NEUTRAL_PASSIVE) then
			return
		endif

		local HeroSelection heroSelectionData = HeroSelection.GetFromUnit(whichUnit)

		if (heroSelectionData == NULL) then
			return
		endif

		call heroSelectionData.Deselect()

		call thistype.Create(owner)		
	endmethod

	static method Init
		set thistype.UPDATE_TIMER = Timer.Create()

		set thistype.CENTER_RECT = Rectangle.CreateFromSelf(gg_rct_HeroSelection_Center)
		set thistype.CHAMBER_RECT = Rectangle.CreateFromSelf(gg_rct_Chamber)

		set thistype.CENTER_X = thistype.CENTER_RECT.GetCenterX()
		set thistype.CENTER_Y = thistype.CENTER_RECT.GetCenterY()

		set thistype.CENTER_Z = Spot.GetHeight(thistype.CENTER_X, thistype.CENTER_Y) + thistype.HEIGHT

		set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Destroy)
		set thistype.LEAVE_EVENT = Event.Create(User.LEAVE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Leave)
		call thistype.POSSESSION_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Possess))

		call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
		call Trigger.CreateFromCode(function thistype.CenterTrig).RegisterEvent.EnterRegion(Region.CreateFromRectangle(thistype.CENTER_RECT), null)
	endmethod
endstruct

//! runtextmacro BaseStruct("HeroSelection", "HERO_SELECTION")
    static EventType DUMMY_EVENT_TYPE
    //! runtextmacro GetKey("KEY")
    //! runtextmacro GetKeyArray("SOUNDS_KEY_ARRAY")

    real angle
    User currentOwner
    string description
    string name
    TextTag nameTag
    Unit whichUnit
    real x
    real y

	static method GetFromUnit takes Unit u returns thistype
		return u.Data.Integer.Get(KEY)
	endmethod

    static method TriggerEvents takes User whichPlayer, Unit whichUnit returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

        call params.Unit.SetTrigger(whichUnit)
        call params.User.SetTrigger(whichPlayer)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    destroyMethod Destroy
        call this.nameTag.Destroy()
        call this.currentOwner.Data.Integer.Remove(KEY)
        call this.whichUnit.Data.Integer.Remove(KEY)
    endmethod

	method LeaveChamber
		local User whichPlayer = this.currentOwner
		local Unit whichUnit = this.whichUnit

        call this.Destroy()

        call whichUnit.Invulnerability.Subtract()

        call whichPlayer.Hero.Set(whichUnit)

        call thistype.TriggerEvents(whichPlayer, whichUnit)

        call whichUnit.Items.Create(EternalVial.THIS_ITEM, true)
        call whichUnit.Silence.Subtract()
        call whichUnit.SkillPoints.Add(1)
        call whichPlayer.State.Add(PLAYER_STATE_RESOURCE_GOLD, 300)

        call Camera.PanTimed(whichPlayer, whichUnit.Position.X.Get(), whichUnit.Position.Y.Get(), 2.)
        call whichUnit.Items.Create(TeleportScroll.THIS_ITEM, true)

        if (Difficulty.SELECTED == Difficulty.TEST) then
            call whichUnit.Level.Set(3)
            call whichPlayer.State.Add(PLAYER_STATE_RESOURCE_LUMBER, 250)
        endif
	endmethod

    trigMethod StairwayRightTrig
        local Unit whichUnit = UNIT.Event.Native.GetTrigger()

        local User whichPlayer = whichUnit.Owner.Get()

		local preplaced target = preplaced.rect_BasementStairwayUpTargetRight

		call whichUnit.Position.SetXY(target.x, target.y)

		local thistype this = whichPlayer.Data.Integer.Get(KEY)

		if (this == NULL) then
			return
		endif
		if (this.whichUnit != whichUnit) then
			return
		endif

		call this.LeaveChamber()
    endmethod

    trigMethod StairwayLeftTrig
        local Unit whichUnit = UNIT.Event.Native.GetTrigger()

        local User whichPlayer = whichUnit.Owner.Get()

		local preplaced target = preplaced.rect_BasementStairwayUpTargetLeft

		call whichUnit.Position.SetXY(target.x, target.y)

		local thistype this = whichPlayer.Data.Integer.Get(KEY)

		if (this == NULL) then
			return
		endif
		if (this.whichUnit != whichUnit) then
			return
		endif

		call this.LeaveChamber()
    endmethod

	method Deselect
		if (this.currentOwner == NULL) then
			return
		endif

		local User currentOwner = this.currentOwner
		local Unit whichUnit = this.whichUnit

		set this.currentOwner = NULL
		call currentOwner.Data.Integer.Remove(KEY)

        call whichUnit.Owner.Set(User.NEUTRAL_PASSIVE)
        call PauseUnit(whichUnit.self, true)
        call whichUnit.Facing.Set(this.angle)
        call whichUnit.Position.SetXY(this.x, this.y)

        call Spot.CreateEffect(this.x, this.y, thistype.RESET_EFFECT_PATH, EffectLevel.LOW).DestroyTimed.Start(2.)
	endmethod

	method Select takes User whichPlayer
		call this.Deselect()

		set this.currentOwner = whichPlayer
		call whichPlayer.Data.Integer.Set(KEY, this)

        //call whichUnit.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call PauseUnit(whichUnit.self, false)
        call whichUnit.Owner.Set(whichPlayer)
        call whichUnit.Select(whichPlayer, true)
	endmethod

    method AddSound takes string path
        local Sound whichSound = Sound.Create(path, false, false, false, 0, 0, SoundEax.DEFAULT)

        call this.whichUnit.Data.Integer.Table.Add(SOUNDS_KEY_ARRAY, whichSound)
    endmethod

    static method Create takes preplaced p, string description returns thistype
        local thistype this = thistype.allocate()

		local TextTag nameTag = TextTag.Create(TextTag.GetFreeId())

		local real angle = p.angle
        local real x = p.x
        local real y = p.y

        local Unit whichUnit = Unit.CreateFromPreplaced(p)

        set this.angle = angle
        set this.name = String.Color.Do(whichUnit.GetProperName(), "ffaaaa00")
        set this.nameTag = nameTag
        set this.whichUnit = whichUnit
        set this.x = x
        set this.y = y
        call whichUnit.Data.Integer.Set(KEY, this)

        //call nameTag.Position.SetCentered(true)
        call nameTag.Position.Set(x - 50., y, 200.)

        call PauseUnit(whichUnit.self, true)
        call whichUnit.Invulnerability.Add()
        call whichUnit.Silence.Add()
        call whichUnit.SkillPoints.Set(0)

		call this.AddToList()

        return this
    endmethod

    eventMethod Event_Start
    	local thistype this

		//Aruruw
        set this = thistype.Create(preplaced.unit_19, "Fast, strong, graceful and a superior handling with the bow adorn the reputation of this young defender. In contrast, she cannot keep pace in melee and owns a minor mana pool. If it should become tight, she will call animal spirits for support.")

        call this.AddSound("Units\\NightElf\\HeroMoonPriestess\\HeroMoonPriestessPissed3.wav")
        call this.AddSound("Units\\NightElf\\HeroMoonPriestess\\HeroMoonPriestessPissed5.wav")
        call this.AddSound("Units\\NightElf\\HeroMoonPriestess\\HeroMoonPriestessWhat2.wav")

		//Drakul
        set this = thistype.Create(preplaced.unit_20, "The Count is a close combat user, even if he does not come with the most of hitpoints. In return, he is able to suck life from his enemies and is granted another chance with 'Rigor Mortis'.")

		call this.AddSound("Units\\Undead\\HeroDreadLord\\HeroDreadlordWhat1.wav")

		//Jota
        set this = thistype.Create(preplaced.unit_21, "An elven acquaintance of Count Drakul. There is not much known about this character either but he seems to be into general magics.")

		call this.AddSound("Units\\Human\\Kael\\KaelYes4.wav")

		//Kera
        set this = thistype.Create(preplaced.unit_24, "Covered in metal, Kera is the Sarafin family's bodyguard and mentor of Aruruw. Underneath her cloak, she holds a whole armory of devastating weapons which she knows well to effectively make use of in combat.")

        call this.AddSound("Units\\NightElf\\HeroWarden\\HeroWardenPissed7.wav")
        call this.AddSound("Units\\NightElf\\HeroWarden\\HeroWardenReady1.wav")
        call this.AddSound("Units\\NightElf\\HeroWarden\\HeroWardenWarcry1.wav")
        call this.AddSound("Units\\NightElf\\HeroWarden\\HeroWardenWhat1.wav")

		//Lizzy
        set this = thistype.Create(preplaced.unit_25, "This little cheeky fairy has a fragile body, which does not permit her open battles. Since here wings were pulled out, she is not able to fly anymore. Still, she has got a lavish magical potential and is a master of theurgic curses, which could become well handy.")

        call this.AddSound("Units\\Human\\Jaina\\JainaPissed1.wav")
        call this.AddSound("Units\\Human\\Jaina\\JainaPissed3.wav")
        call this.AddSound("Units\\Human\\Jaina\\JainaWhat1.wav")
        call this.AddSound("Units\\Human\\Jaina\\JainaWhat3.wav")

		//Rocketeye
        set this = thistype.Create(preplaced.unit_26, "He is the meter-tall bulwark and has got a heavy punch. Forming a team with his Polar Bear chum, together, boosting the fighting spirit is their aim. Unfortunately, the dwarf is short on legs and hardly experienced in magics.")

        call this.AddSound("Units\\Human\\HeroMountainKing\\HeroMountainKingPissed3.wav")
        call this.AddSound("Units\\Human\\HeroMountainKing\\HeroMountainKingPissed5.wav")
        call this.AddSound("Units\\Human\\HeroMountainKing\\HeroMountainKingPissed6.wav")
        call this.AddSound("Units\\Human\\HeroMountainKing\\HeroMountainKingWhat1.wav")
        call this.AddSound("Units\\Human\\HeroMountainKing\\HeroMountainKingWhat2.wav")

		//Smokealot
        set this = thistype.Create(preplaced.unit_27, "The title 'The Stormpike', this hero maintains, is not for a joke. Using his horse he can reach high speeds and his swordsmanship skills are considerable. Other than that, only average attributes.")

        call this.AddSound("Units\\Undead\\HeroDeathKnight\\DeathKnightPissed3.wav")
        call this.AddSound("Units\\Undead\\HeroDeathKnight\\DeathKnightReady1.wav")
        call this.AddSound("Units\\Undead\\HeroDeathKnight\\DeathKnightWhat1.wav")

		//Stormy
        set this = thistype.Create(preplaced.unit_28, "This lively bear originates from the northern polar regions. About five years ago, he moved here alone because the climate up there never appealed to him. Also, there, he comes badly by beer. He is perhaps the most average in the group except his blood alcohol level. Yet, he can produce mana potions for the rest and alcoholize the enemies.")

		call this.AddSound("Units\\Creeps\\PandarenBrewmaster\\PandarenBrewmasterPissed8.wav")

		//Tajran
        set this = thistype.Create(preplaced.unit_30, "The greenskin is an apprentice of Shamanism. This allows him to heal the other group members and to summon the energies of nature. Maybe, thereby, he can gain the others' trust by doing so. He is seated on the back of a black timber wolf.")

        call this.AddSound("Units\\Orc\\Thrall\\ThrallWhat2.wav")
        call this.AddSound("Units\\Orc\\Thrall\\ThrallYes2.wav")
        call this.AddSound("Units\\Orc\\Thrall\\ThrallYes3.wav")

		call Camera.PanTimed(User.ANY, preplaced.rect_HeroSelection_Center.x, preplaced.rect_HeroSelection_Center.y, 0.)
    endmethod

    initMethod Init of Misc
        set thistype.DUMMY_EVENT_TYPE = EventType.Create()
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()

        call Trigger.CreateFromCode(function thistype.StairwayLeftTrig).RegisterEvent.EnterRegion(Region.CreateFromRectangle(Rectangle.CreateFromSelf(gg_rct_BasementStairwayUpLeft)), null)
        call Trigger.CreateFromCode(function thistype.StairwayRightTrig).RegisterEvent.EnterRegion(Region.CreateFromRectangle(Rectangle.CreateFromSelf(gg_rct_BasementStairwayUpRight)), null)

		call Spirit.Init()
    endmethod
endstruct