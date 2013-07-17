-- ------------
-- bekommt [table]railMap, [int]x, [int]y, [char]dir
-- Gibt für (x,y) alle Möglichkeiten in die man weiterfahren kann
-- abhängig von der Richtung (dir) aus der man kommt
function getDirections( railMap, x, y, dir)
    local directions = {}
    if dir == "N" then y = y-1 end
    if dir == "S" then y = y+1 end
    if dir == "E" then x = x+1 end
    if dir == "W" then x = x-1 end
    
    directions.length = 0
    if railMap[x][y-1] and dir ~= 'S'  then 
        directions.N = true
        directions.length = directions.length + 1
    end
    if railMap[x][y+1] and dir ~= 'N' then
        directions.S = true
        directions.length = directions.length + 1
    end
    if railMap[x-1][y] and dir ~= 'E' then 
        directions.W = true
        directions.length = directions.length + 1
    end
    if railMap[x+1][y] and dir ~= 'W' then 
        directions.E = true
        directions.length = directions.length + 1
    end
    return directions
end