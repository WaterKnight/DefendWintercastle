//! runtextmacro BaseStruct("ElementalSpellToHero", "ELEMENTAL_SPELL_TO_HERO")
    static Event CREATE_EVENT
    static Group ENUM_GROUP
    //! runtextmacro GetKey("KEY")

    Spell whichSpell

    eventMethod Event_Create
        local thistype this = params.UnitType.GetTrigger().Data.Integer.Get(KEY)
        local Unit whichUnit = params.Unit.GetTrigger()

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

    initMethod Init of Spells_Grant_Elementals
        set thistype.CREATE_EVENT = Event.Create(Unit.CREATE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Create)
        set thistype.ENUM_GROUP = Group.Create()

        call thistype.Create(UnitType.ARURUW, TwinWolves.THIS_SPELL)
        call thistype.Create(UnitType.DRAKUL, ChillyBreath.THIS_SPELL)
        call thistype.Create(UnitType.JOTA, IceShock.THIS_SPELL)
        call thistype.Create(UnitType.KERA, GhostSword.THIS_SPELL)
        call thistype.Create(UnitType.LIZZY, Fireburst.THIS_SPELL)
        call thistype.Create(UnitType.ROCKETEYE, Monolith.THIS_SPELL)
        call thistype.Create(UnitType.SMOKEALOT, InnerForce.THIS_SPELL)
        call thistype.Create(UnitType.STORMY, Severance.THIS_SPELL)
        call thistype.Create(UnitType.TAJRAN, Thunderstrike.THIS_SPELL)
    endmethod
endstruct