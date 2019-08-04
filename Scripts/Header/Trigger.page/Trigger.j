//! runtextmacro Folder("Trigger")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("Trigger", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Trigger", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Trigger", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Trigger")
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            static method GetLearnedSpellId takes nothing returns integer
                return GetLearnedSkill()
            endmethod

            static method GetSpellId takes nothing returns integer
                return GetSpellAbilityId()
            endmethod

            static method GetDamage takes nothing returns real
                return GetEventDamage()
            endmethod

            static method GetTrigger takes nothing returns Trigger
                return Trigger.GetFromSelf(GetTriggeringTrigger())
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")

        //! runtextmacro CreateAnyStaticStateDefault("DAMAGE", "Damage", "real", "0.")
    endstruct

    //! runtextmacro Struct("RegisterEvent")
        method DestructableDeath takes Destructable whichDestructable returns nothing
            call TriggerRegisterDeathEvent(Trigger(this).self, whichDestructable.self)
        endmethod

        method Dialog takes Dialog whichDialog returns nothing
            call TriggerRegisterDialogEvent(Trigger(this).self, whichDialog.self)
        endmethod

        method DummyUnit takes DummyUnit whichUnit, unitevent whichUnitEvent returns nothing
            call TriggerRegisterUnitEvent(Trigger(this).self, whichUnit.self, whichUnitEvent)
        endmethod

        method EnterRegion takes Region whichRegion, code whichFilter returns nothing
            call TriggerRegisterEnterRegion(Trigger(this).self, whichRegion.self, Condition(whichFilter))
        endmethod

        method LeaveRegion takes Region whichRegion, code whichFilter returns nothing
            call TriggerRegisterLeaveRegion(Trigger(this).self, whichRegion.self, Condition(whichFilter))
        endmethod

        method User takes User whichPlayer, playerevent whichPlayerEvent returns nothing
            if (whichPlayer == User.ANY) then
                local integer iteration = User.ALL_COUNT

                loop
                    call this.User(User.ALL[iteration], whichPlayerEvent)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endif

            call TriggerRegisterPlayerEvent(Trigger(this).self, whichPlayer.self, whichPlayerEvent)
        endmethod

        method UserChat takes User whichPlayer, string input, boolean exactMatch returns nothing
            if (whichPlayer == User.ANY) then
                local integer iteration = User.ALL_COUNT

                loop
                    call this.UserChat(User.ALL[iteration], input, exactMatch)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endif

            call TriggerRegisterPlayerChatEvent(Trigger(this).self, whichPlayer.self, input, exactMatch)
        endmethod

        method PlayerUnit takes User whichPlayer, playerunitevent whichPlayerUnitEvent, code whichFilter returns nothing
            if (whichPlayer == User.ANY) then
                local integer iteration = User.ALL_COUNT

                loop
                    call this.PlayerUnit(User.ALL[iteration], whichPlayerUnitEvent, whichFilter)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endif

            call TriggerRegisterPlayerUnitEvent(Trigger(this).self, whichPlayer.self, whichPlayerUnitEvent, Condition(whichFilter))
        endmethod

        method Unit takes Unit whichUnit, unitevent whichUnitEvent returns nothing
            call TriggerRegisterUnitEvent(Trigger(this).self, whichUnit.self, whichUnitEvent)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Trigger", "TRIGGER")
    //! runtextmacro GetKey("CODE_KEY")
    //! runtextmacro GetKey("KEY")
    static integer RUN_COUNT = 0
    static HashTable TABLE
    static boolexpr TRIG_BOOL_EXPR

    trigger actions
    integer codeId
    string codeNameString
    trigger conditions
    string name
    string nameId
    trigger self

    //! runtextmacro LinkToStruct("Trigger", "Data")
    //! runtextmacro LinkToStruct("Trigger", "Event")
    //! runtextmacro LinkToStruct("Trigger", "Id")
    //! runtextmacro LinkToStruct("Trigger", "RegisterEvent")

    static method GetFromSelf takes trigger self returns thistype
        return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
    endmethod

	method GetNameEx takes nothing returns string
		if (this.codeNameString == null) then
			return this.name
		endif

		return this.codeNameString
	endmethod

    method Destroy takes nothing returns nothing
        local trigger self = this.self

        call this.deallocate()
        //call DestroyTrigger(self)
        call DisableTrigger(self)

        set self = null
    endmethod

    method Clear takes nothing returns nothing
        //call TriggerRemoveCondition(this.actions, this.action)
        //call TriggerRemoveCondition(this.conditions, this.condition)
    endmethod

    method AddCode takes code value returns nothing
        if (value == null) then
            return
        endif

        set this.actions = CreateTrigger()
        set this.codeId = Code.GetId(value)
        set this.nameId = Integer.ToString(Code.GetId(value))

        if (this.codeNameString != null) then
        	set this.codeNameString = this.codeNameString + ";"
        endif

		set this.codeNameString = this.codeNameString + Code.GetName(value)

        call Memory.IntegerKeys.SetIntegerByHandle(this.actions, KEY, this)
        call TriggerAddCondition(this.actions, Condition(value))
    endmethod

    method AddConditions takes code value returns nothing
        if (value == null) then
            return
        endif

        set this.conditions = CreateTrigger()

        call Memory.IntegerKeys.SetIntegerByHandle(this.conditions, KEY, this)
        call TriggerAddCondition(this.conditions, Condition(value))
    endmethod

    method Disable takes nothing returns nothing
        call DisableTrigger(this.self)
    endmethod

    method Enable takes nothing returns nothing
        call EnableTrigger(this.self)
    endmethod

    method Run takes nothing returns nothing
        set thistype.RUN_COUNT = thistype.RUN_COUNT + 1

		if (this.actions == null) then
			call DebugEx(thistype.NAME + ": no action" + "(" + I2S(this) + ")")

			return
		endif

		if (this.codeId == 0) then
			call DebugEx(thistype.NAME + ": no code" + "(" + I2S(this) + ")")

			return
		endif

		call IncStack(this.codeId)

        if not TriggerEvaluate(this.actions) then
            call DebugEx("trigThread broken: " + this.name + ";" + this.nameId + " (" + this.codeNameString + ")")
        endif

		call DecStack()
    endmethod

    method RunWithParams takes EventResponse params returns nothing
        call EventResponse.SetTrigger(params)

        call this.Run()
    endmethod

    static method Sleep takes real timeOut returns nothing
        call TriggerSleepAction(timeOut)
    endmethod

    static method Trig takes nothing returns nothing
        local thistype this = thistype(NULL).Event.Native.GetTrigger()

        if (this.conditions != null) then
            if not TriggerEvaluate(this.conditions) then
                return
            endif
        endif

        //if (this.actions != null) then
          //  call TriggerEvaluate(this.actions)
        //endif
        call this.Run()
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

		local trigger self = CreateTrigger()

        set this.actions = null
        set this.codeId = 0
        set this.codeNameString = null
        set this.conditions = null
        set this.name = "default"
        set this.nameId = null
        set this.self = self
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        call this.Id.Event_Create()

        call TriggerAddCondition(self, thistype.TRIG_BOOL_EXPR)

        set self = null

        return this
    endmethod

	static method CreateWithName takes string name returns thistype
		local thistype this = thistype.Create()

		set this.name = name

		return this
	endmethod

    static method CreateFromCode takes code action returns thistype
    	if (action == null) then
            return NULL
        endif

        local thistype this = thistype.CreateWithName(Code.GetName(action))

        call this.AddCode(action)

        return this
    endmethod

    static method GetFromCode takes code action returns thistype
        local integer actionId = Code.GetId(action)

        local thistype this = thistype.TABLE.Integer.Get(actionId, CODE_KEY)

        if (this == HASH_TABLE.Integer.DEFAULT_VALUE) then
            call thistype.TABLE.Integer.Set(actionId, CODE_KEY, this)

            return thistype.CreateFromCode(action)
        endif

        return this
    endmethod

    //! runtextmacro GetKeyArray("INIT_PARENT_KEY_ARRAY")
    static hashtable INIT_TABLE = null
    static hashtable INIT_CODE_ID_TABLE = null
    static hashtable INIT_MSG_TABLE = null
    static hashtable INIT_MSG_TABLE2 = null
static boolean objTest=false

    static method ObjInitMsg takes nothing returns nothing
local string s=LoadStr(thistype.INIT_MSG_TABLE, GetHandleId(GetTriggeringTrigger()), 0)
if s!=null then
//        call DebugEx(s)
endif
    endmethod

    static method AddObjectInit takes integer tableKey, code c, string name returns nothing
        local trigger t = CreateTrigger()

        //call TriggerAddCondition(t, Condition(function thistype.ObjInitMsg))
        call TriggerAddCondition(t, Condition(c))

        if (thistype.INIT_TABLE == null) then
            set thistype.INIT_TABLE = InitHashtable()
            set thistype.INIT_CODE_ID_TABLE = InitHashtable()
            set thistype.INIT_MSG_TABLE = InitHashtable()
            set thistype.INIT_MSG_TABLE2 = InitHashtable()
        endif

        local integer count = LoadInteger(thistype.INIT_TABLE, tableKey, 0) + 1

        call SaveInteger(thistype.INIT_TABLE, tableKey, 0, count)

        call SaveTriggerHandle(thistype.INIT_TABLE, tableKey, count, t)
        call SaveStr(thistype.INIT_MSG_TABLE2, tableKey, count, name)
        call SaveInteger(thistype.INIT_CODE_ID_TABLE, tableKey, count, Code.GetId(c))
        //if ((tableKey==Trigger.INIT_NORMAL_KEY_ARRAY) or (tableKey==Buff.INIT_KEY_ARRAY) or (tableKey==LightningType.INIT_KEY_ARRAY) or (tableKey==WeatherType.INIT_KEY_ARRAY)) then
            //call SaveStr(thistype.INIT_MSG_TABLE, GetHandleId(t), 0, LoadStr(FUNCS_TABLE, Code.GetId(c), 0))
        //endif
    endmethod

    //! runtextmacro GetKeyArray("INIT_NORMAL_KEY_ARRAY")

    static method AddObjectInitNormal takes code s, string name returns nothing
        call thistype.AddObjectInit(INIT_NORMAL_KEY_ARRAY, s, name)
    endmethod

    //! runtextmacro GetKeyArray("INIT_NATIVE_KEY_ARRAY")

    static method AddNativeInit takes code s returns nothing
        call thistype.AddObjectInit(INIT_NATIVE_KEY_ARRAY, s, null)
    endmethod

    static integer TABLE_KEY

    static integer ITERATION
    static integer ITERATION_END
    static integer STEP_SIZE

    static method RunObjectInits_Exec_Exec takes nothing returns nothing
        local integer iEnd = Math.MinI(thistype.ITERATION + thistype.STEP_SIZE, thistype.ITERATION_END)

        local integer tableKey = thistype.TABLE_KEY

        loop
            exitwhen (thistype.ITERATION > iEnd)

            local trigger t = LoadTriggerHandle(thistype.INIT_TABLE, tableKey, thistype.ITERATION)
            local integer codeId = LoadInteger(thistype.INIT_CODE_ID_TABLE, tableKey, thistype.ITERATION)
            local string name = LoadStr(thistype.INIT_MSG_TABLE2, tableKey, thistype.ITERATION)

            call Loading.Queue(t, codeId, name)

            set thistype.ITERATION = thistype.ITERATION + 1
        endloop

//        set t = null
    endmethod

	static integer MIN
	static integer MAX

    static method RunObjectInits_Exec takes nothing returns nothing
        local integer tableKey = thistype.TABLE_KEY

        local integer count = LoadInteger(thistype.INIT_TABLE, tableKey, 0)

		local ObjThread th = ObjThread.Create("OBJECT INITS " + I2S(tableKey))

        set thistype.ITERATION = thistype.MIN
        set thistype.ITERATION_END = Math.MinI(count, thistype.MAX)
        set thistype.STEP_SIZE = 1500

        loop
            exitwhen (thistype.ITERATION > thistype.ITERATION_END)

            call Code.Run(function thistype.RunObjectInits_Exec_Exec)
        endloop

        call th.Destroy()
    endmethod

    static method RunObjectInits takes integer tableKey returns nothing
        set thistype.TABLE_KEY = tableKey

		set thistype.MIN = 1
		set thistype.MAX = 99999

        call Code.Run(function thistype.RunObjectInits_Exec)
    endmethod

    static method RunObjectInitsLimited takes integer tableKey, integer min, integer max returns nothing
        set thistype.TABLE_KEY = tableKey

		set thistype.MIN = min
		set thistype.MAX = max

        call Code.Run(function thistype.RunObjectInits_Exec)
    endmethod

    initMethod Init of Header_2
        set thistype.TABLE = HashTable.Create()
        set thistype.TRIG_BOOL_EXPR = Condition(function thistype.Trig)
    endmethod
endstruct