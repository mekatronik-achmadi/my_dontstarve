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

local boy = nil
local boy_near = false

local girl_poop = 0
local not_pooping = true

local girl_chat = 0
local girl_word = 0

local girl_words = 
{
    "I want my fart inhaled by your nose", --1
    "I want my poop eaten by your mouth", --2
    "I want my butt hole kissed by your mouth", --3
    "I want my butt hole sucked by your mouth", --4
    "I want my butt hole penetrated by your tongue", --5
    "I want my butt hole licked by your tongue", --6
    "I need my butt cleaned by your tongue", --7
    "I need my butt pooping on your face", --8
    "I need my butt sitting on your face", --9
}

local boy_words =
{
    "My nose can gladly inhale your fart", --1
    "My mouth can eat your poop with pleasure", --2
    "My mouth can happily kiss your butt hole", --3
    "My mouth can lustful suck your butt hole", --4
    "My tongue can gently penetrate your butt hole", --5
    "My tongue can slowly lick your butt hole", --6
    "My tongue can clean your butt with joy", --7
    "My face always be a toilet for your butt", --8
    "My face always be a seat for your butt", --9
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
	"Your face is a cozy toilet for my butt", --9
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
	"I'm happy your butt pooping on my face", --9
}

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
	    inst.components.talker:Say(say_word,2,true)
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
	if not_pooping then
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
		inst.components.talker:Say(say_word,2,true)
	end
end

local function OnPooping(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	
	if boy:HasTag("get_poop") then
	    x,y,z = boy.Transform:GetWorldPosition()
	end
	
	if girl_poop == 1 then
		local poo = SpawnPrefab("girlseeds")
		poo.Transform:SetPosition(x,y,z)
		if boy_near and girl_chat == 0 then
			girl_chat = 7
			local say_word = girl_says[girl_chat-1]
			inst.components.talker:Say(say_word,2,true)
		end
	elseif girl_poop == 2 then
		local poo = SpawnPrefab("glommerfuel")
		poo.Transform:SetPosition(x,y,z)
		if boy_near and girl_chat == 0 then
			girl_chat = 8
			local say_word = girl_says[girl_chat-1]
			inst.components.talker:Say(say_word,2,true)
		end
	elseif girl_poop == 3 then
		local poo = SpawnPrefab("girlpoop")
		poo.Transform:SetPosition(x,y,z)
		if boy_near and girl_chat == 0 then
			girl_chat = 9
			local say_word = girl_says[girl_chat-1]
			inst.components.talker:Say(say_word,2,true)
		end
	end
end

local function OnPoopOut(inst)
	
    if boy:HasTag("get_poop") then
	
	boy:RemoveTag("get_poop")
	boy.sg:GoToState("idle")
	
	if girl_poop == 1 then
	    boy.components.sanity:DoDelta(TUNING.SANITY_TINY)
	elseif girl_poop == 2 then
	    boy.components.sanity:DoDelta(TUNING.SANITY_SMALL)
	elseif girl_poop == 3 then
	    boy.components.sanity:DoDelta(TUNING.SANITY_MED)
	end
	
	inst:AddTag("happy_poop")
	inst:DoTaskInTime(2, function()
	    not_pooping = true
	    inst:RemoveTag("happy_poop")
	    girl_chat = 10
	    inst.components.talker:Say("Your face is a cozy toilet for my butt")
	end)
    else
	not_pooping = true
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
    
    if boy_near and not boy:HasTag("get_poop") then
	if not danger then
	    boy:AddTag("get_poop")
	    boy.sg:GoToState("boy_get_poop")
	    
	    local x,y,z = boy.Transform:GetWorldPosition()
	    inst:ForceFacePoint(boy.Transform:GetWorldPosition())
	    inst.Transform:SetPosition(x,y+0.55,z)
	    boy.Transform:SetPosition(x,y-5,z)
	else
	    boy.components.talker:Say("Your butt can use my face as a toilet later")
	end
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
	
    local brain = require("brains/glommerbrain")
    inst:SetBrain(brain)
    inst:SetStateGraph("SGshadowwaxwell")

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnEntitySleep = OnEntitySleep
    
    boy = GetPlayer()
    
    if TUNING.GIRL_AUTO == "auto" then
    	inst:DoPeriodicTask(240,OnPoopSeed)
    	inst:DoPeriodicTask(math.random(30,60),OnRandomTalking)
    end
    
    inst:ListenForEvent("farting",OnFarting)
    inst:ListenForEvent("pooping",OnPooping)
    inst:ListenForEvent("poop_out",OnPoopOut)
    
    inst:ListenForEvent("ontalk", function() inst.SoundEmitter:PlaySound("dontstarve/characters/wendy/talk_LP","talk") end)
    inst:ListenForEvent("donetalking", function()
	inst.SoundEmitter:KillSound("talk") 
	inst:DoTaskInTime(2.5,OnBoyTalk)
    end)
    
    inst:ListenForEvent("boy_get_poop",OnBoyGetPoop)
    
    return inst
end


return Prefab("common/creatures/glommer", fn, assets, prefabs)
