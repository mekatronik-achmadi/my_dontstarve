require("brains/glommerbrain")
require "stategraphs/SGshadowwaxwell"

local assets=
{
	Asset( "ANIM", "anim/player_basic.zip"),
	Asset("SOUND", "sound/wilson.fsb"),
	
	Asset( "ANIM", "anim/honk.zip" ),
	Asset("SOUND", "sound/wendy.fsb"),
}

local prefabs = 
{	
	"glommerfuel",
	"poop",
}

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

local function ShouldAcceptItem(inst, item)
    
    if poop_time == 1 then
	inst.components.talker:Say("Wait till my poop come out, OK?")	
	return false
    end
    
    if item.components.edible then
	    if item.components.edible.foodtype == "SEEDS" then
		inst.components.talker:Say("My poop is your meal, isn't it?")
		return false
	    elseif item.components.edible.foodtype == "MEAT" or item.components.edible.foodtype == "VEGGIE" then
	    	return true
	    else
		inst.components.talker:Say("Is it better than my poop?")
		return false
	    end
    else
	    inst.components.talker:Say("It's worse then my poop, right?")	
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

local function OnFarting(inst)
	girl_chat = 0
	local fart = SpawnPrefab("maxwell_smoke")
	fart.Transform:SetScale(0.3,0.3,0.3)
	fart.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.components.talker:Say("Uhhhh, Are you breathe in my fart?")
end

local function OnPoopSeed(inst)
	girl_chat = 0
	if poop_time == 0 then
		girl_poop = 1
		poop_time = 1
		inst.sg:GoToState("poop_pre")
	end
end

local function OnPooping(inst)
	girl_chat = 0
	if girl_poop == 1 then
	    local poo = SpawnPrefab("seeds")
	    poo.Transform:SetScale(0.5,0.5,0.5)
	    poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
	    inst.components.talker:Say("Ups, Would you like to eat my poop?")
	elseif girl_poop == 2 then
	    local poo = SpawnPrefab("glommerfuel")
	    poo.Transform:SetScale(0.3,0.3,0.3)
	    poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
	    inst.components.talker:Say("Ehmm, Do you wanna eat my poop?")
	elseif girl_poop == 3 then
	    local poo = SpawnPrefab("poop")
	    poo.Transform:SetScale(0.3,0.3,0.3)
	    poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
	    inst.components.talker:Say("Eyyewww, Can you eat my poop?")
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

local function OnRandomTalking(inst)
	if poop_time == 0 then
		girl_chat = 0
		girl_word = math.random(#girl_words)
	        local word = girl_words[girl_word]
	        if boy_near == 1 then
        		inst.components.talker:Say(word,4)
        		girl_chat = 1
        	end
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
    minimap:SetIcon("honk.tex")
    minimap:SetPriority(5)

    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("honk")
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
    inst.components.locomotor.walkspeed = 10
    
    inst:AddComponent( "playerprox" )
    inst.components.playerprox:SetOnPlayerNear(onnear)    
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
    local brain = require("brains/glommerbrain")
    inst:SetBrain(brain)
    inst:SetStateGraph("SGshadowwaxwell")

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnEntitySleep = OnEntitySleep
    
    inst:ListenForEvent("pooping",OnPooping)
    inst:ListenForEvent("farting",OnFarting)
    inst:ListenForEvent("poop_out",OnPoopOut)
    
    inst:ListenForEvent("ontalk", function() inst.SoundEmitter:PlaySound("dontstarve/characters/wendy/talk_LP","talk") end)
    inst:ListenForEvent("donetalking", function() 
    	inst.SoundEmitter:KillSound("talk")
    	if  poop_time == 0 then
    		if boy_near == 1 and girl_chat == 1 then
	    		local boy = GetPlayer()
    			local word = boy_words[girl_word]
    			if boy.components.talker then
    				boy.components.talker:Say(word,4)
    				girl_chat = 0
	    		end
    		end
	end
    end)
    
    inst:DoPeriodicTask(math.random(30,60),OnRandomTalking)
    inst:DoPeriodicTask(240,OnPoopSeed)
    
    return inst
end


return Prefab("common/creatures/glommer", fn, assets, prefabs)
