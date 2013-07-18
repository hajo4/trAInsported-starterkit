require('_snippets/_all.lua')


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

-- Tutorial 4: Close is good!
railMap = {}

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

function ai.init(map, money, maximumTrains)
    railMap = map2railMap(map)
    buyTrain(random(map.width), random(map.height))



    loc = { ["x"]=4, ["y"]=2, ["dir"]="S" }
    target = { ["x"]=10, ["y"]=5}


    path = searchPath( 0, railMap, loc, target)
    for i=1, #path do 
        print(path[i].x.." "..path[i].y.." "..path[i].dir)
    end


end

function distance(x1, y1, x2, y2)
    res = sqrt( ( x1-x2)^2 + (y1-y2)^2 )
    return res
end

function ai.chooseDirection(train, directions)

end

function ai.newPassenger(name, x, y, destX, destY, vipTime)
end



function ai.foundPassengers( train, passengers )
    return passengers[1]
end

function ai.foundDestination( train )
    dropPassenger(train)
end
