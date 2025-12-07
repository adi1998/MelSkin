modutil.mod.Path.Wrap("SetupFamiliarCostume", function (base, familiar,args)
    base(familiar,args)
    local currentCostume = game.GameState.FamiliarCostumes[familiar.Name]
	if currentCostume ~= nil then
        local costumeData = game.WorldUpgradeData[currentCostume]
        if costumeData.GrannyTexture ~= nil then
            game.SetThingProperty({ DestinationId = familiar.ObjectId, Property = "GrannyTexture", Value = costumeData.GrannyTexture })
        end
    end
end)

modutil.mod.Path.Wrap("FamiliarCostumeShopUpdateVisibility", function (base, screen, args)
    for index, itemName in ipairs( screen.ItemCategories[screen.OpenedFrom.Name] ) do
		local itemData = WorldUpgradeData[itemName]
        print(mod.dump(itemData))
    end
    base(screen,args)
end)