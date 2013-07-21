-- ------------
-- bekommt [table]railMap, [int]x, [int]y, [char]dir
-- Gibt für (x,y) alle Möglichkeiten in die man weiterfahren kann
-- abhängig von der Richtung (dir) aus der man kommt
function getDirections( railMap, loc)
    x = loc.x
    y = loc.y
    dir = loc.dir
    local directions = {}
    -- only check if x y is actually a rail
    if railMap[x][y] then
        -- lookup: possible directions
        if y > 1 and railMap[x][y-1] and dir ~= 'S'  then 
            table.insert(directions, "N")
        end
        if y < railMap.height and railMap[x][y+1] and dir ~= 'N' then
            table.insert(directions, "S")
        end
        if x > 1 and railMap[x-1][y] and dir ~= 'E' then 
            table.insert(directions, "W")
        end
        if x < railMap.width and railMap[x+1][y] and dir ~= 'W' then 
            table.insert(directions, "E")
        end
    end
    return directions
end