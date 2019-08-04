//! runtextmacro BaseStruct("HeroRevival", "HERO_REVIVAL")
    static Event DEATH_EVENT
    static CineFilter DUMMY_CINE_FILTER
    //! runtextmacro GetKey("KEY")
    static Rectangle array REVIVAL_RECTS
    static Event REVIVE_EVENT
    static Unit ROSA
    static Rectangle ROSA_RECT
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
            call thistype.ROSA.Animation.Loop.Abort()
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit ghost = params.Unit.GetTrigger()
        local User localPlayer = User.GetLocal()

        local boolean selected = ghost.IsSelected(localPlayer)
        local real angle = ghost.Facing.Get()
        local User ghostOwner = ghost.Owner.Get()
        local real x = ghost.Position.X.Get()
        local real y = ghost.Position.Y.Get()

		local thistype this = ghost.Data.Integer.Get(KEY)

        local Unit whichUnit = this.whichUnit

        call this.Ending(ghost, whichUnit)

        call thistype.DUMMY_CINE_FILTER.Ending(ghostOwner)
        call whichUnit.Hero.Revive(x, y)

        call whichUnit.Effects.Create(thistype.REVIVE_EFFECT_PATH, thistype.REVIVE_EFFECT_ATTACH_PT, EffectLevel.NORMAL).DestroyTimed.Start(5.)
        call whichUnit.Facing.Set(angle)

        call whichUnit.Buffs.Timed.Start(UNIT.MagicImmunity.NORMAL_BUFF, 1, thistype.MAGIC_IMMUNITY_DURATION)
        call SetUnitOwner(whichUnit.self, ghostOwner.self, false)
        call whichUnit.Select(localPlayer, selected)

        call whichUnit.Life.Set(thistype.LIFE_FACTOR * whichUnit.MaxLife.Get())
        call whichUnit.Mana.Set(thistype.MANA_FACTOR * whichUnit.MaxMana.Get())
    endmethod

    timerMethod UpdateFacing
        local thistype this = Timer.GetExpired().GetData()

        call this.whichUnit.Facing.Set(this.ghost.Facing.Get())
    endmethod

    eventMethod Event_Death
        local Unit whichUnit = params.Unit.GetTrigger()

        if whichUnit.Revival.Is() then
            return
        endif

		set thistype.GHOSTS_AMOUNT = thistype.GHOSTS_AMOUNT + 1

        local User ghostOwner = whichUnit.Owner.Get()
        local User localPlayer = User.GetLocal()
        local Rectangle revivalRect = thistype.REVIVAL_RECTS[0]
        local boolean selected = whichUnit.IsSelected(localPlayer)

        local thistype this = thistype.allocate()

        local Timer updateFacingTimer = Timer.Create()

        local real x = revivalRect.RandomX()
        local real y = revivalRect.RandomY()

        local Unit ghost = Unit.Create(whichUnit.Type.Get(), ghostOwner, x, y, Math.AtanByDeltas(Waypoint.CENTER.GetCenterY() - y, Waypoint.CENTER.GetCenterX() - x))

        set this.ghost = ghost
        set this.ghostEffect = ghost.Effects.Create(thistype.GHOST_EFFECT_PATH, thistype.GHOST_EFFECT_ATTACH_PT, EffectLevel.LOW)
        set this.updateFacingTimer = updateFacingTimer
        set this.whichUnit = whichUnit
        call ghost.Data.Integer.Set(KEY, this)
        call updateFacingTimer.SetData(this)

        call ghost.Abilities.Clear()
        call HeroSpell.ClearAtUnit(ghost)
        call ghost.Attack.Subtract()
        //call ghost.Classes.Add(UnitClass.DEAD)
        call ghost.Classes.Add(UnitClass.NEUTRAL)
        call ghost.Effects.Create(thistype.DEATH_EFFECT_PATH, thistype.DEATH_EFFECT_ATTACH_PT, EffectLevel.NORMAL).DestroyTimed.Start(5.)
        call ghost.Ghost.Add()
        call ghost.Invisibility.Add()
        call ghost.Invulnerability.Add()
        call ghost.LifeRegeneration.Set(0.)
        call ghost.Mana.Set(0.)
        call ghost.ManaRegeneration.Set(thistype.MANA_REGENERATION)
        call ghost.MaxLife.Set(100.)
        call ghost.MaxMana.Set(thistype.MANA_CAP)
        call ghost.Pathing.Subtract()
        call ghost.Select(localPlayer, selected)
        call ghost.Stun.AddTimed(2.)
        if ((localPlayer == whichUnit.Owner.Get()) and selected) then
            call Camera.PanTimed(localPlayer, x, y, 3.)
        endif

        call whichUnit.Data.Integer.Set(KEY, this)
        call whichUnit.Event.Add(REVIVE_EVENT)
        call SetUnitOwner(whichUnit.self, User.NEUTRAL_PASSIVE.self, false)

        call ghost.Abilities.Add(thistype.THIS_SPELL)
        call ghost.Life.Set(100.)

		call thistype.DUMMY_CINE_FILTER.Start(3., ghostOwner)

        call updateFacingTimer.Start(thistype.UPDATE_FACING_TIME, true, function thistype.UpdateFacing)

        if (thistype.GHOSTS_AMOUNT == 1) then
            call thistype.ROSA.Animation.Loop.Start(UNIT.Animation.SPELL)
        endif
    endmethod

    eventMethod Event_Revive
        local Unit whichUnit = params.Unit.GetTrigger()

        local thistype this = whichUnit.Data.Integer.Get(KEY)

        call this.Ending(this.ghost, whichUnit)
    endmethod

    eventMethod Event_HeroPick
        call params.Unit.GetTrigger().Event.Add(DEATH_EVENT)
    endmethod

    eventMethod Event_Start
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death)
        set thistype.REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Revive)
        call Event.Create(HeroSelection.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_HeroPick).AddToStatics()
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.SUCCESS_EVENT_TYPE, EventPriority.MISC, function thistype.Event_SpellEffect))
    endmethod

    initMethod Init of Misc_2
        set thistype.DUMMY_CINE_FILTER = CineFilter.Create()
        set thistype.REVIVAL_RECTS[0] = Rectangle.CreateFromSelf(gg_rct_HeroRevival)
        set thistype.REVIVAL_RECTS[1] = Rectangle.CreateFromSelf(gg_rct_HeroRevival2)

        call thistype.DUMMY_CINE_FILTER.SetColorEnd(148, 58, 145, Real.ToInt(0.7 * 255))
        call thistype.DUMMY_CINE_FILTER.SetTexture("ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp")

        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()

        set thistype.ROSA_RECT = Rectangle.CreateFromSelf(gg_rct_Rosa)

        local real x = thistype.ROSA_RECT.GetCenterX()
        local real y = thistype.ROSA_RECT.GetCenterY()

        set thistype.ROSA = Unit.Create(thistype.ROSA_TYPE, User.CASTLE, x, y, Math.AtanByDeltas(thistype.REVIVAL_RECTS[0].GetCenterY() - y, thistype.REVIVAL_RECTS[0].GetCenterX() - x))
    endmethod
endstruct