//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer array SPELL_POWER_INCREMENT
static integer array DURATION
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AIfc')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_SECOND)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Infection")
    call thistype.THIS_SPELL.SetOrder(OrderId("stoneform"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 13)
    call thistype.THIS_SPELL.SetManaCost(1, 50)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 13)
    call thistype.THIS_SPELL.SetManaCost(2, 62)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetCooldown(3, 13)
    call thistype.THIS_SPELL.SetManaCost(3, 74)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetCooldown(4, 13)
    call thistype.THIS_SPELL.SetManaCost(4, 86)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetCooldown(5, 13)
    call thistype.THIS_SPELL.SetManaCost(5, 98)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDoom.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FIn0', 5, 'VIn0')
    
    set thistype.SPELL_POWER_INCREMENT[1] = 7
    set thistype.SPELL_POWER_INCREMENT[2] = 12
    set thistype.SPELL_POWER_INCREMENT[3] = 17
    set thistype.SPELL_POWER_INCREMENT[4] = 22
    set thistype.SPELL_POWER_INCREMENT[5] = 27
    set thistype.DURATION[1] = 8
    set thistype.DURATION[2] = 8
    set thistype.DURATION[3] = 9
    set thistype.DURATION[4] = 9
    set thistype.DURATION[5] = 10
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BInf', "Infection", 'bInf')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDoom.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Spells\\Infection\\Caster.mdx", AttachPoint.HEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod