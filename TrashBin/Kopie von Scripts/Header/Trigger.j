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
            local integer iteration

            if (whichPlayer == User.ANY) then
                set iteration = User.ALL_COUNT

                loop
                    call this.User(User.ALL[iteration], whichPlayerEvent)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endif
            call TriggerRegisterPlayerEvent(Trigger(this).self, whichPlayer.self, whichPlayerEvent)
        endmethod

        method UserChat takes User whichPlayer, string input, boolean exactMatch returns nothing
            local integer iteration

            if (whichPlayer == User.ANY) then
                set iteration = User.ALL_COUNT

                loop
                    call this.UserChat(User.ALL[iteration], input, exactMatch)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endif
            call TriggerRegisterPlayerChatEvent(Trigger(this).self, whichPlayer.self, input, exactMatch)
        endmethod

        method PlayerUnit takes User whichPlayer, playerunitevent whichPlayerUnitEvent, code whichFilter returns nothing
            local integer iteration

            if (whichPlayer == User.ANY) then
                set iteration = User.ALL_COUNT

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
    trigger conditions
    string name
    trigger self

    //! runtextmacro LinkToStruct("Trigger", "Data")
    //! runtextmacro LinkToStruct("Trigger", "Event")
    //! runtextmacro LinkToStruct("Trigger", "Id")
    //! runtextmacro LinkToStruct("Trigger", "RegisterEvent")

    static method GetFromSelf takes trigger self returns thistype
        return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
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
        set this.name = Integer.ToString(Code.GetId(value))

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
        call TriggerEvaluate(this.actions)
    endmethod

    static method Sleep takes real timeOut returns nothing
        call TriggerSleepAction(timeOut)
    endmethod

    static method Trig takes nothing returns nothing
        local thistype this = thistype(NULL).Event.Native.GetTrigger()

        if (this.conditions != null) then
            if (TriggerEvaluate(this.conditions) == false) then
                return
            endif
        endif

        if (this.actions != null) then
            call TriggerEvaluate(this.actions)
        endif
    endmethod

    static method Create takes nothing returns thistype
        local trigger self = CreateTrigger()
        local thistype this = thistype.allocate()

        set this.actions = null
        set this.conditions = null
        set this.self = self
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        call this.Id.Event_Create()

        call TriggerAddCondition(self, thistype.TRIG_BOOL_EXPR)

        set self = null

        return this
    endmethod

    static method CreateFromCode takes code action returns thistype
        local thistype this = thistype.Create()

        call this.AddCode(action)

        return this
    endmethod

    static method GetFromCode takes code action returns thistype
        local thistype this
        local integer actionId = Code.GetId(action)

        set this = thistype.TABLE.Integer.Get(actionId, CODE_KEY)

        if (this == HASH_TABLE.Integer.DEFAULT_VALUE) then
            call thistype.TABLE.Integer.Set(actionId, CODE_KEY, this)

            return thistype.CreateFromCode(action)
        endif

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.TABLE = HashTable.Create()
        set thistype.TRIG_BOOL_EXPR = Condition(function thistype.Trig)
    endmethod
endstruct