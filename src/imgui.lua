---@meta _
---@diagnostic disable

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
        for option, _ in pairs(mod.dressmap) do
            if rom.ImGui.Selectable(option, (option == config.dress)) then
                config.dress = option
            end
            rom.ImGui.SetItemDefaultFocus()
        end
        rom.ImGui.EndCombo()
    end
end