local SWEasy = (GetModConfigData("SWMode")=="easy")
local SWHard = (GetModConfigData("SWMode")=="hard")
local RoGEasy = (GetModConfigData("RoGMode")=="easy")
local RoGHard = (GetModConfigData("RoGMode")=="hard")

PrefabFiles = 
{
        "wood_shelter",
}

        Assets = 
{
	Asset("ATLAS", "images/inventoryimages/wood_shelter.xml"),
        Asset( "IMAGE", "minimap/siesta_shelter.tex" ),
        Asset( "ATLAS", "minimap/siesta_shelter.xml" ),	
}

        AddMinimapAtlas("minimap/siesta_shelter.xml")

        STRINGS = GLOBAL.STRINGS
        RECIPETABS = GLOBAL.RECIPETABS
        Recipe = GLOBAL.Recipe
        Ingredient = GLOBAL.Ingredient
        TECH = GLOBAL.TECH
        GLOBAL.STRINGS.CHARACTERS.GENERIC.ANNOUNCE_SHELTER = "Thanks for the shelter!"
        GLOBAL.STRINGS.NAMES.WOOD_SHELTER = "Shelter"
        STRINGS.RECIPE_DESC.WOOD_SHELTER = "A little added comfort!"
        GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.WOOD_SHELTER = "I like it!"
        GLOBAL.DRYNESS =  GetModConfigData("Dryness")

        if GLOBAL.IsDLCEnabled(GLOBAL.CAPY_DLC) then
        local wood_shelter = Recipe("wood_shelter",
{ 
        Ingredient("log", GetModConfigData("logs")),
        Ingredient("rope", GetModConfigData("ropes")),
        Ingredient("fabric", GetModConfigData("fabrics")),
},
        RECIPETABS.TOWN, TECH.NONE, GLOBAL.RECIPE_GAME_TYPE.COMMON, "wood_shelter_placer", 1)
        wood_shelter.atlas = "images/inventoryimages/wood_shelter.xml"
        wood_shelter.sortkey = -1
        else
        local wood_shelter = Recipe("wood_shelter",
{ 
        Ingredient("log", GetModConfigData("log")),
        Ingredient("rope", GetModConfigData("rope")),
        Ingredient("pigskin", GetModConfigData("pigskin")),
},
        RECIPETABS.TOWN, TECH.NONE, "wood_shelter_placer", 1)
        wood_shelter.atlas = "images/inventoryimages/wood_shelter.xml"
        wood_shelter.sortkey = -1
end                        