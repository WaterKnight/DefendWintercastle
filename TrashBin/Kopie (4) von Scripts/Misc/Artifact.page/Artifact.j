//! runtextmacro BaseStruct("Artifact", "ARTIFACT")
    static Event CREATE_EVENT
    static Event DESTROY_EVENT
    static Group ENUM_GROUP
    //! runtextmacro GetKey("KEY")
    static integer LEVEL = 0
    static boolean STARTED
    static Group TARGET_GROUP

    Spell whichSpell

    static method Event_Destroy takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.Event.Remove(DESTROY_EVENT)
        call thistype.TARGET_GROUP.RemoveUnit(whichUnit)
    endmethod

    static method Event_ActStart takes nothing returns nothing
        local thistype this
        local Act whichAct = ACT.Event.GetTrigger()
        local Unit whichUnit

        if (whichAct == Act.FIRST) then
            set thistype.LEVEL = 1
        elseif (whichAct == Act.SECOND) then
            set thistype.LEVEL = 2
        elseif (whichAct == Act.THIRD) then
            set thistype.LEVEL = 3
        elseif (whichAct == Act.FOURTH) then
            set thistype.LEVEL = 4
        elseif (whichAct == Act.FIFTH) then
            set thistype.LEVEL = 5
        elseif (whichAct == Act.SIXTH) then
            set thistype.LEVEL = 6
        else
            return
        endif

        loop
            set whichUnit = thistype.TARGET_GROUP.FetchFirst()

            exitwhen (whichUnit == NULL)

            set this = whichUnit.Type.Get().Data.Integer.Get(KEY)
            call thistype.ENUM_GROUP.AddUnit(whichUnit)

            call whichUnit.Abilities.SetLevel(this.whichSpell, thistype.LEVEL)
        endloop

        call thistype.TARGET_GROUP.AddGroupClear(thistype.ENUM_GROUP)
    endmethod

    static method Event_Create takes nothing returns nothing
        local thistype this = UNIT_TYPE.Event.GetTrigger().Data.Integer.Get(KEY)
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call thistype.TARGET_GROUP.AddUnit(whichUnit)
        call whichUnit.Abilities.SetLevel(this.whichSpell, thistype.LEVEL)
        call whichUnit.Event.Add(DESTROY_EVENT)
    endmethod

    static method Create_Enum takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.Native.GetEnum()

        local thistype this = whichUnit.Type.Get().Data.Integer.Get(KEY)

        call thistype.TARGET_GROUP.AddUnit(whichUnit)
        call whichUnit.Abilities.SetLevel(this.whichSpell, thistype.LEVEL)
        call whichUnit.Event.Add(DESTROY_EVENT)
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
        set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Destroy)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.STARTED = true
        set thistype.TARGET_GROUP = Group.Create()
        call Event.Create(Act.START_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ActStart).AddToStatics()

        call thistype.Create(UnitType.ARURUW, RedwoodValkyrie.THIS_SPELL)
        call thistype.Create(UnitType.DRAKUL, BatSwarm.THIS_SPELL)
        call thistype.Create(UnitType.JOTA, WhiteStaff.THIS_SPELL)
        call thistype.Create(UnitType.KERA, SilentBoots.THIS_SPELL)
        call thistype.Create(UnitType.LIZZY, VioletEarring.THIS_SPELL)
        call thistype.Create(UnitType.ROCKETEYE, Thunderbringer.THIS_SPELL)
        call thistype.Create(UnitType.SMOKEALOT, SapphireblueDagger.THIS_SPELL)
        call thistype.Create(UnitType.STORMY, MagicBottle.THIS_SPELL)
        call thistype.Create(UnitType.TAJRAN, TaintedLeaf.THIS_SPELL)

        call Game.DisplayTextTimed(User.ANY, String.Color.Do("Artifacts are enabled.", String.Color.BONUS), 30.)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.STARTED = false
    endmethod
endstruct