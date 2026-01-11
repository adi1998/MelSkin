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
local presetFileName = _PLUGIN.guid .. "CustomPresets.sjson"

local presetFilePath = rom.path.combine(configPath, presetFileName)

function mod.ReadPresetsFromFile()
    local filePresets = {}
    if rom.path.exists(presetFilePath) then
        local fileHandle = io.open(presetFilePath, "r")
        if not fileHandle then
            print("Error opening presets file", presetFilePath)
            return filePresets
        end
        local fileString = fileHandle:read("a*")
        filePresets = sjson.decode(fileString)
        for presetName, preset in pairs(filePresets) do
            mod.PresetTable[presetName] = preset
        end
    end
    return filePresets
end

function mod.WritePresetsToFile()
    local fileHandle = io.open(presetFilePath, "w+")
    if not fileHandle then
        print("Error opening presets file", presetFilePath)
        return
    end
    mod.ReadPresetsFromFile()
    local fileString = sjson.encode(mod.PresetTable)
    fileHandle:write(fileString)
end