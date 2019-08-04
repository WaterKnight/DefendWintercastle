//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\TempestStrike.page\TempestStrike.struct\CriticalAttacks\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\TempestStrike.page\\TempestStrike.struct\\CriticalAttacks\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BCrA', "Tempest Strike", 'bCrA')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCleavingAttack.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Spells\\TempestStrike\\Buff.mdx", AttachPoint.WEAPON, EffectLevel.LOW)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\IllidanMissile\\IllidanMissile.mdl", AttachPoint.WEAPON, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\TempestStrike.page\\TempestStrike.struct\\CriticalAttacks\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\TempestStrike.page\TempestStrike.struct\CriticalAttacks\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\TempestStrike.page\TempestStrike.struct\CriticalAttacks\obj_this.j
static real DURATION = 7.5
static integer array CRITICAL_INCREMENT
static real array ATTACK_SPEED_INCREMENT
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\TempestStrike.page\\TempestStrike.struct\\CriticalAttacks\\this.wc3obj")
    set thistype.CRITICAL_INCREMENT[1] = 40
    set thistype.CRITICAL_INCREMENT[2] = 60
    set thistype.CRITICAL_INCREMENT[3] = 80
    set thistype.CRITICAL_INCREMENT[4] = 100
    set thistype.CRITICAL_INCREMENT[5] = 120
    set thistype.ATTACK_SPEED_INCREMENT[1] = 0.25
    set thistype.ATTACK_SPEED_INCREMENT[2] = 0.4
    set thistype.ATTACK_SPEED_INCREMENT[3] = 0.65
    set thistype.ATTACK_SPEED_INCREMENT[4] = 0.8
    set thistype.ATTACK_SPEED_INCREMENT[5] = 0.95
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\TempestStrike.page\\TempestStrike.struct\\CriticalAttacks\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\TempestStrike.page\TempestStrike.struct\CriticalAttacks\obj_this.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod