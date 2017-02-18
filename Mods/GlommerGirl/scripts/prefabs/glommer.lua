require("brains/glommerbrain")
require "stategraphs/SGshadowwaxwell"

local assets=
{
	Asset( "ANIM", "anim/player_basic.zip"),
	Asset("SOUND", "sound/wilson.fsb"),
	
	Asset( "ANIM", "anim/honk.zip" ),
	Asset( "ANIM", "anim/mabel.zip" ),
	
	Asset("SOUND", "sound/wendy.fsb"),
}

local prefabs = 
{	
	"glommerfuel",
	"poop",
}

local buttlight_intensity = .5
local buttlight_announce = false

local boy = nil
local boy_near = false
local boy_getpoop = false

local girl_poop = 0
local girl_cardio = true
local not_pooping = true

local girl_chat = 0
local girl_word = 0

local girl_words = 
{
	"I want you eat my poop", --1
	"You have to inhale my fart", --2
	"I need your tongue clean my butt", --3
	"I want your tongue lick my butt hole", --4
	"I hope your lips kiss my butt hole", --5
	"My butt need your mouth for toilet", --6
	"I think your face skin warm my butt skin", --7
	"It's' so comfort if my butt sit on your face", --8
	"I think your face fits in my butt crack", --9
}

local boy_words =
{
	"I love to eat all your poop", --1
	"Your fart smells like flower", --2
	"My tongue clean your butt with joy", --3
	"I can slowly lick your sweet butt hole", --4
	"I want to gently kiss your butt hole", --5
	"My mouth always be a toilet for your butt", --6
	"Your butt warm my face too", --7
	"Your butt can comfort my face too", --8
	"It's so nice if my face get into your butt crack", --9
}

local girl_says =
{
	"Wait till my poop come out, OK?", --1
	"My poop is your meal, isn't it?", --2
	"Is it better than my poop?", --3
	"It's worse than my poop, right?", --4
	"Uhhhh, Are you breathe in my fart?", --5
	"Ups, Would you like to eat my poop?", --6
	"Ehmm, Do you wanna eat my poop?", --7
	"Eyyewww, Can you eat my poop?", --8
	"Did you know that my butt shining?", --9
	"What if your mouth suck my butt hole for sport?", --10
}

local boy_says =
{
	"OK, I'm waiting your poop patiently", --1
	"Yes, Your butt hole fed me", --2
	"No, It's worse than your poop", --3
	"Yes, Your poop is better than this", --4
	"Yes, Your fart is my breathe air", --5
	"I would love to eat your poop", --6
	"Yes, I want to eat your poop", --7
	"Of Course, I can eat your poop", --8
	"Yes, Your butt shine to my face", --9
	"OK, My mouth gladly sucking your butt hole", --10
}

local function ButtLight(inst)
    if not GetClock():IsDay() then
	inst.Light:Enable(true)
	inst.Light:SetIntensity(buttlight_intensity)
	inst:DoTaskInTime(2, function()
	    if not buttlight_announce and not_pooping and boy_near and girl_chat == 0 then
		girl_chat = 10
		buttlight_announce = true
		local say_word = girl_says[girl_chat-1]
		inst.components.talker:Say(say_word)
	    end
	end)
    else
	buttlight_announce = false
	inst.Light:Enable(false)
	inst.Light:SetIntensity(0)
    end
end

local function OnRandomTalking(inst)
    if not_pooping and girl_chat == 0 then
	    girl_word = math.random(#girl_words)
	    if boy_near then
		    girl_chat = 1
		    local say_word = girl_words[girl_word]
		    inst.components.talker:Say(say_word)
	    end
    end
end

local function ShouldAcceptItem(inst, item)
    if not not_pooping and girl_chat == 0 then
	if boy_near then	
	    girl_chat = 2
	    local say_word = girl_says[girl_chat-1]		    
	    inst.components.talker:Say(say_word)
	end
	return false
    end
    
    if not girl_cardio and girl_chat == 0 then
	if boy_near then	
	    girl_chat = 11
	    local say_word = girl_says[girl_chat-1]		    
	    inst.components.talker:Say(say_word)
	end
	return false
    end
    
    if item.components.edible then
	    if item.components.edible.foodtype == "GIRLPOOP" then
		if boy_near and girl_chat == 0 then
		    girl_chat = 3
		    local say_word = girl_says[girl_chat-1]
		    inst.components.talker:Say(say_word)
		end
		return false
	    elseif item.components.edible.foodtype == "MEAT" 
		or item.components.edible.foodtype == "VEGGIE" 
		or item.components.edible.foodtype == "SEEDS" then
	    	return true
	    else
		if boy_near and girl_chat == 0 then
		    girl_chat = 4
		    local say_word = girl_says[girl_chat-1]
		    inst.components.talker:Say(say_word)
		end
		return false
	    end
    else
	    if boy_near and girl_chat == 0 then
		girl_chat = 5
		local say_word = girl_says[girl_chat-1]
		inst.components.talker:Say(say_word)	
	    end
	    return false	    
    end    
end

local function OnGetItemFromPlayer(inst, giver, item)

    if item.components.edible then
	
	if item.components.edible.foodtype == "SEEDS" then
	    girl_poop = 1
	elseif item.components.edible.foodtype == "MEAT" then
	    girl_poop = 2
	elseif item.components.edible.foodtype == "VEGGIE" then
	    girl_poop = 3
	end
	
	not_pooping = false
	inst.sg:GoToState("eating")
    end
    
end

local function OnPoopSeed(inst)
	if not not_pooping and girl_cardio then
		girl_poop = 1
		not_pooping = false
		inst.sg:GoToState("colic")
	end
end

local function OnFarting(inst)
	local fart = SpawnPrefab("maxwell_smoke")
	fart.Transform:SetScale(0.3,0.3,0.3)
	fart.Transform:SetPosition(inst.Transform:GetWorldPosition())
	if boy_near and girl_chat == 0 then
		girl_chat = 6
		local say_word = girl_says[girl_chat-1]
		inst.components.talker:Say(say_word)
	end
end

local function OnPooping(inst)
	local x,y,z = boy.Transform:GetWorldPosition()
	if girl_poop == 1 then
		local poo = SpawnPrefab("girlseeds")
		poo.Transform:SetPosition(x,y,z)
		if boy_near and girl_chat == 0 then
			girl_chat = 7
			local say_word = girl_says[girl_chat-1]
			inst.components.talker:Say(say_word)
		end
	elseif girl_poop == 2 then
		local poo = SpawnPrefab("glommerfuel")
		poo.Transform:SetPosition(x,y,z)
		if boy_near and girl_chat == 0 then
			girl_chat = 8
			local say_word = girl_says[girl_chat-1]
			inst.components.talker:Say(say_word)
		end
	elseif girl_poop == 3 then
		local poo = SpawnPrefab("girlpoop")
		poo.Transform:SetPosition(x,y,z)
		if boy_near and girl_chat == 0 then
			girl_chat = 9
			local say_word = girl_says[girl_chat-1]
			inst.components.talker:Say(say_word)
		end
	end
end

local function OnPoopOut(inst)
	not_pooping = true
	if boy_getpoop then
	
	    boy.sg:GoToState("idle")
	    
	    if girl_poop == 1 then
		boy.components.sanity:DoDelta(TUNING.SANITY_TINY)
	    elseif girl_poop == 2 then
		boy.components.sanity:DoDelta(TUNING.SANITY_SMALL)
	    elseif girl_poop == 3 then
		boy.components.sanity:DoDelta(TUNING.SANITY_MED)
	    end
	    
	    boy_getpoop = false
	    boy:RemoveTag("get_poop")
	    
	    girl_cardio = false
	end
end

local function onnear(inst)
	boy_near = true
end

local function onfar(inst)
	boy_near = false
end

local function OnBoyTalk(inst)
    if boy.components.talker and girl_chat > 0 then
	if girl_chat == 1 then
	    local say_word = boy_words[girl_word]
	    boy.components.talker:Say(say_word)
	elseif girl_chat == 6 or girl_chat == 7 or girl_chat == 8 or girl_chat == 9 then
	    local say_word = boy_says[girl_chat-1]
	    boy.components.talker:Say(say_word,2,true)
	else
	    local say_word = boy_says[girl_chat-1]
	    boy.components.talker:Say(say_word)
	end
	girl_chat = 0
    end
end

local function OnBoyGetPoop(inst)

    if not boy_near then
	return
    end
    
    local hounded = GetWorld().components.hounded

    local danger = FindEntity(inst, 10, function(target) 
	    return
		    (target:HasTag("monster") and not target:HasTag("player") and not boy:HasTag("spiderwhisperer"))
		    or (target:HasTag("monster") and not target:HasTag("player") and boy:HasTag("spiderwhisperer") and not target:HasTag("spider"))
		    or (target:HasTag("pig") and not target:HasTag("player") and boy:HasTag("spiderwhisperer"))
		    or (target.components.combat and target.components.combat.target == boy)
    end)

    if hounded and (hounded.warning or hounded.timetoattack <= 0) then
	    danger = true
    end

    if danger then
	    if boy.components.talker then
		    boy.components.talker:Say("Sorry, I'll eat your poop later")
	    end
	    return
    end
    
    if not boy_getpoop then
	boy:AddTag("get_poop")
	boy.sg:GoToState("boy_get_poop")
	boy_getpoop = true
	
	local x,y,z = boy.Transform:GetWorldPosition()
	inst:ForceFacePoint(boy.Transform:GetWorldPosition())
	inst.Transform:SetPosition(x,y+0.55,z)
	boy.Transform:SetPosition(x,y-5,z)
    end
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

	girl_chat = 0
	local say_word = "My beautiful butt makes you eat my poop"
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

    inst:AddTag("scarytoprey")
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
    
    inst.entity:AddLight()
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(buttlight_intensity)
    inst.Light:SetRadius(1)
    inst.Light:SetColour(1,1,1)
    inst.Light:Enable(false)
	
    local brain = require("brains/glommerbrain")
    inst:SetBrain(brain)
    inst:SetStateGraph("SGshadowwaxwell")

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnEntitySleep = OnEntitySleep
    
    boy = GetPlayer()
    
    inst:DoPeriodicTask(160,OnPoopSeed)
    inst:DoPeriodicTask(2, function() ButtLight(inst) end)
    inst:DoPeriodicTask(math.random(20,40),OnRandomTalking)
    
    inst:ListenForEvent("farting",OnFarting)
    inst:ListenForEvent("pooping",OnPooping)
    inst:ListenForEvent("poop_out",OnPoopOut)
    
    inst:ListenForEvent("ontalk", function() inst.SoundEmitter:PlaySound("dontstarve/characters/wendy/talk_LP","talk") end)
    inst:ListenForEvent("donetalking", function()
	inst.SoundEmitter:KillSound("talk") 
	inst:DoTaskInTime(2.5,OnBoyTalk)
    end)
    
    inst:ListenForEvent("girl_cardio",function() girl_cardio = true end)
    inst:ListenForEvent("boy_get_poop",OnBoyGetPoop)
    
    return inst
end


return Prefab("common/creatures/glommer", fn, assets, prefabs)
