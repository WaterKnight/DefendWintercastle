static Spell THIS_SPELL
    
static integer SPECIAL_EFFECT_PERIMETER_INTERVAL = 200
static real INTERVAL = 0.125
static integer WAVES_AMOUNT = 10
static integer MAX_RADIUS = 600
static string SPECIAL_EFFECT_PATH = "Abilities\\\\Spells\\\\NightElf\\\\EntanglingRoots\\\\EntanglingRootsTarget.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\GreenNova.page\\GreenNova.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AGrN')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Green Nova")
    call thistype.THIS_SPELL.SetOrder(OrderId("entanglingroots"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 20)
    call thistype.THIS_SPELL.SetManaCost(1, 400)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNEntanglingRoots.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\GreenNova.page\\GreenNova.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod