//! runtextmacro BaseStruct("RaiseDead", "RAISE_DEAD")
    static real DURATION
    static UnitType SUMMON_UNIT_TYPE
    static BoolExpr TARGET_FILTER

    static Spell THIS_SPELL

    static method Conditions takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (filterUnit.Classes.Contains(UnitClass.DEAD) == false) then
            return false
        endif

        return true
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()
        local real targetAngle
        local real targetX
        local real targetY

        local Unit target = GROUP.EnumUnits.InRange.WithCollision.GetNearest(caster.Position.X.Get(), caster.Position.Y.Get(), thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        call caster.Stop()

        if (target != NULL) then
            set targetAngle = target.Facing.Get()
            set targetX = target.Position.X.Get()
            set targetY = target.Position.Y.Get()

            call target.Destroy()

            call Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE, caster.Owner.Get(), targetX, targetY, targetAngle, DURATION)
        endif
    endmethod

    //! textmacro RaiseDead_CreateSpecials takes doExternal
        $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
            //! i function writeLua(code)
                //! i file = io.open("test.lua", "a")

                //! i file:write(code)

                //! i file:close()
            //! i end

            //! i writeLua([[
                //! i setLv("abuf", 1, "BRaD")
                //! i setLv("adur", 1, 0)
                //! i set("aefs", "")
                //! i setLv("ahdu", 1, 0)
                //! i set("asat", "")
            //! i ]])

            //! i setobjecttype("buffs")

            //! i createobject("Bpsh", "BRaD")

            //! i makechange(current, "frac", "orc")
            //! i makechange(current, "fsat", "")
            //! i makechange(current, "ftip", "Raise Dead")
        $doExternal$//! endexternalblock
    //! endtextmacro

    static method Init takes nothing returns nothing
        //! runtextmacro Spell_Create("/", "THIS_SPELL", "ARaD", "Raise Dead")

        //! runtextmacro Spell_SetTypes("/", "SPECIAL_Apsh", "NORMAL")

        //! runtextmacro Spell_SetAreaRange("/", "600.", "false")
        //! runtextmacro Spell_SetButtonPosition("/", "0", "2")
        //! runtextmacro Spell_SetCooldown("/", "7.")
        //! runtextmacro Spell_SetData("/", "DURATION", "duration", "30.")
        //! runtextmacro Spell_SetData("/", "SUMMON_UNIT_TYPE", "summonUnitType", "UnitType.SKELETON")
        //! runtextmacro Spell_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNRaiseDeadOn.blp")
        //! runtextmacro Spell_SetManaCost("/", "75")
        //! runtextmacro Spell_SetOrder("/", "phaseshift")
        //! runtextmacro Spell_SetUberTooltip("/", "Reanimates a corpse in the shape of two serving skeletons.|nThey last for 30 seconds.")

        //! runtextmacro RaiseDead_CreateSpecials("/")

        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct