//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("BatSwarm", "BAT_SWARM")
    static real array DAMAGE
    static real array ECLIPSE_DURATION
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dBaS", "BatSwarmEnemyMissile", "ENEMY_DUMMY_UNIT_ID", "units\\undead\\Gargoyle\\Gargoyle.mdl")
    static real array HEAL
    static integer array MAX_ENEMIES_AMOUNT
    static string ENEMY_EFFECT_ATTACH_POINT
    static string ENEMY_EFFECT_PATH
    static Buff SPELL_SHIELD_BUFF
    static real array SPELL_SHIELD_DURATION
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dBST", "BatSwarmTargetMissile", "TARGET_DUMMY_UNIT_ID", "Abilities\\Weapons\\FaerieDragonMissile\\FaerieDragonMissile.mdl")
    static BoolExpr TARGET_FILTER

    static Spell THIS_SPELL

    Unit caster
    real damage
    real heal
    Unit target

    static method ImpactTarget takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local real heal = this.heal
        local Unit target = this.target

        call this.deallocate()
        call dummyMissile.Destroy()

        call caster.HealBySpell(target, heal)
    endmethod

    static method ImpactEnemy takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()
        local Unit enemy = UNIT.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local Unit target = this.target

        call dummyMissile.Destroy()

        if (enemy.Classes.Contains(UnitClass.DEAD) == false) then
            call enemy.Effects.Create(thistype.ENEMY_EFFECT_PATH, thistype.ENEMY_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

            call caster.DamageUnitBySpell(enemy, this.damage, true, true)
        endif

        if (target.IsAllyOf(caster.Owner.Get()) == false) then
            call this.deallocate()

            return
        endif

        set dummyMissile = Missile.Create()

        call dummyMissile.Arc.SetByPerc(0.06)
        call dummyMissile.CollisionSize.Set(8.)
        call dummyMissile.DummyUnit.Create(thistype.TARGET_DUMMY_UNIT_ID, 1.5)
        call dummyMissile.Impact.SetAction(function thistype.ImpactTarget)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(500.)
        call dummyMissile.Position.SetFromUnit(enemy)

        call dummyMissile.GoToUnit.Start(target, false)
    endmethod

    static method TargetConditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (Group.TEMP.ContainsUnit(target)) then
            return false
        endif
        if (target == Unit.TEMP) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.WARD)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif

        return true
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Missile dummyMissile
        local Unit enemy
        local Group enemyGroup = Group.Create()
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()
        local thistype this

        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local User casterOwner = caster.Owner.Get()
        local integer iteration = thistype.MAX_ENEMIES_AMOUNT[level]
        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()

        if (target.IsAllyOf(caster.Owner.Get())) then
            call target.MagicImmunity.SpellShield.AddTimed(thistype.SPELL_SHIELD_DURATION[level], UNIT.MagicImmunity.SpellShield.NORMAL_BUFF)
        else
            call target.Eclipse.AddTimed(thistype.ECLIPSE_DURATION[level])
        endif

        loop
            exitwhen (iteration < 1)

            set Group.TEMP = enemyGroup
            set User.TEMP = casterOwner
            set Unit.TEMP = target

            set enemy = GROUP.EnumUnits.InRange.WithCollision.GetNearest(targetX, targetY, areaRange, thistype.TARGET_FILTER)

            exitwhen (enemy == NULL)

            set dummyMissile = Missile.Create()
            set this = thistype.allocate()

            set this.caster = caster
            set this.damage = thistype.DAMAGE[level]
            set this.heal = thistype.HEAL[level]
            set this.target = target
            call enemyGroup.AddUnit(enemy)

            call dummyMissile.Arc.SetByPerc(0.06)
            call dummyMissile.CollisionSize.Set(8.)
            call dummyMissile.DummyUnit.Create(thistype.ENEMY_DUMMY_UNIT_ID, 0.5).PlayerColor.Set(casterOwner.GetColor())
            call dummyMissile.Impact.SetAction(function thistype.ImpactEnemy)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(500.)
            call dummyMissile.Position.SetFromUnit(target)

            call dummyMissile.GoToUnit.Start(enemy, false)

            set iteration = iteration - 1
        endloop

        call enemyGroup.Destroy()
    endmethod

    static method Init takes nothing returns nothing
        //! runtextmacro Spell_Create("/", "THIS_SPELL", "ABaS", "Bat Swarm")

        //! runtextmacro Spell_SetTypes("/", "NORMAL", "ARTIFACT")

        //! runtextmacro Spell_SetAnimation("/", "spell")
        //! runtextmacro Spell_SetAreaRange5("/", "400.", "400.", "400.", "400.", "400.", "true")
        //! runtextmacro Spell_SetCooldown5("/", "14.", "14.", "14.", "14.", "14.")
        //! runtextmacro Spell_SetData5("/", "DAMAGE", "damage", "20.", "30.", "45.", "65.", "90.")
        //! runtextmacro Spell_SetData5("/", "ECLIPSE_DURATION", "eclipseDuration", "7.", "7.", "7.", "7.", "7.")
        //! runtextmacro Spell_SetData("/", "ENEMY_EFFECT_ATTACH_POINT", "", "AttachPoint.CHEST")
        //! runtextmacro Spell_SetDataOfType("/", "string", "ENEMY_EFFECT_PATH", "", "Abilities\\Weapons\\LocustMissile\\LocustMissile.mdl")
        //! runtextmacro Spell_SetData5("/", "HEAL", "heal", "20.", "25.", "30.", "35.", "40.")
        //! runtextmacro Spell_SetData5("/", "MAX_ENEMIES_AMOUNT", "maxEnemiesAmount", "3", "3", "3", "3", "3")
        //! runtextmacro Spell_SetData5("/", "SPELL_SHIELD_DURATION", "spellShieldDuration", "7.", "7.", "7.", "7.", "7.")
        //! runtextmacro Spell_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNCarrionSwarm.blp")
        //! runtextmacro Spell_SetManaCost5("/", "75", "85", "95", "105", "115")
        //! runtextmacro Spell_SetOrder("/", "sanctuary")
        //! runtextmacro Spell_SetRange5("/", "800.", "800.", "800.", "800.", "800.")
        //! runtextmacro Spell_AddSharedBuff("/", "ECLIPSE")
        //! runtextmacro Spell_AddSharedBuff("/", "SPELL_SHIELD")
        //! runtextmacro Spell_SetTargets("/", "air,enemies,friend,ground,invulnerable,neutral,organic,self,vulnerable")
        //! runtextmacro Spell_SetTargetType("/", "UNIT")
        //! runtextmacro Spell_SetUberTooltipLv("/", "1", "Some bats from the ceiling of Wintercastle appear that engulf the target unit. Enemy targets will be rendered in an eclipse for <eclipseDuration> seconds, allies protected by a spell shield for <spellShieldDuration> seconds. The bats will then swarm out to up to <maxEnemiesAmount> nearby enemy units in order to deal <damage> damage and restore <heal> lifepoints each to the target of the spell (allies only).")

        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct