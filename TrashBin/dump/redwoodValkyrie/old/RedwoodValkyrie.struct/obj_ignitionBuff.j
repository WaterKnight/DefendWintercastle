static Buff IGNITION_BUFF
    
    
static method Init_obj_ignitionBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\RedwoodValkyrie.page\\old\\RedwoodValkyrie.struct\\ignitionBuff.wc3buff")
    set thistype.IGNITION_BUFF = Buff.CreateHidden(thistype.NAME + " (ignitionBuff)")
    call thistype.IGNITION_BUFF.SetLostOnDeath(true)
    call thistype.IGNITION_BUFF.SetLostOnDispel(true)
    call t.Destroy()
endmethod