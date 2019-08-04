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

function B2I takes boolean b returns integer
    if b then
        return 1
    endif

    return 0
endfunction

function B2S takes boolean b returns string
    if b then
        return "true"
    endif

    return "false"
endfunction

//! textmacro Folder takes name
    scope Folder$name$
//! endtextmacro

//! textmacro LinkToNamedStruct takes folder, name
    Folder$folder$_$name$ $name$ = this
//! endtextmacro

//! textmacro LinkToStaticStruct takes folder, name
    static Folder$folder$_Struct$name$ $name$ = NULL
//! endtextmacro

globals
    trigger InitLinks_DUMMY_TRIGGER = CreateTrigger()
    integer InitLinks_ITERATION
    integer InitLinks_THREAD_BREAK_COUNTER
    constant integer InitLinks_THREAD_BREAK_LIMIT = 500
endglobals

module InitStructLinks
    private static method InitStructLinks2 takes nothing returns nothing
        local integer iteration = InitLinks_ITERATION

        loop
            call thistype(iteration).dealloc()

            set iteration = iteration - 1

            exitwhen (iteration < STRUCT_MIN)

            set InitLinks_THREAD_BREAK_COUNTER = InitLinks_THREAD_BREAK_COUNTER + 1

            exitwhen (InitLinks_THREAD_BREAK_COUNTER > InitLinks_THREAD_BREAK_LIMIT)
        endloop

        if (iteration > STRUCT_EMPTY) then
            set InitLinks_ITERATION = iteration
            set InitLinks_THREAD_BREAK_COUNTER = 0

            call TriggerEvaluate(InitLinks_DUMMY_TRIGGER)
        else
            static if (DEBUG) then
                set InitLinks_ITERATION = STRUCT_EMPTY
            endif
        endif
    endmethod

    private static method InitStructLinks takes nothing returns boolean
        local integer iteration = InitLinks_ITERATION

        loop
            call thistype.alloc()

            set iteration = iteration - 1

            exitwhen (iteration < STRUCT_MIN)

            set InitLinks_THREAD_BREAK_COUNTER = InitLinks_THREAD_BREAK_COUNTER + 1

            exitwhen (InitLinks_THREAD_BREAK_COUNTER > InitLinks_THREAD_BREAK_LIMIT)
        endloop

        if (iteration > STRUCT_EMPTY) then
            set InitLinks_ITERATION = iteration
            set InitLinks_THREAD_BREAK_COUNTER = 0

            call TriggerEvaluate(InitLinks_DUMMY_TRIGGER)
        else
            static if (DEBUG) then
                set InitLinks_ITERATION = STRUCT_EMPTY
            endif
        endif

        return false
    endmethod

    private static method onInit takes nothing returns nothing
        local boolexpr condition = Condition(function thistype.InitStructLinks)

        set InitLinks_ITERATION = STRUCT_MAX
        set InitLinks_THREAD_BREAK_COUNTER = 0

        call TriggerClearConditions(InitLinks_DUMMY_TRIGGER)

        call TriggerAddCondition(InitLinks_DUMMY_TRIGGER, condition)

        call TriggerEvaluate(InitLinks_DUMMY_TRIGGER)

        call DestroyBoolExpr(condition)

        set condition = null

        static if (DEBUG) then
            if (InitLinks_ITERATION > STRUCT_EMPTY) then
                call Game.DebugMsg("InitLinks: thread break in " + InitStructLinks.name + " with " + I2S(InitLinks_ITERATION))
            endif
        endif

        /*set condition = Condition(function thistype.InitStructLinks2)
        set InitLinks_ITERATION = STRUCT_MAX
        set InitLinks_THREAD_BREAK_COUNTER = 0

        call TriggerClearConditions(InitLinks_DUMMY_TRIGGER)

        call TriggerAddCondition(InitLinks_DUMMY_TRIGGER, condition)

        call TriggerEvaluate(InitLinks_DUMMY_TRIGGER)

        call DestroyBoolExpr(condition)

        set condition = null*/
    endmethod
endmodule

//! textmacro LinkToStruct takes folder, struct
    Folder$folder$_Struct$struct$ $struct$ = this

    implement InitStructLinks
//! endtextmacro

module Allocation
    private static thistype NEXT = NULL
    private static integer array QUEUED
    private static integer QUEUED_COUNT = 0

    /*method deallocate takes nothing returns nothing
        static if (DEBUG) then
            if (this == NULL) then
                call Game.DebugMsg(thistype.deallocate.name + ": try to deallocate NULL instance")

                return
            endif

            if (thistype.QUEUED[this] != STRUCT_INVALID) then
                call Game.DebugMsg(thistype.deallocate.name + ": try to double-deallocate instance " + I2S(this))

                return
            endif
        endif

        set thistype.QUEUED[this] = thistype.NEXT

        set thistype.QUEUED_COUNT = this
    endmethod

    static method allocate takes nothing returns thistype
        local thistype this = thistype.NEXT

        if (this == NULL) then
            set thistype.QUEUED_COUNT = thistype.QUEUED_COUNT + 1

            set this = thistype.QUEUED_COUNT
        else
            set thistype.NEXT = thistype.QUEUED[this]
        endif

        static if (DEBUG) then
            if (integer(this) > STRUCT_MAX) then
                call Game.DebugMsg(thistype.allocate.name + ": unable to allocate instance")

                return NULL
            endif
        endif

        set thistype.QUEUED[this] = STRUCT_INVALID

        return this
    endmethod*/

    private static integer COUNT = STRUCT_EMPTY

    private thistype next

    method deallocate takes nothing returns nothing
        static if (DEBUG) then
            if (this.next != STRUCT_INVALID) then
                call Game.DebugMsg(thistype.allocate.name + ": unable to deallocate instance " + I2S(this))

                return
            endif
        endif

        set this.next = thistype(NULL).next

        set thistype(NULL).next = this
    endmethod

    static method allocate takes nothing returns thistype
        local thistype this

        static if (DEBUG) then
            if (thistype.QUEUED_COUNT == STRUCT_MAX) then
                call Game.DebugMsg(thistype.allocate.name + ": unable to allocate instance")

                return NULL
            endif
        endif

        if (thistype(NULL).next == NULL) then
            set thistype.COUNT = thistype.COUNT + 1

            set this = thistype.COUNT
        else
            set this = thistype(NULL).next

            set thistype(NULL).next = thistype(NULL).next.next
        endif

        static if (DEBUG) then
            set this.next = STRUCT_INVALID
        endif

        return this
    endmethod
endmodule

module List
    static thistype array ALL
    static integer ALL_COUNT = ARRAY_EMPTY

    integer index

    method GetIndex takes nothing returns integer
        return this.index
    endmethod

    method IsInList takes nothing returns boolean
        local integer iteration = thistype.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            if (thistype.ALL[iteration] == this) then
                return true
            endif

            set iteration = iteration - 1
        endloop

        return false
    endmethod

    static method RandomFromList takes integer lowBound, integer highBound returns thistype
        return thistype.ALL[Math.RandomI(lowBound, highBound)]
    endmethod

    method RemoveFromList takes nothing returns boolean
        set thistype.ALL[thistype.ALL_COUNT].index = this.index
        set thistype.ALL[this.index] = thistype.ALL[thistype.ALL_COUNT]

        set thistype.ALL_COUNT = thistype.ALL_COUNT - 1

        return (thistype.ALL_COUNT == ARRAY_EMPTY)
    endmethod

    method RemoveFromListSafe takes nothing returns nothing
        if (this.IsInList()) then
            call this.RemoveFromList()
        endif
    endmethod

    method RemoveFromListSorted takes nothing returns boolean
        local integer iteration = this.index

        loop
            exitwhen (iteration == thistype.ALL_COUNT)

            set thistype.ALL[iteration] = thistype.ALL[iteration + 1]

            set thistype.ALL[iteration].index = iteration

            set iteration = iteration + 1
        endloop

        set thistype.ALL_COUNT = thistype.ALL_COUNT - 1

        return (thistype.ALL_COUNT == ARRAY_EMPTY)
    endmethod

    method AddToList takes nothing returns boolean
        set thistype.ALL_COUNT = thistype.ALL_COUNT + 1

        set thistype.ALL[thistype.ALL_COUNT] = this
        set this.index = thistype.ALL_COUNT

        return (thistype.ALL_COUNT == ARRAY_MIN)
    endmethod
endmodule

//! textmacro CreateList takes name
    static thistype array $name$_ALL
    static integer $name$_ALL_COUNT = ARRAY_EMPTY

    integer $name$_index

    static method $name$_GetIndex takes thistype this returns integer
        return this.$name$_index
    endmethod

    static method $name$_Contains takes thistype this returns boolean
        return (thistype.$name$_GetIndex(this) > ARRAY_MIN)
    endmethod

    static method $name$_Random takes integer lowBound, integer highBound returns thistype
        return thistype.$name$_ALL[Math.RandomI(lowBound, highBound)]
    endmethod

    static method $name$_RandomAll takes nothing returns thistype
        return thistype.$name$_Random(ARRAY_MIN, thistype.$name$_ALL_COUNT)
    endmethod

    static method $name$_Remove takes thistype this returns boolean
        if (thistype.$name$_Contains(this) == false) then
            return false
        endif

        set thistype.$name$_ALL[thistype.$name$_ALL_COUNT].$name$_index = this.$name$_index
        set thistype.$name$_ALL[this.$name$_index - 1] = thistype.$name$_ALL[thistype.$name$_ALL_COUNT]

        set thistype.$name$_ALL_COUNT = thistype.$name$_ALL_COUNT - 1
        set this.$name$_index = ARRAY_MIN

        return (thistype.$name$_ALL_COUNT == ARRAY_EMPTY)
    endmethod

    static method $name$_Add takes thistype this returns boolean
        if (thistype.$name$_Contains(this)) then
            return false
        endif

        set thistype.$name$_ALL_COUNT = thistype.$name$_ALL_COUNT + 1

        set thistype.$name$_ALL[thistype.$name$_ALL_COUNT] = this
        set this.$name$_index = thistype.$name$_ALL_COUNT + 1

        return (thistype.$name$_ALL_COUNT == ARRAY_MIN)
    endmethod
//! endtextmacro

//! textmacro CreateForEachList takes name, parent
    static thistype array $name$_ALL
    static integer $name$_ALL_COUNT = ARRAY_EMPTY

    static method $name$_FetchFirst takes nothing returns thistype
        local thistype result

        if (thistype.$name$_ALL_COUNT < ARRAY_MIN) then
            return NULL
        endif

        set result = thistype.$name$_ALL[ARRAY_MIN]

        set thistype.$name$_ALL[ARRAY_MIN] = thistype.$name$_ALL[thistype.$name$_ALL_COUNT]

        set thistype.$name$_ALL_COUNT = thistype.$name$_ALL_COUNT - 1

        return result
    endmethod

    static method $name$_Set takes nothing returns nothing
        local integer iteration = thistype.$parent$_ALL_COUNT

        loop
            set thistype.$name$_ALL[iteration] = thistype.$parent$_ALL[iteration]

            set iteration = iteration - 1
            exitwhen (iteration < ARRAY_MIN)
        endloop
        set thistype.$name$_ALL_COUNT = thistype.$parent$_ALL_COUNT
    endmethod
//! endtextmacro

module Name
    static method Name takes nothing returns nothing
    endmethod

    static constant string NAME = thistype.Name.name
endmodule

//! textmacro Struct takes name
    public struct Struct$name$
        implement Allocation
        implement List
        implement Name
//! endtextmacro

//! textmacro NamedStruct takes name
    public struct $name$
        implement Allocation
        implement List
        implement Name
//! endtextmacro

//! textmacro BaseStruct takes name, base
    globals
        $name$ $base$ = STRUCT_BASE
    endglobals

    struct $name$
        implement Allocation
        implement List
        implement Name
//! endtextmacro

//! textmacro StaticStruct takes name
    struct $name$
//! endtextmacro

//! textmacro CreateSimpleAddState_NotAdd takes type, defaultValue
    $type$ value

    method Get takes nothing returns $type$
        return this.value
    endmethod

    method Set takes $type$ value returns nothing
        set this.value = value
    endmethod

    method Event_Create takes nothing returns nothing
        call this.Set($defaultValue$)
    endmethod

    method Update takes nothing returns nothing
        call this.Set(this.Get())
    endmethod
//! endtextmacro

//! textmacro CreateSimpleAddState_NotStart takes type
    $type$ value

    method Get takes nothing returns $type$
        return this.value
    endmethod

    method Set takes $type$ value returns nothing
        set this.value = value
    endmethod

    method Add takes $type$ value returns nothing
        call this.Set(this.Get() + value)
    endmethod

    method Subtract takes $type$ value returns nothing
        call this.Set(this.Get() - value)
    endmethod

    method Update takes nothing returns nothing
        call this.Set(this.Get())
    endmethod
//! endtextmacro

//! textmacro CreateSimpleAddState_OnlyGet takes type
    $type$ value

    method Get takes nothing returns $type$
        return this.value
    endmethod
//! endtextmacro

//! textmacro CreateSimpleAddState_OnlyStart takes defaultValue
    method Event_Create takes nothing returns nothing
        set this.value = $defaultValue$
    endmethod
//! endtextmacro

//! textmacro CreateSimpleAddState_OnlyAdd takes type, defaultValue
    method Add takes $type$ value returns nothing
        call this.Set(this.Get() + value)
    endmethod

    method Event_Create takes nothing returns nothing
        call this.Set($defaultValue$)
    endmethod

    method Subtract takes $type$ value returns nothing
        call this.Set(this.Get() - value)
    endmethod

    method Update takes nothing returns nothing
        call this.Set(this.Get())
    endmethod
