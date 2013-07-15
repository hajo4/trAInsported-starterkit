function printMap(map)
    str = {}
    for j = 1, map.height do
        str[j] = ""
        for i = 1, map.width do
            if map[i][j] then 
                str[j] = str[j] .. map[i][j] .. " "
            else
                str[j] = str[j] .. "- "
            end
        end
    end
    for i = 1, #str do
        print(str[i])
    end
end