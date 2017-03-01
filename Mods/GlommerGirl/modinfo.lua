name = "Glommer Girl"
description = "Transform Glommer into a useful dirty girl for better companion\nWarning: Includes dirty words and filthy action"
author = "Achmadi"
forumthread = ""
version = "1.0"

api_version = 6

dont_starve_compatible = true
reign_of_giants_compatible = true

icon_atlas = "girl.xml"
icon = "girl.tex"

configuration_options = {
	{
		name = "GirlDepiction",
		label = "Girl Depiction",
		hover = "Choose preferred Girl Depiction",
		options =
		{	
			{description = "Honoka", data = "honk"},
			{description = "Wendy", data = "wendy"},
			{description = "Mabel", data = "mabel"},	
		},
		default = "mabel",
	},
	
	{
		name = "GirlAutoAct",
		label = "Girl Auto Action",
		hover = "Choose preferred Auto Dirty Action",
		options =
		{	
			{description = "Never", data = "never"},
			{description = "Auto", data = "auto"},
		},
		default = "auto",
	},
}
