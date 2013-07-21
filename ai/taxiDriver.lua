require('_utilities/utilities')
--
-- Der TaxiDriver Bot fährt zufällig auf der Karte herum, solange er keinen Fahrgast hat.
-- Sobald er an Fahrgästen vorbeifährt nimmt er den ersten und sucht den kürzesten Pfad
-- zum Ziel des Fahrgastes. 
--

railMap = {}

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
        print('Ich bin schon voll!')
    else
        -- Wir nehmen den ersten Fahrgast an diesem Ort mit
        p = passengers[1]
        -- Finde den kürzesten Weg mit Tiefensuche
        local location = { ["x"]=train.x,["y"]=train.y,["dir"]=train.dir }
        local target   = { ["x"]=p.destX, ["y"]=p.destY, }
        local path     = depthFirstSearch( 0, railMap, location, target )
        -- Speichere wo der Zug an der Kreuzung langfahren muss
        passengerMap   = railMap
        for i=1, #path do 
            passengerMap[ path[i].x ][ path[i].y ] = path[i].dir 
        end
        print('Fahrgast steigt ein!')
    end
    return p
end

-- wird gerufen wenn man eine Kachel vor einer Kreuzung ist.
-- ACHTUNG: es wird nicht gerufen wenn man AUF der Kreuzung ist sondern DAVOR
-- zurückgeben sollte man eine Richtung ("N", "S", "W", "E") aus dem parameter possibleDirections
function ai.chooseDirection(train, possibleDirections)
    local dir = nil
    local trainLoc = makeLoc(train.x, train.y, train.dir)
    local crossingsLoc = goDir( railMap, trainLoc, train.dir ) -- crossingLoc ~= trainLoc
    if train.passenger then
        -- abfragen der vorberechneten Richtung
        dir = passengerMap[crossingsLoc.x][crossingsLoc.y]
    else
        -- kein Fahrgast an Bord. Zufällige Wahl.
        dir = chooseRandomDir(possibleDirections)        
    end
    return dir
end

-- wird gerufen wenn ein neuer Fahrgast auf der Karte erscheint
function ai.newPassenger(name, x, y, destX, destY, vipTime)
    print("neuer Fahrgast ("..x..", "..y..")")
end

-- wird gerufen wenn der Zug am Zielort angekommen ist
function ai.foundDestination( train )
    dropPassenger(train)
end

-- Wird aufgerufen, wenn genug geld für einen neuen Zug da ist
function ai.enoughMoney(money)
  x = random(rememberMap.width)
  y = random(rememberMap.height)
  buyTrain(x, y)
end

-- Wird aufgerufen, wenn der Zug blockiert wird
-- (Beispielsweise durch einen anderen Zug)
function ai.blocked(train, possibleDirections, lastDirection)
  return lastDirection
end
