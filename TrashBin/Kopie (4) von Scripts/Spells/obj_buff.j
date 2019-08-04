static Buff BUFF
    
static string SFX0
static string SFX0_LEVEL
static string SFX0_ATTACH_PT
    
static method Init_obj_buff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\buff.wc3buff")
    set thistype.BUFF = Buff.CreateHidden(thistype.NAME + " (buff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\buff.wc3buff")
    call t.Destroy()
endmethod