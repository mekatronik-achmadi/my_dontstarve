Default_Console_Key = "~" | "Ctrl+L"
RunScript("consolecommands")

-----------------------------------------------------------------------

TheInput:GetWorldEntityUnderMouse():Remove()
GetWorld().minimap.MiniMap:ShowArea(0,0,0,10000)

-----------------------------------------------------------------------

c_give("ice")
c_give("poop")
c_give("silk")
c_give("mole")
c_give("nitre")
c_give("rocks")
c_give("flint")
c_give("pigskin")
c_give("charcoal")
c_give("goldnugget")
c_give("beefalowool")
c_give("houndstooth")
c_give("spidergland")
c_give("manrabbit_tail")

-----------------------------------------------------------------------

GetPlayer().prefab = "character"
GetPlayer().profile:UnlockEverything()
​GetPlayer().components.builder:GiveAllRecipes()​
