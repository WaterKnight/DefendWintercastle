//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar.page\FrozenStar.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer array MAX_LENGTH
static real CASTER_SIGHT_D_FACTOR = 0.1
static integer array MOVING_AREA_RANGE
static real MAX_ANGLE_D = 0.25 * Math.QUARTER_ANGLE
static real INTERVAL = 0.035
static integer array SPEED
static integer ANGLE_D_FACTOR = 10
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FrozenStar.page\\FrozenStar.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AFrS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Frozen Star")
    call thistype.THIS_SPELL.SetOrder(OrderId("carrionswarm"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 400)
    call thistype.THIS_SPELL.SetCooldown(1, 9)
    call thistype.THIS_SPELL.SetManaCost(1, 55)
    call thistype.THIS_SPELL.SetRange(1, 700)
    call thistype.THIS_SPELL.SetAreaRange(2, 400)
    call thistype.THIS_SPELL.SetCooldown(2, 9)
    call thistype.THIS_SPELL.SetManaCost(2, 75)
    call thistype.THIS_SPELL.SetRange(2, 700)
    call thistype.THIS_SPELL.SetAreaRange(3, 400)
    call thistype.THIS_SPELL.SetCooldown(3, 9)
    call thistype.THIS_SPELL.SetManaCost(3, 95)
    call thistype.THIS_SPELL.SetRange(3, 700)
    call thistype.THIS_SPELL.SetAreaRange(4, 400)
    call thistype.THIS_SPELL.SetCooldown(4, 9)
    call thistype.THIS_SPELL.SetManaCost(4, 115)
    call thistype.THIS_SPELL.SetRange(4, 700)
    call thistype.THIS_SPELL.SetAreaRange(5, 400)
    call thistype.THIS_SPELL.SetCooldown(5, 9)
    call thistype.THIS_SPELL.SetManaCost(5, 135)
    call thistype.THIS_SPELL.SetRange(5, 700)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNStaffOfNegation.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FFS0', 5, 'VFS0')
    
    set thistype.MAX_LENGTH[1] = 700
    set thistype.MAX_LENGTH[2] = 700
    set thistype.MAX_LENGTH[3] = 700
    set thistype.MAX_LENGTH[4] = 700
    set thistype.MAX_LENGTH[5] = 700
    set thistype.MOVING_AREA_RANGE[1] = 200
    set thistype.MOVING_AREA_RANGE[2] = 200
    set thistype.MOVING_AREA_RANGE[3] = 200
    set thistype.MOVING_AREA_RANGE[4] = 200
    set thistype.MOVING_AREA_RANGE[5] = 200
    set thistype.SPEED[1] = 600
    set thistype.SPEED[2] = 600
    set thistype.SPEED[3] = 600
    set thistype.SPEED[4] = 600
    set thistype.SPEED[5] = 600
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FrozenStar.page\\FrozenStar.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar.page\FrozenStar.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar.page\FrozenStar.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qFrS'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FrozenStar.page\\FrozenStar.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FrozenStar.page\\FrozenStar.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar.page\FrozenStar.struct\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod