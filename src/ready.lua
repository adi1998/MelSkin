---@diagnostic disable: cast-local-type
---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
--     so you will most likely want to have it reference
--    values and functions later defined in `reload.lua`.

mod.Player1Id = 40000
mod.Player2Id = 39999

mod.skinPackageList = {}
table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkin")
table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkinPortraits")
table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkinObstacles")
table.insert(mod.skinPackageList, _PLUGIN.guid .. "zerp-MelSkinCustom")

function mod.GetCurrentDress()
    local costumes = game.GetHeroTraitValues("Costume")
    if costumes[1] ~= nil then
        local dress = mod.CostumeDressMap[costumes[1]]
        if dress ~= nil then
            return dress
        end
    end
    local dress = mod.GetCurrentDressConfig()
    if game.CurrentRun.Hero.ObjectId == 39999 then
        dress = config.dress2
    end
    if config.random_each_run then
        dress = mod.GetCurrentRunDress()
    end
    return dress
end

modutil.mod.Path.Wrap("OpenUpgradeChoiceMenu", function (base,source,args)
    local dress = mod.GetCurrentDress()
    local modDressData = mod.GetModDressData()
    local dressData = modDressData[dress]
    if dressData ~= nil and dressData.BoonPortrait then
        game.ScreenData.UpgradeChoice.ComponentData.ShopBackground.Graphic = dress .. "_" .. mod.BoonSelectObstacle.Name
    end
    base(source,args)
    -- resetting base value
    game.ScreenData.UpgradeChoice.ComponentData.ShopBackground.Graphic = mod.BoonSelectObstacle.Name
end)

modutil.mod.Path.Wrap("CreateScreenFromData", function (base, screen, componentData, args)
    if screen.Name == "ProvokeFatesScreen" then
        local dress = mod.GetCurrentDress()
        local modDressData = mod.GetModDressData()
        local dressData = modDressData[dress]
        if dressData ~= nil and dressData.BoonPortrait then
            componentData.ShopBackground.Graphic = dress .. "_" .. mod.BoonSelectObstacle.Name
        end
    end
    base(screen, componentData, args)
end)

function mod.GetDressGrannyTexture(inputDress)
    local modDressData = mod.GetModDressData()
    if modDressData[inputDress] ~= nil then
        if game.MapState.BabyPolymorph then
            return modDressData[inputDress].ChildGrannyTexture or ""
        else
            return modDressData[inputDress].GrannyTexture or ""
        end
    end
    return ""
end

function mod.LoadSkinPackages()
    game.LoadPackages({Names = mod.skinPackageList})
end

function mod.SetupExtraAnimations(dress)
    local laurelCindersSpawner = "LaurelCindersSpawner"
    local modDressData = mod.GetModDressData()
    if dress and modDressData[dress] and modDressData[dress].LaurelCinderHue then
        laurelCindersSpawner  = dress .. laurelCindersSpawner
    end
    if game.MapState[_PLUGIN.guid .. "LaurelCindersSpawner"] ~= laurelCindersSpawner then
        game.StopAnimation({ Name = game.MapState[_PLUGIN.guid .. "LaurelCindersSpawner"], DestinationId = game.CurrentRun.Hero.ObjectId })
        game.CreateAnimation({ Name = laurelCindersSpawner, DestinationId = game.CurrentRun.Hero.ObjectId })
        game.MapState[_PLUGIN.guid .. "LaurelCindersSpawner"] = laurelCindersSpawner
    end

    game.StopAnimation({ Name = "MelArmGlow", DestinationId = game.CurrentRun.Hero.ObjectId })
    game.StopAnimation({ Name = dress .. "MelArmGlow", DestinationId = game.CurrentRun.Hero.ObjectId })
    game.StopAnimation({ Name = game.MapState[_PLUGIN.guid .. "PrevArmGlowAnimation"], DestinationId = game.CurrentRun.Hero.ObjectId })
    if dress and modDressData[dress] and not modDressData[dress].DisableMelArmGlow then
        if modDressData[dress].ArmGlow then
            game.CreateAnimation({ Name = dress .. "MelArmGlow", DestinationId = game.CurrentRun.Hero.ObjectId })
            game.MapState[_PLUGIN.guid .. "PrevArmGlowAnimation"] = dress .. "MelArmGlow"
        else
            game.CreateAnimation({ Name = "MelArmGlow", DestinationId = game.CurrentRun.Hero.ObjectId })
            game.MapState[_PLUGIN.guid .. "PrevArmGlowAnimation"] = "MelArmGlow"
        end
    end
end

modutil.mod.Path.Wrap("SetPlayerDarkside", function (base, flag)
    base(flag)
    if game.Contains({"SpellTransform", "NightmareSequence"}, flag) then
        mod.SetupExtraAnimations("Dark Side")
    end
end)

