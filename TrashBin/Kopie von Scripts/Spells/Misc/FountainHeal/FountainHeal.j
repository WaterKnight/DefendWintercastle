//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("FountainHeal", "FOUNTAIN_HEAL")
    static string CASTER_EFFECT_ATTACH_POINT
    static string CASTER_EFFECT_PATH
    static Event DESTROY_EVENT
    static Buff DUMMY_BUFF
    static Spell DUMMY_SPELL
    static constant integer DUMMY_SPELL_ID = 'AFHD'
    static real HEAL_LIFE_PER_MANA_POINT
    static real HEAL_MANA_PER_MANA_POINT
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static Event ORDER_EVENT
    static string TARGET_LIFE_EFFECT_ATTACH_POINT
    static string TARGET_LIFE_EFFECT_PATH
    static string TARGET_MANA_EFFECT_ATTACH_POINT
    static string TARGET_MANA_EFFECT_PATH

    static Spell THIS_SPELL

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTarget()
        local Unit target = UNIT.Event.GetTrigger()

        local real manaLifeNeeded = (target.MaxLife.GetAll() - target.Life.Get()) / thistype.HEAL_LIFE_PER_MANA_POINT
        local real manaManaNeeded = (target.MaxMana.GetAll() - target.Mana.Get()) / thistype.HEAL_MANA_PER_MANA_POINT

        local real manaNeeded = manaLifeNeeded + manaManaNeeded

        local real manaUsed = Math.Min(caster.Mana.Get(), manaNeeded)

        call target.Stop()

        if (manaUsed < 10.) then
            call caster.AddRisingTextTag(String.Color.Do(caster.GetName() + " empty or target nearly full", String.Color.MALUS), 0.024, 120., 1., 2., KEY_ARRAY + caster)

            return
        endif

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        if (manaLifeNeeded > 0.) then
            call target.Effects.Create(thistype.TARGET_LIFE_EFFECT_PATH, thistype.TARGET_LIFE_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

            call caster.HealBySpell(target, manaUsed * manaLifeNeeded / manaNeeded * thistype.HEAL_LIFE_PER_MANA_POINT)
        endif

        if (manaManaNeeded > 0.) then
            call target.Effects.Create(thistype.TARGET_MANA_EFFECT_PATH, thistype.TARGET_MANA_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

            call caster.HealManaBySpell(target, manaUsed * manaManaNeeded / manaNeeded * thistype.HEAL_MANA_PER_MANA_POINT)
        endif

        call caster.Mana.Subtract(manaUsed)
    endmethod

    static method Event_Order takes nothing returns nothing
        local Unit caster
        local Unit target
        local User targetOwner

        if (ORDER.Event.GetTrigger() != Order.SMART) then
            return
        endif

        set caster = UNIT.Event.GetTrigger()
        set target = UNIT.Event.GetTarget()

        set targetOwner = target.Owner.Get()

        call target.Abilities.AddBySelf(thistype.DUMMY_SPELL_ID)

        call targetOwner.EnableAbilityBySelf(thistype.DUMMY_SPELL_ID, true)

        call target.Order.UnitTarget(Order.EAT_TREE, caster)

        call targetOwner.EnableAbilityBySelf(thistype.DUMMY_SPELL_ID, false)
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Remove(ORDER_EVENT)
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Add(ORDER_EVENT)
    endmethod

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    //! textmacro FountainHeal_CreateDummySpell takes doExternal
        $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
            //! i function writeLua(code)
                //! i file = io.open("spells.lua", "r")

                //! i cur = file:read()

                //! i file:close()

                //! i file = io.open("spell"..cur..".lua", "a")

                //! i file:write(code)

                //! i file:close()
            //! i end

            //! i writeLua([[
                //! i set("asat", "")
                //! i setLv("Eat1", 1, 0)
                //! i setLv("Eat2", 1, 0)
                //! i setLv("Eat3", 1, 0)
            //! i ]])
        $doExternal$//! endexternalblock
    //! endtextmacro

    static method Init takes nothing returns nothing
       //! import obj_FountainHeal.j

        //! runtextmacro FountainHeal_CreateSpecials("/")

        set thistype.ORDER_EVENT = Event.Create(UNIT.Order.Events.Gain.Target.TARGET_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Order)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))

            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

        //! runtextmacro Spell_Finalize("/")

        //! runtextmacro Spell_OpenScope("/")

        //! runtextmacro Spell_Create("/", "DUMMY_SPELL", "AFHD", "Fountain Heal")

        //! runtextmacro Spell_SetTypes("/", "SPECIAL_Aeat", "NORMAL")

        //! runtextmacro Spell_SetRange("/", "384.")
        //! runtextmacro Spell_SetTargets("/", "structure,invulnerable,vulnerable")

        //! runtextmacro FountainHeal_CreateDummySpell("/")

        call thistype.DUMMY_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.PRE_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct