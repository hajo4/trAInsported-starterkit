require '_jumper/jumper.lua'
function ai.init(map, money)
  -- Simple check to assert if Jumper was successfully imported
  assert(Jumper and type(Jumper) == 'table', 'Error loading the Jumper module')

  local walkable = function(v) return v == 'C' end

  -- Library setup
  local Grid = Jumper.Grid -- Alias to the Grid submodule
  local Pathfinder = Jumper.Pathfinder -- Alias to the Pathfinder submodule


  local grid = Grid(map)
  -- Creates a pathfinder object using Jump Point Search
  local myFinder = Pathfinder(grid, 'JPS', walkable) 

  -- Define start and goal locations coordinates
  local startx, starty = 1,1
  local endx, endy = 5,1

  -- Calculates the path, and its length
  local path = myFinder:getPath(startx, starty, endx, endy)
  if path then
    print(('Path found! Length: %.2f'):format(path:getLength()))
      for node, count in path:nodes() do
        print(('Step: %d - x: %d - y: %d'):format(count, node.x, node.y))
      end
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
  return chooseAlmostBrainless(train, possibleDirections)
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
  print("get off!")
  dropPassenger(train)
  
  print("Money: " .. getMoney())
end

-- Wird aufgerufen, wenn ein neuer Fahrgast erscheint
function ai.newPassenger(name, x, y, destX, destY)
  print("Neuer Fahrgast: " .. name)
  rememberPassengers[name] = {x=x,y=y,destX=destX,destY=destY}
end

-- ------------
-- LOCAL HELPER
-- ------------

-- Wenn ein Passagier an Board ist wird versucht diesen ans Ziel zu bringen
function chooseAlmostBrainless(train, possibleDirections)
  if train.passenger then 
    print("train.passenger destination:", train.passenger.destX, train.passenger.destY)
    print("train.pos:", train.x, train.y)
    tbl = {}
    if possibleDirections["N"] and (train.passenger.destY+1 < train.y) then
      tbl[#tbl+1] = "N"
    end
    if possibleDirections["S"] and (train.passenger.destY-1 > train.y) then
      tbl[#tbl+1] = "S"
    end
    if possibleDirections["E"] and (train.passenger.destX+1 > train.x) then
      tbl[#tbl+1] = "E"
    end
    if possibleDirections["W"] and (train.passenger.destX-1 < train.x) then
      tbl[#tbl+1] = "W"
    end
    if #tbl > 0 and (random(100) > 10) then
      return tbl[random(#tbl)]
    end
  end
  return chooseRandom(train, possibleDirections)
end

-- wählt zufällig aus den möglichen Richtungen eine aus
function chooseRandom(train, possibleDirections)
  tbl = {}
  for dir,bool in pairs(possibleDirections) do
    tbl[#tbl+1] = dir
  end
  return tbl[random(#tbl)]
end 