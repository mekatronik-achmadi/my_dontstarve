require("brains/glommerbrain")
require "stategraphs/SGshadowwaxwell"

local assets=
{
	Asset( "ANIM", "anim/player_basic.zip"),
	Asset("SOUND", "sound/wilson.fsb"),
	
	Asset( "ANIM", "anim/honk.zip" ),
	Asset("SOUND", "sound/woodie.fsb"),
}

local prefabs = 
{	
	"glommerfuel",
	"poop",
}

local POOP_TIME = 0
local GIRL_POOP = 0
local GIRL_WORD = 0
local GIRL_DIST = 5

local QWORDS = 
{
	"I want you eat my poop", --0
	"Please inhale my fart", --1
	"Can your mouth clean my butt?", --2
	"Can my butt sit on your face?", --3
	"I want your tongue lick my butt hole", --4
	"I hope your lips kiss my butt hole", --5
	"My butt need your mouth for toilet", --6
	"I think your face skin will warm my butt skin", --7
	"It will so comfort if my butt sit on your face", --8
	"Maybe your face will fit in my butt crack" --9
}

local AWORDS =
{
	"I'll eat all your poop", --0
	"Your fart smells like flower", --1
	"My mouth will clean your butt", --2
	"I hope your butt sit in my face soon", --3
	"Your butt hole taste like a sugar", --4
	"I'll kiss your butt hole with love", --5
	"My mouth always be a toilet for your butt", --6
	"And I think your butt will warm my face too", --7
	"Your butt will comfort my face too", --8
	"It will so nice if my face in your butt crack"
}

local function ShouldAcceptItem(inst, item)
    
    if POOP_TIME == 1 then
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
	    GIRL_POOP = 2
	elseif item.components.edible.foodtype == "VEGGIE" then
	    GIRL_POOP = 3
	end
	
	POOP_TIME = 1
	inst.sg:GoToState("pooping")
    end
    
end

local function OnFarting(inst)
	local fart = SpawnPrefab("maxwell_smoke")
	fart.Transform:SetScale(0.3,0.3,0.3)
	fart.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.components.talker:Say("Uhhhh, Are you breathe in my fart?")
end

local function OnPoopSeed(inst)
	if POOP_TIME == 0 then
		GIRL_POOP = 1
		POOP_TIME = 1
		local fart = SpawnPrefab("maxwell_smoke")
		fart.Transform:SetScale(0.3,0.3,0.3)
		fart.Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst.components.talker:Say("Aww, What if you inhale my fart?")
		inst.sg:GoToState("poop_pre")
	end
end

local function OnPooping(inst)
	if GIRL_POOP == 1 then
	    local poo = SpawnPrefab("seeds")
	    poo.Transform:SetScale(0.5,0.5,0.5)
	    poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
	    inst.components.talker:Say("Ups, Would you like to eat my poop?")
	elseif GIRL_POOP == 2 then
	    local poo = SpawnPrefab("glommerfuel")
	    poo.Transform:SetScale(0.3,0.3,0.3)
	    poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
	    inst.components.talker:Say("Ehmm, Do you wanna eat my poop?")
	elseif GIRL_POOP == 3 then
	    local poo = SpawnPrefab("poop")
	    poo.Transform:SetScale(0.3,0.3,0.3)
	    poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
	    inst.components.talker:Say("Eyyewww, Can you eat my poop?")
	end
end

local function OnPoopOut(inst)
	POOP_TIME = 0
end

local function OnRandomTalking(inst)
	if POOP_TIME == 0 then
		local GIRL_WORD = math.random(#QWORDS)
	        local word = QWORDS[GIRL_WORD]
	        if inst.components.follower:IsNearLeader(GIRL_DIST) then
        		inst.components.talker:Say(word,4)
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
	
    local brain = require("brains/glommerbrain")
    inst:SetBrain(brain)
    inst:SetStateGraph("SGshadowwaxwell")

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnEntitySleep = OnEntitySleep
    
    inst:ListenForEvent("donetalking", function() 
    	inst.SoundEmitter:KillSound("talk")
    	if  POOP_TIME == 0 then
    		if inst.components.follower:IsNearLeader(GIRL_DIST) then
	    		local husband = GetPlayer()
    			local word = AWORDS[GIRL_WORD]
    			husband.components.talker:Say(word,4)
    		end
	end
    end)
    inst:ListenForEvent("ontalk", function() inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/lucytalk_LP","talk") end)
    inst:ListenForEvent("pooping",OnPooping)
    inst:ListenForEvent("farting",OnFarting)
    inst:ListenForEvent("poop_out",OnPoopOut)
    
    inst:DoPeriodicTask(math.random(20,40),OnRandomTalking)
    inst:DoPeriodicTask(240,OnPoopSeed)
    
    return inst
end


return Prefab("common/creatures/glommer", fn, assets, prefabs)
