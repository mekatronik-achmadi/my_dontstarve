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

TUNING.BIRD_SPAWN_MAX_FEATHERHAT = 15
TUNING.BIRD_SPAWN_DELAY_FEATHERHAT = {min=0, max=5}

TUNING.TRAP_TEETH_USES = 10
TUNING.TRAP_TEETH_DAMAGE = 150

AddPrefabPostInit("firesuppressor", function(inst)
    table.insert(inst.components.firedetector.NOTAGS, "campfire")
end)
