function udpatePortraitNameFileMap()
    local tempMap = {}
    for k,v in pairs(mod.PortraitNameFileMap) do
        tempMap[k .. "_Exit"] = v
    end
    for k,v in pairs(tempMap) do
        mod.PortraitNameFileMap[k] = v
    end
end

udpatePortraitNameFileMap()