modutil.mod.Path.Wrap("SetupFamiliarCostume", function (base, familiar,args)
    base(familiar,args)
    local currentCostume = game.GameState.FamiliarCostumes[familiar.Name]
	if currentCostume ~= nil then
        local costumeData = game.WorldUpgradeData[currentCostume]
        game.SetThingProperty({ DestinationId = familiar.ObjectId, Property = "GrannyTexture", Value = costumeData.GrannyTexture })
    end
end)

modutil.mod.Path.Wrap("FamiliarCostumeShopUpdateVisibility", function (base, screen, args)
    base(screen,args)
end)