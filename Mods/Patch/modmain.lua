--replicating tuning.lua constants
local seg_time = 30
local total_day_time = seg_time*16
local aeon_time = total_day_time * 48 * 1000000000
local fuel_amt = aeon_time * 0.1

local day_segs = 10
local dusk_segs = 4
local night_segs = 2

--default day composition. changes in winter, etc
local day_time = seg_time * day_segs
local dusk_time = seg_time * dusk_segs
local night_time = seg_time * night_segs

TUNING.FIRE_DETECTOR_PERIOD = 0.5
TUNING.FIRE_DETECTOR_RANGE = 20
TUNING.FIRESUPPRESSOR_RELOAD_TIME = 1
TUNING.FIRESUPPRESSOR_MAX_FUEL_TIME = aeon_time
TUNING.FIRESUPPRESSOR_EXTINGUISH_HEAT_PERCENT = 1
TUNING.SMOTHERER_EXTINGUISH_HEAT_PERCENT = -10

AddPrefabPostInit("firesuppressor", function(inst)
    table.insert(inst.components.firedetector.NOTAGS, "campfire")
end)
