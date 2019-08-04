//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\BatSwarm.page\BatSwarm.struct\obj_enemyDummyUnit.j
static constant integer ENEMY_DUMMY_UNIT_ID = 'qBaS'
    
    
static method Init_obj_enemyDummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\BatSwarm.page\\BatSwarm.struct\\enemyDummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\BatSwarm.page\\BatSwarm.struct\\enemyDummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\BatSwarm.page\BatSwarm.struct\obj_enemyDummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\BatSwarm.page\BatSwarm.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string ENEMY_EFFECT_PATH = "Abilities\\Weapons\\LocustMissile\\LocustMissile.mdl"
static integer array ECLIPSE_DURATION
static integer array SPELL_SHIELD_DURATION
static integer array HEAL
static integer array MAX_ENEMIES_AMOUNT
static string ENEMY_EFFECT_ATTACH_POINT = "AttachPoint.CHEST"
static integer array DAMAGE
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\BatSwarm.page\\BatSwarm.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ABaS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ARTIFACT)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Bat Swarm")
    call thistype.THIS_SPELL.SetOrder(OrderId("sanctuary"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 400)
    call thistype.THIS_SPELL.SetCooldown(1, 14)
    call thistype.THIS_SPELL.SetManaCost(1, 75)
    call thistype.THIS_SPELL.SetRange(1, 800)
    call thistype.THIS_SPELL.SetAreaRange(2, 400)
    call thistype.THIS_SPELL.SetCooldown(2, 14)
    call thistype.THIS_SPELL.SetManaCost(2, 85)
    call thistype.THIS_SPELL.SetRange(2, 800)
    call thistype.THIS_SPELL.SetAreaRange(3, 400)
    call thistype.THIS_SPELL.SetCooldown(3, 14)
    call thistype.THIS_SPELL.SetManaCost(3, 95)
    call thistype.THIS_SPELL.SetRange(3, 800)
    call thistype.THIS_SPELL.SetAreaRange(4, 400)
    call thistype.THIS_SPELL.SetCooldown(4, 14)
    call thistype.THIS_SPELL.SetManaCost(4, 105)
    call thistype.THIS_SPELL.SetRange(4, 800)
    call thistype.THIS_SPELL.SetAreaRange(5, 400)
    call thistype.THIS_SPELL.SetCooldown(5, 14)
    call thistype.THIS_SPELL.SetManaCost(5, 115)
    call thistype.THIS_SPELL.SetRange(5, 800)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCarrionSwarm.blp")
    
    set thistype.ECLIPSE_DURATION[1] = 7
    set thistype.ECLIPSE_DURATION[2] = 7
    set thistype.ECLIPSE_DURATION[3] = 7
    set thistype.ECLIPSE_DURATION[4] = 7
    set thistype.ECLIPSE_DURATION[5] = 7
    set thistype.SPELL_SHIELD_DURATION[1] = 7
    set thistype.SPELL_SHIELD_DURATION[2] = 7
    set thistype.SPELL_SHIELD_DURATION[3] = 7
    set thistype.SPELL_SHIELD_DURATION[4] = 7
    set thistype.SPELL_SHIELD_DURATION[5] = 7
    set thistype.HEAL[1] = 20
    set thistype.HEAL[2] = 25
    set thistype.HEAL[3] = 30
    set thistype.HEAL[4] = 35
    set thistype.HEAL[5] = 40
    set thistype.MAX_ENEMIES_AMOUNT[1] = 3
    set thistype.MAX_ENEMIES_AMOUNT[2] = 3
    set thistype.MAX_ENEMIES_AMOUNT[3] = 3
    set thistype.MAX_ENEMIES_AMOUNT[4] = 3
    set thistype.MAX_ENEMIES_AMOUNT[5] = 3
    set thistype.DAMAGE[1] = 20
    set thistype.DAMAGE[2] = 30
    set thistype.DAMAGE[3] = 45
    set thistype.DAMAGE[4] = 65
    set thistype.DAMAGE[5] = 90
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\BatSwarm.page\\BatSwarm.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\BatSwarm.page\BatSwarm.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\BatSwarm.page\BatSwarm.struct\obj_targetDummyUnit.j
static constant integer TARGET_DUMMY_UNIT_ID = 'qBST'
    
    
static method Init_obj_targetDummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\BatSwarm.page\\BatSwarm.struct\\targetDummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\BatSwarm.page\\BatSwarm.struct\\targetDummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\BatSwarm.page\BatSwarm.struct\obj_targetDummyUnit.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_enemyDummyUnit)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_targetDummyUnit)
endmethod