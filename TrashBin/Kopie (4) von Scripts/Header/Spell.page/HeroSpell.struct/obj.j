//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_slots[2].j

static method Init_obj_slots2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[2].wc3spell")
    call InitAbility('AHS2')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[2].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_slots[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_slots[4].j

static method Init_obj_slots4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[4].wc3spell")
    call InitAbility('AHS4')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[4].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_slots[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_slots[1].j

static method Init_obj_slots1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[1].wc3spell")
    call InitAbility('AHS1')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[1].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_slots[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_slots[3].j

static method Init_obj_slots3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[3].wc3spell")
    call InitAbility('AHS3')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[3].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_slots[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_spellReplacerBuff.j
static constant integer SPELL_REPLACER_BUFF_ID = 'BHSR'
    
    
static method Init_obj_spellReplacerBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\spellReplacerBuff.wc3buff")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\spellReplacerBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_spellReplacerBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_slots[0].j
static integer array SLOTS_ID
    
    
static method Init_obj_slots0 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[0].wc3spell")
    call InitAbility('AHS0')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[0].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_slots[0].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_this.j
static integer SLOT_ID = 'AHS0'
static integer MAX_SLOTS = 5
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\HeroSpell.struct\obj_this.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_slots2)
    call Spell.AddInit(function thistype.Init_obj_slots4)
    call Spell.AddInit(function thistype.Init_obj_slots1)
    call Spell.AddInit(function thistype.Init_obj_slots3)
    call Buff.AddInit(function thistype.Init_obj_spellReplacerBuff)
    call Spell.AddInit(function thistype.Init_obj_slots0)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod