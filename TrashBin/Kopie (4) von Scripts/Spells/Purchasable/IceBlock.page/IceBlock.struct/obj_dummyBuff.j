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