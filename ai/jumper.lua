require '_utilities/utilities.lua'
require '_jumper/jumper.lua'
-- Simple check to assert if Jumper was successfully imported and highlight all its submodules
do
    if not (Jumper) then 
        error('Error Loading Module Jumper') 
    end
    print(('Module Jumper loaded successfully (@ %s)'):format(tostring(Jumper)))
    for k,v in pairs(Jumper) do
        print(('\t>> Submodule %s (@ %s)'):format(k,tostring(v)))
    end
end

rememberPassengers = {}
jumperMap = {}
myFinder = {}
lookupMap = {}
railMap = {}

function ai.init(map, money)
  railMap = map2railMap(map)
  for i=1, map.height do
    lookupMap[i] = {}
    for j=1, map.width do
      lookupMap[i][j] = {}
    end
  end
  jumperMap = mapToJumperMap(map)
  local walkable = 1

  -- Library setup
  local Grid = Jumper.Grid -- Alias to the Grid submodule
  local Pathfinder = Jumper.Pathfinder -- Alias to the Pathfinder submodule

  -- Creates a grid object
  local grid = Grid(jumperMap) 
  -- Creates a pathfinder object using Jump Point Search
  myFinder = Pathfinder(grid, 'BFS', walkable) 
buyTrain(1, 1)
  -- Define start and goal locations coordinates

end

-- Wird aufgerufen, wenn genug geld für einen neuen Zug da ist
function ai.enoughMoney(money)
  buyTrain(1, 1)
end

-- Wird aufgerufen, wenn eine Richtungswahl ansteht
-- train [table]
-- possibleDirections [table]
function ai.chooseDirection(train, possibleDirections)
  if train.passenger then
    local startx, starty = train.x ,train.y
    local endx, endy = train.passenger.destX, train.passenger.destY

    -- Calculates the path, and its length
    local path = myFinder:getPath(startx, starty, endx, endy)
    kreuzung = makeLoc( path[2].x, path[2].y, train.dir)
    nachKreuzung = makeLoc( path[3].x, path[3].y, train.dir )
    for dir, bool in pairs(possibleDirections) do
      local test_loc = goDir( railMap, kreuzung, dir )
      if test_loc.x == nachKreuzung.x and test_loc.y == nachKreuzung.y then return dir end
    end

  end

  -- fallback
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

function mapToJumperMap(map)
  local jumperMap = {}
  for i=1, map.width do
      for j=1, map.height do
          if not jumperMap[j] then
           jumperMap[j] = {}
          end
          if map[i][j] == 'C' then
              jumperMap[j][i] = 1
          else
              jumperMap[j][i] = 0
          end
      end
  end
  return jumperMap
end