require('_utilities/utilities')
--
-- Der TaxiDriver Bot fährt zufällig auf der Karte herum, solange er keinen Fahrgast hat.
-- Sobald er an Fahrgästen vorbeifährt nimmt er den ersten und sucht den kürzesten Pfad
-- zum Ziel des Fahrgastes. 
--

function DFS_Better( level, railMap, location, target, max_level  )
    if max_level == level then
        return "TOOLONG"
    else
        if location.x == target.x and location.y == target.y then
            max_level = level
            return {}
        else
            local path = {}
            local min = max_level+100
            local dirs = getDirections( railMap, location )
            for index, dir in pairs(dirs) do 
                local new_loc = goDir( railMap, location, dir )
                local res = depthFirstSearch( level+1, railMap, new_loc, target, max_level )
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

railMap = {}
rememberedPassengers = {}
max = 20

-- wird zu Beginn des Spieles gerufen. Hier sollte ein Zug gekauft werden!
function ai.init(map, money, maximumTrains)
    railMap = map2railMap(map)
    buyTrain(random(map.width), random(map.height))
end

-- wird gerufen wenn der Zug auf der gleichen Kachel wie ein Fahrgast ist
function ai.foundPassengers( train, passengers )
    local p = nil 
    if train.passenger then
        -- Wenn der Zug voll ist, halte nicht für Fahrgäste am Straßenrand
    else
        -- get passenger with the smallest Manhattan Distance to target destination
        local minDist = nil
        for index, pass in pairs(passengers) do
            local dist = rememberedPassengers[pass.name].dist
            if minDist == nil or minDist > dist then
                minDist = dist
                p = pass
            end
        end
        print("Fahrgast "..p.name.." steigt ein!")

        -- diesen Fahrgast bringen wir ans Ziel, das nächste mal ist er nicht mehr hier!
        rememberedPassengers[p.name] = nil

        
        -- Finde den kürzesten Weg mit Tiefensuche
        local location = { ["x"]=train.x,["y"]=train.y,["dir"]=train.dir }
        local target   = { ["x"]=p.destX, ["y"]=p.destY, }
        local path     = depthFirstSearch( 0, railMap, location, target, max )
        -- Speichere wo der Zug an der Kreuzung langfahren muss
        passengerMap   = railMap
        for i=1, #path do 
            passengerMap[ path[i].x ][ path[i].y ] = path[i].dir 
        end
    end
    return p
end

-- wird gerufen wenn man eine Kachel vor einer Kreuzung ist.
function ai.chooseDirection(train, possibleDirections)
    local dir = nil
    local trainLoc = makeLoc(train.x, train.y, train.dir)
    local crossingsLoc = goDir( railMap, trainLoc, train.dir ) -- crossingLoc ~= trainLoc
    if train.passenger then
        -- abfragen der vorberechneten Richtung
        dir = passengerMap[crossingsLoc.x][crossingsLoc.y]
    else
        -- kein Fahrgast an Bord. Zufällige Wahl.
        if passengerMap[crossingsLoc.x][crossingsLoc.y] then
            dir = passengerMap[crossingsLoc.x][crossingsLoc.y]
        else
            dir = chooseRandomDir(possibleDirections) 
        end       
    end
    return dir
end

-- wird gerufen wenn ein neuer Fahrgast auf der Karte erscheint
function ai.newPassenger(name, x, y, destX, destY, vipTime)
    -- Benutze die Manhattan Distance als Heuristik für die Entfernung zum Ziel
    local dist = manhattanDist(x,y,destX,destY)
    local loc = makeLoc(x,y, nil)
    rememberedPassengers[name] = { ["dist"]=dist, ["loc"]=loc }
    print("neuer Fahrgast ("..x..", "..y..")")
end

-- wird gerufen wenn der Zug am Zielort angekommen ist
function ai.foundDestination( train )
    dropPassenger(train)
    local minDist = nil
    local dest = nil
    for name, info in pairs(rememberedPassengers) do
        local dist = manhattanDist( train.x, train.y, info.loc.x, info.loc.y)
        print(name.." dist: "..dist)
        if minDist == nil or minDist > dist then
            minDist = dist
            dest = info.loc
        end
    end
    local location = { ["x"]=train.x,["y"]=train.y,["dir"]=train.dir }
    local path     = depthFirstSearch( 0, railMap, location, dest, max )
    -- Speichere wo der Zug an der Kreuzung langfahren muss
    passengerMap   = railMap
    for i=1, #path do 
        passengerMap[ path[i].x ][ path[i].y ] = path[i].dir 
    end

end

       


