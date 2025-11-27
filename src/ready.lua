---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

-- These are some sample code snippets of what you can do with our modding framework:


-- for model texture swap
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

-- for getting available portraits for a dress
mod.PortraitData = {
    Emerald =
    {
        Portraits = DeepCopyTable(mod.Portraits)
    },
    Lavender =
    {
        Portraits = DeepCopyTable(mod.Portraits)
    },
    Azure =
    {
        Portraits = DeepCopyTable(mod.Portraits)
    },
    Onyx =
    {
        Portraits = DeepCopyTable(mod.Portraits)
    },
    Fuchsia =
    {
        Portraits = DeepCopyTable(mod.Portraits)
    },
    Gilded =
    {
        Portraits = DeepCopyTable(mod.Portraits)
    },
    Moonlight =
    {
        Portraits = DeepCopyTable(mod.Portraits)
    },
    Crimson =
    {
        Portraits = DeepCopyTable(mod.Portraits)
    },
}

mod.NameFileMap = {
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

function udpateNameFileMap()
    local tempMap = {}
    for k,v in pairs(mod.NameFileMap) do
        tempMap[k .. "_Exit"] = v
    end
    for k,v in pairs(tempMap) do
        mod.NameFileMap[k] = v
    end
end

udpateNameFileMap()

mod.skinPackageList = {}
table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkin")

local guiPortraitsVFXFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\GUI_Portraits_VFX.sjson")
local portraitprefix = "Portraits\\Melinoe\\"
local modPortraitPrefix = "zerp-MelSkin\\portraits\\"

sjson.hook(guiPortraitsVFXFile, function(data)
    local newdata = {}
    for _, entry in ipairs(data.Animations) do
        local origname = entry.Name
        local origfilepath = entry.FilePath
        local origfilename = mod.NameFileMap[origname]
        if origfilename ~= nil then
            for dress,portraitData in pairs(mod.PortraitData) do
                if portraitData ~= nil and portraitData.Portraits ~= nil and portraitData.Portraits[origfilename] then
                    local newname = dress .. "_" .. origname
                    print("sjson old name", origname)
                    print("sjson new name", newname)
                    -- args.Name = newname
                    local newfilepath = modPortraitPrefix .. dress .. "\\" .. origfilename
                    print("sjson old path", origfilepath)
                    print("sjson new path", newfilepath)
                    local newentry = DeepCopyTable(entry)
                    newentry.Name = newname
                    newentry.FilePath = newfilepath
                    table.insert(newdata,newentry)
                end
            end
        end
    end
    for _, entry in ipairs(newdata) do
        table.insert(data.Animations,entry)
    end
end)


function mod.UpdateSkin(dress)
    if CurrentRun ~= nil and game.GetHeroTraitValues("Costume")[1] == nil then
        SetThingProperty({Property = "GrannyTexture", Value = dress, DestinationId = CurrentRun.Hero.ObjectId})
    end
end

function mod.GetDressValue(inputDress)
    for _, dressPair in ipairs(mod.DressData) do
        local dressName = dressPair[1]
        local dressValue = dressPair[2]
        if dressName == inputDress then
            return dressValue
        end
    end
    return ""
end

mod.dressvalue = mod.GetDressValue(config.dress)
mod.UpdateSkin(mod.dressvalue)

function mod.LoadSkinPackages()
    for _, packageName in ipairs(mod.skinPackageList) do
        print("Loading package: " .. packageName)
        LoadPackages({ Name = packageName })
    end
end

function mod.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. mod.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
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
            local dress = mod.dressvalue
            if config.random_each_run then
                dress = mod.GetDressValue(CurrentRun.Hero.ModDressData)
                print("skin random", dress)
            end
            args_copy.Value = dress
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

function mod.GetPortraitNameFromCostume(filename, name)
    local costumes = game.GetHeroTraitValues("Costume");
    if costumes[1] ~= nil then
        local dress = mod.CostumeDressMap[costumes[1]]
        if dress ~= nil then
            local portraitData = mod.PortraitData[dress]
            if portraitData.Portraits[filename] then
                return dress .. "_" .. name
            end
        end
    end
    return nil
end

function mod.GetPortraitNameFromConfig(filename,name)
    local dress = config.dress
    if config.random_each_run then
        dress = CurrentRun.Hero.ModDressData
        print("portrait random", dress)
    end
    local portraitData = mod.PortraitData[dress]
    if portraitData ~= nil then
        if portraitData.Portraits[filename] then
            return dress .. "_" .. name
        end
    end
    return nil
end

function mod.SetAnimationWrap(base,args)
    local origname = args.Name
    local origfilename = mod.NameFileMap[origname]
    print("play text line", origname, origfilename)
    if origfilename ~= nil then
        local newname = mod.GetPortraitNameFromCostume(origfilename,origname) or mod.GetPortraitNameFromConfig(origfilename,origname) or origname
        print("SetAnimation", origname, newname)
        args.Name = newname
        base(args)
        return
    end
    base(args)
end

function mod.SetAnimationWrap2(base,args)
    return mod.SetAnimationWrap(base,args)
end

modutil.mod.Path.Context.Wrap("PlayTextLines", function (source, textLines, args)
    modutil.mod.Path.Wrap("SetAnimation", mod.SetAnimationWrap)
end)

modutil.mod.Path.Context.Wrap("PlayEmoteAnimFromSource", function (source, args, screen, lines)
    modutil.mod.Path.Wrap("SetAnimation", mod.SetAnimationWrap)
end)

function mod.SetRandomDress()
    mod.random_dress = game.GetRandomArrayValue(mod.DressData)[1]
    print("Random dress", mod.random_dress)
    CurrentRun.Hero.ModDressData = mod.random_dress
end

modutil.mod.Path.Wrap("StartNewRun", function(base, prevRun, args)
    local retValue = base(prevRun,args)
    if config.random_each_run then
        mod.SetRandomDress()
    else
        CurrentRun.Hero.ModDressData = nil
    end
    return retValue
end)