Recipe("firesuppressor", {Ingredient("gears", 1),Ingredient("ice", 8),Ingredient("transistor", 1)}, RECIPETABS.SCIENCE,  TECH.NONE, "firesuppressor_placer")

AddPrefabPostInit("firesuppressor", function(inst)
    inst.components.fueled.rate = .25
    table.insert(inst.components.firedetector.NOTAGS, "campfire")
end)

