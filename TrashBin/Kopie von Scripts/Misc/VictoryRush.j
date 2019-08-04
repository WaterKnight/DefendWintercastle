//! runtextmacro BaseStruct("VictoryRush", "VICTORY_RUSH")
    static constant real AREA_RANGE = 400.
    static constant real ATTACK_SPEED_INCREMENT = 0.3
    static Event DEATH_EVENT
    static Buff DUMMY_BUFF
    static constant real DURATION = 15.
    static Group ENUM_GROUP
    static constant real MOVEMENT_SPEED_INCREMENT = 0.2
    static BoolExpr TARGET_FILTER
    static constant string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"

    static Spell THIS_SPELL

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Attack.Speed.BonusA.Subtract(thistype.ATTACK_SPEED_INCREMENT)
        call target.Movement.Speed.RelativeA.Subtract(thistype.MOVEMENT_SPEED_INCREMENT)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Attack.Speed.BonusA.Add(thistype.ATTACK_SPEED_INCREMENT)
        call target.Movement.Speed.RelativeA.Add(thistype.MOVEMENT_SPEED_INCREMENT)
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (filterUnit.IsAllyOf(User.SPAWN) == false) then
            return false
        endif

        return true
    endmethod

    static method Event_Death takes nothing returns nothing
        local Unit target
        local Unit whichUnit = UNIT.Event.GetTrigger()

        local real x = whichUnit.Position.X.Get()
        local real y = whichUnit.Position.Y.Get()

        call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, thistype.AREA_RANGE, thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, thistype.DURATION)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif

        call Difficulty.SELECTED.SetLifeFactor(Difficulty.SELECTED.GetLifeFactor() + 0.01)

        call Game.DisplayTextTimed(User.ANY, String.Color.Do("Notification:", String.Color.GOLD) + " A defender died: Spawns have now " + Real.ToIntString(Difficulty.SELECTED.GetLifeFactor() * 100.) + Char.PERCENT + " life.", 10.)
    endmethod

    static method Event_HeroPick takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Add(DEATH_EVENT)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call Event.Create(HeroSelection.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_HeroPick).AddToStatics()

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "ViR", "Victory Rush", "1", "false", "ReplaceableTextures\\CommandButtons\\BTNBattleRoar.blp", "This unit is in an adrenaline rush after having defeated an enemy hero nearby.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDispel(true)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\NightElf\\BattleRoar\\RoarTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    endmethod
endstruct