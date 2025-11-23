---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

-- These are some sample code snippets of what you can do with our modding framework:

mod.dressTable = {
	{"Lavender" , "Models/Melinoe/Melinoe_ArachneArmorC",},
	{"Azure" , "Models/Melinoe/Melinoe_ArachneArmorB",},
	{"Emerald" , "Models/Melinoe/Melinoe_ArachneArmorA",},
	{"Onyx" , "Models/Melinoe/Melinoe_ArachneArmorF",},
	{"Fuchsia" , "Models/Melinoe/Melinoe_ArachneArmorD",},
	{"Gilded" , "Models/Melinoe/Melinoe_ArachneArmorE",},
	{"Moonlight" , "Models/Melinoe/Melinoe_ArachneArmorG",},
	{"Crimson" , "Models/Melinoe/Melinoe_ArachneArmorH",},
	{"DarkSide" , "Models/Melinoe/MelinoeTransform_Color",},
    {"Noise", "zerp-MelSkin/Noise"},
    {"Negative", "zerp-MelSkin/Negative"},
    {"RedMel", "zerp-MelSkin/RedMel"},
    {"Invert2", "zerp-MelSkin/Invert2"},
	{"None" , ""},
}

mod.skinPackageList = {}
table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkin")

function mod.SetSkin()
    if CurrentRun ~= nil then
        SetThingProperty({Property = "GrannyTexture", Value = mod.dressvalue, DestinationId = CurrentRun.Hero.ObjectId})
    end
end

for _, dressPair in ipairs(mod.dressTable) do
    local dressName = dressPair[1]
    local dressValue = dressPair[2]
    if dressName == config.dress then
        mod.dressvalue = dressValue
        mod.SetSkin()
        break
    end
end

function mod.LoadSkinPackages()
    for _, packageName in ipairs(mod.skinPackageList) do
        print("Loading package: " .. packageName)
        LoadPackages({ Name = packageName })
    end
end

mod.LoadSkinPackages()