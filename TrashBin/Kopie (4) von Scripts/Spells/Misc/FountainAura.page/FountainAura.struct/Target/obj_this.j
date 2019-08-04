static integer LIFE_REGEN_REL_INC = 4
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FountainAura.page\\FountainAura.struct\\Target\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FountainAura.page\\FountainAura.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod