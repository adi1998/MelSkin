CharacterData = {}

---@param characterName string Custom character name
---@param dressData table Dress data for the custom character, check mod.DressData in data.lua for format
---@param dressOrder table Array defining the order in which the dresses are displayed
---@param isActiveFunction function Returns true whenever the custom character is active
---@param menuCameraParams table Defines offsets and zoom level for the in-game menu
public.RegisterCustomCharacter = function (characterName, dressData, dressOrder, isActiveFunction, menuCameraParams)
    -- add a default skin
    dressOrder = dressOrder or {}
    dressData = game.DeepCopyTable(dressData)
    dressData.Portraits = nil
    dressData.TyphonRivalsPortraitMap = nil
    dressData.PortraitOverlayModifacations = nil
    dressData.BoonPortrait = nil
    dressData.ArmGlow = nil
    dressData.LaurelCinderHue = nil
    if not dressData.None then
        dressData.None =
        {
            GrannyTexture = "",
        }
    end

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

    CharacterData[characterName] = {
        Name = characterName,
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
    return mod.GetCustomCharacterData().DressOrder or mod.DressDisplayOrder
end

function mod.GetCurrentCharacter()
    return mod.GetCustomCharacterData().Name or "Default"
end

function mod.GetCharacterMenuZoomData()
    return mod.GetCustomCharacterData().MenuCameraParams or {}
end