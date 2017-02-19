local assets = 
{
	Asset("ANIM", "anim/glommer_fuel.zip"),
}

local prefabs = {}

local boy = nil

local function OnEaten(inst)
    if boy.components.talker then
	local say_word = "It taste as sweet as her butt hole"
	boy.components.talker:Say(say_word)
    end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

	MakeInventoryPhysics(inst)

	anim:SetBank("glommer_fuel")
	anim:SetBuild("glommer_fuel")
	anim:PlayAnimation("idle")

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst:AddComponent("stackable")
	inst:AddComponent("tradable")

	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	MakeSmallPropagator(inst)
	inst.components.burnable:MakeDragonflyBait(3)

	inst:AddComponent("fertilizer")
	inst.components.fertilizer.fertilizervalue = TUNING.GLOMMERFUEL_FERTILIZE
	inst.components.fertilizer.soil_cycles = TUNING.GLOMMERFUEL_SOILCYCLES

	inst:AddComponent("bait")
	inst:AddComponent("edible")
	inst.components.edible.foodtype = "GIRLPOOP"
	inst.components.edible.healthvalue = TUNING.HEALING_SMALL
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
	inst.components.edible.sanityvalue = -TUNING.SANITY_MED
	inst.components.edible:SetOnEatenFn(OnEaten)
	
	inst.Transform:SetScale(0.3,0.3,0.3)
	
	boy = GetPlayer()
	
	return inst
end

return Prefab("glommerfuel", fn, assets, prefabs)
