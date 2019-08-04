//! runtextmacro BaseStruct("Music", "MUSIC")
    static thistype array PLAY_LIST
    static integer PLAY_LIST_COUNT = ARRAY_EMPTY

    integer playListIndex
    integer priority
    string self

    method Play takes nothing returns nothing
        if (this.playListIndex != ARRAY_EMPTY) then
            return
        endif

        local integer priority = this.priority
        local integer iteration = thistype.PLAY_LIST_COUNT

        set thistype.PLAY_LIST_COUNT = iteration + 1

        loop
        	exitwhen (iteration < ARRAY_MIN)
            exitwhen (thistype.PLAY_LIST[iteration].priority < priority)

            set thistype.PLAY_LIST[iteration].playListIndex = iteration + 1
            set thistype.PLAY_LIST[iteration + 1] = thistype.PLAY_LIST[iteration]

            set iteration = iteration - 1
        endloop

        set iteration = iteration + 1

        set thistype.PLAY_LIST[iteration] = this
        set this.playListIndex = iteration
        if (iteration == thistype.PLAY_LIST_COUNT) then
            call PlayMusic(this.self)
        endif
    endmethod

    method Stop takes nothing returns nothing
        local integer iteration = this.playListIndex

        if (iteration == ARRAY_EMPTY) then
            return
        endif

        set this.playListIndex = ARRAY_EMPTY

        local boolean wasCurrent = (iteration == thistype.PLAY_LIST_COUNT)

        set thistype.PLAY_LIST_COUNT = thistype.PLAY_LIST_COUNT - 1

        loop
            exitwhen (iteration > thistype.PLAY_LIST_COUNT)

            set thistype.PLAY_LIST[iteration] = thistype.PLAY_LIST[iteration + 1]
            set thistype.PLAY_LIST[iteration + 1].playListIndex = iteration

            set iteration = iteration + 1
        endloop

        if wasCurrent then
            if (thistype.PLAY_LIST_COUNT > ARRAY_EMPTY) then
                call StopMusic(false)

                call PlayMusic(thistype.PLAY_LIST[thistype.PLAY_LIST_COUNT].self)
            else
                call StopMusic(true)
            endif
        endif
    endmethod

    static method SetVolume takes real value returns nothing
        call SetMusicVolume(Real.ToInt(value * 127.))
    endmethod

    static method Create takes string self, integer priority returns thistype
        local thistype this = thistype.allocate()

        set this.playListIndex = ARRAY_EMPTY
        set this.priority = priority
        set this.self = self

        return this
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro BaseStruct("SoundChannel", "SOUND_CHANNEL")
    static real OVERALL_VOLUME = 1.

    static constant integer AMBIENT_LOOP = 10
    static constant integer ANIMATION = 11
    static constant integer BIRTH = 13
    static constant integer COMBAT = 5
    static constant integer CONSTRUCTION = 12
    static constant integer ERROR = 6
    static constant integer FIRE = 14
    static constant integer GENERAL = 0
    static constant integer MOVE_LOOP = 9
    static constant integer MUSIC = 7
    static constant integer UI = 8
    static constant integer UNIT_ACK = 2
    static constant integer UNIT_MOVE = 3
    static constant integer UNIT_READY = 4
    static constant integer UNIT_SELECT = 1

    real volume
    volumegroup whichVolumeGroup

    method GetVolume takes nothing returns real
        return this.volume
    endmethod

    method SetVolume takes real value returns nothing
        set this.volume = value

        call VolumeGroupSetVolume(this.whichVolumeGroup, value)
    endmethod

    static method SetVolumeOverall takes real value returns nothing
        local integer iteration = thistype.ALL_COUNT

        set thistype.OVERALL_VOLUME = value
        loop
            exitwhen (iteration < ARRAY_MIN)

            call VolumeGroupSetVolume(thistype.ALL[iteration].whichVolumeGroup, value)

            set iteration = iteration - 1
        endloop
    endmethod

    static method Create takes thistype this, volumegroup whichVolumeGroup returns thistype
        set this.whichVolumeGroup = whichVolumeGroup

        call this.SetVolume(1.)

        call this.AddToList()

        return this
    endmethod

    static method Init takes nothing returns nothing
        call thistype.Create(thistype.AMBIENT_LOOP, SOUND_VOLUMEGROUP_AMBIENTSOUNDS)
        call thistype.Create(thistype.ANIMATION, null)
        call thistype.Create(thistype.BIRTH, null)
        call thistype.Create(thistype.COMBAT, SOUND_VOLUMEGROUP_COMBAT)
        call thistype.Create(thistype.CONSTRUCTION, null)
        call thistype.Create(thistype.ERROR, SOUND_VOLUMEGROUP_UI)
        call thistype.Create(thistype.FIRE, SOUND_VOLUMEGROUP_FIRE)
        call thistype.Create(thistype.GENERAL, null)
        call thistype.Create(thistype.MOVE_LOOP, SOUND_VOLUMEGROUP_UNITMOVEMENT)
        //call thistype.Create(thistype.MUSIC, SOUND_VOLUMEGROUP_MUSIC)
        call thistype.Create(thistype.UI, SOUND_VOLUMEGROUP_UI)
        call thistype.Create(thistype.UNIT_ACK, SOUND_VOLUMEGROUP_UNITSOUNDS)
        call thistype.Create(thistype.UNIT_MOVE, SOUND_VOLUMEGROUP_UNITSOUNDS)
        call thistype.Create(thistype.UNIT_READY, SOUND_VOLUMEGROUP_UNITSOUNDS)
        call thistype.Create(thistype.UNIT_SELECT, SOUND_VOLUMEGROUP_UNITSOUNDS)
    endmethod
