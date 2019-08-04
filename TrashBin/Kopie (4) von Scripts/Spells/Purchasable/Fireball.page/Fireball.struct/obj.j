//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Fireball.page\Fireball.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static real MIN_DAMAGE_FACTOR = 0.4
static integer MIN_DAMAGE_RANGE = 1000
static integer DAMAGE_SPELL_POWER_MOD_FACTOR = 1
static integer array DAMAGE
static real FRIENDLY_FIRE_FACTOR = 0.4
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Fireball.page\\Fireball.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AFiB')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Fireball")
    call thistype.THIS_SPELL.SetOrder(OrderId("firebolt"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 150)
    call thistype.THIS_SPELL.SetCooldown(1, 6)
    call thistype.THIS_SPELL.SetManaCost(1, 15)
    call thistype.THIS_SPELL.SetRange(1, 700)
    call thistype.THIS_SPELL.SetAreaRange(2, 175)
    call thistype.THIS_SPELL.SetCooldown(2, 6)
    call thistype.THIS_SPELL.SetManaCost(2, 25)
    call thistype.THIS_SPELL.SetRange(2, 700)
    call thistype.THIS_SPELL.SetAreaRange(3, 200)
    call thistype.THIS_SPELL.SetCooldown(3, 6)
    call thistype.THIS_SPELL.SetManaCost(3, 35)
    call thistype.THIS_SPELL.SetRange(3, 700)
    call thistype.THIS_SPELL.SetAreaRange(4, 225)
    call thistype.THIS_SPELL.SetCooldown(4, 6)
    call thistype.THIS_SPELL.SetManaCost(4, 45)
    call thistype.THIS_SPELL.SetRange(4, 700)
    call thistype.THIS_SPELL.SetAreaRange(5, 250)
    call thistype.THIS_SPELL.SetCooldown(5, 6)
    call thistype.THIS_SPELL.SetManaCost(5, 55)
    call thistype.THIS_SPELL.SetRange(5, 700)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFireForTheCannon.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FFb0', 5, 'VFb0')
    
    set thistype.DAMAGE[1] = 55
    set thistype.DAMAGE[2] = 90
    set thistype.DAMAGE[3] = 125
    set thistype.DAMAGE[4] = 160
    set thistype.DAMAGE[5] = 195
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Fireball.page\\Fireball.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Fireball.page\Fireball.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Fireball.page\Fireball.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qFir'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Fireball.page\\Fireball.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Fireball.page\\Fireball.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Fireball.page\Fireball.struct\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod