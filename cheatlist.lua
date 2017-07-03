Default_Console_Key = "`"
Default_Clear_Key = "ctrl+l"
RunScript("consolecommands")

-----------------------------------------------------------------------

GetWorld().minimap.MiniMap:ShowArea(0,0,0,10000)
​GetPlayer().components.builder:GiveAllRecipes()​
TheInput:GetWorldEntityUnderMouse():Remove()

-----------------------------------------------------------------------

c_give("ice")
c_give("poop")
c_give("silk")
c_give("nitre")
c_give("rocks")
c_give("flint")
c_give("pigskin")
c_give("charcoal")
c_give("wormlight")
c_give("goldnugget")
c_give("houndstooth")
c_give("beefalowool")
c_give("feather_crow")
c_give("dug_berrybush")
c_give("manrabbit_tail")
c_give("deerclops_eyeball")

-----------------------------------------------------------------------

GetPlayer().prefab = "character"
GetPlayer().profile:UnlockEverything()
