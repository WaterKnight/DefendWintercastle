//! runtextmacro Folder("UnitType")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Boolean")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitType", "Boolean", "boolean")
            endstruct
        endscope

        //! runtextmacro Struct("Boolean")
            //! runtextmacro LinkToStruct("Boolean", "Table")

            //! runtextmacro Data_Type_Implement("UnitType", "Boolean", "boolean")

            //! runtextmacro Data_Boolean_Implement("UnitType")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitType", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("UnitType", "Integer", "integer")
        endstruct

        //! runtextmacro Folder("Real")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitType", "Real", "real")
            endstruct
        endscope

        //! runtextmacro Struct("Real")
            //! runtextmacro LinkToStruct("Real", "Table")

            //! runtextmacro Data_Type_Implement("UnitType", "Real", "real")
        endstruct

        //! runtextmacro Folder("String")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitType", "String", "string")
            endstruct
        endscope

        //! runtextmacro Struct("String")
            //! runtextmacro LinkToStruct("String", "Table")

            //! runtextmacro Data_Type_Implement("UnitType", "String", "string")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")
        //! runtextmacro LinkToStruct("Data", "String")

        //! runtextmacro Data_Implement("UnitType")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro Event_Implement("UnitType")
    endstruct

    //! runtextmacro Folder("Abilities")
        //! runtextmacro Struct("ArrayBuild")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro GetKeyArray("LEVEL_KEY_ARRAY_DETAIL")

            method Count takes nothing returns integer
                return UnitType(this).Data.Integer.Table.Count(KEY_ARRAY)
            endmethod

            method Get takes integer index returns Spell
                return UnitType(this).Data.Integer.Table.Get(KEY_ARRAY, index)
            endmethod

            method GetLevel takes Spell whichSpell returns integer
                return UnitType(this).Data.Integer.Get(LEVEL_KEY_ARRAY_DETAIL + whichSpell)
            endmethod

            method Add takes Spell whichSpell, integer level returns nothing
                if UnitType(this).Data.Integer.Table.Contains(KEY_ARRAY, whichSpell) then
                    call DebugEx("unitType "+UnitType(this).GetName()+" already has spell "+whichSpell.GetName())

                    return
                endif

                call UnitType(this).Data.Integer.Table.Add(KEY_ARRAY, whichSpell)
                call UnitType(this).Data.Integer.Set(LEVEL_KEY_ARRAY_DETAIL + whichSpell, level)
            endmethod

            method Event_Create takes nothing returns nothing
            endmethod
        endstruct

        //! runtextmacro Struct("Hero")
            //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
            integer valuesCount

            method Count takes nothing returns integer
                return this.valuesCount
            endmethod

            method Get takes integer index returns Spell
                return UnitType(this).Data.Integer.Get(KEY_ARRAY_DETAIL + index)
            endmethod

            method Add takes Spell whichSpell returns nothing
                local integer valuesCount = this.valuesCount + 1

                set this.valuesCount = valuesCount
                call UnitType(this).Data.Integer.Set(KEY_ARRAY_DETAIL + valuesCount, whichSpell)
            endmethod

            method Event_Create takes nothing returns nothing
                set this.valuesCount = ARRAY_EMPTY
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Abilities")
        //! runtextmacro LinkToStruct("Abilities", "ArrayBuild")
        //! runtextmacro LinkToStruct("Abilities", "Hero")

        method Count takes nothing returns integer
            return this.ArrayBuild.Count()
        endmethod

        method Get takes integer index returns Spell
            return this.ArrayBuild.Get(index)
        endmethod

        method GetLevel takes integer index returns integer
            return this.ArrayBuild.GetLevel(index)
        endmethod

        method Add takes Spell whichSpell returns nothing
            call this.ArrayBuild.Add(whichSpell, 1)
        endmethod

        method AddWithLevel takes Spell whichSpell, integer level returns nothing
            call this.ArrayBuild.Add(whichSpell, level)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.ArrayBuild.Event_Create()
            call this.Hero.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Armor")
        //! runtextmacro Struct("Type")
            //! runtextmacro CreateSimpleAddState("integer", "0")
        endstruct
    endscope

    //! runtextmacro Struct("Armor")
        //! runtextmacro LinkToStruct("Armor", "Type")

        //! runtextmacro CreateSimpleAddState_NotStart("real")

        method Event_Create takes nothing returns nothing
            call this.Set(0.)

            call this.Type.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Struct("Attachments")
        //! runtextmacro GetKeyArray("ATTACH_POINT_KEY_ARRAY")
        //! runtextmacro GetKeyArray("LEVEL_KEY_ARRAY")
        //! runtextmacro GetKeyArray("PATH_KEY_ARRAY")

        method Count takes nothing returns integer
            return UnitType(this).Data.String.Table.Count(PATH_KEY_ARRAY)
        endmethod

        method GetAttachPoint takes integer index returns string
            return UnitType(this).Data.String.Table.Get(ATTACH_POINT_KEY_ARRAY, index)
        endmethod

        method GetLevel takes integer index returns EffectLevel
            return UnitType(this).Data.Integer.Table.Get(LEVEL_KEY_ARRAY, index)
        endmethod

        method GetPath takes integer index returns string
            return UnitType(this).Data.String.Table.Get(PATH_KEY_ARRAY, index)
        endmethod

        method Add takes string path, string attachPoint, EffectLevel level returns nothing
            call UnitType(this).Data.String.Table.AddMulti(ATTACH_POINT_KEY_ARRAY, attachPoint)
            call UnitType(this).Data.Integer.Table.AddMulti(LEVEL_KEY_ARRAY, level)
            call UnitType(this).Data.String.Table.AddMulti(PATH_KEY_ARRAY, path)
        endmethod
    endstruct

    //! runtextmacro Folder("Attack")
        //! runtextmacro Folder("Missile")
            //! runtextmacro Struct("Speed")
                //! runtextmacro CreateSimpleAddState("real", "0.")
            endstruct
        endscope

        //! runtextmacro Struct("Missile")
            //! runtextmacro LinkToStruct("Missile", "Speed")

            method Event_Create takes nothing returns nothing
                call this.Speed.Event_Create()
            endmethod
        endstruct

        //! runtextmacro Struct("Range")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Struct("Speed")
            //! runtextmacro CreateSimpleAddState("real", "0.")

            method SetByCooldown takes real cooldown returns nothing
                call this.Set(1. / cooldown)
            endmethod
        endstruct

        //! runtextmacro Folder("Splash")
            //! runtextmacro Struct("TargetFlag")
                //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

                method Is takes integer whichFlag returns boolean
                    return UnitType(this).Data.Boolean.Get(KEY_ARRAY_DETAIL + whichFlag)
                endmethod

                method Add takes integer whichFlag returns nothing
                    call UnitType(this).Data.Boolean.Add(KEY_ARRAY_DETAIL + whichFlag)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Splash")
            //! runtextmacro GetKeyArray("AREA_RANGE_KEY_ARRAY")
            //! runtextmacro GetKeyArray("DAMAGE_KEY_ARRAY")

            //! runtextmacro LinkToStruct("Splash", "TargetFlag")

            method Count takes nothing returns integer
                return UnitType(this).Data.Real.Table.Count(AREA_RANGE_KEY_ARRAY)
            endmethod

            method GetAreaRange takes integer index returns real
                return UnitType(this).Data.Real.Table.Get(AREA_RANGE_KEY_ARRAY, index)
            endmethod

            method GetDamageFactor takes integer index returns real
                return UnitType(this).Data.Real.Table.Get(DAMAGE_KEY_ARRAY, index)
            endmethod

            method Add takes real areaRange, real damageFactor returns nothing
                call UnitType(this).Data.Real.Table.AddMulti(AREA_RANGE_KEY_ARRAY, areaRange)
                call UnitType(this).Data.Real.Table.AddMulti(DAMAGE_KEY_ARRAY, damageFactor)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Attack")
        //! runtextmacro LinkToStruct("Attack", "Missile")
        //! runtextmacro LinkToStruct("Attack", "Range")
        //! runtextmacro LinkToStruct("Attack", "Speed")
        //! runtextmacro LinkToStruct("Attack", "Splash")

        //! runtextmacro CreateSimpleAddState_NotStart("Attack")

        method Event_Create
            set this.value = NULL

            call this.Missile.Event_Create()
            call this.Range.Event_Create()
            call this.Speed.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Struct("Blood")
        //! runtextmacro CreateSimpleAddState_NotAdd("string", "null")
    endstruct

    //! runtextmacro Struct("BloodExplosion")
        //! runtextmacro CreateSimpleAddState_NotAdd("string", "null")
    endstruct

    //! runtextmacro Struct("Classes")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        method Count takes nothing returns integer
            return UnitType(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns UnitClass
            return UnitType(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Add takes UnitClass value
            call UnitType(this).Data.Integer.Table.Add(KEY_ARRAY, value)
        endmethod
    endstruct

    //! runtextmacro Struct("CollisionSize")
        //! runtextmacro CreateSimpleAddState("real", "0.")

        method SetByScale takes real value, real scale
            call this.Set(value / scale)
        endmethod
    endstruct

    //! runtextmacro Folder("Damage")
        //! runtextmacro Struct("Delay")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Struct("Dices")
            //! runtextmacro CreateSimpleAddState("integer", "0")
        endstruct

        //! runtextmacro Struct("Sides")
            //! runtextmacro CreateSimpleAddState("integer", "0")
        endstruct

        //! runtextmacro Struct("Type")
            //! runtextmacro CreateSimpleAddState("integer", "-1")
        endstruct
    endscope

    //! runtextmacro Struct("Damage")
        //! runtextmacro LinkToStruct("Damage", "Delay")
        //! runtextmacro LinkToStruct("Damage", "Dices")
        //! runtextmacro LinkToStruct("Damage", "Sides")
        //! runtextmacro LinkToStruct("Damage", "Type")

        //! runtextmacro CreateAnyState("valueBJ", "BJ", "real")

        //! runtextmacro CreateSimpleAddState_NotStart("real")

        method Event_Create
            call this.Set(0.)

            call this.Delay.Event_Create()
            call this.Dices.Event_Create()
            call this.Sides.Event_Create()
            call this.Type.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Decay")
        //! runtextmacro Struct("Duration")
            //! runtextmacro CreateSimpleAddState("real", "10.")
        endstruct
    endscope

    //! runtextmacro Struct("Decay")
        //! runtextmacro LinkToStruct("Decay", "Duration")

        //! runtextmacro CreateSimpleFlagState_NotStart()

        method Event_Create
            call this.Set(true)

            call this.Duration.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Drop")
        //! runtextmacro Struct("Exp")
            //! runtextmacro CreateSimpleAddState("integer", "0")
        endstruct

        //! runtextmacro Struct("Supply")
            //! runtextmacro CreateSimpleAddState("integer", "0")
        endstruct
    endscope

    //! runtextmacro Struct("Drop")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro LinkToStruct("Drop", "Exp")
        //! runtextmacro LinkToStruct("Drop", "Supply")

        method Count takes nothing returns integer
            return UnitType(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns Drop
            return UnitType(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Add takes Drop whichDrop
            call UnitType(this).Data.Integer.Table.Add(KEY_ARRAY, whichDrop)
        endmethod

        method Event_Create
            call this.Exp.Event_Create()
            call this.Supply.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Impact")
        //! runtextmacro Struct("Z")
            static constant real STANDARD = 60.

            //! runtextmacro CreateSimpleAddState("real", "STANDARD")
        endstruct
    endscope

    //! runtextmacro Struct("Impact")
        //! runtextmacro LinkToStruct("Impact", "Z")

        method Event_Create takes nothing returns nothing
            call this.Z.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Outpact")
        //! runtextmacro Struct("Z")
            static constant real STANDARD = 60.

            //! runtextmacro CreateSimpleAddState("real", "STANDARD")
        endstruct
    endscope

    //! runtextmacro Struct("Outpact")
        //! runtextmacro LinkToStruct("Outpact", "Z")

        method Event_Create
            call this.Z.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Struct("Life")
        static constant real INFINITE = 150000.

        //! runtextmacro CreateAnyState("valueBJ", "BJ", "real")

        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Struct("LifeRegeneration")
        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Struct("Mana")
        //! runtextmacro CreateAnyState("valueBJ", "BJ", "real")

        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Struct("ManaRegeneration")
        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Struct("Preload")
        method Event_Create
            local unit dummyUnit = CreateUnit(User.DUMMY.self, UnitType(this).self, 0., 0., 0.)

            call KillUnit(dummyUnit)

            call RemoveUnit(dummyUnit)

            set dummyUnit = null
        endmethod
    endstruct

    //! runtextmacro Struct("Revivalable")
        //! runtextmacro CreateSimpleFlagState("true")
    endstruct

    //! runtextmacro Struct("Scale")
        //! runtextmacro CreateSimpleAddState("real", "1.")
    endstruct

    //! runtextmacro Struct("SightRange")
        //! runtextmacro CreateAnyState("valueBJ", "BJ", "real")

        //! runtextmacro CreateSimpleAddState_NotAdd("real", "800.")
    endstruct

    //! runtextmacro Struct("Speed")
        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Struct("SpellPower")
        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Struct("SpellVamp")
        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Folder("VertexColor")
        //! runtextmacro Struct("Red")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Green")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Blue")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Alpha")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct
    endscope

    //! runtextmacro Struct("VertexColor")
        //! runtextmacro LinkToStruct("VertexColor", "Red")
        //! runtextmacro LinkToStruct("VertexColor", "Green")
        //! runtextmacro LinkToStruct("VertexColor", "Blue")
        //! runtextmacro LinkToStruct("VertexColor", "Alpha")

        method Set takes real red, real green, real blue, real alpha returns nothing
            call this.Red.Set(red)
            call this.Green.Set(green)
            call this.Blue.Set(blue)
            call this.Alpha.Set(alpha)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Red.Event_Create()
            call this.Green.Event_Create()
            call this.Blue.Event_Create()
            call this.Alpha.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Hero")
        //! runtextmacro Struct("PrimaryAttribute")

            static constant integer AGILITY = 1
            static constant integer INTELLIGENCE = 2
            static constant integer STRENGTH = 3

            //! runtextmacro CreateSimpleAddState("integer", "0")
        endstruct

        //! runtextmacro Folder("Agility")
            //! runtextmacro Struct("PerLevel")
                //! runtextmacro CreateSimpleAddState("real", "0.")
            endstruct
        endscope

        //! runtextmacro Struct("Agility")
            //! runtextmacro LinkToStruct("Agility", "PerLevel")

            //! runtextmacro CreateSimpleAddState_NotStart("real")

            method Event_Create takes nothing returns nothing
                call this.Set(0.)

                call this.PerLevel.Event_Create()
            endmethod
        endstruct

        //! runtextmacro Struct("ArmorPerLevel")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Folder("Intelligence")
            //! runtextmacro Struct("PerLevel")
                //! runtextmacro CreateSimpleAddState("real", "0.")
            endstruct
        endscope

        //! runtextmacro Struct("Intelligence")
            //! runtextmacro LinkToStruct("Intelligence", "PerLevel")

            //! runtextmacro CreateSimpleAddState_NotStart("real")

            method Event_Create takes nothing returns nothing
                call this.Set(0.)

                call this.PerLevel.Event_Create()
            endmethod
        endstruct

        //! runtextmacro Folder("Strength")
            //! runtextmacro Struct("PerLevel")
                //! runtextmacro CreateSimpleAddState("real", "0.")
            endstruct
        endscope

        //! runtextmacro Struct("Strength")
            //! runtextmacro LinkToStruct("Strength", "PerLevel")

            //! runtextmacro CreateSimpleAddState_NotStart("real")

            method Event_Create takes nothing returns nothing
                call this.Set(0.)

                call this.PerLevel.Event_Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Hero")
        //! runtextmacro LinkToStruct("Hero", "Agility")
        //! runtextmacro LinkToStruct("Hero", "ArmorPerLevel")
        //! runtextmacro LinkToStruct("Hero", "Intelligence")
        //! runtextmacro LinkToStruct("Hero", "PrimaryAttribute")
        //! runtextmacro LinkToStruct("Hero", "Strength")

        method Event_Create takes nothing returns nothing
            call this.Agility.Event_Create()
            call this.ArmorPerLevel.Event_Create()
            call this.Intelligence.Event_Create()
            call this.PrimaryAttribute.Event_Create()
            call this.Strength.Event_Create()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("UnitType", "UNIT_TYPE")
    static constant real HEROES_ARMOR_BASE = 0.
    //! runtextmacro GetKey("KEY")
    static thistype TEMP

    string combatFlags
    integer self

    //! runtextmacro LinkToStruct("UnitType", "Abilities")
    //! runtextmacro LinkToStruct("UnitType", "Armor")
    //! runtextmacro LinkToStruct("UnitType", "Attachments")
    //! runtextmacro LinkToStruct("UnitType", "Attack")
    //! runtextmacro LinkToStruct("UnitType", "Blood")
    //! runtextmacro LinkToStruct("UnitType", "BloodExplosion")
    //! runtextmacro LinkToStruct("UnitType", "Classes")
    //! runtextmacro LinkToStruct("UnitType", "CollisionSize")
    //! runtextmacro LinkToStruct("UnitType", "Damage")
    //! runtextmacro LinkToStruct("UnitType", "Data")
    //! runtextmacro LinkToStruct("UnitType", "Decay")
    //! runtextmacro LinkToStruct("UnitType", "Drop")
    //! runtextmacro LinkToStruct("UnitType", "Event")
    //! runtextmacro LinkToStruct("UnitType", "Hero")
    //! runtextmacro LinkToStruct("UnitType", "Id")
    //! runtextmacro LinkToStruct("UnitType", "Impact")
    //! runtextmacro LinkToStruct("UnitType", "Life")
    //! runtextmacro LinkToStruct("UnitType", "LifeRegeneration")
    //! runtextmacro LinkToStruct("UnitType", "Mana")
    //! runtextmacro LinkToStruct("UnitType", "ManaRegeneration")
    //! runtextmacro LinkToStruct("UnitType", "Outpact")
    //! runtextmacro LinkToStruct("UnitType", "Preload")
    //! runtextmacro LinkToStruct("UnitType", "Revivalable")
    //! runtextmacro LinkToStruct("UnitType", "Scale")
    //! runtextmacro LinkToStruct("UnitType", "SightRange")
    //! runtextmacro LinkToStruct("UnitType", "Speed")
    //! runtextmacro LinkToStruct("UnitType", "SpellPower")
    //! runtextmacro LinkToStruct("UnitType", "SpellVamp")
    //! runtextmacro LinkToStruct("UnitType", "VertexColor")

    static method GetFromSelf takes integer self returns thistype
        return Memory.IntegerKeys.GetInteger(self, KEY)
    endmethod

    static method GetFromName takes string name returns thistype
        return StringData.Data.Integer.Get(name, KEY)
    endmethod

    method GetName takes nothing returns string
        return GetObjectName(this.self)
    endmethod

    method GetSelf takes nothing returns integer
        return this.self
    endmethod

    //! runtextmacro GetKeyArray("INIT_KEY_ARRAY")

    static method AddInit takes code c, string name returns nothing
        call Trigger.AddObjectInit(INIT_KEY_ARRAY, c, name)
    endmethod

    static method CreateBasic takes integer self returns thistype
        local thistype this = thistype.allocate()

        set this.combatFlags = null
        set this.self = self

        call this.Id.Event_Create()

        call this.Abilities.Event_Create()
        call this.Armor.Event_Create()
        call this.Attack.Event_Create()
        call this.Blood.Event_Create()
        call this.BloodExplosion.Event_Create()
        call this.CollisionSize.Event_Create()
        call this.Damage.Event_Create()
        call this.Decay.Event_Create()
        call this.Drop.Event_Create()
        call this.Hero.Event_Create()
        call this.Impact.Event_Create()
        call this.Life.Event_Create()
        call this.LifeRegeneration.Event_Create()
        call this.Mana.Event_Create()
        call this.ManaRegeneration.Event_Create()
        call this.Preload.Event_Create()
        call this.Outpact.Event_Create()
        call this.Revivalable.Event_Create()
        call this.Scale.Event_Create()
        call this.Speed.Event_Create()
        call this.SpellPower.Event_Create()
        call this.SpellVamp.Event_Create()
        call this.VertexColor.Event_Create()

        call this.BloodExplosion.Set("Objects\\Spawnmodels\\Human\\HumanSmallDeathExplode\\HumanSmallDeathExplode.mdl")

        call this.AddToList()

        call StringData.Data.Integer.Set(this.GetName(), KEY, this)

        return this
    endmethod

    static method Create takes integer self returns thistype
        local thistype this = thistype.CreateBasic(self)

        set this.self = self
        call Memory.IntegerKeys.SetInteger(self, KEY, this)

        return this
    endmethod

    static method CreateHidden takes nothing returns thistype
        return thistype.CreateBasic(0)
    endmethod

    execMethod Init_Executed
//        call Trigger.RunObjectInits(thistype.INIT_KEY_ARRAY)
    endmethod

    static method Init takes nothing returns nothing
        call Code.Run(function thistype.Init_Executed)
    endmethod
endstruct