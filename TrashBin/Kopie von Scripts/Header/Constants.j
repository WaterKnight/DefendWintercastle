//! runtextmacro Folder("Constants")
    globals
        constant integer ARRAY_MAX = 8191
        constant integer ARRAY_MIN = 0
        constant integer COMMAND_FIELD_SIZE = 12
        constant boolean DEBUG = true
        constant integer FRAMES_PER_SECOND_AMOUNT = 64
        constant integer FRAMES_PER_SECOND_HUMAN_EYE_AMOUNT = 32
        constant integer MAX_INVENTORY_SIZE = 6
        constant integer STRUCT_MAX = 8190
        constant integer STRUCT_MIN = 1

        constant integer ARRAY_EMPTY = ARRAY_MIN - 1
        constant real FRAME_UPDATE_TIME = 1. / FRAMES_PER_SECOND_AMOUNT
        constant integer STRUCT_BASE = STRUCT_MAX + 1
        constant integer STRUCT_EMPTY = STRUCT_MIN - 1

        constant integer NULL = STRUCT_EMPTY
        constant integer STRUCT_INVALID = STRUCT_EMPTY - 1
    endglobals
endscope

//! textmacro CreateTimeByFramesAmount takes var, framesAmount
    static constant real $var$ = FRAME_UPDATE_TIME * $framesAmount$
    static constant integer $var$_FRAMES_AMOUNT = $framesAmount$
//! endtextmacro

//! textmacro CreateHumanEyeTime takes var, factor
    static constant real $var$ = ($factor$ * 1.) / FRAMES_PER_SECOND_HUMAN_EYE_AMOUNT
    static constant integer $var$_FRAMES_AMOUNT = R2I(FRAMES_PER_SECOND_HUMAN_EYE_AMOUNT / ($factor$ * 1.))
//! endtextmacro

//! runtextmacro BaseStruct("Bug", "BUG")
    static method Print takes string s returns nothing
        call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60., s)
    endmethod
endstruct