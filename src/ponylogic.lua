function mod.OpenDressSelector()
    if IsScreenOpen("DressSelector") then
        return
    end
    local screen = DeepCopyTable(ScreenData.DressSelector)
    screen.Amount = 0
    screen.FirstPage = 0
    screen.LastPage = 0
    screen.CurrentPage = screen.FirstPage
    local components = screen.Components

    if config.random_each_run then
        screen.ComponentData.Background.Children.RandomDressButton.TextArgs.Color = Color.Orange
    end

    if game.GameState ~= nil and game.GameState.ModFavoriteDressList == nil then
        game.GameState.ModFavoriteDressList = {}
    end

    OnScreenOpened(screen)
    HideCombatUI(screen.Name)
    CreateScreenFromData(screen, screen.ComponentData)

    local index = 0
    screen.DressList = {}
    for _, dressName in ipairs(mod.DressDisplayOrder) do
        local rowOffset = 100
        local columnOffset = 285
        local boonsPerRow = 5
        local rowsPerPage = 7
        local rowIndex = math.floor(index / boonsPerRow)
        local pageIndex = math.floor(rowIndex / rowsPerPage)
        local offsetX = screen.RowStartX + columnOffset * (index % boonsPerRow) - 100
        local offsetY = screen.RowStartY + rowOffset * (rowIndex % rowsPerPage)
        index = index + 1
        screen.LastPage = pageIndex
        if screen.DressList[pageIndex] == nil then
            screen.DressList[pageIndex] = {}
        end
        table.insert(screen.DressList[pageIndex],{
            index = index,
            pageIndex = pageIndex,
            offsetX = offsetX,
            offsetY = offsetY,
            key = dressName
        })
    end

    mod.ApplyMenuZoom()

    mod.DressSelectorLoadPage(screen)
    SetColor({ Id = components.BackgroundTint.Id, Color = Color.Black })
    SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.0, Duration = 0 })
    SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.9, Duration = 0.3 })
    wait(0.3)
    SetConfigOption({ Name = "ExclusiveInteractGroup", Value = "Combat_Menu_TraitTray" })
    screen.KeepOpen = true
    HandleScreenInput(screen)
end

function  mod.DressSelectorLoadPage(screen)
    -- mod.BoonManagerPageButtons(screen, screen.Name)
    local pageDress = screen.DressList[screen.CurrentPage]
    if pageDress then
        for i, dressButtonData in pairs(pageDress) do
            local dressKey = "DressKey" .. dressButtonData.index
            screen.Components[dressKey] = CreateScreenComponent({
                Name = "ButtonDefault",
                Group = "Combat_Menu_TraitTray",
                Scale = 1.1,
                ScaleX = 0.85,
                ToDestroy = true
            })
            SetInteractProperty({
                DestinationId = screen.Components[dressKey].Id,
                Property = "TooltipOffsetY",
                Value = 100
            })
            screen.Components[dressKey].OnPressedFunctionName = mod.SetDress
            screen.Components[dressKey].OnMouseOverFunctionName = mod.DressMouseOverButton
            screen.Components[dressKey].OnMouseOffFunctionName = mod.DressMouseOffButton
            screen.Components[dressKey].Dress = dressButtonData.key
            screen.Components[dressKey].Index = dressButtonData.index
            screen.Components[dressKey].Screen = screen

            if mod.CheckDressInFavorite(dressButtonData.key) then
                local icon = {
                    Name = "BlankObstacle",
                    Animation = "FilledHeartIcon",
                    Scale = 0.5,
                    Group = "Combat_Menu_TraitTray",
                    ToDestroy = true
                }
                screen.Components[dressKey.."Icon"] = CreateScreenComponent(icon)
                screen.Components[dressKey].Icon = screen.Components[dressKey.."Icon"]
            end

            Attach({
                Id = screen.Components[dressKey].Id,
                DestinationId = screen.Components.Background.Id,
                OffsetX = dressButtonData.offsetX,
                OffsetY = dressButtonData.offsetY
            })
            local text = dressButtonData.key
            local color = Color.White
            if config.dress == text and config.random_each_run == false then
                color = Color.Orange
            end
            if config.random_each_run == true and CurrentRun.Hero.ModDressData == text then
                color = Color.Orange
            end
            print(text)
            CreateTextBox({
                Id = screen.Components[dressKey].Id,
                Text = text,
                FontSize = 20,
                OffsetX = 0,
                OffsetY = 0,
                Width = 400,
                Color = color,
                Font = "P22UndergroundSCMedium",
                ShadowBlur = 0,
                ShadowColor = { 0, 0, 0, 1 },
                ShadowOffset = { 0, 2 },
                Justification = "Center"
            })
            if mod.CheckDressInFavorite(dressButtonData.key) then
                Attach({
                    Id = screen.Components[dressKey .. "Icon"].Id,
                    DestinationId = screen.Components[dressKey].Id,
                    OffsetX = -125,
                    OffsetY = -30
                })
            end
        end
    end
end

function mod.DressMouseOverButton(button)
    local screen = button.Screen
    if screen.Closing then
        return
    end
    game.GenericMouseOverPresentation( button )
    screen.SelectedItem = button

	-- update just for preview
    local dressGrannyTexture = mod.GetDressGrannyTexture(button.Dress)
    SetThingProperty({Property = "GrannyTexture", Value = dressGrannyTexture, DestinationId = CurrentRun.Hero.ObjectId})
end

function mod.DressMouseOffButton(button)
    local screen = button.Screen
    screen.SelectedItem = nil

    game.SetupCostume()
end

function mod.SetDress(screen,button)
    local dressGrannyTexture = mod.GetDressGrannyTexture(button.Dress)
    print("Dress", button.Dress)
    print("DressGrannyTexture", dressGrannyTexture)
    config.dress = button.Dress
    config.random_each_run = false
    game.SetupCostume()
    mod.DressSelectorReloadPage(screen)
end

function mod.DressSelectorReloadPage(screen)
    local ids = {}
    for i, component in pairs(screen.Components) do
        if component.RandomButtonId == "RandomButtonId" then
            print("randombuttonreload", screen.Components[i].Text)
            screen.Components[i].Color = Color.White
            if config.random_each_run then
                screen.Components[i].Color = Color.Orange
            end
            ModifyTextBox({Id = screen.Components[i].Id, Color = screen.Components[i].Color})
        end
        if component.ToDestroy then
            table.insert(ids, component.Id)
        end
    end
    Destroy({ Ids = ids })
    mod.DressSelectorLoadPage(screen)
end

function mod.ToggleRandomDressSelection(screen, button)
    config.random_each_run = config.random_each_run == false
    local color = Color.White
    if config.random_each_run then
        color = Color.Orange
    end
	game.SetupCostume()
    ModifyTextBox({Id = button.Id, Color = color})
    mod.DressSelectorReloadPage(screen)
end

function mod.CloseDressSelector(screen)
    ShowCombatUI(screen.Name)
    SetConfigOption({ Name = "ExclusiveInteractGroup", Value = nil })
    OnScreenCloseStarted(screen)
    CloseScreen(GetAllIds(screen.Components), 0.15)
    OnScreenCloseFinished(screen)
    notifyExistingWaiters("DressSelector")
    mod.ResetMenuZoom()
	game.SetupCostume()
end

function mod.ToggleFavriteDressSelection(screen, button)
    if screen.SelectedItem == nil then
        return
    end
    local dressName = screen.SelectedItem.Dress
    print("favorite toggle",dressName)
    if mod.CheckDressInFavorite(dressName) then
        mod.RemoveFavoriteDress(dressName)
    else
        mod.AddFavoriteDress(dressName)
    end
    mod.DressSelectorReloadPage(screen)
end

function mod.ResetFavorites(screen, button)
    game.GameState.ModFavoriteDressList = {}
    mod.DressSelectorReloadPage(screen)
end

function mod.FavoriteAll(screen, button)
    game.GameState.ModFavoriteDressList = game.DeepCopyTable(mod.DressDisplayOrder)
    mod.DressSelectorReloadPage(screen)
end

function mod.ApplyMenuZoom()

    if CurrentRun.CurrentRoom ~= nil then
        if CurrentRun.CurrentRoom.CameraZoomWeights ~= nil then
            for id, _ in pairs( CurrentRun.CurrentRoom.CameraZoomWeights ) do
                SetCameraZoomWeight({ Id = id, Weight = 1, ZoomSpeed = 1.0 })
            end
        end
    end

    if CurrentHubRoom ~= nil then
        if CurrentHubRoom.CameraZoomWeights ~= nil then
            for id, _ in pairs( CurrentHubRoom.CameraZoomWeights ) do
                SetCameraZoomWeight({ Id = id, Weight = 1, ZoomSpeed = 1.0 })
            end
        end
    end

    ClearCameraClamp({ LerpTime = 0 })
    local offsetY = -70
    if HeroHasTrait("TorchAutofireAspect") then
        offsetY = -110
    end
    game.thread(LockCamera,{Id = CurrentRun.Hero.ObjectId, OffsetX = -265, OffsetY = offsetY, Duration = 0.3})
    AdjustZoom({ Fraction = 2.8, Duration = 0.3 })
end

function mod.ResetMenuZoom()
    local defaultZoom = 1.0
    if CurrentHubRoom ~= nil then
        defaultZoom = CurrentHubRoom.ZoomFraction or defaultZoom
    else
        defaultZoom = CurrentRun.CurrentRoom.ZoomFraction or defaultZoom
    end

    if CurrentRun.CurrentRoom ~= nil then
        if CurrentRun.CurrentRoom.CameraZoomWeights ~= nil then
            for id, weight in pairs( CurrentRun.CurrentRoom.CameraZoomWeights ) do
                SetCameraZoomWeight({ Id = id, Weight = weight, ZoomSpeed = 1.0 })
            end
        end
    end

    if CurrentHubRoom ~= nil then
        if CurrentHubRoom.CameraZoomWeights ~= nil then
            for id, weight in pairs( CurrentHubRoom.CameraZoomWeights ) do
                SetCameraZoomWeight({ Id = id, Weight = weight, ZoomSpeed = 1.0 })
            end
        end
    end

    game.thread(LockCamera,{Id = CurrentRun.Hero.ObjectId, Duration = 0.3})
    AdjustZoom({ Fraction = defaultZoom, Duration = 0.3 })
end

function mod.PopulatePonyMenuData()
    mod.ponyMenu = rom.mods["PonyWarrior-PonyMenu"]
    if mod.ponyMenu ~= nil and mod.ponyMenu.CommandData ~= nil then
        ModUtil.Table.Merge(ScreenData,mod.DressScreenData)
        table.insert(mod.ponyMenu.CommandData,mod.DressCommandData)
    end
end