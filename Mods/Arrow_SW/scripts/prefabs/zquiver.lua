local assets=
{
    Asset("ANIM", "anim/zbow.zip"),
    Asset("ANIM", "anim/swap_zquiver.zip"),
	 

    Asset("ATLAS", "images/inventoryimages/zquiver.xml"),
    Asset("IMAGE", "images/inventoryimages/zquiver.tex"),
	
	Asset("ANIM", "anim/ui_zquiver_1x1.zip"),
}
prefabs = {
}

-------------------------------------------------------------zquiver --------------------------------------------------------

function zquiveritemtestfn(container, item, slot)
		if item:HasTag("zupalexsrangedweapons") and (item:HasTag("zarrow") or item:HasTag("zbolt")) then 
			return true
		else
			return false
		end
end
	
local function UpdateQuiverWidgetPos(self, doer)
	if self.open then
		local playerHUD = doer.HUD
		local playercontainers = playerHUD.controls.containers
		local zquiverwidget = nil
				
		local hudscaleadjust = Profile:GetHUDSize()*2
		local qs_pos = INVINFO.EQUIPSLOT_quiver:GetWorldPosition()
		
		if playercontainers then
			for k, v in pairs(playercontainers) do
				if v.container == self.inst then
					zquiverwidget = v
				end
			end
		end
		
		if zquiverwidget ~= nil then
			if zquiverwidget.zquiverHasAnchor == nil then
				zquiverwidget.zquiverHasAnchor = true
				
				zquiverwidget:SetVAnchor(ANCHOR_BOTTOM)
				zquiverwidget:SetHAnchor(ANCHOR_LEFT)
			end
			
			local boatingOffset = GetPlayer().sg.sg.name == "wilsonboating" and 80 or 0
			
			zquiverwidget:UpdatePosition(qs_pos.x, (qs_pos.y+60+boatingOffset+hudscaleadjust))			
		end
	end
end
	
local function Openzquiver(self, doer)	
	self.opener = doer
	if not self.open then
		if doer and doer.HUD then
			doer.HUD:OpenContainer(self.inst, self.side_widget)
		end

		self:OnOpen()
		
		UpdateQuiverWidgetPos(self, doer)
	end
end	
	
local function OnEquipzquiver(inst, owner)	
    owner.AnimState:OverrideSymbol("swap_body", "swap_zquiver", "swap_zquiver")
	
    inst:DoTaskInTime(0, function() inst.components.container:Open(owner) end)
	
	local equiphand = owner.components.inventory and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

	if equiphand == nil or not equiphand:HasTag("zupalexsrangedweapons") or not equiphand:HasTag("usequiverproj") then
		return
	end
	
	local projinquiver = inst.components.container:GetItemInSlot(1)
	if projinquiver == nil or not projinquiver:HasTag("zupalexsrangedweapons") then
		return
	end
	
	equiphand.components.weapon:SetProjectile(projinquiver.prefab)	
end
 
local function OnUnequipzquiver(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_zquiver")
	
	if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
end

local slotpos = {}

table.insert(slotpos, Vector3(0, 0 ,0))

local function OnQuiverGetItem(inst, data)
	inst:DoTaskInTime(FRAMES, function()
								print("My Quiver recieved an item")
								local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
								if owner == nil then
									OnQuiverGetItem(inst, data)
									return
								end
								
								local equiphand = owner.components.inventory and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
								if equiphand == nil or not equiphand:HasTag("zupalexsrangedweapons") or not equiphand:HasTag("usequiverproj") or not data.item:HasTag("zupalexsrangedweapons") then
									return
								end
								
								equiphand.components.weapon:SetProjectile(data.item.prefab)																
							end
	)
end

local function zquiverfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
    MakeInventoryPhysics(inst)
     
    anim:SetBank("quiver")
    anim:SetBuild("swap_zquiver")
    anim:PlayAnimation("anim")
 
	inst:AddTag("zquiver") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	
	
 --The following section is suitable for a DST compatible prefab.
    
----------------------------------------------------------------
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.imagename = "zquiver"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/zquiver.xml"
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.QUIVER
	inst.components.equippable:SetOnEquip( OnEquipzquiver )
	inst.components.equippable:SetOnUnequip( OnUnequipzquiver )
	
	inst:AddComponent("container")
	inst.components.container.widgetVAnchor = ANCHOR_BOTTOM
	inst.components.container.widgetHAnchor = ANCHOR_LEFT
	inst.components.container.itemtestfn = zquiveritemtestfn
	inst.components.container:SetNumSlots(#slotpos)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_zquiver_1x1"
    inst.components.container.widgetanimbuild = "ui_zquiver_1x1"
--	inst.components.container.widgetpos = Vector3(1366.13, 200, 0)
	inst.components.container.widgetpos = Vector3(0, 0, 0)
	inst.components.container.side_widget = false
	inst.components.container.acceptsstacks = true
--    inst.components.container.widgetpos_controller = Vector3(500, -490, 0)
    inst.components.container.side_align_tip = 0
    inst.components.container.type = "zquiver"
	inst.components.container.Open = Openzquiver
	
	inst:AddComponent("zupalexsrangedweapons")
	
	GetPlayer():ListenForEvent("mountboat", function() UpdateQuiverWidgetPos(inst.components.container, GetPlayer()) end)
	
	GetPlayer():ListenForEvent("dismountboat", function() UpdateQuiverWidgetPos(inst.components.container, GetPlayer()) end)
	
	-- inst:StartUpdatingComponent(inst.components.zupalexsrangedweapons)
	
	inst:ListenForEvent("itemget", OnQuiverGetItem)

	return inst
end


return  Prefab("common/inventory/zquiver", zquiverfn, assets, prefabs)