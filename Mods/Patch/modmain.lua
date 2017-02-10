--PrefabFiles = 
--{
        --"bedroll_furry",
--}

--STRINGS = GLOBAL.STRINGS
--RECIPETABS = GLOBAL.RECIPETABS
--Recipe = GLOBAL.Recipe
--Ingredient = GLOBAL.Ingredient
--TECH = GLOBAL.TECH

--GLOBAL.STRINGS.CHARACTERS.GENERIC.ANNOUNCE_SLEEPNEEDSHELTER = "I need a Shelter!"

--Recipe("bedroll_furry", {Ingredient("bedroll_straw", 1), Ingredient("beefalowool", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE)

------------------------------------------------------

Assets =
{
	Asset("ATLAS", "images/newslots.xml"),

}

------------------------------------------------------

TUNING.BIRD_SPAWN_MAX = 4
TUNING.BIRD_SPAWN_DELAY = {min=2, max=8}

TUNING.PERISH_FRIDGE_MULT = .1

TUNING.TRAP_TEETH_USES = 10
TUNING.TRAP_TEETH_DAMAGE = 150

------------------------------------------------------

AddPrefabPostInit("firesuppressor", function(inst)
    table.insert(inst.components.firedetector.NOTAGS, "campfire")
end)

------------------------------------------------------

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
