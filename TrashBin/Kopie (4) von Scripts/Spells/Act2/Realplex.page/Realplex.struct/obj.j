//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Realplex.page\Realplex.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer OFFSET = 100
static integer ILLUSIONS_AMOUNT = 2
static real MOVE_DURATION = 0.5
static string CASTER_EFFECT_PATH = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl"
static integer DURATION = 10
static string CASTER_EFFECT_ATTACH_POINT = "AttachPoint.OVERHEAD"
static string DEATH_EFFECT_PATH = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Realplex.page\\Realplex.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AReP')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Realplex")
    call thistype.THIS_SPELL.SetOrder(OrderId("mirrorimage"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 10)
    call thistype.THIS_SPELL.SetManaCost(1, 50)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNInvisibility.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Realplex.page\\Realplex.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Realplex.page\Realplex.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod