local assets=
{
	Asset("ANIM", "anim/zcrossbow.zip"),
    Asset("ANIM", "anim/swap_zcrossbow.zip"),
	 
    Asset("ATLAS", "images/inventoryimages/zcrossbow.xml"),
    Asset("IMAGE", "images/inventoryimages/zcrossbow.tex"),
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

local function onarmedxzbow(inst, armer)
	inst:AddTag("readytoshoot")
	armer.AnimState:OverrideSymbol("swap_object", "swap_zcrossbow", "swap_crossbow_armed")
end

local function OnEquipXzbow(inst, owner)
	if inst:HasTag("readytoshoot") then
		owner.AnimState:OverrideSymbol("swap_object", "swap_zcrossbow", "swap_crossbow_armed")
	else
		owner.AnimState:OverrideSymbol("swap_object", "swap_zcrossbow", "swap_crossbow")
	end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
 
local function OnUnequipXzbow(inst, owner)	
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function zcrossbowfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
     
    anim:SetBank("crossbow")
    anim:SetBuild("zcrossbow")
    anim:PlayAnimation("crossbow_idle")
 
	inst:AddTag("zcrossbow")
	inst:AddTag("ranged")
	inst:AddTag("usequiverproj")
	
	if TUNING.BOWUSES < 201 then
		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(TUNING.BOWUSES)
		inst.components.finiteuses:SetUses(TUNING.BOWUSES)
		inst.components.finiteuses:SetOnFinished(inst.Remove)
	end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "zcrossbow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/zcrossbow.xml"
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquipXzbow )
    inst.components.equippable:SetOnUnequip( OnUnequipXzbow )
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange((TUNING.BOWRANGE*TUNING.CROSSBOWRANGEMOD - 2), TUNING.BOWRANGE*TUNING.CROSSBOWRANGEMOD)
    inst.components.weapon:SetProjectile("zbolt")
	inst.components.weapon:SetOnAttack(onattack)
	
	inst:AddComponent("zupalexsrangedweapons")
	inst.components.zupalexsrangedweapons:SetAllowedProjectiles( { "zbolt", "poisonzbolt", "explosivezbolt"} )
	inst.components.zupalexsrangedweapons:SetCooldownTime(1.5)
	inst.components.zupalexsrangedweapons:SetOnArmedFn(onarmedxzbow)
 
    return inst
end

return  Prefab("common/inventory/zcrossbow", zcrossbowfn, assets, prefabs)