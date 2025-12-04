---@meta _
---@diagnostic disable

local previousConfig = {
    dress = nil,
    random_each_run = nil,
}

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
                if dressName ~= previousConfig then
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

    local value, checked = rom.ImGui.Checkbox("Random Dress Each Run", config.random_each_run)
    if checked and value ~= previousConfig.random_each_run then
        config.random_each_run = value
        previousConfig.random_each_run = value
        game.SetupCostume()
    end
end