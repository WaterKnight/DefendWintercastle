static Buff ILLUSION_BUFF
    
    
static method Init_obj_illusionBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\illusionBuff.wc3buff")
    set thistype.ILLUSION_BUFF = Buff.Create('BDGI', "Doppelganger", 'bDGI')
    call thistype.ILLUSION_BUFF.SetPositive(true)
    call thistype.ILLUSION_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDoom.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\illusionBuff.wc3buff")
    call t.Destroy()
endmethod