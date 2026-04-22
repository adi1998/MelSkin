local dressMenuObstacleSjson = {
    Name = _PLUGIN.guid .. "DressMenuObstacle",
    InheritFrom = "1_BaseInvulnerableObstacle",
    DisplayInEditor = true,
    Thing =
    {
        EditorOutlineDrawBounds = false,
        Graphic = _PLUGIN.guid .. "Obstacles" .. "\\Erebus_WebThread_01",
        Tallness = 1155,
        Offset = { X = 0, Y = 0 },
        OffsetZ = 100,
        Points = {
            { X = -485, Y = -298 },
            { X = 435, Y = 146 },
            { X = 321, Y = 215 },
            { X = -596, Y = -231 },
        },
    }
}

local crossroadsObstaclesPath = rom.path.combine(rom.paths.Content(),"Game\\Obstacles\\Crossroads.sjson")

sjson.hook(crossroadsObstaclesPath, function (data)
    table.insert(data.Obstacles, dressMenuObstacleSjson)
    return data
end)

table.insert(game.HubRoomData.Hub_Main.StartUnthreadedEvents, {
    FunctionName = _PLUGIN.guid .. "." .. "SpawnDressObstacleHubMain"
})

table.insert(game.HubRoomData.Hub_PreRun.StartUnthreadedEvents, {
    FunctionName = _PLUGIN.guid .. "." .. "SpawnDressObstaclePreRun"
})

modutil.mod.Path.Wrap("DeathAreaSwitchRoom", function (base, source, args)
	if args.Name == "Hub_Main" then
		game.Destroy({Id = mod.dressObstacleId})
        mod.dressObstacleId = nil
	end
	return base(source, args)
end)