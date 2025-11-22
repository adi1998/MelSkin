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
        for _, dressPair in ipairs(mod.dressTable) do
            local  dressName = dressPair[1]
            local  dressValue = dressPair[2]
            if rom.ImGui.Selectable(dressName, (dressName == config.dress)) then
                config.dress = dressName
                mod.dressvalue = dressValue
                mod.SetSkin()
            end
            rom.ImGui.SetItemDefaultFocus()
        end
        rom.ImGui.EndCombo()
    end
end