static constant integer TARGET_DUMMY_UNIT_ID = 'qBST'
    
    
static method Init_obj_targetDummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\BatSwarm.page\\BatSwarm.struct\\targetDummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\BatSwarm.page\\BatSwarm.struct\\targetDummyUnit.wc3unit")
    call t.Destroy()
endmethod