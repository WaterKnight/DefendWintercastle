//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\EnergyCharge.page\EnergyCharge.struct\Target\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\EnergyCharge.page\\EnergyCharge.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BEnC', "Energy Charge", 'bEnC')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSeaGiantPulverize.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\GreenDragonMissile\\GreenDragonMissile.mdl", AttachPoint.HAND_RIGHT, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\EnergyCharge.page\\EnergyCharge.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\EnergyCharge.page\EnergyCharge.struct\Target\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\EnergyCharge.page\EnergyCharge.struct\Target\obj_this.j
static integer HEAL = 30
static integer DAMAGE_INCREMENT = 25
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\EnergyCharge.page\\EnergyCharge.struct\\Target\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\EnergyCharge.page\\EnergyCharge.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\EnergyCharge.page\EnergyCharge.struct\Target\obj_this.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod