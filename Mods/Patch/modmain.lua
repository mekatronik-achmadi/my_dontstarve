PrefabFiles = 
{
	"icebox",
	"bedroll_straw",
}

Assets =
{
	Asset("ATLAS", "images/newslots.xml"),

}

------------------------------------------------------

RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH

-- Tools
Recipe("razor", {Ingredient("twigs", 2), Ingredient("flint", 2)}, RECIPETABS.TOOLS,  TECH.NONE)
Recipe("shovel", {Ingredient("twigs", 2),Ingredient("flint", 2)}, RECIPETABS.TOOLS,  TECH.NONE)
Recipe("pitchfork", {Ingredient("twigs", 2),Ingredient("flint", 2)}, RECIPETABS.TOOLS,  TECH.NONE)

-- Light
Recipe("campfire", {Ingredient("cutgrass", 3), Ingredient("log", 1)}, RECIPETABS.LIGHT, TECH.NONE, "campfire_placer")
Recipe("coldfire", {Ingredient("cutgrass", 3), Ingredient("nitre", 1)}, RECIPETABS.LIGHT, TECH.NONE, "coldfire_placer")
Recipe("molehat", {Ingredient("mole", 1), Ingredient("transistor", 1), Ingredient("wormlight", 1)}, RECIPETABS.LIGHT,  TECH.NONE)
Recipe("firepit", {Ingredient("log", 2), Ingredient("cutgrass", 3),Ingredient("rocks", 8)}, RECIPETABS.LIGHT, TECH.NONE, "firepit_placer")
Recipe("coldfirepit", {Ingredient("nitre", 2), Ingredient("cutgrass", 3),Ingredient("rocks", 8)}, RECIPETABS.LIGHT, TECH.NONE, "coldfirepit_placer")

-- Survival
Recipe("horn", {Ingredient("log", 1),Ingredient("boneshard", 2)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("fishingrod", {Ingredient("twigs", 2),Ingredient("silk", 1)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("backpack", {Ingredient("cutgrass", 4), Ingredient("twigs", 4)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("bedroll_straw", {Ingredient("cutgrass", 3), Ingredient("rope", 1)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("heatrock", {Ingredient("rocks", 5),Ingredient("pickaxe", 1),Ingredient("flint", 2)}, RECIPETABS.SURVIVAL, TECH.NONE)

-- Food
Recipe("meatrack", {Ingredient("twigs", 3),Ingredient("charcoal", 2), Ingredient("rope", 3)}, RECIPETABS.FARM, TECH.NONE, "meatrack_placer")
Recipe("cookpot", {Ingredient("cutstone", 2),Ingredient("charcoal", 4), Ingredient("twigs", 6)}, RECIPETABS.FARM,  TECH.NONE, "cookpot_placer")
Recipe("icebox", {Ingredient("goldnugget", 1), Ingredient("gears", 1), Ingredient("cutstone", 1)}, RECIPETABS.FARM,  TECH.NONE, "icebox_placer", 1.5)
Recipe("fast_farmplot", {Ingredient("cutgrass", 4),Ingredient("poop", 2),Ingredient("rocks", 2)}, RECIPETABS.FARM,  TECH.NONE, "fast_farmplot_placer")

-- Science
Recipe("gears", {Ingredient("log", 1), Ingredient("cutstone", 1)}, RECIPETABS.SCIENCE,  TECH.NONE)
Recipe("transistor", {Ingredient("goldnugget", 1), Ingredient("cutstone", 1)}, RECIPETABS.SCIENCE, TECH.NONE)
Recipe("winterometer", {Ingredient("boards", 2), Ingredient("goldnugget", 2)}, RECIPETABS.SCIENCE,  TECH.NONE, "winterometer_placer")
Recipe("lightning_rod", {Ingredient("goldnugget", 2), Ingredient("cutstone", 1)}, RECIPETABS.SCIENCE,  TECH.NONE, "lightning_rod_placer")
Recipe("rainometer", {Ingredient("boards", 2), Ingredient("goldnugget", 2), Ingredient("rope",2)}, RECIPETABS.SCIENCE,  TECH.NONE, "rainometer_placer")
Recipe("firesuppressor", {Ingredient("gears", 1),Ingredient("ice", 8),Ingredient("transistor", 1)}, RECIPETABS.SCIENCE,  TECH.NONE, "firesuppressor_placer")

-- Magic
Recipe("resurrectionstatue", {Ingredient("boards", 4),Ingredient("meat", 4),Ingredient("rope", 4)}, RECIPETABS.MAGIC,  TECH.NONE, "resurrectionstatue_placer")

-- Fight
Recipe("armorwood", {Ingredient("log", 4),Ingredient("rope", 1)}, RECIPETABS.WAR,  TECH.NONE)
Recipe("trap_teeth", {Ingredient("log", 1),Ingredient("rope", 1),Ingredient("houndstooth", 1)}, RECIPETABS.WAR,  TECH.NONE)

-- Structure
Recipe("turf_woodfloor", {Ingredient("boards", 1)}, RECIPETABS.TOWN, TECH.NONE)
Recipe("wall_stone_item", {Ingredient("cutstone", 2)}, RECIPETABS.TOWN, TECH.NONE,nil,nil,nil,10)
Recipe("turf_savanna", {Ingredient("boards", 1), Ingredient("cutgrass", 2)}, RECIPETABS.TOWN, TECH.NONE)
Recipe("treasurechest", {Ingredient("boards", 3)}, RECIPETABS.TOWN, TECH.NONE, "treasurechest_placer",1)
Recipe("pighouse", {Ingredient("boards", 4), Ingredient("cutstone", 2), Ingredient("pigskin", 2)}, RECIPETABS.TOWN, TECH.NONE, "pighouse_placer")

-- Refine
Recipe("boards", {Ingredient("log", 2)}, RECIPETABS.REFINE,  TECH.NONE)
Recipe("rope", {Ingredient("cutgrass", 2)}, RECIPETABS.REFINE,  TECH.NONE)
Recipe("cutstone", {Ingredient("rocks", 2)}, RECIPETABS.REFINE,  TECH.NONE)
Recipe("boneshard", {Ingredient("houndstooth", 2)}, RECIPETABS.REFINE,  TECH.NONE)
Recipe("walrus_tusk", {Ingredient("boneshard", 2)}, RECIPETABS.REFINE,  TECH.NONE)

-- Dress
Recipe("beefalohat", {Ingredient("beefalowool", 4),Ingredient("horn", 1)}, RECIPETABS.DRESS,  TECH.NONE)
Recipe("cane", {Ingredient("goldnugget", 1), Ingredient("walrus_tusk", 1), Ingredient("twigs", 4)}, RECIPETABS.DRESS,  TECH.NONE)
Recipe("eyebrellahat", {Ingredient("deerclops_eyeball", 1), Ingredient("twigs", 4), Ingredient("boneshard", 2)}, RECIPETABS.DRESS,  TECH.NONE)

------------------------------------------------------

STRINGS = GLOBAL.STRINGS

STRINGS.RECIPE_DESC.HORN = "Sound the call"
STRINGS.RECIPE_DESC.BONESHARD = "Bone from tooth"
STRINGS.RECIPE_DESC.WALRUS_TUSK = "A bigger tooth"

------------------------------------------------------

TUNING = GLOBAL.TUNING

TUNING.TRAP_TEETH_USES = 20
TUNING.TRAP_TEETH_DAMAGE = 150

TUNING.PERISH_FRIDGE_MULT = .25

TUNING.FIRE_DETECTOR_RANGE = 20
TUNING.SMOTHERER_EXTINGUISH_HEAT_PERCENT = 1

TUNING.RESURRECT_HEALTH = 75
TUNING.EFFIGY_HEALTH_PENALTY = 0

TUNING.WOOD_SHELTER_WATERPROOFNESS = 0
TUNING.WOOD_SHELTER_INSULATION = 0
TUNING.WOOD_SHELTER_SLEEPING = 0

TUNING.WOODFLOOR_SPEEDMULTIPLIER = 1.2

------------------------------------------------------

AddPrefabPostInit("firesuppressor", function(inst)
    inst.components.fueled.rate = .25
    table.insert(inst.components.firedetector.NOTAGS, "campfire")
end)

-------------------------------------------------------

function playerpostinit(inst)
	inst:AddComponent("pickyfeet")
end

AddSimPostInit(playerpostinit)

------------------------------------------------------

function backpackpostinit(inst)
	inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BACK
end

function inventorypostinit(component,inst)
	inst.components.inventory.numequipslots = 5
end

AddComponentPostInit("inventory", inventorypostinit)

AddPrefabPostInit("backpack", backpackpostinit)
AddPrefabPostInit("piggyback", backpackpostinit)
AddPrefabPostInit("krampus_sack", backpackpostinit)

AddSimPostInit(gamepostinit)

table.insert(GLOBAL.EQUIPSLOTS, "BACK")
GLOBAL.EQUIPSLOTS.BACK = "back"

AddClassPostConstruct("screens/playerhud", function(self) 
    local oldfn = self.SetMainCharacter
    function self:SetMainCharacter(maincharacter)
        
        oldfn(self, maincharacter)
        
        self.controls.inv:AddEquipSlot(GLOBAL.EQUIPSLOTS.BACK, "images/newslots.xml", "back.tex") 
        self.controls.inv.bg:SetScale(1.2,1,1)

        local bp = maincharacter.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BACK)
        if bp and bp.components.container then
            bp.components.container:Close()
            bp.components.container:Open(maincharacter)
        end
    end
end)
