require("brains/glommerbrain")
require "stategraphs/SGshadowwaxwell"

local assets=
{
	Asset("ANIM", "anim/wendy.zip"),
	Asset("ANIM", "anim/player_basic.zip"),
	Asset("SOUND", "sound/woodie.fsb"),
}

local prefabs = 
{	
	"glommerwings",
	"glommerfuel",
	"poop",
}

SetSharedLootTable('glommer',
{
    {'glommerwings',		1.00},
    {'glommerfuel',		1.00},
    {'glommerfuel',		1.00},
})

local function ShouldAcceptItem(inst, item)
    
    if item.components.edible.foodtype == "SEEDS" then
	inst.components.talker:Say("My poop is your meal, isn't it?")
	return false
    end
    
    return true
end

local function OnGetItemFromPlayer(inst, giver, item)

    if item.components.edible then
	if item.components.edible.foodtype == "VEGGIE" then
	    local pee = SpawnPrefab("glommerfuel")
	    pee.Transform:SetPosition(inst.Transform:GetWorldPosition())
	    inst.components.talker:Say("Ehmm, Do you wanna eat my poop?")
    
	elseif item.components.edible.foodtype == "MEAT" then
	    local poo = SpawnPrefab("poop")
	    poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
	    inst.components.talker:Say("Eyywww, Can you eat my poop?")
	end
    end
    
end

local function OnSeedSpawn(inst)
	inst.components.talker:Say("Ups, Would you like to eat my poop?")	
end

local function CalcSanityAura(inst, observer)
	return TUNING.SANITYAURA_SMALL
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

    inst.DynamicShadow:SetSize(2, .75)
    inst.Transform:SetFourFaced()

    MakeGhostPhysics(inst, 1, .5)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("wendy.png")
    minimap:SetPriority(5)

    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("wendy")
    inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Show("ARM_normal")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("companion")
    inst:AddTag("glommer")
    inst:RemoveTag("canbetrapped")
    inst:RemoveTag("animal")
	
    inst:AddComponent("inspectable")
    inst:AddComponent("follower")
    inst:AddComponent("health")
    inst:AddComponent("knownlocations")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('glommer') 
    
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
    inst.components.locomotor.walkspeed = 6

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner.prefab = "seeds"
    inst.components.periodicspawner.basetime = TUNING.TOTAL_DAY_TIME * 0.5
    inst.components.periodicspawner.randtime = TUNING.TOTAL_DAY_TIME * 0.5
    inst.components.periodicspawner:SetOnSpawnFn(OnSeedSpawn)
    inst.components.periodicspawner:Start()
	
    local brain = require("brains/glommerbrain")
    inst:SetBrain(brain)
    inst:SetStateGraph("SGshadowwaxwell")

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnEntitySleep = OnEntitySleep
    
    inst:ListenForEvent("donetalking", function() inst.SoundEmitter:KillSound("talk") end)
    inst:ListenForEvent("ontalk", function() inst.SoundEmitter:PlaySound("dontstarve/characters/wendy/talk_LP","talk") end)
    
    return inst
end


return Prefab("common/creatures/glommer", fn, assets, prefabs)
