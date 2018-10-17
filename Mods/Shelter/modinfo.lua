name = "Shelter"
description = "Another island masterpiece!"
author = "Afro1967"
version = "1.2"

forumthread = "19505-Modders-Your-new-friend-at-Klei!"

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true

api_version = 6
icon_atlas = "siesta_shelter.xml"
icon = "siesta_shelter.tex"

configuration_options =
{
	{
		name = "logs", 
		label = "SW Logs",
		options = 
	{
		{description = "5", data = 5},
		{description = "Default 10", data = 10},
		{description = "15", data = 15},
		{description = "20", data = 20},
		{description = "25", data = 25},
	},
		default = 10,	
	},
	{
		name = "ropes", 
		label = "SW Ropes",
		options = 
	{
		{description = "2", data = 1},
		{description = "Default 4", data = 4},
		{description = "6", data = 6},
		{description = "8", data = 8},
		{description = "10", data = 10},
	},
		default = 4,
	},
	{
		name = "fabrics", 
		label = "SW Cloths",
		options = 
	{
		{description = "1", data = 1},
		{description = "Default 2", data = 2},
		{description = "3", data = 3},
		{description = "4", data = 4},
		{description = "5", data = 5},
	},
		default = 1,
	},
	{
		name = "log", 
		label = "RoG Logs",
		options = 
	{
		{description = "5", data = 5},
		{description = "Default 10", data = 10},
		{description = "15", data = 15},
		{description = "20", data = 20},
		{description = "25", data = 25},
	},
		default = 10,	
	},
	{
		name = "rope", 
		label = "RoG Ropes",
		options = 
	{
		{description = "2", data = 1},
		{description = "Default 4", data = 4},
		{description = "6", data = 6},
		{description = "8", data = 8},
		{description = "10", data = 10},
	},
		default = 4,
	},
	{
		name = "pigskin", 
		label = "RoG Pigskin",
		options = 
	{
		{description = "1", data = 1},
		{description = "Default 2", data = 2},
		{description = "3", data = 3},
		{description = "4", data = 4},
		{description = "5", data = 5},
	},
		default = 1,
	},
}