//! endtextmacro

//! textmacro CreateSimpleAddState_OnlyAdd_NotStart takes type
    method Add takes $type$ value returns nothing
        call this.Set(this.Get() + value)
    endmethod

    method Subtract takes $type$ value returns nothing
        call this.Set(this.Get() - value)
    endmethod

    method Update takes nothing returns nothing
        call this.Set(this.Get())
    endmethod
//! endtextmacro

//! textmacro CreateSimpleAddState_OnlyAdd_UsePreset takes type, presetValue, defaultValue
    method Add takes $type$ value returns nothing
        call this.Set(this.Get() + value)
    endmethod

    method Event_Create takes nothing returns nothing
        set this.value = $presetValue$
        call this.Set($defaultValue$)
    endmethod

    method Subtract takes $type$ value returns nothing
        call this.Set(this.Get() - value)
    endmethod

    method Update takes nothing returns nothing
        call this.Set(this.Get())
    endmethod
//! endtextmacro

//! textmacro CreateSimpleAddState_OnlyStart_UsePreset takes presetValue, defaultValue
    method Event_Create takes nothing returns nothing
        set this.value = $presetValue$
        call this.Set($defaultValue$)
    endmethod
//! endtextmacro

//! textmacro CreateSimpleAddState takes type, defaultValue
    $type$ value

    method Get takes nothing returns $type$
        return this.value
    endmethod

    method Set takes $type$ value returns nothing
        set this.value = value
    endmethod

    method Add takes $type$ value returns nothing
        call this.Set(this.Get() + value)
    endmethod

    method Event_Create takes nothing returns nothing
        call this.Set($defaultValue$)
    endmethod

    method Subtract takes $type$ value returns nothing
        call this.Set(this.Get() - value)
    endmethod

    method Update takes nothing returns nothing
        call this.Set(this.Get())
    endmethod
//! endtextmacro

//! textmacro CreateSimpleFlagState_NotStart
    boolean flag

    method Is takes nothing returns boolean
        return this.flag
    endmethod

    method Set takes boolean flag returns nothing
        set this.flag = flag
    endmethod
//! endtextmacro

//! textmacro CreateAnyFlagState takes varName, methodName
    boolean $varName$

    method Is$methodName$ takes nothing returns boolean
        return this.$varName$
    endmethod

    method Set$methodName$ takes boolean value returns nothing
        set this.$varName$ = value
    endmethod
//! endtextmacro

//! textmacro CreateAnyFlagStateDefault takes varName, methodName, default
    boolean $varName$ = $default$

    method Is$methodName$ takes nothing returns boolean
        return this.$varName$
    endmethod

    method Set$methodName$ takes boolean value returns nothing
        set this.$varName$ = value
    endmethod
//! endtextmacro

//! textmacro CreateAnyState takes varName, methodName, type
    $type$ $varName$

    method Get$methodName$ takes nothing returns $type$
        return this.$varName$
    endmethod

    method Set$methodName$ takes $type$ value returns nothing
        set this.$varName$ = value
    endmethod
//! endtextmacro

//! textmacro CreateAnyStateDefault takes varName, methodName, type, default
    $type$ $varName$ = $default$

    method Get$methodName$ takes nothing returns $type$
        return this.$varName$
    endmethod

    method Set$methodName$ takes $type$ value returns nothing
        set this.$varName$ = value
    endmethod
//! endtextmacro

//! textmacro CreateAnyStaticState takes varName, methodName, type
    static $type$ $varName$

    static method Get$methodName$ takes nothing returns $type$
        return thistype.$varName$
    endmethod

    static method Set$methodName$ takes $type$ value returns nothing
        set thistype.$varName$ = value
    endmethod
//! endtextmacro

//! textmacro CreateAnyStaticFlagState takes varName, methodName
    static boolean $varName$

    static method Is$methodName$ takes nothing returns boolean
        return thistype.$varName$
    endmethod

    static method Set$methodName$ takes boolean value returns nothing
        set thistype.$varName$ = value
    endmethod
//! endtextmacro

//! textmacro CreateAnyStaticStateDefault takes varName, methodName, type, default
    static $type$ $varName$ = $default$

    static method Get$methodName$ takes nothing returns $type$
        return thistype.$varName$
    endmethod

    static method Set$methodName$ takes $type$ value returns nothing
        set thistype.$varName$ = value
    endmethod
//! endtextmacro

