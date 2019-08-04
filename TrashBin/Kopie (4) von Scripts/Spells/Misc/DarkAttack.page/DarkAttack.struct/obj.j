//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\DarkAttack.page\DarkAttack.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer array HERO_DURATION
static integer array DURATION
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\DarkAttack.page\\DarkAttack.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ADaA')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(6)
    call thistype.THIS_SPELL.SetName("Dark Attack")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetRange(6, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSoulGem.blp")
    
    set thistype.HERO_DURATION[1] = 3
    set thistype.HERO_DURATION[2] = 3
    set thistype.HERO_DURATION[3] = 3
    set thistype.HERO_DURATION[4] = 3
    set thistype.HERO_DURATION[5] = 3
    set thistype.HERO_DURATION[6] = 3
    set thistype.DURATION[1] = 6
    set thistype.DURATION[2] = 6
    set thistype.DURATION[3] = 6
    set thistype.DURATION[4] = 6
    set thistype.DURATION[5] = 6
    set thistype.DURATION[6] = 6
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\DarkAttack.page\\DarkAttack.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\DarkAttack.page\DarkAttack.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\DarkAttack.page\DarkAttack.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\DarkAttack.page\\DarkAttack.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\DarkAttack.page\\DarkAttack.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\DarkAttack.page\DarkAttack.struct\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod