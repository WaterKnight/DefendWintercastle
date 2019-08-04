//! runtextmacro Spell_OpenScope("/")

//! runtextmacro Folder("Severance")
    //! runtextmacro Struct("Buff")
        static real array ARMOR_INCREMENT
        static Buff DUMMY_BUFF
        static real array DURATION

        real armorAdd

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local real armorAdd = this.armorAdd

            call target.Armor.Bonus.Subtract(armorAdd)
            call target.Revival.Able.Add()
            call target.Silence.Subtract(UNIT.Silence.NONE_BUFF)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real armorAdd = thistype.ARMOR_INCREMENT[level]
            local thistype this = target

            set this.armorAdd = armorAdd
            call target.Armor.Bonus.Add(armorAdd)
            call target.Revival.Able.Subtract()
            call target.Silence.Add(UNIT.Silence.NONE_BUFF)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            //! import obj_Severance_Buff.j

                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "Sev", "Severance", "5", "false", "ReplaceableTextures\\CommandButtons\\BTNAcidBomb.blp", "This unit's bones are deep-frozen. They easily splinter under physical force.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.SetLostOnDispel(true)
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Undead\\UnholyFrenzy\\UnholyFrenzyTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Severance", "SEVERANCE")
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dSev", "Severance", "DUMMY_UNIT_ID", "Abilities\\Weapons\\SkeletalMageMissile\\SkeletalMageMissile.mdl")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER
    static integer array TARGETS_AMOUNT

    static Spell THIS_SPELL

    real areaRange
    Unit caster
    integer level
    integer maxTargetsAmount
    Unit target
    Group targetGroup
    integer targetsAmount

    //! runtextmacro LinkToStruct("Severance", "Buff")

    method Ending takes Group targetGroup returns nothing
        call this.deallocate()
        call targetGroup.Destroy()
    endmethod

    static method Conditions takes Unit target returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif

        return true
    endmethod

    static method Conditions_Group takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (Group.TEMP.ContainsUnit(filterUnit)) then
            return false
        endif
        if (thistype.Conditions(filterUnit) == false) then
            return false
        endif

        return true
    endmethod

    method StartMissile takes real sourceX, real sourceY, real sourceZ, Unit target, Group targetGroup returns nothing
        local Missile dummyMissile = Missile.Create()
        local DummyUnit dummyUnit

        set this.target = target

        call targetGroup.AddUnit(target)

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(900.)
        call dummyMissile.Position.Set(sourceX, sourceY, sourceZ)

        call dummyMissile.GoToUnit.Start(target, false)
    endmethod

    static method Impact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer maxTargetsAmount = this.maxTargetsAmount
        local integer targetsAmount = this.targetsAmount
        local Unit target = this.target
        local Group targetGroup = this.targetGroup

        local real targetX = dummyMissile.Position.X.Get()
        local real targetY = dummyMissile.Position.Y.Get()
        local real targetZ = dummyMissile.Position.Z.Get()

        call dummyMissile.Destroy()

        if (target != NULL) then
            set User.TEMP = caster.Owner.Get()

            if (thistype.Conditions(target)) then
                call thistype(NULL).Buff.Start(level, target)
            endif
        endif

        if (targetsAmount == maxTargetsAmount) then
            call this.Ending(targetGroup)
        else
            set Group.TEMP = targetGroup
            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, this.areaRange, thistype.TARGET_FILTER)

            set target = thistype.ENUM_GROUP.GetNearest(targetX, targetY)

            if (target == NULL) then
                call this.Ending(targetGroup)
            else
                set this.targetsAmount = targetsAmount + 1

                call this.StartMissile(targetX, targetY, targetZ, target, targetGroup)
            endif
        endif
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()
        local Group targetGroup = Group.Create()
        local thistype this = thistype.allocate()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.level = level
        set this.maxTargetsAmount = thistype.TARGETS_AMOUNT[level]
        set this.targetGroup = targetGroup
        set this.targetsAmount = 1

        call this.StartMissile(casterX, casterY, caster.Position.Z.GetByCoords(casterX, casterY) + caster.Outpact.Z.Get(true), target, targetGroup)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_Severance.j

        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions_Group)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Buff.Init()

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct