static Spell THIS_SPELL
    
static string CASTER_EFFECT_PATH = "Abilities\\Spells\\Items\\AIvi\\AIviTarget.mdl"
static integer array DURATION
static string CASTER_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static integer array MOVE_SPEED_INCREMENT
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\SilentBoots.page\\SilentBoots.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASiB')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ARTIFACT)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Silent Boots")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 25)
    call thistype.THIS_SPELL.SetManaCost(1, 50)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 22)
    call thistype.THIS_SPELL.SetManaCost(2, 50)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetCooldown(3, 19)
    call thistype.THIS_SPELL.SetManaCost(3, 50)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetCooldown(4, 16)
    call thistype.THIS_SPELL.SetManaCost(4, 50)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetCooldown(5, 13)
    call thistype.THIS_SPELL.SetManaCost(5, 50)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSlippersOfAgility.blp")
    
    set thistype.DURATION[1] = 5
    set thistype.DURATION[2] = 6
    set thistype.DURATION[3] = 7
    set thistype.DURATION[4] = 8
    set thistype.DURATION[5] = 9
    set thistype.MOVE_SPEED_INCREMENT[1] = 50
    set thistype.MOVE_SPEED_INCREMENT[2] = 80
    set thistype.MOVE_SPEED_INCREMENT[3] = 110
    set thistype.MOVE_SPEED_INCREMENT[4] = 140
    set thistype.MOVE_SPEED_INCREMENT[5] = 170
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\SilentBoots.page\\SilentBoots.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod