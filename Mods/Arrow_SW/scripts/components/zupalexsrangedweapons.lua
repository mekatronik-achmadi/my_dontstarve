--Update inventoryitem_replica constructor if any more properties are added

local function onattackrange(self, attackrange)
    if self.inst.replica.inventoryitem ~= nil then
        self.inst.replica.inventoryitem:SetAttackRange(attackrange)
    end
end

local Zupalexsrangedweapons = Class(function(self, inst)
    self.inst = inst
	self.zarrowbasedamage = 0
	self.owner = nil
	self.allowedprojectiles ={}
	self.cooldowntime = nil
	self.fueledby = nil
	self.targx = nil
	self.targy = nil
	self.targz = nil
	
	self.lastattacktime = nil
	
	self.onarmed = nil
	
	self.specificOnHit = nil
	self.specificOnMiss = nil

    self.inst:AddTag("zupalexsrangedweapons")
end,
nil,
{
    attackrange = onattackrange,
})

function Zupalexsrangedweapons:OnRemoveFromEntity()
    if self.inst.replica.inventoryitem ~= nil then
        self.inst.replica.inventoryitem:SetAttackRange(-1)
    end
end

function Zupalexsrangedweapons:SetSpecificOnHitfn(specOnHitfn)
	self.specificOnHit = specOnHitfn
end

function Zupalexsrangedweapons:SetSpecificOnMissfn(specOnMissfn)
	self.specificOnMiss = specOnMissfn
end

function Zupalexsrangedweapons:SetOnArmedFn(onarmedfn)
	self.onarmed = onarmedfn
end

function Zupalexsrangedweapons:OnArmed(armer)
	if self.onarmed then
		self.onarmed(self.inst, armer)
	end
end

function Zupalexsrangedweapons:SetTargetPosition(x, y, z)
	self.targx = x
	self.targy = y
	self.targz = z	
end

function Zupalexsrangedweapons:GetTargetPosition()
	return self.targx, self.targy, self.targz
end

function Zupalexsrangedweapons:SetCooldownTime(cdtime)
	self.cooldowntime = cdtime
end

function Zupalexsrangedweapons:GetCooldownTime()
	return self.cooldowntime
end

function Zupalexsrangedweapons:GetArrowBaseDamage()
	if self.inst.prefab == "zarrow" then
		return TUNING.BOWDMG
	elseif self.inst.prefab == "goldzarrow" then
		return TUNING.BOWDMG*TUNING.GOLDARROWDMGMOD
	elseif self.inst.prefab == "moonstonezarrow" then
		return TUNING.BOWDMG*TUNING.MOONSTONEARROWDMGMOD
	elseif self.inst.prefab == "firezarrow" then
		return TUNING.BOWDMG*(TUNING.FIREARROWDMGMOD/2.0)
	elseif self.inst.prefab == "icezarrow" then
		return TUNING.BOWDMG*TUNING.ICEARROWDMGMOD
	elseif self.inst.prefab == "thunderzarrow" or self.inst.prefab == "dischargedthunderzarrow" then
		return TUNING.BOWDMG*TUNING.THUNDERARROWDMGMOD
	elseif self.inst.prefab == "zbolt" then
		return TUNING.BOWDMG*TUNING.CROSSBOWDMGMOD
	elseif self.inst.prefab == "poisonzbolt" then
		return TUNING.BOWDMG*TUNING.CROSSBOWDMGMOD*0.15
	elseif self.inst.prefab == "explosivezbolt" then
		return 10
	elseif self.inst.prefab == "shadowzarrow" then
		return TUNING.BOWDMG*TUNING.MAGICBOWDMGMOD
	elseif self.inst.prefab == "lightzarrow" then
		return TUNING.BOWDMG*TUNING.MAGICBOWDMGMOD
	elseif self.inst.prefab == "healingzarrow" then
		return 0
	elseif self.inst.prefab == "zmusket_bullet" then
		return TUNING.BOWDMG*TUNING.MUSKETDMGMOD
	end
end

function Zupalexsrangedweapons:SetAllowedProjectiles(projlist)
	self.allowedprojectiles = projlist
end

function Zupalexsrangedweapons:AddAllowedProjectiles(projname)
	table.insert(self.allowedprojectiles, projname)
end

function Zupalexsrangedweapons:GetBasicAmmo()
	if self.inst:HasTag("zarrow") then
		if self.inst:HasTag("golden") then
			return string.lower("goldzarrow")
		elseif self.inst:HasTag("moonstone") then
			return string.lower("moonstonezarrow")
		elseif self.inst:HasTag("electric") then
			return string.lower("dischargedthunderzarrow")
		else
			return string.lower("zarrow")
		end
	elseif self.inst:HasTag("zbolt") then
		if self.inst:HasTag("poison") then
			return string.lower("poisonzbolt")
		else
			return string.lower("zbolt")
		end
	end
end

function Zupalexsrangedweapons:GetMissChance()
	if self.inst:HasTag("zarrow") then
		return TUNING.BOWMISSCHANCESMALL, TUNING.BOWMISSCHANCEBIG
	elseif self.inst:HasTag("zbolt") then
		return TUNING.BOWMISSCHANCESMALL*TUNING.CROSSBOWACCMOD, TUNING.BOWMISSCHANCEBIG*TUNING.CROSSBOWACCMOD
	elseif self.inst:HasTag("zbullet") then
		return TUNING.BOWMISSCHANCESMALL*TUNING.MUSKETACCMOD, TUNING.BOWMISSCHANCEBIG*TUNING.MUSKETACCMOD
	end
end

function Zupalexsrangedweapons:GetRecChance(hit)
	local RecChance

	if hit then
		RecChance = TUNING.HITREC
	else
		RecChance = TUNING.MISSREC
	end

	if self.inst:HasTag("zarrow") then
		if self.inst:HasTag("golden") then
			return (RecChance*TUNING.GOLDARROWRECCHANCEMOD)
		elseif self.inst:HasTag("moonstone") then
			return 0.99
		else
			return RecChance
		end
	elseif self.inst:HasTag("zbolt") then
		return RecChance
	end
end

function Zupalexsrangedweapons:SetFueledBy(itemprefab)
	self.fueledby = itemprefab
end

function Zupalexsrangedweapons:MBSetNewProjectile(itemprefab)
	local currentproj = self.projectile
	
	local newproj = nil
	local lightR, lightG, lightB = nil, nil, nil
	
	if itemprefab == "nightmarefuel" then
		newproj = string.lower("shadowzarrow")
		lightR = 204/255
		lightG = 0/255
		lightB = 255/255
	elseif itemprefab == "z_firefliesball" then
		newproj = string.lower("lightzarrow")	
		lightR = 255/255
        lightG = 253/255
		lightB = 54/255
	elseif itemprefab == "z_bluegoop" then
		newproj = string.lower("healingzarrow")	
		lightR = 247/255
		lightG = 116/255
		lightB = 255/255
	end
	
	if newproj ~= nil then
		self:SetFueledBy(itemprefab)
	
--		print("current proj = ", currentproj or "UNAVAILABLE", " / new proj = ", newproj or "UNAVAILABLE")
	
		if currentproj ~= newproj then
			if self.inst:HasTag("healer") and not newproj == "z_bluegoop" then
				self.inst:RemoveTag("healer")
			end
		
			self.inst.Light:SetColour(lightR, lightG, lightB)
			self.inst.components.weapon:SetProjectile(newproj)
			
--			print("I successfuly set a new projectile : ", self.projectile)
			
			return true
		else
			return false
		end
	end	
end

function Zupalexsrangedweapons:OnSave()
    if self.inst:HasTag("magic") and self.inst:HasTag("zbow") and self.fueledby ~= nil then
        return {fueledby = self.fueledby}
    end
end

function Zupalexsrangedweapons:OnLoad(data)
    if self.inst:HasTag("magic") and self.inst:HasTag("zbow") and data.fueledby then
--		print("I load stuffs")
        self:MBSetNewProjectile(data.fueledby)
    end
end

-- function Zupalexsrangedweapons:CollectEquippedActions(doer, target, actions, right)
	-- if not target:HasTag("wall")
		-- and not doer.components.combat:IsAlly(target)
		-- and doer.components.combat ~= nil
		-- and not target:HasTag("chester")
		-- and doer.components.combat:CanTarget(target)
		-- and target.components.combat:CanBeAttacked(doer)
		-- then
			-- if not right then
				-- if self.inst:HasTag("zbow") then
					-- table.insert(actions, ACTIONS.BOWATTACK)
				-- elseif self.inst:HasTag("zcrossbow") then
					-- table.insert(actions, ACTIONS.CROSSBOWATTACK)
				-- end
			-- end
	-- end
-- end

function Zupalexsrangedweapons:CollectInventoryActions(doer, actions)
	local quiver = doer.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
	local equiphand = doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	
	if self.inst.components.inventoryitem ~= nil then
--		local iteminquiver = quiver.components.container:GetItemInSlot(1)
		if quiver ~= nil and
			self.inst:HasTag("zupalexsrangedweapons") and (self.inst:HasTag("zarrow") or self.inst:HasTag("zbolt")) and
			quiver:HasTag("zupalexsrangedweapons") and quiver.components.container~= nil
			then
				table.insert(actions, ACTIONS.CHANGEARROWTYPE)
		elseif self.inst:HasTag("zupalexsrangedweapons") and (self.inst:HasTag("zcrossbow") or self.inst:HasTag("zmusket")) and self.inst == equiphand then
			table.insert(actions, ACTIONS.ARMCROSSBOW)
		end
	end
end

function Zupalexsrangedweapons:CollectUseActions(doer, target, actions)
	if self.inst:HasTag("zupalexsrangedweapons") and self.inst:HasTag("electric") and self.inst:HasTag("discharged") and 
		target.prefab == "lightning_rod" and target.chargeleft
		then
			table.insert(actions, ACTIONS.TRANSFERCHARGETOPROJECTILE)
	elseif self.inst:HasTag("zbullet") and target:HasTag("zmusket") then
		table.insert(actions, ACTIONS.ARMCROSSBOW)
	end
end

function Zupalexsrangedweapons:OnUpdate(dt)	
	if self.inst.prefab == "zquiver" then
		print("I am a quiver!")
	end
end

function Zupalexsrangedweapons:LongUpdate(dt)
	self:OnUpdate(dt)
end

return Zupalexsrangedweapons