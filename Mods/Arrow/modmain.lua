PrefabFiles = {
    "bow",
	"quiver",
	"sparkles",
	"zupalexsingredients",
}

Assets = {
    Asset( "ANIM", "anim/bow_attack.zip" ),
	Asset("SOUNDPACKAGE", "sound/bow_shoot.fev"),
    Asset("SOUND", "sound/bow_shoot_bank00.fsb"),
	
	Asset("ATLAS", "images/tabimages/archery_tab.xml"),
    Asset("IMAGE", "images/tabimages/archery_tab.tex"),
	
	Asset("ATLAS", "images/tabimages/quiver_slot.xml"),
    Asset("IMAGE", "images/tabimages/quiver_slot.tex"),
}

local require = GLOBAL.require

local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
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

GLOBAL.TUNING.BOWUSES = GetModConfigData("BowUses")
GLOBAL.TUNING.BOWDMG = GetModConfigData("BowDmg")
GLOBAL.TUNING.BOWRANGE = GetModConfigData("BowRange")

GLOBAL.TUNING.COLLISIONSAREON = GetModConfigData("ActivateCollisions")

GLOBAL.TUNING.CROSSBOWDMGMOD = GetModConfigData("CrossbowDmgMod")
GLOBAL.TUNING.CROSSBOWRANGEMOD = GetModConfigData("CrossbowRangeMod")
GLOBAL.TUNING.CROSSBOWACCMOD = GetModConfigData("CrossbowAccMod")

GLOBAL.TUNING.MAGICBOWDMGMOD = GetModConfigData("MagicBowDmgMod")

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

STRINGS.TABS.ARCHERYTAB = "Archery"
GLOBAL.RECIPETABS['ARCHERYTAB'] = {str = "ARCHERYTAB", sort=6, icon = "archery_tab.tex", icon_atlas = "images/tabimages/archery_tab.xml"}

local archerytab = RECIPETABS.ARCHERYTAB

local QUIVERrecipeIngredients = {}

