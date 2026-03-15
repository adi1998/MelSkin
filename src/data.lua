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
        Color = {55, 200, 91, 255}
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