require('_snippets/_all.lua')

rememberPassengers = {}
rememberMap = nil

-- Wird aufgerufen, wenn das Spiel startet
function ai.init(map, money)
  print("Initialized! Hello World!")
  print("I got " .. money .. " credits to spend!!")
  print("map size:", map.height, map.width)
  rememberMap = map

  while money >= 25 do    -- Ein Zug kostet 25 Credits
    buyTrain(random(map.width), random(map.height))
    money = money - 25
  end
end

-- Wird aufgerufen, wenn genug geld für einen neuen Zug da ist
function ai.enoughMoney(money)
  x = random(rememberMap.width)
  y = random(rememberMap.height)
  buyTrain(x, y)
end

-- Wird aufgerufen, wenn eine Richtungswahl ansteht
-- train [table]
-- possibleDirections [table]
function ai.chooseDirection(train, possibleDirections)
  return chooseRandom(train, possibleDirections)
end

-- Wird aufgerufen, wenn der Zug blockiert wird
-- (Beispielsweise durch einen anderen Zug)
function ai.blocked(train, possibleDirections, lastDirection)
  return chooseRandom(train, possibleDirections)
end

-- Wird aufgerufen, wenn der Zug an einem Passagier vorbeikommt
function ai.foundPassengers(train, passengers)
  if train.passenger then return nil end
  return passengers[1]
end

-- Wird aufgerufen, wenn der Zug am Ziel des Passagiers ankommt
function ai.foundDestination(train)
  dropPassenger(train)
end

-- Wird aufgerufen, wenn ein neuer Fahrgast erscheint
function ai.newPassenger(name, x, y, destX, destY)
  print("Neuer Fahrgast: " .. name)
  rememberPassengers[name] = {x=x,y=y,destX=destX,destY=destY}
end

-- ------------
-- LOCAL HELPER
-- ------------

-- wählt zufällig aus den möglichen Richtungen eine aus
function chooseRandom(train, possibleDirections)
  tbl = {}
  for dir,bool in pairs(possibleDirections) do
    tbl[#tbl+1] = dir
  end
  ret = tbl[random(#tbl)]
  return ret
end 