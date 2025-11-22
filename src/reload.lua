---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.


function mod.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. mod.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

modutil.mod.Path.Wrap("SetThingProperty", function(base,args)
	if args.Property == "GrannyTexture" and args.DestinationId == CurrentRun.Hero.ObjectId then
		print(mod.dump(args), tostring(MapState.HostilePolymorph))
	end
	if (MapState.HostilePolymorph == false or MapState.HostilePolymorph == nil) and args.Property == "GrannyTexture" and (args.Value == "null" or args.Value == "") and args.DestinationId == CurrentRun.Hero.ObjectId then
		arg_copy = DeepCopyTable(args)
		-- print(dump(args))
		arg_copy.Value = mod.dressvalue
		-- print(dump(arg_copy))
		base(arg_copy)
	else 
		base(args)
	end
end)