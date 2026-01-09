---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
--     so you will most likely want to have it reference
--    values and functions later defined in `reload.lua`.

local pluginsData = rom.path.combine(rom.paths.plugins_data(), _PLUGIN.guid)
local plugins = rom.path.combine(rom.paths.plugins(), _PLUGIN.guid)
local colorMapExePath = rom.path.combine(pluginsData, "colormap.exe")
local colorMapScriptPath = "python " .. rom.path.combine(plugins, "colormap.py")
local customPath = rom.path.combine(pluginsData, "Custom")
local packagePath = rom.path.combine(pluginsData, "zerp-MelSkinCustom")
-- local rebuildCommand = "powershell \"" .. pluginsData .. "\\build.ps1\""
local rebuildCommand = "C: & cd \"" .. pluginsData .. "\" & deppth2 hpk -s \"" .. customPath .. "\" -t \"" .. packagePath .. "\""

mod.skinPackageList = {}
table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkin")
table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkinCustom")

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
        ScreenData.UpgradeChoice.ComponentData.ShopBackground.Graphic = dress .. "_" .. mod.BoonSelectObstacle.Name
    end
    base(source,args)
    -- resetting base value
    ScreenData.UpgradeChoice.ComponentData.ShopBackground.Graphic = mod.BoonSelectObstacle.Name
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

function mod.GetDressGrannyTexture(inputDress)
    if mod.DressData[inputDress] ~= nil then
        if game.MapState.BabyPolymorph then
            return mod.DressData[inputDress].ChildGrannyTexture or ""
        else
            return mod.DressData[inputDress].GrannyTexture or ""
        end
    end
    return ""
end

function mod.LoadSkinPackages()
    LoadPackages({Names = mod.skinPackageList})
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

modutil.mod.Path.Wrap("SetupCostume", function (base, skipCostume)
    local grannyTexture = mod.GetDressGrannyTexture(config.dress)
    if config.random_each_run then
        grannyTexture = mod.GetDressGrannyTexture(mod.GetCurrentRunDress())
    end
    if (not skipCostume) or game.MapState.BabyPolymorph then
        game.CostumeData.Costume_Default.GrannyTexture = grannyTexture
    end
    base(skipCostume)
    game.CostumeData.Costume_Default.GrannyTexture = ""
end)

-- TODO: this is untested
modutil.mod.Path.Wrap("SetupFlashbackPlayerUnitChronos", function(base,source,args)
    base(source,args)
    SetThingProperty({Property = "GrannyTexture", Value = "", DestinationId = CurrentRun.Hero.ObjectId})
end)

modutil.mod.Path.Wrap("MelBackToBedroomPresentation", function(base,source,args)
    local grannyTexture = mod.GetDressGrannyTexture(config.dress)
    if config.random_each_run then
        grannyTexture = mod.GetDressGrannyTexture(mod.GetCurrentRunDress())
        print("skin random", grannyTexture)
    end
    SetThingProperty({Property = "GrannyTexture", Value = grannyTexture, DestinationId = CurrentRun.Hero.ObjectId})
    base(source,args)
end)

modutil.mod.Path.Wrap("SetupMap", function(base)
    mod.LoadSkinPackages()
    if game.GameState ~= nil and game.GameState.ModFavoriteDressList == nil then
        game.GameState.ModFavoriteDressList = {}
    end
    base()
end)

function mod.GetPortraitNameFromCostume(filename, name)
    local costumes = game.GetHeroTraitValues("Costume");
    if costumes[1] ~= nil then
        local dress = mod.CostumeDressMap[costumes[1]]
        if dress ~= nil then
            local dressData = mod.DressData[dress]
            if dressData.Portraits and dressData.Portraits[filename] then
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
        if dressData.Portraits and dressData.Portraits[filename] then
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
        return base(args)
    end
    if game.MapState.BabyPolymorph then
        local dress = mod.GetCurrentDress()
        local dressdata = mod.DressData[dress]
        if dressdata == nil or dressdata.TyphonRivalsPortraitMap == nil then
            return base(args)
        end
        local newname = dressdata.TyphonRivalsPortraitMap[origname]
        args.Name = newname or args.Name
        return base(args)
    end
    return base(args)
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
    local randomDress = ""
    if game.GameState.ModFavoriteDressList ~= nil and #game.GameState.ModFavoriteDressList > 0 then
        randomDress = game.GetRandomArrayValue(game.GameState.ModFavoriteDressList)
    else
        randomDress = game.GetRandomArrayValue(mod.DressDisplayOrder)
    end
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
    if game.GameState ~= nil and game.GameState.ModFavoriteDressList == nil then
        game.GameState.ModFavoriteDressList = {}
    end
    if config.random_each_run then
        mod.SetRandomDress()
    else
        CurrentRun.Hero.ModDressData = nil
    end
    return retValue
end)

function mod.CheckDressInFavorite(dressName)
    return game.Contains(game.GameState.ModFavoriteDressList,dressName)
end

function mod.RemoveFavoriteDress(dressName)
    local index = game.GetIndex(GameState.ModFavoriteDressList, dressName)
    if index == 0 then
        print("trying to remove unknown dress")
        return
    end
    game.RemoveIndexAndCollapse(GameState.ModFavoriteDressList, index)
end

function mod.AddFavoriteDress(dressName)
    table.insert(GameState.ModFavoriteDressList, dressName)
end

function mod.ReloadCustomTexture()
    local driveLetter = pluginsData:sub(1,1)
    local colorMapPath = colorMapExePath
    if not config.use_exe then
        colorMapPath = colorMapScriptPath
    end
    local colorMapCommand = driveLetter .. ": & cd \"" .. pluginsData .. "\" & " .. colorMapPath .. " --path \"" .. pluginsData .. "\" "
    local rgbCommand = colorMapCommand
    if config.custom_dress_color and config.custom_dress then
        rgbCommand = rgbCommand .. " --dress " .. tostring(config.dresscolor.r) .. "," .. tostring(config.dresscolor.g) .. "," .. tostring(config.dresscolor.b)
    end
    if config.custom_hair_color then
        rgbCommand = rgbCommand .. " --hair " .. tostring(config.haircolor.r) .. "," .. tostring(config.haircolor.g) .. "," .. tostring(config.haircolor.b)
    end
    if config.custom_dress and not config.custom_dress_color then
        rgbCommand = rgbCommand .. " --base " .. config.custom_dress_base
    end
    if config.custom_arm_color then
        rgbCommand = rgbCommand .. " --arm " .. tostring(config.arm_hue)
    end
    if config.bright_dress then
        rgbCommand = rgbCommand .. " --bright "
    end
    print("running", rgbCommand)
    local handle = os.execute(rgbCommand)

    game.UnloadPackages({Names = {_PLUGIN.guid .. "zerp-MelSkinCustom"}})
    game.LoadPackages({Names = {_PLUGIN.guid .. "zerp-MelSkinCustom"}})
end