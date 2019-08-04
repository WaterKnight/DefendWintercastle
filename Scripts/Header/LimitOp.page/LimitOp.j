//! runtextmacro StaticStruct("LimitOp")
    static method GetComplement takes limitop self returns limitop
        if (self == LESS_THAN) then
            return GREATER_THAN_OR_EQUAL
        endif
        if (self == LESS_THAN_OR_EQUAL) then
            return GREATER_THAN
        endif
        if (self == EQUAL) then
            return NOT_EQUAL
        endif
        if (self == NOT_EQUAL) then
            return EQUAL
        endif
        if (self == GREATER_THAN) then
            return LESS_THAN_OR_EQUAL
        endif
        if (self == GREATER_THAN_OR_EQUAL) then
            return LESS_THAN
        endif

        return null
    endmethod
endstruct