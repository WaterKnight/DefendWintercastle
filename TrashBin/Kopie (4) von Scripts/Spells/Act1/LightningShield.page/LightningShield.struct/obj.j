//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\LightningShield.page\LightningShield.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static real INTERVAL = 0.5
static integer DURATION = 20
static integer DAMAGE_PER_SECOND = 20
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LightningShield.page\\LightningShield.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ALiS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Lightning Shield")
    call thistype.THIS_SPELL.SetOrder(OrderId("lightningshield"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 130)
    call thistype.THIS_SPELL.SetCooldown(1, 25)
    call thistype.THIS_SPELL.SetManaCost(1, 120)
    call thistype.THIS_SPELL.SetRange(1, 900)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNLightningShield.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LightningShield.page\\LightningShield.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\LightningShield.page\LightningShield.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\LightningShield.page\LightningShield.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LightningShield.page\\LightningShield.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BLiS', "Lightning Shield", 'bLiS')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNLightningShield.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\LightningShield\\LightningShieldTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LightningShield.page\\LightningShield.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\LightningShield.page\LightningShield.struct\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod