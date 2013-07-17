function makeRailMap(map)
    local railMap = {}
    for i=1, map.width do
        railMap[i] = {}
        for j=1, map.height do
            if map[i][j] == "C" then
                c = 0
                -- W
                if map[i][j-1] == "C" then c = c + 1 end
                -- S
                if map[i+1][j] == "C" then c = c + 10 end	
                -- O
                if map[i][j+1] == "C" then c = c + 100 end
                -- N
                if map[i-1][j] == "C" then c = c + 1000 end

                railMap[i][j] = 1
            else
                railMap[i][j] = 0
            end
        end
    end
    railMap.width = map.width
    railMap.height = map.height
    return railMap
end

-- returns two Tables with x connections and y connections
function buildEdgeThingy(railMap)
	edge = {}

	-- x connections
	edge[i][j][N] = {}
	edge[i][j][E] = {}
	edge[i][j][W] = {}
	edge[i][j][S] = {}

end

