---@meta _
---@diagnostic disable

local previousConfig = {
    dress = nil,
    random_each_run = nil,
    fav = {},
}

for i, dressName in ipairs(mod.DressDisplayOrder) do
    previousConfig.fav[dressName] = nil
end

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
                    mod.UpdateSkin(dressGrannyTexture)
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
        if value then
            
            mod.UpdateSkin(mod.GetDressGrannyTexture(mod.GetCurrentRunDress()))
        else
            -- mod.ClearRunDressData()
            mod.UpdateSkin(mod.GetDressGrannyTexture(config.dress))
        end
    end

    local index = 1

    if config.fav == nil then
        config.fav = {}
    end
    while mod.DressDisplayOrder[index] do
        if config.fav == nil then
            config.fav = {}
        end
        if config.fav[mod.DressDisplayOrder[index]] == nil then
            config.fav[mod.DressDisplayOrder[index]] = true
        end
        local value, checked = rom.ImGui.Checkbox(mod.DressDisplayOrder[index], config.fav[mod.DressDisplayOrder[index]] )
        if checked and value ~= previousConfig.fav[mod.DressDisplayOrder[index]] then
            config.fav[mod.DressDisplayOrder[index]] = value
            previousConfig.fav[mod.DressDisplayOrder[index]] = value
        end
        if index % 3 == 0 then
            rom.ImGui.NewLine()
        else
            rom.ImGui.SameLine()
        end
        index = index + 1
    end

end