static Buff NORMAL_BUFF
    
    
static method Init_obj_normalBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\normalBuff.wc3buff")
    set thistype.NORMAL_BUFF = Buff.CreateHidden(thistype.NAME + " (normalBuff)")
    call thistype.NORMAL_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\StasisTrap\\StasisTotemTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\normalBuff.wc3buff")
    call t.Destroy()
endmethod