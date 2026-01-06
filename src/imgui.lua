---@meta _
---@diagnostic disable

local previousConfig = {
    dress = nil,
    random_each_run = nil,
    hue_shift = 0,
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
    
    rom.ImGui.Separator()

    local new_h = (h+config.hue_shift/360.0) % 1
    r,g,b = rom.ImGui.ColorConvertHSVtoRGB(new_h,s,v)
    rom.ImGui.PushStyleColor(rom.ImGuiCol.FrameBg , r, g, b, 1)
    rom.ImGui.PushStyleColor(rom.ImGuiCol.FrameBgActive , r, g, b, 1)
    rom.ImGui.PushStyleColor(rom.ImGuiCol.FrameBgHovered , r, g, b, 1)
    rom.ImGui.Text("Hue shift")
    
    value, selected = rom.ImGui.SliderInt("", config.hue_shift, 0, 360, '%d%')
    if selected and value ~= previousConfig.hue_shift then
        config.hue_shift = value
        previousConfig.hue_shift = value
        local new_h = (h+config.hue_shift/360.0) % 1
        r,g,b = rom.ImGui.ColorConvertHSVtoRGB(new_h,s,v)
    end
    rom.ImGui.PopStyleColor(3)
    rom.ImGui.SameLine()

    local clicked = rom.ImGui.Button("Apply")
    if clicked or checked then
        game.thread(mod.ReloadCustomTexture)
    end

    rom.ImGui.Separator()

    local value, checked = rom.ImGui.Checkbox("Random Dress Each Run", config.random_each_run)
    if checked and value ~= previousConfig.random_each_run then
        config.random_each_run = value
        previousConfig.random_each_run = value
        game.SetupCostume()
    end
end