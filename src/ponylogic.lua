function mod.OpenDressSelector()
	if IsScreenOpen("DressSelector") then
		return
	end
	local screen = DeepCopyTable(ScreenData.DressSelector)
	screen.Amount = 0
	screen.FirstPage = 0
	screen.LastPage = 0
	screen.CurrentPage = screen.FirstPage
	local components = screen.Components

	local randomButtonText = mod.DressScreenData.DressSelector.ComponentData.Background.Children.RandomDressButton.Text
	if config.random_each_run then
		screen.ComponentData.Background.Children.RandomDressButton.Text = ">>" .. randomButtonText .. "<<"
	end

	OnScreenOpened(screen)
	HideCombatUI(screen.Name)
	CreateScreenFromData(screen, screen.ComponentData)

	local index = 0
	screen.DressList = {}
	for _, dressName in ipairs(mod.DressDisplayOrder) do
		local rowOffset = 100
		local columnOffset = 320
		local boonsPerRow = 5
		local rowsPerPage = 7
		local rowIndex = math.floor(index / boonsPerRow)
		local pageIndex = math.floor(rowIndex / rowsPerPage)
		local offsetX = screen.RowStartX + columnOffset * (index % boonsPerRow)
		local offsetY = screen.RowStartY + rowOffset * (rowIndex % rowsPerPage)
		index = index + 1
		screen.LastPage = pageIndex
		if screen.DressList[pageIndex] == nil then
			screen.DressList[pageIndex] = {}
		end
		table.insert(screen.DressList[pageIndex],{
			index = index,
			pageIndex = pageIndex,
			offsetX = offsetX,
			offsetY = offsetY,
			key = dressName
		})
	end

	mod.DressSelectorLoadPage(screen)

	SetColor({ Id = components.BackgroundTint.Id, Color = Color.Black })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.0, Duration = 0 })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.9, Duration = 0.3 })
	wait(0.3)
	SetConfigOption({ Name = "ExclusiveInteractGroup", Value = "Combat_Menu_TraitTray" })
	screen.KeepOpen = true
	HandleScreenInput(screen)
end

function  mod.DressSelectorLoadPage(screen)
	-- mod.BoonManagerPageButtons(screen, screen.Name)
	local pageDress = screen.DressList[screen.CurrentPage]
	if pageDress then
		for i, dressButtonData in pairs(pageDress) do
			local dressKey = "DressKey" .. dressButtonData.index
			screen.Components[dressKey] = CreateScreenComponent({
				Name = "ButtonDefault",
				Group = "Combat_Menu_TraitTray",
				Scale = 1.2,
				ScaleX = 0.92,
				ToDestroy = true
			})
			SetInteractProperty({
				DestinationId = screen.Components[dressKey].Id,
				Property = "TooltipOffsetY",
				Value = 100
			})
			screen.Components[dressKey].OnPressedFunctionName = mod.SetDress
			screen.Components[dressKey].Dress = dressButtonData.key
			screen.Components[dressKey].Index = dressButtonData.index
			Attach({
				Id = screen.Components[dressKey].Id,
				DestinationId = screen.Components.Background.Id,
				OffsetX = dressButtonData.offsetX,
				OffsetY = dressButtonData.offsetY
			})
			local text = dressButtonData.key
			local color = Color.White
			if config.dress == text then
				text = ">>" .. text .. "<<"
				color = Color.Orange
			end
			print(text)
			CreateTextBox({
				Id = screen.Components[dressKey].Id,
				Text = text,
				FontSize = 20,
				OffsetX = 0,
				OffsetY = 0,
				Width = 400,
				Color = color,
				Font = "P22UndergroundSCMedium",
				ShadowBlur = 0,
				ShadowColor = { 0, 0, 0, 1 },
				ShadowOffset = { 0, 2 },
				Justification = "Center"
			})
		end
	end
end

function mod.SetDress(screen,button)
	local dressGrannyTexture = mod.GetDressGrannyTexture(button.Dress)
	print("Dress", button.Dress)
	print("DressGrannyTexture", dressGrannyTexture)
	config.dress = button.Dress
	config.random_each_run = false
	mod.UpdateSkin(dressGrannyTexture)
	-- mod.CloseDressSelector(screen)
	mod.DressSelectorReloadPage(screen)
end

function mod.DressSelectorReloadPage(screen)
	local ids = {}
	for i, component in pairs(screen.Components) do
		if component.RandomButtonId == "RandomButtonId" then
			print("randombuttonreload", screen.Components[i].Text)
			screen.Components[i].Text = mod.DressScreenData.DressSelector.ComponentData.Background.Children.RandomDressButton.Text
			screen.Components[i].Color = Color.White
			ModifyTextBox({Id = screen.Components[i].Id, Text = screen.Components[i].Text, Color = screen.Components[i].Color})
		end
		if component.ToDestroy then
			table.insert(ids, component.Id)
		end
	end
	Destroy({ Ids = ids })
	mod.DressSelectorLoadPage(screen)
end

function mod.ToggleRandomDressSelection(screen, button)
	config.random_each_run = config.random_each_run == false
	local randomButtonText = mod.DressScreenData.DressSelector.ComponentData.Background.Children.RandomDressButton.Text
	local color = Color.White
	if config.random_each_run then
		randomButtonText = ">>" .. randomButtonText .. "<<"
		color = Color.Orange
		mod.UpdateSkin(mod.GetDressGrannyTexture(mod.GetCurrentRunDress()))
	else
		mod.UpdateSkin(mod.GetDressGrannyTexture(config.dress))
	end
	button.Text = randomButtonText
	ModifyTextBox({Id = button.Id, Text = button.Text, Color = color})
	-- mod.DressSelectorReloadPage(screen)
end

function mod.CloseDressSelector(screen)
	ShowCombatUI(screen.Name)
	SetConfigOption({ Name = "ExclusiveInteractGroup", Value = nil })
	OnScreenCloseStarted(screen)
	CloseScreen(GetAllIds(screen.Components), 0.15)
	OnScreenCloseFinished(screen)
	notifyExistingWaiters("DressSelector")
end

function mod.PopulatePonyMenuData()
    mod.ponyMenu = rom.mods["PonyWarrior-PonyMenu"]
    if mod.ponyMenu ~= nil and mod.ponyMenu.CommandData ~= nil then
        ModUtil.Table.Merge(ScreenData,mod.DressScreenData)
        table.insert(mod.ponyMenu.CommandData,mod.DressCommandData)
    end
end

mod.PopulatePonyMenuData()