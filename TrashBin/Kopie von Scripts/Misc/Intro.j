//! runtextmacro BaseStruct("Intro", "INTRO")
    static Destructable BARREL_DESTRUCTABLE
    static string BRAZIER_SOUND_PATH = "Sound\\Ambient\\DoodadEffects\\LordaeronSummerBrazierLoop1.wav"
    static Camera CAM
    static Camera CAM2
    static Camera CAM3
    static Camera CAM4
    static Camera CAM5
    static Camera CAM6
    static Camera CAM7
    static Camera CAM8
    static Camera CAM9
    static Camera CAM10
    static Camera CAM11
    static Trigger CINE_ABORT_TRIGGER
    static Timer CINE_TIMER
    static constant real DURATION = 300.

    static Rectangle DRAKUL_RECT
    static Rectangle SMOKEALOT_RECT
    static Rectangle ROCKETEYE_RECT
    static Rectangle ARURUW_RECT
    static Rectangle STORMY_RECT
    static Rectangle STORMY2_RECT
    static Rectangle LIZZY_RECT
    static Rectangle LIZZY2_RECT
    static Rectangle LIZZY3_RECT
    static Rectangle TAJRAN_RECT
    static Rectangle TAJRAN2_RECT

    static DummyUnit DRAKUL_UNIT
    static DummyUnit SMOKEALOT_UNIT
    static DummyUnit ROCKETEYE_UNIT
    static DummyUnit ARURUW_UNIT
    static DummyUnit STORMY_UNIT
    static DummyUnit LIZZY_UNIT
    static DummyUnit LIZZY2_UNIT
    static DummyUnit LIZZY3_UNIT
    static DummyUnit TAJRAN_UNIT

    static Rectangle LIGHT_RECT
    static Rectangle LIGHT2_RECT
    static Sound LIGHT_SOUND
    static Sound LIGHT2_SOUND
    static DummyUnit LIGHT_UNIT
    static DummyUnit LIGHT2_UNIT
    static constant integer TORCH_UNIT_ID = 'h008'

    static method SetFaceToDestructable takes DummyUnit whichUnit, Destructable whichTarget returns nothing
        call whichUnit.Facing.SetToDestructable(whichTarget)
    endmethod

    static method SetFaceToUnit takes DummyUnit whichUnit, DummyUnit whichTarget returns nothing
        call whichUnit.Facing.SetToOtherDummyUnit(whichTarget)
    endmethod

    static method SetUnitAtRect takes DummyUnit whichUnit, Rectangle whichRect returns nothing
        call whichUnit.Position.X.Set(whichRect.GetCenterX())
        call whichUnit.Position.Y.Set(whichRect.GetCenterY())
    endmethod

    static method CreateUnitAtRect takes integer unitId, Rectangle whichRect, real whichAngle returns DummyUnit
        local real whichRectX = whichRect.GetCenterX()
        local real whichRectY = whichRect.GetCenterY()

        local DummyUnit newUnit = DummyUnit.Create(unitId, whichRectX, whichRectY, 0., whichAngle)

        call newUnit.PlayerColor.Set(PLAYER_COLOR_BROWN)

        return newUnit
    endmethod

    static method CreateUnitAtRectFaceUnit takes integer unitId, Rectangle whichRect, DummyUnit whichUnit returns DummyUnit
        local real whichRectX = whichRect.GetCenterX()
        local real whichRectY = whichRect.GetCenterY()

        local real whichAngle = Math.AtanByDeltas(whichUnit.Position.Y.Get() - whichRectY, whichUnit.Position.X.Get() - whichRectX)

        local DummyUnit newUnit = DummyUnit.Create(unitId, whichRectX, whichRectY, 0., whichAngle)

        call newUnit.PlayerColor.Set(PLAYER_COLOR_BROWN)

        return newUnit
    endmethod

    static method OrderUnitToRect takes DummyUnit whichUnit, Rectangle whichRect returns nothing
        call whichUnit.Order.PointTarget(Order.MOVE, whichRect.GetCenterX(), whichRect.GetCenterY())
    endmethod

    static method Wait takes real duration, code func returns nothing
        call thistype.CINE_TIMER.Start(duration, false, func)
    endmethod

    static method ApplyCam takes Camera whichCam, real duration returns nothing
        call whichCam.Apply(true, duration)
    endmethod

    static method ApplyCamWait takes Camera whichCam, real duration, code func returns nothing
        call whichCam.Apply(true, duration)
        call thistype.CINE_TIMER.Start(duration, false, func)
    endmethod

    static method SetTransmission takes DummyUnit whichUnit, string text, real duration, code func returns nothing
        call whichUnit.Flash(127, 127, 127, 63)
        call Cinematic.SetScene(whichUnit.GetTypeId(), PLAYER_COLOR_BROWN, whichUnit.GetProperName(), text, duration, duration * 0.8)
        call thistype.CINE_TIMER.Start(duration, false, func)
    endmethod

    static method FadeWait takes integer red, integer green, integer blue, integer alpha, real duration, code func returns nothing
        local CineFilter newFilter = CineFilter.Create()

        call newFilter.SetColorEnd(red, green, blue, 255)
        call newFilter.SetColorStart(255, 255, 255, 0)
        call newFilter.SetTexture("ReplaceableTextures\\CameraMasks\\White_mask.blp")

        call newFilter.Start(duration, User.ANY)

        call thistype.CINE_TIMER.Start(duration, false, func)
    endmethod

    static method Ending takes nothing returns nothing
        local real x = HeroSelection.CENTER_RECT.GetCenterX()
        local real y = HeroSelection.CENTER_RECT.GetCenterY()

        call Cinematic.EndScene()
        call Game.DisplayInterface(User.ANY, true, 1.)
        call Game.EnableControl(User.ANY, true)
        call thistype.CINE_ABORT_TRIGGER.Destroy()
        call thistype.LIGHT_SOUND.Destroy(false)
        call thistype.LIGHT2_SOUND.Destroy(false)
        call thistype.DRAKUL_UNIT.DestroyInstantly()
        call thistype.SMOKEALOT_UNIT.DestroyInstantly()
        call thistype.ROCKETEYE_UNIT.DestroyInstantly()
        call thistype.ARURUW_UNIT.DestroyInstantly()
        call thistype.STORMY_UNIT.DestroyInstantly()
        if (thistype.LIZZY_UNIT != NULL) then
            call thistype.LIZZY_UNIT.DestroyInstantly()
        endif
        if (thistype.TAJRAN_UNIT != NULL) then
            call thistype.TAJRAN_UNIT.DestroyInstantly()
        endif
        call Camera.Reset(User.ANY, 0.)
        call Camera.PanTimed(User.ANY, x, y, 0.)

        call AfterIntro.Start()

        call thistype.CINE_TIMER.Start(1., false, function Difficulty.Start)
    endmethod

    static method Step27 takes nothing returns nothing
        call thistype.Wait(3., function thistype.Ending)
    endmethod

    static method Step26 takes nothing returns nothing
        call thistype.ApplyCam(thistype.CAM11, 5.)
        call thistype.FadeWait(0, 0, 0, 0, 4., function thistype.Step27)
    endmethod

    static method Step25 takes nothing returns nothing
        call thistype.SetTransmission(thistype.DRAKUL_UNIT, "Wintercastle should be a place for all that are in need of help. In these difficult times, we have to stick together, and as I am looking here, there seem to be already all kind of peoples. So break up your disputes and let's take it on at last...", 12., function thistype.Step26)
    endmethod

    static method Step24b takes nothing returns nothing
        call thistype.SetTransmission(thistype.SMOKEALOT_UNIT, "I have to agree with lady Aruruw in this matter.", 3., function thistype.Step25)
    endmethod

    static method Step24 takes nothing returns nothing
        call thistype.SetTransmission(thistype.ARURUW_UNIT, "We shouldn't trust him, Milord. He could be a spy just as well. And even if he speaks the truth, he will still just cause trouble for us with his presence. I am aware of the Orcs' nature and their determination to wipe out every traitor.", 10., function thistype.Step24b)
    endmethod

    static method Step23c takes nothing returns nothing
        call thistype.SetTransmission(thistype.TAJRAN_UNIT, "Furthermore, my clan yearns to kill me. Hence, I would like to ask for refuge. As a reward, I promise you to help in every matter, until my legs won't carry me any longer.", 9., function thistype.Step24)
    endmethod

    static method Step23b takes nothing returns nothing
        call SetFaceToUnit(thistype.TAJRAN_UNIT, thistype.DRAKUL_UNIT)

        call thistype.SetTransmission(thistype.TAJRAN_UNIT, "Yes, I belong to the Orcish race, but was I expelled of my own tribe, when I hesistated to executed one of our enemies and escaped. You see, I was one of their shamans, not a fighter and never approved the violent methods of my fellows. Alone, I won't be able to last for long in this world of ice out there.", 13.5, function thistype.Step23c)
    endmethod

    static method Step23 takes nothing returns nothing
        call SetFaceToUnit(thistype.TAJRAN_UNIT, thistype.ROCKETEYE_UNIT)

        call thistype.SetTransmission(thistype.TAJRAN_UNIT, "Listen to my words, please!", 3., function thistype.Step23b)
    endmethod

    static method Step22d takes nothing returns nothing
        call thistype.SetTransmission(thistype.SMOKEALOT_UNIT, "We should really start deploying some guard posts.", 4., function thistype.Step23)
    endmethod

    static method Step22c takes nothing returns nothing
        call SetFaceToUnit(thistype.ROCKETEYE_UNIT, thistype.TAJRAN_UNIT)

        call thistype.SetTransmission(thistype.ROCKETEYE_UNIT, "Hey, you are one of these vandals!", 3., function thistype.Step22d)
    endmethod

    static method Step22b takes nothing returns nothing
        call thistype.SetTransmission(thistype.TAJRAN_UNIT, "Excuse me for my rude intrusion...", 3.5, function thistype.Step22c)
    endmethod

    static method Step22 takes nothing returns nothing
        set thistype.TAJRAN_UNIT = CreateUnitAtRect('O000', thistype.TAJRAN_RECT, Math.EAST_ANGLE)

        call OrderUnitToRect(thistype.TAJRAN_UNIT, thistype.TAJRAN2_RECT)

        call thistype.Wait(2., function thistype.Step22b)
    endmethod

    static method Step21b takes nothing returns nothing
        call thistype.SetTransmission(thistype.DRAKUL_UNIT, "With that said, we are complete. I myself will participate as well. The caravans, which will traverse the forest under the protection of our efforts, are already standing by.", 8., function thistype.Step22)
    endmethod

    static method Step21 takes nothing returns nothing
        call SetUnitAtRect(thistype.STORMY_UNIT, thistype.STORMY_RECT)
        call SetUnitAtRect(thistype.LIZZY_UNIT, thistype.LIZZY3_RECT)
        call SetFaceToUnit(thistype.ROCKETEYE_UNIT, thistype.DRAKUL_UNIT)
        call SetFaceToUnit(thistype.SMOKEALOT_UNIT, thistype.DRAKUL_UNIT)
        call SetFaceToUnit(thistype.ARURUW_UNIT, thistype.DRAKUL_UNIT)
        call SetFaceToUnit(thistype.STORMY_UNIT, thistype.DRAKUL_UNIT)
        call thistype.DRAKUL_UNIT.Facing.Set(Math.WEST_ANGLE)
        call thistype.ApplyCam(thistype.CAM10, 0.)

        call thistype.Wait(1., function thistype.Step21b)
    endmethod

    static method Step20 takes nothing returns nothing
        call thistype.SetTransmission(thistype.ROCKETEYE_UNIT, "Another gal. The group is already to my liking.", 3., function thistype.Step21)
    endmethod

    static method Step19b takes nothing returns nothing
        call thistype.SetTransmission(thistype.SMOKEALOT_UNIT, "This is LIZZY, a fairy from the Mid East. She was the sole survivor, I rescued, when her homeland was destroyed by the elves. Back then, she decided to accompany me. I am confident she will complement us well with her magical abilities.", 13., function thistype.Step20)
    endmethod

    static method Step19 takes nothing returns nothing
        call SetFaceToUnit(thistype.STORMY_UNIT, thistype.LIZZY_UNIT)

        call thistype.SetTransmission(thistype.STORMY_UNIT, "And you are? *hic*", 2.5, function thistype.Step19b)
    endmethod

    static method Step18b takes nothing returns nothing
        call thistype.SetTransmission(thistype.LIZZY_UNIT, "*hihi* What a primitive blubberbutt!", 3., function thistype.Step19)
    endmethod

    static method Step18 takes nothing returns nothing
        call thistype.LIZZY_UNIT.Destroy()

        set thistype.LIZZY_UNIT = CreateUnitAtRect('H007', thistype.LIZZY_RECT, Math.SOUTH_ANGLE)

        call OrderUnitToRect(thistype.LIZZY_UNIT, thistype.LIZZY2_RECT)

        call thistype.ApplyCamWait(thistype.CAM9, 2., function thistype.Step18b)
    endmethod

    static method Step17c takes nothing returns nothing
        call STORMY_UNIT.Animation.SetByIndex(6)
        call STORMY_UNIT.Animation.Queue(Animation.STAND)

        call thistype.SetTransmission(thistype.STORMY_UNIT, "What the?! Where are these wretches that mess up my beer?! I thwack them until they decide to become meat eaters!", 5.5, function thistype.Step18)
    endmethod

    static method Step17b takes nothing returns nothing
        call thistype.Wait(1., function thistype.Step17c)
    endmethod

    static method Step17 takes nothing returns nothing
        call thistype.SetTransmission(thistype.SMOKEALOT_UNIT, "When the animals are to steal all of the corn from the silos, there won't be any alcohol for you too soon!", 5., function thistype.Step17b)
    endmethod

    static method Step16f takes nothing returns nothing
        call thistype.SetTransmission(thistype.STORMY_UNIT, "Eh?", 1., function thistype.Step17)
    endmethod

    static method Step16e takes nothing returns nothing
        call thistype.SetTransmission(thistype.SMOKEALOT_UNIT, "We are in perilous situation right now, we should keep a clear mind.", 3.5, function thistype.Step16f)
    endmethod

    static method Step16d takes nothing returns nothing
        call SetFaceToUnit(thistype.STORMY_UNIT, thistype.DRAKUL_UNIT)

        call thistype.SetTransmission(thistype.STORMY_UNIT, "What?", 1., function thistype.Step16e)
    endmethod

    static method Step16c takes nothing returns nothing
        call thistype.SetTransmission(thistype.DRAKUL_UNIT, "Stormy, now, it isn't the right time to bemuse yourself with this dazing mixture!", 4., function thistype.Step16d)
    endmethod

    static method Step16b takes nothing returns nothing
        call thistype.Wait(1, function thistype.Step16c)
    endmethod

    static method Step16 takes nothing returns nothing
        call SetFaceToUnit(thistype.DRAKUL_UNIT, thistype.STORMY_UNIT)
        call SetFaceToUnit(thistype.ROCKETEYE_UNIT, thistype.STORMY_UNIT)
        call SetFaceToUnit(thistype.SMOKEALOT_UNIT, thistype.STORMY_UNIT)
        call SetFaceToUnit(thistype.ARURUW_UNIT, thistype.STORMY_UNIT)

        call thistype.ApplyCamWait(thistype.CAM10, 2.5, function thistype.Step16b)
    endmethod

    static method Step15 takes nothing returns nothing
        call thistype.SetTransmission(thistype.STORMY_UNIT, "*hic*", 1.5, function thistype.Step16)
    endmethod

    static method Step14e takes nothing returns nothing
        call thistype.SetTransmission(thistype.ARURUW_UNIT, "...he stood right next to me just a moment ago.", 3., function thistype.Step15)
    endmethod

    static method Step14d takes nothing returns nothing
        call thistype.SetTransmission(thistype.ARURUW_UNIT, "...", 0.75, function thistype.Step14e)
    endmethod

    static method Step14c takes nothing returns nothing
        call thistype.SetTransmission(thistype.ARURUW_UNIT, "..", 0.75, function thistype.Step14d)
    endmethod

    static method Step14b takes nothing returns nothing
        call thistype.SetTransmission(thistype.ARURUW_UNIT, ".", 0.75, function thistype.Step14c)
    endmethod

    static method Step14 takes nothing returns nothing
        call thistype.ApplyCam(thistype.CAM7, 0.)

        call thistype.Wait(1., function thistype.Step14b)
    endmethod

    static method Step13c takes nothing returns nothing
        call thistype.SetTransmission(thistype.DRAKUL_UNIT, "Where did he disappear to again?!", 2., function thistype.Step14)
    endmethod

    static method Step13b takes nothing returns nothing
        call SetUnitAtRect(thistype.STORMY_UNIT, thistype.STORMY2_RECT)
        call SetFaceToDestructable(thistype.STORMY_UNIT, thistype.BARREL_DESTRUCTABLE)

        set thistype.LIZZY_UNIT = CreateUnitAtRect('h009', thistype.STORMY_RECT, Math.SOUTH_ANGLE)

        call thistype.SetTransmission(thistype.DRAKUL_UNIT, "Then, there's Stor...", 3., function thistype.Step13c)
    endmethod

    static method Step13 takes nothing returns nothing
        call thistype.ApplyCamWait(thistype.CAM, 0.5, function thistype.Step13b)
    endmethod

    static method Step12b takes nothing returns nothing
        call SetFaceToUnit(thistype.ROCKETEYE_UNIT, thistype.DRAKUL_UNIT)
        call thistype.Wait(0.5, function thistype.Step13)
    endmethod

    static method Step12 takes nothing returns nothing
        call thistype.SetTransmission(thistype.ROCKETEYE_UNIT, "Woo, I am impressed, young lad'.", 3., function thistype.Step12b)
    endmethod

    static method Step11c takes nothing returns nothing
        call thistype.ApplyCam(thistype.CAM6, 2.)

        call thistype.SetTransmission(thistype.ARURUW_UNIT, "While approaching your castle I noticed a lot of incensed animals, on the south pass in particular. The " + String.Color.Do("Great Winter", String.Color.GOLD) + " hit them pretty well, too, and turned them into raging creatures.", 9.5, function thistype.Step12)
    endmethod

    static method Step11b takes nothing returns nothing
        call SetFaceToUnit(thistype.ARURUW_UNIT, thistype.DRAKUL_UNIT)
        call thistype.Wait(1., function thistype.Step11c)
    endmethod

    static method Step11 takes nothing returns nothing
        call thistype.SetTransmission(thistype.DRAKUL_UNIT, "I received information about lady Aruruw, about her excellent skills as a huntress. This might be to our advantage on this task.", 9., function thistype.Step11b)
    endmethod

    static method Step10c takes nothing returns nothing
        call thistype.SetTransmission(thistype.ARURUW_UNIT, "Do you aim to challenge me?", 4., function thistype.Step11)
    endmethod

    static method Step10b takes nothing returns nothing
        call thistype.ApplyCamWait(thistype.CAM4, 1., function thistype.Step10c)
    endmethod

    static method Step10 takes nothing returns nothing
        call thistype.Wait(1., function thistype.Step10b)
    endmethod

    static method Step9 takes nothing returns nothing
        call SetFaceToUnit(thistype.ARURUW_UNIT, thistype.ROCKETEYE_UNIT)

        call thistype.ApplyCamWait(thistype.CAM5, 1., function thistype.Step10)
    endmethod

    static method Step8 takes nothing returns nothing
        call SetFaceToUnit(thistype.ROCKETEYE_UNIT, thistype.ARURUW_UNIT)

        call thistype.SetTransmission(thistype.ROCKETEYE_UNIT, "This shorty can fight?", 2.5, function thistype.Step9)
    endmethod

    static method Step7b takes nothing returns nothing
        call thistype.SetTransmission(thistype.DRAKUL_UNIT, "Lady Aruruw", 3., function thistype.Step8)
    endmethod

    static method Step7 takes nothing returns nothing
        call thistype.SMOKEALOT_UNIT.Animation.Set(Animation.STAND_READY)

        call thistype.SetTransmission(thistype.SMOKEALOT_UNIT, "At your service *kindles a cigarette*", 3., function thistype.Step7b)
    endmethod

    static method Step6 takes nothing returns nothing
        call thistype.ApplyCam(CAM3, 0.5)

        call thistype.SetTransmission(thistype.DRAKUL_UNIT, "Sir Smokealot", 2., function thistype.Step7)
    endmethod

    static method Step5 takes nothing returns nothing
        call thistype.SetTransmission(thistype.ROCKETEYE_UNIT, "Aye", 1.5, function thistype.Step6)
    endmethod

    static method Step4 takes nothing returns nothing
        call thistype.ApplyCamWait(thistype.CAM2, 0.5, function thistype.Step5)
    endmethod

    static method Step3 takes nothing returns nothing
        call thistype.SetTransmission(thistype.DRAKUL_UNIT, "Rocketeye", 1., function thistype.Step4)
    endmethod

    static method Step2 takes nothing returns nothing
        call thistype.DRAKUL_UNIT.Animation.Set(Animation.SPELL_SLAM)
        call thistype.DRAKUL_UNIT.Animation.Queue(Animation.STAND)

        call thistype.SetTransmission(DRAKUL_UNIT, "Meanwhile, wild animals of the bordering woods have begun to exploit our storages and to attack the residents. This is the reason I called for the four of you.", 7., function thistype.Step3)
    endmethod

    static method AbortTrig takes nothing returns nothing
        local integer iteration = ARRAY_MIN
        local User whichPlayer = USER.Event.Native.GetTrigger()

        local integer whichPlayerIndex = whichPlayer.GetIndex()

        call AfterIntro.StartForPlayer(whichPlayer)

        loop
            exitwhen (User.ALL[iteration].SlotState.Get() == PlayerSlotState.PLAYING)

            set iteration = iteration + 1
        endloop

        if (whichPlayerIndex == iteration) then
            call thistype.Ending()
        endif
    endmethod

    static method Event_Start takes nothing returns nothing
        local real x = HeroSelection.CENTER_RECT.GetCenterX()
        local real y = HeroSelection.CENTER_RECT.GetCenterY()

        call Camera.PanTimed(User.ANY, x, y, 0.)

        call AfterIntro.Start()

        call Timer.Create().Start(1., false, function Difficulty.Start)

        return

        set thistype.BARREL_DESTRUCTABLE = Destructable.CreateFromSelf(gg_dest_B005_0080)
        set thistype.CAM = Camera.CreateFromSelf(gg_cam_Introduction)
        set thistype.CAM2 = Camera.CreateFromSelf(gg_cam_Introduction2)
        set thistype.CAM3 = Camera.CreateFromSelf(gg_cam_Introduction3)
        set thistype.CAM4 = Camera.CreateFromSelf(gg_cam_Introduction4)
        set thistype.CAM5 = Camera.CreateFromSelf(gg_cam_Introduction5)
        set thistype.CAM6 = Camera.CreateFromSelf(gg_cam_Introduction6)
        set thistype.CAM7 = Camera.CreateFromSelf(gg_cam_Introduction7)
        set thistype.CAM8 = Camera.CreateFromSelf(gg_cam_Introduction8)
        set thistype.CAM9 = Camera.CreateFromSelf(gg_cam_Introduction9)
        set thistype.CAM10 = Camera.CreateFromSelf(gg_cam_Introduction10)
        set thistype.CAM11 = Camera.CreateFromSelf(gg_cam_Introduction11)
        set thistype.CINE_ABORT_TRIGGER = Trigger.CreateFromCode(function thistype.AbortTrig)
        set thistype.CINE_TIMER = Timer.Create()
        set thistype.DRAKUL_RECT = Rectangle.CreateFromSelf(gg_rct_Introduction_Drakul)
        set thistype.SMOKEALOT_RECT = Rectangle.CreateFromSelf(gg_rct_Introduction_Smokealot)
        set thistype.ROCKETEYE_RECT = Rectangle.CreateFromSelf(gg_rct_Introduction_Rocketeye)
        set thistype.ARURUW_RECT = Rectangle.CreateFromSelf(gg_rct_Introduction_Aruruw)
        set thistype.STORMY_RECT = Rectangle.CreateFromSelf(gg_rct_Introduction_Stormy)
        set thistype.STORMY2_RECT = Rectangle.CreateFromSelf(gg_rct_Introduction_Stormy2)
        set thistype.LIZZY_RECT = Rectangle.CreateFromSelf(gg_rct_Introduction_Lizzy)
        set thistype.LIZZY2_RECT = Rectangle.CreateFromSelf(gg_rct_Introduction_Lizzy2)
        set thistype.LIZZY3_RECT = Rectangle.CreateFromSelf(gg_rct_Introduction_Lizzy3)
        set thistype.TAJRAN_RECT = Rectangle.CreateFromSelf(gg_rct_Introduction_Tajran)
        set thistype.TAJRAN2_RECT = Rectangle.CreateFromSelf(gg_rct_Introduction_Tajran2)
        set thistype.LIGHT_RECT = Rectangle.CreateFromSelf(gg_rct_Introduction_Light)
        set thistype.LIGHT2_RECT = Rectangle.CreateFromSelf(gg_rct_Introduction_Light2)
        set thistype.DRAKUL_UNIT = CreateUnitAtRect(UnitType.DRAKUL.self, thistype.DRAKUL_RECT, Math.NORTH_ANGLE)
        set thistype.ROCKETEYE_UNIT = CreateUnitAtRectFaceUnit(UnitType.ROCKETEYE.self, thistype.ROCKETEYE_RECT, thistype.DRAKUL_UNIT)
        set thistype.SMOKEALOT_UNIT = CreateUnitAtRectFaceUnit(UnitType.SMOKEALOT.self, thistype.SMOKEALOT_RECT, thistype.DRAKUL_UNIT)
        set thistype.ARURUW_UNIT = CreateUnitAtRectFaceUnit(UnitType.ARURUW.self, thistype.ARURUW_RECT, thistype.DRAKUL_UNIT)
        set thistype.STORMY_UNIT = CreateUnitAtRectFaceUnit(UnitType.STORMY.self, thistype.STORMY_RECT, thistype.DRAKUL_UNIT)
        set thistype.LIZZY_UNIT = NULL
        set thistype.TAJRAN_UNIT = NULL
        set thistype.LIGHT_UNIT = CreateUnitAtRect(thistype.TORCH_UNIT_ID, thistype.LIGHT_RECT, Math.SOUTH_ANGLE)
        set thistype.LIGHT2_UNIT = CreateUnitAtRect(thistype.TORCH_UNIT_ID, thistype.LIGHT2_RECT, Math.SOUTH_ANGLE)
        set thistype.LIGHT_SOUND = Sound.Create(thistype.BRAZIER_SOUND_PATH, true, false, false, 0, 0, SoundEax.DOODAD)
        set thistype.LIGHT2_SOUND = Sound.Create(thistype.BRAZIER_SOUND_PATH, true, false, false, 0, 0, SoundEax.DOODAD)
        call Game.DisplayInterface(User.ANY, false, 1)
        call Game.EnableControl(User.ANY, false)
        call thistype.ApplyCam(Camera.CreateFromSelf(gg_cam_Introduction), 0)
        call thistype.LIGHT_SOUND.Play()
        call thistype.LIGHT2_SOUND.Play()
        call thistype.DRAKUL_UNIT.Animation.Set(UNIT.Animation.SPELL_SLAM)

        call thistype.CINE_ABORT_TRIGGER.RegisterEvent.User(User.ANY, EVENT_PLAYER_END_CINEMATIC)
        call thistype.SetTransmission(DRAKUL_UNIT, "It's about one month now that you searched for shelter in my domicile Wintercastle. Our supply reserves are at a scant stock, so we have to send out caravans in order to retrieve left-behind goods from the surrounding villages.", 11, function thistype.Step2)
        //call SetTransmission(thistype.DRAKUL_UNIT, "It's about one month now that you searched for shelter in my domicile Wintercastle. Our supply reserves are at a scant stock, so we have to send out caravans in order to retrieve left-behind goods from the surrounding villages.", 3, function thistype.Ending)

        call thistype.DRAKUL_UNIT.Animation.Queue(UNIT.Animation.STAND)
        call Visibility.AddRect(User.ANY, Rectangle.CreateFromSelf(gg_rct_Introduction))
    endmethod

    static method Init takes nothing returns nothing
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
    endmethod
endstruct