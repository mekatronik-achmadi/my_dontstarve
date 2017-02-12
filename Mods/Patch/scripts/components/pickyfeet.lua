local PickyFeet= Class(function(self, inst)
    self.inst = inst
	self.old_night_mul = inst.components.sanity.night_drain_mult
	self.old_inherentinsulation = inst.components.temperature.inherentinsulation
	self.old_groundspeedmultiplier = inst.components.locomotor.groundspeedmultiplier
	self.task = self.inst:DoPeriodicTask(0.5, function() self:OnUpdate(0.5) end, 0)
end)

function getFloor(self)
	local x,y,z = self.inst.Transform:GetWorldPosition()
	local ground = GetWorld()
	if ground then
		local tile = ground.Map:GetTileAtPoint(x,y,z)
		return tile
	end
end

function Wood(self)
	local tile = getFloor(self)
	if tile==GROUND.WOODFLOOR then
		self.inst.components.sanity.night_drain_mult=0.1
		self.inst.components.temperature.inherentinsulation=TUNING.INSULATION_SMALL
		self.inst.components.locomotor.groundspeedmultiplier=TUNING.WOODFLOOR_SPEEDMULTIPLIER
	else
		self.inst.components.sanity.night_drain_mult=self.old_night_mul
		self.inst.components.temperature.inherentinsulation=self.old_inherentinsulation
		self.inst.components.locomotor.groundspeedmultiplier=self.old_groundspeedmultiplier
	end
end

function PickyFeet:OnUpdate(dt)
	Wood(self)
end

return PickyFeet
