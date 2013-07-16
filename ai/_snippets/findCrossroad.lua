function findCrossroad(map)
    for j = 1, map.height do
        for i = 1, map.width do
            if map[i][j] == "C" then 
            	c = 0
            	if map[i-1][j] == "C" then c = c + 1 end
            	if map[i+1][j] == "C" then c = c + 1 end
            	if map[i][j-1] == "C" then c = c + 1 end
            	if map[i][j+1] == "C" then c = c + 1 end
            	if c > 2 then
            		map[i][j] = "X"
            	end
            end
            if map[i][j] == "STORE" then 
            	map[i][j] = "L"
            end
        end
    end
    return map
end