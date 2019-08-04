static Buff POSSESSION_BUFF
    
static boolean SHOW_COUNTDOWN = true
    
static method Init_obj_possessionBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Snowmen.page\\Snowmen.struct\\possessionBuff.wc3buff")
    set thistype.POSSESSION_BUFF = Buff.Create('BPos', "Possession", 'bPos')
    call thistype.POSSESSION_BUFF.SetPositive(true)
    call thistype.POSSESSION_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNMagicalSentry.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Snowmen.page\\Snowmen.struct\\possessionBuff.wc3buff")
    call t.Destroy()
endmethod