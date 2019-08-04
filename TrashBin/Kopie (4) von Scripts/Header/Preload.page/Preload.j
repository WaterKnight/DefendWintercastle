function InitObject takes integer id returns nothing
    call GetObjectName(id)
endfunction

struct InitAbilityStruct
    //! runtextmacro GetKeyArray("KEY_ARRAY")
endstruct

function InitAbility takes integer id returns nothing
    call Memory.IntegerKeys.Table.AddInteger(InitAbilityStruct.KEY_ARRAY, InitAbilityStruct.KEY_ARRAY, id)

    if (id == 0) then
        return
    endif

    call InitObject(id)

/*    if (UnitAddAbility(DummyUnit.WORLD_CASTER.Abilities.AddBySelf(id)) then
        call DummyUnit.WORLD_CASTER.Abilities.RemoveBySelf(id)
    endif*/
endfunction

function InitBuff takes integer id returns nothing
    call InitObject(id)
endfunction