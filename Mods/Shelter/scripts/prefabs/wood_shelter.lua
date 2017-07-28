
local assets =
{
	Asset("ANIM", "anim/siesta_shelter.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle", true)
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle", true)
end

local function onnear(inst)
       TUNING.WOOD_SHELTER_WATERPROOFNESS = 0.65
       TUNING.WOOD_SHELTER_INSULATION = TUNING.INSULATION_LARGE
       TUNING.WOOD_SHELTER_SLEEPING = 1
end

local function onfar(inst)
       TUNING.WOOD_SHELTER_WATERPROOFNESS = 0
       TUNING.WOOD_SHELTER_INSULATION = 0
       TUNING.WOOD_SHELTER_SLEEPING = 0
end

local function onsleep(inst, sleeper)
  
  if GetClock():IsDay() then
		local tosay = "ANNOUNCE_NODAYSLEEP"
		if GetWorld():IsCave() then
			tosay = "ANNOUNCE_NODAYSLEEP_CAVE"
		end
		if sleeper.components.talker then
			sleeper.components.talker:Say(GetString(sleeper.prefab, tosay))
			return
		end
	end
  
  if inst:HasTag("fire") then
		if sleeper.components.talker then
			sleeper.components.talker:Say(GetString(sleeper.prefab, "ANNOUNCE_NOSLEEPONFIRE"))
		end
		return
	end
  
  local hounded = GetWorld().components.hounded

	local danger = FindEntity(inst, 10, function(target) 
		return
			(target:HasTag("monster") and not target:HasTag("player") and not sleeper:HasTag("spiderwhisperer"))
			or (target:HasTag("monster") and not target:HasTag("player") and sleeper:HasTag("spiderwhisperer") and not target:HasTag("spider"))
			or (target:HasTag("pig") and not target:HasTag("player") and sleeper:HasTag("spiderwhisperer"))
			or (target.components.combat and target.components.combat.target == sleeper)
	end)
	
	if hounded and (hounded.warning or hounded.timetoattack <= 0) then
		danger = true
	end
	
	if danger then
		if sleeper.components.talker then
			sleeper.components.talker:Say(GetString(sleeper.prefab, "ANNOUNCE_NODANGERSLEEP"))
		end
		return
	end
  
  if sleeper.components.hunger.current < TUNING.CALORIES_MED then
		sleeper.components.talker:Say(GetString(sleeper.prefab, "ANNOUNCE_NOHUNGERSLEEP"))
		return
	end
  
  sleeper.components.health:SetInvincible(true)
	sleeper.components.playercontroller:Enable(false)

	GetPlayer().HUD:Hide()
	TheFrontEnd:Fade(false,1)
  
  inst:DoTaskInTime(1.2, function() 
    GetPlayer().HUD:Show()
    TheFrontEnd:Fade(true,1) 
    
    if GetClock():IsDay() then
      local tosay = "ANNOUNCE_NODAYSLEEP"
			if GetWorld():IsCave() then
				tosay = "ANNOUNCE_NODAYSLEEP_CAVE"
			end
      
      if sleeper.components.talker then				
				sleeper.components.talker:Say(GetString(sleeper.prefab, tosay))
				sleeper.components.health:SetInvincible(false)
				sleeper.components.playercontroller:Enable(true)
				return
			end
        
    end
    
    if sleeper.components.sanity then
			sleeper.components.sanity:DoDelta(TUNING.SANITY_MEDLARGE)
		end
		
		if sleeper.components.hunger then
			sleeper.components.hunger:DoDelta(-TUNING.CALORIES_LARGE, false, true)
		end
		
		if sleeper.components.health then
			sleeper.components.health:DoDelta(TUNING.HEALING_MEDLARGE, false, "tent", true)
		end
    
    if sleeper.components.temperature and sleeper.components.temperature.current < TUNING.TARGET_SLEEP_TEMP then
			sleeper.components.temperature:SetTemperature(TUNING.TARGET_SLEEP_TEMP)
		end		
		
		local moisture_start = nil
		if sleeper.components.moisture and sleeper.components.moisture:GetMoisture() > 0 then
			moisture_start = sleeper.components.moisture.moisture
		end
    
    GetClock():MakeNextDay()
    
    if moisture_start then
			sleeper.components.moisture.moisture = moisture_start - TUNING.SLEEP_MOISTURE_DELTA
			if sleeper.components.moisture.moisture < 0 then sleeper.components.moisture.moisture = 0 end
		end
		
		sleeper.components.health:SetInvincible(false)
		sleeper.components.playercontroller:Enable(true)
		sleeper.sg:GoToState("wakeup")	
    
  end)

end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    
	anim:SetBank("wood_shelter")
	anim:SetBuild("siesta_shelter")
	anim:PlayAnimation("idle", true)
  
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "siesta_shelter.tex" )

	inst:AddTag("shelter")
	
	inst:AddComponent( "playerprox" )
	inst.components.playerprox:SetOnPlayerNear(onnear)    
	inst.components.playerprox:SetOnPlayerFar(onfar)

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = TUNING.SANITYAURA_TINY

	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	inst:ListenForEvent( "onbuilt", onbuilt)
  
  inst:AddComponent("sleepingbag")
	inst.components.sleepingbag.onsleep = onsleep
  
  MakeSnowCovered(inst, .01)
  MakeLargeBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	
    return inst
end

return Prefab( "common/wood_shelter", fn, assets),
		MakePlacer( "common/wood_shelter_placer", "wood_shelter", "siesta_shelter", "idle" ) 