modutil.mod.Path.Wrap("SetupCostume", function (base, skipCostume)
    if game.CurrentRun.Hero.ObjectId ~= 39999 then
        mod.Player1Id = game.CurrentRun.Hero.ObjectId
        mod.Hero = game.CurrentRun.Hero
    else
        mod.Hero2 = game.CurrentRun.Hero
    end
    local grannyTexture = mod.GetDressGrannyTexture(mod.GetCurrentDressConfig())
    if game.CurrentRun.Hero.ObjectId == 39999 then
        grannyTexture = mod.GetDressGrannyTexture(config.dress2)
    end
    if config.random_each_run then
        grannyTexture = mod.GetDressGrannyTexture(mod.GetCurrentRunDress())
    end
    if (not skipCostume) or game.MapState.BabyPolymorph then
        game.CostumeData.Costume_Default.GrannyTexture = grannyTexture
    end
    base(skipCostume)
    game.CostumeData.Costume_Default.GrannyTexture = ""

    -- arm glow and laurel spawner setup
    local dress = mod.GetCurrentDress()
    mod.SetupExtraAnimations(dress)

    local modDressData = mod.GetModDressData()
    if modDressData[dress] and modDressData[dress].Outline then
        local outlineData = modDressData[dress].Outline
        outlineData.Id = game.CurrentRun.Hero.ObjectId
        game.AddOutline( outlineData )
    else
        game.RemoveOutline( { Id = game.CurrentRun.Hero.ObjectId } )
    end
end)

modutil.mod.Path.Wrap("SetPlayerDarkside", function (base, flag)
    game.RemoveOutline( { Id = game.CurrentRun.Hero.ObjectId } )
    return base(flag)
end)

modutil.mod.Path.Wrap("SetPlayerUnDarkside", function (base, flag)
    base(flag)
    local dress = mod.GetCurrentDress()
    local modDressData = mod.GetModDressData()
    if modDressData[dress] and modDressData[dress].Outline then
        local outlineData = modDressData[dress].Outline
        outlineData.Id = game.CurrentRun.Hero.ObjectId
        game.AddOutline( outlineData )
    end
end)

-- TODO: this is untested
modutil.mod.Path.Wrap("SetupFlashbackPlayerUnitChronos", function(base,source,args)
    base(source,args)
    game.SetThingProperty({Property = "GrannyTexture", Value = "", DestinationId = game.CurrentRun.Hero.ObjectId})
end)

modutil.mod.Path.Wrap("MelBackToBedroomPresentation", function(base,source,args)
    local grannyTexture = mod.GetDressGrannyTexture(mod.GetCurrentDressConfig())
    if game.CurrentRun.Hero.ObjectId == 39999 then
        grannyTexture = mod.GetDressGrannyTexture(config.dress2)
    end
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
    if game.GameState and not game.GameState.CustomCharacterFavoriteDressList then
        game.GameState.CustomCharacterFavoriteDressList = {}
    end
    for characterName, _ in pairs(CharacterData) do
        game.GameState.CustomCharacterFavoriteDressList[characterName] = game.GameState.CustomCharacterFavoriteDressList[characterName] or {}
    end
    base()
end)

function mod.GetPortraitNameFromCostume(filename, name)
    local costumes = game.GetHeroTraitValues("Costume");
    if costumes[1] ~= nil then
        local dress = mod.CostumeDressMap[costumes[1]]
        if dress ~= nil then
            local modDressData = mod.GetModDressData()
            local dressData = modDressData[dress]
            if dressData.Portraits and dressData.Portraits[filename] then
                return dress .. "_" .. name
            end
        end
    end
    return nil
end

function mod.GetCurrentDressConfig()
    local characterName = mod.GetCurrentCharacter()
    game.GameState[_PLUGIN.guid .. "CurrentDressConfig"] = game.GameState[_PLUGIN.guid .. "CurrentDressConfig"] or {}
    game.GameState[_PLUGIN.guid .. "CurrentDressConfig"][characterName] = game.GameState[_PLUGIN.guid .. "CurrentDressConfig"][characterName] or "None"
    return game.GameState[_PLUGIN.guid .. "CurrentDressConfig"][characterName]
end

function  mod.SetCurrentDressConfig(dressName)
    local characterName = mod.GetCurrentCharacter()
    game.GameState[_PLUGIN.guid .. "CurrentDressConfig"] = game.GameState[_PLUGIN.guid .. "CurrentDressConfig"] or {}
    game.GameState[_PLUGIN.guid .. "CurrentDressConfig"][characterName] = dressName
end

