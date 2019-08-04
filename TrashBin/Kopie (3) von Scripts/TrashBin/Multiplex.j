//! runtextmacro BaseStruct("Multiplex", "MULTIPLEX")
    static Event CASTER_DEATH_EVENT
    static constant string CASTER_EFFECT_ATTACH_POINT = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl"
    static constant string CASTER_EFFECT_PATH = AttachPoint.OVERHEAD
    static constant string DEATH_EFFECT_PATH = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl"
    static real array DURATION
    static Event ILLUSION_DEATH_EVENT
    //! runtextmacro GetKey("KEY")
    static constant real OFFSET = 50.

    static Spell THIS_SPELL

    Unit caster
    Unit illusion

    static method Event_Illusion_Death takes nothing returns nothing
        local Unit illusion = UNIT.Event.GetTrigger()

        local thistype this = illusion.Data.Integer.Get(KEY)
        local Unit caster = this.caster

        call this.deallocate()
        call caster.Data.Integer.Remove(KEY)
        call caster.Event.Remove(CASTER_DEATH_EVENT)
        call illusion.Data.Integer.Remove(KEY)
        call illusion.Event.Remove(ILLUSION_DEATH_EVENT)
    endmethod

    static method Event_Caster_Death takes nothing returns nothing
        local thistype this = UNIT.Event.GetTrigger().Data.Integer.Get(KEY)

        call this.illusion.KillInstantly()
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Unit illusion
        local real offset = (-1. + Math.RandomI(0, 1) * 2.) * OFFSET

        local real angle = caster.Facing.Get() - Math.QUARTER_ANGLE
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local integer level = caster.Abilities.GetLevel(THIS_SPELL)
        local thistype this = caster.Data.Integer.Get(KEY)

        local real angleX = Math.Cos(angle)
        local real angleY = Math.Sin(angle)

        if (this != NULL) then
            call this.illusion.KillInstantly()
        endif

        set illusion = Unit.CreateIllusion(caster.Type.Get(), caster.Owner.Get(), casterX - offset * angleX, casterY - offset * angleY, UNIT.Facing.STANDARD, DURATION[level], DEATH_EFFECT_PATH)

        set this = thistype.allocate()
        set this.caster = caster
        set this.illusion = illusion
        call caster.Data.Integer.Set(KEY, this)
        call caster.Event.Add(CASTER_DEATH_EVENT)
        call caster.Position.X.Set(casterX + offset * angleX)
        call caster.Position.Y.Set(casterY + offset * angleY)
        call caster.Effects.Create(CASTER_EFFECT_PATH, CASTER_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()
        call illusion.Data.Integer.Set(KEY, this)
        call illusion.Event.Add(ILLUSION_DEATH_EVENT)
    endmethod

    static method Init takes nothing returns nothing
        set THIS_SPELL = Spell.CreateFromSelf('A003')

        call THIS_SPELL.SetOrder(Order.MIRROR_IMAGE)
        call THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)

        set CASTER_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Caster_Death)
        set DURATION[1] = 10.
        set DURATION[2] = 30.
        set DURATION[3] = 30.
        set ILLUSION_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Illusion_Death)
        call THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct

        //! runtextmacro Struct("Multiplex")
            static method Event takes nothing returns nothing
                call Unit.GetFromId(Event.GetSubjectId()).Order.ImmediateBySpell(Multiplex.THIS_SPELL)
            endmethod

            static method Init takes nothing returns nothing
                local EventCombination thisCombination = A_I.CastSpell.CreateBasics(Multiplex.THIS_SPELL, function thistype.Event)

                call thisCombination.AddNewEvent(UNIT.Attack.Events.OFFENDED_EVENT_TYPE, EventPriority.AI, NULL)
            endmethod
        endstruct