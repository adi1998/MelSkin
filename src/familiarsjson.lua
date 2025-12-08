local  helpTextPath = rom.path.combine(rom.paths.Content(),"Game\\Text\\en\\HelpText.en.sjson")

local FamiliarNames = {
    FamiliarCostume_FrogBrown = "Brown",
    FamiliarCostume_FrogGreen = "Green",
    FamiliarCostume_FrogGrey = "Grey",
    FamiliarCostume_FrogYellow = "Yellow",
    FamiliarCostume_HoundBeige = "Beige",
    FamiliarCostume_HoundTan = "Tan",
    FamiliarCostume_HoundOrange = "Orange",
    FamiliarCostume_RavenBlack = "Black",
    FamiliarCostume_RavenGreen = "Green",
    FamiliarCostume_CatBicolor ="Bicolor",
    FamiliarCostume_CatBlack ="Black",
    FamiliarCostume_CatSpotted ="Spotted",
    FamiliarCostume_CatTabby ="Tabby",
    FamiliarCostume_CatTuxedo ="Tuxedo",
    FamiliarCostume_CatWhite ="White",
}

local order = {
    "Id",
    "DisplayName",
    "Description",
}

sjson.hook(helpTextPath, function (data)
    for key, value in pairs(FamiliarNames) do
        local entry = {
            Id = key,
            DisplayName = value,
            Description = "",
        }
        table.insert(data.Texts,sjson.to_object(entry,order))
    end
end)