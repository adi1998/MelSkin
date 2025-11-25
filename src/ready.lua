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
    {"Alternate Time", "zerp-MelSkin/skins/Alternate Time"},
    {"None" , ""},
}

mod.PortraitData = {
    Emerald =
    {
        Portraits = {
            Portraits_Melinoe_01 = true,
            Portraits_Melinoe_Proud_01 = true,
            Portraits_Melinoe_Casual_01 = true,
            Portraits_Melinoe_Empathetic_01 = true,
            Portraits_Melinoe_EmpatheticFlushed_01 = true,
            Portraits_Melinoe_Hesitant_01 = true,
            Portraits_Melinoe_Vulnerable_01 = true,
        }
    },
    Lavender =
    {
        Portraits = {}
    },
    Azure =
    {
        Portraits = {}
    },
    Onyx =
    {
        Portraits = {
            Portraits_Melinoe_01 = true,
            Portraits_Melinoe_Casual_01 = true,
        }
    },
    Fuchsia =
    {
        Portraits = {
            Portraits_Melinoe_01 = true,
            Portraits_Melinoe_Casual_01 = true,
        }
    },
    Gilded =
    {
        Portraits = {}
    },
    Moonlight =
    {
        Portraits = {
            Portraits_Melinoe_01 = true,
        }
    },
    Crimson =
    {
        Portraits = {
            Portraits_Melinoe_01 = true,
            Portraits_Melinoe_Casual_01 = true,
        }
    },
}

mod.SpriteList = {
    Portraits_Melinoe_01 = true,
    Portraits_Melinoe_Casual_01 = true,
    Portraits_Melinoe_Empathetic_01 = true,
    Portraits_Melinoe_EmpatheticFlushed_01 = true,
    Portraits_Melinoe_Hesitant_01 = true,
    Portraits_Melinoe_Intense_01 = true,
    Portraits_Melinoe_Pleased_01 = true,
    Portraits_Melinoe_PleasedFlushed_01 = true,
    Portraits_Melinoe_Proud_01 = true,
    Portraits_Melinoe_Vulnerable_01 = true,
}

mod.skinPackageList = {}
table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkin")

local guiPortraitsVFXFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\GUI_Portraits_VFX.sjson")
local portraitprefix = "Portraits\\Melinoe\\"
local modPortraitPrefix = "zerp-MelSkin\\portraits\\"

sjson.hook(guiPortraitsVFXFile, function(data)
    for _, entry in ipairs(data.Animations) do
        if entry.FilePath ~= nil then
            local filename = string.sub(entry.FilePath,#portraitprefix+1)

            if string.sub(entry.FilePath,1,#portraitprefix) == portraitprefix then
                print(entry.FilePath, filename)
            end
            if mod.PortraitData[config.dress] and mod.PortraitData[config.dress].Portraits[filename] then
                print(filename)
                entry.FilePath = modPortraitPrefix .. config.dress .. "\\" .. filename
                print(entry.FilePath)
            end
        end
    end
end)

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