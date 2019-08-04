struct preplaced
implement Allocation
implement List
static thistype unit_36
static thistype unit_16
static thistype unit_2
static thistype unit_3
static thistype unit_34
static thistype unit_5
static thistype unit_6
static thistype unit_15
static thistype unit_0
static thistype unit_8
static thistype unit_9
static thistype unit_10
static thistype unit_11
static thistype unit_12
static thistype unit_13
static thistype unit_38
static thistype unit_90
static thistype unit_17
static thistype unit_33
static thistype unit_50
static thistype unit_65
static thistype unit_23
static thistype unit_51
static thistype unit_46
static thistype unit_14
static thistype unit_32
static thistype unit_35
static thistype unit_4
static thistype unit_1
static thistype unit_39
static thistype unit_40
static thistype unit_42
static thistype unit_45
static thistype unit_29
static thistype unit_44
static thistype unit_86
static thistype unit_134
static thistype unit_7
static thistype unit_22
static thistype unit_18
static thistype unit_83
static thistype unit_49
static thistype unit_88
static thistype unit_87
static thistype unit_99
static thistype unit_69
static thistype unit_67
static thistype unit_66
static thistype unit_31
static thistype unit_68
static thistype unit_122
static thistype unit_115
static thistype unit_106
static thistype unit_110
static thistype unit_97
static thistype unit_123
static thistype unit_102
static thistype unit_112
static thistype unit_111
static thistype unit_114
static thistype unit_132
static thistype unit_116
static thistype unit_124
static thistype unit_79
static thistype unit_133
static thistype unit_117
static thistype unit_81
static thistype unit_113
static thistype unit_19
static thistype unit_20
static thistype unit_21
static thistype unit_24
static thistype unit_25
static thistype unit_26
static thistype unit_27
static thistype unit_28
static thistype unit_30
static thistype unit_37
static thistype unit_41
boolean enabled
integer ownerIndex
integer typeId
real x
real y
real angle
thistype waygateTarget
//! runtextmacro CreateList("UNITS")
static method createUnit takes boolean enabled, integer typeId, integer ownerIndex, real x, real y, real angle, thistype waygateTarget returns thistype
local thistype this = thistype.allocate()
set this.enabled = enabled
set this.ownerIndex = ownerIndex
set this.typeId = typeId
set this.x = x
set this.y = y
set this.angle = angle
set this.waygateTarget = waygateTarget
call thistype.UNITS_Add(this)
return this
endmethod
static method initUnits
set thistype.unit_36 = thistype.createUnit(true, 'sloc', 0, 0, 0, 4.710, NULL)
set thistype.unit_16 = thistype.createUnit(true, 'UMet', 0, 0, 5760, 4.710, NULL)
set thistype.unit_2 = thistype.createUnit(true, 'uLib', 7, 0, 1792, 4.710, NULL)
set thistype.unit_3 = thistype.createUnit(true, 'uFou', 7, 2048, 1792, 4.710, NULL)
set thistype.unit_34 = thistype.createUnit(true, 'uTav', 15, -6144, -1984, 0.000, NULL)
set thistype.unit_5 = thistype.createUnit(true, 'uPha', 7, -1728, 4288, 4.710, NULL)
set thistype.unit_6 = thistype.createUnit(true, 'uGaC', 7, 1728, 4288, 4.710, NULL)
set thistype.unit_15 = thistype.createUnit(true, 'uTow', 11, 704, -128, 4.710, NULL)
set thistype.unit_0 = thistype.createUnit(true, 'sloc', 1, 0, 0, 4.710, NULL)
set thistype.unit_8 = thistype.createUnit(true, 'sloc', 2, 0, 0, 4.710, NULL)
set thistype.unit_9 = thistype.createUnit(true, 'sloc', 3, 0, 0, 4.710, NULL)
set thistype.unit_10 = thistype.createUnit(true, 'sloc', 4, 0, 0, 4.710, NULL)
set thistype.unit_11 = thistype.createUnit(true, 'sloc', 5, 0, 0, 4.710, NULL)
set thistype.unit_12 = thistype.createUnit(true, 'sloc', 6, 0, 0, 4.710, NULL)
set thistype.unit_13 = thistype.createUnit(true, 'sloc', 7, 0, 0, 4.710, NULL)
set thistype.unit_38 = thistype.createUnit(true, 'uRes', 7, 832, -448, 4.710, NULL)
set thistype.unit_90 = thistype.createUnit(true, 'uArS', 15, 4416, -5376, 4.710, NULL)
set thistype.unit_17 = thistype.createUnit(true, 'uGaC', 7, -3264, 448, 4.710, NULL)
set thistype.unit_33 = thistype.createUnit(true, 'uPen', 8, -5607.96, -5022.64, 5.360, NULL)
set thistype.unit_50 = thistype.createUnit(true, 'ISno', 15, 4.59, -2574.64, 4.710, NULL)
set thistype.unit_65 = thistype.createUnit(true, 'uBTw', 11, -928, 2656, 4.710, NULL)
set thistype.unit_23 = thistype.createUnit(true, 'uRes', 7, -1408, 4352, 4.710, NULL)
set thistype.unit_51 = thistype.createUnit(true, 'ISno', 15, 6004.32, 2239.96, 4.710, NULL)
set thistype.unit_46 = thistype.createUnit(true, 'sloc', 11, 0, 0, 4.710, NULL)
set thistype.unit_14 = thistype.createUnit(true, 'sloc', 8, 0, 0, 4.710, NULL)
set thistype.unit_32 = thistype.createUnit(true, 'uPen', 8, -4436.59, -6030.5, 5.920, NULL)
set thistype.unit_35 = thistype.createUnit(true, 'uTav', 15, 6272, -1600, 4.710, NULL)
set thistype.unit_4 = thistype.createUnit(true, 'uFou', 7, -2048, 1792, 4.710, NULL)
set thistype.unit_1 = thistype.createUnit(true, 'uPha', 7, 3264, 448, 4.710, NULL)
set thistype.unit_39 = thistype.createUnit(true, 'uRes', 7, -3520, 2688, 4.710, NULL)
set thistype.unit_40 = thistype.createUnit(true, 'uSeb', 7, -74.06, 1659.47, 4.570, NULL)
set thistype.unit_42 = thistype.createUnit(true, 'IRun', 15, 3.18, 4995.94, 4.710, NULL)
set thistype.unit_45 = thistype.createUnit(true, 'sloc', 10, 0, 0, 4.710, NULL)
set thistype.unit_29 = thistype.createUnit(true, 'sloc', 9, 0, 0, 4.710, NULL)
set thistype.unit_44 = thistype.createUnit(true, 'uRiS', 7, 3392, 1088, 4.710, NULL)
set thistype.unit_86 = thistype.createUnit(true, 'uPen', 8, -3996.7, -6982.05, 0.100, NULL)
set thistype.unit_134 = thistype.createUnit(false, 'uTrP', 0, 4842.5, -2666.6, 1.150, NULL)
set thistype.unit_7 = thistype.createUnit(true, 'uRes', 7, 1408, 4352, 4.710, NULL)
set thistype.unit_22 = thistype.createUnit(true, 'uRes', 7, 3584, 2944, 4.710, NULL)
set thistype.unit_18 = thistype.createUnit(true, 'uRiS', 7, -3456, 2432, 4.710, NULL)
set thistype.unit_83 = thistype.createUnit(false, 'uPan', 0, -2933.68, -710.26, 5.180, NULL)
set thistype.unit_49 = thistype.createUnit(true, 'ISno', 15, -6400.1, 1532.99, 4.710, NULL)
set thistype.unit_88 = thistype.createUnit(true, 'uPeL', 15, -5590.03, -7097.49, 2.620, NULL)
set thistype.unit_87 = thistype.createUnit(true, 'uPen', 8, -4690.55, -6965.2, 2.820, NULL)
set thistype.unit_99 = thistype.createUnit(false, 'uTus', 0, -1550.46, -1407.35, 2.640, NULL)
set thistype.unit_69 = thistype.createUnit(true, 'uBTw', 11, -672, -160, 4.710, NULL)
set thistype.unit_67 = thistype.createUnit(true, 'uBTw', 11, -3872, 1120, 4.710, NULL)
set thistype.unit_66 = thistype.createUnit(true, 'uBTw', 11, 928, 2656, 4.710, NULL)
set thistype.unit_31 = thistype.createUnit(true, 'uPen', 8, -5808.83, -6672.78, 0.100, NULL)
set thistype.unit_68 = thistype.createUnit(true, 'uBTw', 11, 3872, 1120, 4.710, NULL)
set thistype.unit_122 = thistype.createUnit(false, 'uWoM', 0, 3244.42, -898.11, 4.310, NULL)
set thistype.unit_115 = thistype.createUnit(false, 'uKoM', 0, -4896.15, -1000.41, 4.170, NULL)
set thistype.unit_106 = thistype.createUnit(true, 'nogr', 0, -2668.68, -923.61, 5.100, NULL)
set thistype.unit_110 = thistype.createUnit(false, 'uFuM', 0, -4761.15, -978.84, 4.050, NULL)
set thistype.unit_97 = thistype.createUnit(false, 'uWol', 0, 3092.35, -965.9, 4.510, NULL)
set thistype.unit_123 = thistype.createUnit(false, 'uWol', 0, 3295.54, -1068.42, 3.960, NULL)
set thistype.unit_102 = thistype.createUnit(false, 'uKoB', 0, 1603.14, -1488.02, 1.130, NULL)
set thistype.unit_112 = thistype.createUnit(false, 'uTus', 0, -1666.84, -1546.88, 2.630, NULL)
set thistype.unit_111 = thistype.createUnit(true, 'nogr', 0, -2788.83, -1018.31, 5.490, NULL)
set thistype.unit_114 = thistype.createUnit(false, 'uKoR', 0, 1774.88, -1418.17, 1.010, NULL)
set thistype.unit_132 = thistype.createUnit(false, 'uTrG', 0, 4714.97, -2739.71, 1.460, NULL)
set thistype.unit_116 = thistype.createUnit(false, 'uKoM', 0, -4719.19, -1132.61, 3.770, NULL)
set thistype.unit_124 = thistype.createUnit(false, 'uKoB', 0, 1686.55, -1549.23, 1.040, NULL)
set thistype.unit_79 = thistype.createUnit(false, 'uPan', 0, -3084.7, -845.33, 5.840, NULL)
set thistype.unit_133 = thistype.createUnit(false, 'uTrP', 0, 4603.89, -2603.4, 1.110, NULL)
set thistype.unit_117 = thistype.createUnit(false, 'uBDS', 0, -1471, -1470.95, 2.870, NULL)
set thistype.unit_81 = thistype.createUnit(false, 'uBDS', 0, -1571.35, -1640.34, 2.210, NULL)
set thistype.unit_113 = thistype.createUnit(false, 'uKoR', 0, 1582.36, -1361.09, 0.960, NULL)
set thistype.unit_19 = thistype.createUnit(false, 'UAru', 15, -1703.85, 6098.26, 3.550, NULL)
set thistype.unit_20 = thistype.createUnit(false, 'UDra', 15, -1110.24, 6281.83, 4.160, NULL)
set thistype.unit_21 = thistype.createUnit(false, 'UJot', 15, -1601.65, 5037.67, 2.880, NULL)
set thistype.unit_24 = thistype.createUnit(false, 'UKer', 15, -1965.03, 6124.93, 5.450, NULL)
set thistype.unit_25 = thistype.createUnit(false, 'UMan', 15, -2376.73, 5319.46, 5.980, NULL)
set thistype.unit_26 = thistype.createUnit(false, 'URoc', 15, -2293.22, 6337.23, 4.310, NULL)
set thistype.unit_27 = thistype.createUnit(false, 'USmo', 15, -2105.35, 5143.41, 1.860, NULL)
set thistype.unit_28 = thistype.createUnit(false, 'USto', 15, -2625.32, 6390.22, 5.140, NULL)
set thistype.unit_30 = thistype.createUnit(false, 'UThr', 15, -1248.28, 5694.68, 2.460, NULL)
set thistype.unit_37 = thistype.createUnit(true, 'qwrp', 15, -3200, 5376, 4.710, rect_BasementStairwayUpTargetLeft)
set thistype.unit_41 = thistype.createUnit(true, 'qwrp', 15, -1472, 6848, 4.710, rect_BasementStairwayUpTargetRight)
endmethod
static thistype rect_ArtifactIntroTarget
static thistype rect_BasementStairwayUpLeft
static thistype rect_BasementStairwayUpRight
static thistype rect_BasementStairwayUpTargetLeft
static thistype rect_BasementStairwayUpTargetRight
static thistype rect_Castle
static thistype rect_Chamber
static thistype rect_Creeps_Left_Air
static thistype rect_Creeps_Left_Boss
static thistype rect_Creeps_Left_Melee
static thistype rect_Creeps_Right_Buff
static thistype rect_Creeps_Right_Demon
static thistype rect_Creeps_Right_Minor
static thistype rect_DefenderSpawn_SourceCenter
static thistype rect_DefenderSpawn_TargetBottom
static thistype rect_DefenderSpawn_TargetLeft
static thistype rect_DefenderSpawn_TargetRight
static thistype rect_Gebiet_034_Kopieren
static thistype rect_Gebiet_034_Kopieren_2
static thistype rect_HeroRevival
static thistype rect_HeroRevival2
static thistype rect_HeroSelection_Aruruw
static thistype rect_HeroSelection_Center
static thistype rect_HeroSelection_Drakul
static thistype rect_HeroSelection_Jota
static thistype rect_HeroSelection_Kera
static thistype rect_HeroSelection_Lizzy
static thistype rect_HeroSelection_Rocketeye
static thistype rect_HeroSelection_Smokealot
static thistype rect_HeroSelection_Stormy
static thistype rect_HeroSelection_Tajran
static thistype rect_Introduction
static thistype rect_Introduction_Aruruw
static thistype rect_Introduction_Drakul
static thistype rect_Introduction_Light
static thistype rect_Introduction_Light2
static thistype rect_Introduction_Lizzy
static thistype rect_Introduction_Lizzy2
static thistype rect_Introduction_Lizzy3
static thistype rect_Introduction_Rocketeye
static thistype rect_Introduction_Smokealot
static thistype rect_Introduction_Stormy
static thistype rect_Introduction_Stormy2
static thistype rect_Introduction_Tajran
static thistype rect_Introduction_Tajran2
static thistype rect_LeftBrazier
static thistype rect_LeftTavern
static thistype rect_Lumber
static thistype rect_Lumber10
static thistype rect_Lumber11
static thistype rect_Lumber12
static thistype rect_Lumber13
static thistype rect_Lumber2
static thistype rect_Lumber3
static thistype rect_Lumber4
static thistype rect_Lumber5
static thistype rect_Lumber6
static thistype rect_Lumber7
static thistype rect_Lumber8
static thistype rect_Lumber9
static thistype rect_RightBrazier
static thistype rect_RightTavern
static thistype rect_Rosa
static thistype rect_SpawnBottomIn
static thistype rect_SpawnCenter
static thistype rect_SpawnDestination
static thistype rect_SpawnLeftIn
static thistype rect_SpawnRightIn
static thistype rect_StairsDownDarknessFog
static thistype rect_Tower
static thistype rect_Tower2
static thistype rect_Waypoint_RegionCheck
static thistype rect_Waypoint_RegionCheck2
static thistype rect_Waypoint_RegionCheck3
real minX
real minY
real maxX
real maxY
//! runtextmacro CreateList("RECTS")
static method createRect takes real minX, real maxX, real minY, real maxY returns thistype
local thistype this = thistype.allocate()
set this.minX = minX
set this.maxX = maxX
set this.minY = minY
set this.maxY = maxY
set this.x = (minX + maxX) / 2
set this.y = (minY + maxY) / 2
call this.RECTS_Add(this)
return this
endmethod
static method initRects
set thistype.rect_ArtifactIntroTarget = thistype.createRect(3808, 4672, -6368, -5792)
set thistype.rect_BasementStairwayUpLeft = thistype.createRect(-3328, -3072, 4928, 5504)
set thistype.rect_BasementStairwayUpRight = thistype.createRect(-1888, -1312, 6720, 6976)
set thistype.rect_BasementStairwayUpTargetLeft = thistype.createRect(-3072, -2816, 3456, 3712)
set thistype.rect_BasementStairwayUpTargetRight = thistype.createRect(2560, 2816, 3264, 3520)
set thistype.rect_Castle = thistype.createRect(-4352, 4352, -896, 3968)
set thistype.rect_Chamber = thistype.createRect(-3456, -768, 4512, 7456)
set thistype.rect_Creeps_Left_Air = thistype.createRect(-1760, -1344, -1600, -1216)
set thistype.rect_Creeps_Left_Boss = thistype.createRect(-4992, -4576, -1216, -832)
set thistype.rect_Creeps_Left_Melee = thistype.createRect(-3200, -2784, -960, -576)
set thistype.rect_Creeps_Right_Buff = thistype.createRect(3008, 3424, -1184, -800)
set thistype.rect_Creeps_Right_Demon = thistype.createRect(4544, 4960, -2848, -2464)
set thistype.rect_Creeps_Right_Minor = thistype.createRect(1472, 1888, -1664, -1280)
set thistype.rect_DefenderSpawn_SourceCenter = thistype.createRect(-384, 384, 1408, 2176)
set thistype.rect_DefenderSpawn_TargetBottom = thistype.createRect(-256, 256, -832, -448)
set thistype.rect_DefenderSpawn_TargetLeft = thistype.createRect(-4096, -3712, 1536, 2048)
set thistype.rect_DefenderSpawn_TargetRight = thistype.createRect(3584, 3968, 1536, 2048)
set thistype.rect_Gebiet_034_Kopieren = thistype.createRect(5056, 5184, -6720, -6592)
set thistype.rect_Gebiet_034_Kopieren_2 = thistype.createRect(5056, 5184, -5696, -5568)
set thistype.rect_HeroRevival = thistype.createRect(704, 1152, 384, 832)
set thistype.rect_HeroRevival2 = thistype.createRect(-1152, -704, 384, 832)
set thistype.rect_HeroSelection_Aruruw = thistype.createRect(-1760, -1696, 6208, 6272)
set thistype.rect_HeroSelection_Center = thistype.createRect(-2400, -2208, 5664, 5856)
set thistype.rect_HeroSelection_Drakul = thistype.createRect(-1152, -1088, 6240, 6304)
set thistype.rect_HeroSelection_Jota = thistype.createRect(-1632, -1568, 4992, 5056)
set thistype.rect_HeroSelection_Kera = thistype.createRect(-1984, -1920, 6240, 6304)
set thistype.rect_HeroSelection_Lizzy = thistype.createRect(-2400, -2336, 5280, 5344)
set thistype.rect_HeroSelection_Rocketeye = thistype.createRect(-2656, -2592, 6336, 6400)
set thistype.rect_HeroSelection_Smokealot = thistype.createRect(-2144, -2080, 5120, 5184)
set thistype.rect_HeroSelection_Stormy = thistype.createRect(-2336, -2272, 6304, 6368)
set thistype.rect_HeroSelection_Tajran = thistype.createRect(-1280, -1216, 5664, 5728)
set thistype.rect_Introduction = thistype.createRect(1024, 3456, 3968, 5632)
set thistype.rect_Introduction_Aruruw = thistype.createRect(2208, 2272, 5408, 5472)
set thistype.rect_Introduction_Drakul = thistype.createRect(2208, 2272, 4768, 4832)
set thistype.rect_Introduction_Light = thistype.createRect(1760, 1824, 4704, 4768)
set thistype.rect_Introduction_Light2 = thistype.createRect(2656, 2720, 4704, 4768)
set thistype.rect_Introduction_Lizzy = thistype.createRect(2912, 2976, 5952, 6016)
set thistype.rect_Introduction_Lizzy2 = thistype.createRect(2944, 3008, 5312, 5376)
set thistype.rect_Introduction_Lizzy3 = thistype.createRect(2560, 2624, 5216, 5280)
set thistype.rect_Introduction_Rocketeye = thistype.createRect(1856, 1920, 5216, 5280)
set thistype.rect_Introduction_Smokealot = thistype.createRect(2016, 2080, 5344, 5408)
set thistype.rect_Introduction_Stormy = thistype.createRect(2400, 2464, 5344, 5408)
set thistype.rect_Introduction_Stormy2 = thistype.createRect(3136, 3200, 5024, 5088)
set thistype.rect_Introduction_Tajran = thistype.createRect(1120, 1184, 4672, 4736)
set thistype.rect_Introduction_Tajran2 = thistype.createRect(1696, 1760, 4864, 4928)
set thistype.rect_LeftBrazier = thistype.createRect(-800, -512, 5504, 5792)
set thistype.rect_LeftTavern = thistype.createRect(-6400, -5536, -2208, -1600)
set thistype.rect_Lumber = thistype.createRect(5664, 5920, 3968, 4224)
set thistype.rect_Lumber10 = thistype.createRect(-992, -736, -5408, -5152)
set thistype.rect_Lumber11 = thistype.createRect(160, 416, -6112, -5856)
set thistype.rect_Lumber12 = thistype.createRect(704, 960, -6944, -6688)
set thistype.rect_Lumber13 = thistype.createRect(1408, 1664, -6016, -5760)
set thistype.rect_Lumber2 = thistype.createRect(6592, 6816, 4704, 4928)
set thistype.rect_Lumber3 = thistype.createRect(6336, 6560, 2816, 3072)
set thistype.rect_Lumber4 = thistype.createRect(1792, 2048, -3328, -3072)
set thistype.rect_Lumber5 = thistype.createRect(-3168, -2912, -3200, -2944)
set thistype.rect_Lumber6 = thistype.createRect(-3360, -3104, -3136, -2880)
set thistype.rect_Lumber7 = thistype.createRect(-6560, -6304, 800, 1056)
set thistype.rect_Lumber8 = thistype.createRect(-6912, -6656, 2144, 2400)
set thistype.rect_Lumber9 = thistype.createRect(-5824, -5568, 2336, 2592)
set thistype.rect_RightBrazier = thistype.createRect(512, 800, 5504, 5792)
set thistype.rect_RightTavern = thistype.createRect(5312, 6272, -2272, -1568)
set thistype.rect_Rosa = thistype.createRect(1088, 1184, 352, 448)
set thistype.rect_SpawnBottomIn = thistype.createRect(-704, 32, -6784, -5984)
set thistype.rect_SpawnCenter = thistype.createRect(-640, 640, 1152, 2432)
set thistype.rect_SpawnDestination = thistype.createRect(-320, 288, 3424, 4000)
set thistype.rect_SpawnLeftIn = thistype.createRect(-7648, -7040, 1600, 2304)
set thistype.rect_SpawnRightIn = thistype.createRect(7008, 7616, 1344, 2240)
set thistype.rect_StairsDownDarknessFog = thistype.createRect(3136, 3296, 3360, 3424)
set thistype.rect_Tower = thistype.createRect(-768, -704, -224, -160)
set thistype.rect_Tower2 = thistype.createRect(704, 768, -224, -160)
set thistype.rect_Waypoint_RegionCheck = thistype.createRect(-7712, 8192, 160, 4992)
set thistype.rect_Waypoint_RegionCheck2 = thistype.createRect(-1216, 1216, -8192, 160)
set thistype.rect_Waypoint_RegionCheck3 = thistype.createRect(-1024, 1024, 3968, 6336)
endmethod
endstruct