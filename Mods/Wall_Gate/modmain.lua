local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local TECH = GLOBAL.TECH
local Action = GLOBAL.Action
local ActionHandler = GLOBAL.ActionHandler

STRINGS.NAMES.MECH_HAY_ITEM = "Hay Wall Gate"
STRINGS.RECIPE_DESC.MECH_HAY_ITEM = "Hay Wall Gate Segment."

STRINGS.NAMES.MECH_WOOD_ITEM = "Wood Wall Gate"
STRINGS.RECIPE_DESC.MECH_WOOD_ITEM = "Wooden Wall Gate Segment."

STRINGS.NAMES.MECH_STONE_ITEM = "Stone Wall Gate"
STRINGS.RECIPE_DESC.MECH_STONE_ITEM = "Stone Wall Gate Segment."

STRINGS.NAMES.MECH_RUINS_ITEM = "Thulecite Wall Gate"
STRINGS.RECIPE_DESC.MECH_RUINS_ITEM = "Thulecite Wall Gate Segment."

STRINGS.NAMES.MECH_HAY = "Hay Wall Gate"
STRINGS.NAMES.MECH_WOOD = "Wooden Wall Gate"
STRINGS.NAMES.MECH_STONE = "Stone Wall Gate"
STRINGS.NAMES.MECH_RUINS = "Thulecite Wall Gate"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MECH_HAY_ITEM = "The mechanics are carefully woven in."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MECH_HAY = "This still seems rather unsafe."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MECH_WOOD_ITEM = "Pickets and parts!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MECH_WOOD = "Sliding Pickets!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MECH_STONE_ITEM = "This should let me get in and out quickly."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MECH_STONE = "A not so secret passage."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MECH_RUINS_ITEM = "It's a lot more compact than it looks."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MECH_RUINS = "I wonder what other problems I could solve with this stuff."

STRINGS.CHARACTERS.WILLOW.DESCRIBE.MECH_HAY_ITEM = "This is a waste of flammable stuff."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.MECH_HAY = "This gate would burn so easy!"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.MECH_WOOD_ITEM = "Safe and delightfully flammable."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.MECH_WOOD = "It'd look better on fire."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.MECH_STONE_ITEM = "I can't burn this. Now what?"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.MECH_STONE = "It's not flammable, but at least it's useful."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.MECH_RUINS_ITEM = "Now, where to put this thing?"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.MECH_RUINS = "It looks like it's made of gold. Gold burns, right?"

STRINGS.CHARACTERS.WENDY.DESCRIBE.MECH_HAY = "Death itself can break this door down whenever it wishes to claim me."
STRINGS.CHARACTERS.WENDY.DESCRIBE.MECH_HAY_ITEM = "I shall protect myself with nothing."
STRINGS.CHARACTERS.WENDY.DESCRIBE.MECH_WOOD = "This gate protects from the outside in vain."
STRINGS.CHARACTERS.WENDY.DESCRIBE.MECH_WOOD_ITEM = "Now the trees know true horror."
STRINGS.CHARACTERS.WENDY.DESCRIBE.MECH_STONE = "A doorway to my worst fears."
STRINGS.CHARACTERS.WENDY.DESCRIBE.MECH_STONE_ITEM = "The basic parts of a wicked doorway."
STRINGS.CHARACTERS.WENDY.DESCRIBE.MECH_RUINS_ITEM = "All that glistens, will only delay the inevitable."
STRINGS.CHARACTERS.WENDY.DESCRIBE.MECH_RUINS = "A wall built of the bones of past civilizations."

STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MECH_HAY_ITEM = "Is door made of plant."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MECH_HAY = "Is weak grass door."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MECH_WOOD_ITEM = "Is alive wood."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MECH_WOOD = "Is tree door."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MECH_STONE_ITEM = "Wolfgang make rocks into house door!"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MECH_STONE = "Door is strong, like Wolfgang."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MECH_RUINS_ITEM = "Is hard, like Wolfgang!"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MECH_RUINS = "Is strong and pretty."

STRINGS.CHARACTERS.WX78.DESCRIBE.MECH_HAY_ITEM = "A SIMPLE BASE ENTRY MECHANISM."
STRINGS.CHARACTERS.WX78.DESCRIBE.MECH_HAY = "ENTRYWAY SECURITY: LOW"
STRINGS.CHARACTERS.WX78.DESCRIBE.MECH_WOOD_ITEM = "REINFORCED ENTRYWAY MECHANISM."
STRINGS.CHARACTERS.WX78.DESCRIBE.MECH_WOOD = "ENTRYWAY SECURITY: AVERAGE"
STRINGS.CHARACTERS.WX78.DESCRIBE.MECH_STONE_ITEM = "A VERY ACCEPTABLE ENTRY MECHANISM. I CAN USE IT WELL."
STRINGS.CHARACTERS.WX78.DESCRIBE.MECH_STONE = "ENTRYWAY SECURITY: ABOVE AVERAGE."
STRINGS.CHARACTERS.WX78.DESCRIBE.MECH_RUINS_ITEM = "A REINFORCED ENTRY MECHANISM."
STRINGS.CHARACTERS.WX78.DESCRIBE.MECH_RUINS = "ENTRYWAY SECURITY: BEYOND ACCEPTABLE LEVELS."

STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MECH_HAY_ITEM = "This will have to do, I suppose."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MECH_HAY = "It's a wonder the door's mechanisms don't destroy themselves."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MECH_WOOD_ITEM = "Now this is a perfectly sound idea."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MECH_WOOD = "It's not an actual door, but it's rather close."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MECH_STONE_ITEM = "I can hold as many doors as walls, apparently."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MECH_STONE = "It helps keep visitors out, and me in."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MECH_RUINS_ITEM = "Good thing i'm not an indecisive woman."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MECH_RUINS = "These people seem to be very knowledgable in the use of hardy construction materials."

STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MECH_HAY_ITEM = "Now where to put it?"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MECH_HAY = "Not the best choice of gate materials."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MECH_WOOD_ITEM = "Good gates make good neighbors, i've heard."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MECH_WOOD = "This should help keep out the riff-raff."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MECH_STONE_ITEM = "This should finish the job."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MECH_STONE = "And stay out!"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MECH_RUINS_ITEM = "I honestly don't know who made this odd material."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MECH_RUINS = "A bit garish, but it could work."

STRINGS.CHARACTERS.WOODIE.DESCRIBE.MECH_HAY_ITEM = "It still makes my eyes water."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MECH_HAY = "I could sneeze this down like nothing, eh?"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MECH_WOOD_ITEM = "Like making a cabin."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MECH_WOOD = "Can't help but feel like I wasted this."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MECH_STONE_ITEM = "I like my doors with handles, eh?"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MECH_STONE = "Colder than Lucy's basement. Stronger, too."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MECH_RUINS_ITEM = "I guess I ought to do something with this."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MECH_RUINS = "Too rich for my tastes, eh?"
if GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS) then 
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.MECH_HAY_ITEM = "This would never keep us out!"
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.MECH_HAY = "I hope nobody burns this fragile thing down later."
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.MECH_WOOD_ITEM = "I could make a nice fort out of this."
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.MECH_WOOD = "Keeps me in, and everyone else out."
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.MECH_STONE_ITEM = "It's done. But placement is key!"
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.MECH_STONE = "Ha! Let's see them get through now!"
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.MECH_RUINS_ITEM = "It's not that heavy, actually."
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.MECH_RUINS = "It's very shiny. My queen would have loved it."

	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MECH_HAY_ITEM = "A flimsy defense of the poor villager!"
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MECH_HAY = "A door for the meager woodland creature!"
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MECH_WOOD_ITEM = "The blocks of a sturdy fortress!"
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MECH_WOOD = "I say unto the door, Open Sesame!"
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MECH_STONE_ITEM = "The fortress is mine to shape!"
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MECH_STONE = "A mighty gate, indeed!"
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MECH_RUINS_ITEM = "Behold, the cornerstone of ages past!"
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MECH_RUINS = "The mighty wall of the ancients!"
end

local CLOSE = Action(3)
CLOSE.str = "Close"
CLOSE.id = "CLOSE"
CLOSE.fn = function(act)
	local tar = act.target
    if tar and tar.components.wallgates and tar.components.wallgates:IsOpen() then
		tar.components.wallgates:CloseWall(tar)
		return true
    end
end

AddAction(CLOSE)

AddStategraphActionHandler("wilson", ActionHandler(CLOSE, "give"))

local OPEN = Action(3)
OPEN.str = "Open"
OPEN.id = "OPEN"
OPEN.fn = function(act)
	local tar = act.target
    if tar and tar.components.wallgates and not tar.components.wallgates:IsOpen() then
        tar.components.wallgates:OpenWall(tar)
        return true
    end
end

AddAction(OPEN)

AddStategraphActionHandler("wilson", ActionHandler(OPEN, "give"))

function LighterPostInit(self)
	self.CollectEquippedActions = function(self, doer, target, actions, right)
		if right and target.components.burnable then
			if not target.components.burnable:IsBurning() and target.components.burnable.canlight and not target:HasTag("wallgate") then
				local is_empty = target.components.fueled and target.components.fueled:GetPercent() <= 0
				if not is_empty then
					table.insert(actions, GLOBAL.ACTIONS.LIGHT)
				end
			end
			if not target.components.burnable:IsBurning() and target.components.burnable.canlight and target:HasTag("wallgate") and GLOBAL.TheInput:IsKeyDown(GLOBAL.KEY_CTRL) then
				local is_empty = target.components.fueled and target.components.fueled:GetPercent() <= 0
				if not is_empty then
					table.insert(actions, GLOBAL.ACTIONS.LIGHT)
				end
			end
		end
	end
end

AddComponentPostInit("lighter", LighterPostInit)

