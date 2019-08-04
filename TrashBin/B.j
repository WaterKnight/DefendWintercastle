struct A
    method RemoveFromSafeList takes nothing returns nothing
        local integer index = this.safeIndex

        call this.RemoveFromList()

        set thistype.SAFE_ALL[safeIndex] = NULL
        set thistype.SAFE_COUNT = thistype.SAFE_COUNT - 1
    endmethod

    method GetFromSafeList takes nothing returns thistype
        local integer iteration = thistype.SAFE_COUNT
        local thistype result

        loop
            exitwhen (thistype.SAFE_ALL[iteration] != NULL)
            exitwhen (thistype.SAFE_COUNT < ARRAY_MIN)
        endloop

        if (thistype.SAFE_COUNT < ARRAY_MIN) then
            return NULL
        endif

        set result = thistype.SAFE_ALL[iteration]

        set thistype.SAFE_ALL[iteration] = NULL

        set thistype.SAFE_COUNT = iteration - 1

        return result
    endmethod

    method SetSafeList takes nothing returns nothing
        local integer iteration = thistype.ALL_COUNT

        loop
            set thistype.SAFE_ALL[iteration] = thistype.ALL[iteration]

            set thistype.SAFE_ALL[iteration].safeIndex = iteration

            set iteration = iteration - 1
            exitwhen (iteration < ARRAY_MIN)
        endloop
        set thistype.SAFE_COUNT = thistype.ALL_COUNT
    endmethod

    method Ending takes nothing returns nothing
        call this.RemoveFromSafeList()
    endmethod

    static method Update takes nothing returns nothing
        local integer iteration = thistype.ALL_COUNT

        call thistype.SetSafeList()

        set iteration = thistype.SAFE_COUNT

        loop
            call thistype.SAFE_ALL[iteration].Ending()

            set iteration = iteration - 1
            exitwhen (iteration < ARRAY_MIN)
        endloop
    endmethod

    method Start takes nothing returns nothing
        call this.AddToList()
    endmethod
endstruct