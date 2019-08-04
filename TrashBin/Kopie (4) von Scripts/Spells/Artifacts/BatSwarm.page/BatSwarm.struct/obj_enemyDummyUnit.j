static constant integer ENEMY_DUMMY_UNIT_ID = 'qBaS'
    
    
static method Init_obj_enemyDummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\BatSwarm.page\\BatSwarm.struct\\enemyDummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\BatSwarm.page\\BatSwarm.struct\\enemyDummyUnit.wc3unit")
    call t.Destroy()
endmethod