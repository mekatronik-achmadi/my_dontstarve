require "prefabutil"

function MakeMechType(data)

	local assets =
	{
		Asset("ANIM", "anim/wall.zip"),
		Asset("ANIM", "anim/wall_"..data.name..".zip"),
		Asset("ATLAS", "images/inventoryimages/normal/mech_"..data.name.."_item.xml"),
	}
	
	local function onhammered(inst, worker)
		if data.maxloots and data.loot then
			local num_loots = math.max(1, math.floor(data.maxloots*inst.components.health:GetPercent()))
			for k = 1, num_loots do
				inst.components.lootdropper:SpawnLootPrefab(data.loot)
			end
		end
		
		SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		if data.destroysound then
			inst.SoundEmitter:PlaySound(data.destroysound)		
		end
		local modname = KnownModIndex:GetModActualName("Wall Gates")
		local loot_ver = GetModConfigData("Wall Gates Recipe", modname)
			if loot_ver == "gears" then
				SpawnPrefab("gears").Transform:SetPosition(inst.Transform:GetWorldPosition())
				SpawnPrefab("goldnugget").Transform:SetPosition(inst.Transform:GetWorldPosition())
			elseif loot_ver == "transistor" then
				if IsDLCEnabled(REIGN_OF_GIANTS) then
					SpawnPrefab("goldnugget").Transform:SetPosition(inst.Transform:GetWorldPosition())
					SpawnPrefab("transistor").Transform:SetPosition(inst.Transform:GetWorldPosition())
				else
					SpawnPrefab("goldnugget").Transform:SetPosition(inst.Transform:GetWorldPosition())
					SpawnPrefab("goldnugget").Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
			elseif loot_ver == "gold" then
				SpawnPrefab("goldnugget").Transform:SetPosition(inst.Transform:GetWorldPosition())
				SpawnPrefab("goldnugget").Transform:SetPosition(inst.Transform:GetWorldPosition())
			end
		inst:Remove()
	end
	
	local function test_wall(inst, pt)
		local tiletype = GetGroundTypeAtPosition(pt)
		local ground_OK = tiletype ~= GROUND.IMPASSABLE 
		
		if ground_OK then
			local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 2, nil, {"NOBLOCK", "player", "FX", "INLIMBO", "DECOR"}) -- or we could include a flag to the search?
			for k, v in pairs(ents) do
				if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
					local dsq = distsq( Vector3(v.Transform:GetWorldPosition()), pt)
					if v:HasTag("wall") then
						if dsq < .1 then return false end
					else
						if  dsq< 1 then return false end
					end
				end
			end
			return true
		end
		return false	
	end
	
	local function makeobstacle(inst)
		inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)	
	    inst.Physics:ClearCollisionMask()
		inst.Physics:SetMass(0)
		inst.Physics:CollidesWith(COLLISION.ITEMS)
		inst.Physics:CollidesWith(COLLISION.CHARACTERS)
		inst.Physics:SetActive(true)
	    local ground = GetWorld()
	    if ground then
	    	local pt = Point(inst.Transform:GetWorldPosition())
	    	ground.Pathfinder:AddWall(pt.x, pt.y, pt.z)
	    end
	end
	
	local function clearobstacle(inst)
	    inst:DoTaskInTime(2*FRAMES, function() inst.Physics:SetActive(false) end)
	    local ground = GetWorld()
	    if ground then
	    	local pt = Point(inst.Transform:GetWorldPosition())
	    	ground.Pathfinder:RemoveWall(pt.x, pt.y, pt.z)
	    end
	end
	
	local function resolveanimtoplay(percent)
		local anim_to_play = nil
		if percent <= 0 then
			anim_to_play = "0"
		elseif percent <= .4 then
			anim_to_play = "1_4"
		elseif percent <= .5 then
			anim_to_play = "1_2"
		elseif percent < 1 then
			anim_to_play = "3_4"
		else
			anim_to_play = "1"
		end
		return anim_to_play
	end

	local function onhealthchange(inst, old_percent, new_percent)
		if old_percent <= 0 and new_percent > 0 then makeobstacle(inst) end
		if old_percent > 0 and new_percent <= 0 then clearobstacle(inst) end
		local anim_to_play = resolveanimtoplay(new_percent)
		if new_percent > 0 and inst.components.wallgates:IsOpen() then
			inst.AnimState:PlayAnimation("0")	
		elseif new_percent > 0 and not inst.components.wallgates:IsOpen() then
			inst.AnimState:PlayAnimation(anim_to_play.."_hit")		
			inst.AnimState:PushAnimation(anim_to_play, false)		
		else
			inst.AnimState:PlayAnimation(anim_to_play)		
		end
	end
	
	local function closewallremote(inst)	
	   local var = inst.components.health:GetPercent()
	   if var <= 0 then
	   inst.SoundEmitter:PlaySound(data.destroysound)
	   inst.components.wallgates.isopen = true
	   inst.AnimState:PushAnimation("0")
	   elseif var <= .4 then
	   inst.components.wallgates.isopen = false
	   inst.AnimState:PlayAnimation("1_4")
	   inst.SoundEmitter:PlaySound(data.buildsound)
	   makeobstacle(inst)
	   elseif var <= .5 then
	   inst.components.wallgates.isopen = false
	   inst.AnimState:PlayAnimation("1_2")
	   inst.SoundEmitter:PlaySound(data.buildsound)
	   makeobstacle(inst)
	   elseif var <= .9 then
	   inst.components.wallgates.isopen = false
	   inst.AnimState:PlayAnimation("3_4")
	   inst.SoundEmitter:PlaySound(data.buildsound)
	   makeobstacle(inst)
	   else
	   inst.AnimState:PlayAnimation("1")
	   inst.SoundEmitter:PlaySound(data.buildsound)
	   inst.components.wallgates.isopen = false
	   makeobstacle(inst)
	   end
	end
	
	local function closewall(inst)
		local x,y,z = inst.Transform:GetWorldPosition()
		local nearbywallgates = TheSim:FindEntities(x,y,z, 2, {"wallgate"} )
		for i = 2, #nearbywallgates do
			if nearbywallgates[i].components.wallgates.isopen == true then
			closewallremote(nearbywallgates[i])
			end
		end

	   local var = inst.components.health:GetPercent()
	   if var <= 0 then
	   inst.SoundEmitter:PlaySound(data.destroysound)
	   inst.components.wallgates.isopen = true
	   inst.AnimState:PushAnimation("0")
	   elseif var <= .4 then
	   inst.components.wallgates.isopen = false
	   inst.AnimState:PlayAnimation("1_4")
	   inst.SoundEmitter:PlaySound(data.buildsound)
	   makeobstacle(inst)
	   elseif var <= .5 then
	   inst.components.wallgates.isopen = false
	   inst.AnimState:PlayAnimation("1_2")
	   inst.SoundEmitter:PlaySound(data.buildsound)
	   makeobstacle(inst)
	   elseif var <= .9 then
	   inst.components.wallgates.isopen = false
	   inst.AnimState:PlayAnimation("3_4")
	   inst.SoundEmitter:PlaySound(data.buildsound)
	   makeobstacle(inst)
	   else
	   inst.AnimState:PlayAnimation("1")
	   inst.SoundEmitter:PlaySound(data.buildsound)
	   inst.components.wallgates.isopen = false
	   makeobstacle(inst)
	   end
	end
	
	local function openwallremote(inst)
	    inst.components.wallgates.isopen = true
	    inst.SoundEmitter:PlaySound(data.destroysound)
	    inst.AnimState:PlayAnimation("0")
	    clearobstacle(inst)
	end
	
	local function openwall(inst)
		local x,y,z = inst.Transform:GetWorldPosition()
		local nearbywallgates = TheSim:FindEntities(x,y,z, 2, {"wallgate"})
		for i = 2, #nearbywallgates do
			if nearbywallgates[i].components.wallgates.isopen == false then
				openwallremote(nearbywallgates[i])
			end
		end
		
	    inst.components.wallgates.isopen = true
	    inst.SoundEmitter:PlaySound(data.destroysound)		
	    inst.AnimState:PlayAnimation("0")
	    clearobstacle(inst)
	end
	
	local function ondeploywall(inst, pt, deployer)
		local mech = SpawnPrefab("mech_"..data.name) 
		if mech then 
			pt = Vector3(math.floor(pt.x)+.5, 0, math.floor(pt.z)+.5)
			mech.Physics:SetCollides(false)
			mech.Physics:Teleport(pt.x, pt.y, pt.z) 
			mech.Physics:SetCollides(true)
			inst.components.stackable:Get():Remove()

		    local ground = GetWorld()
		    if ground then
				ground.Pathfinder:AddWall(pt.x, pt.y, pt.z)
                closewall(mech)
		    end
		end 		
	end

	local function onhit(inst)
		if data.destroysound then
			inst.SoundEmitter:PlaySound(data.destroysound)		
		end

		local healthpercent = inst.components.health:GetPercent()
		local anim_to_play = resolveanimtoplay(healthpercent)
		if healthpercent > 0 and inst.components.wallgates:IsOpen() then
		inst.AnimState:PlayAnimation("0")
		elseif healthpercent > 0 then
			inst.AnimState:PlayAnimation(anim_to_play.."_hit")		
			inst.AnimState:PushAnimation(anim_to_play, false)	
		end	

	end
	
	local function onrepaired(inst)
		if data.buildsound then
			inst.SoundEmitter:PlaySound(data.buildsound)		
		end
		closewall(inst)
	end
	    
	local function onload(inst, data)
		if inst.components.health:GetPercent() <= 0 then
			clearobstacle(inst)
		end	
	end

	local function onremoveentity(inst)
		clearobstacle(inst)
	end
	
	local function OnExtinguish(inst)
		if not inst:HasTag("tree") and not inst:HasTag("structure") then
			inst.persists = true
		end
		if inst.components.inventoryitem then
			inst.components.inventoryitem.atlasname = "images/inventoryimages/mech_"..data.name.."_item.xml"
		end
	end
	
	local function fn()
		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst:AddTag("wall")
		inst:AddTag("wallgate")
		MakeObstaclePhysics(inst, .5)    
		inst.entity:SetCanSleep(false)
		anim:SetBank("wall")
		anim:SetBuild("wall_"..data.name)
	    anim:PlayAnimation("1_2", false)
	    
		inst:AddComponent("inspectable")
		inst:AddComponent("lootdropper")
		
		for k,v in ipairs(data.tags) do
		    inst:AddTag(v)
		end
				
		inst:AddComponent("repairable")
        if data.name == "ruins" then
		    inst.components.repairable.repairmaterial = "thulecite"
        else
		    inst.components.repairable.repairmaterial = data.name
        end
		inst.components.repairable.onrepaired = onrepaired
		
		inst:AddComponent("combat")
		inst.components.combat.onhitfn = onhit
		
		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(data.maxhealth)
		inst.components.health.currenthealth = data.maxhealth / 2
		inst.components.health.ondelta = onhealthchange
		inst.components.health.nofadeout = true
		inst.components.health.canheal = false
		inst:AddTag("noauradamage")
		
        inst:AddTag("noauradamage")
		inst:AddComponent("wallgates")
		inst.components.wallgates.openwallfn = openwall
		inst.components.wallgates.closewallfn = closewall
        
		inst.components.wallgates.caninteractfn = function() if data.flammable then return not inst.components.health:IsDead() and not inst.components.burnable:IsBurning() else return not inst.components.health:IsDead() end end
		if data.flammable then
			MakeLargeBurnable(inst)
			MakeLargePropagator(inst)
			inst.components.burnable.flammability = .5
			
			if data.name == "wood" then
				inst.components.propagator.flashpoint = 30+math.random()*10			
			end
		else
			inst.components.health.fire_damage_scale = 0
		end

		if data.buildsound then
			inst.SoundEmitter:PlaySound(data.buildsound)		
		end
		
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(3)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit) 
						
	    inst.OnLoad = onload
	    inst.OnRemoveEntity = onremoveentity
		
		MakeSnowCovered(inst)
		
		return inst
	end
	
	local function itemfn()

		local inst = CreateEntity()
		inst:AddTag("wallbuilder")
		inst:AddTag("wallgateitem")
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
	    
		inst.AnimState:SetBank("wall")
		inst.AnimState:SetBuild("wall_"..data.name)
		inst.AnimState:PlayAnimation("idle")

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/normal/mech_"..data.name.."_item.xml"
			    		
		if data.flammable then
			MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
			MakeSmallPropagator(inst)
			inst.components.burnable:SetOnExtinguishFn(OnExtinguish)
			
			inst:AddComponent("fuel")
			inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
		end
		
		inst:AddComponent("deployable")
		inst.components.deployable.ondeploy = ondeploywall
		inst.components.deployable.test = test_wall
		inst.components.deployable.min_spacing = 0
		inst.components.deployable.placer = "mech_"..data.name.."_placer"
		
		return inst
	end

	return Prefab( "common/mech_"..data.name, fn, assets),
		   Prefab( "common/mech_"..data.name.."_item", itemfn, assets, {"wall_"..data.name, "mech_"..data.name.."_placer"}),
		   MakePlacer("common/mech_"..data.name.."_placer", "wall", "wall_"..data.name, "1_2", false, false, true) 
	end

local mechprefabs = {}

local mechdata = {
			{name = "stone", tags={"stone"}, loot = "rocks", maxloots = 2, maxhealth=TUNING.STONEWALL_HEALTH, buildsound="dontstarve/common/place_structure_stone", destroysound="dontstarve/common/destroy_stone"},
			{name = "wood", tags={"wood"}, loot = "log", maxloots = 2, maxhealth=TUNING.WOODWALL_HEALTH, flammable = false, buildsound="dontstarve/common/place_structure_wood", destroysound="dontstarve/common/destroy_wood"},
			{name = "hay", tags={"grass"}, loot = "cutgrass", maxloots = 2, maxhealth=TUNING.HAYWALL_HEALTH, flammable = true, buildsound="dontstarve/common/place_structure_straw", destroysound="dontstarve/common/destroy_straw"},
			{name = "ruins", tags={"stone", "ruins"}, loot = "thulecite_pieces", maxloots = 2, maxhealth=TUNING.RUINSWALL_HEALTH, buildsound="dontstarve/common/place_structure_stone", destroysound="dontstarve/common/destroy_stone"},
        }

for k,v in pairs(mechdata) do
	local mech, item, placer = MakeMechType(v)
	table.insert(mechprefabs, mech)
	table.insert(mechprefabs, item)
	table.insert(mechprefabs, placer)
end

return unpack(mechprefabs) 
