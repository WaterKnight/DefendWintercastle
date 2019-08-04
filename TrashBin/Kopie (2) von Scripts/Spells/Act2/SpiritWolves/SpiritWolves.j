//! runtextmacro BaseStruct("SpiritWolves", "SPIRIT_WOLVES")
    static real DURATION
    //! runtextmacro GetKey("KEY")
    static real OFFSET
    static integer SUMMON_AMOUNT
    static Event SUMMON_DEATH_EVENT
    static UnitType SUMMON_UNIT_TYPE

    static Spell THIS_SPELL

    //! import "Spells\Act2\SpiritWolves\obj.j"

    Unit caster
    Group summonGroup
    SpellInstance whichInstance

    static method Event_Summon_Death takes nothing returns nothing
        local Unit caster
        local Unit summon = UNIT.Event.GetTrigger()
        local SpellInstance whichInstance

        local thistype this = summon.Data.Integer.Get(KEY)

        local Group summonGroup = this.summonGroup

        call summon.Data.Integer.Remove(KEY)
        call summon.Event.Remove(SUMMON_DEATH_EVENT)
        call summonGroup.RemoveUnit(summon)

        if (summonGroup.IsEmpty()) then
            set caster = this.caster
            set whichInstance = this.whichInstance

            call this.deallocate()
            call caster.Data.Integer.Remove(KEY)
            call summonGroup.Destroy()
            call whichInstance.Destroy()
        endif
    endmethod

    method CreateSummon takes User casterOwner, real casterX, real casterY, real angle, Group summonGroup returns nothing
        local Unit summon = Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE, casterOwner, casterX, casterY, angle, thistype.DURATION)

        call summon.Data.Integer.Set(KEY, this)
        call summon.Event.Add(SUMMON_DEATH_EVENT)
        call summonGroup.AddUnit(summon)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Unit summon
        local Group summonGroup

        local real angle = caster.Facing.Get()
        local User casterOwner = caster.Owner.Get()
        local thistype this = caster.Data.Integer.Get(KEY)

        local real casterX = caster.Position.X.Get() + thistype.OFFSET * Math.Cos(angle)
        local real casterY = caster.Position.Y.Get() + thistype.OFFSET * Math.Sin(angle)
        local integer iteration = thistype.SUMMON_AMOUNT

        if (this != NULL) then
            set summonGroup = this.summonGroup

            set summon = summonGroup.GetFirst()
            call summonGroup.Refs.Add()

            loop
                call summon.Kill()

                set summon = summonGroup.GetFirst()
                exitwhen (summon == NULL)
            endloop

            call summonGroup.Refs.Remove()
        endif

        if (iteration > 0) then
            set summonGroup = Group.Create()
            set this = thistype.allocate()

            set this.caster = caster
            loop
                call this.CreateSummon(casterOwner, casterX, casterY, angle, summonGroup)

                set iteration = iteration - 1
                exitwhen (iteration < 1)
            endloop
            set this.summonGroup = summonGroup
            set this.whichInstance = SpellInstance.Create(caster, thistype.THIS_SPELL)
            call caster.Data.Integer.Set(KEY, this)
        endif
    endmethod

    static method Init takes nothing returns nothing
        set thistype.SUMMON_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Summon_Death)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct