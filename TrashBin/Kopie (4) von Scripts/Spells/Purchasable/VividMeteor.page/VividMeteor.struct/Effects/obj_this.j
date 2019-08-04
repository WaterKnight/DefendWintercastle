static integer ANGLE_START = 0
static real ANGLE_SPEED_OLD = 7.14
static real ANGLE_ACC = 1.43
static integer ANGLE_SPEED = 3
static integer DUMMY_UNITS_AMOUNT = 3
static integer OFFSET_START = 150
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\VividMeteor.page\\VividMeteor.struct\\Effects\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\VividMeteor.page\\VividMeteor.struct\\Effects\\this.wc3obj")
    call t.Destroy()
endmethod