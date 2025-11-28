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
        for _, dressPair in ipairs(mod.DressData) do
            local  dressName = dressPair[1]
            local  dressValue = dressPair[2]
            if rom.ImGui.Selectable(dressName, (dressName == config.dress)) then
                config.dress = dressName
                config.random_each_run = false
                mod.dressvalue = dressValue
                mod.UpdateSkin(mod.dressvalue)
            end
            rom.ImGui.SetItemDefaultFocus()
        end
        rom.ImGui.EndCombo()
    end

    rom.ImGui.Separator()

    local value, checked = rom.ImGui.Checkbox("Random Dress Each Run", config.random_each_run)
    print("value", tostring(value), "checked", tostring(checked))
    if checked then
        config.random_each_run = value
        if value then
            mod.GetCurrentRunRandomDress()
            mod.UpdateSkin(mod.GetDressValue(mod.random_dress))
        else
            -- mod.ClearRunDressData()
            mod.UpdateSkin(mod.GetDressValue(config.dress))
        end
    end
end