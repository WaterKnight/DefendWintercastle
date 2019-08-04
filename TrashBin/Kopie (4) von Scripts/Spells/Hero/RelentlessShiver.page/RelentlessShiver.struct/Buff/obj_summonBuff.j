static Buff SUMMON_BUFF
    
    
static method Init_obj_summonBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Buff\\summonBuff.wc3buff")
    set thistype.SUMMON_BUFF = Buff.Create('BDRS', "Awakened", 'bDRS')
    call thistype.SUMMON_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAnimateDead.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Buff\\summonBuff.wc3buff")
    call t.Destroy()
endmethod