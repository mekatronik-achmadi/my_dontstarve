local assets=
{ 	
	Asset("ATLAS", "images/inventoryimages/zmusket_bullet.xml"),
    Asset("IMAGE", "images/inventoryimages/zmusket_bullet.tex"),
}
prefabs = {
    "zmusketsmoke",
}

local function shootzmusketbullet(inst)
	local smoke = SpawnPrefab("zmusketsmoke")
	local smokeposx, smokeposy, smokeposz = inst.Transform:GetWorldPosition()
	smoke.Transform:SetPosition(smokeposx, smokeposy, smokeposz)
	smoke.AnimState:SetScale(0.5,0.5,-1)
	
    inst.AnimState:PlayAnimation("flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function zmusket_bulletfn() 
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
 
    MakeInventoryPhysics(inst)
 
 	anim:SetBank("zbullet")
    anim:SetBuild("zmusket")
    anim:PlayAnimation("idle")
 
	inst:AddTag("projectile")
	inst:AddTag("zbullet")
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "zmusket_bullet"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/zmusket_bullet.xml"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
	inst:AddComponent("projectile")	
	inst.components.projectile:SetSpeed(80)
	inst.components.projectile:SetOnHitFn(OnHitCommon)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetLaunchOffset(Vector3(1, 1.05, 0))
	inst.components.projectile:SetOnThrownFn(shootzmusketbullet)
	inst:ListenForEvent("onthrown", OnThrownRegular)
	
	inst:AddComponent("zupalexsrangedweapons")
	 
    return inst
end

return  Prefab("common/inventory/zmusket_bullet", zmusket_bulletfn, assets, prefabs)