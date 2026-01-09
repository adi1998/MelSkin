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