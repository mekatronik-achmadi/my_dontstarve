Assets=
{
    Asset("ATLAS", "images/inventoryimages/inf_lantern.xml"),
}

PrefabFiles = 
{
	"inf_lantern",
}

STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH

GLOBAL.STRINGS.NAMES.INF_LANTERN = "Inf Lantern"
STRINGS.RECIPE_DESC.INF_LANTERN = "One Light Soulution"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.PATH_LIGHT = "A useful lantern"

local inf_lantern = Recipe("inf_lantern", {Ingredient("twigs", 3),Ingredient("rope", 1),Ingredient("goldnugget", 1)}, RECIPETABS.LIGHT,  TECH.NONE)
inf_lantern.atlas = "images/inventoryimages/path_light.xml"
