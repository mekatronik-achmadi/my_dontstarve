PrefabFiles = 
{
	"statueglommer",
	"bedroll_furry",
}

------------------------------------------------------

STRINGS = GLOBAL.STRINGS

GLOBAL.STRINGS.CHARACTERS.GENERIC.ANNOUNCE_SLEEPNEEDSHELTER = "I need a Shelter!"

------------------------------------------------------

RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH

Recipe("bedroll_furry", {Ingredient("bedroll_straw", 1), Ingredient("beefalowool", 4)}, RECIPETABS.SURVIVAL, TECH.NONE)

