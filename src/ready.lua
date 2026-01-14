---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- so you will most likely want to have it reference
-- values and functions later defined in `reload.lua`.

mod.skinPackageList = {}
-- table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkinSmall")
table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkinPortraits")
-- table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkinCustom")
-- table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkinCustomSmall")

mod.smallPackageList = {_PLUGIN.guid .. "zerp-MelSkinCustomSmall", _PLUGIN.guid .. "zerp-MelSkinSmall"}
mod.bigPackageList = {_PLUGIN.guid .. "zerp-MelSkinCustom", _PLUGIN.guid .. "zerp-MelSkin"}

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
        game.ScreenData.UpgradeChoice.ComponentData.ShopBackground.Graphic = dress .. "_" .. mod.BoonSelectObstacle.Name
    end
    base(source,args)
    -- resetting base value
    game.ScreenData.UpgradeChoice.ComponentData.ShopBackground.Graphic = mod.BoonSelectObstacle.Name
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
    game.LoadPackages({Names = mod.skinPackageList})
    if config.enable_shimmer_fix then
        game.LoadPackages({Names = mod.smallPackageList})
    else
        game.LoadPackages({Names = mod.bigPackageList})
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
    local dress = config.dress
    if config.random_each_run then
        dress = mod.GetCurrentRunDress()
    end
    game.StopAnimation({ Name = "MelArmGlow", DestinationId = game.CurrentRun.Hero.ObjectId })
    if dress and not mod.DressData[dress].DisableMelArmGlow then
        game.CreateAnimation({ Name = "MelArmGlow", DestinationId = game.CurrentRun.Hero.ObjectId })
    end
end)

-- TODO: this is untested
modutil.mod.Path.Wrap("SetupFlashbackPlayerUnitChronos", function(base,source,args)
    base(source,args)
    game.SetThingProperty({Property = "GrannyTexture", Value = "", DestinationId = game.CurrentRun.Hero.ObjectId})
end)

modutil.mod.Path.Wrap("MelBackToBedroomPresentation", function(base,source,args)
    local grannyTexture = mod.GetDressGrannyTexture(config.dress)
    if config.random_each_run then
        grannyTexture = mod.GetDressGrannyTexture(mod.GetCurrentRunDress())
        print("skin random", grannyTexture)
    end
    game.SetThingProperty({Property = "GrannyTexture", Value = grannyTexture, DestinationId = game.CurrentRun.Hero.ObjectId})
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
    local function RemoveCustomFromArray(array)
        local retValue = {}
        for key, value in pairs(array) do
            if key ~= "Custom" then
                retValue[key] = value
            end
        end
        return retValue
    end
    local randomDress = ""
    local numOfFixedDress = 0
    local numOfPresets = 0
    local fixedDressList = RemoveCustomFromArray(mod.DressDisplayOrder)
    if game.GameState.ModFavoriteDressList ~= nil and #game.GameState.ModFavoriteDressList > 0 then
        numOfFixedDress = #game.GameState.ModFavoriteDressList
        fixedDressList = RemoveCustomFromArray(game.GameState.ModFavoriteDressList)
        if game.Contains(game.GameState.ModFavoriteDressList, "Custom") then
            numOfPresets = game.TableLength(mod.PresetTable) - 1 - ((mod.PresetTable["LastApplied"] and 1) or 0)
            numOfFixedDress = numOfFixedDress - 1
        end
    else
        numOfFixedDress = #mod.DressDisplayOrder - 1
        numOfPresets = game.TableLength(mod.PresetTable) - 1 - ((mod.PresetTable["LastApplied"] and 1) or 0)
    end

    local random = math.random(numOfFixedDress+numOfPresets)
    print("numOfFixedDress", numOfFixedDress)
    print("numOfPresets", numOfPresets)
    print("random index", random)
    if random > numOfFixedDress then
        -- preset selected
        randomDress = "Custom"
        mod.SetRandomCustomPreset()
    else
        randomDress = fixedDressList[random]
    end
    print("Random dress", randomDress)
    game.CurrentRun.Hero.ModDressData = randomDress
end

function mod.GetCurrentRunDress()
    -- if this is called, it means random is enabled
    if game.CurrentRun.Hero.ModDressData == nil or game.CurrentRun.Hero.ModDressData == "" then
        mod.SetRandomDress()
    end
    return game.CurrentRun.Hero.ModDressData
end

modutil.mod.Path.Wrap("StartNewRun", function(base, prevRun, args)
    local retValue = base(prevRun,args)
    if game.GameState ~= nil and game.GameState.ModFavoriteDressList == nil then
        game.GameState.ModFavoriteDressList = {}
    end
    if config.random_each_run then
        mod.SetRandomDress()
    else
        game.CurrentRun.Hero.ModDressData = nil
    end
    return retValue
end)

function mod.CheckDressInFavorite(dressName)
    return game.Contains(game.GameState.ModFavoriteDressList,dressName)
end

function mod.RemoveFavoriteDress(dressName)
    local index = game.GetIndex(game.GameState.ModFavoriteDressList, dressName)
    if index == 0 then
        print("trying to remove unknown dress")
        return
    end
    game.RemoveIndexAndCollapse(game.GameState.ModFavoriteDressList, index)
end

function mod.AddFavoriteDress(dressName)
    table.insert(game.GameState.ModFavoriteDressList, dressName)
end

modutil.mod.Path.Wrap("SetupHeroObject", function (base,...)
    base(...)
    local dress = config.dress
    if config.random_each_run then
        dress = mod.GetCurrentRunDress()
    end
    if dress and mod.DressData[dress].DisableMelArmGlow then
        game.StopAnimation({ Name = "MelArmGlow", DestinationId = game.CurrentRun.Hero.ObjectId })
    end
end)