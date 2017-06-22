RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH

Recipe("homesign", {Ingredient("boards", 1)}, RECIPETABS.TOWN, TECH.NONE, "homesign_placer")

GLOBAL.rewritable_signs = false
GLOBAL.pause_while_writing_on_signs = false

STRINGS = GLOBAL.STRINGS
ACTIONS = GLOBAL.ACTIONS
Action = GLOBAL.Action

STRINGS.ACTIONS.WRITEONSIGN = "Write On"

ACTIONS.WRITEONSIGN = Action(2)
for k,v in pairs(ACTIONS) do
	v.str = STRINGS.ACTIONS[k] or "ACTION"
	v.id = k
end

function actionpostint(inst)
    ACTIONS.WRITEONSIGN.fn = function(act)
	local target = act.target or act.invobject
	local writer = act.doer
	if target and target.components.writeable and not target.components.writeable.text then
	    target.components.writeable:StartWriting(target, writer)
	    return true
	end
    end
end

AddGamePostInit(actionpostint) 

function simpostinit()
    local function addActionHandler(SGname, action, state, condition)
	actionHandler = GLOBAL.ActionHandler(action, state, condition)
	for k,v in pairs(GLOBAL.SGManager.instances) do	
	    if(k.sg.name == SGname) then
		k.sg.actionhandlers[action] = actionHandler
		break
	    end
	end
    end
    
    addActionHandler("wilson", ACTIONS.WRITEONSIGN)
    
    if type(STRINGS.CHARACTERS.GENERIC.DESCRIBE.HOMESIGN) == "string" then

	STRINGS.CHARACTERS.GENERIC.DESCRIBE.HOMESIGN = {}
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.HOMESIGN["GENERIC"] = "There's nothing written on it."

	for k,v in pairs(GLOBAL.GetActiveCharacterList()) do	
	    if STRINGS.CHARACTERS[string.upper(v)] then
		local stored_string = STRINGS.CHARACTERS[string.upper(v)].DESCRIBE.HOMESIGN
		STRINGS.CHARACTERS[string.upper(v)].DESCRIBE.HOMESIGN = {}
		STRINGS.CHARACTERS[string.upper(v)].DESCRIBE.HOMESIGN["GENERIC"] = stored_string
	    end
	end
    else
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.HOMESIGN.GENERIC = "There's nothing written on it."
    end
    
    local hover = GLOBAL.require "widgets/hoverer"
    hover.OnUpdatePre = hover.OnUpdate
    hover.OnUpdate = function(self)
	if not self.owner.components.playercontroller.enabled then
	    self:Hide()
	    return
	end

	self:OnUpdatePre()
    end
end

AddSimPostInit(simpostinit)

function signspostinit(inst)
	
    local function readsigntext(inst, reader)
	if inst.components.writeable and inst.components.writeable.writtentext then

	    local spokentext = nil
	    local writtentext = inst.components.writeable.writtentext		

	    if reader.prefab == "wx78" then
		    spokentext = "MESSAGE READS '"..string.upper(writtentext).."'."
	    else 
		    spokentext = "It says '"..writtentext.."'."
	    end

	    if STRINGS.CHARACTERS[string.upper(reader.prefab)] then
		    STRINGS.CHARACTERS[string.upper(reader.prefab)].DESCRIBE.HOMESIGN["SPOKENTEXT"] = spokentext
	    else
		    STRINGS.CHARACTERS["GENERIC"].DESCRIBE.HOMESIGN["SPOKENTEXT"] = spokentext
	    end

	    return "SPOKENTEXT"	
	else
	    return nil
	end
    end

    inst:AddComponent("writeable")	
    inst.components.inspectable.getstatus = readsigntext	
end

AddPrefabPostInit("homesign", signspostinit)
