function udpatePortraitNameFileMap()
    local tempMap = {}
    for k,v in pairs(mod.PortraitNameFileMap) do
        tempMap[k .. "_Exit"] = v
    end
    for k,v in pairs(tempMap) do
        mod.PortraitNameFileMap[k] = v
    end
end

function mod.AddEntriesToDressData(dressdata,packages)
    if mod.DressData ~= nil then
        for dress, data in pairs(dressdata) do
            if mod.DressData[dress] == nil then
                print("adding extertnal dress", dress, data.GrannyTexture)
                mod.DressData[dress] = data
                table.insert(mod.DressDisplayOrder,dress)
            end
        end
        for _, package in ipairs(packages) do
            table.insert(mod.skinPackageList,package)
        end
    end
end

public.AddEntriesToDressData = mod.AddEntriesToDressData

udpatePortraitNameFileMap()