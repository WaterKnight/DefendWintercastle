static constant integer SPELL_REPLACER_BUFF_ID = 'BHSR'
    
    
static method Init_obj_spellReplacerBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\spellReplacerBuff.wc3buff")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\spellReplacerBuff.wc3buff")
    call t.Destroy()
endmethod