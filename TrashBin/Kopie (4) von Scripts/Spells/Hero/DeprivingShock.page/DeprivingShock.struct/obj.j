//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.struct\obj_this.j
static real TRANSFERED_MANA_FACTOR = 0.5
static integer array STUN_DURATION
static string EFFECT_LIGHTNING_PATH = "MBUR"
static integer array BURNED_MANA
static integer array DAMAGE
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\this.wc3obj")
    set thistype.STUN_DURATION[1] = 1
    set thistype.STUN_DURATION[2] = 1
    set thistype.STUN_DURATION[3] = 1
    set thistype.STUN_DURATION[4] = 1
    set thistype.STUN_DURATION[5] = 1
    set thistype.BURNED_MANA[1] = 65
    set thistype.BURNED_MANA[2] = 100
    set thistype.BURNED_MANA[3] = 140
    set thistype.BURNED_MANA[4] = 185
    set thistype.BURNED_MANA[5] = 235
    set thistype.DAMAGE[1] = 20
    set thistype.DAMAGE[2] = 30
    set thistype.DAMAGE[3] = 45
    set thistype.DAMAGE[4] = 60
    set thistype.DAMAGE[5] = 75
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.struct\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ADeS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_SECOND)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Depriving Shock")
    call thistype.THIS_SPELL.SetOrder(OrderId("darkconversion"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 150)
    call thistype.THIS_SPELL.SetChannelTime(1, 0.5)
    call thistype.THIS_SPELL.SetCooldown(1, 4)
    call thistype.THIS_SPELL.SetManaCost(1, 30)
    call thistype.THIS_SPELL.SetRange(1, 375)
    call thistype.THIS_SPELL.SetAreaRange(2, 175)
    call thistype.THIS_SPELL.SetChannelTime(2, 0.5)
    call thistype.THIS_SPELL.SetCooldown(2, 4)
    call thistype.THIS_SPELL.SetManaCost(2, 45)
    call thistype.THIS_SPELL.SetRange(2, 375)
    call thistype.THIS_SPELL.SetAreaRange(3, 200)
    call thistype.THIS_SPELL.SetChannelTime(3, 0.5)
    call thistype.THIS_SPELL.SetCooldown(3, 4)
    call thistype.THIS_SPELL.SetManaCost(3, 60)
    call thistype.THIS_SPELL.SetRange(3, 375)
    call thistype.THIS_SPELL.SetAreaRange(4, 225)
    call thistype.THIS_SPELL.SetChannelTime(4, 0.5)
    call thistype.THIS_SPELL.SetCooldown(4, 4)
    call thistype.THIS_SPELL.SetManaCost(4, 75)
    call thistype.THIS_SPELL.SetRange(4, 375)
    call thistype.THIS_SPELL.SetAreaRange(5, 250)
    call thistype.THIS_SPELL.SetChannelTime(5, 0.5)
    call thistype.THIS_SPELL.SetCooldown(5, 4)
    call thistype.THIS_SPELL.SetManaCost(5, 90)
    call thistype.THIS_SPELL.SetRange(5, 375)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNRavenForm.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FDS0', 5, 'VDS0')
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod