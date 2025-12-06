function udpatePortraitNameFileMap()
    local tempMap = {}
    for k,v in pairs(mod.PortraitNameFileMap) do
        tempMap[k .. "_Exit"] = v
    end
    for k,v in pairs(tempMap) do
        mod.PortraitNameFileMap[k] = v
    end
end

function mod.AddEntryToDressData(name,entry,package)
    if mod.DressData ~= nil and mod.DressData[name] == nil then
        print("adding extertnal dress",name,entry.GrannyTexture)
        mod.DressData[name] = entry
        table.insert(mod.DressDisplayOrder,name)
        table.insert(mod.skinPackageList,package)
    end
end

public.AddEntryToDressData = mod.AddEntryToDressData

udpatePortraitNameFileMap()