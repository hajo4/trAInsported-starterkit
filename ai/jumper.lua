require '_utilities/utilities.lua'
require '_jumper/jumper.lua'
rememberedPassengers = {}
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
  local startx, starty = train.x ,train.y
  

  if train.passenger then -- go to passenger
    local endx, endy = train.passenger.destX, train.passenger.destY
    -- Calculates the path, and its length
    local path = myFinder:getPath(startx, starty, endx, endy)
    kreuzung = makeLoc( path[2].x, path[2].y, train.dir)
    nachKreuzung = makeLoc( path[3].x, path[3].y, train.dir )
    for dir, bool in pairs(possibleDirections) do
      local test_loc = goDir( railMap, kreuzung, dir )
      if test_loc.x == nachKreuzung.x and test_loc.y == nachKreuzung.y then return dir end
    end

  else -- no passenger
    local minDist = nil
    local dest = nil
    for name, info in pairs(rememberedPassengers) do
        local dist = manhattanDist( train.x, train.y, info.loc.x, info.loc.y)
        if minDist == nil or minDist > dist then
            minDist = dist
            dest = info.loc
        end
    end

    local endx, endy = dest.x, dest.y
    local path = myFinder:getPath(startx, starty, endx, endy)
    if #path > 2 then
      kreuzung = makeLoc( path[2].x, path[2].y, train.dir)
      nachKreuzung = makeLoc( path[3].x, path[3].y, train.dir )
      for dir, bool in pairs(possibleDirections) do
        local test_loc = goDir( railMap, kreuzung, dir )
        if test_loc.x == nachKreuzung.x and test_loc.y == nachKreuzung.y then return dir end
      end
    end
    return chooseRandomDir(possibleDirections)        
  end
end

-- Wird aufgerufen, wenn der Zug blockiert wird
-- (Beispielsweise durch einen anderen Zug)
function ai.blocked(train, possibleDirections, lastDirection)
  return chooseRandom(train, possibleDirections)
end

-- Wird aufgerufen, wenn der Zug an einem Passagier vorbeikommt
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
        -- diesen Fahrgast bringen wir ans Ziel, das nächste mal ist er nicht mehr hier!
        rememberedPassengers[p.name] = nil
    end
    return p
end


-- Wird aufgerufen, wenn der Zug am Ziel des Passagiers ankommt
function ai.foundDestination(train)
  dropPassenger(train)
end

-- Wird aufgerufen, wenn ein neuer Fahrgast erscheint
function ai.newPassenger(name, x, y, destX, destY, vipTime)
    -- Benutze die Manhattan Distance als Heuristik für die Entfernung zum Ziel
    local dist = manhattanDist(x,y,destX,destY)
    local loc = makeLoc(x,y, nil)
    rememberedPassengers[name] = { ["dist"]=dist, ["loc"]=loc }
end

-- ------------
-- LOCAL HELPER
-- ------------

-- Wenn ein Passagier an Board ist wird versucht diesen ans Ziel zu bringen


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