local assets =
{
    Asset("ANIM", "anim/zupalexsingredients.zip"),
	
	Asset("ATLAS", "images/inventoryimages/firefliesball.xml"),
    Asset("IMAGE", "images/inventoryimages/firefliesball.tex"),
	
	Asset("ATLAS", "images/inventoryimages/bluegoop.xml"),
    Asset("IMAGE", "images/inventoryimages/bluegoop.tex"),
}


local function z_firefliesballfn(proxy)
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

	inst.Transform:SetFourFaced()
	
    inst.AnimState:SetBank("firefliesball")
    inst.AnimState:SetBuild("zupalexsingredients")
    inst.AnimState:PlayAnimation("idle")
	
	-----------------------------------------------------

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM    
    inst:AddComponent("inspectable")
    inst:AddComponent("fuel")
    inst.components.fuel.fueltype = "ZUPALEX"

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "firefliesball"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/firefliesball.xml"
	
    return inst
end

local function z_bluegoopfn(proxy)
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

	inst.Transform:SetFourFaced()
	
    inst.AnimState:SetBank("bluegoop")
    inst.AnimState:SetBuild("zupalexsingredients")
    inst.AnimState:PlayAnimation("idle", true)
	
	-----------------------------------------------------

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM    
    inst:AddComponent("inspectable")
    inst:AddComponent("fuel")
    inst.components.fuel.fueltype = "ZUPALEX"

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "bluegoop"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bluegoop.xml"
	
    return inst
end

return 	Prefab("common/inventory/z_firefliesball", z_firefliesballfn, assets, prefabs),
		Prefab("common/inventory/z_bluegoop", z_bluegoopfn, assets, prefabs)
