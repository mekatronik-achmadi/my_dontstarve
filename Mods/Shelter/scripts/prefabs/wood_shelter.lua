
local assets =
{
	Asset("ANIM", "anim/siesta_shelter.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle", true)
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle", true)
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    
    anim:SetBank("wood_shelter")
    anim:SetBuild("siesta_shelter")
    anim:PlayAnimation("idle", true)
   
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "siesta_shelter.tex" )

	if IsDLCEnabled(REIGN_OF_GIANTS)
	or 
	IsDLCEnabled(CAPY_DLC) 
	then
    inst:AddTag("shelter")
    inst:AddTag("dryshelter")
end    

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	inst:ListenForEvent( "onbuilt", onbuilt)

    return inst
end

return Prefab("common/wood_shelter", fn, assets),
	MakePlacer( "common/wood_shelter_placer", "wood_shelter", "siesta_shelter", "idle" ) 
