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
passengerMap = nil

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

function ai.init(map, money, maximumTrains)
    railMap = map2railMap(map)
    buyTrain(random(map.width), random(map.height))

    spawned_passengers = {}
    for i=1, railMap.width do
        spawned_passengers[i] = {}
        for j=1, railMap.height do
            spawned_passengers[i][j]= nil
        end
    end

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
    local dir = nil
    if train.passenger then
        -- find path
        local trainLoc = makeLoc(train.x, train.y, train.dir)
        local crossingsLoc = goDir( railMap, trainLoc, train.dir )
        print("Train Loc "..loc2String(crossingsLoc))
        print("Crossing Loc "..loc2String(crossingsLoc))
        print( passengerMap[crossingsLoc.x][crossingsLoc.y] )
        dir = passengerMap[crossingsLoc.x][crossingsLoc.y]
    else
        -- RANDOM ATTACK!!
        print('go random')
        local tbl = {}
        for dir,bool in pairs(directions) do
            tbl[#tbl+1] = dir
        end
   
        dir = tbl[random(#tbl)]
    end
    return dir

end

function ai.newPassenger(name, x, y, destX, destY, vipTime)

end


function ai.foundPassengers( train, passengers )
    if train.passenger then
        print('seeing a passenger')
    else
        local p = passengers[1] -- this could be more clever
        local location = {["x"]=train.x,["y"]=train.y,["dir"]=train.dir }
        local target = { ["x"]=p.destX, ["y"]=p.destY, }
        local path = searchPath( 0, railMap, location, target )
        passengerMap = railMap
        for i=1, #path do 
            print(path[i].x.." "..path[i].y)
            passengerMap[ path[i].x ][ path[i].y ] = path[i].dir 
        end
        print('getting passenger')
    end
    return passengers[1]
end

function ai.foundDestination( train )
    dropPassenger(train)
end
