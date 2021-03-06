require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/path_light.zip"),
}

local function onhammered(inst, worker)
        SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst:Remove()
        inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
end

local function updatelight(inst)
    if GetClock():IsDay() then
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("idle_off")
        inst.lighton = false

    else

        inst.Light:Enable(true)
        inst.Light:SetRadius(2)
        inst.Light:SetFalloff(.8)
        inst.Light:SetIntensity(.5)
        inst.Light:SetColour(255/255,255/255,255/255)
        inst.AnimState:PlayAnimation("idle_on")
        inst.lighton = true

    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()        

    inst.entity:AddLight()
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetRayTestOnBB(true)

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("path_light")
    inst.AnimState:SetBuild("path_light")
    inst.AnimState:PlayAnimation("idle_off")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("inspectable")

    inst:DoPeriodicTask(2, function() updatelight(inst) end)

    return inst
end

return Prefab("common/objects/path_light", fn, assets),
    MakePlacer( "common/path_light_placer", "path_light", "path_light", "idle_off" )
