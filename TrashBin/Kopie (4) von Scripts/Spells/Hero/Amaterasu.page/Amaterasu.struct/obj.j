//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Amaterasu.page\Amaterasu.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Amaterasu.page\\Amaterasu.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\LiquidFire\\Liquidfire.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Voodoo\\VoodooAura.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Amaterasu.page\\Amaterasu.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Amaterasu.page\Amaterasu.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Amaterasu.page\Amaterasu.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static real DAMAGE_AIR_FACTOR = 0.5
static real INTERVAL = 0.35
static integer array LIFE_INCREMENT
static integer array DAMAGE_ALL
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Amaterasu.page\\Amaterasu.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AAma')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE_EX)
    call thistype.THIS_SPELL.SetLevelsAmount(2)
    call thistype.THIS_SPELL.SetName("Amaterasu")
    call thistype.THIS_SPELL.SetOrder(OrderId("deathanddecay"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell,channel")
    call thistype.THIS_SPELL.SetAreaRange(1, 450)
    call thistype.THIS_SPELL.SetChannelTime(1, 15)
    call thistype.THIS_SPELL.SetCooldown(1, 90)
    call thistype.THIS_SPELL.SetManaCost(1, 145)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetAreaRange(2, 450)
    call thistype.THIS_SPELL.SetChannelTime(2, 15)
    call thistype.THIS_SPELL.SetCooldown(2, 90)
    call thistype.THIS_SPELL.SetManaCost(2, 210)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNOrbofSlowness.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FAm0', 2, 'VAm0')
    
    set thistype.LIFE_INCREMENT[1] = 300
    set thistype.LIFE_INCREMENT[2] = 500
    set thistype.DAMAGE_ALL[1] = 600
    set thistype.DAMAGE_ALL[2] = 900
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Amaterasu.page\\Amaterasu.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Amaterasu.page\Amaterasu.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod