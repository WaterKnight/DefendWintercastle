static real HEAL_LIFE_RELATIVE_AMOUNT = 0.15
static integer AREA_RANGE = 200
static integer SPAWN_AMOUNT_FOR_RUNE = 12
static integer DURATION = 20
static string AREA_EFFECT_PATH = "Abilities\\Spells\\Other\\Andt\\Andt.mdl"
static real HEAL_MANA_RELATIVE_AMOUNT = 0.15
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Rune.page\\Rune.struct\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Rune.page\\Rune.struct\\this.wc3obj")
    call t.Destroy()
endmethod