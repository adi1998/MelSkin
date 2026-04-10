function mod.OpenDressSelector()
    if game.IsScreenOpen("DressSelector") then
        return
    end
    local screen = game.DeepCopyTable(game.ScreenData.DressSelector)
    screen.Amount = 0
    screen.FirstPage = 0
    screen.LastPage = 0
    screen.CurrentPage = screen.FirstPage
    local components = screen.Components

    if config.random_each_run then
        screen.ComponentData.Background.Children.RandomDressButton.TextArgs.Color = game.Color.Orange
    end

    if game.GameState ~= nil and game.GameState.ModFavoriteDressList == nil then
        game.GameState.ModFavoriteDressList = {}
    end

    game.OnScreenOpened(screen)
    game.HideCombatUI(screen.Name)
    game.CreateScreenFromData(screen, screen.ComponentData)

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
    game.thread(mod.StartHeroRotation)

    mod.DressSelectorLoadPage(screen)
    game.SetColor({ Id = components.BackgroundTint.Id, Color = game.Color.Black })
    game.SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.0, Duration = 0 })
    game.SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.9, Duration = 0.3 })
    game.wait(0.3)
    game.SetConfigOption({ Name = "ExclusiveInteractGroup", Value = "Combat_Menu_TraitTray" })
    screen.KeepOpen = true
    game.HandleScreenInput(screen)
end

function  mod.DressSelectorLoadPage(screen)
    -- mod.BoonManagerPageButtons(screen, screen.Name)
    local pageDress = screen.DressList[screen.CurrentPage]
    if pageDress then
        for i, dressButtonData in pairs(pageDress) do
            local dressKey = "DressKey" .. dressButtonData.index
            screen.Components[dressKey] = game.CreateScreenComponent({
                Name = "ButtonDefault",
                Group = "Combat_Menu_TraitTray",
                Scale = 1.1,
                ScaleX = 0.85,
                ToDestroy = true
            })
            game.SetInteractProperty({
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
                screen.Components[dressKey.."Icon"] = game.CreateScreenComponent(icon)
                screen.Components[dressKey].Icon = screen.Components[dressKey.."Icon"]
            end

            game.Attach({
                Id = screen.Components[dressKey].Id,
                DestinationId = screen.Components.Background.Id,
                OffsetX = dressButtonData.offsetX,
                OffsetY = dressButtonData.offsetY
            })
            local text = dressButtonData.key
            local color = game.Color.White
            if config.dress == text and config.random_each_run == false then
                color = game.Color.Orange
            end
            if config.random_each_run == true and game.CurrentRun.Hero.ModDressData == text then
                color = game.Color.Orange
            end
            print(text)
            game.CreateTextBox({
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
                game.Attach({
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
    game.SetThingProperty({Property = "GrannyTexture", Value = dressGrannyTexture, DestinationId = game.CurrentRun.Hero.ObjectId})
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
    game.SetLightBarColor({ PlayerIndex = 1, Color = game.CurrentRun.Hero.LightBarColor or game.HeroData.LightBarColor })
    mod.DressSelectorReloadPage(screen)
end

function mod.DressSelectorReloadPage(screen)
    local ids = {}
    for i, component in pairs(screen.Components) do
        if component.RandomButtonId == "RandomButtonId" then
            print("randombuttonreload", screen.Components[i].Text)
            screen.Components[i].Color = game.Color.White
            if config.random_each_run then
                screen.Components[i].Color = game.Color.Orange
            end
            game.ModifyTextBox({Id = screen.Components[i].Id, Color = screen.Components[i].Color})
        end
        if component.ToDestroy then
            table.insert(ids, component.Id)
        end
    end
    game.Destroy({ Ids = ids })
    mod.DressSelectorLoadPage(screen)
end

function mod.ToggleRandomDressSelection(screen, button)
    config.random_each_run = config.random_each_run == false
    local color = game.Color.White
    if config.random_each_run then
        color = game.Color.Orange
    end
	game.SetupCostume()
    game.SetLightBarColor({ PlayerIndex = 1, Color = game.CurrentRun.Hero.LightBarColor or game.HeroData.LightBarColor })
    game.ModifyTextBox({Id = button.Id, Color = color})
    mod.DressSelectorReloadPage(screen)
end

function mod.CloseDressSelector(screen)
    game.ShowCombatUI(screen.Name)
    game.SetConfigOption({ Name = "ExclusiveInteractGroup", Value = nil })
    game.OnScreenCloseStarted(screen)
    game.CloseScreen(game.GetAllIds(screen.Components), 0.15)
    game.OnScreenCloseFinished(screen)
    game.notifyExistingWaiters("DressSelector")
    mod.ResetMenuZoom()
	game.SetupCostume()
    game.killTaggedThreads(_PLUGIN.guid .. "StartHeroRotation")
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

    if game.CurrentRun.CurrentRoom ~= nil then
        if game.CurrentRun.CurrentRoom.CameraZoomWeights ~= nil then
            for id, _ in pairs( game.CurrentRun.CurrentRoom.CameraZoomWeights ) do
                game.SetCameraZoomWeight({ Id = id, Weight = 1, ZoomSpeed = 1.0 })
            end
        end
    end

    if game.CurrentHubRoom ~= nil then
        if game.CurrentHubRoom.CameraZoomWeights ~= nil then
            for id, _ in pairs( game.CurrentHubRoom.CameraZoomWeights ) do
                game.SetCameraZoomWeight({ Id = id, Weight = 1, ZoomSpeed = 1.0 })
            end
        end
    end

    game.ClearCameraClamp({ LerpTime = 0 })
    local offsetY = -70
    if game.HeroHasTrait("TorchAutofireAspect") then
        offsetY = -110
    end

    if game.CurrentHubRoom and game.CurrentHubRoom.Name == "Hub_Main" then
        game.thread(game.LockCamera,{Id = game.CurrentRun.Hero.ObjectId, OffsetX = -530, OffsetY = offsetY, Duration = 0.35})
        game.AdjustZoom({ Fraction = 1.4, Duration = 0.35 })
        game.SetScale({ Id = game.CurrentRun.Hero.ObjectId, Fraction = 1.7 })
    else
        game.thread(game.LockCamera,{Id = game.CurrentRun.Hero.ObjectId, OffsetX = -265, OffsetY = offsetY, Duration = 0.35})
        game.AdjustZoom({ Fraction = 2.8, Duration = 0.35 })
    end
end

function mod.ResetMenuZoom()
    local defaultZoom = 1.0
    if game.CurrentHubRoom ~= nil then
        defaultZoom = game.CurrentHubRoom.ZoomFraction or defaultZoom
    else
        defaultZoom = game.CurrentRun.CurrentRoom.ZoomFraction or defaultZoom
    end

    if game.CurrentRun.CurrentRoom ~= nil then
        if game.CurrentRun.CurrentRoom.CameraZoomWeights ~= nil then
            for id, weight in pairs( game.CurrentRun.CurrentRoom.CameraZoomWeights ) do
                game.SetCameraZoomWeight({ Id = id, Weight = weight, ZoomSpeed = 1.0 })
            end
        end
    end

    if game.CurrentHubRoom ~= nil then
        if game.CurrentHubRoom.CameraZoomWeights ~= nil then
            for id, weight in pairs( game.CurrentHubRoom.CameraZoomWeights ) do
                game.SetCameraZoomWeight({ Id = id, Weight = weight, ZoomSpeed = 1.0 })
            end
        end
    end

    game.thread(game.LockCamera,{Id = game.CurrentRun.Hero.ObjectId, Duration = 0.3})
    game.AdjustZoom({ Fraction = defaultZoom, Duration = 0.3 })
    if game.CurrentHubRoom and game.CurrentHubRoom.Name == "Hub_Main" then
        game.SetScale({ Id = game.CurrentRun.Hero.ObjectId, Fraction = 1 })
    end
end

-- courtsey of @magic_gonads
local world_to_screen
local screen_to_world

local a,b = 1, 0 -- or 0.5, 0 if it's the wrong way around
local c,d = 0, 0.5 -- or 0, 1 if it's the wrong way around

function world_to_screen(world_angle)
    local t = world_angle

    -- world coords
    -- assuming z = 0
    -- don't need radius as it will cancel in atan2
    local x = math.cos(t)
    local y = math.sin(t)

    -- world coords -> screen coords
    local x2 = a*x + b*y
    local y2 = c*x + d*y

    -- screen angle
    return math.atan2(y2,x2) -- y first in lua's atan2
end

function screen_to_world(screen_angle)
    local t = screen_angle

    -- screen coords
    -- don't need radius as it will cancel in atan2
    local x = math.cos(t)
    local y = math.sin(t)

    -- world coords -> screen coords
    -- assuming z = 0
    -- don't need to divide by determinant as it will cancel in atan2
    local x2 = d*x - b*y
    local y2 = a*y - c*x

    -- world angle
    return math.atan2(y2,x2) -- y first in lua's atan2
end

function mod.StartHeroRotation()
    local angle = 0
    local step = 0.5
    while true do
        local angle_used = math.deg(world_to_screen(math.rad(angle)))
        game.SetGoalAngle({Id = game.CurrentRun.Hero.ObjectId, Angle = angle_used})
        game.waitUnmodified(1/120, _PLUGIN.guid .. "StartHeroRotation")
        angle = (angle + step)%360
    end
end