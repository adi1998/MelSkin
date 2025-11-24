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

	OnScreenOpened(screen)
	HideCombatUI(screen.Name)
	CreateScreenFromData(screen, screen.ComponentData)

	local displayedDresses = {	}
	local index = 0
	screen.DressList = {}
	for k, dress in ipairs(mod.DressData) do
		local rowOffset = 100
		local columnOffset = 400
		local boonsPerRow = 4
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
			dress = dress,
			pageIndex = pageIndex,
			offsetX = offsetX,
			offsetY = offsetY,
			key = dress[1]
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
		for i, dressData in pairs(pageDress) do
			local dressKey = "DressKey" .. dressData.index
			dressData.dress.ObjectId = dressKey
			screen.Components[dressKey] = CreateScreenComponent({
				Name = "ButtonDefault",
				Group = "Combat_Menu_TraitTray",
				Scale = 1.2,
				ScaleX = 1.15,
				ToDestroy = true
			})
			SetInteractProperty({
				DestinationId = screen.Components[dressKey].Id,
				Property = "TooltipOffsetY",
				Value = 100
			})
			screen.Components[dressKey].OnPressedFunctionName = mod.SetDress
			screen.Components[dressKey].Dress = dressData.dress
			screen.Components[dressKey].Index = dressData.index
			Attach({
				Id = screen.Components[dressKey].Id,
				DestinationId = screen.Components.Background.Id,
				OffsetX = dressData.offsetX,
				OffsetY = dressData.offsetY
			})
			local text = dressData.key
			if config.dress == text then
				text = ">>" .. text .. "<<"
			end
			print(text)
			CreateTextBox({
				Id = screen.Components[dressKey].Id,
				Text = text,
				FontSize = 22,
				OffsetX = 0,
				OffsetY = -5,
				Width = 720,
				Color = Color.White,
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
	print("Dress",button.Dress[1])
	print("DressValue",button.Dress[2])
	config.dress = button.Dress[1]
	mod.dressvalue = button.Dress[2]
	mod.UpdateSkin(mod.dressvalue)
	mod.CloseDressSelector(screen)
end

function mod.CloseDressSelector(screen)
	ShowCombatUI(screen.Name)
	SetConfigOption({ Name = "ExclusiveInteractGroup", Value = nil })
	OnScreenCloseStarted(screen)
	CloseScreen(GetAllIds(screen.Components), 0.15)
	OnScreenCloseFinished(screen)
	notifyExistingWaiters("DressSelector")
end