if GetModConfigData("Wall Gates Version") == "recolored" then
	PrefabFiles = 
	{
		"mech.lua",
	}

	Assets = 
	{
		Asset("ATLAS", "images/inventoryimages/mech_hay_item.xml"),
		Asset("ATLAS", "images/inventoryimages/mech_wood_item.xml"),
		Asset("ATLAS", "images/inventoryimages/mech_stone_item.xml"),
		Asset("ATLAS", "images/inventoryimages/mech_ruins_item.xml"),
	}
	
	if GetModConfigData("Wall Gates Recipe") == "gears" then
		local mech_hay_item = GLOBAL.Recipe("mech_hay_item", {Ingredient("wall_hay_item", 1), Ingredient("goldnugget", 2),Ingredient("gears", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
		mech_hay_item.atlas = "images/inventoryimages/mech_hay_item.xml"

		local mech_wood_item = GLOBAL.Recipe("mech_wood_item", {Ingredient("wall_wood_item", 1), Ingredient("goldnugget", 2),Ingredient("gears", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
		mech_wood_item.atlas = "images/inventoryimages/mech_wood_item.xml"

		local mech_stone_item = GLOBAL.Recipe("mech_stone_item", {Ingredient("wall_stone_item", 1), Ingredient("goldnugget", 2),Ingredient("gears", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
		mech_stone_item.atlas = "images/inventoryimages/mech_stone_item.xml"
	
		local mech_ruins_item = GLOBAL.Recipe("mech_ruins_item", {Ingredient("wall_ruins_item", 1), Ingredient("goldnugget", 2),Ingredient("gears", 1)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, nil, nil, true, 1)
		mech_ruins_item.atlas = "images/inventoryimages/mech_ruins_item.xml"
	elseif GetModConfigData("Wall Gates Recipe") == "transistor" then
		if GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS) then 
			local mech_hay_item = GLOBAL.Recipe("mech_hay_item", {Ingredient("wall_hay_item", 1), Ingredient("goldnugget", 2),Ingredient("transistor", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
			mech_hay_item.atlas = "images/inventoryimages/mech_hay_item.xml"

			local mech_wood_item = GLOBAL.Recipe("mech_wood_item", {Ingredient("wall_wood_item", 1), Ingredient("goldnugget", 2),Ingredient("transistor", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
			mech_wood_item.atlas = "images/inventoryimages/mech_wood_item.xml"

			local mech_stone_item = GLOBAL.Recipe("mech_stone_item", {Ingredient("wall_stone_item", 1), Ingredient("goldnugget", 2),Ingredient("transistor", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
			mech_stone_item.atlas = "images/inventoryimages/mech_stone_item.xml"
	
			local mech_ruins_item = GLOBAL.Recipe("mech_ruins_item", {Ingredient("wall_ruins_item", 1), Ingredient("goldnugget", 2),Ingredient("transistor", 1)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, nil, nil, true, 1)
			mech_ruins_item.atlas = "images/inventoryimages/mech_ruins_item.xml"
		else
			local mech_hay_item = GLOBAL.Recipe("mech_hay_item", {Ingredient("wall_hay_item", 1), Ingredient("goldnugget", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
			mech_hay_item.atlas = "images/inventoryimages/mech_hay_item.xml"

			local mech_wood_item = GLOBAL.Recipe("mech_wood_item", {Ingredient("wall_wood_item", 1), Ingredient("goldnugget", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
			mech_wood_item.atlas = "images/inventoryimages/mech_wood_item.xml"

			local mech_stone_item = GLOBAL.Recipe("mech_stone_item", {Ingredient("wall_stone_item", 1), Ingredient("goldnugget", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
			mech_stone_item.atlas = "images/inventoryimages/mech_stone_item.xml"
	
			local mech_ruins_item = GLOBAL.Recipe("mech_ruins_item", {Ingredient("wall_ruins_item", 1), Ingredient("goldnugget", 4)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, nil, nil, true, 1)
			mech_ruins_item.atlas = "images/inventoryimages/mech_ruins_item.xml"
		end
	elseif GetModConfigData("Wall Gates Recipe") == "gold" then
		local mech_hay_item = GLOBAL.Recipe("mech_hay_item", {Ingredient("wall_hay_item", 1), Ingredient("goldnugget", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
		mech_hay_item.atlas = "images/inventoryimages/mech_hay_item.xml"

		local mech_wood_item = GLOBAL.Recipe("mech_wood_item", {Ingredient("wall_wood_item", 1), Ingredient("goldnugget", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
		mech_wood_item.atlas = "images/inventoryimages/mech_wood_item.xml"

		local mech_stone_item = GLOBAL.Recipe("mech_stone_item", {Ingredient("wall_stone_item", 1), Ingredient("goldnugget", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
		mech_stone_item.atlas = "images/inventoryimages/mech_stone_item.xml"
	
		local mech_ruins_item = GLOBAL.Recipe("mech_ruins_item", {Ingredient("wall_ruins_item", 1), Ingredient("goldnugget", 2)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, nil, nil, true, 1)
		mech_ruins_item.atlas = "images/inventoryimages/mech_ruins_item.xml"
	end
end

if GetModConfigData("Wall Gates Version") == "normal" then
	PrefabFiles = 
	{
		"mech_normal.lua",
	}

	Assets = 
	{
		Asset("ATLAS", "images/inventoryimages/normal/mech_hay_item.xml"),
		Asset("ATLAS", "images/inventoryimages/normal/mech_wood_item.xml"),
		Asset("ATLAS", "images/inventoryimages/normal/mech_stone_item.xml"),
		Asset("ATLAS", "images/inventoryimages/normal/mech_ruins_item.xml"),
	}

	if GetModConfigData("Wall Gates Recipe") == "gears" then
		local mech_hay_item = GLOBAL.Recipe("mech_hay_item", {Ingredient("wall_hay_item", 1), Ingredient("goldnugget", 2),Ingredient("gears", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
		mech_hay_item.atlas = "images/inventoryimages/normal/mech_hay_item.xml"

		local mech_wood_item = GLOBAL.Recipe("mech_wood_item", {Ingredient("wall_wood_item", 1), Ingredient("goldnugget", 2),Ingredient("gears", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
		mech_wood_item.atlas = "images/inventoryimages/normal/mech_wood_item.xml"

		local mech_stone_item = GLOBAL.Recipe("mech_stone_item", {Ingredient("wall_stone_item", 1), Ingredient("goldnugget", 2),Ingredient("gears", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
		mech_stone_item.atlas = "images/inventoryimages/normal/mech_stone_item.xml"
	
		local mech_ruins_item = GLOBAL.Recipe("mech_ruins_item", {Ingredient("wall_ruins_item", 1), Ingredient("goldnugget", 2),Ingredient("gears", 1)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, nil, nil, true, 1)
		mech_ruins_item.atlas = "images/inventoryimages/normal/mech_ruins_item.xml"
	elseif GetModConfigData("Wall Gates Recipe") == "transistor" then
		if GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS) then 
			local mech_hay_item = GLOBAL.Recipe("mech_hay_item", {Ingredient("wall_hay_item", 1), Ingredient("goldnugget", 2),Ingredient("transistor", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
			mech_hay_item.atlas = "images/inventoryimages/normal/mech_hay_item.xml"

			local mech_wood_item = GLOBAL.Recipe("mech_wood_item", {Ingredient("wall_wood_item", 1), Ingredient("goldnugget", 2),Ingredient("transistor", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
			mech_wood_item.atlas = "images/inventoryimages/normal/mech_wood_item.xml"

			local mech_stone_item = GLOBAL.Recipe("mech_stone_item", {Ingredient("wall_stone_item", 1), Ingredient("goldnugget", 2),Ingredient("transistor", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
			mech_stone_item.atlas = "images/inventoryimages/normal/mech_stone_item.xml"
	
			local mech_ruins_item = GLOBAL.Recipe("mech_ruins_item", {Ingredient("wall_ruins_item", 1), Ingredient("goldnugget", 2),Ingredient("transistor", 1)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, nil, nil, true, 1)
			mech_ruins_item.atlas = "images/inventoryimages/normal/mech_ruins_item.xml"
		else
			local mech_hay_item = GLOBAL.Recipe("mech_hay_item", {Ingredient("wall_hay_item", 1), Ingredient("goldnugget", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
			mech_hay_item.atlas = "images/inventoryimages/normal/mech_hay_item.xml"

			local mech_wood_item = GLOBAL.Recipe("mech_wood_item", {Ingredient("wall_wood_item", 1), Ingredient("goldnugget", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
			mech_wood_item.atlas = "images/inventoryimages/normal/mech_wood_item.xml"

			local mech_stone_item = GLOBAL.Recipe("mech_stone_item", {Ingredient("wall_stone_item", 1), Ingredient("goldnugget", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
			mech_stone_item.atlas = "images/inventoryimages/normal/mech_stone_item.xml"
	
			local mech_ruins_item = GLOBAL.Recipe("mech_ruins_item", {Ingredient("wall_ruins_item", 1), Ingredient("goldnugget", 4)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, nil, nil, true, 1)
			mech_ruins_item.atlas = "images/inventoryimages/normal/mech_ruins_item.xml"
		end
	elseif GetModConfigData("Wall Gates Recipe") == "gold" then
		local mech_hay_item = GLOBAL.Recipe("mech_hay_item", {Ingredient("wall_hay_item", 1), Ingredient("goldnugget", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
		mech_hay_item.atlas = "images/inventoryimages/normal/mech_hay_item.xml"

		local mech_wood_item = GLOBAL.Recipe("mech_wood_item", {Ingredient("wall_wood_item", 1), Ingredient("goldnugget", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
		mech_wood_item.atlas = "images/inventoryimages/normal/mech_wood_item.xml"

		local mech_stone_item = GLOBAL.Recipe("mech_stone_item", {Ingredient("wall_stone_item", 1), Ingredient("goldnugget", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 1)
		mech_stone_item.atlas = "images/inventoryimages/normal/mech_stone_item.xml"
	
		local mech_ruins_item = GLOBAL.Recipe("mech_ruins_item", {Ingredient("wall_ruins_item", 1), Ingredient("goldnugget", 2)}, RECIPETABS.ANCIENT, TECH.ANCIENT_TWO, nil, nil, true, 1)
		mech_ruins_item.atlas = "images/inventoryimages/normal/mech_ruins_item.xml"
	end
	
	function HighlightPostInit(self)
	self.Highlight = function(self, r, g, b)
	self.highlit = true
	if self.inst:IsValid() and self.inst:HasTag("player") or TheSim:GetLightAtPoint(self.inst.Transform:GetWorldPosition()) > TUNING.DARK_CUTOFF then
		local m = .2
		if self.inst:HasTag("wallgate") or self.inst:HasTag("wallgateitem") then
			self.highlight_add_colour_red = 0.3
			self.highlight_add_colour_green = 0.3
			self.highlight_add_colour_blue = 0
		else
			self.highlight_add_colour_red = r or m
			self.highlight_add_colour_green = g or m
			self.highlight_add_colour_blue = b or m
		end
	end
	self:ApplyColour()   
	end
	end			
	AddComponentPostInit("highlight", HighlightPostInit)
end