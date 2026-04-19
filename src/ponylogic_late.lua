function mod.PopulatePonyMenuData()
    mod.ponyMenu = rom.mods["PonyWarrior-PonyMenu"]
    if mod.ponyMenu ~= nil and mod.ponyMenu.CommandData ~= nil then
        table.insert(mod.ponyMenu.CommandData, mod.DressCommandData)
    end
    ModUtil.Table.Merge(game.ScreenData, mod.DressScreenData)
end