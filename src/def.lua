---@meta zerp-MelSKin
local public = {}

-- document whatever you made publicly available to other plugins here
-- use luaCATS annotations and give descriptions where appropriate
--  e.g. 
--    ---@param a integer helpful description
--    ---@param b string helpful description
--    ---@return table c helpful description
--    function public.do_stuff(a, b) end

---@param name string Dress name to be added
---@param entry table DressData containing GrannyTexture field, other fields are not supported
---@param addportraits boolean Whether to add portraits or not
function public.AddEntryToDressData(name, entry, addportraits) end

return public