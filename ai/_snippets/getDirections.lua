function getDirections( railMap, x, y, dir)
    if dir == "N" then y = y-1 end
    if dir == "S" then y = y+1 end
    if dir == "E" then x = x+1 end
    if dir == "W" then x = x-1 end
    local directions = {}
    directions.length = 0
    print('getDirs'..x..' '..y)
    if railMap[x][y-1] and dir ~= 'S'  then 
        directions.N = true
        print('N')
        directions.length = directions.length + 1
    end
    if railMap[x][y+1] and dir ~= 'N' then 
        print('S')
        directions.S = true
        directions.length = directions.length + 1
    end
    if railMap[x-1][y] and dir ~= 'E' then 
        print("W")
        directions.W = true
        directions.length = directions.length + 1
    end
    if railMap[x+1][y] and dir ~= 'W' then 
        print("E")
        directions.E = true
        directions.length = directions.length + 1
    end
    return directions
end