endstruct

//! runtextmacro BaseStruct("SoundEax", "SOUND_EAX")
    static thistype COMBAT
    static thistype DEFAULT
    static thistype DOODAD
    static thistype HERO_ACKS
    static thistype KOTO_DRUMS
    static thistype MISSILE
    static thistype SPELL

    //! runtextmacro CreateAnyState("self", "Self", "string")
    
    static method Create takes string self returns thistype
    	local thistype this = thistype.allocate()
    	
    	call this.SetSelf(self)
    	
    	return this
    endmethod
    
    static method Init takes nothing returns nothing
    	set thistype.COMBAT = thistype.Create("CombatSoundsEAX")
    	set thistype.DEFAULT = thistype.Create("DefaultEAXON")
    	set thistype.DOODAD = thistype.Create("DoodadsEAX")
    	set thistype.HERO_ACKS = thistype.Create("HeroAcksEAX")
    	set thistype.KOTO_DRUMS = thistype.Create("KotoDrumsEAX")
    	set thistype.MISSILE = thistype.Create("MissilesEAX")
    	set thistype.SPELL = thistype.Create("SpellsEAX")
    endmethod
endstruct

//! runtextmacro BaseStruct("SoundType", "SOUND_TYPE")
	//! runtextmacro CreateAnyState("filePath", "FilePath", "string")
	
	//! runtextmacro CreateAnyState("channel", "Channel", "SoundChannel")
	//! runtextmacro CreateAnyState("eax", "Eax", "SoundEax")
	//! runtextmacro CreateAnyState("pitch", "Pitch", "real")
	//! runtextmacro CreateAnyState("pitchVariance", "PitchVariance", "real")
	//! runtextmacro CreateAnyState("priority", "Priority", "integer")
	//! runtextmacro CreateAnyState("volume", "Volume", "real")
	
	//! runtextmacro CreateAnyState("fadeIn", "FadeIn", "real")
	//! runtextmacro CreateAnyState("fadeOut", "FadeOut", "real")
	//! runtextmacro CreateAnyFlagState("looping", "Looping")
	//! runtextmacro CreateAnyFlagState("stopping", "Stopping")
	
	//! runtextmacro CreateAnyFlagState("is3d", "3D")
	//! runtextmacro CreateAnyState("minDist", "MinDist", "real")
	//! runtextmacro CreateAnyState("maxDist", "MaxDist", "real")
	//! runtextmacro CreateAnyState("cutoffDist", "CutoffDist", "real")
	
	//! runtextmacro CreateAnyState("insideAngle", "InsideAngle", "real")
	//! runtextmacro CreateAnyState("outsideAngle", "OutsideAngle", "real")
	//! runtextmacro CreateAnyState("outsideVolume", "OutsideVolume", "real")	
	//! runtextmacro CreateAnyState("orientationX", "OrientationX", "real")
	//! runtextmacro CreateAnyState("orientationY", "OrientationY", "real")
	//! runtextmacro CreateAnyState("orientationZ", "OrientationZ", "real")

    //! runtextmacro GetKeyArray("INIT_KEY_ARRAY")

    static method AddInit takes code c, string name returns nothing
        call Trigger.AddObjectInit(INIT_KEY_ARRAY, c, name)
    endmethod

	static method Create takes nothing returns thistype
		local thistype this = thistype.allocate()
		
		call this.SetFilePath(null)
		
		call this.SetChannel(SoundChannel.GENERAL)
		call this.SetEax(SoundEax.DEFAULT)
		call this.SetPitch(1.)
		call this.SetPitchVariance(1.)
		call this.SetPriority(1)
		call this.SetVolume(127.)
		
		call this.SetFadeIn(10.)
		call this.SetFadeOut(10.)
		
		call this.SetLooping(false)
		call this.SetStopping(false)
		
		call this.Set3D(false)
		call this.SetMinDist(0.)
		call this.SetMaxDist(0.)
		call this.SetCutoffDist(0.)
		
		call this.SetInsideAngle(0.)
		call this.SetOutsideAngle(0.)
		call this.SetOutsideVolume(0.)
		call this.SetOrientationX(0.)
		call this.SetOrientationY(0.)
		call this.SetOrientationZ(0.)
		
		return this
	endmethod
