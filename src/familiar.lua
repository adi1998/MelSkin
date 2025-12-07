modutil.mod.Path.Wrap("SetupFamiliarCostume", function (base, familiar,args)
    base(familiar,args)
    game.GameState.ModFamiliarCostumes = game.GameState.ModFamiliarCostumes or {}
    local currentModCostume = game.GameState.ModFamiliarCostumes[familiar.Name]
	if currentModCostume ~= nil then
        local costumeData = game.WorldUpgradeData[currentModCostume]
        game.SetThingProperty({ DestinationId = familiar.ObjectId, Property = "GrannyTexture", Value = costumeData.GrannyTexture })
    else
        game.SetThingProperty({ DestinationId = familiar.ObjectId, Property = "GrannyTexture", Value = "" })
    end
end)