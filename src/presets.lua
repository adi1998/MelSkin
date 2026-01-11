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
end

function mod.WritePresetsToFile()
    -- local fileHandle = io.open(presetFilePath, "w+")
    -- if not fileHandle then
    --     print("Error opening presets file for writing", presetFilePath)
    --     return
    -- end
    -- mod.ReadPresetsFromFile()
    local success, fileString = pcall( rom.toml.encodeToFile, mod.PresetTable, { file = presetFilePath, overwrite = true } )
    if success then
        print("Successfully saved preset file")
    else
        print("Failed to save preset file", fileString)
    end
    -- fileHandle:write(fileString)
end