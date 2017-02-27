local assets=
{
	Asset("ANIM", "anim/lantern.zip"),
	Asset("ANIM", "anim/swap_lantern.zip"),
	Asset("SOUND", "sound/wilson.fsb"),
	Asset("INV_IMAGE", "lantern_lit"),
}

local function turnon(inst)
    if not inst.components.machine.ison then

        inst.Light:Enable(true)
        inst.AnimState:PlayAnimation("idle_on")

        if inst.components.equippable:IsEquipped() then
            inst.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_object", "swap_lantern", "swap_lantern_on")
            inst.components.inventoryitem.owner.AnimState:Show("LANTERN_OVERLAY") 
            
        end
        inst.components.machine.ison = true

        inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_LP", "loop")

        inst.components.inventoryitem:ChangeImageName("lantern_lit")
    end
end

local function turnoff(inst)

    inst.Light:Enable(false)
    inst.AnimState:PlayAnimation("idle_off")

    if inst.components.equippable:IsEquipped() then
        inst.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_object", "swap_lantern", "swap_lantern_off")
        inst.components.inventoryitem.owner.AnimState:Hide("LANTERN_OVERLAY") 
    end

    inst.components.machine.ison = false

    inst.SoundEmitter:KillSound("loop")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_off")

    inst.components.inventoryitem:ChangeImageName("lantern")
end

local function OnLoad(inst, data)
    if inst.components.machine and inst.components.machine.ison then
        inst.AnimState:PlayAnimation("idle_on")
        turnon(inst)
    else
        inst.AnimState:PlayAnimation("idle_off")
        turnoff(inst)
    end
end

local function ondropped(inst)
    turnoff(inst)
    turnon(inst)
end

local function onpickup(inst)
	turnon(inst)
end

local function onputininventory(inst)
    turnoff(inst)
end
--
local function onequip(inst, owner) 
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:OverrideSymbol("lantern_overlay", "swap_lantern", "lantern_overlay")
	
    
    owner.AnimState:OverrideSymbol("swap_object", "swap_lantern", "swap_lantern_on")
    owner.AnimState:Show("LANTERN_OVERLAY") 
        
    turnon(inst)
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("lantern_overlay")
	owner.AnimState:Hide("LANTERN_OVERLAY") 	
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()        
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("lantern")
    inst.AnimState:SetBuild("lantern")
    inst.AnimState:PlayAnimation("idle_off")

    inst:AddTag("light")
    
    inst:AddComponent("lighter")

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(onputininventory)
    inst.components.inventoryitem:ChangeImageName("lantern")    

    inst:AddComponent("equippable")

    inst:AddComponent("machine")
    inst.components.machine.turnonfn = turnon
    inst.components.machine.turnofffn = turnoff
    inst.components.machine.cooldowntime = 0
    inst.components.machine.caninteractfn = function() return inst.components.inventoryitem.owner == nil or inst.components.equippable.isequipped end

    inst.entity:AddLight()
    inst.Light:SetColour(180/255, 195/255, 150/255)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(4)
    inst.Light:SetFalloff(.9)
    inst.Light:Enable(false)

    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 

    inst.OnLoad = OnLoad

    return inst
end


return Prefab( "common/inventory/inf_lantern", fn, assets) 
