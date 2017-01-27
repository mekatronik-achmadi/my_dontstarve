local assets=
{
	Asset("ANIM", "anim/zmusket.zip"),
    Asset("ANIM", "anim/swap_zmusket.zip"),
	 
    Asset("ATLAS", "images/inventoryimages/zmusket.xml"),
    Asset("IMAGE", "images/inventoryimages/zmusket.tex"),
}
prefabs = {

}

------------------------------------------------------------ zcrossbowS ------------------------------------------------------------

local function onattack(inst, attacker, target)
    if target.components.sleeper and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end

    if target.components.combat then
        target.components.combat:SuggestTarget(attacker)
    end
end

local function OnEquipMusket(inst, owner)
	-- owner.replica.combat._attackrange:set(TUNING.BOWRANGE*TUNING.MUSKETRANGEMOD)

    owner.AnimState:OverrideSymbol("swap_object", "swap_zmusket", "swap_zmusket")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
 
local function OnUnequipMusket (inst, owner)	
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onarmedmusket(inst, armer, projtouse)
	if not inst:HasTag("readytoshoot") then		
		local inventory = armer.components.inventory
		if projtouse then
			if inventory and inventory:Has(projtouse, 1) then
				inventory:ConsumeByName(projtouse, 1)
				inst:AddTag("readytoshoot")
			end
		elseif inventory and inventory:Has("zmusket_bullet", 1) then
			inventory:ConsumeByName("zmusket_bullet", 1)
			inst:AddTag("readytoshoot")
		elseif inventory and inventory:Has("musket_silverbullet", 1) then
			inventory:ConsumeByName("zmusket_silverbullet", 1)
			inst:AddTag("readytoshoot")
		end
	end
end

local function OnSaveMusket(inst, data)
	if inst:HasTag("readytoshoot") then
		data.loaded = 1
	end
end

local function OnLoadMusket(inst, data)
	if data~= nil and data.loaded and data.loaded == 1 then
		inst:AddTag("readytoshoot")
	end
end

local function zmusketfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
     
    anim:SetBank("zmusket")
    anim:SetBuild("zmusket")
    anim:PlayAnimation("musket_idle")
 
	inst:AddTag("zmusket")
	inst:AddTag("ranged")
	
	if TUNING.BOWUSES < 201 then
		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(TUNING.BOWUSES)
		inst.components.finiteuses:SetUses(TUNING.BOWUSES)
		inst.components.finiteuses:SetOnFinished(inst.Remove)
	end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "zmusket"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/zmusket.xml"
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquipMusket )
    inst.components.equippable:SetOnUnequip( OnUnequipMusket )
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange((TUNING.BOWRANGE*TUNING.MUSKETRANGEMOD-2), TUNING.BOWRANGE*TUNING.MUSKETRANGEMOD)
    inst.components.weapon:SetProjectile("zmusket_bullet")
	inst.components.weapon:SetOnAttack(onattack)
	
	inst:AddComponent("zupalexsrangedweapons")
	inst.components.zupalexsrangedweapons:SetOnArmedFn(onarmedmusket)
	inst.components.zupalexsrangedweapons:SetAllowedProjectiles( { "zmusket_bullet" } )
	inst.components.zupalexsrangedweapons:SetCooldownTime(1.3)
	
	inst.OnSave = OnSaveMusket
	inst.OnLoad = OnLoadMusket
 
    return inst
end

return  Prefab("common/inventory/zmusket", zmusketfn, assets, prefabs)