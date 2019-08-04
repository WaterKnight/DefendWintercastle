//! runtextmacro Folder("Severance")
    //! runtextmacro Struct("Buff")
        static real array ARMOR_INCREMENT
        //! runtextmacro Buff_CreateSimpleType("/", "bSev", "Severance", "BUFF_ID", "false", "ReplaceableTextures\\CommandButtons\\BTNAcidBomb.blp", "This unit's bones are deep-frozen. They easily splinter under physical force.", "ASeB", "BUFF_SPELL_ID")
        static Event DEATH_EVENT
        static real array DURATION
        //! runtextmacro GetKey("KEY")
        static constant string TARGET_EFFECT_ATTACH_POINT = AttachPoint.OVERHEAD
        static constant string TARGET_EFFECT_PATH = "Abilities\\Spells\\Undead\\UnholyFrenzy\\UnholyFrenzyTarget.mdl"

        real armorAdd
        Timer durationTimer
        Unit target
        Effect targetEffect

        method Ending takes Timer durationTimer, Unit target returns nothing
            local real armorAdd = this.armorAdd
            local Effect targetEffect = this.targetEffect

            call this.deallocate()
            call durationTimer.Data.Integer.Remove(KEY)
            call durationTimer.Destroy()
            call target.Armor.Bonus.Subtract(armorAdd)
            call target.Buffs.Remove(DUMMY_BUFF)
            call target.Data.Integer.Remove(KEY)
            call target.Event.Remove(DEATH_EVENT)
            call target.Revival.Able.Add()
            call target.Silence.Remove()
            call targetEffect.Destroy()
        endmethod

        static method Event_Death takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target.Data.Integer.Get(KEY)

            call this.Ending(this.durationTimer, target)
        endmethod

        static method EndingByTimer takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.Data.Integer.Get(KEY)

            call this.Ending(durationTimer, this.target)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            local real armorAdd = ARMOR_INCREMENT[level]
            local Timer durationTimer = Timer.Create()
            local thistype this = target.Data.Integer.Get(KEY)

            if (this != NULL) then
                call this.Ending(this.durationTimer, target)
            endif

            set this = thistype.allocate()

            set this.armorAdd = armorAdd
            set this.durationTimer = durationTimer
            set this.target = target
            set this.targetEffect = target.Effects.Create(TARGET_EFFECT_PATH, TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW)
            call durationTimer.Data.Integer.Set(KEY, this)
            call target.Armor.Bonus.Add(armorAdd)
            call target.Buffs.Timed.Start(DUMMY_BUFF, 1, DURATION[level])
            call target.Data.Integer.Set(KEY, this)
            call target.Event.Add(DEATH_EVENT)
            call target.Revival.Able.Remove()
            call target.Silence.Add()

            call durationTimer.Start(DURATION[level], false, function thistype.EndingByTimer)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF_Init()

            set ARMOR_INCREMENT[1] = -3.
            set ARMOR_INCREMENT[2] = -8.
            set ARMOR_INCREMENT[3] = -15.
            set DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
            set DURATION[1] = 10.
            set DURATION[2] = 10.
            set DURATION[3] = 10.
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Severance", "SEVERANCE")
    static constant real AREA_RANGE = 500.
    static constant string CASTER_EFFECT_ATTACH_POINT = AttachPoint.ORIGIN
    static constant string CASTER_EFFECT_PATH = "Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl"
    static constant real DELAY = 0.35
    static constant string EFFECT_LIGHTNING_PATH = "HWSB"
    static Group ENUM_GROUP
    //! runtextmacro GetKey("KEY")
    static constant string TARGET_EFFECT_ATTACH_POINT = AttachPoint.CHEST
    static constant string TARGET_EFFECT_PATH = "Abilities\\Weapons\\LichMissile\\LichMissile.mdl"
    static BoolExpr TARGET_FILTER
    static integer array TARGETS_AMOUNT
    static Spell THIS_SPELL

    Unit caster
    Timer delayTimer
    Unit lastTarget
    integer level
    Group targetGroup
    integer targetsAmount = 1
    integer targetsAmountMax

    //! runtextmacro LinkToStruct("Severance", "Buff")

    method Ending takes Timer delayTimer, Group targetGroup returns nothing
        call this.deallocate()
        call delayTimer.Data.Integer.Remove(KEY)
        call delayTimer.Destroy()
        call targetGroup.Destroy()
    endmethod

    method Impact takes Unit lastTarget, integer level, Unit newTarget, Group targetGroup returns nothing
        local Lightning effectLightning = Lightning.Create(EFFECT_LIGHTNING_PATH, 0., 0., 0., 0., 0., 0.)

        set this.lastTarget = newTarget
        call effectLightning.BetweenUnits.Start(lastTarget, newTarget)
        call effectLightning.DestroyTimed.Start(0.75)
        call newTarget.Effects.Create(TARGET_EFFECT_PATH, TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).DestroyTimed.Start(2.)
        call targetGroup.AddUnit(newTarget)

        call thistype(NULL).Buff.Start(level, newTarget)
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (Group.TEMP.ContainsUnit(filterUnit)) then
            return false
        endif
        if (filterUnit.IsAllyOf(User.TEMP)) then
            return false
        endif
        if (filterUnit.Type.Is(UNIT.Type.DEAD)) then
            return false
        endif
        if (filterUnit.Type.Is(UNIT.Type.MECHANICAL)) then
            return false
        endif

        return true
    endmethod

    static method ChooseNewTargetByTimer takes nothing returns nothing
        local Unit caster
        local Timer delayTimer = Timer.GetExpired()
        local Unit lastTarget
        local real lastTargetX
        local real lastTargetY
        local Unit newTarget

        local thistype this = delayTimer.Data.Integer.Get(KEY)

        local Group targetGroup = this.targetGroup
        local integer targetsAmount = this.targetsAmount + 1

        if (targetsAmount > this.targetsAmountMax) then
            call this.Ending(delayTimer, targetGroup)
        else
            set caster = this.caster
            set lastTarget = this.lastTarget
            set lastTargetX = lastTarget.Position.X.Get()
            set lastTargetY = lastTarget.Position.Y.Get()

            set Group.TEMP = targetGroup
            set User.TEMP = caster.Owner.Get()

            call ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(lastTargetX, lastTargetY, AREA_RANGE, TARGET_FILTER)

            set newTarget = ENUM_GROUP.GetNearest(lastTargetX, lastTargetY)

            if (newTarget == NULL) then
                call this.Ending(delayTimer, targetGroup)
            else
                set this.targetsAmount = targetsAmount
                call this.Impact(lastTarget, this.level, newTarget, targetGroup)
            endif
        endif
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer delayTimer = Timer.Create()
        local Unit target = UNIT.Event.GetTarget()
        local Group targetGroup = Group.Create()
        local thistype this = thistype.allocate()

        local integer level = caster.Abilities.GetLevel(THIS_SPELL)

        set this.caster = caster
        set this.delayTimer = delayTimer
        set this.lastTarget = target
        set this.level = level
        set this.targetGroup = targetGroup
        set this.targetsAmountMax = TARGETS_AMOUNT[level]
        call caster.Effects.Create(CASTER_EFFECT_PATH, CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
        call delayTimer.Data.Integer.Set(KEY, this)

        call delayTimer.Start(DELAY, true, function thistype.ChooseNewTargetByTimer)

        call this.Impact(caster, level, target, targetGroup)
    endmethod

    static method Init takes nothing returns nothing
        set THIS_SPELL = Spell.CreateFromSelf('A01E')

        call THIS_SPELL.SetOrder(Order.HOWL_OF_TERROR)
        call THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)

        //! runtextmacro CreateHeroSpell("/", "THIS_SPELL", "Se", "ReplaceableTextures\\CommandButtons\\BTNAcidBomb.blp", "V", "Severance", "", "SPELL_TYPE_BUYABLE", "3")

        set ENUM_GROUP = Group.Create()
        set TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        set TARGETS_AMOUNT[1] = 3
        set TARGETS_AMOUNT[2] = 3
        set TARGETS_AMOUNT[3] = 4
        call THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Buff.Init()
    endmethod
endstruct