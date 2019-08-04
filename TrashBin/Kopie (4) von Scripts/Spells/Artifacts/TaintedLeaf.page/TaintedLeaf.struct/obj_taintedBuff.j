static Buff TAINTED_BUFF
    
    
static method Init_obj_taintedBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\TaintedLeaf.page\\TaintedLeaf.struct\\taintedBuff.wc3buff")
    set thistype.TAINTED_BUFF = Buff.Create('BTaL', "Tainted Leaf", 'bTaL')
    call thistype.TAINTED_BUFF.SetPositive(true)
    call thistype.TAINTED_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNRejuvenation.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\TaintedLeaf.page\\TaintedLeaf.struct\\taintedBuff.wc3buff")
    call t.Destroy()
endmethod