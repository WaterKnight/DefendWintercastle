//! runtextmacro BaseStruct("SpellPurchase", "SPELL_PURCHASE")
    static Spell array DISPLAYED_SPELL
    static Event ITEM_GAIN_EVENT
    static Event ITEM_LOSE_EVENT
    static Event ITEM_USE_EVENT
    //! runtextmacro GetKey("KEY")
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
    static integer array LEVELS
    static constant integer SLOT = 4
    static Event SPELL_EFFECT_EVENT

    ItemType thisItemType
    Spell thisSpell

    static method AddSpell takes Unit purchaser, Spell whichSpell returns nothing
        set thistype.DISPLAYED_SPELL[purchaser] = whichSpell
        call HeroSpell.AddToUnit(whichSpell, purchaser)

        //call purchaser.Abilities.Add(whichSpell)

        call purchaser.Hero.SelectSpell(whichSpell, false)

        //if (thistype.LEVELS[purchaser] > 0) then
            call purchaser.Abilities.SetLevel(whichSpell, Math.MaxI(1, thistype.LEVELS[purchaser]))
        //endif
        call purchaser.Owner.Get().EnableAbility(whichSpell, true)
    endmethod

    static method RemoveSpell takes Unit purchaser, Spell whichSpell returns nothing
        set thistype.LEVELS[purchaser] = purchaser.Abilities.GetLevel(whichSpell)

        //call HeroSpell.RemoveFromUnit(whichSpell, purchaser)
        //call purchaser.Abilities.Remove(whichSpell)

        call HeroSpell.RemoveFromUnit(whichSpell, purchaser)
        //call purchaser.Abilities.Remove(whichSpell)

        //call purchaser.Abilities.RemoveBySelf(whichSpell.self)
        call purchaser.Owner.Get().EnableAbility(whichSpell, false)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local thistype this = SPELL.Event.GetTrigger().Data.Integer.Get(KEY)

        if (this != NULL) then
            call UNIT.Event.GetTrigger().Items.GetFirstOfType(this.thisItemType).ChargesAmount.Subtract(1)
        endif
    endmethod

    static method Event_ItemUse takes nothing returns nothing
        local Unit purchaser = UNIT.Event.GetTrigger()
        local ItemType thisItemType = ITEM_TYPE.Event.GetTrigger()

        local thistype this = thisItemType.Data.Integer.Get(KEY)

        call thistype.RemoveSpell(purchaser, thistype.DISPLAYED_SPELL[purchaser])

        call thistype.AddSpell(purchaser, this.thisSpell)
    endmethod

    static method Event_ItemLose takes nothing returns nothing
        local Unit purchaser = UNIT.Event.GetTrigger()
        local thistype this = ITEM_TYPE.Event.GetTrigger().Data.Integer.Get(KEY)

        local Spell thisSpell = this.thisSpell

        if (purchaser.Data.Integer.Subtract(KEY_ARRAY_DETAIL + thisSpell, 1) == false) then
            return
        endif

        call thistype.RemoveSpell(purchaser, thisSpell)

        if (purchaser.Data.Integer.Table.Remove(KEY_ARRAY, thisSpell) == false) then
            call thistype.AddSpell(purchaser, purchaser.Data.Integer.Table.Get(KEY_ARRAY, Memory.IntegerKeys.Table.STARTED))
        endif
    endmethod

    static method Event_ItemGain takes nothing returns nothing
        local Unit purchaser = UNIT.Event.GetTrigger()
        local thistype this = ITEM_TYPE.Event.GetTrigger().Data.Integer.Get(KEY)

        local Spell thisSpell = this.thisSpell

        if (purchaser.Data.Integer.Add(KEY_ARRAY_DETAIL + thisSpell, 1)) then
            if (purchaser.Data.Integer.Table.Add(KEY_ARRAY, thisSpell)) then
                set thisSpell = this.thisSpell

                call thistype.AddSpell(purchaser, thisSpell)
            endif
        endif
    endmethod

    static method Create takes ItemType whichItemType, integer chargesAmount, Spell whichSpell returns thistype
        local thistype this = thistype.allocate()

        set this.thisItemType = whichItemType
        set this.thisSpell = whichSpell
        call whichItemType.ChargesAmount.Set(chargesAmount)
        call whichItemType.Data.Integer.Set(KEY, this)
        call whichItemType.Event.Add(ITEM_GAIN_EVENT)
        call whichItemType.Event.Add(ITEM_LOSE_EVENT)
        call whichItemType.Event.Add(ITEM_USE_EVENT)
        call whichSpell.Data.Integer.Set(KEY, this)
        call whichSpell.Event.Add(SPELL_EFFECT_EVENT)

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ITEM_GAIN_EVENT = Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ItemGain)
        set thistype.ITEM_LOSE_EVENT = Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ItemLose)
        set thistype.ITEM_USE_EVENT = Event.Create(UNIT.Items.Events.Use.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ItemUse)
        set thistype.SPELL_EFFECT_EVENT = Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_SpellEffect)

        //Act1
        call thistype.Create(thistype.BLIZZARD, 5, Blizzard.THIS_SPELL)
        call thistype.Create(thistype.CHILLY_BREATH, 5, ChillyBreath.THIS_SPELL)
        call thistype.Create(thistype.FIREBALL, 5, Fireball.THIS_SPELL)
        call thistype.Create(thistype.VIVID_METEOR, 5, VividMeteor.THIS_SPELL)

        //Act2
        call thistype.Create(thistype.BARRIER, 5, Barrier.THIS_SPELL)
        call thistype.Create(thistype.FLAME_TONGUE, 5, FlameTongue.THIS_SPELL)
        call thistype.Create(thistype.HEAT_EXPLOSION, 5, HeatExplosion.THIS_SPELL)
        call thistype.Create(thistype.ICE_BLOCK, 5, IceBlock.THIS_SPELL)
        call thistype.Create(thistype.WARMTH_MAGNETISM, 5, WarmthMagnetism.THIS_SPELL)

        //Act3
        call thistype.Create(thistype.FROZEN_STAR, 5, FrozenStar.THIS_SPELL)
        call thistype.Create(thistype.GHOST_SWORD, 5, GhostSword.THIS_SPELL)
        call thistype.Create(thistype.SEVERANCE, 5, Severance.THIS_SPELL)
        call thistype.Create(thistype.SNOWY_SPHERE, 5, SnowySphere.THIS_SPELL)

        //Act4
    endmethod
endstruct