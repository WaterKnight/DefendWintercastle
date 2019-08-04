//! runtextmacro BaseStruct("Artifact", "ARTIFACT")
    static Event CREATE_EVENT
    static Group ENUM_GROUP
    //! runtextmacro GetKey("KEY")
    static boolean STARTED

    Spell whichSpell

    eventMethod Event_Create
    	local UnitType whichUnitType = params.UnitType.GetTrigger()
        local Unit whichUnit = params.Unit.GetTrigger()

		local thistype this = whichUnitType.Data.Integer.Get(KEY)

        call HeroSpell.AddToUnit(this.whichSpell, whichUnit)

        call whichUnit.Abilities.Add(this.whichSpell)
    endmethod

    enumMethod Create_Enum
        local Unit whichUnit = UNIT.Event.Native.GetEnum()

        local thistype this = whichUnit.Type.Get().Data.Integer.Get(KEY)

        call HeroSpell.AddToUnit(this.whichSpell, whichUnit)

        call whichUnit.Abilities.Add(this.whichSpell)
    endmethod

    static method Create takes UnitType whichUnitType, Spell whichSpell returns thistype
        local thistype this = thistype.allocate()

        set this.whichSpell = whichSpell
        call whichUnitType.Data.Integer.Set(KEY, this)
        call whichUnitType.Event.Add(CREATE_EVENT)

        call Unit.EnumOfType(whichUnitType, function thistype.Create_Enum)

        return this
    endmethod

    static method Start takes nothing returns nothing
        set thistype.CREATE_EVENT = Event.Create(Unit.CREATE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Create)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.STARTED = true

        call thistype.Create(UnitType.ARURUW, HawkEye.THIS_SPELL)
        call thistype.Create(UnitType.DRAKUL, BatSwarm.THIS_SPELL)
        call thistype.Create(UnitType.JOTA, WhiteStaff.THIS_SPELL)
        call thistype.Create(UnitType.KERA, SilentBoots.THIS_SPELL)
        call thistype.Create(UnitType.LIZZY, VioletEarring.THIS_SPELL)
        call thistype.Create(UnitType.ROCKETEYE, StoneShield.THIS_SPELL)
        call thistype.Create(UnitType.SMOKEALOT, SapphireblueDagger.THIS_SPELL)
        call thistype.Create(UnitType.STORMY, MagicBottle.THIS_SPELL)
        call thistype.Create(UnitType.TAJRAN, TaintedLeaf.THIS_SPELL)

        call Game.DisplayTextTimed(User.ANY, String.Color.Do("Artifacts are enabled.", String.Color.BONUS), 30.)
    endmethod

    initMethod Init of Misc_4
        set thistype.STARTED = false
    endmethod
endstruct