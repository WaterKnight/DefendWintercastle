static Buff NORMAL_BUFF
    
    
static method Init_obj_normalBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Stun\\normalBuff.wc3buff")
    set thistype.NORMAL_BUFF = Buff.Create('BStu', "Stunned", 'bStu')
    call thistype.NORMAL_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNStun.blp")
    call thistype.NORMAL_BUFF.TargetEffects.Add("Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Stun\\normalBuff.wc3buff")
    call t.Destroy()
endmethod