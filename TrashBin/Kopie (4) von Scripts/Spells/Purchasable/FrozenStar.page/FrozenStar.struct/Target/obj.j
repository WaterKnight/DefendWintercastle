//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar.page\FrozenStar.struct\Target\obj_this.j
static integer array SPEED_INCREMENT
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FrozenStar.page\\FrozenStar.struct\\Target\\this.wc3obj")
    set thistype.SPEED_INCREMENT[1] = -90
    set thistype.SPEED_INCREMENT[2] = -90
    set thistype.SPEED_INCREMENT[3] = -90
    set thistype.SPEED_INCREMENT[4] = -90
    set thistype.SPEED_INCREMENT[5] = -90
    set thistype.DURATION[1] = 5
    set thistype.DURATION[2] = 8
    set thistype.DURATION[3] = 11
    set thistype.DURATION[4] = 14
    set thistype.DURATION[5] = 17
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FrozenStar.page\\FrozenStar.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar.page\FrozenStar.struct\Target\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar.page\FrozenStar.struct\Target\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FrozenStar.page\\FrozenStar.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BFrS', "Frozen Star", 'bFrS')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBreathOfFrost.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FrozenStar.page\\FrozenStar.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar.page\FrozenStar.struct\Target\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod