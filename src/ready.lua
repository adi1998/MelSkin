---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

-- DressName: Name displayed in the UI and the key used to retrieve DressData
-- Portrait

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
        Portraits = mod.Portraits
    },
    Azure =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorB",
        Portraits = mod.Portraits
    },
    Emerald =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorA",
        Portraits = mod.Portraits
    },
    Onyx =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorF",
        Portraits = mod.Portraits
    },
    Fuchsia =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorD",
        Portraits = mod.Portraits
    },
    Gilded =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorE",
        Portraits = mod.Portraits
    },
    Moonlight =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorG",
        Portraits = mod.Portraits
    },
    Crimson =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/Melinoe_ArachneArmorH",
        Portraits = mod.Portraits
    },
    DarkSide =
    {
        BoonPortrait = true,
        GrannyTexture = "Models/Melinoe/MelinoeTransform_Color",
    },
    ["Alternate Time"] =
    {
        GrannyTexture = "zerp-MelSkin/skins/Alternate Time"
    },
    Murderrrrr =
    {
        GrannyTexture = "zerp-MelSkin/skins/Halloween 2025"
    },
    None =
    {
        GrannyTexture = ""
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

function udpatePortraitNameFileMap()
    local tempMap = {}
    for k,v in pairs(mod.PortraitNameFileMap) do
        tempMap[k .. "_Exit"] = v
    end
    for k,v in pairs(tempMap) do
        mod.PortraitNameFileMap[k] = v
    end
end

udpatePortraitNameFileMap()

mod.skinPackageList = {}
table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkin")

local guiPortraitsVFXFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\GUI_Portraits_VFX.sjson")
local guiScreensVFXFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\GUI_Screens_VFX.sjson")
local guiFile = rom.path.combine(rom.paths.Content(), "Game\\Obstacles\\GUI.sjson")
local modPortraitPrefix = "zerp-MelSkin\\portraits\\"

sjson.hook(guiPortraitsVFXFile, function(data)
    local newdata = {}
    for _, entry in ipairs(data.Animations) do
        local origname = entry.Name
        local origfilepath = entry.FilePath
        local origfilename = mod.PortraitNameFileMap[origname]
        if origfilename ~= nil then
            for dress, dressData in pairs(mod.DressData) do
                if dressData.Portraits ~= nil and dressData.Portraits[origfilename] then
                    local newname = dress .. "_" .. origname
                    print("sjson new name", newname)
                    -- args.Name = newname
                    local newfilepath = modPortraitPrefix .. dress .. "\\" .. origfilename
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

mod.BoonSjson = {
    {
        Name = "BoonSelectMelIn",
        FilePath = "",
        Material = "Unlit",
        OffsetX = -640,
        VisualFx = "BoonSelectMelFxLoop",
        VisualFxIntervalMin = 0.5,
        VisualFxIntervalMax = 0.5,
        VisualFxCap = 1,
    },
    {
        Name = "BoonSelectMelOut",
        FilePath = "",
    }
}

mod.BoonObstacle =
{
    Name = "BoonSelectMel",
    InheritFrom = "1_BaseGUIObstacle",
    DisplayInEditor = false,
    Thing =
    {
        EditorOutlineDrawBounds = false,
        Graphic = "BoonSelectMelIn",
    }
}

sjson.hook(guiScreensVFXFile, function (data)
    local newdata = {}
    for _, entry in ipairs(mod.BoonSjson) do
        local origname = entry.Name
        for dress,dressData in pairs(mod.DressData) do
            if dressData.BoonPortrait then
                local newname = dress .. "_" .. origname
                local newfilepath = modPortraitPrefix .. dress .. "\\" .. "BoonSelectMelIn0015"
                local newentry = DeepCopyTable(entry)
                newentry.Name = newname
                if origname == "BoonSelectMelIn" then
                    newentry.FilePath = newfilepath
                end
                table.insert(newdata,newentry)
                print(mod.dump(newentry))
            end
        end
    end
    for _, entry in ipairs(newdata) do
        table.insert(data.Animations,entry)
    end
end)

sjson.hook(guiFile,function (data)
    local newdata = {}
    local origname = mod.BoonObstacle.Name
    for dress,dressData in pairs(mod.DressData) do
        if dressData.BoonPortrait then
            local newname = dress .. "_" .. origname
            local newentry = DeepCopyTable(mod.BoonObstacle)
            newentry.Name = newname
            newentry.Thing.Graphic = dress .. "_" .. newentry.Thing.Graphic
            table.insert(newdata,newentry)
            print(mod.dump(newentry))
        end
    end
    for _, entry in ipairs(newdata) do
        table.insert(data.Obstacles,entry)
    end
end)

function mod.GetCurrentDress()
    local costumes = game.GetHeroTraitValues("Costume")
    if costumes[1] ~= nil then
        local dress = mod.CostumeDressMap[costumes[1]]
        if dress ~= nil then
            return dress
        end
    end
    local dress = config.dress
    if config.random_each_run then
        dress = mod.GetCurrentRunDress()
    end
    return dress
end

modutil.mod.Path.Wrap("OpenUpgradeChoiceMenu", function (base,source,args)
    local dress = mod.GetCurrentDress()
    local dressData = mod.DressData[dress]
    if dressData ~= nil and dressData.BoonPortrait then
        ScreenData.UpgradeChoice.ComponentData.ShopBackground.Graphic = dress .. "_" .. mod.BoonObstacle.Name
    end
    base(source,args)
    -- resetting base value
    ScreenData.UpgradeChoice.ComponentData.ShopBackground.Graphic = mod.BoonObstacle.Name
end)

modutil.mod.Path.Context.Wrap("CloseUpgradeChoiceScreen", function (screen, button)
    modutil.mod.Path.Wrap("SetAnimation", function (base,args)
        if args.Name == "BoonSelectMelOut" then
            local dress = mod.GetCurrentDress()
            local dressData = mod.DressData[dress]
            if dressData ~= nil and dressData.BoonPortrait then
                args.Name = dress .. "_" .. args.Name
            end
        end
        base(args)
    end)
end)

function mod.UpdateSkin(dressGrannyTexture)
    if CurrentRun ~= nil and game.GetHeroTraitValues("Costume")[1] == nil then
        SetThingProperty({Property = "GrannyTexture", Value = dressGrannyTexture, DestinationId = CurrentRun.Hero.ObjectId})
    end
end

function mod.GetDressGrannyTexture(inputDress)
    if mod.DressData[inputDress] ~= nil then
        return mod.DressData[inputDress].GrannyTexture or ""
    end
    return ""
end

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
            local grannyTexture = mod.GetDressGrannyTexture(config.dress)
            if config.random_each_run then
                grannyTexture = mod.GetDressGrannyTexture(mod.GetCurrentRunDress())
                print("skin random", grannyTexture)
            end
            args_copy.Value = grannyTexture
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
            local dressData = mod.DressData[dress]
            if dressData.Portraits[filename] then
                return dress .. "_" .. name
            end
        end
    end
    return nil
end

function mod.GetPortraitNameFromConfig(filename,name)
    local dress = config.dress
    if config.random_each_run then
        dress = mod.GetCurrentRunDress()
        print("portrait random", dress)
    end
    local dressData = mod.DressData[dress]
    if dressData ~= nil then
        if dressData.Portraits[filename] then
            return dress .. "_" .. name
        end
    end
    return nil
end

function mod.SetAnimationWrap(base,args)
    local origname = args.Name
    local origfilename = mod.PortraitNameFileMap[origname]
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

modutil.mod.Path.Context.Wrap.Static("PlayTextLines", function (source, textLines, args)
    modutil.mod.Path.Wrap("SetAnimation", mod.SetAnimationWrap)
end)

modutil.mod.Path.Context.Wrap.Static("PlayEmoteAnimFromSource", function (source, args, screen, lines)
    modutil.mod.Path.Wrap("SetAnimation", mod.SetAnimationWrap)
end)

function mod.SetRandomDress()
    local randomDress = tostring(game.GetRandomKey(mod.DressData))
    print("Random dress", randomDress)
    CurrentRun.Hero.ModDressData = randomDress
end

function mod.GetCurrentRunDress()
    -- if this is called, it means random is enabled
    if CurrentRun.Hero.ModDressData == nil or CurrentRun.Hero.ModDressData == "" then
        mod.SetRandomDress()
    end
    return CurrentRun.Hero.ModDressData
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