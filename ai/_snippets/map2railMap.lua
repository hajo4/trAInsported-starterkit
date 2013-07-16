function map2railMap(map)
    local railMap = {}
    for i=1, map.width do
        railMap[i] = {}
        for j=1, map.height do
            if map[i][j] == "C" then
                railMap[i][j] = true
            else
                railMap[i][j] = false
            end
        end
    end
    return railMap
end