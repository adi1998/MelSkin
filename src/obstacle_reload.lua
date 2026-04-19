local dressMenuObstacle = {
    Name = _PLUGIN.guid .. "DressMenuObstacle",
    InteractDistance = 120,
    UseText = "{I} Change Dress",
    OnUsedFunctionName = _PLUGIN.guid .. '.' .. "OpenDressSelectorFromObstacle",
    Activate = true,
}

function mod.SpawnDressObstaclePreRun()
    local dressObstacle = game.DeepCopyTable(dressMenuObstacle)
    print("spawning dress menu obstacle")
    dressObstacle.InteractOffsetX = -130
    dressObstacle.InteractOffsetY = 100
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
end

function mod.SpawnDressObstacleHubMain()
    local shelfObstacle = game.DeepCopyTable(dressMenuObstacle)
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

    mod.OpenDressSelector()

    if obstacle.ObjectId == 566827 then
        game.SetAlpha({ Id = game.CurrentRun.Hero.ObjectId, Fraction = 0, Duration = 0 })
        game.Teleport({ Id = game.CurrentRun.Hero.ObjectId, OffsetX = storedLocation.X, OffsetY = storedLocation.Y })
        game.SetGoalAngle({ Id = game.CurrentRun.Hero.ObjectId, Angle = storedAngle, CompleteAngle = true })
        game.thread(mod.MelinoeDressPresentationOut)
    end
end