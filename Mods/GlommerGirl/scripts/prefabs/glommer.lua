require("brains/glommerbrain")
require "stategraphs/SGglommer"

local assets=
{
	Asset("ANIM", "anim/wendy.zip"),
	Asset("ANIM", "anim/player_basic.zip"),
	Asset("SOUND", "sound/wendy.fsb") ,
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

local WAKE_TO_FOLLOW_DISTANCE = 7
local SLEEP_NEAR_LEADER_DISTANCE = 2

local function ontalk(inst, script)
    inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
end

local function ShouldAcceptItem(inst, item)
    if inst.components.sleeper:IsAsleep() then
        return false
    end
    
    if item.components.edible.foodtype == "SEEDS" then
	inst.components.talker:Say("Hate seeds")
	return false
    end
    
    return true
end

local function OnGetItemFromPlayer(inst, giver, item)

    if inst.components.sleeper:IsAsleep() then
	inst.components.sleeper:WakeUp()
    end

    if item.components.edible then
	if item.components.edible.foodtype == "VEGGIE" then
	    local pee = SpawnPrefab("glommerfuel")
	    pee.Transform:SetPosition(inst.Transform:GetWorldPosition())
	    inst.components.talker:Say("Delicious Vegi")
    
	elseif item.components.edible.foodtype == "MEAT" then
	    local poo = SpawnPrefab("poop")
	    poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
	    inst.components.talker:Say("Delicious Meat")
	end
    end
    
end

local function OnRefuseItem(inst, item)
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE)
end

local function ShouldSleep(inst)
    --print(inst, "ShouldSleep", DefaultSleepTest(inst), not inst.sg:HasStateTag("open"), inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE))
    return DefaultSleepTest(inst) 
    and inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE) 
    and GetWorld().components.clock:GetMoonPhase() ~= "full"
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
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("companion")
    inst:AddTag("glommer")
    inst:AddTag("flying")
    inst:AddTag("cattoyairborne")
	
    inst:AddComponent("inspectable")
    inst:AddComponent("follower")
    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst:AddComponent("knownlocations")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('glommer') 

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)
    
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader:Enable()
    
    inst:AddComponent("talker")
    inst.components.talker.ontalk = ontalk
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
    inst.components.periodicspawner:Start()
	
    local brain = require("brains/glommerbrain")
    inst:SetBrain(brain)
    inst:SetStateGraph("SGglommer")

    MakeMediumFreezableCharacter(inst, "glommer_body")

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnEntitySleep = OnEntitySleep
    
    return inst
end


return Prefab("common/creatures/glommer", fn, assets, prefabs)
