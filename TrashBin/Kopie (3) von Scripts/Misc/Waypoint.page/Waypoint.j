//! runtextmacro Folder("Waypoint")
    //! runtextmacro Folder("RegionCheck")
        //! runtextmacro Struct("Retreat")
            static Buff DUMMY_BUFF
            static constant real DURATION = 5.
            static constant real LIFE_REGENERATION_RELATIVE_INCREMENT = 4.
            static constant real MOVE_SPEED_RELATIVE_INCREMENT = 0.5

            static method Event_BuffLose takes nothing returns nothing
                local Unit target = UNIT.Event.GetTrigger()

                call target.LifeRegeneration.Relative.Subtract(thistype.LIFE_REGENERATION_RELATIVE_INCREMENT)
                call target.Movement.Speed.RelativeA.Subtract(thistype.MOVE_SPEED_RELATIVE_INCREMENT)
            endmethod

            static method Event_BuffGain takes nothing returns nothing
                local Unit target = UNIT.Event.GetTrigger()

                call target.LifeRegeneration.Relative.Add(thistype.LIFE_REGENERATION_RELATIVE_INCREMENT)
                call target.Movement.Speed.RelativeA.Add(thistype.MOVE_SPEED_RELATIVE_INCREMENT)
            endmethod

            static method Start takes Unit target returns nothing
                call target.Attack.DisableTimed(thistype.DURATION, UNIT.Attack.NONE_BUFF)
                call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, thistype.DURATION)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.SetLostOnDeath(true)
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Human\\ManaShield\\ManaShieldCaster.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("RegionCheck")
        static Buff DUMMY_BUFF
        static constant real DURATION = 3.

        Timer durationTimer

        //! runtextmacro LinkToStruct("RegionCheck", "Retreat")

        static method EndingByTimer takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            call target.Buffs.Remove(thistype.DUMMY_BUFF)

            call thistype(NULL).Retreat.Start(target)

            call WAYPOINT.Spawns.Update(target)
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local Timer durationTimer = this.durationTimer

            call durationTimer.Destroy()
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Timer durationTimer = Timer.Create()
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            set this.durationTimer = durationTimer
            call durationTimer.SetData(this)

            call durationTimer.Start(thistype.DURATION, false, function thistype.EndingByTimer)
        endmethod

        static method Trig takes nothing returns nothing
            local Unit whichUnit = UNIT.Event.Native.GetTrigger()

            if (whichUnit.Owner.Get() != User.SPAWN) then
                return
            endif

            call whichUnit.Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        static method Init takes nothing returns nothing
            local Region dummyRegion = Region.Create()

            call dummyRegion.AddRect(Rectangle.CreateFromSelf(gg_rct_Waypoint_RegionCheck))
            call dummyRegion.AddRect(Rectangle.CreateFromSelf(gg_rct_Waypoint_RegionCheck2))
            call Trigger.CreateFromCode(function thistype.Trig).RegisterEvent.LeaveRegion(dummyRegion, null)

                set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.SetLostOnDeath(true)
                call thistype.DUMMY_BUFF.SetShowCountdown(true)
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)

            call thistype(NULL).Retreat.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Spawns")
        static Event DESTROY_EVENT
        static Buff DUMMY_BUFF
        static Event IDLE_EVENT
        static Event OWNER_CHANGE_EVENT
        static constant integer WANDER_SPELL_ID = 'Awan'

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

        Waypoint parent

        static method Update takes Unit whichUnit returns nothing
            local Waypoint next
            local thistype this = whichUnit
            local real x
            local real y

            local Waypoint parent = this.parent

            if (parent == NULL) then
                return
            endif

            set next = parent.GetNext()

            if (next == NULL) then
                if (SpawnType.GetFromType(whichUnit.Type.Get()).IsRunner()) then
                    call whichUnit.Order.UnitTarget(Order.ATTACK, Meteorite.THIS_UNIT)
                else
                    call whichUnit.Order.PointTarget(Order.ATTACK, Meteorite.THIS_UNIT.Position.X.Get(), Meteorite.THIS_UNIT.Position.Y.Get())
                endif
            else
                set x = next.GetCenterX()
                set y = next.GetCenterY()

                if (SpawnType.GetFromType(whichUnit.Type.Get()).IsRunner()) then
                    call whichUnit.Order.PointTarget(Order.MOVE, x, y)
                else
                    call whichUnit.Order.PointTarget(Order.ATTACK, x, y)
                endif
            endif
        endmethod

        method Event_Enter takes Unit whichUnit returns nothing
            local Waypoint parent = this

            if (thistype.ACTIVE_LIST_Contains(whichUnit) == false) then
                return
            endif

            set this = whichUnit

            set this.parent = parent

            call thistype.Update(whichUnit)
        endmethod

        static method Event_Idle takes nothing returns nothing
            call thistype.Update(UNIT.Event.GetTrigger())
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            call target.Order.Events.Idle.Unreg(IDLE_EVENT)

            call thistype.ACTIVE_LIST_Remove(target)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            set this.parent = NULL
            call target.Event.Add(DESTROY_EVENT)
            call target.Event.Add(OWNER_CHANGE_EVENT)

            call target.Order.Events.Idle.Reg(IDLE_EVENT)

            call thistype.ACTIVE_LIST_Add(target)
        endmethod

        static method Event_OwnerChange takes nothing returns nothing
            call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            call target.Event.Remove(DESTROY_EVENT)
            call target.Event.Remove(OWNER_CHANGE_EVENT)
        endmethod

        static method Event_GameOver takes nothing returns nothing
            local thistype this
            local Unit target

            call thistype.FOR_EACH_LIST_Set()

            loop
                set this = thistype.FOR_EACH_LIST_FetchFirst()

                exitwhen (this == NULL)

                set target = this

                call target.Buffs.Remove(thistype.DUMMY_BUFF)

                call target.Abilities.AddBySelf(thistype.WANDER_SPELL_ID)

                call target.Animation.Set(Animation.VICTORY)

                call target.Animation.Queue(Animation.SPELL)
            endloop
        endmethod

        static method Event_Spawn takes nothing returns nothing
            call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Destroy)
            set thistype.IDLE_EVENT = Event.Create(UNIT.Order.Events.Idle.INTERVAL_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Idle)
            set thistype.OWNER_CHANGE_EVENT = Event.Create(UNIT.Owner.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_OwnerChange)
            call Event.Create(Meteorite.GAME_OVER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_GameOver).AddToStatics()
            call Event.Create(Spawn.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Spawn).AddToStatics()

            call InitAbility(thistype.WANDER_SPELL_ID)

                set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Waypoint", "WAYPOINT")
    //! runtextmacro GetKey("KEY")

    static thistype CENTER

    //! runtextmacro LinkToStruct("Waypoint", "RegionCheck")
    //! runtextmacro LinkToStruct("Waypoint", "Spawns")

    //! runtextmacro CreateAnyState("next", "Next", "thistype")
    //! runtextmacro CreateAnyState("source", "Source", "Rectangle")

    static method GetFromSelf takes Region self returns thistype
        return self.Data.Integer.Get(KEY)
    endmethod

    static method GetFromSource takes Rectangle source returns thistype
        return source.Data.Integer.Get(KEY)
    endmethod

    method GetCenterX takes nothing returns real
        return this.GetSource().GetCenterX()
    endmethod

    method GetCenterY takes nothing returns real
        return this.GetSource().GetCenterY()
    endmethod

    static method Trig takes nothing returns nothing
        local thistype this = Region.GetTrigger().Data.Integer.Get(KEY)

        call this.Spawns.Event_Enter(UNIT.Event.Native.GetTrigger())
    endmethod

    static method Create takes Rectangle source, thistype next returns thistype
        local thistype this = thistype.allocate()
        local Region sourceRegion = Region.CreateFromRectangle(source)

        call this.SetNext(next)
        call this.SetSource(source)

        call source.Data.Integer.Set(KEY, this)
        call sourceRegion.Data.Integer.Set(KEY, this)

        call Trigger.CreateFromCode(function thistype.Trig).RegisterEvent.EnterRegion(sourceRegion, null)

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.CENTER = thistype.Create(Rectangle.CreateFromSelf(gg_rct_SpawnCenter), NULL)

        call thistype.Create(Rectangle.CreateFromSelf(gg_rct_SpawnBottomIn), thistype.CENTER)
        call thistype.Create(Rectangle.CreateFromSelf(gg_rct_SpawnLeftIn), thistype.CENTER)
        call thistype.Create(Rectangle.CreateFromSelf(gg_rct_SpawnRightIn), thistype.CENTER)

        call thistype(NULL).RegionCheck.Init()
        call thistype(NULL).Spawns.Init()
    endmethod
endstruct