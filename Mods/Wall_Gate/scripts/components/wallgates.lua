local WallGates = Class(function(self, inst)
	self.inst = inst
	self.openwallfn = nil
	self.closewallfn = nil
	self.isopen = false
	self.caninteractfn = nil
end)

function WallGates:OnSave()
	local data = {}	
	data.isopen = self.isopen
	return data
end

function WallGates:OnLoad(data)
	if data then
		self.isopen = data.isopen
		if self:IsOpen() then self:OpenWall() else self:CloseWall() end
	end
end

function WallGates:CloseWall()
	if self.closewallfn then
		self.closewallfn(self.inst)
	end
	self.isopen = false
end

function WallGates:CanInteract()
	if self.caninteractfn then
		return self.caninteractfn(self.inst)
	else
		return true
	end
end

function WallGates:OpenWall()
	if self.openwallfn then
		self.openwallfn(self.inst)
	end
	self.isopen = true
end

function WallGates:IsOpen()
	return self.isopen
end

function WallGates:CollectSceneActions(doer, actions, right)
	if right and self:CanInteract() then
		if self:IsOpen() then
			table.insert(actions, ACTIONS.CLOSE)
		else
			table.insert(actions, ACTIONS.OPEN)
		end	
	end
end

return WallGates