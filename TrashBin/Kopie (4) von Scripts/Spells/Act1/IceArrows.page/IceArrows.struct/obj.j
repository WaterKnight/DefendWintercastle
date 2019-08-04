//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\IceArrows.page\IceArrows.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\IceArrows.page\\IceArrows.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\IceArrows.page\\IceArrows.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\IceArrows.page\IceArrows.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\IceArrows.page\IceArrows.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl"
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static integer DURATION = 6
static integer DAMAGE = 25
static integer HERO_DURATION = 3
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\IceArrows.page\\IceArrows.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AIcA')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Ice Arrows")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetManaCost(1, 20)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNColdArrowsOn.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\IceArrows.page\\IceArrows.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\IceArrows.page\IceArrows.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod