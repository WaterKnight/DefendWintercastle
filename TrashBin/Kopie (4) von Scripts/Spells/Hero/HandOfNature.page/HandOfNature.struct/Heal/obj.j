//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\Heal\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\Heal\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\Heal\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\Heal\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\Heal\obj_this.j
static string CASTER_EFFECT_PATH = "Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkZapTarget.mdl"
static string CASTER_EFFECT_ATTACH_POINT = "AttachPoint.OVERHEAD"
static integer array LIFE_HEAL
static integer array MANA_HEAL
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\Heal\\this.wc3obj")
    set thistype.LIFE_HEAL[1] = 20
    set thistype.LIFE_HEAL[2] = 30
    set thistype.LIFE_HEAL[3] = 40
    set thistype.LIFE_HEAL[4] = 50
    set thistype.LIFE_HEAL[5] = 60
    set thistype.MANA_HEAL[1] = 20
    set thistype.MANA_HEAL[2] = 30
    set thistype.MANA_HEAL[3] = 40
    set thistype.MANA_HEAL[4] = 50
    set thistype.MANA_HEAL[5] = 60
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\Heal\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\Heal\obj_this.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod