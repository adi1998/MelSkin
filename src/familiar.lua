modutil.mod.Path.Wrap("SetupFamiliarCostume", function (base, familiar,args)
    base(familiar,args)
    local currentCostume = GameState.FamiliarCostumes[familiar.Name]
	if currentCostume ~= nil then
        SetThingProperty({ DestinationId = familiar.ObjectId, Property = "GrannyTexture", Value = costumeData.GrannyTexture })
    end
end)