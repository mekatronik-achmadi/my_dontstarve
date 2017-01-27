name = "Wall Gates"
description = "Different kind of walls, you can open and close them, so they act like a doors. You can now close your base area and don't have to use hammer to get in/out and rebuild your walls."
author = "_Q_"
version = "2.0"

forumthread = ""

api_version = 6

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true

icon_atlas = "wall gates.xml"
icon = "wall gates.tex"

configuration_options =
{
    {
        name = "Wall Gates Version",
        options =
        {
		{description = "Normal", data = "normal"},
		{description = "Recolored", data = "recolored"},
        },
        default = "recolored",
    },
	
	{
        name = "Wall Gates Recipe",
        options =
        {
		{description = "Gears", data = "gears"},
		{description = "Electrical Doodad", data = "transistor"},
		{description = "Gold", data = "gold"},
        },
        default = "gold",
    },
	
}
