//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("BurningOil", "BURNING_OIL")
    static real DAMAGE_PER_INTERVAL
    static real DAMAGE_PER_SECOND
    static Buff DUMMY_BUFF
    static real DURATION
    static Group ENUM_GROUP
    static Event GROUND_ATTACK_EVENT
    static real INTERVAL
    static constant integer MISSILE_GRAPHIC_SPELL_ID = 'A01Z'
    static string SPECIAL_EFFECT_PATH
    static BoolExpr TARGET_FILTER

    static Spell THIS_SPELL

    Unit caster
    Timer durationTimer
    Timer intervalTimer
    integer level
    SpotEffect specialEffect
    real targetX
    real targetY

    static method Ending takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local Timer intervalTimer = this.intervalTimer
        local SpotEffect specialEffect = this.specialEffect

        call this.deallocate()
        call durationTimer.Destroy()
        call intervalTimer.Destroy()
        call specialEffect.Destroy()
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
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

    static method Interval takes nothing returns nothing
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, thistype.THIS_SPELL.GetAreaRange(this.level), thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call caster.DamageUnitBySpell(target, thistype.DAMAGE_PER_INTERVAL, false, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_GroundAttack takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()
        local integer level = caster.Abilities.GetLevel(thistype.THIS_SPELL)
        local thistype this = thistype.allocate()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()

        set this.caster = caster
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.specialEffect = Spot.CreateEffect(targetX, targetY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW)
        set this.targetX = targetX
        set this.targetY = targetY
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)

        call durationTimer.Start(thistype.DURATION, false, function thistype.Ending)
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        call target.Abilities.RemoveBySelf(thistype.MISSILE_GRAPHIC_SPELL_ID)
        call target.Event.Remove(GROUND_ATTACK_EVENT)
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        call target.Abilities.AddBySelf(thistype.MISSILE_GRAPHIC_SPELL_ID)
        call target.Event.Add(GROUND_ATTACK_EVENT)
    endmethod

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    //! textmacro BurningOil_CreateMissileSpell takes doExternal
        $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
            //! i function writeLua(code)
                //! i file = io.open("test.lua", "a")

                //! i file:write(code)

                //! i file:close()
            //! i end

            //! i writeLua([[
                //! i set("aite", "\0")
                //! i set("amac", 0.35)
                //! i set("amat", "Abilities\\Weapons\\DemolisherFireMissile\\DemolisherFireMissile.mdl")
                //! i set("amsp", 900)
                //! i set("anam", "Burning Oil (Missile Graphic)")
                //! i set("arac", "creeps")
                //! i set("asat", "")
                //! i set("aspt", "")
                //! i set("ata0", "")
                //! i set("atat", "")
                //! i setLv("Idam", 1, 0)
                //! i setLv("Iob2", 1, 0)
                //! i setLv("Iob3", 1, 0)
                //! i setLv("Iob4", 1, 0)
                //! i setLv("Iob5", 1, 0)
                //! i setLv("Iobu", 1, "")
            //! i ]])
        $doExternal$//! endexternalblock
    //! endtextmacro

    static method Init takes nothing returns nothing
        //! import obj_BurningOil.j

        //! runtextmacro BurningOil_CreateMissileSpell("/")

        set thistype.DAMAGE_PER_INTERVAL = thistype.DAMAGE_PER_SECOND * thistype.INTERVAL
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.GROUND_ATTACK_EVENT = Event.Create(UNIT.Attack.Events.Ground.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_GroundAttack)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))

            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDeath(false)

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct