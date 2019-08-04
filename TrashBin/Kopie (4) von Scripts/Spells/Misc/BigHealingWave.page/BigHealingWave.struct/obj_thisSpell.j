static Spell THIS_SPELL
    
static real DELAY = 0.35
static string TARGET_EFFECT_PATH = "Spells\\BigHealingWave\\BigHealingWaveTarget.mdl"
static string EFFECT_LIGHTNING_PATH = "HWPB"
static real RESTORED_LIFE_FACTOR = 0.75
static integer TARGETS_AMOUNT = 100
static string EFFECT_LIGHTNING2_PATH = "HWSB"
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\BigHealingWave.page\\BigHealingWave.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ABHW')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Big Healing Wave")
    call thistype.THIS_SPELL.SetOrder(OrderId("healingwave"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 99999)
    call thistype.THIS_SPELL.SetCooldown(1, 15)
    call thistype.THIS_SPELL.SetManaCost(1, 100)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHealingWave.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\BigHealingWave.page\\BigHealingWave.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod