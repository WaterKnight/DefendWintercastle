//! runtextmacro BaseStruct("PlaceKeg", "PLACE_KEG")
    static constant real DURATION = 10.
    static constant string SUMMON_EFFECT_PATH = "Destructables\\Keg\\KegSpawn.mdx"

    static Spell THIS_SPELL

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()

        local Destructable summon = Destructable.Create(DestructableType.KEG, targetX, targetY, Spot.GetHeight(targetX, targetY), Math.RandomAngle(), 1., 0)

        call SpotEffect.CreateOnDestructable(summon, SUMMON_EFFECT_PATH, EffectLevel.NORMAL).DestroyTimed.Start(5.)

        call summon.ApplyTimedLife(DURATION)
    endmethod

    static method Init takes nothing returns nothing
        //! runtextmacro Spell_Create("/", "THIS_SPELL", "APlK", "Place Keg", "NORMAL")

        //! runtextmacro Spell_SetAnimation("/", "spell")
        //! runtextmacro Spell_SetAreaRange("/", "300.")
        //! runtextmacro Spell_SetButtonPosition("/", "3", "0")
        //! runtextmacro Spell_SetCooldown("/", "10.")
        //! runtextmacro Spell_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSelfDestruct.blp")
        //! runtextmacro Spell_SetManaCost("/", "40")
        //! runtextmacro Spell_SetOrder("/", "selfdestruct")
        //! runtextmacro Spell_SetRange("/", "99999.")
        //! runtextmacro Spell_SetTargetType("/", "POINT")
        //! runtextmacro Spell_SetUberTooltip("/", "Puts a barrel at the target position that explodes after 10 seconds or when being attacked. The explosion deals 200 area damage.")

        //! runtextmacro Spell_Finalize("/")

        call THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct