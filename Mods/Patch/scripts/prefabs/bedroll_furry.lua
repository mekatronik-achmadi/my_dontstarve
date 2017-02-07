local assets=
{
	Asset("ANIM", "anim/swap_bedroll_furry.zip"),
}

local function onsleep(inst, sleeper)
    local br = nil
    if inst.components.stackable then
	    br = inst.components.stackable:Get()
    else
	    br = inst
    end

    if br and br.components.finiteuses then
	    if br.components.finiteuses:GetUses() <= 1 then
		    br:Remove()
		    br.persists = false
	    end
    end
    
    if TUNING.WOOD_SHELTER_SLEEPING == 0 then
	sleeper.sg:GoToState("wakeup")
	local tosay = "ANNOUNCE_SLEEPNEEDSHELTER"
	if sleeper.components.talker then
	    sleeper.components.talker:Say(GetString(sleeper.prefab, tosay))
	end
    else
	GetPlayer().HUD:Hide()
	TheFrontEnd:Fade(false,1)
	
	inst:DoTaskInTime(1.2, function() 
	
		TheFrontEnd:Fade(true,1) 
		GetPlayer().HUD:Show()
		
		
		sleeper.sg:GoToState("wakeup")

		if sleeper.components.sanity then
			sleeper.components.sanity:DoDelta(TUNING.SANITY_HUGE, false)
		end

		if sleeper.components.health then
			sleeper.components.health:DoDelta(TUNING.HEALING_HUGE, false, "bedroll", true)
		end

		GetClock():MakeNextDay()
	end)
    end
end

local function onuse()
    GetPlayer().AnimState:OverrideSymbol("swap_bedroll", "swap_bedroll_furry", "bedroll_furry")	
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    MakeInventoryPhysics(inst)
    
    anim:SetBank("swap_bedroll_furry")
    anim:SetBuild("swap_bedroll_furry")
    anim:PlayAnimation("idle")
    
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetConsumption(ACTIONS.SLEEPIN, 1)
    inst.components.finiteuses:SetMaxUses(20)
    inst.components.finiteuses:SetUses(20)
    
    inst:AddComponent("sleepingbag")
    inst.components.sleepingbag.onsleep = onsleep
    
    inst.onuse = onuse
    
    return inst
end

return Prefab( "common/inventory/bedroll_furry", fn, assets) 
