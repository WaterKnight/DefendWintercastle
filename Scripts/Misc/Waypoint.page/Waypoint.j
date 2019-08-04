//! runtextmacro Folder("Waypoint")
    //! runtextmacro Folder("RegionCheck")
        //! runtextmacro Struct("Retreat")
            static method Start takes Unit target returns nothing
                call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, thistype.DURATION)
            endmethod

            static method Init takes nothing returns nothing
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("RegionCheck")
        static Buff DUMMY_BUFF
        static constant real DURATION = 3.

        Timer durationTimer

        //! runtextmacro LinkToStruct("RegionCheck", "Retreat")

        timerMethod EndingByTimer
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            call target.Buffs.Remove(thistype.DUMMY_BUFF)

            call thistype(NULL).Retreat.Start(target)

            call WAYPOINT.Spawns.Update(target)
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            local Timer durationTimer = this.durationTimer

            call durationTimer.Destroy()
        endmethod

        eventMethod Event_BuffGain
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

			local Timer durationTimer = Timer.Create()

            set this.durationTimer = durationTimer
            call durationTimer.SetData(this)

            call durationTimer.Start(thistype.DURATION, false, function thistype.EndingByTimer)
        endmethod

        trigMethod Trig
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
            call dummyRegion.AddRect(Rectangle.CreateFromSelf(gg_rct_Waypoint_RegionCheck3))
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
        static boolean GAME_OVER
        static Event IDLE_EVENT
        static Event OWNER_CHANGE_EVENT
        static Event SPAWN_EVENT

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

        Waypoint parent

        static method Update takes Unit whichUnit returns nothing
            local thistype this = whichUnit

            local Waypoint parent = this.parent

            if thistype.GAME_OVER then
                return
            endif

			local Waypoint next

            if (parent == NULL) then
                set next = NULL//Waypoint.CENTER
            else
                set next = parent.GetNext()
            endif

            if (next == NULL) then
                if SpawnType.GetFromType(whichUnit.Type.Get()).IsRunner() then
                    call whichUnit.Order.UnitTarget(Order.ATTACK, Meteorite.THIS_UNIT)
                else
                    call whichUnit.Order.PointTarget(Order.ATTACK, Meteorite.THIS_UNIT.Position.X.Get(), Meteorite.THIS_UNIT.Position.Y.Get())
                endif
            else
                local real x = next.GetCenterX()
                local real y = next.GetCenterY()

                if SpawnType.GetFromType(whichUnit.Type.Get()).IsRunner() then
                    call whichUnit.Order.PointTarget(Order.MOVE, x, y)
                else
                    call whichUnit.Order.PointTarget(Order.ATTACK, x, y)
                endif
            endif
        endmethod

        method Event_Enter takes Unit whichUnit returns nothing
            local Waypoint parent = this

            if not thistype.ACTIVE_LIST_Contains(whichUnit) then
                return
            endif

            set this = whichUnit

            set this.parent = parent

            call thistype.Update(whichUnit)
        endmethod

        eventMethod Event_Idle
            call thistype.Update(params.Unit.GetTrigger())
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            call target.Order.Events.Idle.Unreg(IDLE_EVENT)

            call thistype.ACTIVE_LIST_Remove(target)
        endmethod

        eventMethod Event_BuffGain
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            set this.parent = NULL
            call target.Event.Add(DESTROY_EVENT)
            call target.Event.Add(OWNER_CHANGE_EVENT)

            if not thistype.GAME_OVER then
                call target.Order.Events.Idle.Reg(IDLE_EVENT)
            endif

            call thistype.ACTIVE_LIST_Add(target)
        endmethod

        eventMethod Event_OwnerChange
            call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        eventMethod Event_Destroy
            local Unit target = params.Unit.GetTrigger()

            call target.Event.Remove(DESTROY_EVENT)
            call target.Event.Remove(OWNER_CHANGE_EVENT)
        endmethod

        eventMethod Event_GameOver
            set thistype.GAME_OVER = true
            //call thistype.SPAWN_EVENT.RemoveFromStatics()

            call thistype.FOR_EACH_LIST_Set()

            loop
                local thistype this = thistype.FOR_EACH_LIST_FetchFirst()
                exitwhen (this == NULL)

                local Unit target = this

                call target.Buffs.Remove(thistype.DUMMY_BUFF)

                call target.Abilities.AddBySelf(thistype.WANDER_SPELL_ID)

                if (target.Classes.Contains(UnitClass.DEAD) == false) then
                    call target.Animation.Set(Animation.VICTORY)

                    call target.Animation.Queue(Animation.SPELL)
                endif
            endloop
        endmethod

        eventMethod Event_Spawn
            call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Destroy)
            set thistype.GAME_OVER = false
            set thistype.IDLE_EVENT = Event.Create(UNIT.Order.Events.Idle.INTERVAL_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Idle)
            set thistype.OWNER_CHANGE_EVENT = Event.Create(UNIT.Owner.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_OwnerChange)
            set thistype.SPAWN_EVENT = Event.Create(Spawn.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Spawn)
            call Event.Create(Meteorite.GAME_OVER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_GameOver).AddToStatics()

            call thistype.SPAWN_EVENT.AddToStatics()

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

    trigMethod Trig
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

    initMethod Init of Misc_5
        set thistype.CENTER = thistype.Create(Rectangle.CreateFromSelf(gg_rct_SpawnCenter), NULL)

        call thistype.Create(Rectangle.CreateFromSelf(gg_rct_SpawnBottomIn), NULL)
        call thistype.Create(Rectangle.CreateFromSelf(gg_rct_SpawnLeftIn), NULL)
        call thistype.Create(Rectangle.CreateFromSelf(gg_rct_SpawnRightIn), NULL)

        call thistype(NULL).RegionCheck.Init()
        call thistype(NULL).Spawns.Init()
    endmethod
endstruct