static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\ColdResistance.page\\ColdResistance.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BCoR', "Cold Resistance", 'bCoR')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFreezingBreath.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\ColdResistance.page\\ColdResistance.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod