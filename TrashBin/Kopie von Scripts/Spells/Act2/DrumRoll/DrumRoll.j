//! runtextmacro Spell_OpenScope("/")

//! runtextmacro Folder("DrumRoll")
    //! runtextmacro Struct("Target")
        static real DAMAGE_RELATIVE_INCREMENT
        static Event DEATH_EVENT
        static Buff DUMMY_BUFF
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
        static string TARGET_EFFECT_ATTACH_POINT
        static string TARGET_EFFECT_PATH

        real damageAdd
        DrumRoll parent
        UnitEffect targetEffect

        method Ending takes DrumRoll parent, Unit target, Group targetGroup returns nothing
            local real damageAdd = this.damageAdd
            local UnitEffect targetEffect = this.targetEffect

            call target.Damage.Relative.Subtract(damageAdd)
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Buffs.Remove(DUMMY_BUFF)
                call target.Event.Remove(DEATH_EVENT)
            endif
            call target.Data.Integer.Remove(KEY_ARRAY_DETAIL + parent)
            if (targetEffect != NULL) then
                call targetEffect.Destroy()
            endif
            call targetGroup.RemoveUnit(target)
        endmethod

        method EndingByParent takes Unit target, Group targetGroup returns nothing
            local DrumRoll parent = this

            set this = target.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)

            call this.Ending(parent, target, targetGroup)
        endmethod

        static method Event_Death takes nothing returns nothing
            local DrumRoll parent
            local Unit target = UNIT.Event.GetTrigger()
            local thistype this

            local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                set this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                set parent = this.parent

                call this.Ending(parent, target, parent.targetGroup)

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method Start takes Unit caster, integer level, Unit target, Group targetGroup returns nothing
            local real damageAdd = thistype.DAMAGE_RELATIVE_INCREMENT
            local DrumRoll parent = this

            set this = thistype.allocate()
            set this.damageAdd = damageAdd
            set this.parent = parent
            if (target != caster) then
                set this.targetEffect = target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
            else
                set this.targetEffect = NULL
            endif
            call target.Damage.Relative.Add(damageAdd)
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Buffs.Add(thistype.DUMMY_BUFF, level)
                call target.Event.Add(DEATH_EVENT)
            endif
            call target.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)
            call targetGroup.AddUnit(target)
        endmethod

        static method Init takes nothing returns nothing
            //! import obj_DrumRoll_Target.j

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "DrR", "Drum Roll", "1", "true", "ReplaceableTextures\\PassiveButtons\\PASBTNDrum.blp", "This brave warrior listens to the sound of war drums; its attack damage is increased. This buff stacks.")

            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("DrumRoll", "DRUM_ROLL")
    static Event DEATH_EVENT
    static Buff DUMMY_BUFF
    static Group ENUM_GROUP
    static Group ENUM_GROUP2
    static Event REVIVE_EVENT
    static BoolExpr TARGET_FILTER
    static constant real UPDATE_TIME = 0.75

    static Spell THIS_SPELL

    boolean activated
    real areaRange
    integer level
    Group targetGroup
    Timer updateTimer

    //! runtextmacro LinkToStruct("DrumRoll", "Target")

    method ClearTargetGroup takes Group targetGroup returns nothing
        local Unit target

        loop
            set target = targetGroup.GetFirst()
            exitwhen (target == NULL)

            call this.Target.EndingByParent(target, targetGroup)
        endloop
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local boolean activated = this.activated
        local Group targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer

        call this.ClearTargetGroup(targetGroup)

        if (activated) then
            call target.Event.Remove(DEATH_EVENT)
        else
            call target.Event.Remove(REVIVE_EVENT)
        endif
        call targetGroup.Destroy()
        call updateTimer.Destroy()
    endmethod

    static method Event_Death takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        set this.activated = false
        call target.Event.Add(REVIVE_EVENT)
        call target.Event.Remove(DEATH_EVENT)
        call this.ClearTargetGroup(this.targetGroup)
        call updateTimer.Pause()
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (filterUnit.IsAllyOf(User.TEMP) == false) then
            return false
        endif

        return true
    endmethod

    static method Update takes nothing returns nothing
        local integer level
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this
        local Group targetGroup = this.targetGroup

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), this.areaRange, thistype.TARGET_FILTER)

        call thistype.ENUM_GROUP.RemoveUnit(caster)

        set target = targetGroup.GetFirst()

        if (target != NULL) then
            loop
                if (thistype.ENUM_GROUP.ContainsUnit(target)) then
                    call thistype.ENUM_GROUP.RemoveUnit(target)
                    call thistype.ENUM_GROUP2.AddUnit(target)
                    call targetGroup.RemoveUnit(target)
                else
                    call this.Target.EndingByParent(target, targetGroup)
                endif

                set target = targetGroup.GetFirst()
                exitwhen (target == NULL)
            endloop

            call targetGroup.AddGroupClear(thistype.ENUM_GROUP2)
        endif

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set level = this.level

            loop
                call this.Target.Start(caster, level, target, targetGroup)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_Revive takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Event.Add(DEATH_EVENT)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()
        local Timer updateTimer = Timer.Create()

        local thistype this = target

        set this.activated = true
        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.level = level
        set this.targetGroup = Group.Create()
        set this.updateTimer = updateTimer

        call target.Event.Add(DEATH_EVENT)
        call updateTimer.SetData(this)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)
    endmethod

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_DrumRoll.j

        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.ENUM_GROUP2 = Group.Create()
        set thistype.REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Revive)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))

            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDeath(false)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\CommandAura\\CommandAura.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)

        call thistype(NULL).Target.Init()

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct