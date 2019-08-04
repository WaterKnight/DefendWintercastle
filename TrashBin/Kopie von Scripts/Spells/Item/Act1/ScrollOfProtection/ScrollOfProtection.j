//! runtextmacro Spell_OpenScope("/")

//! runtextmacro Folder("ScrollOfProtection")
    //! runtextmacro Struct("Target")
        static real ARMOR_INCREMENT
        static Buff DUMMY_BUFF
        static real DURATION

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            call target.Armor.Bonus.Subtract(thistype.ARMOR_INCREMENT)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            call target.Armor.Bonus.Add(thistype.ARMOR_INCREMENT)
        endmethod

        method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION)
        endmethod

        static method Init takes nothing returns nothing
            //! import obj_ScrollOfProtection_Target.j

                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "ScP", "Scroll of Protection", "1", "true", "ReplaceableTextures\\CommandButtons\\BTNScroll.blp", "Is affected by an uberdosis of vitamins.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.SetLostOnDispel(true)
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Items\\AIda\\AIdaTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.NORMAL)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("ScrollOfProtection", "SCROLL_OF_PROTECTION")
    static Group ENUM_GROUP
    static string SPECIAL_EFFECT_PATH
    static BoolExpr TARGET_FILTER

    static Spell THIS_SPELL

    //! runtextmacro LinkToStruct("ScrollOfProtection", "Target")

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.NEUTRAL)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP) == false) then
            return false
        endif

        return true
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()
        local Unit target

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        call Spot.CreateEffect(casterX, casterY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.NORMAL).Destroy()

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(casterX, casterY, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)

                call thistype(NULL).Target.Start(level, target)
            endloop
        endif
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_ScrollOfProtection.j

        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Target.Init()

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct