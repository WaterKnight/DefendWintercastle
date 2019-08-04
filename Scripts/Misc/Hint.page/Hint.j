//! runtextmacro BaseStruct("Hint", "HINT")
    static constant real INTERVAL = 60.

    static boolean SHOW = false

    string text

    timerMethod Interval
        local thistype this

        if thistype.SHOW then
            set this = thistype.RandomFromList(ARRAY_MIN, thistype.ALL_COUNT)

            call Game.DisplayTextTimed(User.ANY, String.Color.Do("Hint " + Integer.ToString(this.GetIndex() + 1 - ARRAY_MIN) + " of " + Integer.ToString(thistype.ALL_COUNT + 1 - ARRAY_MIN) + ": ", String.Color.GOLD) + this.text, 10.)
        endif
    endmethod

    eventMethod Event_AfterIntro
        call Timer.Create().Start(thistype.INTERVAL, true, function thistype.Interval)
    endmethod

    static method Create takes string text returns thistype
        local thistype this = thistype.allocate()

        set this.text = text

        call this.AddToList()

        return this
    endmethod

    initMethod Init of Misc_2
        call thistype.Create("You receive a notification message each time when there are creep camps in the next level. These creeps spawn outside of the castle and drop some unique effect besides gold/xp like permanent stats bonuses or temporary buffs.")
        call thistype.Create("Regard one of the modern travelling services that are next to the side entrances of the castle to spend a visit at the tavern.")
        call thistype.Create("Explore the vast castle library that holds ancient wisdom of nature-bound magic.")
        call thistype.Create("Wintercastle lies in the crystal mountains, behind the shadowy forest that never met the light of spring.")
        call thistype.Create("1-2 heroes should be enough to take care of normal creep camps. The taverns serve 'Tropical Rainbow' for free, but only one vial at a time. You may use it to fast return to the castle or to approach the other camp. It also boosts the attack speed so can be compoundable with finishing off the creeps.")

        call Event.Create(AfterIntro.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_AfterIntro).AddToStatics()
    endmethod
endstruct