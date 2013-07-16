function printMap(map)
    str = {}
    print(map.height)
    for j = 1, map.height do
        str[j] = ""
        for i = 1, map.width do
            if map[i][j] then 
                if map[i][j] == "STORE" then
                    str[j] = str[j] .. "L" .. " "
                else
                    str[j] = str[j] .. map[i][j] .. " "
                end
            else
                str[j] = str[j] .. "= "
            end
        end
    end
    for i = 1, #str do
        print(str[i])
    end
end