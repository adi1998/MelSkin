game.OverwriteTableKeys( game.WorldUpgradeData,
{
    FamiliarCostume_FrogBrown =
	{
		Icon = "Costume_Frog02",
		InheritFrom = { "DefaultFamiliarCostume" },
		GrannyModel = "Frog_Mesh",
        GrannyTexture = "zerp-MelSkin/CritterFrogBrown_Color",

		Cost =
		{
			CosmeticsPoints = 100,
		},

		PreRevealVoiceLines =
		{
			{ GlobalVoiceLines = "FamiliarFrogCostumeUnlocked" },
			{ GlobalVoiceLines = "FamiliarMiscCostumeUnlocked" }
		},
		SwitchCostumeVoiceLines =
		{
			{ GlobalVoiceLines = "FamiliarFrogSwitchCostumeVoiceLines" },
			{ GlobalVoiceLines = "FamiliarMiscSwitchCostumeVoiceLines" },
		},
	},

    FamiliarCostume_FrogGreen =
	{
		Icon = "Costume_Frog02",
		InheritFrom = { "DefaultFamiliarCostume" },
		GrannyModel = "Frog_Mesh",
        GrannyTexture = "zerp-MelSkin/CritterFrogGreen_Color",

		Cost =
		{
			CosmeticsPoints = 100,
		},

		PreRevealVoiceLines =
		{
			{ GlobalVoiceLines = "FamiliarFrogCostumeUnlocked" },
			{ GlobalVoiceLines = "FamiliarMiscCostumeUnlocked" }
		},
		SwitchCostumeVoiceLines =
		{
			{ GlobalVoiceLines = "FamiliarFrogSwitchCostumeVoiceLines" },
			{ GlobalVoiceLines = "FamiliarMiscSwitchCostumeVoiceLines" },
		},
	},

    FamiliarCostume_FrogGrey =
	{
		Icon = "Costume_Frog02",
		InheritFrom = { "DefaultFamiliarCostume" },
		GrannyModel = "Frog_Mesh",
        GrannyTexture = "zerp-MelSkin/CritterFrogGrey_Color",

		Cost =
		{
			CosmeticsPoints = 100,
		},

		PreRevealVoiceLines =
		{
			{ GlobalVoiceLines = "FamiliarFrogCostumeUnlocked" },
			{ GlobalVoiceLines = "FamiliarMiscCostumeUnlocked" }
		},
		SwitchCostumeVoiceLines =
		{
			{ GlobalVoiceLines = "FamiliarFrogSwitchCostumeVoiceLines" },
			{ GlobalVoiceLines = "FamiliarMiscSwitchCostumeVoiceLines" },
		},
	},

    FamiliarCostume_FrogYellow =
	{
		Icon = "Costume_Frog02",
		InheritFrom = { "DefaultFamiliarCostume" },
		GrannyModel = "Frog_Mesh",
        GrannyTexture = "zerp-MelSkin/CritterFrogYellow_Color",

		Cost =
		{
			CosmeticsPoints = 100,
		},

		PreRevealVoiceLines =
		{
			{ GlobalVoiceLines = "FamiliarFrogCostumeUnlocked" },
			{ GlobalVoiceLines = "FamiliarMiscCostumeUnlocked" }
		},
		SwitchCostumeVoiceLines =
		{
			{ GlobalVoiceLines = "FamiliarFrogSwitchCostumeVoiceLines" },
			{ GlobalVoiceLines = "FamiliarMiscSwitchCostumeVoiceLines" },
		},
	},
})

mod.FamiliarList = {
    ItemCategories = {
        FrogFamiliar = {
            "FamiliarCostume_FrogBrown",
            "FamiliarCostume_FrogGreen",
            "FamiliarCostume_FrogGrey",
            "FamiliarCostume_FrogYellow",
        }
    }
}

for familiar, familiarCostume in pairs(mod.FamiliarList.ItemCategories) do
    table.insert(game.ScreenData.FamiliarCostumeShop.ItemCategories[familiar],familiarCostume)
end