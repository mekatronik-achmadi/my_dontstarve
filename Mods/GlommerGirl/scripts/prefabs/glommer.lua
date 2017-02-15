require("brains/glommerbrain")
require "stategraphs/SGshadowwaxwell"

local assets=
{
	Asset("ANIM", "anim/player_basic.zip"),
	Asset("SOUND", "sound/wilson.fsb"),
	
	Asset("ANIM", "anim/wendy.zip"),
	Asset("SOUND", "sound/wendy.fsb"),
	--Asset("ANIM", "anim/willow.zip"),
	--Asset("SOUND", "sound/willow.fsb"),
}

local prefabs = 
{	
	"glommerfuel",
	"poop",
}

local GIRL_POOP = 0
local POOP_TIME = 0
local WORDS = {"I want you eat all my poop","Please inhale every my fart","Can your mouth clean my butt?","Can my butt sit on your face?","I want your tongue lick my butt hole","I hope your lips kiss my butt hole","My butt hole need your mouth as toilet","I think your face skin will warm my butt skin","If my butt can sit on your face, it will so comfort","Maybe your face will fit in my butt crack"}

local function ShouldAcceptItem(inst, item)
    
    if POOP_TIME == 1 then
	inst.components.talker:Say("wait till my poop come out, ok?")	
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

local function OnSeedSpawn(inst)
	if POOP_TIME == 0 then
		GIRL_POOP = 1
		POOP_TIME = 1
		inst.sg:GoToState("poop_pre")
	end
end

local function OnPooping(inst)
	if GIRL_POOP == 1 then
	    local poo = SpawnPrefab("seeds")
	    poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
	    inst.components.talker:Say("Ups, Would you like to eat my poop?")
	elseif GIRL_POOP == 2 then
	    local poo = SpawnPrefab("glommerfuel")
	    poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
	    inst.components.talker:Say("Ehmm, Do you wanna eat my poop?")
	elseif GIRL_POOP == 3 then
	    local poo = SpawnPrefab("poop")
	    poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
	    inst.components.talker:Say("Eyyewww, Can you eat my poop?")
	end
end

local function OnFarting(inst)
	local fart = SpawnPrefab("maxwell_smoke")
	fart.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.components.talker:Say("Aww, what if you inhale my fart?")
end

local function OnPoopOut(inst)
	POOP_TIME = 0
end

local function OnRandomTalking(inst)
	if POOP_TIME == 0 then
	        local word = WORDS[math.random(#WORDS)]
        	inst.components.talker:Say(word,4)
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
    minimap:SetIcon("wendy.png")
    --minimap:SetIcon("willow.png")
    minimap:SetPriority(5)

    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("wendy")
    --inst.AnimState:SetBuild("willow")
    inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Show("ARM_normal")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("companion")
    inst:AddTag("glommer")
    inst:RemoveTag("canbetrapped")
	
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

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetOnSpawnFn(OnSeedSpawn)
    inst.components.periodicspawner.prefab = "maxwell_smoke"
    inst.components.periodicspawner.basetime = TUNING.TOTAL_DAY_TIME * 0.1
    inst.components.periodicspawner.randtime = TUNING.TOTAL_DAY_TIME * 0.1
    inst.components.periodicspawner:Start()
	
    local brain = require("brains/glommerbrain")
    inst:SetBrain(brain)
    inst:SetStateGraph("SGshadowwaxwell")

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnEntitySleep = OnEntitySleep
    
    inst:ListenForEvent("donetalking", function() inst.SoundEmitter:KillSound("talk") end)
    inst:ListenForEvent("ontalk", function() inst.SoundEmitter:PlaySound("dontstarve/characters/wendy/talk_LP","talk") end)
    --inst:ListenForEvent("ontalk", function() inst.SoundEmitter:PlaySound("dontstarve/characters/willow/talk_LP","talk") end)
    inst:ListenForEvent("pooping",OnPooping)
    inst:ListenForEvent("farting",OnFarting)
    inst:ListenForEvent("poop_out",OnPoopOut)
    
    inst:DoPeriodicTask(math.random(20,40),OnRandomTalking)
    
    return inst
end


return Prefab("common/creatures/glommer", fn, assets, prefabs)
