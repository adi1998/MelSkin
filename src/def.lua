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

return public