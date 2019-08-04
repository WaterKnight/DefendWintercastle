//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Avatar.page\Avatar.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static real LIFE_LEECH_SPELL_POWER_MOD_FACTOR = 0.125
static integer array DAMAGE_INCREMENT
static integer LIFE_SPELL_POWER_MOD_FACTOR = 3
static integer SCALE_DURATION = 1
static integer array LIFE_INCREMENT
static integer array DURATION
static real array ARMOR_INCREMENT
static integer array LIFE_LEECH_INCREMENT
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl"
static real array SCALE_INCREMENT
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Avatar.page\\Avatar.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AAva')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE)
    call thistype.THIS_SPELL.SetLevelsAmount(3)
    call thistype.THIS_SPELL.SetName("Avatar")
    call thistype.THIS_SPELL.SetOrder(OrderId("avatar"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 70)
    call thistype.THIS_SPELL.SetManaCost(1, 125)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 70)
    call thistype.THIS_SPELL.SetManaCost(2, 125)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetCooldown(3, 70)
    call thistype.THIS_SPELL.SetManaCost(3, 125)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAvatar.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FAv0', 3, 'VAv0')
    
    set thistype.DAMAGE_INCREMENT[1] = 20
    set thistype.DAMAGE_INCREMENT[2] = 30
    set thistype.DAMAGE_INCREMENT[3] = 40
    set thistype.LIFE_INCREMENT[1] = 500
    set thistype.LIFE_INCREMENT[2] = 750
    set thistype.LIFE_INCREMENT[3] = 1000
    set thistype.DURATION[1] = 30
    set thistype.DURATION[2] = 45
    set thistype.DURATION[3] = 60
    set thistype.ARMOR_INCREMENT[1] = 5
    set thistype.ARMOR_INCREMENT[2] = 7.5
    set thistype.ARMOR_INCREMENT[3] = 10
    set thistype.LIFE_LEECH_INCREMENT[1] = 5
    set thistype.LIFE_LEECH_INCREMENT[2] = 10
    set thistype.LIFE_LEECH_INCREMENT[3] = 15
    set thistype.SCALE_INCREMENT[1] = 0.3
    set thistype.SCALE_INCREMENT[2] = 0.5
    set thistype.SCALE_INCREMENT[3] = 0.7
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Avatar.page\\Avatar.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Avatar.page\Avatar.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Avatar.page\Avatar.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Avatar.page\\Avatar.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BAva', "Avatar", 'bAva')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAvatar.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkTarget.mdl", AttachPoint.CHEST, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Avatar.page\\Avatar.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Avatar.page\Avatar.struct\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod