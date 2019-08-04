//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WanShroud.page\WanShroud.struct\Target\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WanShroud.page\\WanShroud.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BWSh', "Wan Shroud", 'bWSh')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCyclone.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WanShroud.page\\WanShroud.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WanShroud.page\WanShroud.struct\Target\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WanShroud.page\WanShroud.struct\Target\obj_this.j
static integer array MISS_INCREMENT
static real array ARMOR_INCREMENT
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WanShroud.page\\WanShroud.struct\\Target\\this.wc3obj")
    set thistype.MISS_INCREMENT[1] = 30
    set thistype.MISS_INCREMENT[2] = 60
    set thistype.MISS_INCREMENT[3] = 90
    set thistype.MISS_INCREMENT[4] = 120
    set thistype.MISS_INCREMENT[5] = 150
    set thistype.ARMOR_INCREMENT[1] = -0.25
    set thistype.ARMOR_INCREMENT[2] = -0.25
    set thistype.ARMOR_INCREMENT[3] = -0.25
    set thistype.ARMOR_INCREMENT[4] = -0.25
    set thistype.ARMOR_INCREMENT[5] = -0.25
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WanShroud.page\\WanShroud.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WanShroud.page\WanShroud.struct\Target\obj_this.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod