local assets=
{
    Asset("ANIM", "anim/zbow.zip"),
    Asset("ANIM", "anim/swap_zbow.zip"),
	
    Asset("ATLAS", "images/inventoryimages/zbow.xml"),
    Asset("IMAGE", "images/inventoryimages/zbow.tex"),

---------------------------------------------------------------------

    Asset("ANIM", "anim/swap_zmagicbow.zip"),
	
    Asset("ATLAS", "images/inventoryimages/zmagicbow.xml"),
    Asset("IMAGE", "images/inventoryimages/zmagicbow.tex"),

}
prefabs = {
	"sparkles",
	"zarrow",
	"goldzarrow",
	"moonstonezarrow",
	"firezarrow",
	"icezarrow",
	"thunderzarrow",
	"dischargedthunderzarrow",
	"shadowzarrow",
	"lightzarrow",
	"healingzarrow",
}

----------------------------------------------------------------------------zbowS--------------------------------------------------------------

local function onattack(inst, attacker, target)
    if target.components.sleeper and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end

    if target.components.combat then
        target.components.combat:SuggestTarget(attacker)
    end
end

local function AssignProjInQuiver(inst, owner)
	local quiver = owner.components.inventory and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
	
	if quiver then
		local projinquiver = quiver.components.container:GetItemInSlot(1)
		if projinquiver then
			inst.components.weapon:SetProjectile(projinquiver.prefab)
		end
	end
end

local function OnEquipzbow(inst, owner)	
	AssignProjInQuiver(inst, owner)

    owner.AnimState:OverrideSymbol("swap_object", "swap_zbow", "swap_bow")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
 
local function OnUnequipzbow(inst, owner)	
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function zbowfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
     
    anim:SetBank("bow")
    anim:SetBuild("zbow")
    anim:PlayAnimation("bow_idle")
 
	inst:AddTag("ranged")
	inst:AddTag("zbow")
	inst:AddTag("usequiverproj")
	
	if TUNING.BOWUSES < 201 then
		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(TUNING.BOWUSES)
		inst.components.finiteuses:SetUses(TUNING.BOWUSES)
		inst.components.finiteuses:SetOnFinished(inst.Remove)
	end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "zbow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/zbow.xml"
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquipzbow )
    inst.components.equippable:SetOnUnequip( OnUnequipzbow )
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange((TUNING.BOWRANGE-2), TUNING.BOWRANGE)
    inst.components.weapon:SetProjectile("zarrow")
	inst.components.weapon:SetOnAttack(onattack)
	
	inst:AddComponent("zupalexsrangedweapons")
	inst.components.zupalexsrangedweapons:SetAllowedProjectiles( { "zarrow", "zgoldarrow", "zmoonstonearrow", "zfirearrow", "zicearrow", "zthunderarrow", "zdischargedthunderarrow" } )
	inst.components.zupalexsrangedweapons:SetCooldownTime(1.3)
 
    return inst
end

----------------------------------------------------------------------------------------------MAGIC zbow-----------------------------------------------------------------

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

local function OnEquipzmagicbow(inst, owner)	
	owner.AnimState:OverrideSymbol("swap_object", "swap_zmagicbow", "swap_magicbow")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
		inst:AddTag("hasfuel")
	end
	
	if inst:HasTag("hasfuel") then
		inst.Light:Enable(true)
		SpawnSparkles(inst, owner)
	end
	
	if inst.components.weapon.projectile == "healingzarrow" and not inst:HasTag("healer") then
		inst:AddTag("healer")
	end		
end
 
local function OnUnequipzmagicbow(inst, owner)	
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

	if inst.sparkles01 ~= nil then
        inst.sparkles01:SetFollowTarget(nil)
        inst.sparkles01 = nil
		inst:RemoveEventCallback("locomote", inst.onlocomote, owner)
    end
	
	inst.Light:Enable(false)
end

local function zmagicbow_empty(inst)
	if inst.sparkles01 ~= nil then
        inst.sparkles01:SetFollowTarget(nil)
        inst.sparkles01 = nil
    end
	
	inst.Light:Enable(false)
	
	if inst:HasTag("hasfuel") then
		inst:RemoveTag("hasfuel")
	end
end

local function zmagicbowCanAcceptFuelItem(self, item)
	if item ~= nil and item.components.fuel ~= nil and (item.components.fuel.fueltype == "ZUPALEX" or item.prefab == "nightmarefuel") then
		return true
	else
		return false
	end
end

local function zmagicbowTakeFuel(self, item)		
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

local function zmagicbowOnSave(self)
    if self.currentfuel > 0 then
        return {fuel = self.currentfuel}
    end
end

local function zmagicbowfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
	
    anim:SetBank("magicbow")
    anim:SetBuild("zbow")
    anim:PlayAnimation("magicbow_idle")
 
 	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.8)
	inst.Light:SetRadius(0.5)
	inst.Light:SetFalloff(0.33)
	inst.Light:SetColour(204/255, 0/255, 255/255)
	inst.Light:Enable(false)
 
	inst:AddTag("ranged")
	inst:AddTag("magic")
	inst:AddTag("zbow")
	
----------------------------------------------------------------
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "zmagicbow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/zmagicbow.xml"
	inst.components.inventoryitem:SetOnDroppedFn(function(inst) inst.Light:Enable(false) end)
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquipzmagicbow )
    inst.components.equippable:SetOnUnequip( OnUnequipzmagicbow )
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange((TUNING.BOWRANGE - 2), TUNING.BOWRANGE)
    inst.components.weapon:SetProjectile("shadowzarrow")
	inst.components.weapon:SetOnAttack(onattack)
	
	inst:AddComponent("zupalexsrangedweapons")
	inst.components.zupalexsrangedweapons:SetCooldownTime(1.3)
	
	inst:AddComponent("fueled")
	inst.components.fueled.accepting = true
	inst.components.fueled.fueltype = "ZUPALEX"
	inst:AddTag("NIGHTMARE_fueled") -- to accept the nightmarefuel as well without modifying the fueltype of the nightmarefuel (better compatibility sake)
	inst.components.fueled.maxfuel = 10
	inst.components.fueled:StopConsuming()
	inst.components.fueled.CanAcceptFuelItem = zmagicbowCanAcceptFuelItem
	inst.components.fueled.TakeFuelItem = zmagicbowTakeFuel
	inst.components.fueled.OnSave = zmagicbowOnSave
	inst.components.fueled:SetDepletedFn(zmagicbow_empty)

    return inst
end

return  Prefab("common/inventory/zbow", zbowfn, assets, prefabs),
		Prefab("common/inventory/zmagicbow", zmagicbowfn, assets, prefabs)