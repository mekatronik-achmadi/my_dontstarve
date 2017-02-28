require("screens/inputtextscreen")

local Writeable = Class(function(self, inst)
	self.inst = inst
	self.writtentext = nil
	self.caninteractfn = nil
	self.writtenfn = nil
end)

function Writeable:OnSave()
	local data = {}	
	data.writtentext = self.writtentext
	return data
end

function Writeable:OnLoad(data)
	if data then
		self.writtentext = data.writtentext
	end
end

function Writeable:CanInteract()
	if self.caninteractfn then
		return self.caninteractfn(self.inst)
	else
		return true
	end
end

function Writeable:StartWriting(target, writer)	
	TheFrontEnd:PushScreen(InputTextScreen(target, writer))
end

function Writeable:CollectSceneActions(doer, actions, writing)
	if writing and self:CanInteract() and (not self.writtentext or rewritable_signs) then	
		table.insert(actions, ACTIONS.WRITEONSIGN)		
	end
end

return Writeable