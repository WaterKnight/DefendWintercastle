//! runtextmacro Folder("IceLance")
    //! runtextmacro Struct("Target")
        static Event DEATH_EVENT
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

        integer amount
        IceLance parent

        method Ending takes IceLance parent, Unit target, Group targetGroup returns nothing
            call this.deallocate()
            call target.Data.Integer.Remove(KEY_ARRAY_DETAIL + parent)
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Event.Remove(DEATH_EVENT)
            endif
            call targetGroup.RemoveUnit(target)
        endmethod

        method EndingByParent takes Unit target, Group targetGroup returns nothing
            local IceLance parent = this

            set this = target.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)

            call this.Ending(parent, target, targetGroup)
        endmethod

        static method Event_Death takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()
            local thistype this

            local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                set this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call this.Ending(this.parent, target, this.parent.targetGroup)

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method Get takes Unit target returns integer
            set this = target.Data.Integer.Get(KEY_ARRAY_DETAIL + this)

            if (this == NULL) then
                return 0
            endif

            return this.amount
        endmethod

        method Start takes Unit target, Group targetGroup returns nothing
            local IceLance parent = this
            set this = target.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)
            if (this == NULL) then
                set this = thistype.allocate()
                set this.amount = 1
                set this.parent = parent
                call target.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)
                if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                    call target.Event.Add(DEATH_EVENT)
                endif
                call targetGroup.AddUnit(target)
            else
                set this.amount = this.amount + 1
            endif
        endmethod

        static method Init takes nothing returns nothing
            set DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("IceLance", "ICE_LANCE")
    static real array AREA_RANGE
    static constant real DAMAGE_MOD_FACTOR = 1.
    static real array DAMAGE
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dIcl", "Ice Lance", "DUMMY_UNIT_ID", "Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl")
    static real array DURATION
    static Group ENUM_GROUP
    static constant real INTERVAL = 0.035
    //! runtextmacro GetKey("KEY")
    static real array LENGTH
    static constant integer LEVELS_AMOUNT = 3
    static real array MAX_DAMAGE
    static constant integer MAX_HITS_PER_TARGET = 3
    static real array MAX_LENGTH
    static constant string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl"
    static real array SPEED
    static BoolExpr TARGET_FILTER
    static thistype TEMP
    static Spell THIS_SPELL
    static constant real UPDATE_TIME = 0.035

    real angle
    real areaRange
    Unit caster
    real damage
    DummyUnit dummyUnit
    integer hitsPerTarget
    Timer intervalTimer
    real maxDamage
    Group targetGroup
    real x
    real xAdd
    real y
    real yAdd
    Timer updateTimer
    SpellInstance whichInstance

    //! runtextmacro LinkToStruct("IceLance", "Target")

    static method Ending takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()
        local Unit target

        local thistype this = durationTimer.Data.Integer.Get(KEY)

        local DummyUnit dummyUnit = this.dummyUnit
        local Timer intervalTimer = this.intervalTimer
        local Group targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer

        call this.deallocate()
        call dummyUnit.Destroy()
        call durationTimer.Data.Integer.Remove(KEY)
        call durationTimer.Destroy()
        call intervalTimer.Data.Integer.Remove(KEY)
        call intervalTimer.Destroy()
        call updateTimer.Data.Integer.Remove(KEY)
        call updateTimer.Destroy()
        loop
            set target = targetGroup.GetFirst()
            exitwhen (target == NULL)
            call this.Target.EndingByParent(target, targetGroup)
        endloop

        call targetGroup.Destroy()
        call whichInstance.Destroy()
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (filterUnit.IsAllyOf(User.TEMP)) then
            return false
        endif
        if (filterUnit.Type.Is(UNIT.Type.DEAD)) then
            return false
        endif
        if (TEMP.Target.Get(filterUnit) == TEMP_INTEGER) then
            return false
        endif

        return true
    endmethod

    static method DealDamage takes nothing returns nothing
        local real maxDamage
        local Unit target
        local Group targetGroup
        local thistype this = Timer.GetExpired().Data.Integer.Get(KEY)
        local SpellInstance whichInstance

        local Unit caster = this.caster

        set User.TEMP = caster.Owner.Get()
        set TEMP_INTEGER = this.hitsPerTarget
        set TEMP = this

        call ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(this.x, this.y, this.areaRange, TARGET_FILTER)

        set target = ENUM_GROUP.GetFirst()

        if (target != NULL) then
            set damage = this.damage
            set maxDamage = this.maxDamage
            set targetGroup = this.targetGroup
            set whichInstance = this.whichInstance

            loop
                set damage = Math.Min(damage, maxDamage)
                call ENUM_GROUP.RemoveUnit(target)

                call this.Target.Start(target, targetGroup)

                set maxDamage = maxDamage - damage
                call caster.DamageUnitBySpell(whichInstance, target, damage, false)

                set target = ENUM_GROUP.GetFirst()
                exitwhen (target == NULL)
            endloop

            set this.maxDamage = maxDamage
        endif
    endmethod

    static method Move takes nothing returns nothing
        local thistype this = Timer.GetExpired().Data.Integer.Get(KEY)

        local real angle = this.angle
        local DummyUnit dummyUnit = this.dummyUnit
        local real x = this.x + this.xAdd
        local real y = this.y + this.yAdd

        set this.x = x
        set this.y = y
        call Effect.Create(SPECIAL_EFFECT_PATH, x, y, EffectLevel.LOW).Destroy()
        call Effect.Create(SPECIAL_EFFECT_PATH, x + 110. * Math.Cos(angle + 5. * Math.PI / 6.), y + 110. * Math.Sin(angle + 5. * Math.PI / 6.), EffectLevel.NORMAL).Destroy()
        call Effect.Create(SPECIAL_EFFECT_PATH, x + 110. * Math.Cos(angle - 5. * Math.PI / 6.), y + 110. * Math.Sin(angle - 5. * Math.PI / 6.), EffectLevel.NORMAL).Destroy()
        call dummyUnit.Position.X.Set(x)
        call dummyUnit.Position.Y.Set(y)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()
        local thistype this = thistype.allocate()
        local Timer updateTimer = Timer.Create()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local integer level = caster.Abilities.GetLevel(THIS_SPELL)
        local SpellInstance whichInstance = SpellInstance.Create(caster)

        local real dX = targetX - casterX
        local real dY = targetY - casterY

        local real angle = caster.CastAngle(dX, dY)
        local real d = Math.DistanceByDeltas(dX, dY)

        set this.angle = angle
        set this.areaRange = AREA_RANGE[level]
        set this.caster = caster
        set this.damage = DAMAGE[level] + caster.Damage.GetAll() * DAMAGE_MOD_FACTOR
        set this.dummyUnit = DummyUnit.Create(DUMMY_UNIT_ID, casterX, casterY, caster.Position.Z.GetByCoords(casterX, casterY) + caster.Outpact.Z.Get(true), angle)
        set this.hitsPerTarget = MAX_HITS_PER_TARGET
        set this.intervalTimer = intervalTimer
        set this.maxDamage = MAX_DAMAGE[level]
        set this.targetGroup = Group.Create()
        set this.updateTimer = updateTimer
        set this.x = casterX
        set this.xAdd = LENGTH[level] * Math.Cos(angle)
        set this.y = casterY
        set this.yAdd = LENGTH[level] * Math.Sin(angle)
        set this.whichInstance = whichInstance
        call durationTimer.Data.Integer.Set(KEY, this)
        call intervalTimer.Data.Integer.Set(KEY, this)
        call updateTimer.Data.Integer.Set(KEY, this)

        call intervalTimer.Start(INTERVAL, true, function thistype.DealDamage)
        call updateTimer.Start(UPDATE_TIME, true, function thistype.Move)

        call durationTimer.Start(DURATION[level], false, function thistype.Ending)
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration = LEVELS_AMOUNT

        set THIS_SPELL = Spell.CreateFromSelf('A000')

        call THIS_SPELL.SetOrder(Order.SHOCK_WAVE)
        call THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)

        //! runtextmacro CreateHeroSpell("/", "THIS_SPELL", "IL", "ReplaceableTextures\\CommandButtons\\BTNFrostBolt.blp", "L", "Ice Lance", "", "SPELL_TYPE_BUYABLE", "3")

        set AREA_RANGE[1] = 200.
        set AREA_RANGE[2] = 200.
        set AREA_RANGE[3] = 200.
        set DAMAGE[1] = 20.
        set DAMAGE[2] = 40.
        set DAMAGE[3] = 60.
        set ENUM_GROUP = Group.Create()
        set MAX_DAMAGE[1] = 140.
        set MAX_DAMAGE[2] = 225.
        set MAX_DAMAGE[3] = 400.
        set MAX_LENGTH[1] = 700.
        set MAX_LENGTH[2] = 700.
        set MAX_LENGTH[3] = 700.
        set SPEED[1] = 600.
        set SPEED[2] = 600.
        set SPEED[3] = 600.
        set TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        loop
            set DURATION[iteration] = MAX_LENGTH[iteration] / SPEED[iteration]
            set LENGTH[iteration] = SPEED[iteration] * UPDATE_TIME

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop

        call Target.Init()
    endmethod
endstruct