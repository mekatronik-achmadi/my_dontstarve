
Assets=
{
    Asset("ATLAS", "images/inventoryimages/path_light.xml"),
}

PrefabFiles =
{
	"path_light",
}

    STRINGS = GLOBAL.STRINGS
    RECIPETABS = GLOBAL.RECIPETABS
    Recipe = GLOBAL.Recipe
    Ingredient = GLOBAL.Ingredient
    TECH = GLOBAL.TECH

    GLOBAL.STRINGS.NAMES.PATH_LIGHT = "Path Light"
    STRINGS.RECIPE_DESC.PATH_LIGHT = "It lights your path."
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.PATH_LIGHT = "It's a light"

---------------------------------------

	local path_lightrecipe = GLOBAL.Recipe("path_light",
{
	Ingredient("transistor", 1),
	Ingredient("twigs", 3),
	Ingredient("rope", 1),
},
	RECIPETABS.TOWN, TECH.NONE, "path_light_placer" )
    path_lightrecipe.atlas = "images/inventoryimages/path_light.xml"
