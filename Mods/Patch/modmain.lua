PrefabFiles = 
{
	"icebox",
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

Recipe("armorwood", {Ingredient("log", 8),Ingredient("rope", 2)}, RECIPETABS.WAR,  TECH.NONE)
Recipe("backpack", {Ingredient("cutgrass", 4), Ingredient("twigs", 4)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("beefalohat", {Ingredient("beefalowool", 4),Ingredient("horn", 1)}, RECIPETABS.DRESS,  TECH.NONE)
Recipe("cane", {Ingredient("goldnugget", 2), Ingredient("walrus_tusk", 1), Ingredient("twigs", 4)}, RECIPETABS.DRESS,  TECH.NONE)
Recipe("coldfire", {Ingredient("cutgrass", 3), Ingredient("nitre", 2)}, RECIPETABS.LIGHT, TECH.NONE, "coldfire_placer")
Recipe("coldfirepit", {Ingredient("nitre", 2), Ingredient("cutstone", 4), Ingredient("transistor", 2)}, RECIPETABS.LIGHT, TECH.NONE, "coldfirepit_placer")
Recipe("eyebrellahat", {Ingredient("deerclops_eyeball", 1), Ingredient("twigs", 15), Ingredient("boneshard", 4)}, RECIPETABS.DRESS,  TECH.NONE)
Recipe("fast_farmplot", {Ingredient("cutgrass", 10),Ingredient("poop", 6),Ingredient("rocks", 4)}, RECIPETABS.FARM,  TECH.NONE, "fast_farmplot_placer")
Recipe("firesuppressor", {Ingredient("gears", 2),Ingredient("ice", 15),Ingredient("transistor", 2)}, RECIPETABS.SCIENCE,  TECH.NONE, "firesuppressor_placer")
Recipe("fishingrod", {Ingredient("twigs", 2),Ingredient("silk", 2)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("heatrock", {Ingredient("rocks", 10),Ingredient("pickaxe", 1),Ingredient("flint", 3)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("icebox", {Ingredient("goldnugget", 2), Ingredient("gears", 1), Ingredient("cutstone", 1)}, RECIPETABS.FARM,  TECH.NONE, "icebox_placer", 1.5)
Recipe("lightning_rod", {Ingredient("goldnugget", 4), Ingredient("cutstone", 1)}, RECIPETABS.SCIENCE,  TECH.NONE, "lightning_rod_placer")
Recipe("meatrack", {Ingredient("twigs", 3),Ingredient("charcoal", 2), Ingredient("rope", 3)}, RECIPETABS.FARM, TECH.NONE, "meatrack_placer")
Recipe("molehat", {Ingredient("mole", 2), Ingredient("transistor", 2), Ingredient("wormlight", 1)}, RECIPETABS.LIGHT,  TECH.NONE)
Recipe("pighouse", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, RECIPETABS.TOWN, TECH.NONE, "pighouse_placer")
Recipe("pitchfork", {Ingredient("twigs", 2),Ingredient("flint", 2)}, RECIPETABS.TOOLS,  TECH.NONE)
Recipe("rainometer", {Ingredient("boards", 2), Ingredient("goldnugget", 2), Ingredient("rope",2)}, RECIPETABS.SCIENCE,  TECH.NONE, "rainometer_placer")
Recipe("razor", {Ingredient("twigs", 2), Ingredient("flint", 2)}, RECIPETABS.TOOLS,  TECH.NONE)
Recipe("shovel", {Ingredient("twigs", 2),Ingredient("flint", 2)}, RECIPETABS.TOOLS,  TECH.NONE)
Recipe("trap_teeth", {Ingredient("log", 1),Ingredient("rope", 1),Ingredient("houndstooth", 3)}, RECIPETABS.WAR,  TECH.NONE)
Recipe("treasurechest", {Ingredient("boards", 3)}, RECIPETABS.TOWN, TECH.NONE, "treasurechest_placer",1)
Recipe("turf_woodfloor", {Ingredient("boards", 1)}, RECIPETABS.TOWN, TECH.NONE)
Recipe("wall_stone_item", {Ingredient("cutstone", 2)}, RECIPETABS.TOWN, TECH.NONE,nil,nil,nil,6)
Recipe("winterometer", {Ingredient("boards", 2), Ingredient("goldnugget", 2)}, RECIPETABS.SCIENCE,  TECH.NONE, "winterometer_placer")

Recipe("rope", {Ingredient("cutgrass", 3)}, RECIPETABS.REFINE,  TECH.NONE)
Recipe("boards", {Ingredient("log", 4)}, RECIPETABS.REFINE,  TECH.NONE)
Recipe("cutstone", {Ingredient("rocks", 3)}, RECIPETABS.REFINE,  TECH.NONE)

Recipe("transistor", {Ingredient("goldnugget", 2), Ingredient("cutstone", 1)}, RECIPETABS.SCIENCE, TECH.NONE)
Recipe("gears", {Ingredient("log", 1), Ingredient("cutstone", 1)}, RECIPETABS.SCIENCE,  TECH.NONE)
Recipe("boneshard", {Ingredient("houndstooth", 3)}, RECIPETABS.REFINE,  TECH.NONE)

Recipe("homesign", {Ingredient("boards", 1)}, RECIPETABS.TOWN, TECH.NONE, "homesign_placer")

------------------------------------------------------

TUNING = GLOBAL.TUNING

TUNING.TRAP_TEETH_USES = 10
TUNING.TRAP_TEETH_DAMAGE = 150

TUNING.PERISH_FRIDGE_MULT = .25

TUNING.FIRE_DETECTOR_RANGE = 20
TUNING.SMOTHERER_EXTINGUISH_HEAT_PERCENT = 1

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
