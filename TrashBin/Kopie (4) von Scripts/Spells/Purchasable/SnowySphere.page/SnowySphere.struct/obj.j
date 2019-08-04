//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\SnowySphere.page\SnowySphere.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qSnS'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\SnowySphere.page\\SnowySphere.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\SnowySphere.page\\SnowySphere.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\SnowySphere.page\SnowySphere.struct\obj_dummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\SnowySphere.page\SnowySphere.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer SPAWN_OFFSET = -50
static integer array SPAWN_ANGLE_MAX_ADD
static integer array MAX_LENGTH
static integer array SPEED
static integer array SPAWN_AMOUNT
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\SnowySphere.page\\SnowySphere.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASnS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Snowy Sphere")
    call thistype.THIS_SPELL.SetOrder(OrderId("acidbomb"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 75)
    call thistype.THIS_SPELL.SetCooldown(1, 15)
    call thistype.THIS_SPELL.SetRange(1, 500)
    call thistype.THIS_SPELL.SetAreaRange(2, 75)
    call thistype.THIS_SPELL.SetCooldown(2, 15)
    call thistype.THIS_SPELL.SetRange(2, 500)
    call thistype.THIS_SPELL.SetAreaRange(3, 75)
    call thistype.THIS_SPELL.SetCooldown(3, 15)
    call thistype.THIS_SPELL.SetRange(3, 500)
    call thistype.THIS_SPELL.SetAreaRange(4, 75)
    call thistype.THIS_SPELL.SetCooldown(4, 15)
    call thistype.THIS_SPELL.SetRange(4, 500)
    call thistype.THIS_SPELL.SetAreaRange(5, 75)
    call thistype.THIS_SPELL.SetCooldown(5, 15)
    call thistype.THIS_SPELL.SetRange(5, 500)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNTornado.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FSS0', 5, 'VSS0')
    
    set thistype.SPAWN_ANGLE_MAX_ADD[1] = 14
    set thistype.SPAWN_ANGLE_MAX_ADD[2] = 14
    set thistype.SPAWN_ANGLE_MAX_ADD[3] = 14
    set thistype.SPAWN_ANGLE_MAX_ADD[4] = 14
    set thistype.SPAWN_ANGLE_MAX_ADD[5] = 14
    set thistype.MAX_LENGTH[1] = 800
    set thistype.MAX_LENGTH[2] = 800
    set thistype.MAX_LENGTH[3] = 800
    set thistype.MAX_LENGTH[4] = 800
    set thistype.MAX_LENGTH[5] = 800
    set thistype.SPEED[1] = 800
    set thistype.SPEED[2] = 800
    set thistype.SPEED[3] = 800
    set thistype.SPEED[4] = 800
    set thistype.SPEED[5] = 800
    set thistype.SPAWN_AMOUNT[1] = 20
    set thistype.SPAWN_AMOUNT[2] = 30
    set thistype.SPAWN_AMOUNT[3] = 40
    set thistype.SPAWN_AMOUNT[4] = 50
    set thistype.SPAWN_AMOUNT[5] = 60
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\SnowySphere.page\\SnowySphere.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\SnowySphere.page\SnowySphere.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod