local guiPortraitsVFXFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\GUI_Portraits_VFX.sjson")
local guiScreensVFXFile = rom.path.combine(rom.paths.Content(), "Game\\Animations\\GUI_Screens_VFX.sjson")
local guiFile = rom.path.combine(rom.paths.Content(), "Game\\Obstacles\\GUI.sjson")
local modPortraitPrefix = "zerp-MelSkin\\portraits\\"

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

sjson.hook(guiPortraitsVFXFile, function(data)
    local newdata = {}
    for _, entry in ipairs(data.Animations) do
        local origname = entry.Name
        local origfilename = mod.PortraitNameFileMap[origname]
        if origfilename ~= nil then
            for dress, dressData in pairs(mod.DressData) do
                if dressData.Portraits ~= nil and dressData.Portraits[origfilename] then
                    local newname = dress .. "_" .. origname
                    print("sjson new name", newname)
                    -- args.Name = newname
                    local newfilepath = modPortraitPrefix .. dress .. "\\" .. origfilename
                    local newentry = game.DeepCopyTable(entry)
                    newentry.Name = newname
                    newentry.FilePath = newfilepath
                    table.insert(newdata,newentry)
                end
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
		Graphic = "zerp-MelSkin\\Box_Preview"
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