//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("SapphireblueDagger", "SAPPHIREBLUE_DAGGER")
    static real array BUFF_DURATION
    static real array DAMAGE
    static string DAMAGE_TARGET_EFFECT_ATTACH_POINT
    static string DAMAGE_TARGET_EFFECT_PATH
    static BoolExpr DAMAGE_TARGET_FILTER
    static Buff DUMMY_BUFF
    static Group ENUM_GROUP
    static real array HEAL
    static real array HEAL_PER_TARGET
    static string HEAL_TARGET_EFFECT_ATTACH_POINT
    static string HEAL_TARGET_EFFECT_PATH
    static BoolExpr HEAL_TARGET_FILTER
    static real array LIFE_LEECH_INCREMENT
    static real array MAX_RANGE
    static real array MAX_RANGE_SQUARE
    static string START_EFFECT_PATH
    static string TARGET_EFFECT_PATH

    static Spell THIS_SPELL

    real lifeLeechAdd

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local real lifeLeechAdd = this.lifeLeechAdd

        call target.LifeLeech.Subtract(lifeLeechAdd)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local real lifeLeechAdd = thistype.LIFE_LEECH_INCREMENT[level]

        set this.lifeLeechAdd = lifeLeechAdd
        call target.LifeLeech.Add(lifeLeechAdd)
    endmethod

    static method DamageConditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
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

    static method HealConditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP) == false) then
            return false
        endif

        return true
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local real angle
        local Unit caster = UNIT.Event.GetTrigger()
        local real damage
        local real heal = 0.
        local real healPerTarget
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()

        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local User casterOwner = caster.Owner.Get()
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real dX = targetX - casterX
        local real dY = targetY - casterY

        if (Math.DistanceSquareByDeltas(dX, dY) > thistype.MAX_RANGE_SQUARE[level]) then
            set angle = caster.CastAngle(dX, dY)

            set targetX = casterX + thistype.MAX_RANGE[level] * Math.Cos(angle)
            set targetY = casterY + thistype.MAX_RANGE[level] * Math.Sin(angle)
        endif

        call Spot.CreateEffect(casterX, casterY, thistype.START_EFFECT_PATH, EffectLevel.NORMAL).Destroy()
        call Spot.CreateEffect(targetX, targetY, thistype.TARGET_EFFECT_PATH, EffectLevel.LOW).Destroy()

        call caster.Position.SetWithCollision(targetX, targetY)

        set User.TEMP = casterOwner
        set Unit.TEMP = caster

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, areaRange, thistype.DAMAGE_TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set damage = thistype.DAMAGE[level]
            set healPerTarget = thistype.HEAL_PER_TARGET[level]

            loop
                set heal = heal + healPerTarget

                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif

        set User.TEMP = casterOwner

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, areaRange, thistype.HEAL_TARGET_FILTER)

        call thistype.ENUM_GROUP.RemoveUnit(caster)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set heal = heal + thistype.HEAL[level]

            loop
                call target.Effects.Create(thistype.HEAL_TARGET_EFFECT_PATH, thistype.HEAL_TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)

                call caster.HealBySpell(target, heal)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif

        call caster.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.BUFF_DURATION[level])
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration

        //! import obj_SapphireBlueDagger.j

        set thistype.DAMAGE_TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.DamageConditions)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.HEAL_TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.HealConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "SaD", "Sapphireblue Dagger", "5", "true", "ReplaceableTextures\\CommandButtons\\BTNSnazzyPotion.blp", "Life leech.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDispel(true)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Items\\VampiricPotion\\VampPotionCaster.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Items\\VampiricPotion\\VampPotionCaster.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)

            set iteration = thistype.THIS_SPELL.GetLevelsAmount()

            loop
                set thistype.MAX_RANGE_SQUARE[iteration] = Math.Square(thistype.MAX_RANGE[iteration])

                set iteration = iteration - 1
                exitwhen (iteration < 1)
            endloop

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct