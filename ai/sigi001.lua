-- Tutorial 4: Close is good!
railMap = {}

function ai.init(map, money, maximumTrains)
    for x = 1, map.width, 1 do
        for y = 1, map.height, 1 do
            if map[x][y] == "S" then 
                print("Hotspot found at: "..x..", "..y.."!")
            end
        end
    end
    spawned_passengers = {}
    railMap = map2railMap(map)
    print('start')
    path = searchPath( 0, "S", 4, 3, 5, 5, railMap )
    for value in path do
        print value
    end
    print('end')
    
    buyTrain(random(map.width), random(map.height))
end

function distance(x1, y1, x2, y2)
    res = sqrt( ( x1-x2)^2 + (y1-y2)^2 )
    return res
end

function ai.chooseDirection(train, directions)
    if train.passenger == nil then
        print(train.name.."carries no passenger.")
        return "W"
    else
        print(train.name.." carries "..train.passenger.name)
        if train.passenger.destX < train.x then
            return "W"
        else
            return "E"
        end
    end
end

function ai.newPassenger(name, x, y, destX, destY, vipTime)
   print("passenger spawned at: "..x..", "..y.."!")
   p = {}
   p.name = name
   p.x = x
   p.y = y
   p.destX = destX
   p.destY = destY
   p.vipTime = vipTime
   table.insert(spawned_passengers, p)
   print(spawned_passengers)
end

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

function ai.foundPassengers( train, passengers )
    pass = nil
    dist = 100
    i = 1
    while i<= #passengers do
        d = distance( train.x, train.y, passengers[i].destX,passengers[i].destY)
        if d < dist then
            dist = d
            pass = passengers[i]
        end
        i = i+1
    end
    return pass
end

function ai.foundDestination( train )
    dropPassenger(train)
end
