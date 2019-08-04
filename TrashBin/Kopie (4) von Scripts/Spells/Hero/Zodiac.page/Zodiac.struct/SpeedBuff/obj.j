//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Zodiac.page\Zodiac.struct\SpeedBuff\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Zodiac.page\\Zodiac.struct\\SpeedBuff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BZBS', "Zodiac", 'bZBS')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNRacoon.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Units\\NightElf\\Owl\\Owl.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Zodiac.page\\Zodiac.struct\\SpeedBuff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Zodiac.page\Zodiac.struct\SpeedBuff\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Zodiac.page\Zodiac.struct\SpeedBuff\obj_this.j
static real array SPEED_RELATIVE_INCREMENT
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Zodiac.page\\Zodiac.struct\\SpeedBuff\\this.wc3obj")
    set thistype.SPEED_RELATIVE_INCREMENT[1] = 0.25
    set thistype.SPEED_RELATIVE_INCREMENT[2] = 0.35
    set thistype.SPEED_RELATIVE_INCREMENT[3] = 0.4
    set thistype.SPEED_RELATIVE_INCREMENT[4] = 0.45
    set thistype.SPEED_RELATIVE_INCREMENT[5] = 0.5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Zodiac.page\\Zodiac.struct\\SpeedBuff\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Zodiac.page\Zodiac.struct\SpeedBuff\obj_this.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod