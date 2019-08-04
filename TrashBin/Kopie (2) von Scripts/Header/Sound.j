//! runtextmacro BaseStruct("Music", "MUSIC")
    static thistype array PLAY_LIST
    static integer PLAY_LIST_COUNT = ARRAY_EMPTY

    integer playListIndex
    integer priority
    string self

    method Play takes nothing returns nothing
        local integer iteration
        local integer priority

        if (this.playListIndex != ARRAY_EMPTY) then
            return
        endif

        set priority = this.priority
        set iteration = thistype.PLAY_LIST_COUNT

        set thistype.PLAY_LIST_COUNT = iteration + 1

        loop
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
        local boolean wasCurrent

        if (iteration == ARRAY_EMPTY) then
            return
        endif

        set this.playListIndex = ARRAY_EMPTY
        set wasCurrent = (iteration == thistype.PLAY_LIST_COUNT)

        set thistype.PLAY_LIST_COUNT = thistype.PLAY_LIST_COUNT - 1

        loop
            exitwhen (iteration > thistype.PLAY_LIST_COUNT)

            set thistype.PLAY_LIST[iteration] = thistype.PLAY_LIST[iteration + 1]
            set thistype.PLAY_LIST[iteration + 1].playListIndex = iteration

            set iteration = iteration + 1
        endloop

        if (wasCurrent) then
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
    static constant string COMBAT = "CombatSoundsEAX"
    static constant string DEFAULT = "DefaultEAXON"
    static constant string DOODAD = "DoodadsEAX"
    static constant string EMPTY = ""
    static constant string HERO_ACKS = "HeroAcksEAX"
    static constant string KOTO_DRUMS = "KotoDrumsEAX"
    static constant string MISSILE = "MissilesEAX"
    static constant string SPELL = "SpellsEAX"
endstruct

//! runtextmacro BaseStruct("Sound", "SOUND")
    static thistype ERROR

    SoundChannel channel
    boolean looping
    sound self

    //! runtextmacro CreateAnyState("volume", "Volume", "real")

    method Destroy takes boolean waitForPlayed returns nothing
        local boolean looping = this.looping
        local sound self = this.self

        call this.deallocate()
        if (waitForPlayed) then
            call StopSound(self, true, true)
        else
            if (looping) then
                call StopSound(self, true, waitForPlayed)
            else
                call KillSoundWhenDone(self)
            endif
        endif

        set self = null
    endmethod

    method LimitToPlayer takes User whichPlayer returns nothing
        if (User.GetLocal() != whichPlayer) then
            call SetSoundVolume(this.self, 0)
        endif
    endmethod

    method Play takes nothing returns nothing
        call SetSoundVolume(this.self, Real.ToInt(this.volume * this.channel.GetVolume() * SoundChannel.OVERALL_VOLUME * 127.))
        call StartSound(this.self)
    endmethod

    method PlayForPlayer takes User whichPlayer returns nothing
        if (whichPlayer.IsLocal()) then
            call this.Play()
        endif
    endmethod

    method SetChannel takes SoundChannel value returns nothing
        call SetSoundChannel(this.self, value)
    endmethod

    method SetPosition takes real x, real y, real z returns nothing
        call SetSoundPosition(this.self, x, y, z)
    endmethod

    method SetPositionAndPlay takes real x, real y, real z returns nothing
        call this.SetPosition(x, y, z)

        call this.Play()
    endmethod

    method Stop takes boolean fadeOut returns nothing
        call StopSound(this.self, false, fadeOut)
    endmethod

    static method Create takes string fileName, boolean looping, boolean is3D, boolean stop, integer fadeIn, integer fadeOut, string eax returns thistype
        local thistype this = thistype.allocate()

        set this.channel = SoundChannel.GENERAL
        set this.looping = looping
        set this.self = CreateSound(fileName, looping, is3D, stop, fadeIn, fadeOut, eax)
        call this.SetVolume(1.)

        return this
    endmethod

    static method Init takes nothing returns nothing
        call SoundChannel.Init()

        set thistype.ERROR = thistype.Create("Sound\\Interface\\Error.wav", false, false, false, 10, 10, SoundEax.EMPTY)
        call thistype.ERROR.SetChannel(SoundChannel.UI)

        call Music.Init()
    endmethod
endstruct