QUIVERrecipeIngredients[#QUIVERrecipeIngredients + 1]= GIngredient("pigskin", QUIVERREQPIGSKIN);
QUIVERrecipeIngredients[#QUIVERrecipeIngredients + 1] = GIngredient("rope", QUIVERREQROPE);

local quiverrecipe = GLOBAL.Recipe("quiver", QUIVERrecipeIngredients , archerytab, ReturnTechLevel(QUIVERTECHLEVEL), nil, nil, nil, 1)
quiverrecipe.atlas = "images/inventoryimages/quiver.xml"

local BOWrecipeIngredients = {}

BOWrecipeIngredients[#BOWrecipeIngredients + 1]= GIngredient("twigs", BOWREQTWIGS);
BOWrecipeIngredients[#BOWrecipeIngredients + 1] = GIngredient("silk", BOWREQSILK);

local bowrecipe = GLOBAL.Recipe("bow", BOWrecipeIngredients , archerytab, ReturnTechLevel(BOWTECHLEVEL), nil, nil, nil, 1)
bowrecipe.atlas = "images/inventoryimages/bow.xml"

local ARROWrecipeIngredients = {}

ARROWrecipeIngredients[#ARROWrecipeIngredients + 1]= GIngredient(ARROWHEADTYPE, ARROWREQHEAD);
ARROWrecipeIngredients[#ARROWrecipeIngredients + 1] = GIngredient(PROJSHAFTTYPE, ARROWREQLOG);
if ARROWREQFEATHER > 0 then
	ARROWrecipeIngredients[#ARROWrecipeIngredients + 1] = GIngredient("feather_crow", ARROWREQFEATHER);
end

local arrowrecipe =  GLOBAL.Recipe("arrow", ARROWrecipeIngredients , archerytab, ReturnTechLevel(ARROWTECHLEVEL), nil, nil, nil, ARROWCRAFTNUM)
arrowrecipe.atlas = "images/inventoryimages/arrow.xml"

local GOLDARROWrecipeIngredients = {}

GOLDARROWrecipeIngredients[#GOLDARROWrecipeIngredients + 1]= GIngredient("goldnugget", GOLDARROWREQHEAD);
GOLDARROWrecipeIngredients[#GOLDARROWrecipeIngredients + 1] = GIngredient(PROJSHAFTTYPE, GOLDARROWREQLOG);
if GOLDARROWREQFEATHER > 0 then
	GOLDARROWrecipeIngredients[#GOLDARROWrecipeIngredients + 1] = GIngredient("feather_crow", GOLDARROWREQFEATHER);
end

local goldarrowrecipe =  GLOBAL.Recipe("goldarrow", GOLDARROWrecipeIngredients , archerytab, ReturnTechLevel(GOLDTECHLEVEL), nil, nil, nil, GOLDARROWCRAFTNUM)
goldarrowrecipe.atlas = "images/inventoryimages/goldarrow.xml"

local MOONSTONEARROWrecipeIngredients = {}

MOONSTONEARROWrecipeIngredients[#MOONSTONEARROWrecipeIngredients + 1]= GIngredient("orangegem", MOONSTONEARROWREQHEAD);
MOONSTONEARROWrecipeIngredients[#MOONSTONEARROWrecipeIngredients + 1] = GIngredient(PROJSHAFTTYPE, MOONSTONEARROWREQLOG);
if MOONSTONEARROWREQFEATHER > 0 then
	MOONSTONEARROWrecipeIngredients[#MOONSTONEARROWrecipeIngredients + 1] = GIngredient("feather_crow", MOONSTONEARROWREQFEATHER);
end

local moonstonearrowrecipe =  GLOBAL.Recipe("moonstonearrow", MOONSTONEARROWrecipeIngredients , archerytab, ReturnTechLevel(MOONSTONETECHLEVEL), nil, nil, nil, MOONSTONEARROWCRAFTNUM)
moonstonearrowrecipe.atlas = "images/inventoryimages/moonstonearrow.xml"

local FIREARROWrecipeIngredients = {}

FIREARROWrecipeIngredients[#FIREARROWrecipeIngredients + 1] = GIngredient(PROJSHAFTTYPE, FIREARROWREQLOG);
FIREARROWrecipeIngredients[#FIREARROWrecipeIngredients + 1]= GIngredient(FIREARROWHEADTYPE, FIREARROWREQHEAD);
if FIREARROWREQFEATHER > 0 then
	FIREARROWrecipeIngredients[#FIREARROWrecipeIngredients + 1] = GIngredient("feather_robin", FIREARROWREQFEATHER);
end
if FIREARROWREQGRASS > 0 then
	FIREARROWrecipeIngredients[#FIREARROWrecipeIngredients + 1] = GIngredient("cutgrass", FIREARROWREQGRASS);
end

local firearrowrecipe =  GLOBAL.Recipe("firearrow", FIREARROWrecipeIngredients , archerytab, ReturnTechLevel(FIREARROWTECHLEVEL), nil, nil, nil, FIREARROWCRAFTNUM)
firearrowrecipe.atlas = "images/inventoryimages/firearrow.xml"

local ICEARROWrecipeIngredients = {}

ICEARROWrecipeIngredients[#ICEARROWrecipeIngredients + 1] = GIngredient(PROJSHAFTTYPE, ICEARROWREQLOG);
ICEARROWrecipeIngredients[#ICEARROWrecipeIngredients + 1]= GIngredient(ICEARROWHEADTYPE, ICEARROWREQHEAD);
if ICEARROWREQFEATHER > 0 then
	ICEARROWrecipeIngredients[#ICEARROWrecipeIngredients + 1] = GIngredient("feather_robin_winter", ICEARROWREQFEATHER);
end

local icearrowrecipe =  GLOBAL.Recipe("icearrow", ICEARROWrecipeIngredients , archerytab, ReturnTechLevel(ICEARROWTECHLEVEL), nil, nil, nil, ICEARROWCRAFTNUM)
icearrowrecipe.atlas = "images/inventoryimages/icearrow.xml"

local THUNDERARROWrecipeIngredients = {}

THUNDERARROWrecipeIngredients[#THUNDERARROWrecipeIngredients + 1] = GIngredient(PROJSHAFTTYPE, THUNDERARROWREQLOG);
THUNDERARROWrecipeIngredients[#THUNDERARROWrecipeIngredients + 1]= GIngredient(THUNDERARROWHEADTYPE, THUNDERARROWREQHEAD);
if THUNDERARROWREQFEATHER > 0 then
	THUNDERARROWrecipeIngredients[#THUNDERARROWrecipeIngredients + 1] = GIngredient("feather_robin_winter", THUNDERARROWREQFEATHER);
end

local thunderarrowrecipe = GLOBAL.Recipe("thunderarrow", THUNDERARROWrecipeIngredients , archerytab, ReturnTechLevel(THUNDERARROWTECHLEVEL), nil, nil, nil, THUNDERARROWCRAFTNUM)
thunderarrowrecipe.atlas = "images/inventoryimages/thunderarrow.xml"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local CROSSBOWrecipeIngredients = {}

CROSSBOWrecipeIngredients[#CROSSBOWrecipeIngredients + 1]= GIngredient("boards", CROSSBOWREQBOARDS);
CROSSBOWrecipeIngredients[#CROSSBOWrecipeIngredients + 1] = GIngredient("silk", CROSSBOWREQSILK);
if CROSSBOWREQHAMMER > 0 then
	CROSSBOWrecipeIngredients[#CROSSBOWrecipeIngredients + 1] = GIngredient("hammer", CROSSBOWREQHAMMER);
end

local crossbowrecipe =  GLOBAL.Recipe("crossbow", CROSSBOWrecipeIngredients , archerytab, ReturnTechLevel(CROSSBOWTECHLEVEL), nil, nil, nil, 1)
crossbowrecipe.atlas = "images/inventoryimages/crossbow.xml"

local BOLTrecipeIngredients = {}

BOLTrecipeIngredients[#BOLTrecipeIngredients + 1]= GIngredient(PROJSHAFTTYPE, BOLTREQLOG);
if BOLTREQFEATHER > 0 then
	BOLTrecipeIngredients[#BOLTrecipeIngredients + 1] = GIngredient("feather_crow", BOLTREQFEATHER);
end
BOLTrecipeIngredients[#BOLTrecipeIngredients + 1] = GIngredient(BOLTHEADTYPE, BOLTREQHEAD);

local boltrecipe =  GLOBAL.Recipe("bolt", BOLTrecipeIngredients , archerytab, ReturnTechLevel(BOLTTECHLEVEL), nil, nil, nil, BOLTCRAFTNUM)
boltrecipe.atlas = "images/inventoryimages/bolt.xml"

local POISONBOLTrecipeIngredients = {}

POISONBOLTrecipeIngredients[#POISONBOLTrecipeIngredients + 1]= GIngredient(PROJSHAFTTYPE, POISONBOLTREQLOG);
if POISONBOLTREQFEATHER > 0 then
	POISONBOLTrecipeIngredients[#POISONBOLTrecipeIngredients + 1] = GIngredient("feather_crow", POISONBOLTREQFEATHER);
end
POISONBOLTrecipeIngredients[#POISONBOLTrecipeIngredients + 1] = GIngredient(POISONBOLTHEADTYPE, POISONBOLTREQHEAD);
POISONBOLTrecipeIngredients[#POISONBOLTrecipeIngredients + 1] = GIngredient("red_cap", POISONBOLTREQREDCAP);

local poisonboltrecipe = GLOBAL.Recipe("poisonbolt", POISONBOLTrecipeIngredients , archerytab, ReturnTechLevel(POISONBOLTTECHLEVEL), nil, nil, nil, POISONBOLTCRAFTNUM)
poisonboltrecipe.atlas = "images/inventoryimages/poisonbolt.xml"

local EXPLOSIVEBOLTrecipeIngredients = {}

EXPLOSIVEBOLTrecipeIngredients[#EXPLOSIVEBOLTrecipeIngredients + 1]= GIngredient(PROJSHAFTTYPE, EXPLOSIVEBOLTREQLOG);
if EXPLOSIVEBOLTREQFEATHER > 0 then
	EXPLOSIVEBOLTrecipeIngredients[#EXPLOSIVEBOLTrecipeIngredients + 1] = GIngredient("feather_crow", EXPLOSIVEBOLTREQFEATHER);
end
if EXPLOSIVEBOLTREQMOSQUITO > 0 then
	EXPLOSIVEBOLTrecipeIngredients[#EXPLOSIVEBOLTrecipeIngredients + 1] = GIngredient("mosquitosack", EXPLOSIVEBOLTREQMOSQUITO);
end
EXPLOSIVEBOLTrecipeIngredients[#BOLTrecipeIngredients + 1] = GIngredient(EXPLOSIVEBOLTHEADTYPE, EXPLOSIVEBOLTREQHEAD);

local explosiveboltrecipe =  GLOBAL.Recipe("explosivebolt", EXPLOSIVEBOLTrecipeIngredients , archerytab, ReturnTechLevel(EXPLOSIVEBOLTTECHLEVEL), nil, nil, nil, EXPLOSIVEBOLTCRAFTNUM)
explosiveboltrecipe.atlas = "images/inventoryimages/explosivebolt.xml"

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local MAGICBOWrecipeIngredients = {}

MAGICBOWrecipeIngredients[#MAGICBOWrecipeIngredients + 1] = GIngredient("livinglog", MAGICBOWREQLIVINGLOG);
MAGICBOWrecipeIngredients[#MAGICBOWrecipeIngredients + 1] = GIngredient("purplegem", MAGICBOWREQGEM);
if MAGICBOWREQGLOMMER then
	MAGICBOWrecipeIngredients[#MAGICBOWrecipeIngredients + 1] = GIngredient("glommerflower", 1);
end

local magicbowrecipe =  GLOBAL.Recipe("magicbow", MAGICBOWrecipeIngredients , archerytab, ReturnTechLevel(MAGICBOWTECHLEVEL), nil, nil, nil, 1)
magicbowrecipe.atlas = "images/inventoryimages/magicbow.xml"

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local FIREFLIESBALLrecipeIngredients = {}

FIREFLIESBALLrecipeIngredients[#FIREFLIESBALLrecipeIngredients + 1] = GIngredient("fireflies", 1);
FIREFLIESBALLrecipeIngredients[#FIREFLIESBALLrecipeIngredients + 1] = GIngredient("honey", 3);

local firefliesballrecipe =  GLOBAL.Recipe("z_firefliesball", FIREFLIESBALLrecipeIngredients , archerytab, ReturnTechLevel(MAGICBOWTECHLEVEL), nil, nil, nil, 1)
firefliesballrecipe.atlas = "images/inventoryimages/firefliesball.xml"
firefliesballrecipe.image = "firefliesball.tex"

local BLUEGOOPrecipeIngredients = {}

BLUEGOOPrecipeIngredients[#BLUEGOOPrecipeIngredients + 1] = GIngredient("spidergland", 1);
BLUEGOOPrecipeIngredients[#BLUEGOOPrecipeIngredients + 1] = GIngredient("blue_cap", 1);

local bluegooprecipe =  GLOBAL.Recipe("z_bluegoop", BLUEGOOPrecipeIngredients , archerytab, ReturnTechLevel(MAGICBOWTECHLEVEL), nil, nil, nil, 1)
bluegooprecipe.atlas = "images/inventoryimages/bluegoop.xml"
bluegooprecipe.image = "bluegoop.tex"

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

STRINGS.NAMES.BOW = "Wooden Bow"
STRINGS.RECIPE_DESC.BOW = "Useful if you can aim."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOW = "I used to be a good archer... then I took an arrow in the knee."

STRINGS.NAMES.QUIVER = "Quiver"
STRINGS.RECIPE_DESC.QUIVER = "Store your arrows!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.QUIVER = "With this stuff, I will look like a serious archer."

STRINGS.NAMES.ARROW = "Basic Arrow"
STRINGS.RECIPE_DESC.ARROW = "Do not throw it bare handed."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARROW = "Probably best used with a bow..."

STRINGS.NAMES.GOLDARROW = "Gold Arrow"
STRINGS.RECIPE_DESC.GOLDARROW = "Hunt with style."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDARROW = "I'm sure I could have found a better use this..."

STRINGS.NAMES.MOONSTONEARROW = "Moon Rock Arrow"
STRINGS.RECIPE_DESC.MOONSTONEARROW = "Expensive but efficient."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOONSTONEARROW = "Sharp and shiny!"

STRINGS.NAMES.FIREARROW = "Fire Arrow"
STRINGS.RECIPE_DESC.FIREARROW = "Better be careful with that."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIREARROW = "I should probably avoid using it in the middle of my camp..."

STRINGS.NAMES.ICEARROW = "Freezing Arrow"
STRINGS.RECIPE_DESC.ICEARROW = "Stay cool."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICEARROW = "Should I keep it in the fridge?"

STRINGS.NAMES.THUNDERARROW = "Thunder Arrow"
STRINGS.RECIPE_DESC.THUNDERARROW = "Storm is coming."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.THUNDERARROW = "The red wire on the plus..."

STRINGS.NAMES.DISCHARGEDTHUNDERARROW = "Discharged Thunder Arrow"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISCHARGEDTHUNDERARROW = "It looks like it is not active anymore."

STRINGS.NAMES.CROSSBOW = "Crossbow"
STRINGS.RECIPE_DESC.CROSSBOW = "Heavy and powerful."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CROSSBOW = "This stuff is bigger than me."

STRINGS.NAMES.BOLT = "Basic Bolt"
STRINGS.RECIPE_DESC.BOLT = "Not a toothpick."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOLT = "Small projectile for such a big weapon..."

STRINGS.NAMES.POISONBOLT = "Poison Bolt"
STRINGS.RECIPE_DESC.POISONBOLT = "Cooked with arsenic."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.POISONBOLT = "Did it have to be so ugly?"

STRINGS.NAMES.EXPLOSIVEBOLT = "Explosive Bolt"
STRINGS.RECIPE_DESC.EXPLOSIVEBOLT = "Do not use point blank."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EXPLOSIVEBOLT = "Is it really a good idea?"

STRINGS.NAMES.MAGICBOW = "Magic Bow"
STRINGS.RECIPE_DESC.MAGICBOW = "Just like in fairy tails."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAGICBOW = "I expect a rainbow farting unicorns anytime soon."

STRINGS.NAMES.Z_FIREFLIESBALL = "Fireflies Ball"
STRINGS.RECIPE_DESC.Z_FIREFLIESBALL = "Do not eat"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.Z_FIREFLIESBALL = "It's probably useful for something. Don't ask me what."

STRINGS.NAMES.Z_BLUEGOOP = "Blue Goop"
STRINGS.RECIPE_DESC.Z_BLUEGOOP = "Do not shoot at your foes."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.Z_BLUEGOOP = "It looks gross."

-------------------------------------QUIVER EXTRA EQUIP SLOT-------------------------------------------------------------------------------------------------------------------------------------------------

GLOBAL.EQUIPSLOTS.QUIVER = "quiver"

local RPGHUDisON = false
for _, moddir in ipairs(GLOBAL.KnownModIndex:GetModsToLoad()) do
    if GLOBAL.KnownModIndex:GetModInfo(moddir).name == "RPG HUD" then
		print("RPG HUD is activated")
		RPGHUDisON = true
    end
end

AddGlobalClassPostConstruct("widgets/inventorybar", "Inv", function(self, owner)
--															local inventory = self.owner.components.inventory
--															local num_slot = inventory:GetNumSlots()
--															local extraslot = num_slot - 18 + 1 -- 18 is the regular amount, +1 since I will add one later
															
															if not RPGHUDisON then
																self.bg:SetScale(1.15+0.05,1,1)
																self.bgcover:SetScale(1.15+0.05,1,1)
															end
					
															self:AddEquipSlot(GLOBAL.EQUIPSLOTS.QUIVER, "images/tabimages/quiver_slot.xml", "quiver_slot.tex",99)
														end
)


-------------------------------------NEW ACTIONS--------------------------------------------------------------------------------------

local global_facing

local global_havearrow
local global_targetisok
local global_targetislimbo
local global_havequiver
local global_projtypeok
local global_xbowisarmed
local global_finishedarming
local global_conditions_fulfilled

local global_isbowmagic
local global_magicweaponhasfuel

local allowedprojbow = { "arrow", "goldarrow", "moonstonearrow", "firearrow", "icearrow", "thunderarrow", "dischargedthunderarrow" }
local allowedprojcrossbow = { "bolt", "poisonbolt", "explosivebolt" }

local function DoZRangedAttack(act)
--	print("I entered the  ACTION ZRANGEDATTACK !")
	local equippedbow = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
--	local proj = equippedbow.components.zupalexsrangedweapons.projectile
	local quiver = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
	
	
	local ArrowsInInv = false
	
	global_havearrow = false
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

		if equippedbow:HasTag("bow") and equippedbow:HasTag("magic") then
			if equippedbow.components.fueled ~= nil and not equippedbow.components.fueled:IsEmpty() then
				equippedbow.components.zupalexsrangedweapons:LaunchProjectile(act.doer, target)
				equippedbow.components.zupalexsrangedweapons:OnAttack(act.doer, target)
			end
		elseif quiver ~= nil and quiver.components.container ~= nil then
			global_havequiver = true
			local projinquiver = quiver.components.container:GetItemInSlot(1)
			
	--		ArrowsInInv = quiver.components.container:Has(proj,1)
	--		if ArrowsInInv then
			if projinquiver ~= nil then
	--			print("I can get the quiver and the arrow in the action!")
				global_havearrow = true
				
				for k, v in pairs(equippedbow.components.zupalexsrangedweapons.allowedprojectiles) do
	--				print("Projectile in quiver : ", projinquiver.prefab, "   / found : ", v)
					if projinquiver.prefab == v then
	--					print("found a matching projectile")
						global_projtypeok = true
						break
					end
				end	
				
				if global_projtypeok then
					if not target:HasTag("wall") then
						equippedbow.components.zupalexsrangedweapons:SetProjectile(projinquiver.prefab)
						equippedbow.components.zupalexsrangedweapons:LaunchProjectile(act.doer, target)
						equippedbow.components.zupalexsrangedweapons:OnAttack(act.doer, target)
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
	inst:RemoveTag("use_arrow")
	inst:RemoveTag("use_firearrow")
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
--					print("there is nothing in the quiver and I put new arrows")
--					inventory:RemoveItem(useditem, true)
--					quiver.components.container:GiveItem(useditem, 1)	
					local newactivearrow = GLOBAL.SpawnPrefab(string.lower(useditem.prefab))
					newactivearrow.components.stackable:SetStackSize(useditem.components.stackable.stacksize)
					quiver.components.container:GiveItem(newactivearrow, 1)
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
					
					local newactivearrow = GLOBAL.SpawnPrefab(useditem.prefab)
					newactivearrow.components.stackable:SetStackSize(useditem.components.stackable.stacksize)
					
					local previnquiver = GLOBAL.SpawnPrefab(slotitem.prefab)
					previnquiver.components.stackable:SetStackSize(slotitem.components.stackable.stacksize)							
							
					slotitem:Remove()
					useditem:Remove()
					quiver.components.container:GiveItem(newactivearrow, 1)	
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
ARMCROSSBOW.str = "Arm the Crossbow"
ARMCROSSBOW.id = "ARMCROSSBOW"
ARMCROSSBOW.fn = function(act)
--	print("I entered the  ACTION ARMCROSSBOW!")
	local crossbow = act.invobject

	if crossbow.components.zupalexsrangedweapons ~= nil and crossbow:HasTag("zupalexsrangedweapons") and crossbow:HasTag("crossbow") then
		if not crossbow:HasTag("readytoshoot") then
			crossbow.components.zupalexsrangedweapons:OnArmed(act.doer)
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
	
	local newproj = GLOBAL.SpawnPrefab("thunderarrow")
	
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

local bow_attack = State({
    name = "bow",
    tags = { "attack", "notalking", "abouttoattack", "autopredict", "busy" },

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
		local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local wornhat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local quiver = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
		local projinquiver = nil
		
		inst.components.combat:SetTarget(target)
		inst.components.locomotor:Stop()
	
		global_isbowmagic = false	
		global_magicweaponhasfuel = false
		
		if equip:HasTag("magic") then
			global_isbowmagic = true
			
			if equip:HasTag("hasfuel") then
				global_magicweaponhasfuel = true
			end
		end
		
		global_havequiver = false
		global_havearrow = false	
		global_projtypeok = false

--		local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
		local cooldown = 60 * FRAMES
		
--		print("I am in the state and the quiver is : ", quiver)

		if not global_isbowmagic then
			if quiver ~= nil and quiver.components.container ~= nil then
				global_havequiver = true
				projinquiver = quiver.components.container:GetItemInSlot(1)
			end
			
			if projinquiver ~= nil then
				global_havearrow = true
				for k, v in pairs(allowedprojbow) do
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
		if ((global_havequiver and global_havearrow and global_projtypeok) or (global_isbowmagic and global_magicweaponhasfuel)) and global_targetisok then
			global_conditions_fulfilled = true
		end
		
--		print("Conditions status is : ", global_havequiver, "   ", global_havearrow, "   ", global_targetisok, "   ", global_projtypeok, "   => ", global_conditions_fulfilled)
		
		if not global_conditions_fulfilled then
			inst.AnimState:PlayAnimation("idle", true)
		end
		
--		print("have arrow : ", global_havearrow, "   /   target is ok : ", global_targetisok)			
		
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
										if global_isbowmagic then
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
										inst:ClearBufferedAction()
									end
								end),	
	
		TimeEvent(8 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										if global_isbowmagic then
											inst.SoundEmitter:PlaySound("bow_shoot/magicbow_shoot/shot")
										else
											inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_shoot")
										end
									end
								end),	
	
		TimeEvent(14 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										inst.sg:RemoveStateTag("abouttoattack")
										inst:PerformBufferedAction()
									end
								end),
							
		TimeEvent(15 * FRAMES, function(inst)
									if not global_conditions_fulfilled then
										inst.sg:RemoveStateTag("attack")
										inst.AnimState:PlayAnimation("idle")
									elseif global_isbowmagic then
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
		
		if global_isbowmagic and inst.beamstring ~= nil then
			inst.beamstring:Remove()
		end
		
		
		if inst.components.talker then
			if not global_isbowmagic then
				if not global_havequiver then
					local noquiver_message = "I should first get a quiver!"
					inst.components.talker:Say(noquiver_message)
				elseif not global_havearrow then
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

AddStategraphState("wilson", bow_attack)


local crossbow_attack = State({
    name = "crossbow",
    tags = { "attack", "notalking", "abouttoattack", "autopredict", "busy" },

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
		local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local wornhat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local quiver = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
		local projinquiver = nil
		
		inst.components.combat:SetTarget(target)
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
			global_havearrow = true
			for k, v in pairs(allowedprojcrossbow) do
--				print("Projectile in quiver (state) : ", projinquiver.prefab, "   / found : ", v)
				if projinquiver.prefab == v then
--					print("found a matching projectile in state")
					global_projtypeok = true
					break
				end
			end		
		else
			global_havearrow = false
		end
		
		if equip:HasTag("zupalexsrangedweapons") and equip:HasTag("crossbow") and equip:HasTag("readytoshoot") then
			global_xbowisarmed = true
		else
			global_xbowisarmed = false
		end
		
		if target ~= nil and not target:HasTag("wall") then
			global_targetisok = true
		else
			global_targetisok = false
		end
			
		global_conditions_fulfilled = false	
		if global_havequiver and global_havearrow and global_targetisok and global_projtypeok and global_xbowisarmed then
			global_conditions_fulfilled = true
		end
		
--		print("Conditions status is : ", global_havequiver, "   ", global_havearrow, "   ", global_targetisok, "   ", global_projtypeok, "   => ", global_conditions_fulfilled)
		
		if not global_conditions_fulfilled then
			inst.AnimState:PlayAnimation("idle", true)
		end
			
--		print("have arrow : ", global_havearrow, "   /   target is ok : ", global_targetisok)			
			
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
		TimeEvent(0 * FRAMES, function(inst)
									if not global_conditions_fulfilled then
										inst:ClearBufferedAction()
									end
								end),
	
		TimeEvent(15 * FRAMES, function(inst)
									if not global_conditions_fulfilled then
										inst.sg:RemoveStateTag("abouttoattack")
										inst.AnimState:PlayAnimation("idle")
									end
								end),
	
		TimeEvent(18 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_shoot", nil, nil, true)
									end
								end),	
	
		TimeEvent(23 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										inst.sg:RemoveStateTag("abouttoattack")
										inst:PerformBufferedAction()
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
			elseif not global_havearrow then
				local noammo_message = "My quiver is empty!"
				inst.components.talker:Say(noammo_message)
			elseif not global_projtypeok then
				local badammo_message = "This won't fit it my current weapon..."
				inst.components.talker:Say(badammo_message)
			elseif not global_xbowisarmed then
				local xbownotarmed_message = "I won't shoot far if I don't arm it first..."
				inst.components.talker:Say(xbownotarmed_message)
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

AddStategraphState("wilson", crossbow_attack)

local crossbow_arm = State({
    name = "crossbow_arm",
    tags = { "doing", "busy" },

    onenter = function(inst)
		local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local wornhat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		
		inst.components.locomotor:Stop()
		inst.sg.statemem.action = inst.bufferedaction
		
		global_finishedarming = false
		
		local cooldown = 80 * FRAMES
			
		if equip:HasTag("zupalexsrangedweapons") and equip:HasTag("crossbow") and not equip:HasTag("readytoshoot") then
			global_xbowisarmed = false
		else
			global_xbowisarmed = true
		end
			
		global_conditions_fulfilled = false	
		if not global_xbowisarmed then
			global_conditions_fulfilled = true
		end
		
--		print("Conditions status is : ", global_havequiver, "   ", global_havearrow, "   ", global_targetisok, "   ", global_projtypeok, "   => ", global_conditions_fulfilled)
		
		local playerposx, playerposy, playerposz = inst.Transform:GetWorldPosition()
		inst:ForceFacePoint(playerposx, playerposy-50, playerposz)
		
		if not global_conditions_fulfilled then
			inst.AnimState:PlayAnimation("idle", true)
		else	
			inst.AnimState:PlayAnimation("crossbow_arm")

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
									if global_conditions_fulfilled then
										inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_draw", nil, nil, true)
										inst.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow_armed")
									end
								end),	
	
		TimeEvent(62 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										inst:PerformBufferedAction()
										global_finishedarming = true
									end
								end),
    },

    ontimeout = function(inst)
		inst.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow")
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
		if inst.bufferedaction == inst.sg.statemem.action then
            inst:ClearBufferedAction()
        end
        inst.sg.statemem.action = nil
	
		if not global_finishedarming and not global_xbowisarmed then
			inst.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow")
		end
	
		if inst.components.talker then
			if global_xbowisarmed then
				local alreadyarmed_message = "If I pull even more on this stuff it will break..."
				inst.components.talker:Say(alreadyarmed_message)
			end
		end
		
		inst.AnimState:Show("timeline_0")
		inst.AnimState:Show("timeline_3")
		inst.AnimState:Show("timeline_15")
		inst.AnimState:Show("timeline_16")
    end,		
})

AddStategraphState("wilson", crossbow_arm)


AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BOWATTACK, function(inst, action)
--																		inst.sg.mem.localchainattack = not action.forced or nil
																		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then
																			if inst.components.combat ~= nil and (GLOBAL.GetTime() - inst.components.combat.laststartattacktime) > 1.2 then
																				local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
																				return (weapon:HasTag("bow") and weapon:HasTag("zupalexsrangedweapons") and "bow")
																			end
																		end
																	end
													)
)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.CROSSBOWATTACK, function(inst, action)
--																		inst.sg.mem.localchainattack = not action.forced or nil
																		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then
																			if inst.components.combat ~= nil and (GLOBAL.GetTime() - inst.components.combat.laststartattacktime) > 1.4 then
																				local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
																				return (weapon:HasTag("crossbow") and weapon:HasTag("zupalexsrangedweapons") and "crossbow")
																			end
																		end
																	end
													)
)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.CHANGEARROWTYPE, "doshortaction"))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TRANSFERCHARGETOPROJECTILE, "dolongaction"))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ARMCROSSBOW, function(inst, action)
																			local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
																			return (weapon:HasTag("crossbow") and weapon:HasTag("zupalexsrangedweapons") and "crossbow_arm")
																		end
													)
)     



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