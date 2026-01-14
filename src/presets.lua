mod.PresetTable =
{
    ["Default"] =
    {
        Name = "Default",
        Dress = {
            Type = "Color",
            R = 202,
            G = 105,
            B = 28,
            Bright = false,
            -- Base = "None"
        },
        Hair = {
            R = 203,
            G = 178,
            B = 121,
        },
        Arm = {
            Hue = 0, -- 0-360
        }
    }
}

local configPath = rom.paths.config()
local presetFileName = _PLUGIN.guid .. "CustomPresets.cfg"

local presetFilePath = rom.path.combine(configPath, presetFileName)

local pluginsData = rom.path.combine(rom.paths.plugins_data(), _PLUGIN.guid .. "Helper")
local plugins = rom.path.combine(rom.paths.plugins(), _PLUGIN.guid .. "Helper")
local colorMapExePath = "start /b /wait \"\" \"" .. rom.path.combine(pluginsData, "colormap.exe") .. "\""
local colorMapScriptPath = "python \"" .. rom.path.combine(plugins, "colormap.py") .. "\""

function mod.ReadPresetsFromFile()
    if rom.path.exists(presetFilePath) then
        -- local fileHandle = io.open(presetFilePath, "r")
        -- if not fileHandle then
        --     print("Error opening presets file for reading", presetFilePath)
        --     return
        -- end
        -- local fileString = fileHandle:read("*a")
        -- print("preset file content", fileString)
        local success, filePresets = pcall(rom.toml.decodeFromFile, presetFilePath)
        if success then
            for presetName, preset in pairs(filePresets) do
                mod.PresetTable[presetName] = preset
            end
            print("Successfully loaded preset file")
        else
            print("Failed to read preset file", filePresets)
        end
    end
    local touchFile = io.open(rom.path.combine(_PLUGIN.plugins_data_mod_folder_path, "update"), "r")
    local isTouch = touchFile~=nil and io.close(touchFile)
    if not isTouch and mod.PresetTable["LastApplied"] ~= nil then
        LoadPreset(true)
        mod.ReloadCustomTexture(true)
        touchFile = io.open(rom.path.combine(_PLUGIN.plugins_data_mod_folder_path, "update"), "w+")
        if touchFile then
            touchFile:write("")
            touchFile:close()
        end
    end
end

function mod.WritePresetsToFile(lastApplied)
    -- local fileHandle = io.open(presetFilePath, "w+")
    -- if not fileHandle then
    --     print("Error opening presets file for writing", presetFilePath)
    --     return
    -- end
    -- mod.ReadPresetsFromFile()
    if lastApplied then
        local touchFile = io.open(rom.path.combine(_PLUGIN.plugins_data_mod_folder_path, "update"), "w+")
        if touchFile then
            touchFile:write("")
            touchFile:close()
        end
    end
    local success, fileString = pcall( rom.toml.encodeToFile, mod.PresetTable, { file = presetFilePath, overwrite = true } )
    if success then
        print("Successfully saved preset file")
    else
        print("Failed to save preset file", fileString)
    end
    -- fileHandle:write(fileString)
end

function mod.ReloadCustomTexture(lastApplied)
    local driveLetter = pluginsData:sub(1,1)
    local colorMapPath = colorMapExePath
    if not config.use_exe then
        colorMapPath = colorMapScriptPath
    end
    local colorMapCommand = driveLetter .. ": & cd \"" .. _PLUGIN.plugins_data_mod_folder_path .. "\" & " .. colorMapPath .. " --path \"" .. _PLUGIN.plugins_data_mod_folder_path .. "\" "
    local rgbCommand = colorMapCommand
    if config.custom_dress_color and config.custom_dress then
        rgbCommand = rgbCommand .. " --dress " .. tostring(config.dresscolor.r) .. "," .. tostring(config.dresscolor.g) .. "," .. tostring(config.dresscolor.b)
    end
    if config.custom_hair_color then
        rgbCommand = rgbCommand .. " --hair " .. tostring(config.haircolor.r) .. "," .. tostring(config.haircolor.g) .. "," .. tostring(config.haircolor.b)
    end
    if config.custom_dress and not config.custom_dress_color then
        rgbCommand = rgbCommand .. " --base " .. config.custom_dress_base
    end
    if config.custom_arm_color then
        rgbCommand = rgbCommand .. " --arm " .. tostring(config.arm_hue)
    end
    if config.bright_dress then
        rgbCommand = rgbCommand .. " --bright "
    end
    print("running", rgbCommand)
    local handle = os.execute(rgbCommand)
    if not lastApplied then
        game.UnloadPackages({Names = {_PLUGIN.guid .. "zerp-MelSkinCustom"}})
        game.LoadPackages({Names = {_PLUGIN.guid .. "zerp-MelSkinCustom"}})
    end
end

function mod.SetRandomCustomPreset()
    local presetArray = {}
    for presetName, _ in pairs(mod.PresetTable) do
        if presetName ~= "Default" and presetName ~= "LastApplied" then
            table.insert(presetArray, presetName)
        end
    end
    if #presetArray > 0 then
        local randomPreset = game.GetRandomArrayValue(presetArray)
        config.current_preset = randomPreset
        print("random preset", randomPreset)
        LoadPreset()
        SavePreset(true)
        mod.ReloadCustomTexture()
        -- mod.ResetMenuZoom()
    end
end