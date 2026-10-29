CharacterData = {}

---@param characterName string Custom character name
---@param dressData table Dress data for the custom character, check mod.DressData in data.lua for format, additionally also supports PortraitAnimSwapMap
---@param dressOrder table Array defining the order in which the dresses are displayed
---@param isActiveFunction fun(): boolean Returns true whenever the custom character is active
---@param menuCameraParams table Defines offsets and zoom level for the in-game menu
public.RegisterCustomCharacter = function (characterName, dressData, dressOrder, isActiveFunction, menuCameraParams)
    dressOrder = dressOrder or {}
    dressData = game.DeepCopyTable(dressData)

    -- these are explicitly unsupported
    dressData.Portraits = nil
    dressData.TyphonRivalsPortraitMap = nil
    dressData.PortraitOverlayModifacations = nil
    dressData.BoonPortrait = nil
    dressData.ArmGlow = nil
    dressData.LaurelCinderHue = nil

    -- add a default skin
    if not dressData.None then
        dressData.None =
        {
            GrannyTexture = "",
        }
    end

    -- default skin should always be available
    dressData.None.GameStateRequirements = nil

    -- chuck every granny texture into a common map, surely nothing goes wrong :)
    for dressName, data in pairs(dressData) do
        if not game.Contains(dressOrder, dressName) then
            table.insert(dressOrder, dressName)
        end
        if data.IsArachne then
            mod.CostumeDressMap[data.GrannyTexture] = dressName
        end
    end

    -- remove "Custom" skin as it holds special meaning in the mod
    dressData.Custom = nil
    game.RemoveValueAndCollapse(dressOrder, "Custom")

    local env = envy.getfenv(2)
	local guid = (env and env._PLUGIN and env._PLUGIN.guid) or (_PLUGIN and _PLUGIN.guid)
    print("Registering custom character from", guid, ":", characterName)
    CharacterData[guid .. characterName] = {
        Name = guid .. characterName,
        DressData = dressData,
        DressOrder = dressOrder,
        IsActiveFunction = isActiveFunction,
        MenuCameraParams = menuCameraParams
    }
end

function mod.GetCustomCharacterData()
    for _, characterData in pairs(CharacterData) do
        if characterData.IsActiveFunction and characterData.IsActiveFunction() then
            return characterData
        end
    end
    return {}
end

function mod.GetModDressData()
    return mod.GetCustomCharacterData().DressData or mod.DressData
end

function mod.GetModDressDataOrder()
    local order = {}
    local modDressData = mod.GetModDressData()
    for index, dressName in ipairs(mod.GetCustomCharacterData().DressOrder or mod.DressDisplayOrder) do
        local dress = modDressData[dressName]
        if not dress.GameStateRequirements or game.IsGameStateEligible(dress, dress.GameStateRequirements) then
            table.insert(order, dressName)
        end
    end
    return order
end

function mod.GetCurrentCharacter()
    return mod.GetCustomCharacterData().Name or "Default"
end

function mod.GetCharacterMenuZoomData()
    return mod.GetCustomCharacterData().MenuCameraParams or {}
end

---@return string dress Return dress equipped for the current character.
public.GetCurrentDress = mod.GetCurrentDress