local assets=
{
    Asset("ANIM", "anim/bow.zip"),
    Asset("ANIM", "anim/swap_quiver.zip"),
	 

    Asset("ATLAS", "images/inventoryimages/quiver.xml"),
    Asset("IMAGE", "images/inventoryimages/quiver.tex"),
	
	Asset("ANIM", "anim/ui_quiver_1x1.zip"),
}
prefabs = {
}

-------------------------------------------------------------QUIVER --------------------------------------------------------

function quiveritemtestfn(container, item, slot)
		if item:HasTag("zupalexsrangedweapons") and (item:HasTag("arrow") or item:HasTag("bolt")) then 
			return true
		else
			return false
		end
end
	
local function OpenQuiver(self, doer)
	local playerHUD = doer.HUD
	local playercontainers = playerHUD.controls.containers
	local quiverwidget = nil
			
	local hudscaleadjust = Profile:GetHUDSize()*2
	local qs_pos = INVINFO.EQUIPSLOT_quiver:GetWorldPosition()
	
	self.opener = doer
	if not self.open then
		if doer and doer.HUD then
			doer.HUD:OpenContainer(self.inst, self.side_widget)
		end

		if playercontainers then
			for k, v in pairs(playercontainers) do
				if v.container == self.inst then
					quiverwidget = v
				end
			end
		end
		
		if quiverwidget ~= nil then
			if quiverwidget.QuiverHasAnchor == nil then
				quiverwidget.QuiverHasAnchor = true
				
				quiverwidget:SetVAnchor(ANCHOR_BOTTOM)
				quiverwidget:SetHAnchor(ANCHOR_LEFT)
			end
			
			quiverwidget:UpdatePosition(qs_pos.x, (qs_pos.y+60+hudscaleadjust))			
		end
		
		self:OnOpen()
	end
end	
	
local function OnEquipQuiver(inst, owner)	
    owner.AnimState:OverrideSymbol("swap_body", "swap_quiver", "swap_body")
    inst:DoTaskInTime(0, function() inst.components.container:Open(owner) end)
end
 
local function OnUnequipQuiver(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
	if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
end

local slotpos = {}

table.insert(slotpos, Vector3(0, 0 ,0))


local function quiverfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
     
    anim:SetBank("quiver")
    anim:SetBuild("swap_quiver")
    anim:PlayAnimation("anim")
 
	inst:AddTag("quiver") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	
	
 --The following section is suitable for a DST compatible prefab.
    
----------------------------------------------------------------
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.imagename = "quiver"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/quiver.xml"
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.QUIVER
	inst.components.equippable:SetOnEquip( OnEquipQuiver )
	inst.components.equippable:SetOnUnequip( OnUnequipQuiver )
	
	inst:AddComponent("container")
	inst.components.container.widgetVAnchor = ANCHOR_BOTTOM
	inst.components.container.widgetHAnchor = ANCHOR_LEFT
	inst.components.container.itemtestfn = quiveritemtestfn
	inst.components.container:SetNumSlots(#slotpos)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_quiver_1x1"
    inst.components.container.widgetanimbuild = "ui_quiver_1x1"
--	inst.components.container.widgetpos = Vector3(1366.13, 200, 0)
	inst.components.container.widgetpos = Vector3(0, 0, 0)
	inst.components.container.side_widget = false
	inst.components.container.acceptsstacks = true
--    inst.components.container.widgetpos_controller = Vector3(500, -490, 0)
    inst.components.container.side_align_tip = 0
    inst.components.container.type = "quiver"
	inst.components.container.Open = OpenQuiver
	
	inst:AddComponent("zupalexsrangedweapons")

	return inst
end


return  Prefab("common/inventory/quiver", quiverfn, assets, prefabs)