endstruct

//! runtextmacro BaseStruct("Sound", "SOUND")
    static thistype ERROR

    sound self

    Timer stopEx_delayTimer
    boolean stopEx_destroyAfter
    boolean stopEx_fadeOut

	//! runtextmacro CreateAnyState("filePath", "FilePath", "string")
	
	//! runtextmacro CreateAnyState("channel", "Channel2", "SoundChannel")
	//! runtextmacro CreateAnyState("eax", "Eax", "SoundEax")
	//! runtextmacro CreateAnyState("pitch", "Pitch", "real")
	//! runtextmacro CreateAnyState("pitchVariance", "PitchVariance", "real")
	//! runtextmacro CreateAnyState("priority", "Priority", "integer")
	//! runtextmacro CreateAnyState("volume", "Volume", "real")
	
	//! runtextmacro CreateAnyState("fadeIn", "FadeIn", "real")
	//! runtextmacro CreateAnyState("fadeOut", "FadeOut", "real")
	//! runtextmacro CreateAnyFlagState("looping", "Looping")
	//! runtextmacro CreateAnyFlagState("stopping", "Stopping")
	
	//! runtextmacro CreateAnyFlagState("is3d", "3D")
	//! runtextmacro CreateAnyState("minDist", "MinDist", "real")
	//! runtextmacro CreateAnyState("maxDist", "MaxDist", "real")
	//! runtextmacro CreateAnyState("cutoffDist", "CutoffDist", "real")
	
	//! runtextmacro CreateAnyState("insideAngle", "InsideAngle", "real")
	//! runtextmacro CreateAnyState("outsideAngle", "OutsideAngle", "real")
	//! runtextmacro CreateAnyState("outsideVolume", "OutsideVolume", "real")	
	//! runtextmacro CreateAnyState("orientationX", "OrientationX", "real")
	//! runtextmacro CreateAnyState("orientationY", "OrientationY", "real")
	//! runtextmacro CreateAnyState("orientationZ", "OrientationZ", "real")

	//! runtextmacro CreateAnyStateDefault("targetUnit", "TargetUnit", "Unit", NULL)
	//! runtextmacro CreateAnyStateDefault("x", "X", "real", 0)
	//! runtextmacro CreateAnyStateDefault("y", "Y", "real", 0)
	//! runtextmacro CreateAnyStateDefault("z", "Z", "real", 0)

	method GetXEx returns real
		if (this.GetTargetUnit() != NULL) then
			return this.GetTargetUnit().Position.X.Get()
		endif

		return this.GetX()
	endmethod

	method GetYEx returns real
		if (this.GetTargetUnit() != NULL) then
			return this.GetTargetUnit().Position.Y.Get()
		endif

		return this.GetY()
	endmethod

	method GetZEx returns real
		if (this.GetTargetUnit() != NULL) then
			return this.GetTargetUnit().Position.Z.Get()
		endif

		return this.GetZ()
	endmethod

    static method StopEx_Delay takes nothing returns nothing
        local Timer delayTimer = Timer.GetExpired()

        local thistype this = delayTimer.GetData()

        set this.stopEx_delayTimer = NULL

        call StopSound(this.self, this.stopEx_destroyAfter, this.stopEx_fadeOut)

        call this.subRef()
    endmethod

    method StopEx takes boolean destroyAfter, boolean fadeOut returns nothing
        local Timer delayTimer = this.stopEx_delayTimer

        if (delayTimer == NULL) then
            set delayTimer = Timer.Create()

            call delayTimer.SetData(this)

            call this.addRef()
        endif

        set this.stopEx_delayTimer = delayTimer
        set this.stopEx_destroyAfter = destroyAfter
        set this.stopEx_fadeOut = fadeOut

        call delayTimer.Start(0.07, false, function thistype.StopEx_Delay)
    endmethod

    destroyMethod Destroy takes boolean waitForPlayed
        local sound self = this.self

        if waitForPlayed then
            call this.StopEx(true, true)
        else
            if this.IsLooping() then
                call this.StopEx(true, waitForPlayed)
            else
                call KillSoundWhenDone(self)
            endif
        endif

        set self = null
    endmethod

    method LimitToPlayer takes User whichPlayer returns nothing
        if whichPlayer.IsLocal() then
            call SetSoundVolume(this.self, 0)
        endif
    endmethod

    method Play takes nothing returns nothing
        call SetSoundVolume(this.self, Real.ToInt(this.volume * this.GetChannel2().GetVolume() * SoundChannel.OVERALL_VOLUME * 127.))
        call StartSound(this.self)

		if this.Is3D() then
			local TextTag t = TEXT_TAG.CreateRising.Create(this.GetFilePath(), 0.02 * this.GetVolume(), this.GetXEx(), this.GetYEx(), this.GetZEx(), 300, 0, 2, TextTag.GetFreeId())

			call t.Color.SetRandomRGB()
			call t.Position.SetCentered()
		endif
    endmethod

    method PlayForPlayer takes User whichPlayer returns nothing
        if whichPlayer.IsLocal() then
            call this.Play()
        endif
    endmethod

    method SetChannel takes SoundChannel val returns nothing
    	call this.SetChannel2(val)

    	if (this.self != null) then
        	call SetSoundChannel(this.self, val)
        endif
    endmethod

    method SetPosition takes real x, real y, real z returns nothing
    	call this.SetTargetUnit(NULL)
    	call this.SetX(x)
    	call this.SetY(y)
    	call this.SetZ(z)

        call SetSoundPosition(this.self, x, y, z)
    endmethod

    method SetPositionAndPlay takes real x, real y, real z returns nothing
        call this.SetPosition(x, y, z)

        call this.Play()
    endmethod

	method AttachToUnitAndPlay takes Unit target returns nothing
		call this.SetTargetUnit(target)
    	call this.SetX(target.Position.X.Get())
    	call this.SetY(target.Position.Y.Get())
    	call this.SetZ(target.Position.Z.Get())

		call AttachSoundToUnit(this.self, target.self)
		
		call this.Play()
	endmethod

    method Stop takes boolean fadeOut returns nothing
        call this.StopEx(false, fadeOut)
    endmethod

    static method Create takes string filePath, boolean looping, boolean is3d, boolean stop, real fadeIn, real fadeOut, SoundEax eax returns thistype
        local thistype this = thistype.allocate()
        
        set this.stopEx_delayTimer = NULL
		
		call this.SetFilePath(filePath)
		
		call this.SetChannel(SoundChannel.GENERAL)
		call this.SetEax(eax)
		call this.SetVolume(1.)

		call this.SetFadeIn(fadeIn)
		call this.SetFadeOut(fadeOut)
        call this.SetLooping(looping)
        call this.SetStopping(stop)

		call this.Set3D(is3d)        

		call this.Recreate()

        return this
    endmethod

	method Recreate takes nothing returns nothing
		local string eax = this.GetEax().GetSelf()
		
		if (eax == null) then
			set eax = ""
		endif
//		call DebugEx("create sound with "+this.GetFilePath()+";"+B2S(this.IsLooping())+B2S(this.Is3D())+";"+B2S(this.IsStopping())+";"+R2S(this.GetFadeIn())+";"+R2S(this.GetFadeOut())+eax)
		set this.self = CreateSound(this.GetFilePath(), this.IsLooping(), this.Is3D(), this.IsStopping(), Real.ToInt(this.GetFadeIn()), Real.ToInt(this.GetFadeOut()), eax)
	endmethod

	static method CreateFromType takes SoundType whichType returns thistype
        local thistype this = thistype.allocate()

		set this.stopEx_delayTimer = NULL

		call this.SetFilePath(whichType.GetFilePath())

        call this.SetChannel(whichType.GetChannel())
        call this.SetEax(whichType.GetEax())
        call this.SetPitch(whichType.GetPitch())
        call this.SetPitchVariance(whichType.GetPitchVariance())
        call this.SetPriority(whichType.GetPriority())
        call this.SetVolume(whichType.GetVolume())
        
        call this.SetFadeIn(whichType.GetFadeIn())
        call this.SetFadeOut(whichType.GetFadeOut())
        call this.SetLooping(whichType.IsLooping())
        call this.SetStopping(whichType.IsStopping())
        
        call this.Set3D(whichType.Is3D())
        call this.SetMinDist(whichType.GetMinDist())
        call this.SetMaxDist(whichType.GetMaxDist())
        call this.SetCutoffDist(whichType.GetCutoffDist())
        
        call this.SetInsideAngle(whichType.GetInsideAngle())
		call this.SetOutsideAngle(whichType.GetOutsideAngle())
		call this.SetOutsideVolume(whichType.GetOutsideVolume())
		call this.SetOrientationX(whichType.GetOrientationX())
		call this.SetOrientationY(whichType.GetOrientationY())
		call this.SetOrientationZ(whichType.GetOrientationZ())

		call this.Recreate()

        return this
	endmethod

    initMethod Init of Header_2
    	call SoundEax.Init()
        call SoundChannel.Init()

        set thistype.ERROR = thistype.Create("Sound\\Interface\\Error.wav", false, false, false, 10, 10, NULL)
        call thistype.ERROR.SetChannel(SoundChannel.UI)

        call Music.Init()
    endmethod
endstruct

//! runtextmacro BaseStruct("UnitSound", "UNIT_SOUND")
	Sound thisSound

	method Destroy takes nothing returns nothing
		call this.thisSound.Destroy(true)

		call this.deallocate()
	endmethod

	static method Create takes Unit whichUnit, SoundType whichSoundType returns thistype
		local thistype this = thistype.allocate()

		local Sound thisSound = Sound.CreateFromType(whichSoundType)

		set this.thisSound = thisSound

		call thisSound.AttachToUnitAndPlay(whichUnit)

		return this
	endmethod
endstruct