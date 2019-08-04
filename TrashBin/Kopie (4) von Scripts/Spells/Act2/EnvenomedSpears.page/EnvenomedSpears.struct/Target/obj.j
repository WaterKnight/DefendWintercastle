//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\EnvenomedSpears.page\EnvenomedSpears.struct\Target\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\EnvenomedSpears.page\\EnvenomedSpears.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BEnS', "Poisoned", 'bEnS')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNEnvenomedSpear.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\EnvenomedSpears.page\\EnvenomedSpears.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\EnvenomedSpears.page\EnvenomedSpears.struct\Target\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\EnvenomedSpears.page\EnvenomedSpears.struct\Target\obj_this.j
static real INTERVAL = 0.5
static integer DURATION = 3
static integer DAMAGE_PER_SECOND = 20
static integer HERO_DURATION = 1
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\EnvenomedSpears.page\\EnvenomedSpears.struct\\Target\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\EnvenomedSpears.page\\EnvenomedSpears.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\EnvenomedSpears.page\EnvenomedSpears.struct\Target\obj_this.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod