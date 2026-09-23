---@meta zerp-MelSKin
local public = {}

-- document whatever you made publicly available to other plugins here
-- use luaCATS annotations and give descriptions where appropriate
--  e.g. 
--    ---@param a integer helpful description
--    ---@param b string helpful description
--    ---@return table c helpful description
--    function public.do_stuff(a, b) end

---@param dressdata table DressData containing GrannyTexture field, other fields are not supported
---@param packages table list of package/s for the skin/s
function public.AddEntriesToDressData(dressdata, packages) end

---@param characterName string Custom character name
---@param dressData table Dress data for the custom character, check mod.DressData in data.lua for format
---@param dressOrder table Array defining the order in which the dresses are displayed
---@param isActiveFunction function Returns true whenever the custom character is active
---@param menuCameraParams table Defines offsets and zoom level for the in-game menu
function public.RegisterCustomCharacter(characterName, dressData, dressOrder, isActiveFunction, menuCameraParams) end

return public