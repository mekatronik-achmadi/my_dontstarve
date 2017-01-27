local assets=
{	
	Asset("ATLAS", "images/inventoryimages/zarrow.xml"),
    Asset("IMAGE", "images/inventoryimages/zarrow.tex"),
	Asset("ATLAS", "images/inventoryimages/goldzarrow.xml"),
    Asset("IMAGE", "images/inventoryimages/goldzarrow.tex"),
	Asset("ATLAS", "images/inventoryimages/moonstonezarrow.xml"),
    Asset("IMAGE", "images/inventoryimages/moonstonezarrow.tex"),
	Asset("ATLAS", "images/inventoryimages/firezarrow.xml"),
    Asset("IMAGE", "images/inventoryimages/firezarrow.tex"),
	Asset("ATLAS", "images/inventoryimages/icezarrow.xml"),
    Asset("IMAGE", "images/inventoryimages/icezarrow.tex"),
	Asset("ATLAS", "images/inventoryimages/thunderzarrow.xml"),
    Asset("IMAGE", "images/inventoryimages/thunderzarrow.tex"),
	Asset("ATLAS", "images/inventoryimages/dischargedthunderzarrow.xml"),
    Asset("IMAGE", "images/inventoryimages/dischargedthunderzarrow.tex"),
}
prefabs = {

}

----------------------------------------------------zarrowS----------------------------------------------------------

local function commonzarrowfn(zarrowanim, tags) 
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
 
	inst:AddTag("projectile") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("zarrow")

	if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
    end
	
	anim:SetBank("arrow")
    anim:SetBuild("zbow")
    anim:PlayAnimation(zarrowanim, true)
	
 --The following section is suitable for a DST compatible prefab.
    
----------------------------------------------------------------
	
	inst:AddComponent("zupalexsrangedweapons")
	
	inst:AddComponent("projectile")
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(inst.components.zupalexsrangedweapons.OnPutInInventory)
	
	inst:AddComponent("stackable")
	
	 
    return inst
end

local function shootzarrow(inst)
    inst.AnimState:PlayAnimation("arrow_flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function shootgoldzarrow(inst)
    inst.AnimState:PlayAnimation("goldarrow_flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function shootmoonstonezarrow(inst)
    inst.AnimState:PlayAnimation("moonstonearrow_flight", true)
	inst.Light:Enable(true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function onhitzarrow_fire(inst, attacker, target)
	target.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_impact_fire")
	
--	print("I am shooting a Fire zarrow")
	
	if target.components.burnable then
        target.components.burnable:Ignite(nil, attacker)
    end
    if target.components.freezable then
        target.components.freezable:Unfreeze()
    end
    if target.components.health then
        target.components.health:DoFireDamage((TUNING.BOWDMG*(TUNING.FIREARROWDMGMOD/2.0)), attacker)
    end
end

local function onhitzarrow_ice(inst, attacker, target)
--	print("I am shooting an Ice zarrow")
   
    if target.components.burnable then
        if target.components.burnable:IsBurning() then
            target.components.burnable:Extinguish()
        elseif target.components.burnable:IsSmoldering() then
            target.components.burnable:SmotherSmolder()
        end
    end

    if target.components.freezable then
        target.components.freezable:AddColdness(1)
        target.components.freezable:SpawnShatterFX()
    end
end

local function onhitzarrow_thunder(inst, attacker, target)
	local lightningstrike = SpawnPrefab("lightning")
	lightningstrike.Transform:SetPosition(target.Transform:GetWorldPosition())
	
	if not target:HasTag("stunned") then
		target:AddTag("stunned")
		
		if target.stuneffect == nil and target.components.health and not target.components.health:IsDead() then
			local symzboltofollow = nil
			local symzboltofollow_x = 0
			local symzboltofollow_y = -100
			local symzboltofollow_z = 0.02
		
			symzboltofollow = target.components.combat.hiteffectsymbol
		
			if (symzboltofollow == "marker" or symzboltofollow == nil) and target.components.burnable then
				for k, v in pairs(target.components.burnable.fxdata) do
					if v.follow ~= nil then
						symzboltofollow = v.follow
						symzboltofollow_x = v.x
						symzboltofollow_y = v.y - 190
						symzboltofollow_z = v.z
					end
				end
			end
		
--			print("symzboltofollow = ", symzboltofollow)
		
			if symzboltofollow ~= nil and symzboltofollow ~= "marker" then 
				target.stuneffect = SpawnPrefab("stuneffect")
				target.stuneffect.Transform:SetPosition(target:GetPosition():Get())
				target.stuneffect:SetFollowTarget(target, symzboltofollow, symzboltofollow_x, symzboltofollow_y, symzboltofollow_z)
				target:ListenForEvent("death", function()
											if target.stuneffect ~= nil then
												target.stuneffect:SetFollowTarget(nil)
												target.stuneffect = nil
											end
										end
							)
			end
		end
		
		if target.components.locomotor then
			target.preventmoving = target:DoPeriodicTask(0, function(target) target.components.locomotor:Stop() end)
			target.electricstun = target:DoPeriodicTask(4, function(target) 
																	target:RemoveTag("stunned")
																	
																	if target.stuneffect  ~= nil then
																		target.stuneffect:SetFollowTarget(nil)
																		target.stuneffect = nil
																	end
																	
																	if target.electricstun then
																		target.electricstun:Cancel()
																		target.electricstun = nil
																	end
																
																	if target.preventmoving then
																		target.preventmoving:Cancel()
																		target.preventmoving = nil
																	end
																end
															)															
		end
	end
	
	if GetSeasonManager():IsRaining() then
		if math.random() <= 0.5 then
			if attacker.components.playerlightningtarget then
				attacker.components.playerlightningtarget:DoStrike()
				GetSeasonManager():DoLightningStrike(Vector3(GetPlayer().Transform:GetWorldPosition()))
			end
		end
	end
end

local function regularzarrowfn()
	local inst = commonzarrowfn("arrow_idle", { "piercing", "sharp", "recoverable" })
	
	inst.Physics:SetCollisionCallback(OnCollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootzarrow)
	inst.components.projectile:SetOnHitFn(OnHitCommon)
	inst.components.projectile:SetOnMissFn(OnMissArrowRegular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", OnThrownRegular)
	
	inst.components.inventoryitem.imagename = "zarrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/zarrow.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function goldzarrowfn()
	local inst = commonzarrowfn("goldarrow_idle", { "piercing", "sharp", "golden", "recoverable" })
	
	inst.Physics:SetCollisionCallback(OnCollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootgoldzarrow)
	inst.components.projectile:SetOnHitFn(OnHitCommon)
	inst.components.projectile:SetOnMissFn(OnMissArrowRegular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", OnThrownRegular)
	
	inst.components.inventoryitem.imagename = "goldzarrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/goldzarrow.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function ondroppedMSzarrow(inst)
	inst.Light:Enable(true)
end

local function moonstonezarrowfn()
	local inst = commonzarrowfn("moonstonearrow_idle", { "piercing", "sharp", "moonstone", "recoverable" })
	
	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.6)
	inst.Light:SetRadius(0.5)
	inst.Light:SetFalloff(0.75)
	inst.Light:Enable(true)
	inst.Light:SetColour(0/255, 0/255, 255/255)
	
	inst.Physics:SetCollisionCallback(OnCollide)
	
    inst.components.inventoryitem:SetOnDroppedFn(ondroppedMSzarrow)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootmoonstonezarrow)
	inst.components.projectile:SetOnHitFn(OnHitCommon)
	inst.components.projectile:SetOnMissFn(OnMissArrowRegular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", OnThrownRegular)
	
	inst.components.inventoryitem.imagename = "moonstonezarrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/moonstonezarrow.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function onmisszarrow_special(inst, attacker, target)
	inst:Remove()
end

local function shootzarrow_fire(inst)
    inst.AnimState:PlayAnimation("firearrow_flight", true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function shootzarrow_ice(inst)
    inst.AnimState:PlayAnimation("icearrow_flight", true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function firezarrowfn()
	local inst = commonzarrowfn("firearrow_idle", { "burning", "recoverable" })
	
	inst.Physics:SetCollisionCallback(OnCollide)
	
	inst.components.zupalexsrangedweapons:SetSpecificOnHitfn(onhitzarrow_fire)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootzarrow_fire)
	inst.components.projectile:SetOnHitFn(OnHitCommon)
	inst.components.projectile:SetOnMissFn(OnMissArrowRegular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", OnThrownRegular)
	
	inst.components.inventoryitem.imagename = "firezarrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/firezarrow.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function icezarrowfn()
	local inst = commonzarrowfn("icearrow_idle", { "freezing", "recoverable" })
	
	inst.Physics:SetCollisionCallback(OnCollide)
	
	inst.components.zupalexsrangedweapons:SetSpecificOnHitfn(onhitzarrow_ice)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootzarrow_ice)
	inst.components.projectile:SetOnHitFn(OnHitCommon)
	inst.components.projectile:SetOnMissFn(OnMissArrowRegular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", OnThrownRegular)
	
	inst.components.inventoryitem.imagename = "icezarrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/icezarrow.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function startflickering(inst)
	if inst.flickering == nil then
		inst.flickering = inst:DoPeriodicTask(0.075, function(inst)
														inst.lightstate = inst.Light:IsEnabled()
														inst.Light:Enable(not inst.lightstate)
													end
											)
	end
end

local function stopflickering(inst)
	if inst.flickering ~= nil then
		inst.flickering:Cancel()
		inst.flickering = nil
	end
end

local function shootzarrow_thunder(inst)
    inst.AnimState:PlayAnimation("thunderarrow_flight", true)
	startflickering(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function thunderzarrowfn()
	local inst = commonzarrowfn("thunderarrow_idle", { "electric", "recoverable" })
	
	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.4)
	inst.Light:SetRadius(0.3)
	inst.Light:SetFalloff(0.66)
	inst.Light:SetColour(152/255, 229/255, 243/255)
	inst.Light:Enable(false)
	
	inst.Physics:SetCollisionCallback(OnCollide)
	
	inst.components.zupalexsrangedweapons:SetSpecificOnHitfn(onhitzarrow_thunder)
	
	inst.components.inventoryitem:SetOnDroppedFn(startflickering)	
	inst.components.inventoryitem:SetOnPickupFn(stopflickering)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootzarrow_thunder)
	inst.components.projectile:SetOnHitFn(OnHitCommon)
	inst.components.projectile:SetOnMissFn(OnMissArrowRegular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", OnThrownRegular)
	
	inst.components.inventoryitem.imagename = "thunderzarrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/thunderzarrow.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	inst.components.zupalexsrangedweapons.stimuli = "electric"
	
	return inst
end

local function shootzarrow_thunder_discharged(inst)
    inst.AnimState:PlayAnimation("thunderarrow_flight_discharged", true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function dischargedthunderzarrowfn()
	local inst = commonzarrowfn("thunderarrow_idle_discharged", { "electric", "discharged", "recoverable" })
	
	inst.Physics:SetCollisionCallback(OnCollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootzarrow_thunder_discharged)
	inst.components.projectile:SetOnHitFn(OnHitCommon)
	inst.components.projectile:SetOnMissFn(OnMissArrowRegular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", OnThrownRegular)
	
	inst.components.inventoryitem.imagename = "dischargedthunderzarrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dischargedthunderzarrow.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

--------------------------------------------------------------------------MAGIC PROJECTILES-------------------------------------------------------------------------

local function commonmagicprojfn(zarrowanim, tags) 
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
 
    MakeInventoryPhysics(inst)
 
 	anim:SetBank("magicprojectile")
    anim:SetBuild("zbow")
    anim:PlayAnimation(zarrowanim)
 
	inst:AddTag("projectile") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("zarrow")
	inst:AddTag("magic")

	if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
    end
	
----------------------------------------------------------------
	
	inst:AddComponent("projectile")	
	
	inst:AddComponent("zupalexsrangedweapons")
	 
    return inst
end

local function shootshadowzarrow(inst)
    inst.AnimState:PlayAnimation("shadowarrow_flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function shadowzarrowfn()
	local inst = commonmagicprojfn("shadowarrow_flight", { "shadow" })
	
	RemovePhysicsColliders(inst)
	
	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.8)
	inst.Light:SetRadius(3)
	inst.Light:SetFalloff(0.33)
	inst.Light:Enable(true)
	inst.Light:SetColour(119/255, 45/255, 166/255)
	
	inst:AddTag("energy")
	inst:AddTag("nocollisionoverride")
	
	inst.persists = false
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootshadowzarrow)
	inst.components.projectile:SetOnHitFn(OnHitCommon)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", OnThrownRegular)
	
	return inst
end

local function shootlightzarrow(inst)
    inst.AnimState:PlayAnimation("lightarrow_flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function lightzarrowfn()
	local inst = commonmagicprojfn("lightarrow_flight", { "light" })
	
	RemovePhysicsColliders(inst)
	
	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.8)
	inst.Light:SetRadius(3)
	inst.Light:SetFalloff(0.33)
	inst.Light:Enable(true)
	inst.Light:SetColour(255/255, 253/255, 54/255)
	
	inst:AddTag("energy")
	inst:AddTag("nocollisionoverride")
	
	inst.persists = false
	
	inst.components.projectile:SetSpeed(30)
	inst.components.projectile:SetOnThrownFn(shootlightzarrow)
	inst.components.projectile:SetOnHitFn(OnHitCommon)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", OnThrownRegular)
	
	return inst
end

local function shoothealingzarrow(inst)
    inst.AnimState:PlayAnimation("healingarrow_flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function onhitzarrow_healing(inst, attacker, target)
	if target ~= nil then
		if target.components.health ~= nil and not target.components.health:IsDead() then
		target.components.health:DoDelta(25)
		end
		
		if target.components.sanity ~= nil then
			target.components.sanity:DoDelta(-5)
		end
	end
end

local function healingzarrowfn()
	local inst = commonmagicprojfn("healingarrow_flight", { "healing" })
	
	RemovePhysicsColliders(inst)
	
	inst.components.zupalexsrangedweapons:SetSpecificOnHitfn(onhitzarrow_healing)
	
	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.8)
	inst.Light:SetRadius(3)
	inst.Light:SetFalloff(0.33)
	inst.Light:Enable(true)
	inst.Light:SetColour(247/255, 116/255, 255/255)
	
	inst:AddTag("energy")
	inst:AddTag("nocollisionoverride")
	
	inst.persists = false
	
	inst.components.projectile:SetSpeed(20)
	inst.components.projectile:SetOnThrownFn(shoothealingzarrow)
	inst.components.projectile:SetOnHitFn(OnHitCommon)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", OnThrownRegular)
	
	return inst
end

return  Prefab("common/inventory/zarrow", regularzarrowfn, assets, prefabs),
		Prefab("common/inventory/goldzarrow", goldzarrowfn, assets, prefabs),
		Prefab("common/inventory/moonstonezarrow", moonstonezarrowfn, assets, prefabs),
		Prefab("common/inventory/firezarrow", firezarrowfn, assets, prefabs),
		Prefab("common/inventory/icezarrow", icezarrowfn, assets, prefabs),
		Prefab("common/inventory/thunderzarrow", thunderzarrowfn, assets, prefabs),
		Prefab("common/inventory/dischargedthunderzarrow", dischargedthunderzarrowfn, assets, prefabs),
		Prefab("common/inventory/shadowzarrow", shadowzarrowfn, assets),
		Prefab("common/inventory/lightzarrow", lightzarrowfn, assets),
		Prefab("common/inventory/healingzarrow", healingzarrowfn, assets)