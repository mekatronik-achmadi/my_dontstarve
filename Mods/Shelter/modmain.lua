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

        GLOBAL.STRINGS.NAMES.WOOD_SHELTER = "Shelter"
        STRINGS.RECIPE_DESC.WOOD_SHELTER = "A little added comfort!"
        GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.WOOD_SHELTER = "I like it!"

local wood_shelter = GLOBAL.Recipe("wood_shelter",
{ 
        Ingredient("log", 8),
        Ingredient("rope", 4),
},
        RECIPETABS.TOWN, TECH.NONE,"wood_shelter_placer" )
        wood_shelter.atlas = "images/inventoryimages/wood_shelter.xml"
