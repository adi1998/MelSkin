---@meta _
---@diagnostic disable

local previousConfig = {
    dress = nil,
    random_each_run = nil,
    hue_shift = 0,
    dresscolor = {
        r = 0,
        g = 0,
        b = 0,
    },
    haircolor = {
        r = 0,
        g = 0,
        b = 0,
    }
}

local r, g, b = 202/255, 105/255, 28/255
local h, s, v = rom.ImGui.ColorConvertRGBtoHSV(r, g, b)

local text_hsv = { 130/360, 56/100, 89/100 }
local back_hsv = { 160/360, 64/100, 38/100 }

local zoom = false

local presetNameBuffer = ""
local prevPresetBuffer = ""

rom.gui.add_imgui(function()
    if rom.ImGui.Begin("Dress Selector") then
        drawMenu()
        rom.ImGui.End()
    elseif zoom then
        zoom = false
        mod.ResetMenuZoom()
    end
end)

rom.gui.add_to_menu_bar(function()
    if rom.ImGui.BeginMenu("Configure Dress") then
        drawMenu()
        rom.ImGui.EndMenu()
    elseif zoom then
        zoom = false
        mod.ResetMenuZoom()
    end
end)

function drawMenu()

    if not zoom then
        AdjustZoom({ Fraction = 2.8, Duration = 0.3 })
        if config.enable_shimmer_fix then
            game.UnloadPackages({Names = mod.smallPackageList})
            game.LoadPackages({Names = mod.bigPackageList})
        end
        game.thread(mod.ResetZoomAfterImGuiClose)
        zoom = true
    end

    -- TODO: reenable once MelskinHelper is updated
    -- local value, checked = rom.ImGui.Checkbox("Enable Shimmer Fix (for custom skins)", config.enable_shimmer_fix)
    -- if checked and value ~= previousConfig.enable_shimmer_fix then
    --     config.enable_shimmer_fix = value
    --     previousConfig.enable_shimmer_fix = value
    -- end

    rom.ImGui.Text("Select Dress")
    if rom.ImGui.BeginCombo("###dress", config.dress) then
        for _, dressName in ipairs(mod.DressDisplayOrder) do
            if rom.ImGui.Selectable(dressName, (dressName == config.dress)) then
                if dressName ~= previousConfig.dress then
                    local  dressGrannyTexture = mod.GetDressGrannyTexture(dressName)
                    config.dress = dressName
                    previousConfig.dress = dressName
                    config.random_each_run = false
                    game.SetupCostume()
                end
                rom.ImGui.SetItemDefaultFocus()
            end
        end
        rom.ImGui.EndCombo()
    end
    
    if config.dress == "Custom" then

        local value, checked = rom.ImGui.Checkbox("Dress", config.custom_dress)
        if checked and value ~= previousConfig.custom_dress then
            config.custom_dress = value
            previousConfig.custom_dress = value
        end

        

        if config.custom_dress then
            rom.ImGui.SameLine()
            local value, checked = rom.ImGui.Checkbox("Color", config.custom_dress_color)
            if checked and value ~= previousConfig.custom_dress_color then
                config.custom_dress_color = value
                previousConfig.custom_dress_color = value
            end
        end

        -- rom.ImGui.Separator()
        if config.custom_dress_color and config.custom_dress then
            rom.ImGui.PushStyleColor(rom.ImGuiCol.FrameBg , config.dresscolor.r/255, config.dresscolor.g/255, config.dresscolor.b/255, 1)
            rom.ImGui.InputText("###dresspreview", "", 1)
            rom.ImGui.PopStyleColor(1)

            rom.ImGui.SameLine()

            local value, checked = rom.ImGui.Checkbox("Bright", config.bright_dress)
            if checked and value ~= previousConfig.bright_dress then
                config.bright_dress = value
                previousConfig.bright_dress = value
            end

            value, selected = rom.ImGui.SliderInt("###R1", config.dresscolor.r, 0, 255, '%d%')
            if selected and value ~= previousConfig.dresscolor.r then
                config.dresscolor.r = value
                previousConfig.dresscolor.r = value
            end
            rom.ImGui.SameLine(); rom.ImGui.Text("R")

            value, selected = rom.ImGui.SliderInt("###G1", config.dresscolor.g, 0, 255, '%d%')
            if selected and value ~= previousConfig.dresscolor.g then
                config.dresscolor.g = value
                previousConfig.dresscolor.g = value
            end
            rom.ImGui.SameLine(); rom.ImGui.Text("G")

            value, selected = rom.ImGui.SliderInt("###B1", config.dresscolor.b, 0, 255, '%d%')
            if selected and value ~= previousConfig.dresscolor.b then
                config.dresscolor.b = value
                previousConfig.dresscolor.b = value
            end
            rom.ImGui.SameLine(); rom.ImGui.Text("B")
        end
    
        if not config.custom_dress_color and config.custom_dress then
            if rom.ImGui.BeginCombo("###cdress", config.custom_dress_base) then
                for _, dressName in ipairs(mod.CustomDressDisplayOrder) do
                    if rom.ImGui.Selectable(dressName, (dressName == config.custom_dress_base)) then
                        if dressName ~= previousConfig.custom_dress_base then
                            -- mod.ReloadCustomTexture()
                            -- game.SetupCostume()
                            config.custom_dress_base = dressName
                            previousConfig.custom_dress_base = dressName
                        end
                        rom.ImGui.SetItemDefaultFocus()
                    end
                end
                rom.ImGui.EndCombo()
            end
        end

        local value, checked = rom.ImGui.Checkbox("Hair", config.custom_hair_color)
        if checked and value ~= previousConfig.custom_hair_color then
            config.custom_hair_color = value
            previousConfig.custom_hair_color = value
        end
        if config.custom_hair_color then
            rom.ImGui.PushStyleColor(rom.ImGuiCol.FrameBg , config.haircolor.r/255, config.haircolor.g/255, config.haircolor.b/255, 1)
            rom.ImGui.InputText("###hairpreview", "", 1)
            rom.ImGui.PopStyleColor(1)

            value, selected = rom.ImGui.SliderInt("###R2", config.haircolor.r, 0, 255, '%d%')
            if selected and value ~= previousConfig.haircolor.r then
                config.haircolor.r = value
                previousConfig.haircolor.r = value
            end
            rom.ImGui.SameLine(); rom.ImGui.Text("R")

            value, selected = rom.ImGui.SliderInt("###G2", config.haircolor.g, 0, 255, '%d%')
            if selected and value ~= previousConfig.haircolor.g then
                config.haircolor.g = value
                previousConfig.haircolor.g = value
            end
            rom.ImGui.SameLine(); rom.ImGui.Text("G")

            value, selected = rom.ImGui.SliderInt("###B2", config.haircolor.b, 0, 255, '%d%')
            if selected and value ~= previousConfig.haircolor.b then
                config.haircolor.b = value
                previousConfig.haircolor.b = value
            end
            rom.ImGui.SameLine(); rom.ImGui.Text("B")
        end
        
        local value, checked = rom.ImGui.Checkbox("Ghost Arm", config.custom_arm_color)
        if checked and value ~= previousConfig.custom_arm_color then
            config.custom_arm_color = value
            previousConfig.custom_arm_color = value
        end
        
        if config.custom_arm_color then
            local text_shifted = (text_hsv[1] + config.arm_hue/360) % 1
            local r,g,b = rom.ImGui.ColorConvertHSVtoRGB(text_shifted,text_hsv[2],text_hsv[3])
            rom.ImGui.PushStyleColor(rom.ImGuiCol.Text, r, g, b, 1 )

            local back_shifted = (back_hsv[1] + config.arm_hue/360) % 1
            r,g,b = rom.ImGui.ColorConvertHSVtoRGB(back_shifted,back_hsv[2],back_hsv[3])
            rom.ImGui.PushStyleColor(rom.ImGuiCol.FrameBg , r, g, b, 1)
            rom.ImGui.PushStyleColor(rom.ImGuiCol.FrameBgActive , r, g, b, 1)
            rom.ImGui.PushStyleColor(rom.ImGuiCol.FrameBgHovered , r, g, b, 1)

            value, selected = rom.ImGui.SliderInt("###armhue", config.arm_hue, 0, 360, '%d%')
            if selected and value ~= previousConfig.arm_hue then
                config.arm_hue = value
                previousConfig.arm_hue = value
            end
            rom.ImGui.PopStyleColor(4)
            rom.ImGui.SameLine(); rom.ImGui.Text("Hue")
        end

        if config.custom_arm_color or config.custom_dress or config.custom_hair_color then
            local clicked = rom.ImGui.Button("Apply")
            if clicked then
                game.thread(mod.ReloadCustomTexture, cdress)
                SavePreset(true)
            end

            text, selected = rom.ImGui.InputText("###preset name", presetNameBuffer, 100)
            if selected and text ~= prevPresetBuffer then
                prevPresetBuffer = text
                presetNameBuffer = text
            end

            if presetNameBuffer ~= "Default" or presetNameBuffer ~= "LastApplied" then
                rom.ImGui.SameLine()
                local saveButtonText = "Save"
                if presetNameBuffer and presetNameBuffer ~= "" and mod.PresetTable[presetNameBuffer] then
                    saveButtonText = "Overwrite"
                end
                local clicked = rom.ImGui.Button(saveButtonText)
                if clicked and presetNameBuffer ~= nil and presetNameBuffer ~= "" then
                    SavePreset()
                end
            end

            if rom.ImGui.BeginCombo("###preset list", config.current_preset) then
                for presetName, preset in pairs(mod.PresetTable) do
                    if presetName ~= "LastApplied" and rom.ImGui.Selectable(presetName, (presetName == config.current_preset)) then
                        if preset.Name ~= previousConfig.current_preset then
                            config.current_preset = presetName
                            previousConfig.current_preset = presetName
                        end
                        rom.ImGui.SetItemDefaultFocus()
                    end
                end
                rom.ImGui.EndCombo()
            end

            rom.ImGui.SameLine()

            local clicked = rom.ImGui.Button("Load")
            if clicked then
                LoadPreset()
            end

            if config.current_preset ~= "Default" then
                rom.ImGui.SameLine()
                local clicked = rom.ImGui.Button("Delete")
                if clicked then
                    DeletePreset()
                end
            end

        end

    end

    rom.ImGui.Separator()

    local value, checked = rom.ImGui.Checkbox("Random Dress Each Run", config.random_each_run)
    if checked and value ~= previousConfig.random_each_run then
        config.random_each_run = value
        previousConfig.random_each_run = value
        game.SetupCostume()
    end
end

function mod.ResetZoomAfterImGuiClose()
    while rom.gui.is_open() do
        wait(0.3)
    end
    zoom = false
    mod.ResetMenuZoom()
end

function LoadPreset(lastApplied)
    local preset = mod.PresetTable[config.current_preset]
    if lastApplied then
        preset = mod.PresetTable["LastApplied"]
    end
    config.custom_arm_color = preset.Arm ~= nil
    config.arm_hue = (preset.Arm or {Hue = 0}).Hue
    config.custom_hair_color = preset.Hair ~= nil
    local hairLocal = (preset.Hair or {R=0,G=0,B=0})
    config.haircolor.r = hairLocal.R
    config.haircolor.g = hairLocal.G
    config.haircolor.b = hairLocal.B
    if preset.Dress ~= nil then
        config.custom_dress = true
        if preset.Dress.Type == "Color" then
            config.custom_dress_color = true
            -- config.custom_dress_base = false
            config.dresscolor.r = preset.Dress.R
            config.dresscolor.g = preset.Dress.G
            config.dresscolor.b = preset.Dress.B
            config.bright_dress = preset.Dress.Bright
        end
        if preset.Dress.Type == "Base" then
            config.custom_dress_color = false
            config.custom_dress_base = preset.Dress.Base
        end
    else
        config.custom_dress = false
    end
    if not lastApplied then presetNameBuffer = config.current_preset end
end

function SavePreset(lastApplied)
    local preset = {
        Name = presetNameBuffer,
    }
    if lastApplied then
        preset.Name = "LastApplied"
    end
    if config.custom_arm_color then
        preset.Arm = {
            Hue = config.arm_hue
        }
    end
    if config.custom_hair_color then
        preset.Hair = {
            R = config.haircolor.r,
            G = config.haircolor.g,
            B = config.haircolor.b,
        }
    end
    if config.custom_dress_color and config.custom_dress then
        preset.Dress = {
            Type = "Color",
            R = config.dresscolor.r,
            G = config.dresscolor.g,
            B = config.dresscolor.b,
            Bright = config.bright_dress
        }
    end
    if config.custom_dress and not config.custom_dress_color then
        preset.Dress = {
            Type = "Base",
            Base = config.custom_dress_base
        }
    end
    if not lastApplied then
        mod.PresetTable[presetNameBuffer] = preset
    else
        mod.PresetTable["LastApplied"] = preset
    end
    mod.WritePresetsToFile(lastApplied)
    if not lastApplied then
        config.current_preset = presetNameBuffer
        presetNameBuffer = ""
    end
end

function DeletePreset()
    mod.PresetTable[config.current_preset] = nil
    config.current_preset = "Default"
    mod.WritePresetsToFile()
end