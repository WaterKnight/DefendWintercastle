//! runtextmacro BaseStruct("HeroSelection", "HERO_SELECTION")
    static Rectangle CENTER_RECT
    static real CENTER_X
    static real CENTER_Y
    static Event DESELECTION_EVENT
    static EventType DUMMY_EVENT_TYPE
    static GameMessage array LAST_MESSAGE
    static Unit array LAST_SELECTED
    static Group HERO_GROUP
    //! runtextmacro GetKey("KEY")
    static Unit array PICKED_UNIT
    static Event SELECTION_EVENT
    //! runtextmacro GetKeyArray("SOUNDS_KEY_ARRAY")
    static constant string SPECIAL_EFFECT_ATTACH_POINT = AttachPoint.ORIGIN
    static constant string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
    static real STAIRWAY_TARGET_X
    static real STAIRWAY_TARGET_Y

    static thistype ARURUW
    static thistype DRAKUL
    static thistype JOTA
    static thistype KERA
    static thistype LIZZY
    static thistype ROCKETEYE
    static thistype SMOKEALOT
    static thistype STORMY
    static thistype TAJRAN

    string description
    string name
    TextTag nameTag
    Unit whichUnit

    static method TriggerEvents takes User whichPlayer, Unit whichUnit returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local EventPriority priority

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call UNIT.Event.SetTrigger(whichUnit)
                call USER.Event.SetTrigger(whichPlayer)

                call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    static method StairwayTrig takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.Native.GetTrigger()

        local User whichUnitOwner = whichUnit.Owner.Get()

        if (whichUnit != thistype.PICKED_UNIT[whichUnitOwner]) then
            return
        endif

        call whichUnit.Data.Integer.Remove(KEY)

        call whichUnit.Invulnerability.Subtract(UNIT.Invulnerability.NONE_BUFF)
        call whichUnit.Items.Create(Meat.THIS_ITEM, true)
        call whichUnit.Position.SetWithCollision(thistype.STAIRWAY_TARGET_X, thistype.STAIRWAY_TARGET_Y)
        call whichUnit.Silence.Subtract(UNIT.Silence.NONE_BUFF)
        call whichUnit.SkillPoints.Add(1)
        call whichUnitOwner.Hero.Set(whichUnit)
        call whichUnitOwner.State.Add(PLAYER_STATE_RESOURCE_GOLD, 300)

        call Camera.PanTimed(whichUnitOwner, whichUnit.Position.X.Get(), whichUnit.Position.Y.Get(), 2.)
        call whichUnit.Items.Create(IceTea.ICE_TEA, true)

        if (Difficulty.SELECTED == Difficulty.TEST) then
            call whichUnit.Level.Set(3)
            call whichUnitOwner.State.Add(PLAYER_STATE_RESOURCE_LUMBER, 250)
        endif

        call thistype.TriggerEvents(whichUnitOwner, whichUnit)
    endmethod

    static method Trig_Conditions takes User whichPlayer, Unit whichUnit returns boolean
        if (thistype.HERO_GROUP.ContainsUnit(whichUnit) == false) then
            return false
        endif
        if (whichPlayer.Hero.Get() != NULL) then
            return false
        endif

        return true
    endmethod

    method Destroy takes Unit whichUnit returns nothing
        local TextTag nameTag = this.nameTag

        call this.deallocate()
        call nameTag.Destroy()
        call whichUnit.Data.Integer.Remove(KEY)
    endmethod

    static method Event_Deselect takes nothing returns nothing
        local User whichPlayer = USER.Event.Native.GetTrigger()
        local Unit whichUnit = UNIT.Event.Native.GetTrigger()

        if (thistype.Trig_Conditions(whichPlayer, whichUnit)) then
            set thistype.LAST_SELECTED[whichPlayer] = NULL
            call Game.ClearTextMessages(whichPlayer)
        endif
    endmethod

    static method Event_Select takes nothing returns nothing
        local thistype this
        local User whichPlayer = USER.Event.Native.GetTrigger()
        local Unit whichUnit = UNIT.Event.Native.GetTrigger()

        if (thistype.Trig_Conditions(whichPlayer, whichUnit)) then
            set this = whichUnit.Data.Integer.Get(KEY)

            if (thistype.LAST_MESSAGE[whichPlayer] != NULL) then
                call thistype.LAST_MESSAGE[whichPlayer].Destroy()

                set thistype.LAST_MESSAGE[whichPlayer] = NULL
            endif

            if (thistype.LAST_SELECTED[whichPlayer] == whichUnit) then
                //call this.Destroy(whichUnit)

                if (thistype.PICKED_UNIT[whichPlayer] != NULL) then
                    call thistype.PICKED_UNIT[whichPlayer].Event.Add(DESELECTION_EVENT)
                    call thistype.PICKED_UNIT[whichPlayer].Event.Add(SELECTION_EVENT)

                    call thistype.HERO_GROUP.AddUnit(thistype.PICKED_UNIT[whichPlayer])
                    call thistype.PICKED_UNIT[whichPlayer].Owner.Set(User.CASTLE)
                    call PauseUnit(thistype.PICKED_UNIT[whichPlayer].self, true)
                endif

                set thistype.PICKED_UNIT[whichPlayer] = whichUnit

                call whichUnit.Event.Remove(DESELECTION_EVENT)
                call whichUnit.Event.Remove(SELECTION_EVENT)

                call thistype.HERO_GROUP.RemoveUnit(whichUnit)
                call whichUnit.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
                call PauseUnit(whichUnit.self, false)
                call whichUnit.Owner.Set(whichPlayer)
            else
                set thistype.LAST_MESSAGE[whichPlayer] = GameMessage.Create(this.description, whichPlayer)
                set thistype.LAST_SELECTED[whichPlayer] = whichUnit
                call Sound(this.whichUnit.Data.Integer.Table.RandomAll(SOUNDS_KEY_ARRAY)).PlayForPlayer(whichPlayer)

                call whichUnit.Animation.Set(Animation.ATTACK)
                call whichUnit.Animation.Queue(Animation.STAND)
            endif
        endif
    endmethod

    method AddSound takes string path returns nothing
        local Sound whichSound = Sound.Create(path, false, false, false, 0, 0, SoundEax.DEFAULT)

        call this.whichUnit.Data.Integer.Table.Add(SOUNDS_KEY_ARRAY, whichSound)
    endmethod

    static method Create takes UnitType whichUnitType, string description, rect whichRectSelf returns thistype
        local TextTag nameTag = TextTag.Create(TextTag.GetFreeId())
        local thistype this = thistype.allocate()
        local Rectangle whichRect = Rectangle.CreateFromSelf(whichRectSelf)

        local real x = whichRect.GetCenterX()
        local real y = whichRect.GetCenterY()

        local Unit whichUnit = Unit.Create(whichUnitType, User.CASTLE, x, y, Math.AtanByDeltas(thistype.CENTER_Y - y, thistype.CENTER_X - x))

        set this.name = String.Color.Do(whichUnit.GetProperName(), "ffaaaa00")
        set this.whichUnit = whichUnit
        set this.nameTag = nameTag
        call whichUnit.Data.Integer.Set(KEY, this)
        call whichUnit.Event.Add(DESELECTION_EVENT)
        call whichUnit.Event.Add(SELECTION_EVENT)

        call thistype.HERO_GROUP.AddUnit(whichUnit)
        //call nameTag.Position.SetCentered(true)
        call nameTag.Position.Set(x - 50., y, 200.)

        call PauseUnit(whichUnit.self, true)
        call whichUnit.Invulnerability.Add(UNIT.Invulnerability.NONE_BUFF)
        call whichUnit.Silence.Add(UNIT.Silence.NONE_BUFF)
        call whichUnit.SkillPoints.Set(0)

        return this
    endmethod

    static method Event_Start takes nothing returns nothing
        set thistype.CENTER_X = thistype.CENTER_RECT.GetCenterX()
        set thistype.CENTER_Y = thistype.CENTER_RECT.GetCenterY()

        set thistype.ARURUW = thistype.Create(UnitType.ARURUW, "Fast, strong, graceful and a superior handling with the bow adorn the reputation of this young defender. In contrast, she cannot keep pace in melee and owns a minor mana pool. If it should become tight, she will call animal spirits for support.", gg_rct_HeroSelection_Aruruw)
        set thistype.DRAKUL = thistype.Create(UnitType.DRAKUL, "The Count is a close combat user, even if he does not come with the most of hitpoints. In return, he is able to suck life from his enemies and is granted another chance with 'Rigor Mortis'.", gg_rct_HeroSelection_Drakul)
        set thistype.JOTA = thistype.Create(UnitType.JOTA, "An elven acquaintance of Count Drakul. There is not much known about this character either but he seems to be into general magics.", gg_rct_HeroSelection_Jota)
        set thistype.KERA = thistype.Create(UnitType.KERA, "Covered in metal, Kera is the Sarafin family's bodyguard and mentor of Aruruw. Underneath her cloak, she holds a whole armory of devastating weapons which she knows well to effectively make use of in combat.", gg_rct_HeroSelection_Kera)
        set thistype.LIZZY = thistype.Create(UnitType.LIZZY, "This little cheeky fairy has a fragile body, which does not permit her open battles. Since here wings were pulled out, she is not able to fly anymore. Still, she has got a lavish magical potential and is a master of theurgic curses, which could become well handy.", gg_rct_HeroSelection_Lizzy)
        set thistype.ROCKETEYE = thistype.Create(UnitType.ROCKETEYE, "He is the meter-tall bulwark and has got a heavy punch. Forming a team with his Polar Bear chum, together, boosting the fighting spirit is their aim. Unfortunately, the dwarf is short on legs and hardly experienced in magics.", gg_rct_HeroSelection_Rocketeye)
        set thistype.SMOKEALOT = thistype.Create(UnitType.SMOKEALOT, "The title 'The Stormpike', this hero maintains, is not for a joke. Using his horse he can reach high speeds and his swordsmanship skills are considerable. Other than that, only average attributes.", gg_rct_HeroSelection_Smokealot)
        set thistype.STORMY = thistype.Create(UnitType.STORMY, "This lively bear originates from the northern polar regions. About five years ago, he moved here alone because the climate up there never appealed to him. Also, there, he comes badly by beer. He is perhaps the most average in the group except his blood alcohol level. Yet, he can produce mana potions for the rest and alcoholize the enemies.", gg_rct_HeroSelection_Stormy)
        set thistype.TAJRAN = thistype.Create(UnitType.TAJRAN, "The greenskin is an apprentice of Shamanism. This allows him to heal the other group members and to summon the energies of nature. Maybe, thereby, he can gain the others' trust by doing so. He is seated on the back of a black timber wolf.", gg_rct_HeroSelection_Tajran)

        call thistype.ARURUW.AddSound("Units\\NightElf\\HeroMoonPriestess\\HeroMoonPriestessPissed3.wav")
        call thistype.ARURUW.AddSound("Units\\NightElf\\HeroMoonPriestess\\HeroMoonPriestessPissed5.wav")
        call thistype.ARURUW.AddSound("Units\\NightElf\\HeroMoonPriestess\\HeroMoonPriestessWhat2.wav")
        call thistype.DRAKUL.AddSound("Units\\Undead\\HeroDreadLord\\HeroDreadlordWhat1.wav")
        call thistype.JOTA.AddSound("Units\\Human\\Kael\\KaelYes4.wav")
        call thistype.KERA.AddSound("Units\\NightElf\\HeroWarden\\HeroWardenPissed7.wav")
        call thistype.KERA.AddSound("Units\\NightElf\\HeroWarden\\HeroWardenReady1.wav")
        call thistype.KERA.AddSound("Units\\NightElf\\HeroWarden\\HeroWardenWarcry1.wav")
        call thistype.KERA.AddSound("Units\\NightElf\\HeroWarden\\HeroWardenWhat1.wav")
        call thistype.LIZZY.AddSound("Units\\Human\\Jaina\\JainaPissed1.wav")
        call thistype.LIZZY.AddSound("Units\\Human\\Jaina\\JainaPissed3.wav")
        call thistype.LIZZY.AddSound("Units\\Human\\Jaina\\JainaWhat1.wav")
        call thistype.LIZZY.AddSound("Units\\Human\\Jaina\\JainaWhat3.wav")
        call thistype.ROCKETEYE.AddSound("Units\\Human\\HeroMountainKing\\HeroMountainKingPissed3.wav")
        call thistype.ROCKETEYE.AddSound("Units\\Human\\HeroMountainKing\\HeroMountainKingPissed5.wav")
        call thistype.ROCKETEYE.AddSound("Units\\Human\\HeroMountainKing\\HeroMountainKingPissed6.wav")
        call thistype.ROCKETEYE.AddSound("Units\\Human\\HeroMountainKing\\HeroMountainKingWhat1.wav")
        call thistype.ROCKETEYE.AddSound("Units\\Human\\HeroMountainKing\\HeroMountainKingWhat2.wav")
        call thistype.SMOKEALOT.AddSound("Units\\Undead\\HeroDeathKnight\\DeathKnightPissed3.wav")
        call thistype.SMOKEALOT.AddSound("Units\\Undead\\HeroDeathKnight\\DeathKnightReady1.wav")
        call thistype.SMOKEALOT.AddSound("Units\\Undead\\HeroDeathKnight\\DeathKnightWhat1.wav")
        call thistype.STORMY.AddSound("Units\\Creeps\\PandarenBrewmaster\\PandarenBrewmasterPissed8.wav")
        call thistype.TAJRAN.AddSound("Units\\Orc\\Thrall\\ThrallWhat2.wav")
        call thistype.TAJRAN.AddSound("Units\\Orc\\Thrall\\ThrallYes2.wav")
        call thistype.TAJRAN.AddSound("Units\\Orc\\Thrall\\ThrallYes3.wav")

        set Unit.ARURUW = thistype.ARURUW.whichUnit
        set Unit.DRAKUL = thistype.DRAKUL.whichUnit
        set Unit.KERA = thistype.KERA.whichUnit
        set Unit.LIZZY = thistype.LIZZY.whichUnit
        set Unit.ROCKETEYE = thistype.ROCKETEYE.whichUnit
        set Unit.SMOKEALOT = thistype.SMOKEALOT.whichUnit
        set Unit.STORMY = thistype.STORMY.whichUnit
        set Unit.TAJRAN = thistype.TAJRAN.whichUnit
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration = User.ALL_COUNT
        local User specificPlayer
        local Rectangle stairwayRect = Rectangle.CreateFromSelf(gg_rct_BasementStairwayUpTarget)

        set thistype.CENTER_RECT = Rectangle.CreateFromSelf(gg_rct_HeroSelection_Center)
        set thistype.DESELECTION_EVENT = Event.Create(UNIT.Selection.ENDING_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Deselect)
        set thistype.DUMMY_EVENT_TYPE = EventType.Create()
        set thistype.HERO_GROUP = Group.Create()
        set thistype.SELECTION_EVENT = Event.Create(UNIT.Selection.REPEAT_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Select)
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()

        loop
            exitwhen (iteration < ARRAY_MIN)

            set specificPlayer = User.ALL[iteration]

            set thistype.LAST_MESSAGE[iteration] = NULL
            set thistype.LAST_SELECTED[iteration] = NULL
            set thistype.PICKED_UNIT[iteration] = NULL

            set iteration = iteration - 1
        endloop

        set thistype.STAIRWAY_TARGET_X = stairwayRect.GetCenterX()
        set thistype.STAIRWAY_TARGET_Y = stairwayRect.GetCenterY()
        call Trigger.CreateFromCode(function thistype.StairwayTrig).RegisterEvent.EnterRegion(Region.CreateFromRectangle(Rectangle.CreateFromSelf(gg_rct_BasementStairwayUp)), null)
    endmethod
endstruct