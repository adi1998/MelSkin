---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
--     so only assign to values or define things here.

function mod.HasUnviewedCostumeItemnoChar( source, args )
	args = args or {}
	for dressName, dressData in pairs( mod.DressData ) do
		if GameState.zerpCostumeWorn and not GameState.zerpCostumeWorn[dressName] then
			if not dressData.GameStateRequirements or dressData.GameStateRequirements == nil or IsGameStateEligible( source, dressData.GameStateRequirements ) then
                return true
            end
        end
	end
	return false
end

function mod.HasUnviewedCostumeItem( source, args )
	args = args or {}
	if mod.HasUnviewedCostumeItemnoChar( source, args ) then
        return true
    end
    if CharacterData then
        for characterName, characterData in pairs(CharacterData) do
            if characterData.UnlockCondition and IsGameStateEligible( source, characterData.UnlockCondition) then
                for dressName, dressData in pairs( characterData.DressData ) do
                    if GameState.zerpCostumeWorn and GameState.zerpCostumeWorn[characterName] and not GameState.zerpCostumeWorn[characterName][dressName] then
                        if not dressData.GameStateRequirements or dressData.GameStateRequirements == nil or IsGameStateEligible( source, dressData.GameStateRequirements ) then
                            return true
                        end
                    end
                end
            end 
        end
    end
	return false
end
