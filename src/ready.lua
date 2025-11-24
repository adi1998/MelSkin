---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

-- These are some sample code snippets of what you can do with our modding framework:

mod.DressData = {
    {"Lavender" , "Models/Melinoe/Melinoe_ArachneArmorC"},
    {"Azure" , "Models/Melinoe/Melinoe_ArachneArmorB"},
    {"Emerald" , "Models/Melinoe/Melinoe_ArachneArmorA"},
    {"Onyx" , "Models/Melinoe/Melinoe_ArachneArmorF"},
    {"Fuchsia" , "Models/Melinoe/Melinoe_ArachneArmorD"},
    {"Gilded" , "Models/Melinoe/Melinoe_ArachneArmorE"},
    {"Moonlight" , "Models/Melinoe/Melinoe_ArachneArmorG"},
    {"Crimson" , "Models/Melinoe/Melinoe_ArachneArmorH"},
    {"Dark Side" , "Models/Melinoe/MelinoeTransform_Color"},
    {"None" , ""},
}

mod.skinPackageList = {}
table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkin")

function mod.UpdateSkin(dress)
    if CurrentRun ~= nil then
        SetThingProperty({Property = "GrannyTexture", Value = dress, DestinationId = CurrentRun.Hero.ObjectId})
    end
end

for _, dressPair in ipairs(mod.DressData) do
    local dressName = dressPair[1]
    local dressValue = dressPair[2]
    if dressName == config.dress then
        mod.dressvalue = dressValue
        mod.UpdateSkin(mod.dressvalue)
        break
    end
end

function mod.LoadSkinPackages()
    for _, packageName in ipairs(mod.skinPackageList) do
        print("Loading package: " .. packageName)
        LoadPackages({ Name = packageName })
    end
end

modutil.mod.Path.Wrap("SetThingProperty", function(base,args)
	if CurrentRun.Hero.SubtitleColor ~= Color.ChronosVoice and
        (MapState.HostilePolymorph == false or MapState.HostilePolymorph == nil) and
        args.Property == "GrannyTexture" and
        (args.Value == "null" or args.Value == "") and
        args.DestinationId == CurrentRun.Hero.ObjectId then
            print("Base args:",mod.dump(args))
            args_copy = DeepCopyTable(args)
            args_copy.Value = mod.dressvalue
            print("Mod args:",mod.dump(args_copy))
            base(args_copy)
	else
		base(args)
	end
end)

-- TODO: this is untested
modutil.mod.Path.Wrap("SetupFlashbackPlayerUnitChronos", function(base,source,args)
    base(source,args)
    SetThingProperty({Property = "GrannyTexture", Value = "", DestinationId = CurrentRun.Hero.ObjectId})
end)

modutil.mod.Path.Wrap("SetupMap", function(base)
    mod.LoadSkinPackages()
    base()
end)