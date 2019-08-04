static integer HEAL = 30
static integer DAMAGE_INCREMENT = 25
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\EnergyCharge.page\\EnergyCharge.struct\\Target\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\EnergyCharge.page\\EnergyCharge.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod