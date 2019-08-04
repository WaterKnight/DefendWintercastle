//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BurningSpiritMeteorite.page\BurningSpiritMeteorite.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qBSp'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\BurningSpiritMeteorite.page\\BurningSpiritMeteorite.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\BurningSpiritMeteorite.page\\BurningSpiritMeteorite.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BurningSpiritMeteorite.page\BurningSpiritMeteorite.struct\obj_dummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BurningSpiritMeteorite.page\BurningSpiritMeteorite.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\BurningSpiritMeteorite.page\\BurningSpiritMeteorite.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BBu2', "Burning Spirit", 'bBu2')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNIncinerate.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustSpecial.mdl", AttachPoint.HAND_LEFT, EffectLevel.LOW)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustSpecial.mdl", AttachPoint.HAND_RIGHT, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\BurningSpiritMeteorite.page\\BurningSpiritMeteorite.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BurningSpiritMeteorite.page\BurningSpiritMeteorite.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BurningSpiritMeteorite.page\BurningSpiritMeteorite.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static real CRITICAL_INC = 0.25
static integer DURATION = 20
static real SPEED_REL_INC = 0.25
static real ATTACK_RATE_INC = 0.25
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\BurningSpiritMeteorite.page\\BurningSpiritMeteorite.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ABuM')
    
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Burning Spirit (Meteorite)")
    call thistype.THIS_SPELL.SetOrder(OrderId("bloodlust"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 60)
    call thistype.THIS_SPELL.SetManaCost(1, 60)
    call thistype.THIS_SPELL.SetRange(1, 99999)
    call thistype.THIS_SPELL.SetCooldown(2, 60)
    call thistype.THIS_SPELL.SetManaCost(2, 60)
    call thistype.THIS_SPELL.SetRange(2, 99999)
    call thistype.THIS_SPELL.SetCooldown(3, 60)
    call thistype.THIS_SPELL.SetManaCost(3, 60)
    call thistype.THIS_SPELL.SetRange(3, 99999)
    call thistype.THIS_SPELL.SetCooldown(4, 60)
    call thistype.THIS_SPELL.SetManaCost(4, 60)
    call thistype.THIS_SPELL.SetRange(4, 99999)
    call thistype.THIS_SPELL.SetCooldown(5, 60)
    call thistype.THIS_SPELL.SetManaCost(5, 60)
    call thistype.THIS_SPELL.SetRange(5, 99999)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNIncinerate.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\BurningSpiritMeteorite.page\\BurningSpiritMeteorite.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BurningSpiritMeteorite.page\BurningSpiritMeteorite.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod