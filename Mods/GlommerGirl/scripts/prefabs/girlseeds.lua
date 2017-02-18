require "prefabs/veggies"
local assets=
{
	Asset("ANIM", "anim/seeds.zip"),
}

local prefabs ={}    

for k,v in pairs(VEGGIES) do
	table.insert(prefabs, k)
end

local function pickproduct(inst)
	
	local total_w = 0
	for k,v in pairs(VEGGIES) do
		total_w = total_w + (v.seed_weight or 1)
	end
	
	local rnd = math.random()*total_w
	for k,v in pairs(VEGGIES) do
		rnd = rnd - (v.seed_weight or 1)
		if rnd <= 0 then
			return k
		end
	end
	
	return "carrot"
end

local boy = nil

local function OnEaten(inst)
    if boy.components.talker then
	local say_word = "It's so soft like her butt hole"
	boy.components.talker:Say(say_word)
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("seeds")
    inst.AnimState:SetBuild("seeds")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true)
    
    inst:AddComponent("bait")
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "GIRLPOOP"
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY
    inst.components.edible.sanityvalue = -TUNING.SANITY_TINY
    inst.components.edible:SetOnEatenFn(OnEaten)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("seeds")
    
    inst:AddComponent("plantable")
    inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
    inst.components.plantable.product = pickproduct
    
    inst.Transform:SetScale(0.5,0.5,0.5)
    
    boy = GetPlayer()
    
    return inst
end

return Prefab( "common/inventory/girlseeds", fn, assets, prefabs)
