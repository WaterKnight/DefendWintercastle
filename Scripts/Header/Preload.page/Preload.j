function InitObject takes integer id returns nothing
    call GetObjectName(id)
endfunction

struct InitAbilityStruct
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static unit PRELOADER_UNIT = null
endstruct

function InitAbility takes integer id, boolean extended returns nothing
    if Memory.IntegerKeys.GetBoolean(InitAbilityStruct.KEY_ARRAY, id) then
        call DebugEx("spell " + GetObjectName(id) + "(" + Integer.ToAscii(id) + ") already preloaded")

        return
    endif

    call Memory.IntegerKeys.SetBoolean(InitAbilityStruct.KEY_ARRAY, id, true)

    if (id == 0) then
        return
    endif

    call InitObject(id)

    if not extended then
        return
    endif

    if (InitAbilityStruct.PRELOADER_UNIT == null) then
        set InitAbilityStruct.PRELOADER_UNIT = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), DummyUnit.PRELOADER_ID, 0, 0, 0)
    endif

    if UnitAddAbility(InitAbilityStruct.PRELOADER_UNIT, id) then
        call UnitRemoveAbility(InitAbilityStruct.PRELOADER_UNIT, id)
    endif
endfunction

function InitBuff takes integer id returns nothing
    call InitObject(id)
endfunction