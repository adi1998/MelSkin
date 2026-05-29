-- list of supported Portraits
mod.Portraits =
{
    Portraits_Melinoe_01 = true,
    Portraits_Melinoe_Proud_01 = true,
    Portraits_Melinoe_Intense_01 = true,
    Portraits_Melinoe_Vulnerable_01 = true,
    Portraits_Melinoe_Empathetic_01 = true,
    Portraits_Melinoe_EmpatheticFlushed_01 = true,
    Portraits_Melinoe_Hesitant_01 = true,
    Portraits_Melinoe_Casual_01 = true,
    Portraits_Melinoe_Pleased_01 = true,
    Portraits_Melinoe_PleasedFlushed_01 = true,
}

mod.DressData = {
    Lavender =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorC",
        Portraits = mod.Portraits,
        Color = {206, 168, 238, 255}
    },
    Azure =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorB",
        Portraits = mod.Portraits,
        Color = {0, 89, 220, 255},
    },
    Emerald =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorA",
        Portraits = mod.Portraits,
        Color = {20, 200, 40, 255}
    },
    Onyx =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorF",
        Portraits = mod.Portraits,
        Color = {49, 41, 41, 255}
    },
    Fuchsia =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorD",
        Portraits = mod.Portraits,
        Color = {200, 69, 134, 255}
    },
    Gilded =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorE",
        Portraits = mod.Portraits,
        Color = {216, 171, 0, 255}
    },
    Moonlight =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorG",
        Portraits = mod.Portraits,
        Color = {204, 215, 243, 255}
    },
    Crimson =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorH",
        Portraits = mod.Portraits,
        Color = {220, 0, 0, 255},
    },
    ["Dark Side"] =
    {
        GrannyTexture = "Models/Melinoe/MelinoeTransform_Color",
        ChildGrannyTexture = "Models/Melinoe/YoungMelTransform_Color",
        Portraits = {
            Portraits_Melinoe_01 = true,
            Portraits_Melinoe_Hesitant_01 = true,
            Portraits_Melinoe_Casual_01 = true,
            Portraits_Melinoe_Proud_01 = true,
        },
        PortraitOverlayModifacations = {
            Portrait_Mel_Blink = "nil",
            Portrait_Mel_Hesitant_Blink = "nil",
            Portrait_Mel_Intense_Blink = "nil",
            Portrait_Mel_Pleased_Blink = "nil",
            Portrait_Mel_Vulnerable_Blink = "nil",
            Portrait_Mel_LaurelGlow = {
                Hue = 0.408,
                VisualFx = { Name = "LaurelBurnIris", Hue = 0.408 },
            },
            Portrait_Mel_Hesitant_LaurelGlow = {
                Hue = 0.408,
                VisualFx = { Name = "LaurelBurnIris", Hue = 0.408 },
            },
            Portrait_Mel_Intense_LaurelGlow = {
                Hue = 0.408,
                VisualFx = { Name = "LaurelBurnIris", Hue = 0.408 },
            },
            Portrait_Mel_Pleased_LaurelGlow = {
                Hue = 0.408,
                VisualFx = { Name = "LaurelBurnIris", Hue = 0.408 },
            },
            Portrait_Mel_Vulnerable_LaurelGlow = {
                Hue = 0.408,
                VisualFx = { Name = "LaurelBurnIris", Hue = 0.408 },
            },
        },
        Color = {70, 206, 125, 255},
        LaurelCinderHue = 0.408,
    },
    ["Alternate Time"] =
    {
        GrannyTexture = "zerp-MelSkin/Alternate Time",
        ChildGrannyTexture = "zerp-MelSkin/YoungMelRed_Color",
        TyphonRivalsPortraitMap = {
            Portrait_Mel_Child_Defiant_01 = "Portrait_Melinoe_Child_Ending_Defiant_01",
            Portrait_Mel_Child_Defiant_01_Exit = "Portrait_Melinoe_Child_Ending_Defiant_01_Exit",
        },
        DisableMelArmGlow = true,
        Color = {134, 0, 0, 255}
    },
    Murderrrrr =
    {
        GrannyTexture = "zerp-MelSkin/Halloween 2025",
        Color = {176, 208, 66, 255},
        ArmGlow = {
            StartRed = 0.6,
            StartGreen = 0.9,
            StartBlue = 0.1,
            EndRed = 0.7,
            EndGreen = 1,
            EndBlue = 0.1,
        }
    },
    Chaos =
    {
        GrannyTexture = "zerp-MelSkin/Chaos",
        BoonPortrait = true,
        Portraits = mod.Portraits,
        PortraitOverlayModifacations = {
            Portrait_Mel_Body2_Wiggle1_In = "nil",
            Portrait_Mel_Body1_Wiggle2_In = "nil",
            Portrait_Mel_Body2_Wiggle2_In = {
                Hue = 0.44,
		        Saturation = 0.3,
                UpdateChainTo = true,
            },
            Portrait_Mel_Body1_Wiggle1_In = {
                Hue = 0.44,
		        Saturation = 0.3,
                UpdateChainTo = true,
            },
            Portrait_Mel_Body2_Wiggle2 = {
                Hue = 0.44,
		        Saturation = 0.3,
            },
            Portrait_Mel_Body1_Wiggle1 = {
                Hue = 0.44,
		        Saturation = 0.3,
            },
            Portrait_Mel_Body2_ArmGlow = {
                Hue = 0.385,
            },
            Portrait_Mel_Body1_ArmGlow = {
                Hue = 0.385,
            },
            Portrait_Mel_LaurelGlow = {
                Hue = -0.24,
                VisualFx = { Name = "LaurelBurnIris", Hue = -0.24 },
            },
            Portrait_Mel_Hesitant_LaurelGlow = {
                Hue = -0.24,
                VisualFx = { Name = "LaurelBurnIris", Hue = -0.24 },
            },
            Portrait_Mel_Intense_LaurelGlow = {
                Hue = -0.24,
                VisualFx = { Name = "LaurelBurnIris", Hue = -0.24 },
            },
            Portrait_Mel_Pleased_LaurelGlow = {
                Hue = -0.24,
                VisualFx = { Name = "LaurelBurnIris", Hue = -0.24 },
            },
            Portrait_Mel_Vulnerable_LaurelGlow = {
                Hue = -0.24,
                VisualFx = { Name = "LaurelBurnIris", Hue = -0.24 },
            },
        },
        Color = {197, 64, 220, 255},
        ArmGlow = {
            StartRed = 0.9,
            StartGreen = 0.2,
            StartBlue = 0.9,
            EndRed = 0.8,
            EndGreen = 0.3,
            EndBlue = 1,
        },
        LaurelCinderHue = -0.24,
    },
    Visage = {
        GrannyTexture = "zerp-MelSkin/Visage",
        Outline =
        {
            R = 25,
            G = 200,
            B = 160,
            Opacity = 1,
            Thickness = 10,
            Threshold = 0.6,
        },
        Color = {70, 206, 125, 255},
    },
    None =
    {
        GrannyTexture = "",
        Color = {202, 105, 29, 255}
    },
    Custom =
    {
        GrannyTexture = "zerp-MelSkinCustom/custom"
    }
}

mod.DressDisplayOrder = {
    "Lavender" ,
    "Azure" ,
    "Emerald" ,
    "Onyx" ,
    "Fuchsia" ,
    "Gilded" ,
    "Moonlight" ,
    "Crimson" ,
    "Dark Side",
    "Alternate Time",
    "Murderrrrr",
    "Chaos",
    "Visage",
    "None",
    "Custom"
}

mod.CustomDressDisplayOrder = {
    "Lavender" ,
    "Azure" ,
    "Emerald" ,
    "Onyx" ,
    "Fuchsia" ,
    "Gilded" ,
    "Moonlight" ,
    "Crimson" ,
    "None"
}

-- for portraitprefix based on Arachne boon
mod.CostumeDressMap = {
    ["Models/Melinoe/Melinoe_ArachneArmorC"] = "Lavender",
    ["Models/Melinoe/Melinoe_ArachneArmorB"] = "Azure",
    ["Models/Melinoe/Melinoe_ArachneArmorA"] = "Emerald",
    ["Models/Melinoe/Melinoe_ArachneArmorF"] = "Onyx",
    ["Models/Melinoe/Melinoe_ArachneArmorD"] = "Fuchsia",
    ["Models/Melinoe/Melinoe_ArachneArmorE"] = "Gilded",
    ["Models/Melinoe/Melinoe_ArachneArmorG"] = "Moonlight",
    ["Models/Melinoe/Melinoe_ArachneArmorH"] = "Crimson",
}

mod.PortraitNameFileMap = {
    Portrait_Mel_Default_01 = "Portraits_Melinoe_01",
    Portrait_Mel_Proud_01 = "Portraits_Melinoe_Proud_01",
    Portrait_Mel_Intense_01 = "Portraits_Melinoe_Intense_01",
    Portrait_Mel_Vulnerable_01 = "Portraits_Melinoe_Vulnerable_01",
    Portrait_Mel_Empathetic_01 = "Portraits_Melinoe_Empathetic_01",
    Portrait_Mel_EmpatheticFlushed_01 = "Portraits_Melinoe_EmpatheticFlushed_01",
    Portrait_Mel_Hesitant_01 = "Portraits_Melinoe_Hesitant_01",
    Portrait_Mel_Casual_01 = "Portraits_Melinoe_Casual_01",
    Portrait_Mel_Pleased_01 = "Portraits_Melinoe_Pleased_01",
    Portrait_Mel_PleasedFlushed_01 = "Portraits_Melinoe_PleasedFlushed_01",
}

mod.ZagMelMap = {
    ModsNikkelMHadesBiomes_Portrait_Zag_Default_01 = {"Portraits_Melinoe_01", "ZagDefault"},
    ModsNikkelMHadesBiomes_Portrait_Zag_Serious_01 = {"Portraits_Melinoe_Intense_01", "ZagSerious"},
    ModsNikkelMHadesBiomes_Portrait_Zag_Defiant_01 = {"Portraits_Melinoe_Intense_01", "ZagDefiant"},
    ModsNikkelMHadesBiomes_Portrait_Zag_Empathetic_01 = {"Portraits_Melinoe_Empathetic_01", "ZagEmpathetic"},
    ModsNikkelMHadesBiomes_Portrait_Zag_Unwell_01 = {"Portraits_Melinoe_Hesitant_01", "ZagUnwell"},
}