function mod.GetPortraitNameFromConfig(filename,name)
    local dress = mod.GetCurrentDressConfig()
    if game.CurrentRun.Hero.ObjectId == 39999 then
        dress = config.dress2
    end
    if config.random_each_run then
        dress = mod.GetCurrentRunDress()
        print("portrait random", dress)
    end
    local modDressData = mod.GetModDressData()
    local dressData = modDressData[dress]
    if dressData ~= nil then
        if dressData.Portraits and dressData.Portraits[filename] then
            return dress .. "_" .. name
        end
    end
    return nil
end

function mod.SetRandomDress()
    local randomDress = ""
    local numOfFixedDress = 0
    local numOfPresets = 0
    local dressDisplayOrder = mod.GetModDressDataOrder()
    local fixedDressList = game.DeepCopyTable(dressDisplayOrder)
    game.RemoveValueAndCollapse(fixedDressList, "Custom")
    local currentCharacter = mod.GetCurrentCharacter()
    local modFavoriteList = game.GameState.ModFavoriteDressList
    if currentCharacter ~= "Default" then
        modFavoriteList = game.GameState.CustomCharacterFavoriteDressList[currentCharacter]
    end
    if modFavoriteList and #modFavoriteList > 0 then
        numOfFixedDress = #modFavoriteList
        fixedDressList = game.DeepCopyTable(modFavoriteList)
        game.RemoveValueAndCollapse(fixedDressList, "Custom")
        if game.Contains(modFavoriteList, "Custom") and currentCharacter == "Default" then
            numOfPresets = game.TableLength(mod.PresetTable) - 1 - ((mod.PresetTable["LastApplied"] and 1) or 0)
            numOfFixedDress = numOfFixedDress - 1
        end
    else
        numOfFixedDress = #fixedDressList
        if currentCharacter == "Default" then
            numOfPresets = game.TableLength(mod.PresetTable) - 1 - ((mod.PresetTable["LastApplied"] and 1) or 0)
        end
    end

    local totalOptions = numOfFixedDress + numOfPresets
    -- this will only be zero if there are no presets and only Custom is favorited
    totalOptions = (totalOptions == 0 and 1) or totalOptions
    local random = math.random(totalOptions)
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
    game.CurrentRun.Hero[_PLUGIN.guid .. "RandomDressData"] = game.CurrentRun.Hero[_PLUGIN.guid .. "RandomDressData"] or {}
    game.CurrentRun.Hero[_PLUGIN.guid .. "RandomDressData"][currentCharacter] = randomDress
    game.SetLightBarColor({ PlayerIndex = 1, Color = game.CurrentRun.Hero.LightBarColor or game.HeroData.LightBarColor })
end

function mod.GetCurrentRunDress()
    -- if this is called, it means random is enabled
    local currentCharacter = mod.GetCurrentCharacter()
    game.CurrentRun.Hero[_PLUGIN.guid .. "RandomDressData"] = game.CurrentRun.Hero[_PLUGIN.guid .. "RandomDressData"] or {}
    if game.CurrentRun.Hero[_PLUGIN.guid .. "RandomDressData"][currentCharacter] == nil or game.CurrentRun.Hero[_PLUGIN.guid .. "RandomDressData"][currentCharacter] == "" then
        mod.SetRandomDress()
    end
    return game.CurrentRun.Hero[_PLUGIN.guid .. "RandomDressData"][currentCharacter]
end

modutil.mod.Path.Wrap("StartNewRun", function(base, prevRun, args)
    local retValue = base(prevRun,args)
    if game.GameState and not game.GameState.ModFavoriteDressList then
        game.GameState.ModFavoriteDressList = {}
    end
    if game.GameState and not game.GameState.CustomCharacterFavoriteDressList then
        game.GameState.CustomCharacterFavoriteDressList = {}
    end
    for characterName, _ in pairs(CharacterData) do
        game.GameState.CustomCharacterFavoriteDressList[characterName] = game.GameState.CustomCharacterFavoriteDressList[characterName] or {}
    end
    if config.random_each_run then
        mod.SetRandomDress()
    else
        local currentCharacter = mod.GetCurrentCharacter()
        game.CurrentRun.Hero[_PLUGIN.guid .. "RandomDressData"] = game.CurrentRun.Hero[_PLUGIN.guid .. "RandomDressData"] or {}
        game.CurrentRun.Hero[_PLUGIN.guid .. "RandomDressData"][currentCharacter] = nil
    end
    return retValue
end)

function mod.CheckDressInFavorite(dressName)
    local modFavoriteList = game.GameState.ModFavoriteDressList
    local currentCharacter = mod.GetCurrentCharacter()
    if currentCharacter ~= "Default" then
        modFavoriteList = game.GameState.CustomCharacterFavoriteDressList[currentCharacter]
    end
    return game.Contains(modFavoriteList, dressName)
