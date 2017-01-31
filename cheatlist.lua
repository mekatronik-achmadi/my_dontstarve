RunScript("consolecommands")

--------------------------------------------------------------------------------

GetWorld().minimap.MiniMap:ShowArea(0,0,0,10000)
​GetPlayer().components.builder:GiveAllRecipes()​
TheInput:GetWorldEntityUnderMouse():Remove()

--------------------------------------------------------------------------------

c_give("bow") -- "zbow"
c_give("quiver") -- zquiver

c_give("flint") -- "arrow"
c_give("nitre") -- "coldfire"
c_give("silk") -- "fishingrod"
c_give("charcoal") -- "meatrack"

c_give("cane")
c_give("heatrock")
c_give("panflute")

c_give("molehat")
c_give("beefalohat")
c_give("eyebrellahat")

c_give("turf_woodfloor")
c_give("mech_stone_item")
c_give("wall_stone_item")

c_spawn("icebox")
c_spawn("fast_farmplot")

c_spawn("path_light")
c_spawn("wood_shelter")

c_spawn("coldfirepit")
c_spawn("firesuppressor")

c_spawn("pighouse")
c_spawn("rabbithouse")

c_spawn("rainometer")
c_spawn("winterometer")
c_spawn("lightning_rod")

--------------------------------------------------------------------------------

GetPlayer().prefab = "character"
GetPlayer().profile:UnlockEverything()
