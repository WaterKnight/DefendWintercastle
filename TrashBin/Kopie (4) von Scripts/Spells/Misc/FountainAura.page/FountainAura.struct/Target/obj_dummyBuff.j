static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FountainAura.page\\FountainAura.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BFoA', "Healed", 'bFoA')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHeal.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\ANrm\\ANrmTarget.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FountainAura.page\\FountainAura.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod