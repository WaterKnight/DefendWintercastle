//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Crippling.page\Crippling.struct\Target\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Crippling.page\\Crippling.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BCrp', "Crippled", 'bCrp')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDispelMagic.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Spells\\Crippling\\Target.mdx", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Crippling.page\\Crippling.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Crippling.page\Crippling.struct\Target\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Crippling.page\Crippling.struct\Target\obj_this.j
static string DAMAGE_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string DAMAGE_EFFECT_PATH = "Abilities\\Spells\\Undead\\OrbOfDeath\\AnnihilationMissile.mdl"
static real array DAMAGE_FACTOR
static integer array DAMAGE
static integer array DURATION
static real array DAMAGE_RELATIVE_INCREMENT
static real array ATTACK_SPEED_INCREMENT
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Crippling.page\\Crippling.struct\\Target\\this.wc3obj")
    set thistype.DAMAGE_FACTOR[1] = 0.06
    set thistype.DAMAGE_FACTOR[2] = 0.07
    set thistype.DAMAGE_FACTOR[3] = 0.08
    set thistype.DAMAGE_FACTOR[4] = 0.09
    set thistype.DAMAGE_FACTOR[5] = 0.1
    set thistype.DAMAGE[1] = 20
    set thistype.DAMAGE[2] = 30
    set thistype.DAMAGE[3] = 40
    set thistype.DAMAGE[4] = 50
    set thistype.DAMAGE[5] = 60
    set thistype.DURATION[1] = 6
    set thistype.DURATION[2] = 6
    set thistype.DURATION[3] = 6
    set thistype.DURATION[4] = 6
    set thistype.DURATION[5] = 6
    set thistype.DAMAGE_RELATIVE_INCREMENT[1] = -0.3
    set thistype.DAMAGE_RELATIVE_INCREMENT[2] = -0.3
    set thistype.DAMAGE_RELATIVE_INCREMENT[3] = -0.3
    set thistype.DAMAGE_RELATIVE_INCREMENT[4] = -0.3
    set thistype.DAMAGE_RELATIVE_INCREMENT[5] = -0.3
    set thistype.ATTACK_SPEED_INCREMENT[1] = -0.5
    set thistype.ATTACK_SPEED_INCREMENT[2] = -0.55
    set thistype.ATTACK_SPEED_INCREMENT[3] = -0.6
    set thistype.ATTACK_SPEED_INCREMENT[4] = -0.65
    set thistype.ATTACK_SPEED_INCREMENT[5] = -0.7
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Crippling.page\\Crippling.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Crippling.page\Crippling.struct\Target\obj_this.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod