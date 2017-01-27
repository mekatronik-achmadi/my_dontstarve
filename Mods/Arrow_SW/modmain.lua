PrefabFiles = {
    "zbow",
	"zarrows",
	"zcrossbow",
	"zbolts",
	"zmusket",
	"zbullets",
	"zfxs",
	"zquiver",
	"sparkles",
	"zupalexsingredients",
}

Assets = {
    Asset( "ANIM", "anim/zbow_attack.zip" ),
	Asset( "ANIM", "anim/swap_zmloader.zip" ),
	
	Asset("SOUNDPACKAGE", "sound/bow_shoot.fev"),
    Asset("SOUND", "sound/bow_shoot_bank00.fsb"),
	
	Asset("ATLAS", "images/tabimages/archery_tab.xml"),
    Asset("IMAGE", "images/tabimages/archery_tab.tex"),
	
	Asset("ATLAS", "images/tabimages/zquiver_slot.xml"),
    Asset("IMAGE", "images/tabimages/zquiver_slot.tex"),
}

local require = GLOBAL.require

require("common_archery_functions")

local RPGHUDisON = false
local HerointheDarkisON = false

for _, moddir in ipairs(GLOBAL.KnownModIndex:GetModsToLoad()) do
    if GLOBAL.KnownModIndex:GetModInfo(moddir).name ~= nil then
		if string.find(GLOBAL.KnownModIndex:GetModInfo(moddir).name, "RPG HUD") then
			print("RPG HUD is activated")
			RPGHUDisON = true
		elseif GLOBAL.KnownModIndex:GetModInfo(moddir).name == "Hero in the Dark" then
			print("Hero in the Dark is activated")
			HerointheDarkisON = true		
		end
	end
end

local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local GIngredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH

local FRAMES = GLOBAL.FRAMES
local ACTIONS = GLOBAL.ACTIONS
local State = GLOBAL.State
local EventHandler = GLOBAL.EventHandler
local ActionHandler = GLOBAL.ActionHandler
local TimeEvent = GLOBAL.TimeEvent
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS

local BOWREQTWIGS = GetModConfigData("BowTwigs_req")
local BOWREQSILK = GetModConfigData("BowSilk_req")
local BOWTECHLEVEL = GetModConfigData("BowTechLevel")

local CROSSBOWREQBOARDS = GetModConfigData("CrossbowBoards_req")
local CROSSBOWREQSILK = GetModConfigData("CrossbowSilk_req")
local CROSSBOWREQHAMMER = GetModConfigData("CrossbowHammer_req")
local CROSSBOWTECHLEVEL = GetModConfigData("CrossbowTechLevel")

local MUSKETREQBOARDS = GetModConfigData("MusketBoards_req")
local MUSKETREQGOLD = GetModConfigData("MusketGold_req")
local MUSKETREQFLINT = GetModConfigData("MusketFlint_req")
local MUSKETTECHLEVEL = GetModConfigData("MusketTechLevel")

local MAGICBOWREQLIVINGLOG = GetModConfigData("MagicBowLivingLog_req")
local MAGICBOWREQGEM = GetModConfigData("MagicBowPurpleGem_req")
local MAGICBOWREQGLOMMER = GetModConfigData("MagicBowGlommerFlower_req")
local MAGICBOWTECHLEVEL = GetModConfigData("MagicBowTechLevel")

local QUIVERREQPIGSKIN = GetModConfigData("QuiverPigskin_req")
local QUIVERREQROPE = GetModConfigData("QuiverRope_req")
local QUIVERTECHLEVEL = GetModConfigData("QuiverTechLevel")

local PROJSHAFTTYPE = GetModConfigData("ProjShaftType")

local ARROWHEADTYPE = GetModConfigData("ArrowHeadType")
local ARROWREQHEAD = GetModConfigData("ArrowHead_req")
local ARROWREQLOG = GetModConfigData("ArrowLog_req")
local ARROWREQFEATHER = GetModConfigData("ArrowFeather_req")
local ARROWCRAFTNUM = GetModConfigData("ArrowCraftAmount")
local ARROWTECHLEVEL = GetModConfigData("ArrowTechLevel")

local GOLDARROWREQHEAD = GetModConfigData("GoldArrowHead_req")
local GOLDARROWREQLOG = GetModConfigData("GoldArrowLog_req")
local GOLDARROWREQFEATHER = GetModConfigData("GoldArrowFeather_req")
local GOLDARROWCRAFTNUM = GetModConfigData("GoldArrowCraftAmount")
local GOLDARROWTECHLEVEL = GetModConfigData("GoldArrowTechLevel")

local MOONSTONEARROWREQHEAD = GetModConfigData("MoonstoneArrowHead_req")
local MOONSTONEARROWREQLOG = GetModConfigData("MoonstoneArrowLog_req")
local MOONSTONEARROWREQFEATHER = GetModConfigData("MoonstoneArrowFeather_req")
local MOONSTONEARROWCRAFTNUM = GetModConfigData("MoonstoneArrowCraftAmount")
local MOONSTONEARROWTECHLEVEL = GetModConfigData("MoonstoneArrowTechLevel")

local FIREARROWHEADTYPE = GetModConfigData("FireArrowHeadType")
local FIREARROWREQHEAD = GetModConfigData("FireArrowHead_req")
local FIREARROWREQGRASS = GetModConfigData("FireArrowGrass_req")
local FIREARROWREQLOG = GetModConfigData("FireArrowLog_req")
local FIREARROWREQFEATHER = GetModConfigData("FireArrowFeather_req")
local FIREARROWCRAFTNUM = GetModConfigData("FireArrowCraftAmount")
local FIREARROWTECHLEVEL = GetModConfigData("FireArrowTechLevel")

local ICEARROWHEADTYPE = GetModConfigData("IceArrowHeadType")
local ICEARROWREQHEAD = GetModConfigData("IceArrowHead_req")
local ICEARROWREQLOG = GetModConfigData("IceArrowLog_req")
local ICEARROWREQFEATHER = GetModConfigData("IceArrowFeather_req")
local ICEARROWCRAFTNUM = GetModConfigData("IceArrowCraftAmount")
local ICEARROWTECHLEVEL = GetModConfigData("IceArrowTechLevel")

local THUNDERARROWHEADTYPE = GetModConfigData("ThunderArrowHeadType")
local THUNDERARROWREQHEAD = GetModConfigData("ThunderArrowHead_req")
local THUNDERARROWREQLOG = GetModConfigData("ThunderArrowLog_req")
local THUNDERARROWREQFEATHER = GetModConfigData("ThunderArrowFeather_req")
local THUNDERARROWCRAFTNUM = GetModConfigData("ThunderArrowCraftAmount")
local THUNDERARROWTECHLEVEL = GetModConfigData("ThunderArrowTechLevel")

local BOLTHEADTYPE = GetModConfigData("BoltHeadType")
local BOLTREQHEAD = GetModConfigData("BoltHead_req")
local BOLTREQLOG = GetModConfigData("BoltLog_req")
local BOLTREQFEATHER = GetModConfigData("BoltFeather_req")
local BOLTCRAFTNUM = GetModConfigData("BoltCraftAmount")
local BOLTTECHLEVEL = GetModConfigData("BoltTechLevel")

local POISONBOLTHEADTYPE = GetModConfigData("PoisonBoltHeadType")
local POISONBOLTREQHEAD = GetModConfigData("PoisonBoltHead_req")
local POISONBOLTREQLOG = GetModConfigData("PoisonBoltLog_req")
local POISONBOLTREQREDCAP = GetModConfigData("PoisonBoltRedCap_req")
local POISONBOLTREQFEATHER = GetModConfigData("PoisonBoltFeather_req")
local POISONBOLTCRAFTNUM = GetModConfigData("PoisonBoltCraftAmount")
local POISONBOLTTECHLEVEL = GetModConfigData("PoisonBoltTechLevel")

local EXPLOSIVEBOLTHEADTYPE = GetModConfigData("ExplosiveBoltHeadType")
local EXPLOSIVEBOLTREQHEAD = GetModConfigData("ExplosiveBoltHead_req")
local EXPLOSIVEBOLTREQLOG = GetModConfigData("ExplosiveBoltLog_req")
local EXPLOSIVEBOLTREQFEATHER = GetModConfigData("ExplosiveBoltFeather_req")
local EXPLOSIVEBOLTREQMOSQUITO = GetModConfigData("ExplosiveBoltMosquitoSack_req")
local EXPLOSIVEBOLTCRAFTNUM = GetModConfigData("ExplosiveBoltCraftAmount")
local EXPLOSIVEBOLTTECHLEVEL = GetModConfigData("ExplosiveBoltTechLevel")

local MUSKETBULLETREQHEAD = GetModConfigData("MusketBulletHead_req")
local MUSKETBULLETREQGP = GetModConfigData("MusketBulletGP_req")
local MUSKETBULLETCRAFTNUM = GetModConfigData("MusketBulletCraftAmount")

GLOBAL.TUNING.BOWUSES = GetModConfigData("BowUses")
GLOBAL.TUNING.BOWDMG = GetModConfigData("BowDmg")
GLOBAL.TUNING.BOWRANGE = GetModConfigData("BowRange")

GLOBAL.TUNING.COLLISIONSAREON = GetModConfigData("ActivateCollisions")

GLOBAL.TUNING.CROSSBOWDMGMOD = GetModConfigData("CrossbowDmgMod")
GLOBAL.TUNING.CROSSBOWRANGEMOD = GetModConfigData("CrossbowRangeMod")
GLOBAL.TUNING.CROSSBOWACCMOD = GetModConfigData("CrossbowAccMod")

GLOBAL.TUNING.MAGICBOWDMGMOD = GetModConfigData("MagicBowDmgMod")

GLOBAL.TUNING.MUSKETDMGMOD = GetModConfigData("MusketDmgMod")
GLOBAL.TUNING.MUSKETRANGEMOD = GetModConfigData("MusketRangeMod")
GLOBAL.TUNING.MUSKETACCMOD = GetModConfigData("MusketAccMod")

GLOBAL.TUNING.GOLDARROWDMGMOD = GetModConfigData("GoldArrowDmgMod")
GLOBAL.TUNING.MOONSTONEARROWDMGMOD = GetModConfigData("MoonstoneArrowDmgMod")

GLOBAL.TUNING.FIREARROWDMGMOD = GetModConfigData("FireArrowDmgMod")
GLOBAL.TUNING.ICEARROWDMGMOD = GetModConfigData("IceArrowDmgMod")
GLOBAL.TUNING.THUNDERARROWDMGMOD = GetModConfigData("ThunderArrowDmgMod")

GLOBAL.TUNING.LRCHARGENUM = GetModConfigData("LightningRodChargesNum")

GLOBAL.TUNING.POISONBOLTDMGMOD = GetModConfigData("PoisonBoltDmgMod")
GLOBAL.TUNING.POISONBOLTDURATION = GetModConfigData("PoisonBoltDuration")

GLOBAL.TUNING.EXPLOSIVEBOLTRAD = GetModConfigData("ExplosiveBoltRadius")
GLOBAL.TUNING.EXPLOSIVEBOLTDMG = GetModConfigData("ExplosiveBoltExpDmg")

GLOBAL.TUNING.HITREC = GetModConfigData("ArrowHitRecovery")
GLOBAL.TUNING.MISSREC = GetModConfigData("ArrowMissRecovery")
GLOBAL.TUNING.GOLDARROWRECCHANCEMOD = GetModConfigData("GoldArrowRecoveryMod")

GLOBAL.TUNING.BOWMISSCHANCESMALL = GetModConfigData("BowMissChanceSmall")
GLOBAL.TUNING.BOWMISSCHANCEBIG = GetModConfigData("BowMissChanceBig")

GLOBAL.TUNING.HITCHANCEBUGS = GetModConfigData("HitChanceBugs")
GLOBAL.TUNING.HITCHANCEFLYINGBIRDS = GetModConfigData("HitChanceTakeOff")

GLOBAL.TUNING.CRITCHANCEPVE = GetModConfigData("CritPvE")
GLOBAL.TUNING.CRITDMGMODPVE = GetModConfigData("CritDmgModPvE")


GLOBAL.INVINFO = {}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function ReturnTechLevel(modcfg)
	if modcfg == "NONE" then
		return TECH.NONE
	elseif modcfg == "SCIENCE_ONE" then
		return TECH.SCIENCE_ONE
	elseif modcfg == "SCIENCE_TWO" then
		return TECH.SCIENCE_TWO		
	elseif modcfg == "MAGIC_TWO" then
		return TECH.MAGIC_TWO			
	elseif modcfg == "MAGIC_THREE" then
		return TECH.MAGIC_THREE			
	end
end

local function AddModRecipe(_recName, _ingrList, _tab, _techLevel, _recType, _placer, _spacing, _proxyLock, _amount)
	if GLOBAL.CAPY_DLC and GLOBAL.IsDLCEnabled(GLOBAL.CAPY_DLC) then
		return GLOBAL.Recipe(_recName, _ingrList , _tab, _techLevel, _recType, _placer, _spacing, _proxyLock, _amount)
	else
		return GLOBAL.Recipe(_recName, _ingrList , _tab, _techLevel, _placer, _spacing, _proxyLock, _amount)
	end
end

STRINGS.TABS.ARCHERYTAB = "Archery"
GLOBAL.RECIPETABS['ARCHERYTAB'] = {str = "ARCHERYTAB", sort=6, icon = "archery_tab.tex", icon_atlas = "images/tabimages/archery_tab.xml"}

local archerytab = RECIPETABS.ARCHERYTAB

local QUIVERrecipeIngredients = {}

QUIVERrecipeIngredients[#QUIVERrecipeIngredients + 1]= GIngredient("pigskin", QUIVERREQPIGSKIN);
QUIVERrecipeIngredients[#QUIVERrecipeIngredients + 1] = GIngredient("rope", QUIVERREQROPE);

local quiverrecipe = AddModRecipe("zquiver", QUIVERrecipeIngredients , archerytab, ReturnTechLevel(QUIVERTECHLEVEL), "common", nil, nil, nil, 1)
quiverrecipe.atlas = "images/inventoryimages/zquiver.xml"

local BOWrecipeIngredients = {}

BOWrecipeIngredients[#BOWrecipeIngredients + 1]= GIngredient("twigs", BOWREQTWIGS);
BOWrecipeIngredients[#BOWrecipeIngredients + 1] = GIngredient("silk", BOWREQSILK);

local zbowrecipe = AddModRecipe("zbow", BOWrecipeIngredients , archerytab, ReturnTechLevel(BOWTECHLEVEL), "common", nil, nil, nil, 1)
zbowrecipe.atlas = "images/inventoryimages/zbow.xml"

local ARROWrecipeIngredients = {}

ARROWrecipeIngredients[#ARROWrecipeIngredients + 1]= GIngredient(ARROWHEADTYPE, ARROWREQHEAD);
ARROWrecipeIngredients[#ARROWrecipeIngredients + 1] = GIngredient(PROJSHAFTTYPE, ARROWREQLOG);
if ARROWREQFEATHER > 0 then
	ARROWrecipeIngredients[#ARROWrecipeIngredients + 1] = GIngredient("feather_crow", ARROWREQFEATHER);
end

local zarrowrecipe =  AddModRecipe("zarrow", ARROWrecipeIngredients , archerytab, ReturnTechLevel(ARROWTECHLEVEL), "common", nil, nil, nil, ARROWCRAFTNUM)
zarrowrecipe.atlas = "images/inventoryimages/zarrow.xml"

local GOLDARROWrecipeIngredients = {}

GOLDARROWrecipeIngredients[#GOLDARROWrecipeIngredients + 1]= GIngredient("goldnugget", GOLDARROWREQHEAD);
GOLDARROWrecipeIngredients[#GOLDARROWrecipeIngredients + 1] = GIngredient(PROJSHAFTTYPE, GOLDARROWREQLOG);
if GOLDARROWREQFEATHER > 0 then
	GOLDARROWrecipeIngredients[#GOLDARROWrecipeIngredients + 1] = GIngredient("feather_crow", GOLDARROWREQFEATHER);
end

local goldzarrowrecipe =  AddModRecipe("goldzarrow", GOLDARROWrecipeIngredients , archerytab, ReturnTechLevel(GOLDARROWTECHLEVEL), "common", nil, nil, nil, GOLDARROWCRAFTNUM)
goldzarrowrecipe.atlas = "images/inventoryimages/goldzarrow.xml"

local MOONSTONEARROWrecipeIngredients = {}

MOONSTONEARROWrecipeIngredients[#MOONSTONEARROWrecipeIngredients + 1]= GIngredient("orangegem", MOONSTONEARROWREQHEAD);
MOONSTONEARROWrecipeIngredients[#MOONSTONEARROWrecipeIngredients + 1] = GIngredient(PROJSHAFTTYPE, MOONSTONEARROWREQLOG);
if MOONSTONEARROWREQFEATHER > 0 then
	MOONSTONEARROWrecipeIngredients[#MOONSTONEARROWrecipeIngredients + 1] = GIngredient("feather_crow", MOONSTONEARROWREQFEATHER);
end

local moonstonezarrowrecipe =  AddModRecipe("moonstonezarrow", MOONSTONEARROWrecipeIngredients , archerytab, ReturnTechLevel(MOONSTONEARROWTECHLEVEL), "common", nil, nil, nil, MOONSTONEARROWCRAFTNUM)
moonstonezarrowrecipe.atlas = "images/inventoryimages/moonstonezarrow.xml"

local FIREARROWrecipeIngredients = {}

FIREARROWrecipeIngredients[#FIREARROWrecipeIngredients + 1] = GIngredient(PROJSHAFTTYPE, FIREARROWREQLOG);
FIREARROWrecipeIngredients[#FIREARROWrecipeIngredients + 1]= GIngredient(FIREARROWHEADTYPE, FIREARROWREQHEAD);
if FIREARROWREQFEATHER > 0 then
	FIREARROWrecipeIngredients[#FIREARROWrecipeIngredients + 1] = GIngredient("feather_robin", FIREARROWREQFEATHER);
end
if FIREARROWREQGRASS > 0 then
	FIREARROWrecipeIngredients[#FIREARROWrecipeIngredients + 1] = GIngredient("cutgrass", FIREARROWREQGRASS);
end

local firezarrowrecipe =  AddModRecipe("firezarrow", FIREARROWrecipeIngredients , archerytab, ReturnTechLevel(FIREARROWTECHLEVEL), "common", nil, nil, nil, FIREARROWCRAFTNUM)
firezarrowrecipe.atlas = "images/inventoryimages/firezarrow.xml"

local ICEARROWrecipeIngredients = {}

ICEARROWrecipeIngredients[#ICEARROWrecipeIngredients + 1] = GIngredient(PROJSHAFTTYPE, ICEARROWREQLOG);
ICEARROWrecipeIngredients[#ICEARROWrecipeIngredients + 1]= GIngredient(ICEARROWHEADTYPE, ICEARROWREQHEAD);
if ICEARROWREQFEATHER > 0 then
	ICEARROWrecipeIngredients[#ICEARROWrecipeIngredients + 1] = GIngredient("feather_robin_winter", ICEARROWREQFEATHER);
end

local icezarrowrecipe =  AddModRecipe("icezarrow", ICEARROWrecipeIngredients , archerytab, ReturnTechLevel(ICEARROWTECHLEVEL), "common", nil, nil, nil, ICEARROWCRAFTNUM)
icezarrowrecipe.atlas = "images/inventoryimages/icezarrow.xml"

local THUNDERARROWrecipeIngredients = {}

THUNDERARROWrecipeIngredients[#THUNDERARROWrecipeIngredients + 1] = GIngredient(PROJSHAFTTYPE, THUNDERARROWREQLOG);
THUNDERARROWrecipeIngredients[#THUNDERARROWrecipeIngredients + 1]= GIngredient(THUNDERARROWHEADTYPE, THUNDERARROWREQHEAD);
if THUNDERARROWREQFEATHER > 0 then
	THUNDERARROWrecipeIngredients[#THUNDERARROWrecipeIngredients + 1] = GIngredient("feather_robin_winter", THUNDERARROWREQFEATHER);
end

local thunderzarrowrecipe = AddModRecipe("thunderzarrow", THUNDERARROWrecipeIngredients , archerytab, ReturnTechLevel(THUNDERARROWTECHLEVEL), "common", nil, nil, nil, THUNDERARROWCRAFTNUM)
thunderzarrowrecipe.atlas = "images/inventoryimages/thunderzarrow.xml"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local CROSSBOWrecipeIngredients = {}

CROSSBOWrecipeIngredients[#CROSSBOWrecipeIngredients + 1]= GIngredient("boards", CROSSBOWREQBOARDS);
CROSSBOWrecipeIngredients[#CROSSBOWrecipeIngredients + 1] = GIngredient("silk", CROSSBOWREQSILK);
if CROSSBOWREQHAMMER > 0 then
	CROSSBOWrecipeIngredients[#CROSSBOWrecipeIngredients + 1] = GIngredient("hammer", CROSSBOWREQHAMMER);
end

local zcrossbowrecipe =  AddModRecipe("zcrossbow", CROSSBOWrecipeIngredients , archerytab, ReturnTechLevel(CROSSBOWTECHLEVEL), "common", nil, nil, nil, 1)
zcrossbowrecipe.atlas = "images/inventoryimages/zcrossbow.xml"

local BOLTrecipeIngredients = {}

BOLTrecipeIngredients[#BOLTrecipeIngredients + 1]= GIngredient(PROJSHAFTTYPE, BOLTREQLOG);
if BOLTREQFEATHER > 0 then
	BOLTrecipeIngredients[#BOLTrecipeIngredients + 1] = GIngredient("feather_crow", BOLTREQFEATHER);
end
BOLTrecipeIngredients[#BOLTrecipeIngredients + 1] = GIngredient(BOLTHEADTYPE, BOLTREQHEAD);

local zboltrecipe =  AddModRecipe("zbolt", BOLTrecipeIngredients , archerytab, ReturnTechLevel(BOLTTECHLEVEL), "common", nil, nil, nil, BOLTCRAFTNUM)
zboltrecipe.atlas = "images/inventoryimages/zbolt.xml"

local POISONBOLTrecipeIngredients = {}

POISONBOLTrecipeIngredients[#POISONBOLTrecipeIngredients + 1]= GIngredient(PROJSHAFTTYPE, POISONBOLTREQLOG);
if POISONBOLTREQFEATHER > 0 then
	POISONBOLTrecipeIngredients[#POISONBOLTrecipeIngredients + 1] = GIngredient("feather_crow", POISONBOLTREQFEATHER);
end
POISONBOLTrecipeIngredients[#POISONBOLTrecipeIngredients + 1] = GIngredient(POISONBOLTHEADTYPE, POISONBOLTREQHEAD);
POISONBOLTrecipeIngredients[#POISONBOLTrecipeIngredients + 1] = GIngredient("red_cap", POISONBOLTREQREDCAP);

local poisonzboltrecipe = AddModRecipe("poisonzbolt", POISONBOLTrecipeIngredients , archerytab, ReturnTechLevel(POISONBOLTTECHLEVEL), "common", nil, nil, nil, POISONBOLTCRAFTNUM)
poisonzboltrecipe.atlas = "images/inventoryimages/poisonzbolt.xml"

local EXPLOSIVEBOLTrecipeIngredients = {}

EXPLOSIVEBOLTrecipeIngredients[#EXPLOSIVEBOLTrecipeIngredients + 1]= GIngredient(PROJSHAFTTYPE, EXPLOSIVEBOLTREQLOG);
if EXPLOSIVEBOLTREQFEATHER > 0 then
	EXPLOSIVEBOLTrecipeIngredients[#EXPLOSIVEBOLTrecipeIngredients + 1] = GIngredient("feather_crow", EXPLOSIVEBOLTREQFEATHER);
end
if EXPLOSIVEBOLTREQMOSQUITO > 0 then
	EXPLOSIVEBOLTrecipeIngredients[#EXPLOSIVEBOLTrecipeIngredients + 1] = GIngredient("mosquitosack", EXPLOSIVEBOLTREQMOSQUITO);
end
EXPLOSIVEBOLTrecipeIngredients[#BOLTrecipeIngredients + 1] = GIngredient(EXPLOSIVEBOLTHEADTYPE, EXPLOSIVEBOLTREQHEAD);

local explosivezboltrecipe =  AddModRecipe("explosivezbolt", EXPLOSIVEBOLTrecipeIngredients , archerytab, ReturnTechLevel(EXPLOSIVEBOLTTECHLEVEL), "common", nil, nil, nil, EXPLOSIVEBOLTCRAFTNUM)
explosivezboltrecipe.atlas = "images/inventoryimages/explosivezbolt.xml"

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local MAGICBOWrecipeIngredients = {}

MAGICBOWrecipeIngredients[#MAGICBOWrecipeIngredients + 1] = GIngredient("livinglog", MAGICBOWREQLIVINGLOG);
MAGICBOWrecipeIngredients[#MAGICBOWrecipeIngredients + 1] = GIngredient("purplegem", MAGICBOWREQGEM);
if MAGICBOWREQGLOMMER then
	MAGICBOWrecipeIngredients[#MAGICBOWrecipeIngredients + 1] = GIngredient("glommerflower", 1);
end

local zmagicbowrecipe =  AddModRecipe("zmagicbow", MAGICBOWrecipeIngredients , archerytab, ReturnTechLevel(MAGICBOWTECHLEVEL), "common", nil, nil, nil, 1)
zmagicbowrecipe.atlas = "images/inventoryimages/zmagicbow.xml"

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local MUSKETrecipeIngredients = {}

MUSKETrecipeIngredients[#MUSKETrecipeIngredients + 1] = GIngredient("boards", MUSKETREQBOARDS);
MUSKETrecipeIngredients[#MUSKETrecipeIngredients + 1] = GIngredient("flint", MUSKETREQFLINT);
MUSKETrecipeIngredients[#MUSKETrecipeIngredients + 1] = GIngredient("goldnugget", MUSKETREQGOLD);

local zmusketrecipe =  AddModRecipe("zmusket", MUSKETrecipeIngredients , archerytab, ReturnTechLevel(MUSKETTECHLEVEL), "common", nil, nil, nil, 1)
zmusketrecipe.atlas = "images/inventoryimages/zmusket.xml"


local MUSKETBULLETrecipeIngredients = {}

MUSKETBULLETrecipeIngredients[#MUSKETBULLETrecipeIngredients + 1] = GIngredient("rocks", MUSKETBULLETREQHEAD);
MUSKETBULLETrecipeIngredients[#MUSKETBULLETrecipeIngredients + 1] = GIngredient("gunpowder", MUSKETBULLETREQGP);

local zmusket_bulletrecipe =  AddModRecipe("zmusket_bullet", MUSKETBULLETrecipeIngredients , archerytab, ReturnTechLevel(MUSKETTECHLEVEL), "common", nil, nil, nil, MUSKETBULLETCRAFTNUM)
zmusket_bulletrecipe.atlas = "images/inventoryimages/zmusket_bullet.xml"

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local FIREFLIESBALLrecipeIngredients = {}

FIREFLIESBALLrecipeIngredients[#FIREFLIESBALLrecipeIngredients + 1] = GIngredient("fireflies", 1);
FIREFLIESBALLrecipeIngredients[#FIREFLIESBALLrecipeIngredients + 1] = GIngredient("honey", 3);

local firefliesballrecipe =  AddModRecipe("z_firefliesball", FIREFLIESBALLrecipeIngredients , archerytab, ReturnTechLevel(MAGICBOWTECHLEVEL), "common", nil, nil, nil, 1)
firefliesballrecipe.atlas = "images/inventoryimages/firefliesball.xml"
firefliesballrecipe.image = "firefliesball.tex"

local BLUEGOOPrecipeIngredients = {}

BLUEGOOPrecipeIngredients[#BLUEGOOPrecipeIngredients + 1] = GIngredient("spidergland", 1);
BLUEGOOPrecipeIngredients[#BLUEGOOPrecipeIngredients + 1] = GIngredient("blue_cap", 1);

local bluegooprecipe =  AddModRecipe("z_bluegoop", BLUEGOOPrecipeIngredients , archerytab, ReturnTechLevel(MAGICBOWTECHLEVEL), "common", nil, nil, nil, 1)
bluegooprecipe.atlas = "images/inventoryimages/bluegoop.xml"
bluegooprecipe.image = "bluegoop.tex"

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

STRINGS.NAMES.ZBOW = "Wooden Bow"
STRINGS.RECIPE_DESC.ZBOW = "Useful if you can aim."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZBOW = "I used to be a good archer... then I took an arrow in the knee."

STRINGS.NAMES.ZQUIVER = "Quiver"
STRINGS.RECIPE_DESC.ZQUIVER = "Store your arrows!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZQUIVER = "With this stuff, I will look like a serious archer."

STRINGS.NAMES.ZARROW = "Basic Arrow"
STRINGS.RECIPE_DESC.ZARROW = "Do not throw it bare handed."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZARROW = "Probably best used with a bow..."

STRINGS.NAMES.GOLDZARROW = "Gold Arrow"
STRINGS.RECIPE_DESC.GOLDZARROW = "Hunt with style."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDZARROW = "I'm sure I could have found a better use this..."

STRINGS.NAMES.MOONSTONEZARROW = "Moon Rock Arrow"
STRINGS.RECIPE_DESC.MOONSTONEZARROW = "Expensive but efficient."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOONSTONEZARROW = "Sharp and shiny!"

STRINGS.NAMES.FIREZARROW = "Fire Arrow"
STRINGS.RECIPE_DESC.FIREZARROW = "Better be careful with that."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIREZARROW = "I should probably avoid using it in the middle of my camp..."

STRINGS.NAMES.ICEZARROW = "Freezing Arrow"
STRINGS.RECIPE_DESC.ICEZARROW = "Stay cool."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICEZARROW = "Should I keep it in the fridge?"

STRINGS.NAMES.THUNDERZARROW = "Thunder Arrow"
STRINGS.RECIPE_DESC.THUNDERZARROW = "Storm is coming."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.THUNDERZARROW = "The red wire on the plus..."

STRINGS.NAMES.DISCHARGEDTHUNDERZARROW = "Discharged Thunder Arrow"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISCHARGEDTHUNDERZARROW = "It looks like it is not active anymore."

STRINGS.NAMES.ZCROSSBOW = "Crossbow"
STRINGS.RECIPE_DESC.ZCROSSBOW = "Heavy and powerful."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZCROSSBOW = "This stuff is bigger than me."

STRINGS.NAMES.ZBOLT = "Basic Bolt"
STRINGS.RECIPE_DESC.ZBOLT = "Not a toothpick."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZBOLT = "Small projectile for such a big weapon..."

STRINGS.NAMES.POISONZBOLT = "Poison Bolt"
STRINGS.RECIPE_DESC.POISONZBOLT = "Cooked with arsenic."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.POISONZBOLT = "Did it have to be so ugly?"

STRINGS.NAMES.EXPLOSIVEZBOLT = "Explosive Bolt"
STRINGS.RECIPE_DESC.EXPLOSIVEZBOLT = "Do not use point blank."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EXPLOSIVEZBOLT = "Is it really a good idea?"

STRINGS.NAMES.ZMAGICBOW = "Magic Bow"
STRINGS.RECIPE_DESC.ZMAGICBOW = "Just like in fairy tails."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZMAGICBOW = "I expect a rainbow farting unicorns anytime soon."

STRINGS.NAMES.ZMUSKET = "Musket"
STRINGS.RECIPE_DESC.ZMUSKET = "It's loud. You're warned."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZMUSKET = "Am I the fifth musketeer?"

STRINGS.NAMES.ZMUSKET_BULLET = "Musket Bullet"
STRINGS.RECIPE_DESC.ZMUSKET_BULLET = "Let's go hunting my  deer."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZMUSKET_BULLET = "It looks like marbles"

STRINGS.NAMES.Z_FIREFLIESBALL = "Fireflies Ball"
STRINGS.RECIPE_DESC.Z_FIREFLIESBALL = "Do not eat"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.Z_FIREFLIESBALL = "It's probably useful for something. Don't ask me what."

STRINGS.NAMES.Z_BLUEGOOP = "Blue Goop"
STRINGS.RECIPE_DESC.Z_BLUEGOOP = "Do not shoot at your foes."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.Z_BLUEGOOP = "It looks gross."

-------------------------------------QUIVER EXTRA EQUIP SLOT-------------------------------------------------------------------------------------------------------------------------------------------------

GLOBAL.EQUIPSLOTS.QUIVER = "quiver"

AddGlobalClassPostConstruct("widgets/inventorybar", "Inv", function(self, owner)
--															local inventory = self.owner.components.inventory
--															local num_slot = inventory:GetNumSlots()
--															local extraslot = num_slot - 18 + 1 -- 18 is the regular amount, +1 since I will add one later
															
															if not RPGHUDisON then
																self.bg:SetScale(1.15+0.05,1,1)
																self.bgcover:SetScale(1.15+0.05,1,1)
															end
					
															self:AddEquipSlot(GLOBAL.EQUIPSLOTS.QUIVER, "images/tabimages/zquiver_slot.xml", "zquiver_slot.tex",99)
														end
)


-------------------------------------NEW ACTIONS--------------------------------------------------------------------------------------

local global_facing

local global_havezarrow
local global_targetisok
local global_targetislimbo
local global_havequiver
local global_projtypeok
local global_xzbowisarmed
local global_finishedarming
local global_conditions_fulfilled

local global_iszbowmagic
local global_magicweaponhasfuel

local allowedprojzbow = { "zarrow", "goldzarrow", "moonstonezarrow", "firezarrow", "icezarrow", "thunderzarrow", "dischargedthunderzarrow" }
local allowedprojzcrossbow = { "zbolt", "poisonzbolt", "explosivezbolt" }

local function DoZRangedAttack(act)
--	print("I entered the  ACTION ZRANGEDATTACK !")
	local equippedzbow = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
--	local proj = equippedzbow.components.zupalexsrangedweapons.projectile
	local quiver = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
	
	
	local ArrowsInInv = false
	
	global_havezarrow = false
	global_havequiver = false
	global_projtypeok = false
	global_targetislimbo = true
	
	local target = act.target
	local attackerpos = act.doer:GetPosition()
			
	if target == nil or target:HasTag("wall") then
		for k,v in pairs(GLOBAL.TheSim:FindEntities(attackerpos.x, attackerpos.y, attackerpos.z, 25)) do
			if v.components and v.components.combat and v.components.combat:CanBeAttacked(act.doer) and
			act.doer.components and act.doer.components.combat and act.doer.components.combat:CanTarget(v)
			and not v:HasTag("wall") and not act.doer:HasTag("player") then
				target = v
				break
			end
		end
	end
	
	if target and not target:IsInLimbo()  then
		global_targetislimbo = false	
--		print("target is not in limbo")

		if equippedzbow:HasTag("zbow") and equippedzbow:HasTag("magic") then
			if equippedzbow.components.fueled ~= nil and not equippedzbow.components.fueled:IsEmpty() then
				equippedzbow.components.zupalexsrangedweapons:LaunchProjectile(act.doer, target)
				equippedzbow.components.zupalexsrangedweapons:OnAttack(act.doer, target)
			end
		elseif quiver ~= nil and quiver.components.container ~= nil then
			global_havequiver = true
			local projinquiver = quiver.components.container:GetItemInSlot(1)
			
	--		ArrowsInInv = quiver.components.container:Has(proj,1)
	--		if ArrowsInInv then
			if projinquiver ~= nil then
	--			print("I can get the quiver and the zarrow in the action!")
				global_havezarrow = true
				
				for k, v in pairs(equippedzbow.components.zupalexsrangedweapons.allowedprojectiles) do
	--				print("Projectile in quiver : ", projinquiver.prefab, "   / found : ", v)
					if projinquiver.prefab == v then
	--					print("found a matching projectile")
						global_projtypeok = true
						break
					end
				end	
				
				if global_projtypeok then
					if not target:HasTag("wall") then
						equippedzbow.components.zupalexsrangedweapons:SetProjectile(projinquiver.prefab)
						equippedzbow.components.zupalexsrangedweapons:LaunchProjectile(act.doer, target)
						equippedzbow.components.zupalexsrangedweapons:OnAttack(act.doer, target)
					end
				end
			end
		end
	end
		
	return true
end

local BOWATTACK = GLOBAL.Action(4,		-- priority
								nil,	-- instant (set to not instant)
								false,	-- right mouse button
								GLOBAL.TUNING.BOWRANGE,	-- distance check
								nil,	-- ghost valid (set to not ghost valid)
								nil,	-- ghost exclusive
								true,	-- can force action
								nil)	-- Range check function
BOWATTACK.str = "Bow Attack"
BOWATTACK.id = "BOWATTACK"
BOWATTACK.fn = DoZRangedAttack


AddAction(BOWATTACK)

local CROSSBOWATTACK = GLOBAL.Action(4,		-- priority
								nil,	-- instant (set to not instant)
								false,	-- right mouse button
								GLOBAL.TUNING.BOWRANGE*GLOBAL.TUNING.CROSSBOWRANGEMOD,	-- distance check
								nil,	-- ghost valid (set to not ghost valid)
								nil,	-- ghost exclusive
								true,	-- can force action
								nil)	-- Range check function
CROSSBOWATTACK.str = "Crossbow Attack"
CROSSBOWATTACK.id = "CROSSBOWATTACK"
CROSSBOWATTACK.fn = DoZRangedAttack

AddAction(CROSSBOWATTACK)

local function ClearUseArrowTags(inst)
	inst:RemoveTag("use_zarrow")
	inst:RemoveTag("use_firezarrow")
end

local CHANGEARROWTYPE = GLOBAL.Action(5,		-- priority
								nil,	-- instant (set to not instant)
								true,	-- right mouse button
								nil,		-- distance check
								nil,	-- ghost valid (set to not ghost valid)
								nil,	-- ghost exclusive
								nil,	-- can force action
								nil)	-- Range check function
CHANGEARROWTYPE.str = "Change the ammo type to use"
CHANGEARROWTYPE.id = "CHANGEARROWTYPE"
CHANGEARROWTYPE.fn = function(act)
--	print("I entered the  ACTION CHANGEARROWTYPE!")

	local quiver = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
	local useditem = act.invobject
	local inventory = act.doer.components.inventory
					
--	print("Used object is : ", useditem.prefab)
	
	if useditem ~= nil and quiver.components.container ~= nil and quiver:HasTag("zupalexsrangedweapons") then
--		print("I have a quiver and a used item")
		local slotitem = quiver.components.container:GetItemInSlot(1)
			if useditem ~= slotitem then
				if slotitem == nil and
				quiver.components.container:CanTakeItemInSlot(useditem, 1) and
				(quiver.components.container.acceptsstacks or
				useditem.components.stackable == nil or
				not useditem.components.stackable:IsStack()) 
				then
--					print("there is nothing in the quiver and I put new zarrows")
--					inventory:RemoveItem(useditem, true)
--					quiver.components.container:GiveItem(useditem, 1)	
					local newactivezarrow = GLOBAL.SpawnPrefab(string.lower(useditem.prefab))
					newactivezarrow.components.stackable:SetStackSize(useditem.components.stackable.stacksize)
					quiver.components.container:GiveItem(newactivezarrow, 1)
					useditem:Remove()
			elseif useditem ~= nil and
				slotitem ~= nil and
				quiver.components.container:CanTakeItemInSlot(useditem, 1) and
				slotitem.prefab == useditem.prefab and
				slotitem.components.stackable ~= nil and
				quiver.components.container.acceptsstacks 
				then	
--					print("there is something in the quiver and i add to the existing stack")
					local currentactivestack = useditem.components.stackable.stacksize
					local currentstackinquiver = slotitem.components.stackable.stacksize
					local stackoverflow = currentactivestack - slotitem.components.stackable:RoomLeft()
					
--					print("inv stack = ", currentactivestack, "     /     quiver stack = ", currentstackinquiver, "     /     overflow = ", stackoverflow)
					
					if stackoverflow <= 0 then
						slotitem.components.stackable:SetStackSize(currentactivestack + currentstackinquiver)
						useditem:Remove()
					else
						slotitem.components.stackable:SetStackSize(slotitem.components.stackable.maxsize)
						useditem.components.stackable:SetStackSize(stackoverflow)
--						print("quiver stack old = ", currentstackinquiver, "     /     quiver stack new = ", slotitem.components.stackable.stacksize, "     /     leftover = ", useditem.components.stackable.stacksize)
					end
			elseif useditem ~= nil and
				slotitem ~= nil and
				quiver.components.container:CanTakeItemInSlot(useditem, slot) and
				not (slotitem.prefab == useditem.prefab and
					slotitem.components.stackable ~= nil and
					quiver.components.container.acceptsstacks) and
				not (useditem.components.stackable ~= nil and
					useditem.components.stackable:IsStack() and
					not quiver.components.container.acceptsstacks) 
				then
--					print("there is something in the quiver and i swap the two stacks")
					
					local newactivezarrow = GLOBAL.SpawnPrefab(useditem.prefab)
					newactivezarrow.components.stackable:SetStackSize(useditem.components.stackable.stacksize)
					
					local previnquiver = GLOBAL.SpawnPrefab(slotitem.prefab)
					previnquiver.components.stackable:SetStackSize(slotitem.components.stackable.stacksize)							
							
					slotitem:Remove()
					useditem:Remove()
					quiver.components.container:GiveItem(newactivezarrow, 1)	
					inventory:GiveItem(previnquiver)
					
					
					local foundemptyslot = false
			end
		end
	end
	
	return true
end

AddAction(CHANGEARROWTYPE)

local ARMCROSSBOW = GLOBAL.Action(	5,		-- priority
									nil,	-- instant (set to not instant)
									true,	-- right mouse button
									nil,		-- distance check
									nil,	-- ghost valid (set to not ghost valid)
									nil,	-- ghost exclusive
									nil,	-- can force action
									nil)	-- Range check function
ARMCROSSBOW.strfn = function(act)
	if act.invobject:HasTag("zcrossbow") then
		return "XBOW"
	elseif act.invobject:HasTag("zmusket") or act.invobject:HasTag("zbullet") then
		return "MUSKET"
	end
end
ARMCROSSBOW.id = "ARMCROSSBOW"
ARMCROSSBOW.fn = function(act)
--	print("I entered the  ACTION ARMCROSSBOW!")
	local invobj = act.invobject
	local target = act.target
	local inventory = act.doer.components.inventory
	
	if invobj.components.zupalexsrangedweapons ~= nil and 
		(invobj:HasTag("zcrossbow") or 
		(invobj:HasTag("zmusket") and inventory and (inventory:Has("zmusket_bullet", 1) or inventory:Has("zmusket_silverbullet", 1)))) then
			if not invobj:HasTag("readytoshoot") then
				invobj.components.zupalexsrangedweapons:OnArmed(act.doer)
			end
	end
	
	if target and invobj and invobj.components.zupalexsrangedweapons and target.components.zupalexsrangedweapons and invobj:HasTag("zbullet") and target:HasTag("zmusket") then
		if not target:HasTag("readytoshoot") then
			target.components.zupalexsrangedweapons:OnArmed(act.doer, invobj.prefab)
		end
	end

	return true
end

AddAction(ARMCROSSBOW)

local TRANSFERCHARGETOPROJECTILE = GLOBAL.Action(	6,		-- priority
													nil,	-- instant (set to not instant)
													nil,	-- right mouse button
													nil,	-- distance check
													nil,	-- ghost valid (set to not ghost valid)
													nil,	-- ghost exclusive
													nil,	-- can force action
													nil)	-- Range check function
TRANSFERCHARGETOPROJECTILE.str = "Recharge one projectile"
TRANSFERCHARGETOPROJECTILE.id = "TRANSFERCHARGETOPROJECTILE"
TRANSFERCHARGETOPROJECTILE.fn = function(act)
	local target = act.target
	local useditem = act.invobject
	local inventory = act.doer.components.inventory
	
	if target.chargeleft then
		if target.zchargeleft == nil then
			target.zchargeleft = GLOBAL.TUNING.LRCHARGENUM
		end
		
		target.zchargeleft = target.zchargeleft - 1

		if target.zchargeleft <= 0 then
			target.AnimState:ClearBloomEffectHandle()
			target.charged = false
			target.chargeleft = nil
			target.zchargeleft = nil
			target.Light:Enable(false)
			if target.zaptask then
				target.zaptask:Cancel()
				target.zaptask = nil
			end
			if target:HasTag("z_ischarged") then
				target:RemoveTag("z_ischarged")
			end
		end
	end
		
	local currentstack = useditem.components.stackable.stacksize
	
	local newproj = GLOBAL.SpawnPrefab("thunderzarrow")
	
	if currentstack > 1 then
		useditem.components.stackable:SetStackSize(currentstack - 1)
	else
		useditem:Remove()
	end
	
	inventory:GiveItem(newproj)
	
	return true
end

AddAction(TRANSFERCHARGETOPROJECTILE)

------------------------------------------------------------STATEGRAPHES-----------------------------------------------------------------------------

local zbow_attack = State({
    name = "zbow",
    tags = { "attack", "notalking", "abouttoattack", "autopredict", "busy" },

    onenter = function(inst)
        inst.sg.statemem.target = inst.components.combat.target
		local target = inst.components.combat.target
		local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local wornhat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local quiver = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
		local projinquiver = nil
		
		inst.components.locomotor:Stop()
	
		global_iszbowmagic = false	
		global_magicweaponhasfuel = false
		
		if equip:HasTag("magic") then
			global_iszbowmagic = true
			
			if equip:HasTag("hasfuel") then
				global_magicweaponhasfuel = true
			end
		end
		
		global_havequiver = false
		global_havezarrow = false	
		global_projtypeok = false

--		local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
		local cooldown = 60 * FRAMES
		
--		print("I am in the state and the quiver is : ", quiver)

		if not global_iszbowmagic then
			if quiver ~= nil and quiver.components.container ~= nil then
				global_havequiver = true
				projinquiver = quiver.components.container:GetItemInSlot(1)
			end
			
			if projinquiver ~= nil then
				global_havezarrow = true
				for k, v in pairs(allowedprojzbow) do
	--				print("Projectile in quiver (state) : ", projinquiver.prefab, "   / found : ", v)
					if projinquiver.prefab == v then
	--					print("found a matching projectile in state")
						global_projtypeok = true
						break
					end
				end
			end
		end
		
		if target ~= nil and not target:HasTag("wall") then
			global_targetisok = true
		else
			global_targetisok = false
		end

		global_conditions_fulfilled = false
		if ((global_havequiver and global_havezarrow and global_projtypeok) or (global_iszbowmagic and global_magicweaponhasfuel)) and global_targetisok then
			global_conditions_fulfilled = true
		end
		
--		print("Conditions status is : ", global_havequiver, "   ", global_havezarrow, "   ", global_targetisok, "   ", global_projtypeok, "   => ", global_conditions_fulfilled)
		
		if not global_conditions_fulfilled then
			inst.AnimState:PlayAnimation("idle", true)
		end
		
--		print("have zarrow : ", global_havezarrow, "   /   target is ok : ", global_targetisok)			
		
	    if equip ~= nil and equip.components.zupalexsrangedweapons ~= nil and global_conditions_fulfilled then
			inst.components.combat:StartAttack()
		
--			print("And I found the BOW on the host!")
			inst.AnimState:PlayAnimation("bow_attack")

			inst.xoffsetBS = -70
			inst.yoffsetBS = 90
			inst.zoffsetBS = 0
			
			if inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_UP then
				inst.zoffsetBS = -0.1
				if wornhat ~= nil then
--					print("hat and face up")
					inst.AnimState:Hide("timeline_0")
				else
--					print("no hat and face up")
					inst.AnimState:Hide("timeline_15")
				end
			elseif inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_DOWN then
				inst.xoffsetBS = -65
				inst.yoffsetBS = 85
				if wornhat ~= nil then
--					print("hat and face down")
					inst.AnimState:Hide("timeline_3")
				else
--				print("no hat and face down")
				inst.AnimState:Hide("timeline_16")
				end
			else
				if wornhat ~= nil then
--					print("hat and face side")
					inst.AnimState:Hide("timeline_3")
				else
--				print("no hat and face side")
				inst.AnimState:Hide("timeline_16")
				end
			end
        end

		inst.sg:SetTimeout(cooldown)
		
        if target ~= nil and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.attacktarget = target
        end
    end,

    timeline =
    {		
		TimeEvent(0 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										if global_iszbowmagic then
											inst.beamstring = GLOBAL.SpawnPrefab("beamstring")
											inst.beamstring.Transform:SetPosition(inst:GetPosition():Get())
											inst.beamstring:SetFollowTarget(inst, "swap_beamstring", inst.xoffsetBS, inst.yoffsetBS, inst.zoffsetBS)
											inst.beamstring.AnimState:PlayAnimation("drawandshoot")
											inst.beamstring.AnimState:SetLayer(GLOBAL.LAYER_WORLD)
--											inst.beamstring.AnimState:SetSortOrder(0)
	
											inst.SoundEmitter:PlaySound("bow_shoot/magicbow_shoot/buzz", "buzz")
										else
											inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_draw")
										end
									else
										inst.sg:RemoveStateTag("abouttoattack")
									end
								end),	
	
		TimeEvent(8 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										if global_iszbowmagic then
											inst.SoundEmitter:PlaySound("bow_shoot/magicbow_shoot/shot")
										else
											inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_shoot")
										end
									end
								end),	
	
		TimeEvent(14 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										-- print("Attack should be performed now")
										inst.components.combat:DoAttack(inst.sg.statemem.target) 
										inst.sg:RemoveStateTag("abouttoattack")
									end
								end),
							
		TimeEvent(15 * FRAMES, function(inst)
									if not global_conditions_fulfilled then
										inst.sg:RemoveStateTag("attack")
										inst.AnimState:PlayAnimation("idle")
									elseif global_iszbowmagic then
										inst.SoundEmitter:KillSound("buzz")
									end
								end),
								
		TimeEvent(18 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										inst.sg:RemoveStateTag("attack")
										inst.sg:RemoveStateTag("busy")
									end
								end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
		inst.sg:RemoveStateTag("busy")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
--		print("I exit the SG of the host NOW")
        inst.components.combat:SetTarget(nil)
		
		if global_iszbowmagic and inst.beamstring ~= nil then
			inst.beamstring:Remove()
		end
		
		
		if inst.components.talker then
			if not global_iszbowmagic then
				if not global_havequiver then
					local noquiver_message = "I should first get a quiver!"
					inst.components.talker:Say(noquiver_message)
				elseif not global_havezarrow then
					local noammo_message = "My quiver is empty!"
					inst.components.talker:Say(noammo_message)
				elseif not global_projtypeok then
					local badammo_message = "This won't fit it my current weapon..."
					inst.components.talker:Say(badammo_message)
				elseif global_targetislimbo then
					local targetinlimbo_message = "It's too late now..."
					inst.components.talker:Say(targetinlimbo_message)
				elseif not global_targetisok then
					local fail_message = "There's no potential target on sight."
					inst.components.talker:Say(fail_message)
				end
			else
				if not global_magicweaponhasfuel then
					local nomagicfuel_message = "It looks like this stuff ran out of juice."
					inst.components.talker:Say(nomagicfuel_message)
				end
			end
		end
		
		inst.AnimState:Show("timeline_0")
		inst.AnimState:Show("timeline_3")
		inst.AnimState:Show("timeline_15")
		inst.AnimState:Show("timeline_16")
    end,		
})

AddStategraphState("wilson", zbow_attack)
AddStategraphState("wilsonboating", zbow_attack)

local zcrossbow_attack = State({
    name = "zcrossbow",
    tags = { "attack", "notalking", "abouttoattack", "autopredict", "busy" },

    onenter = function(inst)
        inst.sg.statemem.target = inst.components.combat.target
		local target = inst.components.combat.target
		local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local wornhat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local quiver = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
		local projinquiver = nil
		
		inst.components.locomotor:Stop()
		
		local ArrowsInInv = false
		
--		local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
		local cooldown = 60 * FRAMES
		
--		print("I am in the state and the quiver is : ", quiver)
		
		if quiver ~= nil and quiver.components.container ~= nil then
			global_havequiver = true
			projinquiver = quiver.components.container:GetItemInSlot(1)
		else
			global_havequiver = false
		end
		
		global_projtypeok = false
		if projinquiver ~= nil then
			global_havezarrow = true
			for k, v in pairs(allowedprojzcrossbow) do
--				print("Projectile in quiver (state) : ", projinquiver.prefab, "   / found : ", v)
				if projinquiver.prefab == v then
--					print("found a matching projectile in state")
					global_projtypeok = true
					break
				end
			end		
		else
			global_havezarrow = false
		end
		
		if equip:HasTag("zupalexsrangedweapons") and (equip:HasTag("zcrossbow") or equip:HasTag("zmusket")) and equip:HasTag("readytoshoot") then
			global_xbowisarmed = true
		else
			global_xbowisarmed = false
		end
		
		if target ~= nil and not target:HasTag("wall") then
			global_targetisok = true
		else
			global_targetisok = false
		end
		
		if equip:HasTag("zmusket") then
			global_havequiver = true
			global_havezarrow = true
			global_projtypeok = true
		end
			
		global_conditions_fulfilled = false	
		if global_havequiver and global_havezarrow and global_targetisok and global_projtypeok and global_xbowisarmed then
			global_conditions_fulfilled = true
		end
		
--		print("Conditions status is : ", global_havequiver, "   ", global_havezarrow, "   ", global_targetisok, "   ", global_projtypeok, "   => ", global_conditions_fulfilled)
		
		if not global_conditions_fulfilled then
			inst.AnimState:PlayAnimation("idle", true)
		end
			
--		print("have zarrow : ", global_havezarrow, "   /   target is ok : ", global_targetisok)			
			
	    if equip ~= nil and equip.components.zupalexsrangedweapons ~= nil and global_conditions_fulfilled then
			inst.components.combat:StartAttack()
		
--			print("And I found the BOW on the host!")
			inst.AnimState:PlayAnimation("crossbow_attack")

			if wornhat ~= nil then
				if inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_UP then
--					print("hat and face up")
					inst.AnimState:Hide("timeline_0")
				elseif inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_DOWN then
--					print("hat and face down")
					inst.AnimState:Hide("timeline_3")
				else
--					print("hat and face side")
					inst.AnimState:Hide("timeline_3")
				end
			else
				if inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_UP then
--					print("no hat and face up")
					inst.AnimState:Hide("timeline_15")
				elseif inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_DOWN then
--					print("no hat and face down")
					inst.AnimState:Hide("timeline_16")
				else
--					print("no hat and face side")
					inst.AnimState:Hide("timeline_16")
				end
			end
        end

		inst.sg:SetTimeout(cooldown)
		
        if target ~= nil and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.attacktarget = target
        end
    end,

    timeline =
    {		
		TimeEvent(15 * FRAMES, function(inst)
									if not global_conditions_fulfilled then
										inst.sg:RemoveStateTag("abouttoattack")
										inst.AnimState:PlayAnimation("idle")
									end
								end),
	
		TimeEvent(18 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										if global_weapname == "zcrossbow" then
											inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_shoot", nil, nil, true)
										elseif global_weapname == "zmusket" then
											inst.SoundEmitter:PlaySound("bow_shoot/musket/shot", nil, nil, true)
										end
									end
								end),	
	
		TimeEvent(23 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										inst.components.combat:DoAttack(inst.sg.statemem.target) 
										inst.sg:RemoveStateTag("abouttoattack")
									end
								end),
								
		TimeEvent(27 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										inst.sg:RemoveStateTag("attack")
										inst.sg:RemoveStateTag("busy")
									end
								end),							
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
		inst.sg:RemoveStateTag("busy")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
--		print("I exit the SG of the host NOW")
        inst.components.combat:SetTarget(nil)
		
		if inst.components.talker then
			if not global_havequiver then
				local noquiver_message = "I should first get a quiver!"
				inst.components.talker:Say(noquiver_message)
			elseif not global_havezarrow then
				local noammo_message = "My quiver is empty!"
				inst.components.talker:Say(noammo_message)
			elseif not global_projtypeok then
				local badammo_message = "This won't fit it my current weapon..."
				inst.components.talker:Say(badammo_message)
			elseif not global_xbowisarmed then
				local xzbownotarmed_message = "I won't shoot far if I don't arm it first..."
				inst.components.talker:Say(xzbownotarmed_message)
			elseif global_targetislimbo then
				local targetinlimbo_message = "It's too late now..."
				inst.components.talker:Say(targetinlimbo_message)
			elseif not global_targetisok then
				local fail_message = "There's no potential target on sight."
				inst.components.talker:Say(fail_message)
			end
		end
		
		inst.AnimState:Show("timeline_0")
		inst.AnimState:Show("timeline_3")
		inst.AnimState:Show("timeline_15")
		inst.AnimState:Show("timeline_16")
    end,		
})

AddStategraphState("wilson", zcrossbow_attack)
AddStategraphState("wilsonboating", zcrossbow_attack)

local zcrossbow_arm = State({
    name = "zcrossbow_arm",
    tags = { "doing", "busy" },

    onenter = function(inst)
		local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local wornhat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		
		global_weapname = equip.prefab
		global_hasbullet = (inst.components.inventory and inst.components.inventory:Has("zmusket_bullet", 1 ) or inst.components.inventory:Has("zmusket_silverbullet", 1)) or equip:HasTag("zcrossbow")
		
		inst.components.locomotor:Stop()
		inst.sg.statemem.action = inst.bufferedaction
		
		global_finishedarming = false
		
		local cooldown = 130 * FRAMES
			
		if equip:HasTag("zupalexsrangedweapons") and (equip:HasTag("zcrossbow") or equip:HasTag("zmusket")) and not equip:HasTag("readytoshoot") then
			global_xbowisarmed = false
		else
			global_xbowisarmed = true
		end
			
		global_conditions_fulfilled = false	
		if not global_xbowisarmed then
			global_conditions_fulfilled = true
		end
		
--		print("Conditions status is : ", global_havequiver, "   ", global_havezarrow, "   ", global_targetisok, "   ", global_projtypeok, "   => ", global_conditions_fulfilled)
		
		local playerposx, playerposy, playerposz = inst.Transform:GetWorldPosition()
		inst:ForceFacePoint(playerposx, playerposy-50, playerposz)
		
		if not global_conditions_fulfilled then
			inst.AnimState:PlayAnimation("idle", true)
		else	
			if global_weapname == "zcrossbow" then
				inst.AnimState:PlayAnimation("crossbow_arm")
			elseif global_weapname == "zmusket" then
				inst.AnimState:PlayAnimation("musket_reload")	
				inst.AnimState:OverrideSymbol("swap_mloader", "swap_zmloader", "swap_zmloader")
			end

			if wornhat ~= nil then
				inst.AnimState:Hide("timeline_3")
			else
				inst.AnimState:Hide("timeline_16")
			end
        end
		
		inst.sg:SetTimeout(cooldown)
    end,

    timeline =
    {	
		TimeEvent(0 * FRAMES, function(inst)
									if not global_conditions_fulfilled then
										inst:ClearBufferedAction()
									end
								end),
	
		TimeEvent(15 * FRAMES, function(inst)
									inst.sg:RemoveStateTag("busy")
									if not global_conditions_fulfilled then
										inst.AnimState:PlayAnimation("idle")
									end
								end),
	
		TimeEvent(31 * FRAMES, function(inst)
									if global_conditions_fulfilled and global_weapname == "zcrossbow" then
										inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_draw", nil, nil, true)
										inst.AnimState:OverrideSymbol("swap_object", "swap_zcrossbow", "swap_crossbow_armed")
									end
								end),	
	
		TimeEvent(62 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										inst:PerformBufferedAction()
										global_finishedarming = true
									end
								end),

		TimeEvent(63 * FRAMES, function(inst)
									if global_conditions_fulfilled and global_weapname == "zmusket" then
										inst.SoundEmitter:PlaySound("bow_shoot/musket/reload", nil, nil, true)
									end
								end),	
								
		TimeEvent(103 * FRAMES, function(inst)
									if global_conditions_fulfilled and global_weapname == "zmusket" then
										inst:PerformBufferedAction()
										global_finishedarming = true
									end
								end),
    },

    ontimeout = function(inst)
		inst.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow")
		owner.AnimState:ClearOverrideSymbol("swap_mloader")
        inst.sg:GoToState("idle", true)
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
		inst.AnimState:ClearOverrideSymbol("swap_mloader")
        inst.sg.statemem.action = nil
	
		if global_weapname == "zcrossbow" and not global_finishedarming and not global_xbowisarmed then
			inst.AnimState:OverrideSymbol("swap_object", "swap_zcrossbow", "swap_zcrossbow")
		end
	
		if inst.components.talker then
			if not global_hasbullet then
				local nobullet_message = "I do not have anything to put in..."
				inst.components.talker:Say(nobullet_message)	
			elseif global_xbowisarmed and global_weapname == "zcrossbow" then
				local alreadyarmed_message = "If I pull even more on this stuff it will break..."
				inst.components.talker:Say(alreadyarmed_message)
			elseif global_xbowisarmed and global_weapname == "zmusket" then
				local alreadyarmed_message = "It is probably not a good idea to pile it up..."
				inst.components.talker:Say(alreadyarmed_message)
			end
		end
		
		inst.AnimState:Show("timeline_0")
		inst.AnimState:Show("timeline_3")
		inst.AnimState:Show("timeline_15")
		inst.AnimState:Show("timeline_16")
    end,		
})

AddStategraphState("wilson", zcrossbow_arm)
AddStategraphState("wilsonboating", zcrossbow_arm)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.CHANGEARROWTYPE, "doshortaction"))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TRANSFERCHARGETOPROJECTILE, "dolongaction"))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ARMCROSSBOW, function(inst, action)
																			local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
																			return ((weapon:HasTag("zcrossbow") or weapon:HasTag("zmusket")) and "zcrossbow_arm")
																		end
													)
)     

AddStategraphActionHandler("wilsonboating", ActionHandler(ACTIONS.CHANGEARROWTYPE, "doshortaction"))

AddStategraphActionHandler("wilsonboating", ActionHandler(ACTIONS.TRANSFERCHARGETOPROJECTILE, "dolongaction"))

AddStategraphActionHandler("wilsonboating", ActionHandler(ACTIONS.ARMCROSSBOW, function(inst, action)
																			local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
																			return ((weapon:HasTag("zcrossbow") or weapon:HasTag("zmusket")) and "zcrossbow_arm")
																		end
													)
) 

AddStategraphPostInit("wilson", function(_sg)
	local OriginalDestStateATTACK = _sg.events.doattack.fn
	
	local function NewDestStateATTACK(inst, action)
		inst.sg.mem.localchainattack = not action.forced or nil
		local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
		
		-- print("Executing the modified ACTION.ATTACK destination state check")
		
		if weapon and weapon:HasTag("zupalexsrangedweapons") and not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") and inst.components.combat ~= nil then
			if weapon:HasTag("zbow") then
				inst.sg:GoToState("zbow")
			elseif weapon:HasTag("zcrossbow") or weapon:HasTag("zmusket") then
				inst.sg:GoToState("zcrossbow")
			end
		else
			return OriginalDestStateATTACK(inst, action)
		end
	end
	
	_sg.events.doattack.fn = NewDestStateATTACK
end)

AddStategraphPostInit("wilsonboating", function(_sg)
	local OriginalDestStateATTACK = _sg.events.doattack.fn
	
	local function NewDestStateATTACK(inst, action)
		inst.sg.mem.localchainattack = not action.forced or nil
		local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
		
		-- print("Executing the modified ACTION.ATTACK destination state check")
		
		if weapon and weapon:HasTag("zupalexsrangedweapons") and not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") and inst.components.combat ~= nil then
			if weapon:HasTag("zbow") then
				inst.sg:GoToState("zbow")
			elseif weapon:HasTag("zcrossbow") or weapon:HasTag("zmusket") then
				inst.sg:GoToState("zcrossbow")
			end
		else
			return OriginalDestStateATTACK(inst, action)
		end
	end
	
	_sg.events.doattack.fn = NewDestStateATTACK
end)


local function InvBarPostConstruct(self, owner)
	GLOBAL.INVINFO.ITEMSLOTSNUM = self.owner.components.inventory:GetNumSlots()
	GLOBAL.INVINFO.EQUIPSLOTINFO = self.equipslotinfo
	GLOBAL.INVINFO.EQUIP = self.equip
	GLOBAL.INVINFO.INV = self.inv
end

AddClassPostConstruct("widgets/inventorybar", InvBarPostConstruct)

local function EquipSlotPostConstruct(self, equipslot, atlas, bgim, owner)
	GLOBAL.INVINFO["EQUIPSLOT_"..equipslot] = self
end

AddClassPostConstruct("widgets/equipslot", EquipSlotPostConstruct)

local function FixForOpenQuiverWhileBoating(self, owner)
	local origOnUpdate = self.OnUpdate
	
	self.OnUpdate = function(dt)
		if self.isopen and self.owner and self.container 
			and not (self.container.components.inventoryitem and self.container.components.inventoryitem:IsHeldBy(self.owner)) 
			and self.container ~= GLOBAL.GetPlayer().components.driver.vehicle 
			and self.container.prefab == "zquiver" then
				return
		else
			origOnUpdate(dt)
		end		
	end
end

AddClassPostConstruct("widgets/containerwidget", FixForOpenQuiverWhileBoating)

AddComponentPostInit("inventory", function(_comp)
	local OriginalInventoryOnLoad = _comp.OnLoad
	
	_comp.OnLoad = function(self, data, newents)
		OriginalInventoryOnLoad(self, data, newents)
		
		if data.items then
			for k,v in pairs(data.items) do	
				local inst = GLOBAL.SpawnSaveRecord(v, newents)
				
				if inst ~= nil then
					inst:Remove()
				else
					local modstring = nil
					if string.find(v.prefab, "arrow", 1) ~= nil then
						modstring = string.gsub(v.prefab, "arrow", "zarrow")
					elseif string.find(v.prefab, "bolt", 1) ~= nil then
						modstring = string.gsub(v.prefab, "bolt", "zbolt")
					else
						modstring = "z"..v.prefab
					end
					
					print("Attempt to replace invalid prefab...", v.prefab, " with ", modstring)
					v.prefab = modstring
					inst = modstring ~= nil and GLOBAL.SpawnSaveRecord(v, newents) or nil
					
					if inst then
						self:GiveItem(inst, k)
					end
				end
			end
		end
		
		if data.equip then
			for k,v in pairs(data.equip) do
				local inst = GLOBAL.SpawnSaveRecord(v, newents)
				
				if inst ~= nil then
					inst:Remove()
				else
					local modstring = nil
					if string.find(v.prefab, "arrow", 1) ~= nil then
						modstring = string.gsub(v.prefab, "arrow", "zarrow")
					elseif string.find(v.prefab, "bolt", 1) ~= nil then
						modstring = string.gsub(v.prefab, "bolt", "zbolt")
					else
						modstring = "z"..v.prefab
					end
					
					print("Attempt to replace invalid prefab...", v.prefab, " with ", modstring)
					v.prefab = modstring
					inst = modstring ~= nil and GLOBAL.SpawnSaveRecord(v, newents) or nil
					
					if inst then
						self:GiveItem(inst, k)
					end
				end
			end
		end
	end
end)


AddComponentPostInit("container", function(_comp)
	local OriginalInventoryOnLoad = _comp.OnLoad
	
	_comp.OnLoad = function(self, data, newents)
		OriginalInventoryOnLoad(self, data, newents)
		
		if data.items then
			for k,v in pairs(data.items) do
				local inst = GLOBAL.SpawnSaveRecord(v, newents)
				
				if inst ~= nil then
					inst:Remove()
				else
					local modstring = nil
					if string.find(v.prefab, "arrow", 1) ~= nil then
						modstring = string.gsub(v.prefab, "arrow", "zarrow")
					elseif string.find(v.prefab, "bolt", 1) ~= nil then
						modstring = string.gsub(v.prefab, "bolt", "zbolt")
					else
						modstring = "z"..v.prefab
					end
					
					print("Attempt to replace invalid prefab...", v.prefab, " with ", modstring)
					v.prefab = modstring
					inst = modstring ~= nil and GLOBAL.SpawnSaveRecord(v, newents) or nil
					
					if inst then
						self:GiveItem(inst, k)
					end
				end
			end
		end
	end
end)

------------------------------------------------------ ADDING STUFFS TO CONSTANT TABLES -----------------------------------------------------------------------

GLOBAL.STRINGS.ACTIONS["ARMCROSSBOW"] = {
	XBOW = "Arm the Crossbow",
	MUSKET = "Reload the Musket",
}