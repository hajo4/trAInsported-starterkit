function makeRailMap(map)
    local railMap = {}
    for i=1, map.width do
        railMap[i] = {}
        for j=1, map.height do
            if map[i][j] == "C" then
                c = 0
                if map[i-1][j] == "C" then c = c + 1 end
                if map[i+1][j] == "C" then c = c + 1 end
                if map[i][j-1] == "C" then c = c + 1 end
                if map[i][j+1] == "C" then c = c + 1 end

                if c > 2 then
                    railMap[i][j] = 2
                else
                    railMap[i][j] = 1
                end
            else
                railMap[i][j] = 0
            end
        end
    end
    railMap.width = map.width
    railMap.height = map.height
    return railMap
end
