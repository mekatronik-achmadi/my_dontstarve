local assets=
{ 	
	Asset("ATLAS", "images/inventoryimages/zbolt.xml"),
    Asset("IMAGE", "images/inventoryimages/zbolt.tex"),
	Asset("ATLAS", "images/inventoryimages/poisonzbolt.xml"),
    Asset("IMAGE", "images/inventoryimages/poisonzbolt.tex"),
	Asset("ATLAS", "images/inventoryimages/explosivezbolt.xml"),
    Asset("IMAGE", "images/inventoryimages/explosivezbolt.tex"),
}
prefabs = {
    "explode_small",
	"poisoncloud",
	"stuneffect",
}

local function PoisonWearOff(target)
	 if target.components.combat then
		target.components.combat.damagemultiplier = nil
		
		if	target.components.locomotor then
			target.components.locomotor.walkspeed = target.components.locomotor.walkspeed/0.5
			target.components.locomotor.runspeed = target.components.locomotor.runspeed/0.5
		end
		
		if target:HasTag("poisoned") then
			target:RemoveTag("poisoned")
		end
		
		if target.poisoncloud ~= nil then
			target.poisoncloud:SetFollowTarget(nil)
			target.poisoncloud = nil
		end
		
		if target.poisonwearofftask then
			target.poisonwearofftask:Cancel()
			target.poisonwearofftask = nil
		end
	 end
end

local function onhitzbolt_poison(inst, attacker, target)
    if target.components.combat then
		if not target:HasTag("poisoned") then
			target:AddTag("poisoned")
			
			if target.poisoncloud == nil then
				local symzboltofollow = nil
				local symzboltofollow_x = 0
				local symzboltofollow_y = 0
				local symzboltofollow_z = 0.02
			
				symzboltofollow = target.components.combat.hiteffectsymbol			
			
				if (symzboltofollow == "marker" or symzboltofollow == nil) and target.components.burnable then
					for k, v in pairs(target.components.burnable.fxdata) do
						if v.follow ~= nil then
							symzboltofollow = v.follow
							symzboltofollow_x = v.x
							symzboltofollow_y = v.y - 30
							symzboltofollow_z = v.z
						end
					end
				end
			
				if symzboltofollow ~= nil and symzboltofollow ~= "marker" then
					target.poisoncloud = SpawnPrefab("poisoncloud")
					target.poisoncloud.Transform:SetPosition(target:GetPosition():Get())
					target.poisoncloud:SetFollowTarget(target, symzboltofollow, symzboltofollow_x, symzboltofollow_y, symzboltofollow_z)
					target:ListenForEvent("death", function()
													if target.poisoncloud ~= nil then
														target.poisoncloud:SetFollowTarget(nil)
														target.poisoncloud = nil
													end
												end
										)
				end
			end
		end
		
		target.components.combat.damagemultiplier = 0.6
		
		if target.components.health and not target.components.health:IsDead() then
			local timeouttick = 0
			target.loosehealthovertime = target:DoPeriodicTask(1, function(target) 
																	target.components.health:DoDelta(-TUNING.BOWDMG*TUNING.CROSSBOWDMGMOD*TUNING.POISONBOLTDMGMOD/TUNING.POISONBOLTDURATION, true)
																	timeouttick = timeouttick+1
																	if timeouttick == TUNING.POISONBOLTDURATION then
																		target.loosehealthovertime:Cancel()
																		target.loosehealthovertime = nil
																	end
																end
															)															
		end
		
		if	target.components.locomotor then
			target.components.locomotor.walkspeed = target.components.locomotor.walkspeed*0.5
			target.components.locomotor.runspeed = target.components.locomotor.runspeed*0.5
		end
		
		if target.poisonwearofftask == nil then
			target.poisonwearofftask = target:DoPeriodicTask(10, PoisonWearOff)
		else
			target.poisonwearofftask:Cancel()
			target.poisonwearofftask = nil
			target.poisonwearofftask = target:DoPeriodicTask(10, PoisonWearOff)
		end
	end
end

local function onhitzbolt_explosive(inst, attacker, target)
	local targposx, targposy, targposz
	if target ~= inst then
		targposx, targposy, targposz = target.Transform:GetWorldPosition()
	else
		targposx, targposy, targposz = inst.components.zupalexsrangedweapons:GetTargetPosition()
	end
	
	local ents = TheSim:FindEntities(targposx, targposy, targposz, TUNING.EXPLOSIVEBOLTRAD)
    for i, ent in ipairs(ents) do
		if ent ~= inst and attacker.components.combat:IsValidTarget(ent)
			then
				ent.components.combat:GetAttacked(attacker, TUNING.EXPLOSIVEBOLTDMG)
		elseif ent.components.workable ~= nil and ent.components.workable.workleft > 0 then
				ent.components.workable:WorkedBy(inst, TUNING.EXPLOSIVEBOLTDMG)
		elseif ent == attacker then
				ent.components.combat:GetAttacked(attacker, TUNING.EXPLOSIVEBOLTDMG*0.2)
		end
		
		ent:DoTaskInTime(0.5, function()
									if ent:IsValid() and not ent:IsInLimbo() then
										if ent.components.burnable and
										not ent.components.burnable:IsBurning() then
											ent.components.burnable:Ignite(true)
										end
									end
								end
						)
    end

    SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")
	
	local rdmradius = TUNING.EXPLOSIVEBOLTRAD/4
	
	target:DoTaskInTime(0.15, function() SpawnPrefab("explode_small").Transform:SetPosition(targposx+math.random(-rdmradius, rdmradius), targposy+math.random(-rdmradius, rdmradius), targposz+math.random(-rdmradius, rdmradius)) end)
	target:DoTaskInTime(0.15, function() target.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo") end)
	target:DoTaskInTime(0.25, function() SpawnPrefab("explode_small").Transform:SetPosition(targposx+math.random(-rdmradius, rdmradius), targposy+math.random(-rdmradius, rdmradius), targposz+math.random(-rdmradius, rdmradius)) end)
	target:DoTaskInTime(0.25, function() target.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo") end)
	target:DoTaskInTime(0.4, function() SpawnPrefab("explode_small").Transform:SetPosition(targposx+math.random(-rdmradius, rdmradius), targposy+math.random(-rdmradius, rdmradius), targposz+math.random(-rdmradius, rdmradius)) end)
	target:DoTaskInTime(0.4, function() target.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo") end)
	
end


local function onmiss_explosivezbolt(inst, attacker, target)
	local shooter = inst.components.zupalexsrangedweapons.owner
	onhitzbolt_explosive(inst, shooter, target)
	inst:Remove()
end

------------------------------------------------------------ zboltS ----------------------------------------------------------------

local function commonzboltfn(zboltanim, tags) 
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
     
    anim:SetBank("bolt")
    anim:SetBuild("zcrossbow")
    anim:PlayAnimation(zboltanim)
 
	inst:AddTag("projectile") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("zbolt")

	if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
    end

 --The following section is suitable for a DST compatible prefab.
    
----------------------------------------------------------------
	
	inst:AddComponent("zupalexsrangedweapons")
		
	inst:AddComponent("projectile")
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	
	inst:AddComponent("stackable")
	
	 
    return inst
end

local function shootzbolt(inst)
    inst.AnimState:PlayAnimation("bolt_flight",true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end
	
local function regularzboltfn()
	local inst = commonzboltfn("bolt_idle", { "piercing", "sharp", "recoverable" })
	
	inst.Physics:SetCollisionCallback(OnCollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootzbolt)
	inst.components.projectile:SetOnHitFn(OnHitCommon)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", OnThrownRegular)
	
	inst.components.inventoryitem.imagename = "zbolt"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/zbolt.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function shootpoisonzbolt(inst)
    inst.AnimState:PlayAnimation("poisonbolt_flight",true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function poisonzboltfn()
	local inst = commonzboltfn("poisonbolt_idle", { "poison" })
	
	inst.Physics:SetCollisionCallback(OnCollide)
	
	inst.components.zupalexsrangedweapons:SetSpecificOnHitfn(onhitzbolt_poison)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootpoisonzbolt)
	inst.components.projectile:SetOnHitFn(OnHitCommon)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", OnThrownRegular)
	
	inst.components.inventoryitem.imagename = "poisonzbolt"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/poisonzbolt.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function shootexplosivezbolt(inst)
    inst.AnimState:PlayAnimation("explosivebolt_flight",true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function explosivezboltfn()
	local inst = commonzboltfn("explosivebolt_idle", { "explosive" })
	
	inst.entity:AddSoundEmitter()

	inst.Physics:SetCollisionCallback(OnCollide)
	
	inst.components.zupalexsrangedweapons:SetSpecificOnHitfn(onhitzbolt_explosive)
		
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootexplosivezbolt)
    inst.components.projectile:SetOnHitFn(OnHitCommon)
    inst.components.projectile:SetOnMissFn(onmiss_explosivezbolt)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
    inst:ListenForEvent("onthrown", OnThrownRegular)
	
	inst.components.inventoryitem.imagename = "explosivezbolt"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/explosivezbolt.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

return  Prefab("common/inventory/zbolt", regularzboltfn, assets, prefabs),
		Prefab("common/inventory/poisonzbolt", poisonzboltfn, assets, prefabs),
		Prefab("common/inventory/explosivezbolt", explosivezboltfn, assets, prefabs)