function mod.SetAnimationWrap(base,args)
    local origname = args.Name
    print("orig", origname)
    local origfilename = mod.PortraitNameFileMap[origname]
    if origfilename ~= nil then
        local newname = mod.GetPortraitNameFromCostume(origfilename,origname) or mod.GetPortraitNameFromConfig(origfilename,origname) or origname
        -- print("SetAnimation", origname, newname)
        args.Name = newname
        print("new", args.Name)
        return base(args)
    end

    local zagOrigFileNames = mod.ZagMelMap[origname] or mod.ZagMelMap[origname:sub(1,-6)]
    if zagOrigFileNames ~= nil then
        local dress = mod.GetCurrentDress()
        local dressData = mod.DressData[dress or "None"]
        local prefix = ""
        if dressData and dressData.Portraits and dressData.Portraits[zagOrigFileNames[1]] then
            prefix = dress
        end
        local newname = prefix .. origname
        args.Name = newname
        print("new", args.Name)
        return base(args)
    end

    if game.MapState.BabyPolymorph then
        local dress = mod.GetCurrentDress()
        local dressdata = mod.DressData[dress]
        if dressdata == nil or dressdata.TyphonRivalsPortraitMap == nil then
            return base(args)
        end
        local newname = dressdata.TyphonRivalsPortraitMap[origname]
        args.Name = newname or args.Name
        print("new", args.Name)
        return base(args)
    end
    print("new", args.Name)
    return base(args)
end

function mod.SetAnimationWrap2(base,args)
    return mod.SetAnimationWrap(base,args)
end

modutil.mod.Path.Context.Wrap.Static("PlayTextLines", function (source, textLines, args)
    modutil.mod.Path.Wrap("SetAnimation", mod.SetAnimationWrap)
end)

modutil.mod.Path.Context.Wrap.Static("PlayEmoteAnimFromSource", function (source, args, screen, lines)
    modutil.mod.Path.Wrap("SetAnimation", mod.SetAnimationWrap)
end)

modutil.mod.Path.Context.Wrap.Static("CloseUpgradeChoiceScreen", function (screen, button)
    modutil.mod.Path.Wrap("SetAnimation", function (base,args)
        if args.Name == "BoonSelectMelOut" then
            local dress = mod.GetCurrentDress()
            local dressData = mod.DressData[dress]
            local setAlpha = false
            if dressData ~= nil and dressData.BoonPortrait then
                args.Name = dress .. "_" .. args.Name
                setAlpha = true
            end
            local val = base(args)
            if setAlpha then
                game.SetAlpha({ Id = args.DestinationId, Fraction = 0, Duration = 0.1 })
            end
            return val
        end
        return base(args)
    end)
end)