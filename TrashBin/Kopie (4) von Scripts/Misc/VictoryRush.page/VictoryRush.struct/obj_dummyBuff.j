static Buff DUMMY_BUFF
    
static integer AREA_RANGE = 400
static real MOVEMENT_SPEED_INCREMENT = 0.2
static integer DURATION = 15
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
static real ATTACK_SPEED_INCREMENT = 0.3
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\VictoryRush.page\\VictoryRush.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BViR', "Victory Rush", 'bViR')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBattleRoar.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\NightElf\\BattleRoar\\RoarTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\VictoryRush.page\\VictoryRush.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod