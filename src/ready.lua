---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
--     so you will most likely want to have it reference
--    values and functions later defined in `reload.lua`.

mod.skinPackageList = {}
table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkin")



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