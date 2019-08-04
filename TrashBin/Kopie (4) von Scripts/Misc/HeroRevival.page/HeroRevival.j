//! runtextmacro BaseStruct("HeroRevival", "HERO_REVIVAL")
    static Event DEATH_EVENT
    static CineFilter DUMMY_CINE_FILTER
    static boolean IGNORE_NEXT = false
    //! runtextmacro GetKey("KEY")
    static Rectangle array REVIVAL_RECTS
    static Event REVIVE_EVENT
    //! runtextmacro CreateHumanEyeTime("UPDATE_FACING_TIME", "4")

    static integer GHOSTS_AMOUNT = 0

    Unit ghost
    UnitEffect ghostEffect
    Timer updateFacingTimer
    Unit whichUnit

    static method GetGhostByUnit takes Unit whichUnit returns Unit
        return thistype(whichUnit.Data.Integer.Get(KEY)).ghost
    endmethod

    method Ending takes Unit ghost, Unit whichUnit returns nothing
        local UnitEffect ghostEffect = this.ghostEffect
        local Timer updateFacingTimer = this.updateFacingTimer

        call ghost.Data.Integer.Remove(KEY)
        call updateFacingTimer.Destroy()
        call whichUnit.Data.Integer.Remove(KEY)
        call whichUnit.Event.Remove(REVIVE_EVENT)

        call ghost.Destroy()

        set thistype.GHOSTS_AMOUNT = thistype.GHOSTS_AMOUNT - 1

        if (thistype.GHOSTS_AMOUNT == 0) then
            call Unit.ROSA.Animation.Loop.Abort()
        endif
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit ghost = UNIT.Event.GetTrigger()
        local User localPlayer = User.GetLocal()

        local boolean selected = ghost.IsSelected(localPlayer)
        local thistype this = ghost.Data.Integer.Get(KEY)
        local real angle = ghost.Facing.Get()
        local User ghostOwner = whichUnit.Owner.Get()
        local real x = ghost.Position.X.Get()
        local real y = ghost.Position.Y.Get()

        local Unit whichUnit = this.whichUnit

        call this.Ending(ghost, whichUnit)

        call thistype.DUMMY_CINE_FILTER.Ending(ghostOwner)
        call whichUnit.Hero.Revive(x, y)

        call whichUnit.Effects.Create(thistype.REVIVE_EFFECT_PATH, thistype.REVIVE_EFFECT_ATTACH_PT, EffectLevel.NORMAL).DestroyTimed.Start(5.)
        call whichUnit.Facing.Set(angle)

        call whichUnit.MagicImmunity.AddTimed(thistype.MAGIC_IMMUNITY_DURATION, UNIT.MagicImmunity.NORMAL_BUFF)
        call SetUnitOwner(whichUnit.self, ghostOwner.self, false)
        call whichUnit.Select(localPlayer, selected)

        call whichUnit.Life.Set(thistype.LIFE_FACTOR * whichUnit.MaxLife.GetAll())
        call whichUnit.Mana.Set(thistype.MANA_FACTOR * whichUnit.MaxMana.GetAll())
    endmethod

    static method UpdateFacing takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

        call this.whichUnit.Facing.Set(this.ghost.Facing.Get())
    endmethod

    static method Event_Death takes nothing returns nothing
        local Rectangle revivalRect        
        local Unit ghost
        local User ghostOwner
        local User localPlayer
        local boolean selected
        local thistype this
        local Timer updateFacingTimer
        local Unit whichUnit = UNIT.Event.GetTrigger()
        local real x
        local real y

        if (whichUnit.Revival.Is()) then
            return
        endif

        set ghostOwner = whichUnit.Owner.Get()
        set thistype.GHOSTS_AMOUNT = thistype.GHOSTS_AMOUNT + 1
        set localPlayer = User.GetLocal()
        set revivalRect = thistype.REVIVAL_RECTS[0]
        set selected = whichUnit.IsSelected(localPlayer)
        set this = thistype.allocate()
        set updateFacingTimer = Timer.Create()

        set x = revivalRect.RandomX()
        set y = revivalRect.RandomY()
        if (thistype.GHOSTS_AMOUNT == 1) then
            call Unit.ROSA.Animation.Loop.Start(UNIT.Animation.SPELL)
        endif

        set thistype.IGNORE_NEXT = true

        set ghost = Unit.Create(whichUnit.Type.Get(), ghostOwner, x, y, Math.AtanByDeltas(Waypoint.CENTER.GetCenterY() - y, Waypoint.CENTER.GetCenterX() - x))

        set this.ghost = ghost
        set this.ghostEffect = ghost.Effects.Create(thistype.GHOST_EFFECT_PATH, thistype.GHOST_EFFECT_ATTACH_PT, EffectLevel.LOW)
        set this.updateFacingTimer = updateFacingTimer
        set this.whichUnit = whichUnit
        call ghost.Data.Integer.Set(KEY, this)
        call updateFacingTimer.SetData(this)

        call thistype.DUMMY_CINE_FILTER.Start(3., ghostOwner)
        call ghost.Abilities.Clear()
        call ghost.Attack.Subtract()
        call ghost.Classes.Add(UnitClass.DEAD)
        call ghost.Classes.Add(UnitClass.NEUTRAL)
        call ghost.Effects.Create(thistype.DEATH_EFFECT_PATH, thistype.DEATH_EFFECT_ATTACH_PT, EffectLevel.NORMAL).DestroyTimed.Start(5.)
        call ghost.Ghost.Add()
        call ghost.Invisibility.Add()
        call ghost.Invulnerability.Add(UNIT.Invulnerability.NONE_BUFF)
        call ghost.LifeRegeneration.Set(0.)
        call ghost.Mana.Set(0.)
        call ghost.ManaRegeneration.Set(thistype.MANA_REGENERATION)
        call ghost.MaxLife.Set(100.)
        call ghost.MaxMana.Set(thistype.MANA_CAP)
        call ghost.Select(localPlayer, selected)
        call ghost.Stun.AddTimed(2., UNIT.Stun.NONE_BUFF)
        if ((localPlayer == whichUnit.Owner.Get()) and selected) then
            call Camera.PanTimed(localPlayer, x, y, 3.)
        endif
        call whichUnit.Data.Integer.Set(KEY, this)
        call whichUnit.Event.Add(REVIVE_EVENT)
        call SetUnitOwner(whichUnit.self, User.NEUTRAL_PASSIVE.self, false)

        call ghost.Abilities.Add(thistype.THIS_SPELL)
        call ghost.Life.Set(100.)

        call updateFacingTimer.Start(thistype.UPDATE_FACING_TIME, true, function thistype.UpdateFacing)
    endmethod

    static method Event_Revive takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        local thistype this = whichUnit.Data.Integer.Get(KEY)

        call this.Ending(this.ghost, whichUnit)
    endmethod

    static method Event_HeroPick takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Add(DEATH_EVENT)
    endmethod

    static method Event_Start takes nothing returns nothing
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death)
        set thistype.REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Revive)
        call Event.Create(HeroSelection.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_HeroPick).AddToStatics()
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_SpellEffect))
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DUMMY_CINE_FILTER = CineFilter.Create()
        set thistype.REVIVAL_RECTS[0] = Rectangle.CreateFromSelf(gg_rct_HeroRevival)
        set thistype.REVIVAL_RECTS[1] = Rectangle.CreateFromSelf(gg_rct_HeroRevival2)

        call thistype.DUMMY_CINE_FILTER.SetColorEnd(148, 58, 145, Real.ToInt(0.7 * 255))
        call thistype.DUMMY_CINE_FILTER.SetTexture("ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp")

        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
    endmethod
endstruct