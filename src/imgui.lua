---@meta _
---@diagnostic disable

local previousConfig = {
    dress = nil,
    random_each_run = nil,
    hue_shift = 0,
    color = {
        r = 0,
        g = 0,
        b = 0,
    }
}

local r, g, b = 202/255, 105/255, 28/255
local h, s, v = rom.ImGui.ColorConvertRGBtoHSV(r, g, b)

rom.gui.add_imgui(function()
    if rom.ImGui.Begin("Dress Selector") then
        drawMenu()
        rom.ImGui.End()
    end
end)

rom.gui.add_to_menu_bar(function()
    if rom.ImGui.BeginMenu("Configure Dress") then
        drawMenu()
        rom.ImGui.EndMenu()
    end
end)

function drawMenu()
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
        rom.ImGui.Separator()

        local new_h = (h+config.hue_shift/360.0) % 1
        r,g,b = rom.ImGui.ColorConvertHSVtoRGB(new_h,s,v)
        rom.ImGui.PushStyleColor(rom.ImGuiCol.FrameBg , config.color.r/255, config.color.g/255, config.color.b/255, 1)
        rom.ImGui.PushStyleColor(rom.ImGuiCol.FrameBgActive , config.color.r/255, config.color.g/255, config.color.b/255, 1)
        rom.ImGui.PushStyleColor(rom.ImGuiCol.FrameBgHovered , config.color.r/255, config.color.g/255, config.color.b/255, 1)
        rom.ImGui.PushStyleColor(rom.ImGuiCol.SliderGrab, config.color.r/255, config.color.g/255, config.color.b/255, 0)
        rom.ImGui.PushStyleColor(rom.ImGuiCol.SliderGrabActive, config.color.r/255, config.color.g/255, config.color.b/255, 0)
        rom.ImGui.Text("Custom Color Selector")
        
        value, selected = rom.ImGui.SliderInt("", config.hue_shift, 0, 360, '')
        if selected and value ~= previousConfig.hue_shift then
            config.hue_shift = value
            previousConfig.hue_shift = value
            local new_h = (h+config.hue_shift/360.0) % 1
            r,g,b = rom.ImGui.ColorConvertHSVtoRGB(new_h,s,v)
        end

        rom.ImGui.PopStyleColor(5)

        value, selected = rom.ImGui.SliderInt("R", config.color.r, 0, 255, '%d%')
        if selected and value ~= previousConfig.color.r then
            config.color.r = value
            previousConfig.color.r = value
        end

        value, selected = rom.ImGui.SliderInt("G", config.color.g, 0, 255, '%d%')
        if selected and value ~= previousConfig.color.g then
            config.color.g = value
            previousConfig.color.g = value
        end

        value, selected = rom.ImGui.SliderInt("B", config.color.b, 0, 255, '%d%')
        if selected and value ~= previousConfig.color.b then
            config.color.b = value
            previousConfig.color.b = value
        end
        
        -- rom.ImGui.SameLine()

        local clicked = rom.ImGui.Button("Apply")
        if clicked or checked then
            game.thread(mod.ReloadCustomTexture)
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