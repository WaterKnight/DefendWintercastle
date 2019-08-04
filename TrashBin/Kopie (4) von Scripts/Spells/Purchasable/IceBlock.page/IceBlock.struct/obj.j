//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\IceBlock.page\IceBlock.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer array LIFE_REGEN_INC
static real array DURATION
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\IceBlock.page\\IceBlock.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AIcB')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Ice Block")
    call thistype.THIS_SPELL.SetOrder(OrderId("hex"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 15)
    call thistype.THIS_SPELL.SetManaCost(1, 30)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 15)
    call thistype.THIS_SPELL.SetManaCost(2, 35)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetCooldown(3, 15)
    call thistype.THIS_SPELL.SetManaCost(3, 40)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetCooldown(4, 15)
    call thistype.THIS_SPELL.SetManaCost(4, 45)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetCooldown(5, 15)
    call thistype.THIS_SPELL.SetManaCost(5, 50)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNIcyTreasureBox.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FIB0', 5, 'VIB0')
    
    set thistype.LIFE_REGEN_INC[1] = 5
    set thistype.LIFE_REGEN_INC[2] = 10
    set thistype.LIFE_REGEN_INC[3] = 15
    set thistype.LIFE_REGEN_INC[4] = 20
    set thistype.LIFE_REGEN_INC[5] = 25
    set thistype.DURATION[1] = 5
    set thistype.DURATION[2] = 5.5
    set thistype.DURATION[3] = 6
    set thistype.DURATION[4] = 6.5
    set thistype.DURATION[5] = 7
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\IceBlock.page\\IceBlock.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\IceBlock.page\IceBlock.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\IceBlock.page\IceBlock.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\IceBlock.page\\IceBlock.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BIcB', "Ice Block", 'bIcB')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNIcyTreasureBox.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathTargetArt.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Items\\StaffOfSanctuary\\Staff_Sanctuary_Target.mdl", AttachPoint.CHEST, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\IceBlock.page\\IceBlock.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\IceBlock.page\IceBlock.struct\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod