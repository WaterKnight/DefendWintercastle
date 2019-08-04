//! runtextmacro BaseStruct("HeroSpell", "HERO_SPELL")
    //! runtextmacro GetKey("BASE_SPELL_KEY")
    //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
    static Event LEARN_EVENT
    static constant integer MAX_SLOTS = 5

    integer learnerSpellId
    integer replacerId

    //! textmacro HeroSpell_CreateReplacerBuff takes doExternal
        $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
            //! i function set(field, value)
                //! i makechange(current, field, value)
            //! i end

            //! i function setl(field, level, value)
                //! i makechange(current, field, level, value)
            //! i end

            //! i setobjecttype("buffs")

            //! i createobject("BNeg", "BHSR")

            //! i set("fart", "")
            //! i set("frac", "human")
            //! i set("fta0", "")
            //! i set("fta1", "")
            //! i set("fta2", "")
            //! i set("fta3", "")
            //! i set("ftac", 0)
            //! i set("ftat", "")
            //! i set("ftip", "Hero Spell Replacer")
        $doExternal$//! endexternalblock
    //! endtextmacro

    //! runtextmacro HeroSpell_CreateReplacerBuff("/")

    //! textmacro HeroSpell_CreateSlots takes doExternal
        static constant integer SLOT_ID = 'AHS0'

        $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
            //! i function set(field, value)
                //! i makechange(current, field, value)
            //! i end

            //! i function setl(field, level, value)
                //! i makechange(current, field, level, value)
            //! i end

            //! i setobjecttype("abilities")

            //! i for i = 0, 4, 1 do
                //! i createobject("ANcl", "AHS"..i)

                //! i set("aani", "")
                //! i set("aart", "")
                //! i set("abpx", 0)
                //! i set("acap", "")
                //! i set("acat", "")
                //! i set("aeat", "")
                //! i set("ahky", "")
                //! i set("alev", 5)
                //! i set("anam", "Hero Spell Slot "..i)
                //! i set("arac", "other")
                //! i for i2 = 1, 5, 1 do
                    //! i setl("aran", i2, 0)
                    //! i setl("Ncl1", i2, 0)
                    //! i setl("Ncl4", i2, 0)
                    //! i setl("Ncl5", i2, "\0")
                //! i end
                //! i set("ata0", "")
                //! i set("atat", "")
                //! i setl("atp1", 1, "")
                //! i setl("aub1", 1, "")
                //! i setl("Ncl6", 1, "")
            //! i end
        $doExternal$//! endexternalblock
    //! endtextmacro

    //! runtextmacro HeroSpell_CreateSlots("")

    static method GetFromUnit takes Unit whichUnit, SpellClass whichClass returns Spell
        return whichUnit.Data.Integer.Get(KEY_ARRAY_DETAIL + whichClass)
    endmethod

    static method GetLearnerSpellId takes Spell whichSpell, integer level returns integer
        return (whichSpell.GetClass().GetLearnPrefix() + thistype(whichSpell).learnerSpellId + level)
    endmethod

    static method GetReplacerId takes Spell whichSpell returns integer
        return (thistype(whichSpell).replacerId + whichSpell.GetClass().GetLearnPositionIndex())
    endmethod

    static method Event_Learn takes nothing returns nothing
        local Spell whichSpell = SPELL.Event.GetTrigger().Data.Integer.Get(BASE_SPELL_KEY)
        local Unit whichUnit = UNIT.Event.GetTrigger()
        local integer level = GetLearnedSkillLevel()

        if (level < whichSpell.GetLevelsAmount()) then
            call whichUnit.Abilities.SetLevelBySelf(thistype.GetReplacerId(whichSpell), level + 1)
        else
            call whichUnit.Abilities.RemoveBySelf(thistype.GetReplacerId(whichSpell))
        endif
        call whichUnit.Abilities.SetLevel(whichSpell, level)
    endmethod

    static method RemoveFromUnit takes Spell whichSpell, Unit whichUnit returns nothing
        call whichUnit.Data.Integer.Remove(KEY_ARRAY_DETAIL + whichSpell.GetClass())

        call whichUnit.Abilities.RemoveBySelf(thistype.GetReplacerId(whichSpell))
        call whichUnit.Owner.Get().EnableAbility(whichSpell, false)
    endmethod

    static method AddToUnit takes Spell whichSpell, Unit whichUnit returns nothing
        local integer learnerSpellId = thistype.GetLearnerSpellId(whichSpell, 0)
        local SpellClass whichClass = whichSpell.GetClass()

        local Spell oldSpell = thistype.GetFromUnit(whichUnit, whichClass)

        local integer level = whichUnit.Abilities.GetLevel(oldSpell)

        if (oldSpell != NULL) then
            call thistype.RemoveFromUnit(oldSpell, whichUnit)
        endif

        call whichUnit.Data.Integer.Set(KEY_ARRAY_DETAIL + whichClass, whichSpell)

        call whichUnit.Abilities.SetLevel(whichSpell, level)
        call whichUnit.Owner.Get().EnableAbility(whichSpell, true)
        if (level < whichSpell.GetLevelsAmount()) then
            call whichUnit.Abilities.SetLevelBySelf(thistype.GetReplacerId(whichSpell), whichUnit.Abilities.GetLevel(whichSpell) + 1)
        endif

        if (learnerSpellId != 0) then
            //set learnerSpellId = thistype.GetLearnerSpellId(whichSpell, index)

            //call whichUnit.Abilities.SetLevelBySelf(learnerSpellId, whichUnit.Abilities.GetLevel(whichSpell))
        endif
    endmethod

    static method ReplaceSlot takes SpellClass whichClass, Spell newSpell, Unit whichUnit returns nothing
        if (thistype.GetFromUnit(whichUnit, whichClass) != NULL) then
            call thistype.AddToUnit(newSpell, whichUnit)
        endif
    endmethod

    static method InitSpell takes Spell whichSpell, integer learnerSpellId, integer levelsAmount, integer replacerId returns nothing
        local Spell learnerSpell
        local SpellClass whichClass = whichSpell.GetClass()

        local integer abilityId = (replacerId + whichClass.GetLearnPositionIndex())
        local integer learnerPrefix = whichClass.GetLearnPrefix()
        local integer level = (levelsAmount - 1)

        call InitAbility(abilityId)
        call User.ANY.EnableAbilityBySelf(abilityId, false)

        set thistype(whichSpell).learnerSpellId = learnerSpellId
        set thistype(whichSpell).replacerId = replacerId
        loop
            exitwhen (level < 0)

            set abilityId = (learnerPrefix + learnerSpellId + level)

            set learnerSpell = Spell.CreateFromSelf(abilityId)
            call InitAbility(abilityId)

            call learnerSpell.Data.Integer.Set(BASE_SPELL_KEY, whichSpell)
            call learnerSpell.Event.Add(LEARN_EVENT)

            set level = level - 1
        endloop
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration = thistype.MAX_SLOTS - 1

        set thistype.LEARN_EVENT = Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Learn)

        loop
            exitwhen (iteration < ARRAY_MIN)

            call User.ANY.EnableAbilityBySelf(thistype.SLOT_ID + iteration, false)

            set iteration = iteration - 1
        endloop
    endmethod
