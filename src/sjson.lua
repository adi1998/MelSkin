local guiPortraitsVFXFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\GUI_Portraits_VFX.sjson")
local guiScreensVFXFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\GUI_Screens_VFX.sjson")
local guiFile = rom.path.combine(rom.paths.Content(), "Game\\Obstacles\\GUI.sjson")
local modPortraitPrefix = "zerp-MelSkinPortraits\\"

mod.BoonSelectAnims = {
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
                    -- print("sjson new name", newname)
                    -- args.Name = newname
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
                if origname == "BoonSelectMelIn" then
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