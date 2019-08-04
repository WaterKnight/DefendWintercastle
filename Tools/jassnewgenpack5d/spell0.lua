--START OF OpenScope

Color = {}
Color.DWC = "|cff00bfff"
Color.GOLD = "|cffffcc00"
Color.RESET = "|r"
Color.CHANNEL = "|cff00ffff"
Color.COLDNESS = "|cff0000ff"
Color.ECLIPSE = "|cffff00ff"
Color.IGNITION = "|cffff0000"
Color.INVISIBILITY = "|cffffff00"
Color.POISON = "|cff00ff00"
Color.SILENCE = "|cffc8b380"
Color.SLEEP = "|cff00ffff"
Color.SPELL_SHIELD = "|cffff00ff"
Math = {}
Math.QUARTER_ANGLE = 1.57
BUFF_DESCRIPTIONS = {}
BUFF_DESCRIPTIONS["CHANNEL"] = Color.CHANNEL.."Channel"..Color.RESET.."|nThe cast of an ability is being woven. While doing so, the unit cannot move nor attack but fire other non-channeling spells and use items. An issued 'Stop' order will cancel everything."
BUFF_DESCRIPTIONS["COLDNESS"] = Color.COLDNESS.."Coldness"..Color.RESET.."|nReduces attack speed by "..Color.GOLD.."25%"..Color.RESET.." and move speed by "..Color.GOLD.."25%"..Color.RESET..". Cold units take "..Color.GOLD.."135%"..Color.RESET.." damage when being below "..Color.GOLD.."35%"..Color.RESET.." life."
BUFF_DESCRIPTIONS["ECLIPSE"] = Color.ECLIPSE.."Eclipse"..Color.RESET.."|nDecreases move speed by "..Color.GOLD.."30%"..Color.RESET..", spellpower by "..Color.GOLD.."50%"..Color.RESET.." and mana regeneration by "..Color.GOLD.."50%"..Color.RESET.."%."
BUFF_DESCRIPTIONS["IGNITION"] = Color.IGNITION.."Ignition"..Color.RESET.."|nUnveils invisible units and causes "..Color.GOLD.."5%"..Color.RESET.." ("..Color.GOLD.."2%"..Color.RESET..") magic damage every second."
BUFF_DESCRIPTIONS["INVISIBILITY"] = Color.INVISIBILITY.."Invisibility"..Color.RESET.."|nCarriers of this buff are masked to non-allies. Performing attacks or casting abilities reveals oneself. Invisible units are sure to deal a critical strike when they surprise with a stealthed melee attack."
BUFF_DESCRIPTIONS["POISON"] = Color.POISON.."Poison"..Color.RESET.."|nReduces attack speed by "..Color.GOLD.."35%"..Color.RESET.." and move speed by "..Color.GOLD.."20%"..Color.RESET..". Poisoned units regenerate their hitpoints only half as fast."
BUFF_DESCRIPTIONS["SILENCE"] = Color.SILENCE.."Silence"..Color.RESET.."|nSilenced units are unable to cast abilities."
BUFF_DESCRIPTIONS["SLEEP"] = Color.SLEEP.."Sleep"..Color.RESET.."|nSleeping units are unable to act and wake up when attacked. This damage is sure to be critical."
BUFF_DESCRIPTIONS["SPELL_SHIELD"] = Color.SPELL_SHIELD.."Spell Shield"..Color.RESET.."|nProtects the unit from many disadvantageous magical effects. Unlike 'Magic Immunity', the 'Spell Shield' blocks only one such thing and then disperses."
CLASS_ARTIFACT = 0
CLASS_HERO_FIRST = 1
CLASS_HERO_SECOND = 2
CLASS_HERO_ULTIMATE = 3
CLASS_HERO_ULTIMATE_EX = 4
CLASS_ITEM = 5
CLASS_NORMAL = 6
CLASS_PURCHASABLE = 7
function set(field, value, default)
if (value == nil) then
makechange(current, field, default)
else
makechange(current, field, value)
end
end
function setLv(field, level, value, default)
if (value == nil) then
makechange(current, field, level, default)
else
makechange(current, field, level, value)
end
end
function setLevelsAmount(value)
levelsAmount = value
if (value == 1) then
tooltip[1] = Color.DWC..name..Color.RESET
else
for i = 1, value, 1 do
tooltip[i] = Color.DWC..name..Color.RESET.." ["..Color.GOLD.."Level "..i..Color.RESET.."]"
end
end
end
function addSharedBuff(value)
sharedBuffsCount = sharedBuffsCount + 1
sharedBuffs[sharedBuffsCount] = value
end
function addData(name, values)
if (name == nil) then
return
end
it = 1
datasCount = datasCount + 1
datas[datasCount] = name
datasValue[datasCount] = {}
while (values[it] ~= nil) do
datasValue[datasCount][it] = values[it]
it = it + 1
end
end
areaRange = {}
castTime = {}
channelTime = {}
cooldown = {}
datas = {}
datasCount = 0
datasValue = {}
isHeroSpell = false
manaCost = {}
range = {}
sharedBuffs = {}
sharedBuffsCount = 0
showAreaRange = {}
targets = {}
tooltip = {}
uberTooltip = {}

--END OF OpenScope
--CREATE SPELL "Heal Explosion"

name = "Heal Explosion"
raw = "AHEx"
class = CLASS_NORMAL
setobjecttype("abilities")
if ("NORMAL" == "NORMAL") then
channelBased = true
showAreaRange = {}
createobject("ANcl", raw)
set("acap", "")
set("acat", "")
set("aeat", "")
set("aher", "\0")
set("ahky", "")
set("anam", name)
set("ata0", "")
set("atat", "")
elseif ("NORMAL" == "PARALLEL_IMMEDIATE") then
order = "berserk"
parallelImmediate = true
createobject("Absk", raw)
set("ahky", "")
set("anam", name)
set("ata0", "")
set("atat", "")
elseif ("NORMAL" == "PASSIVE") then
createobject("Agyb", raw)
set("acap", "")
set("acat", "")
set("aeat", "")
set("aher", "\0")
set("ahky", "")
set("anam", name)
set("areq", "")
set("ata0", "")
set("atat", "")
elseif (string.sub("NORMAL", 1, 1 + 7 - 1) == "SPECIAL") then
createobject(string.sub("NORMAL", 1 + 7 + 1, string.len("NORMAL")), raw)
set("acap", "")
set("acat", "")
set("aeat", "")
set("aher", "\0")
set("ahky", "")
set("anam", name)
set("ata0", "")
set("atat", "")
end
if ("NORMAL" == "ARTIFACT") then
hotkey = "F"
if (x == nil) then
x = 1
y = 1
end
if (levelsAmount == nil) then
setLevelsAmount(5)
end
elseif ("NORMAL" == "HERO_FIRST") then
hotkey = "Q"
isHeroSpell = true
if (x == nil) then
x = 0
y = 2
end
if (levelsAmount == nil) then
setLevelsAmount(5)
end
elseif ("NORMAL" == "HERO_SECOND") then
hotkey = "W"
isHeroSpell = true
if (x == nil) then
x = 1
y = 2
end
if (levelsAmount == nil) then
setLevelsAmount(5)
end
elseif ("NORMAL" == "HERO_ULTIMATE") then
hotkey = "E"
isHeroSpell = true
if (x == nil) then
x = 2
y = 2
end
if (levelsAmount == nil) then
setLevelsAmount(3)
end
elseif ("NORMAL" == "HERO_ULTIMATE_EX") then
hotkey = "R"
isHeroSpell = true
if (x == nil) then
x = 3
y = 2
end
if (levelsAmount == nil) then
setLevelsAmount(2)
end
elseif ("NORMAL" == "ITEM") then
set("aite", 1)
if (levelsAmount == nil) then
setLevelsAmount(1)
end
elseif ("NORMAL" == "NORMAL") then
hotkey = "Q"
if (x == nil) then
x = 0
y = 2
end
if (levelsAmount == nil) then
setLevelsAmount(1)
end
elseif ("NORMAL" == "PURCHASABLE") then
hotkey = "T"
isHeroSpell = true
if (x == nil) then
x = 2
y = 1
end
if (levelsAmount == nil) then
setLevelsAmount(5)
end
end
set("ahky", hotkey)
animation = "spell"
areaRange[1] = 300.
showAreaRange[1] = false
x = 1
y = 2
channelTime[1] = 2.5
cooldown[1] = 15.
if ("damage" ~= "") then
addData("damage", {50.})
end
if ("heal" ~= "") then
addData("heal", {120.})
end
if ("" ~= "") then
addData("", {AttachPoint.WEAPON})
end
if ("" ~= "") then
addData("", {"Spells\\HealExplosion\\Charge.mdx"})
end
if ("" ~= "") then
addData("", {AttachPoint.CHEST})
end
if ("" ~= "") then
addData("", {"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosDone.mdl"})
end
if ("" ~= "") then
addData("", {AttachPoint.CHEST})
end
if ("" ~= "") then
addData("", {"Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl"})
end
if ("" ~= "") then
addData("", {AttachPoint.CHEST})
end
if ("" ~= "") then
addData("", {"Abilities\\Spells\\Items\\StaffOfPurification\\PurificationTarget.mdl"})
end
icon = "ReplaceableTextures\\CommandButtons\\BTNHealExplosion.blp"
manaCost[1] = 25
order = "bloodlust"
if ("IMMEDIATE" == "IMMEDIATE") then
targetType = 0
elseif ("IMMEDIATE" == "POINT") then
targetType = 2
elseif ("IMMEDIATE" == "POINT_OR_UNIT") then
targetType = 3
elseif ("IMMEDIATE" == "UNIT") then
targetType = 1
end
uberTooltip[1] = "After <channelTime> seconds of channeling, the caster heals every friend in range by <heal> and damages enemies by <damage>."
function replace(a, sub, rep, gold)
if (rep == nil) then
rep = ""
end
c = 1
if (gold == nil) then
rep = Color.GOLD..rep..Color.RESET
end
while (c < string.len(a) - string.len(sub) + 2) do
if (string.sub(a, c, c + string.len(sub) - 1) == sub) then
a = string.sub(a, 1, c - 1)..rep..string.sub(a, c + string.len(sub))
else
c = c + 1
end
end
return a
end
function replaceTags(a, level)
a = string.gsub(a, "<level>", level)
a = string.gsub(a, "<prevLevel>", level - 1)
a = replace(a, "<areaRange>", areaRange[level])
a = replace(a, "<channelTime>", channelTime[level])
a = replace(a, "<cooldown>", cooldown[level])
a = replace(a, "<manaCost>", manaCost[level])
a = replace(a, "<name>", name)
for i = 1, levelsAmount, 1 do
a = replace(a, "<areaRange"..i..">", areaRange[i])
a = replace(a, "<channelTime"..i..">", channelTime[i])
a = replace(a, "<cooldown"..i..">", cooldown[i])
a = replace(a, "<manaCost"..i..">", manaCost[i])
end
for i = 1, datasCount, 1 do
if (datasValue[i][level] == nil) then
a = replace(a, "<"..datas[i]..">", datasValue[i][1])
if (type(datasValue[i][1]) == "number") then
a = replace(a, "<"..datas[i]..",%>", (datasValue[i][1] * 100).."%")
end
else
a = replace(a, "<"..datas[i]..">", datasValue[i][level])
if (type(datasValue[i][level]) == "number") then
a = replace(a, "<"..datas[i]..",%>", (datasValue[i][level] * 100).."%")
end
end
for i2 = 1, levelsAmount, 1 do
a = replace(a, "<"..datas[i]..i2..">", datasValue[i][i2])
if (type(datasValue[i][i2]) == "number") then
a = replace(a, "<"..datas[i]..i2..",%>", (datasValue[i][i2] * 100).."%")
end
end
end
a = replace(a, "<COLDNESS>", Color.COLDNESS, false)
a = replace(a, "</COLDNESS>", Color.RESET, false)
a = replace(a, "<ECLIPSE>", Color.ECLIPSE, false)
a = replace(a, "</ECLIPSE>", Color.RESET, false)
a = replace(a, "<IGNITION>", Color.IGNITION, false)
a = replace(a, "</IGNITION>", Color.RESET, false)
a = replace(a, "<INVISIBILITY>", Color.INVISIBILITY, false)
a = replace(a, "</INVISIBILITY>", Color.RESET, false)
a = replace(a, "<POISON>", Color.POISON, false)
a = replace(a, "</POISON>", Color.RESET, false)
a = replace(a, "<SLEEP>", Color.SLEEP, false)
a = replace(a, "</SLEEP>", Color.RESET, false)
return a
end
--FINALIZE

set("alev", levelsAmount)
for i = 1, levelsAmount, 1 do
if (uberTooltip[i] == nil) then
if (i == 1) then
uberTooltip[i] = ""
else
uberTooltip[i] = uberTooltip[i - 1]
end
end
end
set("aani", animation, "")
set("aart", icon, "")
set("abpx", x, 0)
set("abpy", y, 0)
for i = 1, levelsAmount, 1 do
if (parallelImmediate) then
setLv("abuf", i, "BPar", "")
end
if (showAreaRange[i]) then
setLv("aare", i, areaRange[i], 0)
end
setLv("acas", i, castTime[i], 0)
setLv("acdn", i, cooldown[i], 0)
setLv("amcs", i, manaCost[i], 0)
setLv("aran", i, range[i], 0)
setLv("atar", i, targetsAll, "")
end
for i = 1, levelsAmount, 1 do
if (targets[i] ~= nil) then
setLv("atar", i, targets[i])
end
end
for i = 1, levelsAmount, 1 do
if (hotkey == nil) then
setLv("atp1", i, tooltip[i], "")
else
setLv("atp1", i, "("..Color.GOLD..hotkey..Color.RESET..") "..tooltip[i], "")
end
end
for i = 1, levelsAmount, 1 do
uberTooltip[i] = replaceTags(uberTooltip[i], i)
for i2 = 1, sharedBuffsCount, 1 do
buff = sharedBuffs[i2]
uberTooltip[i] = uberTooltip[i].."|n|n"..BUFF_DESCRIPTIONS[buff]
end
if (lore ~= nil) then
uberTooltip[i] = uberTooltip[i].."|n|n"..Color.GOLD..lore..Color.RESET
end
if (cooldown[i] ~= nil) then
if (cooldown[i] > 0) then
uberTooltip[i] = uberTooltip[i].."|n|n"..Color.DWC.."Cooldown: "..Color.GOLD..cooldown[i]..Color.DWC.." seconds"..Color.RESET
end
end
setLv("aub1", i, uberTooltip[i], "")
end
if (channelBased) then
if (order ~= nil) then
for i = 1, levelsAmount, 1 do
setLv("Ncl6", i, order)
end
end
for i = 1, levelsAmount, 1 do
setLv("Ncl1", i, 0, 0)
setLv("Ncl2", i, targetType, 0)
end
for i = 1, levelsAmount, 1 do
if (showAreaRange[i]) then
setLv("Ncl3", i, 19)
else
setLv("Ncl3", i, 17)
end
setLv("Ncl4", i, 0)
setLv("Ncl5", i, "\0")
end
end
if (isHeroSpell) then
if (class == CLASS_ARTIFACT) then
index = 4
LEARN_BUTTON_POS_X = 0
LEARN_BUTTON_POS_Y = 1
LEARN_PREFIX = "K"
elseif (class == CLASS_HERO_FIRST) then
index = 0
LEARN_BUTTON_POS_X = 0
LEARN_BUTTON_POS_Y = 0
LEARN_PREFIX = "F"
elseif (class == CLASS_HERO_SECOND) then
index = 1
LEARN_BUTTON_POS_X = 1
LEARN_BUTTON_POS_Y = 0
LEARN_PREFIX = "G"
elseif (class == CLASS_HERO_ULTIMATE) then
index = 2
LEARN_BUTTON_POS_X = 2
LEARN_BUTTON_POS_Y = 0
LEARN_PREFIX = "H"
elseif (class == CLASS_HERO_ULTIMATE_EX) then
index = 3
LEARN_BUTTON_POS_X = 3
LEARN_BUTTON_POS_Y = 0
LEARN_PREFIX = "J"
end
for level = 1, levelsAmount, 1 do
if (researchUberTooltip[level] == nil) then
researchUberTooltip[level] = researchUberTooltip[level - 1]
end
end
createobject("ANeg", "C"..researchRaw..index)
set("abpx", 0)
set("abpy", 0)
set("ahky", "")
set("alev", levelsAmount)
set("anam", name.." Hero Spell Replacer "..index)
set("arac", "other")
set("aret", "")
set("arhk", "")
set("arpx", 0)
set("arut", "")
for level = 1, levelsAmount, 1 do
setLv("abuf", level, "BHSR")
setLv("atp1", level, "")
setLv("aub1", level, "")
setLv("Neg1", level, 0)
setLv("Neg2", level, 0)
if (level == 1) then
setLv("Neg3", level, "AHS"..index..","..LEARN_PREFIX..researchRaw..(level - 1))
else
setLv("Neg3", level, LEARN_PREFIX..researchRaw..(level - 2)..","..LEARN_PREFIX..researchRaw..(level - 1))
end
setLv("Neg4", level, "")
setLv("Neg5", level, "")
setLv("Neg6", level, "")
end
for level = 1, levelsAmount, 1 do
if (researchUberTooltip[level] ~= nil) then
researchUberTooltip[level] = replaceTags(researchUberTooltip[level], level)
end
createobject("ANcl", LEARN_PREFIX..researchRaw..(level - 1))
set("aani", "")
set("aart", "")
set("abpx", 0)
set("acap", "")
set("acat", "")
set("aeat", "")
set("ahky", "")
set("alev", 1)
set("anam", name.." Hero Spell Learner "..index.." Level "..level)
set("arac", "other")
for i3 = 1, 1, 1 do
setLv("aran", i3, 0)
setLv("Ncl1", i3, 0)
setLv("Ncl3", i3, 0)
setLv("Ncl4", i3, 0)
setLv("Ncl5", i3, "\0")
end
set("arar", icon, "")
set("aret", "Learn ("..Color.GOLD..hotkey..Color.RESET..") "..Color.DWC..name..Color.RESET.." ["..Color.GOLD.."Level %d"..Color.RESET.."]")
set("arhk", hotkey)
set("arpx", LEARN_BUTTON_POS_X)
set("arpy", LEARN_BUTTON_POS_Y)
set("arut", researchUberTooltip[level], "")
set("ata0", "")
set("atat", "")
setLv("atp1", 1, "")
setLv("aub1", 1, "")
setLv("Ncl6", 1, "")
end
end
