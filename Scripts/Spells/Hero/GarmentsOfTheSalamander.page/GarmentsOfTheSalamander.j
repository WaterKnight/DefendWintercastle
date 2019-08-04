//! runtextmacro Folder("GarmentsOfTheSalamander")
    //! runtextmacro Struct("Regen")
        static Group ENUM_GROUP
        static BoolExpr TARGET_FILTER

        Timer intervalTimer
        UnitModSet regenMod

        condMethod Conditions
            local Unit target = UNIT.Event.Native.GetFilter()

            if target.Classes.Contains(UnitClass.DEAD) then
                return false
            endif
            if target.Classes.Contains(UnitClass.MECHANICAL) then
                return false
            endif
            if target.Classes.Contains(UnitClass.STRUCTURE) then
                return false
            endif
            if not target.IsAllyOf(User.TEMP) then
                return false
            endif

            return true
        endmethod

        timerMethod Interval
            local thistype this = Timer.GetExpired().GetData()

            local Unit source = this
            local UnitModSet regenMod = this.regenMod

			local integer level = source.Abilities.GetLevel(GarmentsOfTheSalamander.REVERT_SPELL)
            local real x = source.Position.X.Get()
            local real y = source.Position.Y.Get()

            set User.TEMP = source.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, GarmentsOfTheSalamander.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)
            
            local integer targetCount = thistype.ENUM_GROUP.Count()
            
        	call source.ModSets.Remove(regenMod)

        	call regenMod.RealMods.ResetVal(UNIT.LifeRegeneration.Bonus.STATE, thistype.LIFE_REGEN_INC_PER_TARGET[level] * targetCount)

        	call source.ModSets.Add(regenMod)
        	
        	if (level != source.Buffs.GetLevel(thistype.DUMMY_BUFF)) then
                call source.Buffs.Remove(thistype.DUMMY_BUFF)
                
                call source.Buffs.Add(thistype.DUMMY_BUFF, level)
            endif
        endmethod

        eventMethod Event_BuffLose
            local Unit source = params.Unit.GetTrigger()

            local thistype this = source

            local Timer intervalTimer = this.intervalTimer
            local UnitModSet regenMod = this.regenMod

            call intervalTimer.Destroy()
            
            call source.ModSets.Remove(regenMod)
            
            call regenMod.Destroy()
        endmethod

        eventMethod Event_BuffGain
            local Unit source = params.Unit.GetTrigger()
            
            local Timer intervalTimer = Timer.Create()
            local UnitModSet regenMod = UnitModSet.Create()

            local thistype this = source

            set this.intervalTimer = intervalTimer
            set this.regenMod = regenMod
            call intervalTimer.SetData(this)

			call regenMod.RealMods.Add(UNIT.LifeRegeneration.Bonus.STATE, 0.)

			call source.ModSets.Add(regenMod)

            call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        endmethod

        static method Finish takes Unit source returns nothing
            call source.Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        static method Start takes Unit source, integer level returns nothing
            call source.Buffs.Add(thistype.DUMMY_BUFF, level)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("GarmentsOfTheSalamander", "GARMENTS_OF_THE_SALAMANDER")
    UnitType origUnitType

	//! runtextmacro LinkToStruct("GarmentsOfTheSalamander", "Regen")

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local UnitType origUnitType = this.origUnitType

        call target.Type.SetWithChangerAbility(origUnitType, thistype.REVERT_ABILITY_ID)

		call target.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call HeroSpell.ReplaceSlot(SpellClass.ARTIFACT, WhiteStaff.THIS_SPELL, target)
        call HeroSpell.ReplaceSlot(SpellClass.HERO_FIRST, WaterBindings.THIS_SPELL, target)
        call HeroSpell.ReplaceSlot(SpellClass.HERO_SECOND, thistype.THIS_SPELL, target)

        call thistype(NULL).Regen.Finish(target)
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        set this.origUnitType = target.Type.Get()

        call target.Type.SetWithChangerAbility(thistype.THIS_UNIT_TYPE, thistype.CHANGER_ABILITY_ID)

		call target.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call HeroSpell.ReplaceSlot(SpellClass.ARTIFACT, Vomit.THIS_SPELL, target)
        call HeroSpell.ReplaceSlot(SpellClass.HERO_FIRST, Conflagration.THIS_SPELL, target)
        call HeroSpell.ReplaceSlot(SpellClass.HERO_SECOND, thistype.REVERT_SPELL, target)
        
        call thistype(NULL).Regen.Start(target, level)
    endmethod

    eventMethod Event_RevertSpellEffect
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_SpellEffect
        call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Hero
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.REVERT_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_RevertSpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        
        call thistype(NULL).Regen.Init()
    endmethod
endstruct