static Spell THIS_SPELL
    
static real HEAL_FACTOR = 0.25
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\FuniculusUmbilicalis\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AInS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Funiculus Umbilicalis")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDoom.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\FuniculusUmbilicalis\\thisSpell.wc3spell")
    call t.Destroy()
endmethod