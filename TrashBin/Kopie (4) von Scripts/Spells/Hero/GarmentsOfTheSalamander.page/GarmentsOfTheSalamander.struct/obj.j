//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\GarmentsOfTheSalamander.page\GarmentsOfTheSalamander.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer array LIFE_REGEN_INCREMENT
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\GarmentsOfTheSalamander.page\\GarmentsOfTheSalamander.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASam')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_SECOND)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Garments of the Salamander")
    call thistype.THIS_SPELL.SetOrder(OrderId("evileye"))
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 3)
    call thistype.THIS_SPELL.SetManaCost(1, 15)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 3)
    call thistype.THIS_SPELL.SetManaCost(2, 15)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetCooldown(3, 3)
    call thistype.THIS_SPELL.SetManaCost(3, 15)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetCooldown(4, 3)
    call thistype.THIS_SPELL.SetManaCost(4, 15)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetCooldown(5, 3)
    call thistype.THIS_SPELL.SetManaCost(5, 15)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNThunderLizardSalamander.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FSa0', 5, 'VSa0')
    
    set thistype.LIFE_REGEN_INCREMENT[1] = 5
    set thistype.LIFE_REGEN_INCREMENT[2] = 8
    set thistype.LIFE_REGEN_INCREMENT[3] = 11
    set thistype.LIFE_REGEN_INCREMENT[4] = 14
    set thistype.LIFE_REGEN_INCREMENT[5] = 17
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\GarmentsOfTheSalamander.page\\GarmentsOfTheSalamander.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\GarmentsOfTheSalamander.page\GarmentsOfTheSalamander.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\GarmentsOfTheSalamander.page\GarmentsOfTheSalamander.struct\obj_revertSpell.j
static Spell REVERT_SPELL
    
    
static method Init_obj_revertSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\GarmentsOfTheSalamander.page\\GarmentsOfTheSalamander.struct\\revertSpell.wc3spell")
    set thistype.REVERT_SPELL = Spell.CreateFromSelf('ASaR')
    
    call thistype.REVERT_SPELL.SetClass(SpellClass.HERO_SECOND)
    call thistype.REVERT_SPELL.SetLevelsAmount(5)
    call thistype.REVERT_SPELL.SetName("Revert to Human Form")
    call thistype.REVERT_SPELL.SetOrder(OrderId("evileye"))
    call thistype.REVERT_SPELL.SetAnimation("spell")
    call thistype.REVERT_SPELL.SetCooldown(1, 3)
    call thistype.REVERT_SPELL.SetRange(1, 750)
    call thistype.REVERT_SPELL.SetCooldown(2, 3)
    call thistype.REVERT_SPELL.SetRange(2, 750)
    call thistype.REVERT_SPELL.SetCooldown(3, 3)
    call thistype.REVERT_SPELL.SetRange(3, 750)
    call thistype.REVERT_SPELL.SetCooldown(4, 3)
    call thistype.REVERT_SPELL.SetRange(4, 750)
    call thistype.REVERT_SPELL.SetCooldown(5, 3)
    call thistype.REVERT_SPELL.SetRange(5, 750)
    call thistype.REVERT_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHeroBloodElfPrince.blp")
    
    call HeroSpell.InitSpell(thistype.REVERT_SPELL, 'FSR0', 5, 'VSR0')
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\GarmentsOfTheSalamander.page\\GarmentsOfTheSalamander.struct\\revertSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\GarmentsOfTheSalamander.page\GarmentsOfTheSalamander.struct\obj_revertSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\GarmentsOfTheSalamander.page\GarmentsOfTheSalamander.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\GarmentsOfTheSalamander.page\\GarmentsOfTheSalamander.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\GarmentsOfTheSalamander.page\\GarmentsOfTheSalamander.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\GarmentsOfTheSalamander.page\GarmentsOfTheSalamander.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\GarmentsOfTheSalamander.page\GarmentsOfTheSalamander.struct\obj_thisUnitType.j
static UnitType THIS_UNIT_TYPE
    
    
static method Init_obj_thisUnitType takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\GarmentsOfTheSalamander.page\\GarmentsOfTheSalamander.struct\\thisUnitType.wc3unit")
    set thistype.THIS_UNIT_TYPE = UnitType.Create('USal')
    call thistype.THIS_UNIT_TYPE.Classes.Add(UnitClass.HERO)
    call thistype.THIS_UNIT_TYPE.Scale.Set(0.95)
    call thistype.THIS_UNIT_TYPE.VertexColor.Set(255, 150, 170, 255)
    call thistype.THIS_UNIT_TYPE.Impact.Z.Set(100)
    call thistype.THIS_UNIT_TYPE.Outpact.Z.Set(20)
    call thistype.THIS_UNIT_TYPE.Speed.Set(280)
    call thistype.THIS_UNIT_TYPE.Armor.Set(1)
    call thistype.THIS_UNIT_TYPE.Armor.Type.Set(Attack.ARMOR_TYPE_HERO)
    call thistype.THIS_UNIT_TYPE.Life.Set(100)
    call thistype.THIS_UNIT_TYPE.Life.SetBJ(100)
    call thistype.THIS_UNIT_TYPE.LifeRegeneration.Set(1)
    call thistype.THIS_UNIT_TYPE.Mana.Set(100)
    call thistype.THIS_UNIT_TYPE.Mana.SetBJ(100)
    call thistype.THIS_UNIT_TYPE.ManaRegeneration.Set(0)
    call thistype.THIS_UNIT_TYPE.SightRange.Set(1400)
    call thistype.THIS_UNIT_TYPE.SightRange.SetBJ(1400)
    call thistype.THIS_UNIT_TYPE.SpellPower.Set(15)
    call thistype.THIS_UNIT_TYPE.Attack.Set(Attack.NORMAL)
    call thistype.THIS_UNIT_TYPE.Attack.Range.Set(140)
    call thistype.THIS_UNIT_TYPE.Attack.Speed.SetByCooldown(1.8)
    call thistype.THIS_UNIT_TYPE.Damage.Delay.Set(0.5)
    call thistype.THIS_UNIT_TYPE.Damage.Set(29)
    call thistype.THIS_UNIT_TYPE.Damage.SetBJ(29)
    call thistype.THIS_UNIT_TYPE.Damage.Dices.Set(1)
    call thistype.THIS_UNIT_TYPE.Damage.Sides.Set(10)
    call thistype.THIS_UNIT_TYPE.Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.THIS_UNIT_TYPE.CollisionSize.Set(48)
    call thistype.THIS_UNIT_TYPE.Drop.Supply.Set(20)
    call thistype.THIS_UNIT_TYPE.Drop.Exp.Set(10)
    call thistype.THIS_UNIT_TYPE.Hero.Agility.Set(6)
    call thistype.THIS_UNIT_TYPE.Hero.Agility.PerLevel.Set(2.5)
    call thistype.THIS_UNIT_TYPE.Hero.ArmorPerLevel.Set(0.8)
    call thistype.THIS_UNIT_TYPE.Hero.Intelligence.Set(16)
    call thistype.THIS_UNIT_TYPE.Hero.Intelligence.PerLevel.Set(4.5)
    call thistype.THIS_UNIT_TYPE.Hero.Strength.Set(9)
    call thistype.THIS_UNIT_TYPE.Hero.Strength.PerLevel.Set(3.5)
    call thistype.THIS_UNIT_TYPE.Abilities.Add(WaterBindings(NULL).THIS_SPELL)
    call thistype.THIS_UNIT_TYPE.Abilities.Add(GarmentsOfTheSalamander(NULL).THIS_SPELL)
    call thistype.THIS_UNIT_TYPE.Abilities.Add(NegationWave(NULL).THIS_SPELL)
    call thistype.THIS_UNIT_TYPE.Abilities.Add(Tsukuyomi(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\GarmentsOfTheSalamander.page\\GarmentsOfTheSalamander.struct\\thisUnitType.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\GarmentsOfTheSalamander.page\GarmentsOfTheSalamander.struct\obj_thisUnitType.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Spell.AddInit(function thistype.Init_obj_revertSpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call UnitType.AddInit(function thistype.Init_obj_thisUnitType)
endmethod