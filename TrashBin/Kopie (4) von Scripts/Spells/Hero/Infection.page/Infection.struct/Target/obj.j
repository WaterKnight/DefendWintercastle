//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Target\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BInB', "Infection", 'bInB')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDoom.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\AcidBomb\\BottleImpact.mdl", AttachPoint.HEAD, EffectLevel.NORMAL)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\Parasite\\ParasiteTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Target\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Target\obj_this.j
static integer array ARMOR_INCREMENT
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Target\\this.wc3obj")
    set thistype.ARMOR_INCREMENT[1] = -3
    set thistype.ARMOR_INCREMENT[2] = -5
    set thistype.ARMOR_INCREMENT[3] = -7
    set thistype.ARMOR_INCREMENT[4] = -9
    set thistype.ARMOR_INCREMENT[5] = -11
    set thistype.DURATION[1] = 5
    set thistype.DURATION[2] = 5
    set thistype.DURATION[3] = 5
    set thistype.DURATION[4] = 5
    set thistype.DURATION[5] = 5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Target\obj_this.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod