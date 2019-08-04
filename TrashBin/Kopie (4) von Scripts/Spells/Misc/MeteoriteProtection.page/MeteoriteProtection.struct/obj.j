//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\MeteoriteProtection.page\MeteoriteProtection.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string SPEED_INCREMENT
static string DURATION
static string CRITICAL_INCREMENT
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\MeteoriteProtection.page\\MeteoriteProtection.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AMtP')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Meteorite Protection")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetRange(1, 750)
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\MeteoriteProtection.page\\MeteoriteProtection.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\MeteoriteProtection.page\MeteoriteProtection.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod