//! runtextmacro BaseStruct("MountainKing", "MOUNTAIN_KING")
	UnitModSet mods

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

		local UnitModSet mods = this.mods

        call target.Animation.Remove(UNIT.Animation.ALTERNATE)
        call target.ModSets.Remove(mods)

		call mods.Destroy()

		call HeroSpell.ReplaceSlot(SpellClass.HERO_ULTIMATE, thistype.THIS_SPELL, target)
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local real spellPower = target.SpellPower.Get()

        local thistype this = target

		local UnitModSet mods = UnitModSet.Create() 

		set this.mods = mods

        //call mods.RealMods.Add(UNIT.MaxLife.Bonus.STATE, spellPower * thistype.LIFE_INC_SPELL_POWER_MOD)
        call mods.RealMods.Add(UNIT.LifeLeech.STATE, spellPower * thistype.LIFE_LEECH_INC_SPELL_POWER_MOD)

        call target.Animation.Add(UNIT.Animation.ALTERNATE)
        call target.ModSets.Add(mods)

		call HeroSpell.ReplaceSlot(SpellClass.HERO_ULTIMATE, Thunderbringer.THIS_SPELL, target)
    endmethod

    eventMethod Event_SpellEffect
        local integer level = params.Spell.GetLevel()

        call params.Unit.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
    endmethod

    initMethod Init of Spells_Hero
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct