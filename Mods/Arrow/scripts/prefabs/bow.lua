local assets=
{
    Asset("ANIM", "anim/bow.zip"),
    Asset("ANIM", "anim/swap_bow.zip"),
	
    Asset("ATLAS", "images/inventoryimages/bow.xml"),
    Asset("IMAGE", "images/inventoryimages/bow.tex"),
	
	Asset("ATLAS", "images/inventoryimages/arrow.xml"),
    Asset("IMAGE", "images/inventoryimages/arrow.tex"),
	Asset("ATLAS", "images/inventoryimages/goldarrow.xml"),
    Asset("IMAGE", "images/inventoryimages/goldarrow.tex"),
	Asset("ATLAS", "images/inventoryimages/moonstonearrow.xml"),
    Asset("IMAGE", "images/inventoryimages/moonstonearrow.tex"),
	Asset("ATLAS", "images/inventoryimages/firearrow.xml"),
    Asset("IMAGE", "images/inventoryimages/firearrow.tex"),
	Asset("ATLAS", "images/inventoryimages/icearrow.xml"),
    Asset("IMAGE", "images/inventoryimages/icearrow.tex"),
	Asset("ATLAS", "images/inventoryimages/thunderarrow.xml"),
    Asset("IMAGE", "images/inventoryimages/thunderarrow.tex"),
	Asset("ATLAS", "images/inventoryimages/dischargedthunderarrow.xml"),
    Asset("IMAGE", "images/inventoryimages/dischargedthunderarrow.tex"),
	 
--------------------------------------------------------------------	 
	 
	Asset("ANIM", "anim/crossbow.zip"),
    Asset("ANIM", "anim/swap_crossbow.zip"),
	 
    Asset("ATLAS", "images/inventoryimages/crossbow.xml"),
    Asset("IMAGE", "images/inventoryimages/crossbow.tex"),
	
	Asset("ATLAS", "images/inventoryimages/bolt.xml"),
    Asset("IMAGE", "images/inventoryimages/bolt.tex"),
	Asset("ATLAS", "images/inventoryimages/poisonbolt.xml"),
    Asset("IMAGE", "images/inventoryimages/poisonbolt.tex"),
	Asset("ATLAS", "images/inventoryimages/explosivebolt.xml"),
    Asset("IMAGE", "images/inventoryimages/explosivebolt.tex"),
	
---------------------------------------------------------------------

    Asset("ANIM", "anim/swap_magicbow.zip"),
	
    Asset("ATLAS", "images/inventoryimages/magicbow.xml"),
    Asset("IMAGE", "images/inventoryimages/magicbow.tex"),

}
prefabs = {
    "explode_small",
	"sparkles",
}

----------------------------------------------------------------------------BOWS--------------------------------------------------------------

local OriginalDoAttackButton
local OriginalDoControllerAttack, OriginalUpdateControllerAttackTarget

local function BowForceAttackOverride(self)
    local force_attack = TheInput:IsControlPressed(CONTROL_FORCE_ATTACK)
--    local target = self:GetAttackTarget(force_attack, retarget, retarget ~= nil)

	local target = nil
	local attackerpos = self.inst:GetPosition()
	
	for k,v in pairs(TheSim:FindEntities(attackerpos.x, attackerpos.y, attackerpos.z, 25)) do
		if v.components and v.components.combat and v.components.combat:CanBeAttacked(self.inst) and
		self.inst.components and self.inst.components.combat and self.inst.components.combat:CanTarget(v) and not self.inst.components.combat:IsAlly(v) and
		not (v.sg and v.sg:HasStateTag("invisible")) and
		TheSim:GetLightAtPoint(v.Transform:GetWorldPosition()) > TUNING.DARK_CUTOFF and
		not v:HasTag("wall") and not v:HasTag("player")and not v:IsInLimbo() and v.prefab ~= "butterfly" 
		then
--			print("Targets nearby : ", v)
			if v:HasTag("hostile") then
				target = v
				break
			else
				if v.prefab == "bee" then
					if target == nil then
						target = v
					end
				else 
					if target == nil or target.prefab == "bee" then
						target = v
					end
				end
			end
		end
--		print("target is currently : ", target)
	end

	local activeitem 

	if self.inst.components.combat ~= nil then
		activeitem = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)	
	elseif self.inst.components.inventory ~= nil then
		activeitem = self.inst.components.inventory:GetActiveItem() or self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	end
	
	local actiontoperform, cooldowntime
	
	if activeitem ~= nil then
		if activeitem:HasTag("bow") then
			actiontoperform = ACTIONS.BOWATTACK
			cooldowntime = 1.3
		elseif activeitem:HasTag("crossbow") then
			actiontoperform = ACTIONS.CROSSBOWATTACK
			cooldowntime = 1.5
		end
	end
	
	local incooldown = nil

	local lastattack = self.inst.components.combat.laststartattacktime or 0
	incooldown = (self.inst.components.combat ~= nil and (GetTime() - lastattack) < cooldowntime)
--	print("Last Attack -> ", lastattack)
	
	if target ~= nil and not incooldown then
		local action = BufferedAction(self.inst, target, actiontoperform)
		self.inst.components.locomotor:PushAction(action, true)
	else
		return -- already doing it!
	end
end

local function OverrideDoControllerAttack(self)
	self.time_direct_walking = 0

	local activeitem 

	if self.inst.components.combat ~= nil then
		activeitem = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	elseif self.inst.components.inventory ~= nil then
		activeitem = self.inst.components.inventory:GetActiveItem() or self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	end
	
	local actiontoperform, cooldowntime
	
	if activeitem ~= nil then
		if activeitem:HasTag("bow") then
			actiontoperform = ACTIONS.BOWATTACK
			cooldowntime = 1.3
		elseif activeitem:HasTag("crossbow") then
			if activeitem:HasTag("readytoshoot") then
				actiontoperform = ACTIONS.CROSSBOWATTACK
			else
				actiontoperform = ACTIONS.ARMCROSSBOW
				local action = BufferedAction(self.inst, nil, actiontoperform, activeitem)
				self.inst.components.locomotor:PushAction(action, false, true)
				return
			end
			cooldowntime = 1.5
		end
	end
	
	local incooldown = nil

	local lastattack = self.inst.components.combat.laststartattacktime or 0
	incooldown = (self.inst.components.combat ~= nil and (GetTime() - lastattack) < cooldowntime)

	local attack_target = self.controller_attack_target

	if attack_target and self.inst.components.combat.target ~= attack_target and not incooldown then
		local action = BufferedAction(self.inst, attack_target, actiontoperform)
		self.inst.components.locomotor:PushAction(action, true)
	elseif not attack_target and not self.inst.components.combat.target then
		local action = BufferedAction(self.inst, nil, actiontoperform)
		self.inst.components.locomotor:PushAction(action, true)
	else
		return -- already doing it!
	end
end

local must_have_attack ={"HASCOMBATCOMPONENT"}
local cant_have_attack ={"FX", "NOCLICK", "DECOR", "INLIMBO"}

function OverrideUpdateControllerAttackTarget(self, dt)
	local activeitem 

	if self.inst.components.combat ~= nil then
		activeitem = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	elseif self.inst.components.inventory ~= nil then
		activeitem = self.inst.components.inventory:GetActiveItem() or self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	end
	
	if self.controllerattacktargetage then
		self.controllerattacktargetage = self.controllerattacktargetage + dt
	end

	--if self.controller_attack_target and self.controllerattacktargetage and self.controllerattacktargetage < .3 then return end

	local heading_angle = -(self.inst.Transform:GetRotation())
	local dir = Vector3(math.cos(heading_angle*DEGREES),0, math.sin(heading_angle*DEGREES))
	
	local me_pos = Vector3(self.inst.Transform:GetWorldPosition())
	
	local min_rad = 4
	local max_range = activeitem.components.zupalexsrangedweapons.hitrange+3

	local rad = max_range
	
	local x,y,z = me_pos:Get()
	local nearby_ents = TheSim:FindEntities(x,y,z, rad, must_have_attack, cant_have_attack)

	local target = nil
	local target_score = nil
	local target_action = nil

	if self.controller_attack_target then
		table.insert(nearby_ents, self.controller_attack_target)
	end

	for k,v in pairs(nearby_ents) do
	
		local canattack = self:CanAttackWithController(v)

		if canattack then

			local px,py,pz = v.Transform:GetWorldPosition()
			local ox,oy,oz = px - me_pos.x, py - me_pos.y, pz - me_pos.z
			local dsq = ox*ox + oy*oy +oz*oz
			local dist = dsq > 0 and math.sqrt(dsq) or 0
			
			local dot = 0
			if dist > 0 then
				local nx, ny, nz = ox/dist, oy/dist, oz/dist
				dot = nx*dir.x + ny*dir.y + nz*dir.z
			end
			
			if (dist < min_rad or dot > 0) and dist < max_range then
				
				local score = (1 + dot)* (1 / math.max(min_rad*min_rad, dsq))

				if (v.components.follower and v.components.follower.leader == self.inst) or v.prefab == "chester" then
					score = score * .25
				elseif v:HasTag("monster") then
					score = score * 4
				end

				if v.components.combat.target == self.inst then
					score = score * 6
				end

				if self.controller_attack_target == v then
					score = score * 10
				end

				if not target or target_score < score then
					target = v
					target_score = score
				end
			end
		end
	end

	if not target and self.controller_target and self.controller_target:HasTag("wall") and self.controller_target.components.health and self.controller_target.components.health.currenthealth > 0 then
		target = self.controller_target
	end

	if target ~= self.controller_attack_target then
		self.controller_attack_target = target
		self.controllerattacktargetage = 0
	end
end

local function BowLCOverride(inst, target, position)
    local actions = nil
    local useitem = inst.components.inventory:GetActiveItem()
    local equipitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	local self = inst.components.playeractionpicker
  
	local activeitem = useitem or equipitem
  
	local actiontoperform
	
	if activeitem ~= nil then
		if activeitem:HasTag("bow") then
			actiontoperform = ACTIONS.BOWATTACK
		elseif activeitem:HasTag("crossbow") then
			actiontoperform = ACTIONS.CROSSBOWATTACK
		end
	end
	
    local passable = true
    if not self.ground then
        self.ground = GetWorld()
    end

    if position and self.ground and self.ground.Map then
        local tile = self.ground.Map:GetTileAtPoint(position.x, position.y, position.z)
        passable = tile ~= GROUND.IMPASSABLE
    end

    --if we're specifically using an item, see if we can use it on the target entity
    if useitem and useitem:IsValid() then

        if target == inst then
            actions = self:GetInventoryActions(useitem, false)
        end

		--print ("!", self:ShouldForceDrop() , target == nil , useitem.components.inventoryitem , useitem.components.inventoryitem.owner == self.inst)
        if not actions then
            if target then
                actions = self:GetUseItemActions(target, useitem)
            elseif passable and position then
                actions = self:GetPointActions(position, useitem)
            end
        end
    elseif target then
        --if we're clicking on a scene entity, see if we can use our equipped object on it, or just use it
        if self:ShouldForceInspect() and target.components.inspectable then
            actions = self:SortActionList({ACTIONS.LOOKAT}, target, nil)
        elseif self:ShouldForceAttack() and inst.components.combat:CanTarget(target) then
            actions = self:SortActionList({actiontoperform}, target, nil)
        elseif equipitem and equipitem:IsValid() then
            actions = self:GetEquippedItemActions(target, equipitem)
        end
        
        if actions == nil or #actions == 0 then
			actions = self:GetSceneActions(target)
        end
    end
    
    
    if not actions and position and not target and passable then
    
		--can we use our equipped item at the point?
		if equipitem and equipitem:IsValid() then
			actions = self:GetPointActions(position, equipitem)
            --this is to make it so you don't auto-drop equipped items when you left click the ground. kinda ugly.
            if actions then
                for k,v in ipairs(actions) do
				    if v.action == ACTIONS.DROP then
					    table.remove(actions, k)
					    break
				    end
                end
            end
		end
		
		--if we're pointing at open ground, walk
		if not actions or #actions == 0 then
			--actions = { BufferedAction(inst, nil, ACTIONS.WALKTO, nil, position) }
		end
    end

    
    return actions or {}
end

local function SetBowActionsOverride(inst, owner, enable)
    if enable then
		if owner.components.playercontroller ~= nil then
			owner.components.playercontroller.DoAttackButton = BowForceAttackOverride
			owner.components.playercontroller.DoControllerAttack = OverrideDoControllerAttack
			owner.components.playercontroller.UpdateControllerAttackTarget = OverrideUpdateControllerAttackTarget
		end
		if owner.components.playeractionpicker ~= nil then
			owner.components.playeractionpicker.leftclickoverride = BowLCOverride
		end
    else		
        if owner.components.playercontroller ~= nil then
			owner.components.playercontroller.DoAttackButton = OriginalDoAttackButton
			owner.components.playercontroller.DoControllerAttack = OriginalDoControllerAttack
			owner.components.playercontroller.UpdateControllerAttackTarget = OriginalUpdateControllerAttackTarget
        end
        if owner.components.playeractionpicker ~= nil then
			owner.components.playeractionpicker.leftclickoverride = nil
        end
    end
end

local function OnEquipControlsOverride(inst, owner, enable)
	if enable then
		if OriginalDoAttackButton == nil and owner.components.playercontroller ~= nil then
			OriginalDoAttackButton = owner.components.playercontroller.DoAttackButton
		end

		if OriginalDoControllerAttack == nil and owner.components.playercontroller ~= nil then
			OriginalDoControllerAttack = owner.components.playercontroller.DoControllerAttack
		end
		
		if OriginalUpdateControllerAttackTarget == nil and owner.components.playercontroller ~= nil then
			OriginalUpdateControllerAttackTarget = owner.components.playercontroller.UpdateControllerAttackTarget
		end
		
		if owner.components.combat then
			owner.components.combat.laststartattacktime = 0
		end
		
		SetBowActionsOverride(inst, owner, true)
	else
		SetBowActionsOverride(inst, owner, false)
	end
end

local function onattack(inst, attacker, target)
    if target.components.sleeper and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end

    if target.components.combat then
        target.components.combat:SuggestTarget(attacker)
    end
	
	local quiver = attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
	
	if inst:HasTag("magic") and inst:HasTag("bow") then
		if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
			inst.components.fueled:DoDelta(-1)
		end
	else	
		if quiver ~= nil and quiver.components.container ~= nil then
			local projinquiver = quiver.components.container:GetItemInSlot(1)
				if projinquiver ~= nil then
					if projinquiver.components.stackable.stacksize == 1 and attacker.components.inventory:Has(projinquiver.prefab, 1) then
						local projtotransfer = SpawnPrefab(projinquiver.prefab)
						local amounttotransfer = select(2, attacker.components.inventory:Has(projinquiver.prefab, 1))
						quiver.components.container:ConsumeByName(projinquiver.prefab,1)
						
						if amounttotransfer < projtotransfer.components.stackable.maxsize then
							projtotransfer.components.stackable:SetStackSize(amounttotransfer)
							attacker.components.inventory:ConsumeByName(projinquiver.prefab,amounttotransfer)
						else
							projtotransfer.components.stackable:SetStackSize(projtotransfer.components.stackable.maxsize)
							attacker.components.inventory:ConsumeByName(projinquiver.prefab,projtotransfer.components.stackable.maxsize)						
						end
						
						quiver.components.container:GiveItem(projtotransfer)
					else
						quiver.components.container:ConsumeByName(projinquiver.prefab,1)				
					end
				end
		end
	end
	
	if inst.components.zupalexsrangedweapons ~= nil and inst:HasTag("crossbow") then
		inst:RemoveTag("readytoshoot")
		attacker.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow")
	end
end

local function OnEquipBow(inst, owner)
	OnEquipControlsOverride(inst, owner, true)
	
--	print("I equip the bow")
			
    owner.AnimState:OverrideSymbol("swap_object", "swap_bow", "swap_bow")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
 
local function OnUnequipBow(inst, owner)	
--	print("I unequip the bow")
	
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

	OnEquipControlsOverride(inst, owner, false)
end

local function bowfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
     
    anim:SetBank("bow")
    anim:SetBuild("bow")
    anim:PlayAnimation("bow_idle")
 
	inst:AddTag("bow") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("ranged")
	
 --The following section is suitable for a DST compatible prefab.
    

----------------------------------------------------------------
	
--	print("BOW USES = " , TUNING.BOWUSES, "   /   BOW DMG = ", TUNING.BOWDMG)
	
	if TUNING.BOWUSES < 201 then
		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(TUNING.BOWUSES)
		inst.components.finiteuses:SetUses(TUNING.BOWUSES)
		inst.components.finiteuses:SetOnFinished(inst.Remove)
	end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "bow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bow.xml"
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquipBow )
    inst.components.equippable:SetOnUnequip( OnUnequipBow )
	
	inst:AddComponent("zupalexsrangedweapons")
	inst.components.zupalexsrangedweapons:SetDamage(0)
    inst.components.zupalexsrangedweapons:SetRange((TUNING.BOWRANGE - 2), TUNING.BOWRANGE)
    inst.components.zupalexsrangedweapons:SetProjectile("arrow")
	inst.components.zupalexsrangedweapons:SetOnAttack(onattack)
	inst.components.zupalexsrangedweapons:SetAllowedProjectiles( { "arrow", "goldarrow", "moonstonearrow", "firearrow", "icearrow", "thunderarrow", "dischargedthunderarrow" } )
 
    return inst
end

----------------------------------------------------ARROWS----------------------------------------------------------

local function onpickup(inst)
	if inst.prefab == "moonstonearrow" then	
		inst.Light:Enable(false)
	end
end

local function onputininventory(inst, owner)
	local activeitem = nil
	local quiver = nil
	local projinquiver = nil
	
	if owner.components.inventory ~= nil then
		inst:DoTaskInTime(0, function () 
								activeitem = owner.components.inventory:GetActiveItem()
								quiver = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
--								print("Active item is : ", activeitem or "UNAVAILABLE", "  / Quiver is : ", quiver or "UNAVAILABLE")
								
								if inst ~= activeitem and quiver ~= nil then
									projinquiver = quiver.components.container:GetItemInSlot(1)
--									print("Player ", inst.components.inventoryitem.owner, " put ", inst, " in its inventory (owner = ", owner, ")")
--									print("Quiver has : ", projinquiver or "EMPTY")
									if projinquiver == nil then
										local projtostore = SpawnPrefab(string.lower(inst.prefab))
										projtostore.components.stackable:SetStackSize(inst.components.stackable.stacksize)
										quiver.components.container:GiveItem(projtostore, 1)
										inst:Remove()
									elseif projinquiver.prefab == inst.prefab and not projinquiver.components.stackable:IsFull() then
										local currentactivestack = inst.components.stackable.stacksize
										local currentstackinquiver = projinquiver.components.stackable.stacksize
										local stackoverflow = currentactivestack - projinquiver.components.stackable:RoomLeft()			
										
										if stackoverflow <= 0 then
											projinquiver.components.stackable:SetStackSize(currentactivestack + currentstackinquiver)
											inst:Remove()
										else
											projinquiver.components.stackable:SetStackSize(projinquiver.components.stackable.maxsize)
											local projtostore = SpawnPrefab(string.lower(inst.prefab))
											projtostore.components.stackable:SetStackSize(stackoverflow)
											owner:DoTaskInTime(0, function() owner.components.inventory:GiveItem(projtostore) end)
											inst:Remove()
										end
									end								
								end
							end)
	end
end

local function commonarrowfn(arrowanim, tags) 
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
 
	inst:AddTag("projectile") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("arrow")

	if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
    end
	
	anim:SetBank("arrow")
    anim:SetBuild("bow")
    anim:PlayAnimation(arrowanim, true)
	
 --The following section is suitable for a DST compatible prefab.
    
----------------------------------------------------------------
	
	inst:AddComponent("projectile")
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPickupFn(onpickup)
	inst.components.inventoryitem:SetOnPutInInventoryFn(onputininventory)
	
	
	inst:AddComponent("zupalexsrangedweapons")
	
	inst:AddComponent("stackable")
	
	 
    return inst
end

local function onhitarrow_fire(attacker, target)
	target.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_impact_fire")
	
--	print("I am shooting a Fire Arrow")
	
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

local function onhitarrow_ice(attacker, target)
--	print("I am shooting an Ice Arrow")
   
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

local function onhitarrow_thunder(inst, attacker, target)
	local lightningstrike = SpawnPrefab("lightning")
	lightningstrike.Transform:SetPosition(target.Transform:GetWorldPosition())
	
	if not target:HasTag("stunned") then
		target:AddTag("stunned")
		
		if target.stuneffect == nil and target.components.health and not target.components.health:IsDead() then
			local symboltofollow = nil
			local symboltofollow_x = 0
			local symboltofollow_y = -100
			local symboltofollow_z = 0.02
		
			symboltofollow = target.components.combat.hiteffectsymbol
		
			if (symboltofollow == "marker" or symboltofollow == nil) and target.components.burnable then
				for k, v in pairs(target.components.burnable.fxdata) do
					if v.follow ~= nil then
						symboltofollow = v.follow
						symboltofollow_x = v.x
						symboltofollow_y = v.y - 190
						symboltofollow_z = v.z
					end
				end
			end
		
--			print("symboltofollow = ", symboltofollow)
		
			if symboltofollow ~= nil and symboltofollow ~= "marker" then 
				target.stuneffect = SpawnPrefab("stuneffect")
				target.stuneffect.Transform:SetPosition(target:GetPosition():Get())
				target.stuneffect:SetFollowTarget(target, symboltofollow, symboltofollow_x, symboltofollow_y, symboltofollow_z)
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

local function onhitbolt_poison(attacker, target)
--	print("I am shooting an Ice Arrow")
   
    if target.components.combat then
		if not target:HasTag("poisoned") then
			target:AddTag("poisoned")
			
			if target.poisoncloud == nil then
				local symboltofollow = nil
				local symboltofollow_x = 0
				local symboltofollow_y = 0
				local symboltofollow_z = 0.02
			
				symboltofollow = target.components.combat.hiteffectsymbol			
			
				if (symboltofollow == "marker" or symboltofollow == nil) and target.components.burnable then
					for k, v in pairs(target.components.burnable.fxdata) do
						if v.follow ~= nil then
							symboltofollow = v.follow
							symboltofollow_x = v.x
							symboltofollow_y = v.y - 30
							symboltofollow_z = v.z
						end
					end
				end
			
				if symboltofollow ~= nil and symboltofollow ~= "marker" then
					target.poisoncloud = SpawnPrefab("poisoncloud")
					target.poisoncloud.Transform:SetPosition(target:GetPosition():Get())
					target.poisoncloud:SetFollowTarget(target, symboltofollow, symboltofollow_x, symboltofollow_y, symboltofollow_z)
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

local function onhitbolt_explosive(inst, attacker, target)
--	print("I am shooting an Explosive Bolt")

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

local function onthrown_regular(inst, data)
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
	if inst.Physics ~= nil and not inst:HasTag("nocollisionoverride") then
		inst.Physics:ClearCollisionMask()
		inst.Physics:CollidesWith(COLLISION.WORLD)
		if TUNING.COLLISIONSAREON then
			inst.Physics:CollidesWith(COLLISION.OBSTACLES)
		end
	end
end

local function shootarrow(inst)
    inst.AnimState:PlayAnimation("arrow_flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function shootgoldarrow(inst)
    inst.AnimState:PlayAnimation("goldarrow_flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function shootmoonstonearrow(inst)
    inst.AnimState:PlayAnimation("moonstonearrow_flight", true)
	inst.Light:Enable(true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function onmissarrow_regular(inst, attacker, target)
	local zupaproj = inst.components.zupalexsrangedweapons
	local RecChance = zupaproj:GetRecChance(false)

	if math.random() <= RecChance and inst:HasTag("recoverable") then
		local currentweaponbaseproj = zupaproj:GetBasicAmmo()
--		print("currentprojbasic in super miss = ", currentprojbasicammo)
		local recoveredarrow = SpawnPrefab(currentweaponbaseproj)
		recoveredarrow.Transform:SetPosition(zupaproj:GetTargetPosition())
	end

	inst:Remove()
end

local function onmiss_explosivebolt(inst, attacker, target)
	local shooter = inst.components.zupalexsrangedweapons.owner
	onhitbolt_explosive(inst, shooter, target)
	inst:Remove()
end

local function onhitarrow_healing(inst, attacker, target)
	if target ~= nil then
		if target.components.health ~= nil and not target.components.health:IsDead() then
		target.components.health:DoDelta(25)
		end
		
		if target.components.sanity ~= nil then
			target.components.sanity:DoDelta(-5)
		end
	end
end

local function HITorMISSHandler(inst, attacker, target, DamageToApply, canmiss, canrecover)
	local misschancesmall, misschancebig = inst.components.zupalexsrangedweapons:GetMissChance()
	
	local misschance
	local RecChance
	local ignoreattack = false
	
	if TUNING.HITCHANCEFLYINGBIRDS and target:HasTag("bird") and target.sg and target.sg:HasStateTag("flying") then
		misschance = 0.995
		ignoreattack = true
	elseif TUNING.HITCHANCEBUGS and target.prefab == "bee" or target.prefab == "butterfly" then
		misschance = 0.99
	elseif canmiss then
		if target:HasTag("rabbit") or target:HasTag("bird") or target:HasTag("mole") or target:HasTag("butterfly") or target:HasTag("bee") or target:HasTag("frog") then 
			misschance = misschancesmall
		else
			misschance = misschancebig
		end
	else
		misschance = 0
	end
	
	local hitscore = math.random()
	
--	print("hitscore = ", hitscore)
--	print("miss chance = ", misschance)
	
--	print("Thrower in Component file = ", inst.components.zupalexsrangedweapons.owner)
	
	local bowowner = inst.components.zupalexsrangedweapons.owner -- in this particular case, the "attacker" is actually the bow, because the inst is the arrow, and the "owner" of the arrow is the bow...
	
	if bowowner == nil then
		bowowner = attacker
	end
	
	if not target:IsInLimbo() then
		if hitscore <= misschance then	
			if bowowner ~= nil and bowowner.components and bowowner.components.talker then
				local miss_message = "I should aim better next time!"
				bowowner.components.talker:Say(miss_message)
			end
			if not ignoreattack then
				target:PushEvent("attacked", {attacker = bowowner, damage = 0.1})
			end
			
			if inst.prefab == "explosivebolt" then
				onhitbolt_explosive(inst, bowowner, target)
			end
			
			if canrecover and inst:HasTag("recoverable") then
				RecChance = inst.components.zupalexsrangedweapons:GetRecChance(false)

			
				if math.random() <= RecChance then
					local rdmshift = Vector3(math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random())
					local targposx, targposy, targposz = target.Transform:GetWorldPosition()
					local currentprojbasicammo = inst.components.zupalexsrangedweapons:GetBasicAmmo()
		--			print("currentprojbasic in miss = ", currentprojbasicammo)
					local recoveredarrow = SpawnPrefab(currentprojbasicammo)
					recoveredarrow.Transform:SetPosition((targposx + rdmshift.x), (targposy + rdmshift.y), (targposz + rdmshift.z))
				end	
			end
		else	
			if target:HasTag("player") then
				if (1-hitscore) <= TUNING.CRITCHANCEPVP then
	--				print("Score a critical against a Player!")
					DamageToApply = DamageToApply*TUNING.CRITDMGMODPVP
				end
			else
				if (1-hitscore) <= TUNING.CRITCHANCEPVE then
	--				print("Score a critical against a Mob!")
					DamageToApply = DamageToApply*TUNING.CRITDMGMODPVE
				end
			end
				
	--		print("Damage To Apply = ", DamageToApply)	
				
			target.components.combat:GetAttacked(bowowner, DamageToApply)
			
			if inst.prefab == "firearrow" then
				onhitarrow_fire(bowowner, target)
			elseif inst.prefab == "icearrow" then
				onhitarrow_ice(bowowner, target)
			elseif inst.prefab == "thunderarrow" then
				onhitarrow_thunder(inst, bowowner, target)
			elseif inst.prefab == "poisonbolt" then
				onhitbolt_poison(bowowner, target)
			elseif inst.prefab == "explosivebolt" then
				onhitbolt_explosive(inst, bowowner, target)
			elseif inst.prefab == "healingarrow" then
				onhitarrow_healing(inst, bowowner, target)
			end
			
			if canrecover and inst:HasTag("recoverable") then
				RecChance = inst.components.zupalexsrangedweapons:GetRecChance(true)
			
				if math.random() <= RecChance then
					if target.arrowtorecover == nil then
						target.arrowtorecover = {}
						target.arrowtorecover[inst.prefab] = 1
					elseif target.arrowtorecover ~= nil and target.arrowtorecover[inst.prefab] == nil then
						target.arrowtorecover[inst.prefab] = 1
					else
						target.arrowtorecover[inst.prefab] = target.arrowtorecover[inst.prefab] + 1
					end
					
					for k, v in pairs(target.arrowtorecover) do
--						print(k, "  ->  ", v)
					end
--					print("****************************************")
					
					if target.RetrievePinnedArrows == nil then
						if target.components.health and target.components.health:IsDead() then
							local recoveredarrow = SpawnPrefab(inst.components.zupalexsrangedweapons:GetBasicAmmo())
							local rdmshift = Vector3(math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random())
							local targposx, targposy, targposz = target.Transform:GetWorldPosition()
							recoveredarrow.Transform:SetPosition((targposx + rdmshift.x), (targposy + rdmshift.y), (targposz + rdmshift.z))
						else
							target.RetrievePinnedArrows = function()
															target:DoTaskInTime(0.5, function() 
																						if target.arrowtorecover ~= nil then
																							for k, v in pairs(target.arrowtorecover) do
																								local NbrOfStack = math.ceil(v/20)
																								local LastStackSize = v - (NbrOfStack-1)*20
																								
																								local StS = 1 -- Stack to Spawn
																								while StS <= NbrOfStack do
																									local pinnedarrow = SpawnPrefab(k)								
	--										--														print("Arrow to recover = ", pinnedarrow.components.zupalexsrangedweapons:GetBasicAmmo())
																									local recoveredarrow = SpawnPrefab(pinnedarrow.components.zupalexsrangedweapons:GetBasicAmmo())
																									pinnedarrow:Remove()
																									
																									if StS == NbrOfStack then
																										recoveredarrow.components.stackable:SetStackSize(LastStackSize)
																									else
																										recoveredarrow.components.stackable:SetStackSize(recoveredarrow.components.stackable.maxsize)
																									end
																									
																									local rdmshift = Vector3(math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random())
																									local targposx, targposy, targposz = target.Transform:GetWorldPosition()
																									recoveredarrow.Transform:SetPosition((targposx + rdmshift.x), (targposy + rdmshift.y), (targposz + rdmshift.z))
																									StS = StS+1
																								end
																							end						
																							target.arrowtorecover = nil
																						end
																					end					
																				)
														end
							target:ListenForEvent("death", target.RetrievePinnedArrows)
						end
					end
				end		
			end
		end	
	else
		if not inst:HasTag("explosive") then
			onmissarrow_regular(inst, bowowner, inst)
		else
			onmiss_explosivebolt(inst, bowowner, inst)
		end
	end
end

local function CalcFinalDamage(inst, target, applydodelta)
	local bowowner = inst.components.zupalexsrangedweapons.owner -- in this particular case, the "attacker" is actually the bow, because the inst is the arrow, and the "owner" of the arrow is the bow...
	local BaseDamage = inst.components.zupalexsrangedweapons:GetArrowBaseDamage()
	local DmgModifier = 1.0
	local DmgMultiplier = (bowowner.components.combat.damagemultiplier or 1) -- Damage multiplier of a specific character
	
	local AdditionnalDmgMultiplier =
		(inst.components.zupalexsrangedweapons.stimuli == "electric" and
		not (target:HasTag("electricdamageimmune") or (target.components.inventory ~= nil and target.components.inventory:IsInsulated()))
		and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (target.components.moisture ~= nil and target.components.moisture:GetMoisturePercent() or (target:GetIsWet() and 1 or 0)))
		or 0
	
	if bowowner ~= nil and bowowner.components.sanity ~= nil then
		if inst.prefab == "lightarrow" then 
			if target:HasTag("shadowcreature") then
				DmgModifier = 1.6
				if applydodelta then bowowner.components.sanity:DoDelta(5) end
			elseif not target:HasTag("hostile") then
				DmgModifier = 0.6
				if applydodelta then bowowner.components.sanity:DoDelta(-10) end					
			end	
		elseif inst.prefab == "shadowarrow" then 
			if target:HasTag("shadowcreature")then
				DmgModifier = 0.2
				if applydodelta then bowowner.components.sanity:DoDelta(-10) end
			else 
				if applydodelta then bowowner.components.sanity:DoDelta(-2) end
			end
		elseif inst.prefab == "healingarrow" then 
			if target:HasTag("hostile")then
				if applydodelta then bowowner.components.sanity:DoDelta(-15) end
			elseif target:HasTag("player")then
				if applydodelta then bowowner.components.sanity:DoDelta(-5) end
			end
		end
	end
	
	return BaseDamage*(DmgModifier*DmgMultiplier + AdditionnalDmgMultiplier)
end

local function onhitcommon(inst, attacker, target)			
--	print("Final Damage = ", CalcFinalDamage(inst, target, false))
	
	HITorMISSHandler(inst, attacker, target, CalcFinalDamage(inst, target, true), true, true)

	if target.components.health and not target.components.health:IsDead() and math.random() < 0.65 then
		if target:HasTag("bird") then
			GetWorld():DoTaskInTime(0.5, function() target.sg:GoToState("flyaway") end)
		elseif target.prefab == "rabbit" then
			GetWorld():DoTaskInTime(0.5, function() target:PushEvent("gohome") end)
		end
	end
	
	if inst:IsValid() then
		inst:Remove()
	end
end

local function oncollide(inst, other)
	local zupaproj = inst.components.zupalexsrangedweapons
	local attacker = zupaproj.owner

	if not attacker then
		inst:Remove()
		return
	end
	
	if not (other:HasTag("campfire") or other:HasTag("watersource")) then
		if inst.components.zupalexsrangedweapons ~= nil and not inst:HasTag("explosive") then
			if other.components.combat ~= nil and other:IsValid() and not other:IsInLimbo() and not other:HasTag("wall") then
				HITorMISSHandler(inst, attacker, other, CalcFinalDamage(inst, other, true), false, false)
			elseif inst:HasTag("recoverable") then
				local inst_x, inst_y, inst_z = inst.Transform:GetWorldPosition()
				local obstacle_x, obstacle_y, obstacle_z = other.Transform:GetWorldPosition()
				local currentprojbasicammo = inst.components.zupalexsrangedweapons:GetBasicAmmo()
				local recoveredarrow = SpawnPrefab(currentprojbasicammo)
				recoveredarrow.Transform:SetPosition((2*inst_x-obstacle_x), (2*inst_y-obstacle_y), (2*inst_z-obstacle_z))
			end
		elseif inst.components.zupalexsrangedweapons ~= nil and inst:HasTag("explosive") then
			onhitbolt_explosive(inst, attacker, other)
		end
 
		if inst:IsValid() then
			inst:Remove()
		end		
	elseif other:HasTag("campfire") or other:HasTag("watersource") then
--		print("Low obstalce encountered")
		RemovePhysicsColliders(inst)
		inst.Physics:CollidesWith(COLLISION.WORLD)
		inst.Physics:CollidesWith(COLLISION.OBSTACLES)
	end
end

local function regulararrowfn()
	local inst = commonarrowfn("arrow_idle", { "piercing", "sharp", "recoverable" })
	
	inst.Physics:SetCollisionCallback(oncollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootarrow)
	inst.components.projectile:SetOnHitFn(onhitcommon)
	inst.components.projectile:SetOnMissFn(onmissarrow_regular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", onthrown_regular)
	
	inst.components.inventoryitem.imagename = "arrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/arrow.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function goldarrowfn()
	local inst = commonarrowfn("goldarrow_idle", { "piercing", "sharp", "golden", "recoverable" })
	
	inst.Physics:SetCollisionCallback(oncollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootgoldarrow)
	inst.components.projectile:SetOnHitFn(onhitcommon)
	inst.components.projectile:SetOnMissFn(onmissarrow_regular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", onthrown_regular)
	
	inst.components.inventoryitem.imagename = "goldarrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/goldarrow.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function ondroppedMSarrow(inst)
	inst.Light:Enable(true)
end

local function moonstonearrowfn()
	local inst = commonarrowfn("moonstonearrow_idle", { "piercing", "sharp", "moonstone", "recoverable" })
	
	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.6)
	inst.Light:SetRadius(0.5)
	inst.Light:SetFalloff(0.75)
	inst.Light:Enable(true)
	inst.Light:SetColour(0/255, 0/255, 255/255)
	
	inst.Physics:SetCollisionCallback(oncollide)
	
    inst.components.inventoryitem:SetOnDroppedFn(ondroppedMSarrow)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootmoonstonearrow)
	inst.components.projectile:SetOnHitFn(onhitcommon)
	inst.components.projectile:SetOnMissFn(onmissarrow_regular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", onthrown_regular)
	
	inst.components.inventoryitem.imagename = "moonstonearrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/moonstonearrow.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function onmissarrow_special(inst, attacker, target)
	inst:Remove()
end

local function shootarrow_fire(inst)
    inst.AnimState:PlayAnimation("firearrow_flight", true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function shootarrow_ice(inst)
    inst.AnimState:PlayAnimation("icearrow_flight", true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function firearrowfn()
	local inst = commonarrowfn("firearrow_idle", { "burning", "recoverable" })
	
	inst.Physics:SetCollisionCallback(oncollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootarrow_fire)
    inst.components.projectile:SetOnHitFn(onhitcommon)
    inst.components.projectile:SetOnMissFn(onmissarrow_regular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
    inst:ListenForEvent("onthrown", onthrown_regular)
	
	inst.components.inventoryitem.imagename = "firearrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/firearrow.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function icearrowfn()
	local inst = commonarrowfn("icearrow_idle", { "freezing", "recoverable" })
	
	inst.Physics:SetCollisionCallback(oncollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootarrow_ice)
    inst.components.projectile:SetOnHitFn(onhitcommon)
    inst.components.projectile:SetOnMissFn(onmissarrow_regular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
    inst:ListenForEvent("onthrown", onthrown_regular)
	
	inst.components.inventoryitem.imagename = "icearrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/icearrow.xml"
	
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

local function shootarrow_thunder(inst)
    inst.AnimState:PlayAnimation("thunderarrow_flight", true)
	startflickering(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function thunderarrowfn()
	local inst = commonarrowfn("thunderarrow_idle", { "electric", "recoverable" })
	
	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.4)
	inst.Light:SetRadius(0.3)
	inst.Light:SetFalloff(0.66)
	inst.Light:SetColour(152/255, 229/255, 243/255)
	inst.Light:Enable(false)
	
	inst.Physics:SetCollisionCallback(oncollide)
	
	
	inst.components.inventoryitem:SetOnDroppedFn(startflickering)	
	inst.components.inventoryitem:SetOnPickupFn(stopflickering)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootarrow_thunder)
    inst.components.projectile:SetOnHitFn(onhitcommon)
    inst.components.projectile:SetOnMissFn(onmissarrow_regular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
    inst:ListenForEvent("onthrown", onthrown_regular)
	
	inst.components.inventoryitem.imagename = "thunderarrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/thunderarrow.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	inst.components.zupalexsrangedweapons.stimuli = "electric"
	
	return inst
end

local function shootarrow_thunder_discharged(inst)
    inst.AnimState:PlayAnimation("thunderarrow_flight_discharged", true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function dischargedthunderarrowfn()
	local inst = commonarrowfn("thunderarrow_idle_discharged", { "electric", "discharged", "recoverable" })
	
	inst.Physics:SetCollisionCallback(oncollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootarrow_thunder_discharged)
    inst.components.projectile:SetOnHitFn(onhitcommon)
    inst.components.projectile:SetOnMissFn(onmissarrow_regular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
    inst:ListenForEvent("onthrown", onthrown_regular)
	
	inst.components.inventoryitem.imagename = "dischargedthunderarrow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dischargedthunderarrow.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

------------------------------------------------------------ CROSSBOWS ------------------------------------------------------------

local function onarmedxbow(inst, armer)
	inst:AddTag("readytoshoot")
	armer.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow_armed")
end

local function OnEquipXbow(inst, owner)
	OnEquipControlsOverride(inst, owner, true)
	
--	print("I equip the crossbow")

	if inst:HasTag("readytoshoot") then
		owner.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow_armed")
	else
		owner.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow")
	end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
 
local function OnUnequipXbow(inst, owner)	
--	print("I unequip the crossbow")
	
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

	OnEquipControlsOverride(inst, owner, false)
end

local function crossbowfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
     
    anim:SetBank("crossbow")
    anim:SetBuild("crossbow")
    anim:PlayAnimation("crossbow_idle")
 
	inst:AddTag("crossbow") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("ranged")
	
 --The following section is suitable for a DST compatible prefab.
    
----------------------------------------------------------------
	
--	print("BOW USES = " , TUNING.BOWUSES, "   /   BOW DMG = ", TUNING.BOWDMG)
	
	if TUNING.BOWUSES < 201 then
		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(TUNING.BOWUSES)
		inst.components.finiteuses:SetUses(TUNING.BOWUSES)
		inst.components.finiteuses:SetOnFinished(inst.Remove)
	end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "crossbow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/crossbow.xml"
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquipXbow )
    inst.components.equippable:SetOnUnequip( OnUnequipXbow )
	
	inst:AddComponent("zupalexsrangedweapons")
--	inst.components.zupalexsrangedweapons:SetIsReady(false)
	inst.components.zupalexsrangedweapons:SetOnArmedFn(onarmedxbow)
	inst.components.zupalexsrangedweapons:SetDamage(0)
    inst.components.zupalexsrangedweapons:SetRange((TUNING.BOWRANGE*TUNING.CROSSBOWRANGEMOD - 2), TUNING.BOWRANGE*TUNING.CROSSBOWRANGEMOD)
    inst.components.zupalexsrangedweapons:SetProjectile("arrow")
	inst.components.zupalexsrangedweapons:SetOnAttack(onattack)
	inst.components.zupalexsrangedweapons:SetAllowedProjectiles( { "bolt", "poisonbolt", "explosivebolt"} )
 
    return inst
end


------------------------------------------------------------ BOLTS ----------------------------------------------------------------

local function commonboltfn(boltanim, tags) 
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
     
    anim:SetBank("bolt")
    anim:SetBuild("crossbow")
    anim:PlayAnimation(boltanim)
 
	inst:AddTag("projectile") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("bolt")

	if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
    end

 --The following section is suitable for a DST compatible prefab.
    
----------------------------------------------------------------
	
	inst:AddComponent("projectile")
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPickupFn(onpickup)
	inst.components.inventoryitem:SetOnPutInInventoryFn(onputininventory)
	
	inst:AddComponent("zupalexsrangedweapons")
	
	inst:AddComponent("stackable")
	
	 
    return inst
end

local function shootbolt(inst)
    inst.AnimState:PlayAnimation("bolt_flight",true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end
	
local function regularboltfn()
	local inst = commonboltfn("bolt_idle", { "piercing", "sharp", "recoverable" })
	
	inst.Physics:SetCollisionCallback(oncollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootbolt)
    inst.components.projectile:SetOnHitFn(onhitcommon)
    inst.components.projectile:SetOnMissFn(onmissarrow_regular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
    inst:ListenForEvent("onthrown", onthrown_regular)
	
	inst.components.inventoryitem.imagename = "bolt"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bolt.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function shootpoisonbolt(inst)
    inst.AnimState:PlayAnimation("poisonbolt_flight",true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function poisonboltfn()
	local inst = commonboltfn("poisonbolt_idle", { "poison" })
	
	inst.Physics:SetCollisionCallback(oncollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootpoisonbolt)
    inst.components.projectile:SetOnHitFn(onhitcommon)
    inst.components.projectile:SetOnMissFn(onmissarrow_regular)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
    inst:ListenForEvent("onthrown", onthrown_regular)
	
	inst.components.inventoryitem.imagename = "poisonbolt"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/poisonbolt.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

local function shootexplosivebolt(inst)
    inst.AnimState:PlayAnimation("explosivebolt_flight",true)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function explosiveboltfn()
	local inst = commonboltfn("explosivebolt_idle", { "explosive" })
	
	inst.entity:AddSoundEmitter()

		
	inst.Physics:SetCollisionCallback(oncollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootexplosivebolt)
    inst.components.projectile:SetOnHitFn(onhitcommon)
    inst.components.projectile:SetOnMissFn(onmiss_explosivebolt)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
    inst:ListenForEvent("onthrown", onthrown_regular)
	
	inst.components.inventoryitem.imagename = "explosivebolt"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/explosivebolt.xml"
	
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	return inst
end

----------------------------------------------------------------------------------------------MAGIC BOW-----------------------------------------------------------------

local function SpawnSparkles(inst, owner)
	if inst.sparkles01 == nil then
        inst.sparkles01 = SpawnPrefab("sparkles")
        inst.sparkles01.Transform:SetPosition(inst:GetPosition():Get())
        inst.sparkles01:SetFollowTarget(owner, "swap_object", -100, -300, 0.02)
    end
	
	local ismoving = false
	
	inst.onlocomote = function(owner)
		if inst.sparkles01 ~= nil then
			if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
				if owner.components.locomotor.wantstomoveforward and not ismoving then
					ismoving = true
					inst.sparkles01:SetFollowTarget(owner, "swap_hat", 50, -280, 0.02)
					inst.sparkles01.AnimState:PlayAnimation("mov", true)
		--          inst.sparkles01.SoundEmitter:PlaySound("dontstarve/common/fan_twirl_LP", "twirl")
				elseif not owner.components.locomotor.wantstomoveforward and ismoving then
					ismoving = false
					inst.sparkles01:SetFollowTarget(owner, "swap_object", -100, -300, 0.02)
					inst.sparkles01.AnimState:PlayAnimation("idle", true)
		--          inst.sparkles01.SoundEmitter:KillSound("twirl")
				end
			else
				inst:RemoveEventCallback("locomote", inst.onlocomote, owner)
			end
		else
			inst:RemoveEventCallback("locomote", inst.onlocomote, owner)
		end
    end

    inst:ListenForEvent("locomote", inst.onlocomote, owner)
end

local function OnEquipMagicBow(inst, owner)	
	OnEquipControlsOverride(inst, owner, true)
	
	owner.AnimState:OverrideSymbol("swap_object", "swap_magicbow", "swap_magicbow")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
		inst:AddTag("hasfuel")
	end
	
	if inst:HasTag("hasfuel") then
		inst.Light:Enable(true)
		SpawnSparkles(inst, owner)
	end
	
	if inst.components.zupalexsrangedweapons.projectile.prefab == "healingarrow" and not self.inst:HasTag("healer") then
		self.inst:AddTag("healer")
	end		
--	print("I equip the bow")
end
 
local function OnUnequipMagicBow(inst, owner)	
--	print("I unequip the bow")
	
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

	if inst.sparkles01 ~= nil then
        inst.sparkles01:SetFollowTarget(nil)
        inst.sparkles01 = nil
		inst:RemoveEventCallback("locomote", inst.onlocomote, owner)
    end
	
	inst.Light:Enable(false)

	OnEquipControlsOverride(inst, owner, false)
end

local function magicbow_empty(inst)
	if inst.sparkles01 ~= nil then
        inst.sparkles01:SetFollowTarget(nil)
        inst.sparkles01 = nil
    end
	
	inst.Light:Enable(false)
	
	if inst:HasTag("hasfuel") then
		inst:RemoveTag("hasfuel")
	end
end

local function MagicBowCanAcceptFuelItem(self, item)
	if item ~= nil and item.components.fuel ~= nil and (item.components.fuel.fueltype == "ZUPALEX" or item.prefab == "nightmarefuel") then
		return true
	else
		return false
	end
end

local function MagicBowTakeFuel(self, item)		
	if self:CanAcceptFuelItem(item) then
	
		local changeproj = self.inst.components.zupalexsrangedweapons:MBSetNewProjectile(item.prefab)
	
--		print("changeproj = ", changeproj)
	
		if changeproj then
			self:MakeEmpty()
		end
	
		if not self.inst:HasTag("hasfuel") then
			if self.inst.components.equippable ~= nil and self.inst.components.equippable:IsEquipped() then
				self.inst.Light:Enable(true)
			end
			self.inst:AddTag("hasfuel")
		end
		
		if item.prefab =="nightmarefuel" or item.prefab == "z_bluegoop" then
			self:DoDelta(5)
		elseif item.prefab =="z_firefliesball" then
			self:DoDelta(10)
		end
		
        item:Remove()

        if self.inst.components.equippable ~= nil and self.inst.components.equippable:IsEquipped() and self.inst.sparkles01 == nil then
			local owner = self.inst.components.inventoryitem.owner
            SpawnSparkles(self.inst, owner)
        end

        return true
    end
end

local function MagicBowOnSave(self)
    if self.currentfuel > 0 then
        return {fuel = self.currentfuel}
    end
end

local function magicbowfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
	
    anim:SetBank("magicbow")
    anim:SetBuild("bow")
    anim:PlayAnimation("magicbow_idle")
 
 	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.8)
	inst.Light:SetRadius(0.5)
	inst.Light:SetFalloff(0.33)
	inst.Light:SetColour(204/255, 0/255, 255/255)
	inst.Light:Enable(false)
 
	inst:AddTag("bow") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("ranged")
	inst:AddTag("magic")
	
----------------------------------------------------------------
	
--	print("BOW USES = " , TUNING.BOWUSES, "   /   BOW DMG = ", TUNING.BOWDMG)
	
--	inst:AddComponent("finiteuses")
--	inst.components.finiteuses:SetMaxUses(10)
--	inst.components.finiteuses:SetUses(10)
--	inst.components.finiteuses:SetOnFinished(magicbow_empty)
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "magicbow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/magicbow.xml"
	inst.components.inventoryitem:SetOnDroppedFn(function(inst) inst.Light:Enable(false) end)
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquipMagicBow )
    inst.components.equippable:SetOnUnequip( OnUnequipMagicBow )
	
	inst:AddComponent("zupalexsrangedweapons")
	inst.components.zupalexsrangedweapons:SetDamage(0)
    inst.components.zupalexsrangedweapons:SetRange((TUNING.BOWRANGE - 2), TUNING.BOWRANGE)
    inst.components.zupalexsrangedweapons:SetProjectile("shadowarrow")
	inst.components.zupalexsrangedweapons:SetOnAttack(onattack)
	
	inst:AddComponent("fueled")
	inst.components.fueled.accepting = true
	inst.components.fueled.fueltype = "ZUPALEX"
	inst:AddTag("NIGHTMARE_fueled") -- to accept the nightmarefuel as well without modifying the fueltype of the nightmarefuel (better compatibility sake)
	inst.components.fueled.maxfuel = 10
	inst.components.fueled:StopConsuming()
	inst.components.fueled.CanAcceptFuelItem = MagicBowCanAcceptFuelItem
	inst.components.fueled.TakeFuelItem = MagicBowTakeFuel
	inst.components.fueled.OnSave = MagicBowOnSave
	inst.components.fueled:SetDepletedFn(magicbow_empty)

    return inst
end


--------------------------------------------------------------------------MAGIC PROJECTILES-------------------------------------------------------------------------

local function commonmagicprojfn(arrowanim, tags) 
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
 
    MakeInventoryPhysics(inst)
 
 	anim:SetBank("magicprojectile")
    anim:SetBuild("bow")
    anim:PlayAnimation(arrowanim)
 
	inst:AddTag("projectile") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("arrow")
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

local function shootshadowarrow(inst)
    inst.AnimState:PlayAnimation("shadowarrow_flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function shadowarrowfn()
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
	
--	inst.Physics:SetCollisionCallback(oncollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootshadowarrow)
	inst.components.projectile:SetOnHitFn(onhitcommon)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", onthrown_regular)
	
	return inst
end

local function shootlightarrow(inst)
    inst.AnimState:PlayAnimation("lightarrow_flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function lightarrowfn()
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
	
--	inst.Physics:SetCollisionCallback(oncollide)
	
	inst.components.projectile:SetSpeed(30)
	inst.components.projectile:SetOnThrownFn(shootlightarrow)
	inst.components.projectile:SetOnHitFn(onhitcommon)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", onthrown_regular)
	
	return inst
end

local function shoothealingarrow(inst)
    inst.AnimState:PlayAnimation("healingarrow_flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function healingarrowfn()
	local inst = commonmagicprojfn("healingarrow_flight", { "healing" })
	
	RemovePhysicsColliders(inst)
	
	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.8)
	inst.Light:SetRadius(3)
	inst.Light:SetFalloff(0.33)
	inst.Light:Enable(true)
	inst.Light:SetColour(247/255, 116/255, 255/255)
	
	inst:AddTag("energy")
	inst:AddTag("nocollisionoverride")
	
	inst.persists = false
	
--	inst.Physics:SetCollisionCallback(oncollide)
	
	inst.components.projectile:SetSpeed(20)
	inst.components.projectile:SetOnThrownFn(shoothealingarrow)
	inst.components.projectile:SetOnHitFn(onhitcommon)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	inst:ListenForEvent("onthrown", onthrown_regular)
	
	return inst
end

--------------------------------------------------------------------------FXs-------------------------------------------------------------------------

local function AlignToOwner(inst)
    if inst.followtarget ~= nil then
		local ownerrot = inst.followtarget.Transform:GetRotation()
        inst.Transform:SetRotation(ownerrot)
    end
end


local function SetFollowTarget(inst, target, follow_symbol, follow_x, follow_y, follow_z)
    inst.followtarget = target
	if inst.followtarget ~= nil then
		inst.Follower:FollowSymbol(target.GUID, follow_symbol, follow_x, follow_y, follow_z)
		inst.savedfollowtarget = target
	elseif inst.savedfollowtarget ~= nil then
		inst:Remove()
	end
end

local function poisoncloudfn(proxy)
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddFollower()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("fx")
    inst.AnimState:SetBuild("bow")
    inst.AnimState:PlayAnimation("poisoncloud", true)
	
	-----------------------------------------------------
    inst:AddTag("FX")
	inst:AddTag("NOCLICK")

    inst.persists = false

    inst.SetFollowTarget = SetFollowTarget

    return inst
end

local function stuneffectfn(proxy)
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddFollower()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("fx")
    inst.AnimState:SetBuild("bow")
    inst.AnimState:PlayAnimation("stuneffect", true)
	
	-----------------------------------------------------
    inst:AddTag("FX")
	inst:AddTag("NOCLICK")

    inst.persists = false

    inst.SetFollowTarget = SetFollowTarget

    return inst
end

return  Prefab("common/inventory/bow", bowfn, assets, prefabs),
		Prefab("common/inventory/arrow", regulararrowfn, assets, prefabs),
		Prefab("common/inventory/goldarrow", goldarrowfn, assets, prefabs),
		Prefab("common/inventory/moonstonearrow", moonstonearrowfn, assets, prefabs),
		Prefab("common/inventory/firearrow", firearrowfn, assets, prefabs),
		Prefab("common/inventory/icearrow", icearrowfn, assets, prefabs),
		Prefab("common/inventory/thunderarrow", thunderarrowfn, assets, prefabs),
		Prefab("common/inventory/dischargedthunderarrow", dischargedthunderarrowfn, assets, prefabs),
		Prefab("common/inventory/crossbow", crossbowfn, assets, prefabs),
		Prefab("common/inventory/bolt", regularboltfn, assets, prefabs),
		Prefab("common/inventory/poisonbolt", poisonboltfn, assets, prefabs),
		Prefab("common/inventory/explosivebolt", explosiveboltfn, assets, prefabs),
		Prefab("common/inventory/magicbow", magicbowfn, assets, prefabs),
		Prefab("common/inventory/shadowarrow", shadowarrowfn, assets),
		Prefab("common/inventory/lightarrow", lightarrowfn, assets),
		Prefab("common/inventory/healingarrow", healingarrowfn, assets),
		Prefab("common/fx/poisoncloud", poisoncloudfn, assets),
		Prefab("common/fx/stuneffect", stuneffectfn, assets)