local dressMenuObstacle_HubMain = {
    Name = _PLUGIN.guid .. "DressMenuObstacle",
    InteractDistance = 150,
    UseText = "{I} Change Dress",
    OnUsedFunctionName = _PLUGIN.guid .. '.' .. "OpenDressSelectorFromObstacle",
    Activate = true,
    SetupEvents =
    {
        {
            FunctionName = "PlayStatusAnimation",
            Args = { Animation = "StatusIconNewItemsInStock", AnimOffsetZ = 120 },
            GameStateRequirements =
            {
                {
                    FunctionName = _PLUGIN.guid .. "." .. "HasUnviewedCostumeItem",
                    FunctionArgs = {
                        SkipCustomCharacter = true
                    }
                },
            },
        },
    }
}

local dressMenuObstacle_HubPreRun = {
    Name = _PLUGIN.guid .. "DressMenuObstacle",
    InteractDistance = 120,
    InteractOffsetX = -130,
    InteractOffsetY = 100,
    UseText = "{I} Change Dress",
    OnUsedFunctionName = _PLUGIN.guid .. '.' .. "OpenDressSelectorFromObstacle",
    Activate = true,
    SetupEvents =
    {
        {
            FunctionName = "PlayStatusAnimation",
            Args = { Animation = "StatusIconNewItemsInStock", AnimOffsetZ = -10 },
            GameStateRequirements =
            {
                {
                    FunctionName = _PLUGIN.guid .. "." .. "HasUnviewedCostumeItem",
                },
            },
        },
    }
}

function mod.SpawnDressObstaclePreRun()
    local dressObstacle = game.DeepCopyTable(dressMenuObstacle_HubPreRun)
    dressObstacle.ObjectId = game.SpawnObstacle({
        Name = _PLUGIN.guid .. "DressMenuObstacle",
        Group = "Standing",
        DestinationId = 587351, -- chair id
        OffsetX = 100,
        OffsetY = -180,
        OffSetZ = 300,
        AttachedTable = dressObstacle,
    })
    dressObstacle.ActivateIds = { dressObstacle.ObjectId }
    game.SetupObstacle(dressObstacle)

    game.FlipHorizontal({ Id = dressObstacle.ObjectId })

    -- brighness fix, it just works
    game.SetThingProperty({Property = "AddColor", Value = true, DestinationId = dressObstacle.ObjectId })
    game.SetColor({ Id = dressObstacle.ObjectId, Color = {0,0,0,1} })
    mod.dressObstacleId = dressObstacle.ObjectId
    game.SessionMapState[_PLUGIN.guid .. "DressObstacle"] = dressObstacle
end

function mod.SpawnDressObstacleHubMain()
    local shelfObstacle = game.DeepCopyTable(dressMenuObstacle_HubMain)
    shelfObstacle.ObjectId = 566827 -- shelf id
    shelfObstacle.ActivateIds = { shelfObstacle.ObjectId }
    print("making shelf interactable")
    game.SetupObstacle(shelfObstacle)
end

function mod.MelinoeDressPresentationIn()
    game.wait( 0.4, game.RoomThreadName)
    game.CreateAnimation({ Name = "TeleportDisappear", DestinationId = game.CurrentRun.Hero.ObjectId, Scale = 0.9 })
    game.wait( 0.05, game.RoomThreadName )
    game.SetAlpha({ Id = game.CurrentRun.Hero.ObjectId, Fraction = 1.0, Duration = 0 })
end

function mod.MelinoeDressPresentationOut()
    game.wait( 0.4, game.RoomThreadName)
    game.CreateAnimation({ Name = "TeleportDisappear", DestinationId = game.CurrentRun.Hero.ObjectId, Scale = 0.53 })
    game.wait( 0.05, game.RoomThreadName )
    game.SetAlpha({ Id = game.CurrentRun.Hero.ObjectId, Fraction = 1.0, Duration = 0 })
end

function mod.OpenDressSelectorFromObstacle(obstacle, args, user)
    local storedLocation
    local storedAngle
    if obstacle.ObjectId == 566827 then
        storedLocation = game.GetLocation({Id = game.CurrentRun.Hero.ObjectId})
        storedAngle = game.GetAngle({Id = game.CurrentRun.Hero.ObjectId})
        game.SetAlpha({ Id = game.CurrentRun.Hero.ObjectId, Fraction = 0, Duration = 0 })
        game.Teleport({ Id = game.CurrentRun.Hero.ObjectId, DestinationId = 566827, OffsetX = -590, OffsetY = -520 })
        game.SetAngle({ Id = game.CurrentRun.Hero.ObjectId, Angle = 315 })
        game.thread(mod.MelinoeDressPresentationIn)
    end

    mod.OpenDressSelectorHorribleCoopHack(obstacle)

    if obstacle.ObjectId == 566827 then
        game.SetAlpha({ Id = game.CurrentRun.Hero.ObjectId, Fraction = 0, Duration = 0 })
        game.Teleport({ Id = game.CurrentRun.Hero.ObjectId, OffsetX = storedLocation.X, OffsetY = storedLocation.Y })
        game.SetGoalAngle({ Id = game.CurrentRun.Hero.ObjectId, Angle = storedAngle, CompleteAngle = true })
        game.thread(mod.MelinoeDressPresentationOut)
    end
end

function mod.HasUnviewedCostumeItem( source, args )
    if not source then
        return
    end
	args = args or {}
    local modDressData = mod.GetModDressData()
    local characterName = mod.GetCurrentCharacter()
    if args.SkipCustomCharacter then
        modDressData = mod.DressData
        characterName = "Default"
    end

    for dressName, dressData in pairs( modDressData ) do
        if not game.GameState[_PLUGIN.guid .. "CostumeViewRecord"][characterName][dressName] then
            if game.IsEmpty(dressData.GameStateRequirements) or game.IsGameStateEligible( source, dressData.GameStateRequirements ) then
                return true
            end
        end
    end
	return false
end

function mod.CheckRestartStatusAnimation(source)
    game.wait(0.2)
    game.RunEventsGeneric(source.SetupEvents, source)
end

function mod.StatusAnimationPollThread()
    game.wait(1, _PLUGIN.guid .. "StatusAnimationPollThread")
    local obstacle = game.SessionMapState[_PLUGIN.guid .. "DressObstacle"]
    local currentState = mod.HasUnviewedCostumeItem(obstacle)
    while true do
        if obstacle then
            local newState = mod.HasUnviewedCostumeItem(obstacle)
            if newState ~= currentState then
                if newState then
                    game.RunEventsGeneric(obstacle.SetupEvents, obstacle)
                else
                    game.StopStatusAnimation(obstacle)
                end
                currentState = newState
            end
        end
        game.wait(2, _PLUGIN.guid .. "StatusAnimationPollThread")
    end
end