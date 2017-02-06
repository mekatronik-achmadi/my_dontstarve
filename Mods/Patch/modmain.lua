TUNING.HEAT_ROCK_CARRIED_BONUS_HEAT_FACTOR = 4

TUNING.TRAP_TEETH_USES = 20
TUNING.TRAP_TEETH_DAMAGE = 150

AddPrefabPostInit("firesuppressor", function(inst)
    table.insert(inst.components.firedetector.NOTAGS, "campfire")
end)
