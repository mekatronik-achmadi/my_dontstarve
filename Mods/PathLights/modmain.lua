   
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

    local easy = (GetModConfigData("path_lightrecipe")=="easy")
    local normal = (GetModConfigData("path_lightrecipe")=="normal")

    if easy then
	local path_lightrecipe = GLOBAL.Recipe("path_light",
{ 
	Ingredient("rocks", 1),
	Ingredient("twigs", 3),
	Ingredient("rope", 1),
    Ingredient("fireflies", 1),
},
	RECIPETABS.LIGHT, TECH.NONE, "path_light_placer" )                     
    path_lightrecipe.atlas = "images/inventoryimages/path_light.xml"

    else if normal then
    local path_lightrecipe = GLOBAL.Recipe("path_light",
{ 
    Ingredient("rocks", 2),
    Ingredient("twigs", 3),
    Ingredient("rope", 1),
    Ingredient("fireflies", 1),
},
    RECIPETABS.LIGHT, TECH.SCIENCE_ONE, "path_light_placer" )                     
    path_lightrecipe.atlas = "images/inventoryimages/path_light.xml"

    else 
    local path_lightrecipe = GLOBAL.Recipe("path_light",
{ 
    Ingredient("rocks", 2),
    Ingredient("twigs", 3),
    Ingredient("rope", 2),
    Ingredient("fireflies", 1),
},
    RECIPETABS.LIGHT, TECH.SCIENCE_TWO, "path_light_placer" )                     
    path_lightrecipe.atlas = "images/inventoryimages/path_light.xml"
    end
end

--------------------------------

    GLOBAL.color1 = (GetModConfigData("light_color")=="color1")
    GLOBAL.color2 = (GetModConfigData("light_color")=="color2")
    GLOBAL.color3 = (GetModConfigData("light_color")=="color3")
    GLOBAL.color4 = (GetModConfigData("light_color")=="color4")    