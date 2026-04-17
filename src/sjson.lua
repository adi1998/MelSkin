local guiPortraitsVFXFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\GUI_Portraits_VFX.sjson")
local guiScreensVFXFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\GUI_Screens_VFX.sjson")
local guiFile = rom.path.combine(rom.paths.Content(), "Game\\Obstacles\\GUI.sjson")
local modPortraitPrefix = "zerp-MelSkinPortraits\\"

mod.BoonSelectAnims = {
    {
        Name = "BoonSelectMelIn",
        FilePath = "",
        Material = "Unlit",
        StartOffsetX = -660,
        EndOffsetX = -640,
        VisualFx = "BoonSelectMelFxLoop",
        VisualFxIntervalMin = 0.5,
        VisualFxIntervalMax = 0.5,
        VisualFxCap = 1,
        EndAlpha = 1.0,
        Duration = 0.1,
        HoldLastFrame = true,
        NumFrames = 1,
        StartFrame = 1,
        StartOffsetY = 50,
        EndOffsetY = 0,
        EndBlue = 1.0,
		EndGreen = 1.0,
		EndRed = 1.0,
        StartAlpha = 0,
    },
    {
        Name = "BoonSelectMelOut",
        FilePath = "",
        Material = "Unlit",
        EndAlpha = 0.0,
		EndBlue = 0.0,
		EndGreen = 0.0,
		EndRed = 0.0,
		StartAlpha = 1.0,
		StartBlue = 1.0,
		StartGreen = 1.0,
		StartRed = 1.0,
		EndFrame = 1,
		HoldLastFrame = false,
		StartFrame = 1,
		EndOffsetX = -620,
		StartOffsetX = -640,
        StartOffsetY = 0,
        EndOffsetY = -50,
        Duration = 0.05
    }
}

mod.BoonSelectObstacle =
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

mod.ZagMelSubTemplate =
{
    Name = "",
    InheritFrom = "Portrait_Base_01",
    FilePath = "",
    OffsetY = 32,
    OffsetX = 0,
    SortMode = "Id"
}

mod.ZagMelCombinedTemplate =
{
    Name = _PLUGIN.guid .. "Mel",
    InheritFrom = "Portrait_Base_01",
    FilePath = "",
    OffsetY = 10,
    OffsetX = -185,
    Scale = 0.64,
    Alpha = 0.7,
    SortMode = "Id",
    CreateAnimations = {
        { Name = "" }
    }
}

local function modifyNewEntryOverlays(entry, modifications, anim_data_table, prefix)
    if type(modifications) ~= "table" then
        return {}
    end
    local createAnimations = entry.CreateAnimations or {}
    local new_entries = {}
    for animName, mod_table in pairs(modifications) do
        if type(mod_table) == "string" and mod_table == "nil" then
            local index = 0
            for i, animEntry in ipairs(createAnimations) do
                if animEntry.Name == animName then
                    index = i
                    break
                end
            end
            if index > 0 then
                game.RemoveIndexAndCollapse(createAnimations, index)
            end
        elseif type(mod_table) == "table" then
            local animData = game.DeepCopyTable(anim_data_table[animName])
            for key, value in pairs(mod_table) do
                if key == "VisualFx" and type(value) == "table" and value.Name == "LaurelBurnIris" then
                    local laurelAnim = game.DeepCopyTable(anim_data_table[value.Name])
                    local laurelSubAnims = laurelAnim.Random or {}
                    for _, subAnim in ipairs(laurelSubAnims) do
                        local subAnimData = game.DeepCopyTable(anim_data_table[subAnim.Name])
                        subAnimData.Hue = value.Hue or subAnimData.Hue
                        subAnimData.Name = prefix .. subAnimData.Name
                        subAnim.Name = subAnimData.Name
                        table.insert(new_entries, subAnimData)
                    end
                    laurelAnim.Name = prefix .. laurelAnim.Name
                    table.insert(new_entries, laurelAnim)
                    animData[key] = laurelAnim.Name
                else
                    if key == "UpdateChainTo" and value and animData.ChainTo then
                        animData.ChainTo = prefix .. animData.ChainTo
                    else
                        animData[key] = value
                    end
                end
            end
            for i, animEntry in ipairs(createAnimations) do
                if animEntry.Name == animName then
                    animEntry.Name = prefix .. animEntry.Name
                end
            end
            animData.Name = prefix .. animData.Name
            table.insert(new_entries, animData)
        end
    end
    entry.CreateAnimations = createAnimations
    return new_entries
end

sjson.hook(guiPortraitsVFXFile, function(data)
    local newdata = {}
    local name_data_map = {}
    for _, entry in ipairs(data.Animations) do
        if type(entry.Name) == "string" then
            name_data_map[entry.Name] = entry
        end
    end
    for _, entry in ipairs(data.Animations) do
        local origname = entry.Name
        local origfilename = mod.PortraitNameFileMap[origname]
        if origfilename ~= nil then
            for dress, dressData in pairs(mod.DressData) do
                if dressData.Portraits ~= nil and dressData.Portraits[origfilename] then
                    local newname = dress .. "_" .. origname
                    local newfilepath = modPortraitPrefix .. dress .. "\\" .. origfilename
                    local newentry = game.DeepCopyTable(entry)
                    newentry.Name = newname
                    newentry.FilePath = newfilepath
                    local newSubEntries = modifyNewEntryOverlays(newentry, dressData.PortraitOverlayModifacations, name_data_map, dress)
                    for _, value in pairs(newSubEntries) do
                        table.insert(newdata, value)
                    end
                    table.insert(newdata,newentry)
                end
            end
        end
    end
    for zagPortraitName, fileNames in pairs(mod.ZagMelMap) do
        for dress, dressData in pairs(mod.DressData) do
            if dressData.Portraits ~= nil and dressData.Portraits[fileNames[1]] ~= nil then
                local newSubPortrait = game.DeepCopyTable(mod.ZagMelSubTemplate)

                local newPortrait = game.DeepCopyTable(mod.ZagMelCombinedTemplate)
                newPortrait.Name = dress .. zagPortraitName
                newPortrait.FilePath = modPortraitPrefix .. dress .. "\\" .. fileNames[1]
                newPortrait.CreateAnimations[1].Name = newPortrait.Name .. "SubPortrait"

                newSubPortrait.Name = newPortrait.CreateAnimations[1].Name
                newSubPortrait.FilePath = modPortraitPrefix .. fileNames[2]

                table.insert(newdata, newSubPortrait)
                table.insert(newdata, newPortrait)
                local newSubPortraitExit = game.DeepCopyTable(newSubPortrait)
                newSubPortraitExit.InheritFrom = newSubPortraitExit.InheritFrom .. "_Exit"
                newSubPortraitExit.Name = newSubPortraitExit.Name .. "_Exit"

                local newPortraitExit = game.DeepCopyTable(newPortrait)
                newPortraitExit.InheritFrom = newPortraitExit.InheritFrom .. "_Exit"
                newPortraitExit.Name = newPortraitExit.Name .. "_Exit"
                newPortraitExit.CreateAnimations[1].Name = newSubPortraitExit.Name
                table.insert(newdata, newSubPortraitExit)
                table.insert(newdata, newPortraitExit)
            end
        end
    end
    for _, entry in ipairs(newdata) do
        table.insert(data.Animations,entry)
    end
end)

sjson.hook(guiScreensVFXFile, function (data)
    for _, entry in ipairs(mod.BoonSelectAnims) do
        local origname = entry.Name
        for dress,dressData in pairs(mod.DressData) do
            if dressData.BoonPortrait then
                local newname = dress .. "_" .. origname
                local newfilepath = modPortraitPrefix .. dress .. "\\" .. "BoonSelectMelIn0015"
                local newentry = game.DeepCopyTable(entry)
                newentry.Name = newname
                if origname == "BoonSelectMelIn" or true then
                    newentry.FilePath = newfilepath
                end
                table.insert(data.Animations,newentry)
            end
        end
    end
end)

sjson.hook(guiFile,function (data)
    local origname = mod.BoonSelectObstacle.Name
    for dress,dressData in pairs(mod.DressData) do
        if dressData.BoonPortrait then
            local newname = dress .. "_" .. origname
            local newentry = game.DeepCopyTable(mod.BoonSelectObstacle)
            newentry.Name = newname
            newentry.Thing.Graphic = dress .. "_" .. newentry.Thing.Graphic
            table.insert(data.Obstacles,newentry)
        end
    end
end)

local function AddPreviewSjson()
    local GUIFile = rom.path.combine(rom.paths.Content, 'Game/Obstacles/GUI.sjson')

    local gui_order = {
        "Name", "InheritFrom", "DisplayInEditor", "Thing"
    }

    local gui_order_2 = {
        "EditorOutlineDrawBounds", "Graphic"
    }

    local newSubItem = sjson.to_object({
        EditorOutlineDrawBounds = false,
        Graphic = "zerp-MelSkinPortraits\\Box_Preview"
    }, gui_order_2)

    local newItem = sjson.to_object({
        Name = "MelSkin_Box_Preview",
        InheritFrom = "1_BaseGUIObstacle",
        DisplayInEditor = false,
        Thing = newSubItem,
    }, gui_order)

    sjson.hook(GUIFile, function(data)
        table.insert(data.Obstacles, newItem)
    end)
end

AddPreviewSjson()

local melinoeGeneralVfxFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\Melinoe_General_VFX.sjson")

sjson.hook(melinoeGeneralVfxFile, function (data)
    local new_data = {}
    local name_data_map = {}
    for _, entry in ipairs(data.Animations) do
        if type(entry.Name) == "string" then
            name_data_map[entry.Name] = entry
        end
    end

    for dress, dressData in pairs(mod.DressData) do
        local laurelCinderSpawner = game.DeepCopyTable(name_data_map["LaurelCindersSpawner"])
        local laurelCinders = game.DeepCopyTable(name_data_map["LaurelCinders"])
        local laurelBurnA = game.DeepCopyTable(name_data_map["LaurelBurnA"])
        local laurelBurnB = game.DeepCopyTable(name_data_map["LaurelBurnB"])
        local laurelBurnC = game.DeepCopyTable(name_data_map["LaurelBurnC"])
        local laurelBurnD = game.DeepCopyTable(name_data_map["LaurelBurnD"])

        local laurelCinderSpawnerAmbient = game.DeepCopyTable(name_data_map["LaurelCindersSpawnerAmbient"])
        local laurelCindersAmbient = game.DeepCopyTable(name_data_map["LaurelCindersAmbient"])
        local laurelBurnAAmbient = game.DeepCopyTable(name_data_map["LaurelBurnA_Ambient"])
        local laurelBurnBAmbient = game.DeepCopyTable(name_data_map["LaurelBurnB_Ambient"])
        local laurelBurnCAmbient = game.DeepCopyTable(name_data_map["LaurelBurnC_Ambient"])
        local laurelBurnDAmbient = game.DeepCopyTable(name_data_map["LaurelBurnD_Ambient"])

        -- local melArmGlow = game.DeepCopyTable(name_data_map["MelArmGlow"])

        if dressData.ArmGlow then
            laurelCinderSpawner.CreateAnimations = {
                { Name = dress .. "MelArmGlow" }
            }
        end
        if dressData.LaurelCinderHue then

            laurelBurnA.Hue = dressData.LaurelCinderHue
            laurelBurnA.Name = dress .. laurelBurnA.Name

            laurelBurnB.Hue = dressData.LaurelCinderHue
            laurelBurnB.Name = dress .. laurelBurnB.Name

            laurelBurnC.Hue = dressData.LaurelCinderHue
            laurelBurnC.Name = dress .. laurelBurnC.Name

            laurelBurnD.Hue = dressData.LaurelCinderHue
            laurelBurnD.Name = dress .. laurelBurnD.Name

            laurelCinders.Random = {
                { Name = laurelBurnA.Name },
                { Name = laurelBurnB.Name },
                { Name = laurelBurnC.Name },
                { Name = laurelBurnD.Name },
            }

            laurelCinders.Name = dress .. laurelCinders.Name
            laurelCinderSpawner.VisualFx = laurelCinders.Name

            --ambient
            laurelBurnAAmbient.Hue = dressData.LaurelCinderHue
            laurelBurnAAmbient.Name = dress .. laurelBurnAAmbient.Name

            laurelBurnBAmbient.Hue = dressData.LaurelCinderHue
            laurelBurnBAmbient.Name = dress .. laurelBurnBAmbient.Name

            laurelBurnCAmbient.Hue = dressData.LaurelCinderHue
            laurelBurnCAmbient.Name = dress .. laurelBurnCAmbient.Name

            laurelBurnDAmbient.Hue = dressData.LaurelCinderHue
            laurelBurnDAmbient.Name = dress .. laurelBurnDAmbient.Name

            laurelCindersAmbient.Random = {
                { Name = laurelBurnAAmbient.Name },
                { Name = laurelBurnBAmbient.Name },
                { Name = laurelBurnCAmbient.Name },
                { Name = laurelBurnDAmbient.Name },
            }

            laurelCindersAmbient.Name = dress .. laurelCindersAmbient.Name
            laurelCinderSpawnerAmbient.VisualFx = laurelCindersAmbient.Name

            laurelCinderSpawnerAmbient.Name = dress .. laurelCinderSpawnerAmbient.Name

            laurelCinderSpawner.ChildAnimation = laurelCinderSpawnerAmbient.Name

            table.insert(new_data, laurelCinders)
            table.insert(new_data, laurelBurnA)
            table.insert(new_data, laurelBurnB)
            table.insert(new_data, laurelBurnC)
            table.insert(new_data, laurelBurnD)
            table.insert(new_data, laurelCinderSpawnerAmbient)
            table.insert(new_data, laurelCindersAmbient)
            table.insert(new_data, laurelBurnAAmbient)
            table.insert(new_data, laurelBurnBAmbient)
            table.insert(new_data, laurelBurnCAmbient)
            table.insert(new_data, laurelBurnDAmbient)
        end

        if dressData.ArmGlow or dressData.LaurelCinderHue then
            laurelCinderSpawner.Name = dress .. laurelCinderSpawner.Name
            table.insert(new_data, laurelCinderSpawner)
        end
    end
    for _, value in ipairs(new_data) do
        table.insert(data.Animations, value)
    end
    return data
end)

local melinoe1BaseVfxFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\Melinoe_1Base_VFX.sjson")

sjson.hook(melinoe1BaseVfxFile, function (data)
    local newdata = {}
    for _, entry in ipairs(data.Animations) do
        if entry.Name == "MelArmGlow" then
            for dress, dressData in pairs(mod.DressData) do
                if dressData.ArmGlow then
                    local newentry = game.DeepCopyTable(entry)
                    newentry.StartRed = dressData.ArmGlow.StartRed or newentry.StartRed
                    newentry.StartGreen = dressData.ArmGlow.StartGreen or newentry.StartGreen
                    newentry.StartBlue = dressData.ArmGlow.StartBlue or newentry.StartBlue
                    newentry.EndRed = dressData.ArmGlow.EndRed or newentry.EndRed
                    newentry.EndGreen = dressData.ArmGlow.EndGreen or newentry.EndGreen

                    newentry.Name = dress .. newentry.Name
                    table.insert(newdata, newentry)
                end
            end
            break
        end
    end
    for _, value in ipairs(newdata) do
        table.insert(data.Animations, value)
    end
end)