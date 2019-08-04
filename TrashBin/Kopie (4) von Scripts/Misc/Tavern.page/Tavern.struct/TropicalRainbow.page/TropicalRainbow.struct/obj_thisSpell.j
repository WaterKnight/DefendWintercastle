static Spell THIS_SPELL
    
static real MANA_REGEN_REL_INC = 0.5
static real LIFE_REGEN_REL_INC = 0.5
static real SPEED_REL_INC = 0.2
static real SPELL_POWER_REL_INC = 0.2
static integer DURATION = 60
static real DAMAGE_REL_INC = 0.2
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Tavern.page\\Tavern.struct\\TropicalRainbow.page\\TropicalRainbow.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ATrR')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ITEM)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Tropical Rainbow")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 60)
    call thistype.THIS_SPELL.SetRange(1, 750)
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Tavern.page\\Tavern.struct\\TropicalRainbow.page\\TropicalRainbow.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod