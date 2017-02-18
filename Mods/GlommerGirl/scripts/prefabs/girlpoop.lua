local assets =
{
	Asset("ANIM", "anim/poop.zip"),
}

local prefabs =
{
    "flies",
    "poopcloud",
}

local function OnBurn(inst)
    DefaultBurnFn(inst)
    if inst.flies then
        inst.flies:Remove()
        inst.flies = nil
    end   
end

local function FuelTaken(inst, taker)
    local cloud = SpawnPrefab("poopcloud")
    if cloud then
        cloud.Transform:SetPosition(taker.Transform:GetWorldPosition() )
    end
end

local boy = nil

local function OnEaten(inst)
    if boy.components.talker then
        local say_word = "It feels like her butt hole filling my mouth"
        boy.components.talker:Say(say_word)
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("poop")
    inst.AnimState:SetBuild("poop")
    inst.AnimState:PlayAnimation("dump")
    inst.AnimState:PushAnimation("idle")
    
    inst:AddComponent("stackable")
    inst:AddComponent("inspectable")
    inst:AddComponent("smotherer")
    inst:AddComponent("tradable")

    inst:AddComponent("fertilizer")
    inst.components.fertilizer.fertilizervalue = TUNING.POOP_FERTILIZE
    inst.components.fertilizer.soil_cycles = TUNING.POOP_SOILCYCLES
    inst.components.fertilizer.withered_cycles = TUNING.POOP_WITHEREDCYCLES

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(function() inst.flies = inst:SpawnChild("flies") end )
    inst.components.inventoryitem:SetOnPickupFn(function() if inst.flies then inst.flies:Remove() inst.flies = nil end end )
    inst.components.inventoryitem:SetOnPutInInventoryFn(function() if inst.flies then inst.flies:Remove() inst.flies = nil end end )
    inst.components.inventoryitem:ChangeImageName("poop")
    
    inst.flies = inst:SpawnChild("flies")
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    inst.components.fuel:SetOnTakenFn(FuelTaken)
    
    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    inst.components.burnable:SetOnIgniteFn(OnBurn)
    MakeSmallPropagator(inst)
    inst.components.burnable:MakeDragonflyBait(3)
    
    ---------------------        
    
    inst.Transform:SetScale(0.3,0.3,0.3)
    
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "GIRLPOOP"
	inst.components.edible.healthvalue = TUNING.HEALING_TINY
	inst.components.edible.hungervalue = TUNING.CALORIES_MED
	inst.components.edible.sanityvalue = -TUNING.SANITY_MED
	inst.components.edible:SetOnEatenFn(OnEaten)
    
    boy = GetPlayer()
    
    return inst
end

return Prefab( "common/inventory/girlpoop", fn, assets, prefabs) 

