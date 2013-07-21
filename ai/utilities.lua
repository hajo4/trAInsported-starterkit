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
    railMap.width = map.width
    railMap.height = map.height
    return railMap
end

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

function chooseRandomDir( directions )
    local tbl = {}
    for dir,bool in pairs(directions) do
        tbl[#tbl+1] = dir
    end
    return tbl[random(#tbl)]
end

function depthFirstSearch( level, railMap, location, target  )
    max_level = 30 -- tinker with this, maybe you can dig deeper! ;)
    if max_level == level then
        return "TOOLONG"
    else
        if location.x == target.x and location.y == target.y then
            return {}
        else
            local path = {}
            local min = max_level+100
            local dirs = getDirections( railMap, location )
            for index, dir in pairs(dirs) do 
                local new_loc = goDir( railMap, location, dir )
                local res = depthFirstSearch( level+1, railMap, new_loc, target )
                if res ~= "TOOLONG" then
                    table.insert(res, {["x"]=location.x, ["y"]=location.y, ["dir"]=dir})
                    if #res < min then
                        path = res
                        min = #path
                    end
                end
            end
            return path
        end
    end
end

function goDir( railMap, loc, dir )
    h = railMap.height
    w = railMap.width
    x = loc.x
    y = loc.y
    if dir == "S" then y = y+1 end
    if dir == "N" then y = y-1 end
    if dir == "W" then x = x-1 end
    if dir == "E" then x = x+1 end
    if x > w or y > h or x < 1 or y < 1 then
        print("out of range "..x.." "..y)
    else
        return {["x"]=x, ["y"]=y, ["dir"]=dir}
    end
end 

function loc2String( loc )
    return loc.x.." "..loc.y.." "..loc.dir
end

function makeLoc( x, y, dir)
    return { ["x"]=x, ["y"]=y, ["dir"]=dir }
end

function dir2String( map, loc )
    x = loc.x
    y = loc.y
    dir = loc.dir
    dirs = getDirections( map, loc )
    str = "loc("..x.." "..y.." "..dir..") -> "
    if dirs[1] then
        str = str..dirs[1].." "
    end
    if dirs[2] then
        str = str..dirs[2].." "
    end
    if dirs[3] then
        str = str..dirs[2].." "
    end
    if dirs[4] then
        str = str..dirs[2].." "
    end
    return str
end

function manhattanDist(x1, y1, x2, y2)
    return math.abs(x1-x2) + math.abs(y1-y2)
end