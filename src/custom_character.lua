CharacterData = {}

---@param characterName string Custom character name
---@param dressData table Dress data for the custom character, check mod.DressData in data.lua for format
---@param dressOrder table Array defining the order in which the dresses are displayed
---@param isActiveFunction function Returns true whenever the custom character is active
public.RegisterCustomCharacter = function (characterName, dressData, dressOrder, isActiveFunction)
    -- add a default skin
    if not dressData.None then
        dressData.None =
        {
            GrannyTexture = "",
        }
        if not game.Contains(dressOrder, "None") then
            table.insert(dressOrder)
        end
    end

    -- remove "Custom" skin as it holds special meaning in the mod
    dressData.Custom = nil
    game.RemoveValueAndCollapse(dressOrder, "Custom")

    CharacterData[characterName] = {
        Name = characterName,
        DressData = dressData,
        DressOrder = dressOrder,
        IsActiveFunction = isActiveFunction
    }
end

function mod.GetCustomCharacterData()
    for characterName, characterData in pairs(CharacterData) do
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