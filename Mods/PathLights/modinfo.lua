
name = "Path Lights"
description = "lights"
author = "Afro1967"
version = "1.1"

forumthread = ""

api_version = 6

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true

icon_atlas = "path_light.xml"
icon = "path_light.tex"

configuration_options =
{
	{
		name = "path_lightrecipe",
		label = "Recipe",
        hover = "Here's where you change the recipe",
		options =
	{
		{description = "Easy", data = "easy", hover = "1 Rock 3 Twigs 1 firefly and 1 Rope"},
		{description = "Normal", data = "normal", hover = "1 Moon Rock 3 Twigs 1 firefly and 1 Rope"},
		{description = "Hard", data = "hard", hover = "2 Moon Rocks 3 Twigs 1 firefly and 2 Rope"},
	},
		default = "easy",
	},

	{
		name = "light_color",
		label = "Light Color",
        hover = "Here we change the light color",
		options =
	{
		{description = "Blue", data = "color1"},
		{description = "Red", data = "color2"},
		{description = "Green", data = "color3"},
		{description = "White", data = "color4"},
	},
		default = "color4",
	}
}
