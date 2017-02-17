require("brains/glommerbrain")
require "stategraphs/SGshadowwaxwell"

local assets=
{
	Asset( "ANIM", "anim/player_basic.zip"),
	Asset("SOUND", "sound/wilson.fsb"),
	
	Asset( "ANIM", "anim/honk.zip" ),
	Asset( "ANIM", "anim/tomoka.zip" ),
	
	Asset("SOUND", "sound/wendy.fsb"),
}

local prefabs = 
{	
	"glommerfuel",
	"poop",
}

local boy = nil
local boy_near = 0

local girl_chat = 0
local girl_word = 0

local girl_poop = 0
local poop_time = 0

local girl_words = 
{
	"I want you eat my poop", --1
	"You have to inhale my fart", --2
	"Can your mouth clean my butt?", --3
	"Can my butt sit on your face?", --4
	"I want your tongue lick my butt hole", --5
	"I hope your lips kiss my butt hole", --6
	"My butt need your mouth for toilet", --7
	"I think your face skin will warm my butt skin", --8
	"It will so comfort if my butt sit on your face", --9
	"Maybe your face will fit in my butt crack", --10
}

local boy_words =
{
	"I'll eat all your poop", --1
	"Your fart smells like flower", --2
	"My mouth will clean your butt", --3
	"I hope your butt sit in my face soon", --4
	"Your butt hole taste like a sugar", --5
	"I'll kiss your butt hole with love", --6
	"My mouth always be a toilet for your butt", --7
	"And I think your butt will warm my face too", --8
	"Your butt will comfort my face too", --9
	"It will so nice if my face get into your butt crack", --10
}

local girl_says =
{
	"Wait till my poop come out, OK?", --1
	"My poop is your meal, isn't it?", --2
	"Is it better than my poop?", --3
	"It's worse then my poop, right?", --4
	"Uhhhh, Are you breathe in my fart?", --5
	"Ups, Would you like to eat my poop?", --6
	"Ehmm, Do you wanna eat my poop?", --7
	"Eyyewww, Can you eat my poop?", --8
}

local boy_says =
{
	"For your poop, I'll wait patiently", --1
	"Your butt hole fed me", --2
	"No better meal than your poop", --3
	"Your poop is the best meal", --4
	"Your fart is my breathe air", --5
	"I would love to eat your poop", --6
	"Yes, I want to eat your poop", --7
	"Of Course, I can eat your poop", --8
}

local function OnRandomTalking(inst)
	if poop_time == 0 then
		girl_word = math.random(#girl_words)
	        if boy_near == 1 then
			girl_chat = 1
			local say_word = girl_words[girl_word]
        		inst.components.talker:Say(say_word)
        	end
	end
end

local function ShouldAcceptItem(inst, item)
    if poop_time == 1 then
	if boy_near == 1 then	
	    girl_chat = 2
	    local say_word = girl_says[girl_chat-1]		    
	    inst.components.talker:Say(say_word)
	end
	return false
    end
    
    if item.components.edible then
	    if item.components.edible.foodtype == "SEEDS" then
		if boy_near == 1 then
		    girl_chat = 3
		    local say_word = girl_says[girl_chat-1]
		    inst.components.talker:Say(say_word)
		end
		return false
	    elseif item.components.edible.foodtype == "MEAT" or item.components.edible.foodtype == "VEGGIE" then
	    	return true
	    else
		if boy_near == 1 then
		    girl_chat = 4
		    local say_word = girl_says[girl_chat-1]
		    inst.components.talker:Say(say_word)
		end
		return false
	    end
    else
	    if boy_near == 1 then
		girl_chat = 5
		local say_word = girl_says[girl_chat-1]
		inst.components.talker:Say(say_word)	
	    end
	    return false	    
    end    
end

local function OnGetItemFromPlayer(inst, giver, item)

    if item.components.edible then
	
	if item.components.edible.foodtype == "MEAT" then
	    girl_poop = 2
	elseif item.components.edible.foodtype == "VEGGIE" then
	    girl_poop = 3
	end
	
	poop_time = 1
	inst.sg:GoToState("pooping")
    end
    
end

local function OnPoopSeed(inst)
	if poop_time == 0 then
		girl_poop = 1
		poop_time = 1
		inst.sg:GoToState("poop_pre")
	end
end

local function OnFarting(inst)
	local fart = SpawnPrefab("maxwell_smoke")
	fart.Transform:SetScale(0.3,0.3,0.3)
	fart.Transform:SetPosition(inst.Transform:GetWorldPosition())
	if boy_near == 1 then
		girl_chat = 6
		local say_word = girl_says[girl_chat-1]
		inst.components.talker:Say(say_word)
	end
end

local function OnPooping(inst)
	if girl_poop == 1 then
		local poo = SpawnPrefab("seeds")
		poo.Transform:SetScale(0.5,0.5,0.5)
		poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
		if boy_near == 1 then
			girl_chat = 7
			local say_word = girl_says[girl_chat-1]
			inst.components.talker:Say(say_word)
		end
	elseif girl_poop == 2 then
		local poo = SpawnPrefab("glommerfuel")
		poo.Transform:SetScale(0.3,0.3,0.3)
		poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
		if boy_near == 1 then
			girl_chat = 8
			local say_word = girl_says[girl_chat-1]
			inst.components.talker:Say(say_word)
		end
	elseif girl_poop == 3 then
		local poo = SpawnPrefab("poop")
		poo.Transform:SetScale(0.3,0.3,0.3)
		poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
		if boy_near == 1 then
			girl_chat = 9
			local say_word = girl_says[girl_chat-1]
			inst.components.talker:Say(say_word)
		end
	end
end

local function OnPoopOut(inst)
	poop_time = 0
end

local function onnear(inst)
	boy_near = 1
end

local function onfar(inst)
	boy_near = 0
	girl_chat = 0
end

local function OnBoyTalk(inst)
    if boy_near == 1 and girl_chat > 0 and boy.components.talker then
	if girl_chat == 1 then
	    local say_word = boy_words[girl_word]
	    boy.components.talker:Say(say_word)
	else
	    local say_word = boy_says[girl_chat-1]
	    boy.components.talker:Say(say_word)
	end
	girl_chat = 0
    end
end

local function CalcSanityAura(inst, observer)
	return TUNING.SANITYAURA_LARGE
end

local function LeaveWorld(inst)
    inst:Remove()
end

local function OnEntitySleep(inst)
	if inst.ShouldLeaveWorld then
		LeaveWorld(inst)
	end
end

local function OnSave(inst, data)
	data.ShouldLeaveWorld = inst.ShouldLeaveWorld
end

local function OnLoad(inst, data)

	girl_chat = 0
	local say_word = "My beauty will makes you eat my poop"
	inst.components.talker:Say(say_word)
	
	if data then
		inst.ShouldLeaveWorld = data.ShouldLeaveWorld
	end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()

    inst.DynamicShadow:SetSize( 1.3, .6 )
    inst.Transform:SetFourFaced()

    MakeCharacterPhysics(inst, 75, .5)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon(TUNING.GIRL_ICON)
    minimap:SetPriority(5)

    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild(TUNING.GIRL_DEPIC)
    inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Show("ARM_normal")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("companion")
    inst:AddTag("glommer")
	
    inst:AddComponent("inspectable")
    inst:AddComponent("follower")
    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst:AddComponent("knownlocations")
    
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader:Enable()
    
    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0,-600,0)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 7
    inst.components.locomotor.runspeed = 7
    
    inst:AddComponent( "playerprox" )
    inst.components.playerprox:SetOnPlayerNear(onnear)    
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
    local brain = require("brains/glommerbrain")
    inst:SetBrain(brain)
    inst:SetStateGraph("SGshadowwaxwell")

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnEntitySleep = OnEntitySleep
    
    boy = GetPlayer()
    
    inst:DoPeriodicTask(160,OnPoopSeed)
    inst:DoPeriodicTask(math.random(20,40),OnRandomTalking)
    
    inst:ListenForEvent("pooping",OnPooping)
    inst:ListenForEvent("farting",OnFarting)
    inst:ListenForEvent("poop_out",OnPoopOut)
    
    inst:ListenForEvent("ontalk", function() inst.SoundEmitter:PlaySound("dontstarve/characters/wendy/talk_LP","talk") end)
    inst:ListenForEvent("donetalking", function()
	inst.SoundEmitter:KillSound("talk") 
	inst:DoTaskInTime(2.5,OnBoyTalk)
    end)
    
    return inst
end


return Prefab("common/creatures/glommer", fn, assets, prefabs)
