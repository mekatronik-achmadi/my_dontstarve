PrefabFiles =
{
	"bedroll_straw",
	"mermhouse",
	"icebox",
	"walls",
	"hats",
}

Assets =
{
	Asset("ATLAS", "images/newslots.xml"),
	Asset("ATLAS", "images/mermhouse.xml"),
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
Recipe("hammer", {Ingredient("twigs", 2),Ingredient("rocks", 2), Ingredient("rope", 1)}, RECIPETABS.TOOLS, TECH.NONE)

-- Light
Recipe("torch", {Ingredient("cutgrass", 2),Ingredient("twigs", 1)}, RECIPETABS.LIGHT, TECH.NONE)
Recipe("campfire", {Ingredient("cutgrass", 3), Ingredient("log", 1)}, RECIPETABS.LIGHT, TECH.NONE, "campfire_placer")
Recipe("coldfire", {Ingredient("cutgrass", 3), Ingredient("nitre", 1)}, RECIPETABS.LIGHT, TECH.NONE, "coldfire_placer")
Recipe("lantern", {Ingredient("twigs", 3), Ingredient("rope", 2), Ingredient("lightbulb", 2)}, RECIPETABS.LIGHT, TECH.NONE)
Recipe("firepit", {Ingredient("log", 2), Ingredient("cutgrass", 3),Ingredient("rocks", 8)}, RECIPETABS.LIGHT, TECH.NONE, "firepit_placer")
Recipe("coldfirepit", {Ingredient("nitre", 2), Ingredient("cutgrass", 3),Ingredient("rocks", 8)}, RECIPETABS.LIGHT, TECH.NONE, "coldfirepit_placer")

-- Survival
Recipe("trap", {Ingredient("twigs", 2),Ingredient("cutgrass", 4)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("birdtrap", {Ingredient("twigs", 6),Ingredient("silk", 4)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("horn", {Ingredient("log", 1),Ingredient("houndstooth", 4)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("fishingrod", {Ingredient("twigs", 2),Ingredient("silk", 1)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("backpack", {Ingredient("cutgrass", 4), Ingredient("twigs", 4)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("bedroll_straw", {Ingredient("cutgrass", 3), Ingredient("rope", 1)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("bugnet", {Ingredient("twigs", 4), Ingredient("silk", 2), Ingredient("rope", 1)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("heatrock", {Ingredient("rocks", 5),Ingredient("pickaxe", 1),Ingredient("flint", 2)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("umbrella", {Ingredient("twigs", 4) ,Ingredient("pigskin", 1), Ingredient("silk",2 )}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("tent", {Ingredient("silk", 4),Ingredient("twigs", 4),Ingredient("rope", 2)}, RECIPETABS.SURVIVAL, TECH.NONE, "tent_placer")
Recipe("siestahut", {Ingredient("pigskin", 1),Ingredient("log", 4),Ingredient("rope", 2)}, RECIPETABS.SURVIVAL, TECH.NONE, "siestahut_placer")

-- Food
Recipe("beebox", {Ingredient("boards", 2),Ingredient("bee", 4)}, RECIPETABS.FARM, TECH.NONE, "beebox_placer")
Recipe("meatrack", {Ingredient("twigs", 3),Ingredient("charcoal", 2), Ingredient("rope", 3)}, RECIPETABS.FARM, TECH.NONE, "meatrack_placer")
Recipe("cookpot", {Ingredient("cutstone", 2),Ingredient("charcoal", 4), Ingredient("twigs", 6)}, RECIPETABS.FARM,  TECH.NONE, "cookpot_placer")
Recipe("icebox", {Ingredient("goldnugget", 1), Ingredient("gears", 1), Ingredient("cutstone", 1)}, RECIPETABS.FARM,  TECH.NONE, "icebox_placer", 1.5)
Recipe("fast_farmplot", {Ingredient("boards", 1),Ingredient("poop", 2),Ingredient("rocks", 2)}, RECIPETABS.FARM,  TECH.NONE, "fast_farmplot_placer")

-- Science
Recipe("gears", {Ingredient("log", 1), Ingredient("rocks", 2)}, RECIPETABS.SCIENCE,  TECH.NONE)
Recipe("transistor", {Ingredient("goldnugget", 1), Ingredient("rocks", 2)}, RECIPETABS.SCIENCE, TECH.NONE)
Recipe("gunpowder", {Ingredient("rottenegg", 1), Ingredient("charcoal", 1), Ingredient("nitre", 1)}, RECIPETABS.SCIENCE,  TECH.NONE)
Recipe("winterometer", {Ingredient("boards", 2), Ingredient("goldnugget", 2)}, RECIPETABS.SCIENCE,  TECH.NONE, "winterometer_placer")
Recipe("lightning_rod", {Ingredient("goldnugget", 2), Ingredient("cutstone", 1)}, RECIPETABS.SCIENCE,  TECH.NONE, "lightning_rod_placer")
Recipe("rainometer", {Ingredient("boards", 2), Ingredient("goldnugget", 2), Ingredient("rope",2)}, RECIPETABS.SCIENCE,  TECH.NONE, "rainometer_placer")

-- Fight
Recipe("armorwood", {Ingredient("log", 4),Ingredient("rope", 1)}, RECIPETABS.WAR,  TECH.NONE)
Recipe("boomerang", {Ingredient("boards", 1),Ingredient("rope", 1)}, RECIPETABS.WAR,  TECH.NONE)
Recipe("spear", {Ingredient("twigs", 2),Ingredient("rope", 1),Ingredient("flint", 1) }, RECIPETABS.WAR,  TECH.NONE)
Recipe("footballhat", {Ingredient("pigskin", 1), Ingredient("rope", 1), Ingredient("log", 1)}, RECIPETABS.WAR,  TECH.NONE)
Recipe("trap_teeth", {Ingredient("log", 1),Ingredient("rope", 1),Ingredient("houndstooth", 1)}, RECIPETABS.WAR,  TECH.NONE)

-- Structure
Recipe("turf_woodfloor", {Ingredient("boards", 1)}, RECIPETABS.TOWN, TECH.NONE)
Recipe("treasurechest", {Ingredient("boards", 3)}, RECIPETABS.TOWN, TECH.NONE, "treasurechest_placer",1)
Recipe("wall_wood_item", {Ingredient("log", 3), Ingredient("rope", 1)}, RECIPETABS.TOWN, TECH.NONE,nil,nil,nil,6)
Recipe("wall_hay_item", {Ingredient("cutgrass", 3), Ingredient("rope", 1) }, RECIPETABS.TOWN, TECH.NONE,nil,nil,nil,6)
Recipe("spidereggsack", {Ingredient("silk", 4), Ingredient("monstermeat", 2),Ingredient("spidergland", 2)}, RECIPETABS.TOWN, TECH.NONE)
Recipe("pighouse", {Ingredient("boards", 4), Ingredient("cutstone", 2), Ingredient("pigskin", 2)}, RECIPETABS.TOWN, TECH.NONE, "pighouse_placer")
Recipe("birdcage", {Ingredient("cutgrass", 6), Ingredient("goldnugget", 2), Ingredient("boards", 2)}, RECIPETABS.TOWN, TECH.NONE, "birdcage_placer")
Recipe("rabbithouse", {Ingredient("boards", 4), Ingredient("cutstone", 2), Ingredient("manrabbit_tail", 2)}, RECIPETABS.TOWN, TECH.NONE, "rabbithouse_placer")

-- Refine
Recipe("boards", {Ingredient("log", 3)}, RECIPETABS.REFINE,  TECH.NONE)
Recipe("rope", {Ingredient("cutgrass", 3)}, RECIPETABS.REFINE,  TECH.NONE)
Recipe("cutstone", {Ingredient("rocks", 3)}, RECIPETABS.REFINE,  TECH.NONE)

-- Dress
Recipe("strawhat", {Ingredient("cutgrass", 8)}, RECIPETABS.DRESS,  TECH.NONE)
Recipe("beehat", {Ingredient("silk", 4), Ingredient("rope", 1)}, RECIPETABS.DRESS,  TECH.NONE)

------------------------------------------------------

STRINGS = GLOBAL.STRINGS

STRINGS.RECIPE_DESC.HORN = "Sound the call"
STRINGS.RECIPE_DESC.SPIDEREGGSACK = "Plant a fight club"

------------------------------------------------------

STRINGS.RECIPE_DESC.MERMHOUSE = "Create a war"
local mermhouse = Recipe("mermhouse", {Ingredient("boards", 4), Ingredient("fish", 2), Ingredient("froglegs",2)}, RECIPETABS.TOWN, TECH.NONE, "pighouse_placer")
mermhouse.atlas = "images/mermhouse.xml"

------------------------------------------------------

TUNING = GLOBAL.TUNING

TUNING.TRAP_TEETH_USES = 20
TUNING.FISHINGROD_USES = 10

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