//! textmacro CreateAnyStaticFlagStateDefault takes varName, methodName, default
    static boolean $varName$ = $default$

    static method Is$methodName$ takes nothing returns boolean
        return thistype.$varName$
    endmethod

    static method Set$methodName$ takes boolean value returns nothing
        set thistype.$varName$ = value
    endmethod
//! endtextmacro

//! textmacro CreateSimpleFlagState takes defaultValue
    boolean flag

    method Is takes nothing returns boolean
        return this.flag
    endmethod

    method Set takes boolean flag returns nothing
        set this.flag = flag
    endmethod

    method Event_Create takes nothing returns nothing
        call this.Set($defaultValue$)
    endmethod
//! endtextmacro

//! textmacro CreateSimpleFlagCountState takes defaultValue
    integer flag

    method Get takes nothing returns integer
        return this.flag
    endmethod

    method Is takes nothing returns boolean
        return (this.flag > 0)
    endmethod

    method Set takes integer flag returns nothing
        set this.flag = flag
    endmethod

    method Subtract takes nothing returns nothing
        call this.Set(this.Get() - 1)
    endmethod

    method SubtractValue takes integer value returns nothing
        call this.Set(this.Get() - value)
    endmethod

    method Add takes nothing returns nothing
        call this.Set(this.Get() + 1)
    endmethod

    method AddValue takes integer value returns nothing
        call this.Set(this.Get() + value)
    endmethod

    method Event_Create takes nothing returns nothing
        call this.Set($defaultValue$)
    endmethod
//! endtextmacro

//! textmacro CreateSimpleFlagCountState_NotStart
    integer flag

    method Get takes nothing returns integer
        return this.flag
    endmethod

    method Is takes nothing returns boolean
        return (this.flag > 0)
    endmethod

    method Set takes integer flag returns nothing
        set this.flag = flag
    endmethod

    method Subtract takes nothing returns nothing
        call this.Set(this.Get() - 1)
    endmethod

    method Add takes nothing returns nothing
        call this.Set(this.Get() + 1)
    endmethod
//! endtextmacro

//scope Base

globals
    boolean TEMP_BOOLEAN
    boolean TEMP_BOOLEAN2
    boolean TEMP_BOOLEAN3
    boolean TEMP_BOOLEAN4
    integer TEMP_INTEGER
    integer TEMP_INTEGER2
    integer TEMP_INTEGER3
    integer TEMP_INTEGER4
    real TEMP_REAL
    real TEMP_REAL2
    real TEMP_REAL3
    real TEMP_REAL4
    real TEMP_REAL5
    real TEMP_REAL6
endglobals

globals
    boolean exit
endglobals

function Exit takes nothing returns boolean
    return exit
endfunction

function booleanToString takes boolean b returns string
    if (b) then
        return "true"
    endif

    return "false"
endfunction

function integerToString takes integer a returns string
    return I2S(a)
endfunction

function realToString takes real a returns string
    return R2S(a)
endfunction

function stringToString takes string s returns string
    return s
endfunction

function Print takes string s returns nothing
    call DisplayTextToPlayer(GetLocalPlayer(), 0., 0., s)
endfunction

function RenderGraphics takes nothing returns nothing
    //call PauseGame(true)

    //call Trigger.Sleep(0.)

    //call PauseGame(false)
endfunction

/*//! externalblock extension=lua ObjectMerger $FILENAME$
    //! i setobjecttype("doodads")

    //! i modifyobject("D02G")

    //! i makechange(current, "dfil", "Doodads\\Grass\\Grass")
//! endexternalblock*/

globals
    boolean DEBUG_EX_ON = true
endglobals

function DebugEx takes string s returns nothing
    call BJDebugMsg(s)

//call PreloadGenClear()

//call PreloadGenStart()

    call Preload(s)

    call PreloadGenEnd("D:\\DWC_Errors.txt")
endfunction

struct ObjThread
    implement Allocation
    implement List

    string name

    method Destroy takes nothing returns nothing
        call this.deallocate()
//call DebugEx("destroy "+this.name)
        call this.RemoveFromList()
    endmethod

    static method PrintErrors takes nothing returns nothing
        local integer i = thistype.ALL_COUNT

        loop
            exitwhen (i < ARRAY_MIN)

            call DebugEx("could not finish " + thistype.ALL[i].name)
set DEBUG_EX_ON = false
            call thistype.ALL[i].Destroy()
set DEBUG_EX_ON = true
            set i = i - 1
        endloop
    endmethod

    static method Create takes string name returns thistype
        local thistype this = thistype.allocate()

        set this.name = name

        call this.AddToList()

        return this
    endmethod
endstruct