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
        for _, dressName in ipairs(mod.DressDisplayOrder) do
            if rom.ImGui.Selectable(dressName, (dressName == config.dress)) then
                local  dressGrannyTexture = mod.GetDressGrannyTexture(dressName)
                config.dress = dressName
                config.random_each_run = false
                mod.UpdateSkin(dressGrannyTexture)
            end
            rom.ImGui.SetItemDefaultFocus()
        end
        rom.ImGui.EndCombo()
    end
    
    rom.ImGui.Separator()

    local value, checked = rom.ImGui.Checkbox("Random Dress Each Run", config.random_each_run)
    if checked then
        config.random_each_run = value
        if value then
            
            mod.UpdateSkin(mod.GetDressGrannyTexture(mod.GetCurrentRunDress()))
        else
            -- mod.ClearRunDressData()
            mod.UpdateSkin(mod.GetDressGrannyTexture(config.dress))
        end
    end
end