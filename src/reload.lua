---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.


function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

mod.dressmap = {
	Lavender = "Models/Melinoe/Melinoe_ArachneArmorC",
	Azure = "Models/Melinoe/Melinoe_ArachneArmorB",
	Emerald = "Models/Melinoe/Melinoe_ArachneArmorA",
	Onyx = "Models/Melinoe/Melinoe_ArachneArmorF",
	Fuchsia = "Models/Melinoe/Melinoe_ArachneArmorD",
	Gilded = "Models/Melinoe/Melinoe_ArachneArmorE",
	Moonlight = "Models/Melinoe/Melinoe_ArachneArmorG",
	Crimson = "Models/Melinoe/Melinoe_ArachneArmorH",
	DarkSide = "Models/Melinoe/MelinoeTransform_Color",
	None = ""
}

modutil.mod.Path.Wrap("SetThingProperty", function(base,args)
	if args.Property == "GrannyTexture" and args.DestinationId == CurrentRun.Hero.ObjectId then
		print(dump(args))
	end
	if args.Property == "GrannyTexture" and (args.Value == "null" or args.Value == "") and args.DestinationId == CurrentRun.Hero.ObjectId then
		arg_copy = DeepCopyTable(args)
		-- print(dump(args))
		arg_copy.Value = mod.dressmap[config.dress]
		-- print(dump(arg_copy))
		base(arg_copy)
	else 
		base(args)
	end
end)