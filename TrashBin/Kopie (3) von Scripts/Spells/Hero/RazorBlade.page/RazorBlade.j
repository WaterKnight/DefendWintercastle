//! runtextmacro Folder("RazorBlade")
    //! runtextmacro Struct("DrawBack")
        //! runtextmacro DummyUnit_CreateSimpleType("", "dRBD", "RazorBlade_DrawBack", "DUMMY_UNIT_ID", "Abilities\\Weapons\\SentinelMissile\\SentinelMissile.mdl")
        static Group ENUM_GROUP
        //! runtextmacro GetKeyArray("MISSILES_KEY_ARRAY")
        //! runtextmacro GetKeyArray("PARENTS_KEY_ARRAY_DETAIL")
        static BoolExpr TARGET_FILTER
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        real areaRange
        Unit caster
        real damage
        Group targetGroup

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

        static method Impact takes nothing returns nothing
            local Missile dummyMissile = MISSILE.Event.GetTrigger()

            local thistype this = dummyMissile.GetData()

            if (Memory.IntegerKeys.Table.RemoveInteger(PARENTS_KEY_ARRAY_DETAIL + this, MISSILES_KEY_ARRAY, dummyMissile)) then
                call this.deallocate()

                if (thistype.ACTIVE_LIST_Remove(this)) then
                    call thistype.UPDATE_TIMER.Pause()
                endif
            endif

            call dummyMissile.Destroy()
        endmethod

        static method TargetConditions takes nothing returns boolean
            local Unit target = UNIT.Event.Native.GetFilter()

            if (Group.TEMP.ContainsUnit(target)) then
                return false
            endif

            if (target.Classes.Contains(UnitClass.DEAD)) then
                return false
            endif
            if (target.IsAllyOf(User.TEMP)) then
                return false
            endif

            return true
        endmethod

        static method Update takes nothing returns nothing
            local real areaRange
            local Unit caster
            local real damage
            local Missile dummyMissile
            local integer iteration
            local Unit target
            local Group targetGroup
            local thistype this

            call thistype.FOR_EACH_LIST_Set()

            loop
                set this = thistype.FOR_EACH_LIST_FetchFirst()

                exitwhen (this == NULL)

                set areaRange = this.areaRange
                set caster = this.caster
                set damage = this.damage
                set iteration = Memory.IntegerKeys.Table.CountIntegers(PARENTS_KEY_ARRAY_DETAIL + this, MISSILES_KEY_ARRAY)
                set targetGroup = this.targetGroup

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    set dummyMissile = Memory.IntegerKeys.Table.GetInteger(PARENTS_KEY_ARRAY_DETAIL + this, MISSILES_KEY_ARRAY, iteration)

                    set Group.TEMP = targetGroup
                    set User.TEMP = caster.Owner.Get()

                    call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.DoWithZ(dummyMissile.Position.X.Get(), dummyMissile.Position.Y.Get(), dummyMissile.Position.Z.Get(), areaRange, thistype.TARGET_FILTER)

                    set target = thistype.ENUM_GROUP.FetchFirst()

                    if (target != NULL) then
                        loop
                            call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()
                            call targetGroup.AddUnit(target)

                            call caster.DamageUnitBySpell(target, damage, false, true)

                            set target = thistype.ENUM_GROUP.FetchFirst()
                            exitwhen (target == NULL)
                        endloop
                    endif

                    set iteration = iteration - 1
                endloop
            endloop
        endmethod

        static method Start takes Unit caster, integer level, real sourceX, real sourceY, real sourceZ returns nothing
            local real casterX = caster.Position.X.Get()
            local real casterY = caster.Position.Y.Get()
            local real casterZ = caster.Position.Z.Get() + caster.Impact.Z.Get(true)
            local Missile dummyMissile
            local integer iteration = thistype.MISSILES_AMOUNT[level]
            local real maxLength = thistype.MAX_LENGTH[level]
            local thistype this = thistype.allocate()
            local real window = thistype.WINDOW[level]

            local real dX = casterX - sourceX
            local real dY = casterY - sourceY
            local real dZ = casterZ - sourceZ

            local real angle = Math.AtanByDeltas(dY, dX)
            local real d = Math.DistanceByDeltasWithZ(dX, dY, dZ)

            local real angleAdd = window / (iteration - 1)

            set dZ = dZ / d

            set d = 1. - dZ

            set angle = angle - window / 2

            set this.areaRange = thistype.AREA_RANGE[level]
            set this.caster = caster
            set this.damage = thistype.DAMAGE[level]
            set this.targetGroup = Group.Create()

            loop
                exitwhen (iteration < 1)

                set dummyMissile = Missile.Create()
                set dX = Math.Cos(angle) * d
                set dY = Math.Sin(angle) * d

                call Memory.IntegerKeys.Table.AddInteger(PARENTS_KEY_ARRAY_DETAIL + this, MISSILES_KEY_ARRAY, dummyMissile)

                call dummyMissile.Acceleration.Set(500.)
                call dummyMissile.CollisionSize.Set(thistype.AREA_RANGE[level])
                call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)//.AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
                call dummyMissile.Impact.SetAction(function thistype.Impact)
                call dummyMissile.SetData(this)
                call dummyMissile.Speed.Set(850.)
                call dummyMissile.Position.Set(sourceX, sourceY, sourceZ)

                call dummyMissile.GoToSpot.Start(sourceX + maxLength * dX, sourceY + maxLength * dY, sourceZ + maxLength * dZ)

                set angle = angle + angleAdd
                set iteration = iteration - 1
            endloop

            if (thistype.ACTIVE_LIST_Add(this)) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("RazorBlade", "RAZOR_BLADE")
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dRaz", "RazorBlade", "DUMMY_UNIT_ID", "Abilities\\Weapons\\BloodElfSpellThiefMISSILE\\BloodElfSpellThiefMISSILE.mdl")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    Unit caster
    real damage
    Missile dummyMissile
    integer level
    Group targetGroup
    real targetX
    real targetY
    Timer updateTimer

    //! runtextmacro LinkToStruct("RazorBlade", "DrawBack")

    static method Impact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Timer updateTimer = this.updateTimer
        local real x = dummyMissile.Position.X.Get()
        local real y = dummyMissile.Position.Y.Get()
        local real z = dummyMissile.Position.Z.Get()

        call this.deallocate()
        call dummyMissile.Destroy()
        call updateTimer.Destroy()

        call thistype(NULL).DrawBack.Start(caster, level, x, y, z)
    endmethod

    static method TargetConditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        /*if (Group.TEMP.ContainsUnit(target)) then
            return false
        endif*/

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif

        return true
    endmethod

    static method Update takes nothing returns nothing
        local real damage
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster
        local Missile dummyMissile = this.dummyMissile
        local Group targetGroup = this.targetGroup
        local real targetX = this.targetX
        local real targetY = this.targetY

        set Group.TEMP = targetGroup
        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.DoWithZ(dummyMissile.Position.X.Get(), dummyMissile.Position.Y.Get(), dummyMissile.Position.Z.Get(), thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set damage = this.damage
            set targetGroup = this.targetGroup

            loop
                if (Group.TEMP.ContainsUnit(target) == false) then
                    call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()
                    call target.Position.Timed.Accelerated.AddKnockback(650., -200., Math.AtanByDeltas(targetY - target.Position.Y.Get(), targetX - target.Position.X.Get()), 1.)
                    call targetGroup.AddUnit(target)

                    call caster.DamageUnitBySpell(target, damage, false, true)
                endif

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Missile dummyMissile = Missile.Create()
        local integer level = SPELL.Event.GetLevel()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()
        local thistype this = thistype.allocate()
        local Timer updateTimer = Timer.Create()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real maxLength = thistype.MAX_LENGTH[level]

        local real angle = caster.CastAngle(targetX - casterX, targetY - casterY)

        set targetX = casterX + maxLength * Math.Cos(angle)
        set targetY = casterY + maxLength * Math.Sin(angle)

        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.dummyMissile = dummyMissile
        set this.level = level
        set this.targetGroup = Group.Create()
        set this.targetX = targetX
        set this.targetY = targetY
        set this.updateTimer = updateTimer
        call updateTimer.SetData(this)

        call dummyMissile.Acceleration.Set(-400.)
        call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)//.AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(1100.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).DrawBack.Init()
    endmethod
endstruct