endstruct

//! runtextmacro BaseStruct("SpellClass", "SPELL_CLASS")
    static constant integer LEARN_PREFIX_BASE = 'F000'

    static thistype ARTIFACT
    static thistype HERO_FIRST
    static thistype HERO_SECOND
    static thistype HERO_ULTIMATE
    static thistype HERO_ULTIMATE_EX
    static thistype ITEM
    static thistype NORMAL
    static thistype PURCHASABLE

    //! runtextmacro CreateAnyFlagState("hero", "Hero")
    //! runtextmacro CreateAnyState("learnPositionIndex", "LearnPositionIndex", "integer")
    //! runtextmacro CreateAnyState("learnPrefix", "LearnPrefix", "integer")

    static method Create takes boolean isHero, integer learnPositionIndex, integer learnPrefix returns thistype
        local thistype this = thistype.allocate()

        if (learnPrefix != 0) then
            set learnPrefix = learnPrefix - thistype.LEARN_PREFIX_BASE
        endif

        call this.SetLearnPositionIndex(learnPositionIndex)
        call this.SetLearnPrefix(learnPrefix)
        call this.SetHero(isHero)

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ARTIFACT = thistype.Create(false, 0, 0)
        set thistype.HERO_FIRST = thistype.Create(true, 0, 'F000')
        set thistype.HERO_SECOND = thistype.Create(true, 1, 'G000')
        set thistype.HERO_ULTIMATE = thistype.Create(true, 2, 'H000')
        set thistype.HERO_ULTIMATE_EX = thistype.Create(true, 3, 'J000')
        set thistype.ITEM = thistype.Create(false, 0, 0)
        set thistype.NORMAL = thistype.Create(false, 0, 0)
        set thistype.PURCHASABLE = thistype.Create(true, 4, 'K000')
    endmethod
endstruct

//! runtextmacro Folder("Spell")
    globals
        constant integer MAX_SPELL_LEVEL_Wrapped = 3
    endglobals

    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Spell", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("Spell", "Boolean", "boolean")
        endstruct

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Spell", "Integer", "integer")
        endstruct

        //! runtextmacro Struct("Real")
            //! runtextmacro Data_Type_Implement("Spell", "Real", "real")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")

        //! runtextmacro Data_Implement("Spell")
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            //! textmacro Spell_Event_Native_CreateResponse takes name, source
                static method Get$name$ takes nothing returns Spell
                    return Spell.GetFromSelf($source$())
                endmethod
            //! endtextmacro

            //! runtextmacro Spell_Event_Native_CreateResponse("Cast", "GetSpellAbilityId")
            //! runtextmacro Spell_Event_Native_CreateResponse("Learned", "GetLearnedSkill")
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")

        //! runtextmacro CreateAnyStaticFlagStateDefault("CHANNEL_COMPLETE", "ChannelComplete", "false")
        //! runtextmacro CreateAnyStaticStateDefault("LEVEL", "Level", "integer", "0")
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "Spell", "NULL")

        //! runtextmacro Event_Implement("Spell")
    endstruct
endscope

//! runtextmacro BaseStruct("Spell", "SPELL")
    //! runtextmacro GetKeyArray("AREA_RANGE_KEY_ARRAY_DETAIL")
    //! runtextmacro GetKeyArray("CHANNEL_TIME_KEY_ARRAY_DETAIL")
    //! runtextmacro GetKeyArray("COOLDOWN_KEY_ARRAY_DETAIL")
    static constant string DEFAULT_NAME = "Default string"
    //! runtextmacro GetKey("KEY")
    //! runtextmacro GetKeyArray("MANA_COST_KEY_ARRAY_DETAIL")
    //! runtextmacro GetKeyArray("RANGE_KEY_ARRAY_DETAIL")
    static constant integer TARGET_TYPE_IMMEDIATE = 0
    static constant integer TARGET_TYPE_PASSIVE = 1
    static constant integer TARGET_TYPE_POINT = 2
    static constant integer TARGET_TYPE_POINT_OR_UNIT = 3
    static constant integer TARGET_TYPE_UNIT = 4
    static thistype TEMP
    static constant integer TYPE_HERO_FIRST_LEVELS_AMOUNT = 5
    static constant integer TYPE_HERO_SECOND_LEVELS_AMOUNT = 5
    static constant integer TYPE_HERO_ULTIMATE_EX_LEVELS_AMOUNT = 3
    static constant integer TYPE_HERO_ULTIMATE_LEVELS_AMOUNT = 3
    static constant integer TYPE_NORMAL_LEVELS_AMOUNT = 1

    static thistype METEORITE_PROTECTION

    //! runtextmacro LinkToStruct("Spell", "Data")
    //! runtextmacro LinkToStruct("Spell", "Event")
    //! runtextmacro LinkToStruct("Spell", "Id")

    //! runtextmacro CreateAnyState("animation", "Animation", "string")
    //! runtextmacro CreateAnyFlagState("heroSpell", "HeroSpell")
    //! runtextmacro CreateAnyState("icon", "Icon", "string")
    //! runtextmacro CreateAnyState("levelsAmount", "LevelsAmount", "integer")
    //! runtextmacro CreateAnyState("thisOrder", "Order", "Order")
    //! runtextmacro CreateAnyState("name", "Name", "string")
    //! runtextmacro CreateAnyState("self", "Self", "integer")
    //! runtextmacro CreateAnyState("targetType", "TargetType", "integer")
    //! runtextmacro CreateAnyState("whichClass", "Class", "SpellClass")

    //! textmacro Spell_CreateParallelBuff takes doExternal, raw
        static constant integer PARALLEL_CAST_BUFF_ID = '$raw$'

        $doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
            //! i function set(field, value)
                //! i makechange(current, field, value)
            //! i end

            //! i function setl(field, level, value)
                //! i makechange(current, field, level, value)
            //! i end

            //! i setobjecttype("buffs")

            //! i createobject("BOwk", "$raw$")

            //! i set("ftip", "Parallel Cast")
            //! i set("frac", "human")
        $doExternal$//! endexternalblock
    //! endtextmacro

    //! runtextmacro Spell_CreateParallelBuff("/", "BPar")

    static method GetFromName takes string name returns thistype
        return StringData.Data.Integer.Get(name, KEY)
    endmethod

    static method GetFromSelf takes integer self returns thistype
        return Memory.IntegerKeys.GetInteger(self, KEY)
    endmethod

    method GetAreaRange takes integer level returns real
        return this.Data.Real.Get(AREA_RANGE_KEY_ARRAY_DETAIL + level)
    endmethod

    method GetChannelTime takes integer level returns real
        return this.Data.Real.Get(CHANNEL_TIME_KEY_ARRAY_DETAIL + level)
    endmethod

    method GetCooldown takes integer level returns real
        return this.Data.Real.Get(COOLDOWN_KEY_ARRAY_DETAIL + level)
    endmethod

    method GetManaCost takes integer level returns integer
        return this.Data.Integer.Get(MANA_COST_KEY_ARRAY_DETAIL + level)
    endmethod

    method GetRange takes integer level returns real
        return this.Data.Real.Get(RANGE_KEY_ARRAY_DETAIL + level)
    endmethod

    static method SelfExists takes integer self returns boolean
        return (GetObjectName(self) != DEFAULT_NAME)
    endmethod

    method SetAreaRange takes integer level, real value returns nothing
        call this.Data.Real.Set(AREA_RANGE_KEY_ARRAY_DETAIL + level, value)
    endmethod

    method SetChannelTime takes integer level, real value returns nothing
        call this.Data.Real.Set(CHANNEL_TIME_KEY_ARRAY_DETAIL + level, value)
    endmethod

    method SetCooldown takes integer level, real value returns nothing
        call this.Data.Real.Set(COOLDOWN_KEY_ARRAY_DETAIL + level, value)
    endmethod

    method SetManaCost takes integer level, integer value returns nothing
        call this.Data.Integer.Set(MANA_COST_KEY_ARRAY_DETAIL + level, value)
    endmethod

    method SetRange takes integer level, real value returns nothing
        call this.Data.Real.Set(RANGE_KEY_ARRAY_DETAIL + level, value)
    endmethod

    static method CreateBasic takes string name returns thistype
        local thistype this = thistype.allocate()

        set this.levelsAmount = 0
        call this.SetHeroSpell(false)
        call this.SetName(name)

        call this.Id.Event_Create()

        //call this.Preload.Event_Create()

        return this
    endmethod

    static method CreateFromSelf takes integer self returns thistype
        local thistype this = thistype.CreateBasic(GetObjectName(self))

        set this.self = self
        call Memory.IntegerKeys.SetInteger(self, KEY, this)
        //call StringData.Data.Integer.Set(this.GetName(), KEY, this)

        call InitAbility(self)

        return this
    endmethod

    static method CreateHidden takes string name returns thistype
        return thistype.CreateBasic(name)
    endmethod

    static method Init takes nothing returns nothing
        call SpellClass.Init()

        call InitBuff(thistype.PARALLEL_CAST_BUFF_ID)

        //! runtextmacro Spell_OpenScope("/")

        //! runtextmacro Spell_Create("/", "METEORITE_PROTECTION", "AMtP", "Meteorite Protection")

        //! runtextmacro Spell_SetTypes("/", "PASSIVE", "NORMAL")

        //! runtextmacro Spell_Finalize("/")

        call HeroSpell.Init()
    endmethod
endstruct

//! runtextmacro Folder("SpellInstance")
    //! runtextmacro Struct("Refs")
        boolean waiting

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method CheckForDestroy takes nothing returns boolean
            if (this.Get() > 0) then
                set this.waiting = true

                return false
            endif

            return true
        endmethod

        method Subtract takes nothing returns nothing
            local integer value = this.Get() - 1

            set this.value = value

            if ((value == 0) and (this.waiting)) then
                call SpellInstance(this).Destroy()
            endif
        endmethod

        method Add takes nothing returns nothing
            set this.value = this.Get() + 1
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0
            set this.waiting = false
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SpellInstance", "SPELL_INSTANCE")
    static thistype TEMP

    //! runtextmacro LinkToStruct("SpellInstance", "Refs")

    //! runtextmacro CreateAnyState("caster", "Caster", "Unit")
    //! runtextmacro CreateAnyState("critFlag", "CritFlag", "integer")
    //! runtextmacro CreateAnyState("damageMod", "DamageMod", "real")
    //! runtextmacro CreateAnyState("dealtDamage", "DealtDamage", "real")
    //! runtextmacro CreateAnyState("level", "Level", "integer")
    //! runtextmacro CreateAnyState("spellPowerMod", "SpellPowerMod", "real")
    //! runtextmacro CreateAnyState("targetItem", "TargetItem", "Item")
    //! runtextmacro CreateAnyState("targetUnit", "TargetUnit", "Unit")
    //! runtextmacro CreateAnyState("targetX", "TargetX", "real")
    //! runtextmacro CreateAnyState("targetY", "TargetY", "real")
    //! runtextmacro CreateAnyState("whichSpell", "Spell", "Spell")

    method GetCurrentTargetX takes nothing returns real
        local Item targetItem = this.GetTargetItem()
        local Unit targetUnit

        if (targetItem != NULL) then
            return targetItem.Position.GetX()
        endif

        set targetUnit = this.GetTargetUnit()

        if (targetUnit != NULL) then
            return targetUnit.Position.X.Get()
        endif

        return this.GetTargetX()
    endmethod

    method GetCurrentTargetY takes nothing returns real
        local Item targetItem = this.GetTargetItem()
        local Unit targetUnit

        if (targetItem != NULL) then
            return targetItem.Position.GetY()
        endif

        set targetUnit = this.GetTargetUnit()

        if (targetUnit != NULL) then
            return targetUnit.Position.Y.Get()
        endif

        return this.GetTargetY()
    endmethod

    method Destroy takes nothing returns nothing
        if (this.Refs.CheckForDestroy() == false) then
            return
        endif

        call this.deallocate()
    endmethod

    method AddDamage takes real damage, boolean crit returns nothing
        if (damage > 0.) then
            call this.SetCritFlag(this.GetCritFlag() + Boolean.ToIntEx(crit))
            call this.SetDealtDamage(this.GetDealtDamage() + damage)
        endif
    endmethod

    static method Create takes Unit caster, Spell whichSpell returns thistype
        local thistype this = thistype.allocate()

        call this.SetCaster(caster)
        call this.SetCritFlag(0)
        call this.SetDamageMod(caster.Damage.GetAll())
        call this.SetDealtDamage(0.)
        call this.SetLevel(caster.Abilities.GetLevel(whichSpell))
        call this.SetSpell(whichSpell)
        call this.SetSpellPowerMod(caster.SpellPower.GetAll())
        call this.SetTargetItem(NULL)
        call this.SetTargetUnit(NULL)
        call this.SetTargetX(0.)
        call this.SetTargetY(0.)

        call this.Refs.Event_Create()

        return this
    endmethod
endstruct