end

function mod.RemoveFavoriteDress(dressName)
    local modFavoriteList = game.GameState.ModFavoriteDressList
    local currentCharacter = mod.GetCurrentCharacter()
    if currentCharacter ~= "Default" then
        modFavoriteList = game.GameState.CustomCharacterFavoriteDressList[currentCharacter]
    end
    local index = game.GetIndex(modFavoriteList, dressName)
    if index == 0 then
        print("trying to remove unknown dress")
        return
    end
    game.RemoveIndexAndCollapse(modFavoriteList, index)
end

function mod.AddFavoriteDress(dressName)
    local currentCharacter = mod.GetCurrentCharacter()
    if currentCharacter == "Default" then
        table.insert(game.GameState.ModFavoriteDressList, dressName)
    else
        table.insert(game.GameState.CustomCharacterFavoriteDressList[currentCharacter], dressName)
    end
end

modutil.mod.Path.Wrap("SetupHeroObject", function (base, ...)
    game.CurrentRun.Hero.LightBarColor[_PLUGIN.guid .. "SwapWithDressColor"] = true
    base(...)
    local dress = mod.GetCurrentDressConfig()
    if game.CurrentRun.Hero.ObjectId == 39999 then
        dress = config.dress2
    end
    if config.random_each_run then
        dress = mod.GetCurrentRunDress()
    end
    local modDressData = mod.GetModDressData()
    if dress and modDressData[dress] and (modDressData[dress].ArmGlow or modDressData[dress].LaurelCinderHue) then
        game.StopAnimation({ Name = "LaurelCindersSpawner", DestinationId = game.CurrentRun.Hero.ObjectId })
        game.StopAnimation({ Name = game.MapState[_PLUGIN.guid .. "LaurelCindersSpawner"], DestinationId = game.CurrentRun.Hero.ObjectId })
        game.CreateAnimation({ Name = dress .. "LaurelCindersSpawner", DestinationId = game.CurrentRun.Hero.ObjectId })
        game.MapState[_PLUGIN.guid .. "LaurelCindersSpawner"] = dress .. "LaurelCindersSpawner"
        if modDressData[dress].ArmGlow then
            game.MapState[_PLUGIN.guid .. "PrevArmGlowAnimation"] = dress .. "MelArmGlow"
        end
    else
        game.MapState[_PLUGIN.guid .. "LaurelCindersSpawner"] = "LaurelCindersSpawner"
    end
    if dress and modDressData[dress] and modDressData[dress].DisableMelArmGlow then
        game.StopAnimation({ Name = "MelArmGlow", DestinationId = game.CurrentRun.Hero.ObjectId })
    end
end)

modutil.mod.Path.Wrap("ArachneArmorApply", function (base, screen, args)
    base(screen, args)
    game.SetLightBarColor({ PlayerIndex = 1, Color = game.CurrentRun.Hero.LightBarColor or game.HeroData.LightBarColor })
end)

modutil.mod.Path.Wrap("ProcessHeroTraitChanges", function (base, trait, reverse)
    base(trait, reverse)
    if trait.Costume and reverse then
        game.SetLightBarColor({ PlayerIndex = 1, Color = game.CurrentRun.Hero.LightBarColor or game.HeroData.LightBarColor })
    end
end)

modutil.mod.Path.Wrap("CreateNewHero", function (base, prevRun, args)
    local hero = base(prevRun, args)
    hero.LightBarColor[_PLUGIN.guid .. "SwapWithDressColor"] = true
    return hero
end)

modutil.mod.Path.Wrap("SetLightBarColor", function (base, args)
    args = args or {}
    if args.Color and args.Color[_PLUGIN.guid .. "SwapWithDressColor"] then
        print("Swapping default LightBarColor", mod.dump(args.Color))
        local dress = mod.GetCurrentDress()
        local modDressData = mod.GetModDressData()
        local dressData = modDressData[dress]
        local dressColor = dressData.Color
        if dress == "Custom" then
            local preset = mod.PresetTable["LastApplied"] or mod.PresetTable["Default"]
            local presetDress = preset.Dress or mod.PresetTable["Default"].Dress
            if presetDress.Type == "Color" then
                dressColor = { presetDress.R, presetDress.G, presetDress.B, 255 }
            elseif presetDress.Type == "Base" then
                dressColor = mod.DressData[presetDress.Base].Color
            end
        end
        if dressColor then
            args.Color = dressColor
        else
            args.Color = game.DeepCopyTable(args.Color)
            args.Color[_PLUGIN.guid .. "SwapWithDressColor"] = nil
        end
        print("Swapped LightBarColor", mod.dump(args.Color))
    end
    return base(args)
end)