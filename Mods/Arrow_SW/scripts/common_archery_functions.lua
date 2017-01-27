function DoPostAttackTask(inst, attacker)
	local quiver = attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
	local equiphand = attacker.components.inventory and attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	
	if equiphand then
		if equiphand:HasTag("magic") and equiphand:HasTag("zbow") then
			if equiphand.components.fueled ~= nil and not equiphand.components.fueled:IsEmpty() then
				equiphand.components.fueled:DoDelta(-1)
			end
		elseif equiphand:HasTag("zmusket") then
			if equiphand:HasTag("readytoshoot") then
				equiphand:RemoveTag("readytoshoot")
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
	end
	
	if equiphand and equiphand:HasTag("zcrossbow") and equiphand.components.zupalexsrangedweapons then
		-- print("I should disarm the Xbow")
		equiphand:RemoveTag("readytoshoot")
		attacker.AnimState:OverrideSymbol("swap_object", "swap_zcrossbow", "swap_crossbow")
	end
end

function OnPutInInventory(inst, owner)
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

function OnPickup(inst)
	if inst.prefab == "moonstonezarrow" then	
		inst.Light:Enable(false)
	end
end

function OnMissArrowRegular(inst, attacker, target)
	local RecChanceBonus = 0
	local zupaproj = inst.components.zupalexsrangedweapons
	
	if attacker:HasTag("improvedsight") then
		RecChanceBonus = TUNING.VITAMINRRECMOD
	end
	
	local RecChance = zupaproj and zupaproj:GetRecChance(false) + RecChanceBonus
	
	if math.random() <= RecChance and inst:HasTag("recoverable") then
		local currentweaponbaseproj = zupaproj and zupaproj:GetBasicAmmo()
--		print("currentprojbasic in super miss = ", currentprojbasicammo)
		local recoveredarrow = currentweaponbaseproj and SpawnPrefab(currentweaponbaseproj)
		if recoveredarrow then
			recoveredarrow.Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
	end

	inst:Remove()
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
	
	local zbowowner = inst.components.zupalexsrangedweapons.owner -- in this particular case, the "attacker" is actually the zbow, because the inst is the zarrow, and the "owner" of the zarrow is the zbow...
	
	if zbowowner == nil then
		zbowowner = attacker
	end
	
	if not target:IsInLimbo() then
		if hitscore <= misschance then	
			if zbowowner ~= nil and zbowowner.components and zbowowner.components.talker then
				local miss_message = "I should aim better next time!"
				zbowowner.components.talker:Say(miss_message)
			end
			if not ignoreattack then
				target:PushEvent("attacked", {attacker = zbowowner, damage = 0.1})
			end
			
			if inst.prefab == "explosivezbolt" and inst.components.zupalexsrangedweapons.specificOnHit then
				inst.components.zupalexsrangedweapons.specificOnHit(inst, zbowowner, target)
			end
			
			if canrecover and inst:HasTag("recoverable") then
				RecChance = inst.components.zupalexsrangedweapons:GetRecChance(false)

			
				if math.random() <= RecChance then
					local rdmshift = Vector3(math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random())
					local targposx, targposy, targposz = target.Transform:GetWorldPosition()
					local currentprojbasicammo = inst.components.zupalexsrangedweapons:GetBasicAmmo()
		--			print("currentprojbasic in miss = ", currentprojbasicammo)
					local recoveredzarrow = SpawnPrefab(currentprojbasicammo)
					recoveredzarrow.Transform:SetPosition((targposx + rdmshift.x), (targposy + rdmshift.y), (targposz + rdmshift.z))
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
				
			target.components.combat:GetAttacked(zbowowner, DamageToApply)
			
			if inst.components.zupalexsrangedweapons.specificOnHit then
				inst.components.zupalexsrangedweapons.specificOnHit(inst, zbowowner, target)
			end
			
			if canrecover and inst:HasTag("recoverable") then
				RecChance = inst.components.zupalexsrangedweapons:GetRecChance(true)
			
				if math.random() <= RecChance then
					if target.zarrowtorecover == nil then
						target.zarrowtorecover = {}
						target.zarrowtorecover[inst.prefab] = 1
					elseif target.zarrowtorecover ~= nil and target.zarrowtorecover[inst.prefab] == nil then
						target.zarrowtorecover[inst.prefab] = 1
					else
						target.zarrowtorecover[inst.prefab] = target.zarrowtorecover[inst.prefab] + 1
					end
					
					for k, v in pairs(target.zarrowtorecover) do
--						print(k, "  ->  ", v)
					end
--					print("****************************************")
					
					if target.RetrievePinnedzarrows == nil then
						if target.components.health and target.components.health:IsDead() then
							local recoveredzarrow = SpawnPrefab(inst.components.zupalexsrangedweapons:GetBasicAmmo())
							local rdmshift = Vector3(math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random())
							local targposx, targposy, targposz = target.Transform:GetWorldPosition()
							recoveredzarrow.Transform:SetPosition((targposx + rdmshift.x), (targposy + rdmshift.y), (targposz + rdmshift.z))
						else
							target.RetrievePinnedzarrows = function()
															target:DoTaskInTime(0.5, function() 
																						if target.zarrowtorecover ~= nil then
																							for k, v in pairs(target.zarrowtorecover) do
																								local NbrOfStack = math.ceil(v/20)
																								local LastStackSize = v - (NbrOfStack-1)*20
																								
																								local StS = 1 -- Stack to Spawn
																								while StS <= NbrOfStack do
																									local pinnedzarrow = SpawnPrefab(k)								
	--										--														print("zarrow to recover = ", pinnedzarrow.components.zupalexsrangedweapons:GetBasicAmmo())
																									local recoveredzarrow = SpawnPrefab(pinnedzarrow.components.zupalexsrangedweapons:GetBasicAmmo())
																									pinnedzarrow:Remove()
																									
																									if StS == NbrOfStack then
																										recoveredzarrow.components.stackable:SetStackSize(LastStackSize)
																									else
																										recoveredzarrow.components.stackable:SetStackSize(recoveredzarrow.components.stackable.maxsize)
																									end
																									
																									local rdmshift = Vector3(math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random())
																									local targposx, targposy, targposz = target.Transform:GetWorldPosition()
																									recoveredzarrow.Transform:SetPosition((targposx + rdmshift.x), (targposy + rdmshift.y), (targposz + rdmshift.z))
																									StS = StS+1
																								end
																							end						
																							target.zarrowtorecover = nil
																						end
																					end					
																				)
														end
							target:ListenForEvent("death", target.RetrievePinnedzarrows)
						end
					end
				end		
			end
		end	
	else
		if not inst.components.zupalexsrangedweapons.specificOnMiss then
			onmisszarrow_regular(inst, zbowowner, inst)
		else
			inst.components.zupalexsrangedweapons.specificOnMiss(inst, zbowowner, inst)
		end
	end
end

local function CalcFinalDamage(inst, attacker, target, applydodelta)
	local BaseDamage = inst.components.zupalexsrangedweapons:GetArrowBaseDamage()
	local DmgModifier = 1.0
	local DmgMultiplier = (attacker.components.combat.damagemultiplier or 1) -- Damage multiplier of a specific character
	
	local AdditionnalDmgMultiplier =
		(inst.components.zupalexsrangedweapons.stimuli == "electric" and
		not (target:HasTag("electricdamageimmune") or (target.components.inventory ~= nil and target.components.inventory:IsInsulated()))
		and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (target.components.moisture ~= nil and target.components.moisture:GetMoisturePercent() or (target:GetIsWet() and 1 or 0)))
		or 0
	
	if attacker ~= nil and attacker.components.sanity ~= nil then
		if inst.prefab == "lightarrow" then 
			if target:HasTag("shadowcreature") then
				DmgModifier = 1.6
				if applydodelta then attacker.components.sanity:DoDelta(5) end
			elseif not target:HasTag("hostile") then
				DmgModifier = 0.6
				if applydodelta then attacker.components.sanity:DoDelta(-10) end					
			end	
		elseif inst.prefab == "shadowarrow" then 
			if target:HasTag("shadowcreature")then
				DmgModifier = 0.2
				if applydodelta then attacker.components.sanity:DoDelta(-10) end
			else 
				if applydodelta then attacker.components.sanity:DoDelta(-2) end
			end
		elseif inst.prefab == "healingarrow" then 
			if target:HasTag("hostile")then
				if applydodelta then attacker.components.sanity:DoDelta(-15) end
			elseif target:HasTag("player")then
				if applydodelta then attacker.components.sanity:DoDelta(-5) end
			end
		end
	end
	
	return BaseDamage*(DmgModifier*DmgMultiplier + AdditionnalDmgMultiplier)
end

function OnHitCommon(inst, attacker, target)			
	print(attacker, " attacked ", target, " with ", inst)
	print("Final Damage = ", CalcFinalDamage(inst, attacker, target, false))

	HITorMISSHandler(inst, attacker, target, CalcFinalDamage(inst, attacker, target, true), true, true)

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

function OnCollide(inst, other)
	local zupaproj = inst.components.zupalexsrangedweapons
	local attacker = GetPlayer()

	if not attacker then
		inst:Remove()
		return
	end
	
	-- print("Collision between ", tostring(inst), " and ", tostring(other))
	
	if not (other:HasTag("campfire") or other:HasTag("watersource")) then
		if inst.components.zupalexsrangedweapons ~= nil and not inst:HasTag("explosive") then
			if other.components.combat ~= nil and other:IsValid() and not other:IsInLimbo() and not other:HasTag("wall") then
				HITorMISSHandler(inst, attacker, other, CalcFinalDamage(inst, other, true), false, false)
			elseif inst:HasTag("recoverable") then
				local inst_x, inst_y, inst_z = inst.Transform:GetWorldPosition()
				local obstacle_x, obstacle_y, obstacle_z = other.Transform:GetWorldPosition()
				local currentprojbasicammo = inst.components.zupalexsrangedweapons:GetBasicAmmo()
				local recoveredzarrow = SpawnPrefab(currentprojbasicammo)
				recoveredzarrow.Transform:SetPosition((2*inst_x-obstacle_x), (2*inst_y-obstacle_y), (2*inst_z-obstacle_z))
			end
		elseif inst:HasTag("explosive") and inst.specificOnHit then
			inst.specificOnHit(inst, attacker, other)
		end
 
		if inst:IsValid() then
			inst:Remove()
		end		
	elseif other:HasTag("campfire") or other:HasTag("watersource") then
--		print("Low obstalce encountered")
		RemovePhysicsColliders(inst)
		inst.Physics:CollidesWith(COLLISION.GROUND)
		inst.Physics:CollidesWith(COLLISION.OBSTACLES)
	end
end

function OnThrownRegular(inst, data)
	inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
	if inst.Physics ~= nil and not inst:HasTag("nocollisionoverride") then
		inst.Physics:ClearCollisionMask()
		inst.Physics:CollidesWith(COLLISION.GROUND)
		if TUNING.COLLISIONSAREON then
			inst.Physics:CollidesWith(COLLISION.OBSTACLES)
		end
	end
	local attacker = FindEntity(inst, 1.8, nil, { "player" })
	print("I check for the attacker -> ", attacker or "NOT FOUND!")
	if attacker then 
		-- inst.components.projectile.owner = attacker 
		DoPostAttackTask(inst, attacker)	
	end
end