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
---@param package string package name to load for granny texture
function public.AddEntryToDressData(name, entry, package) end

return public