# trAInsprorted
Ein Programmierspiel in dem es darum geht mit KI gesteuerten Zügen personen von A nach B zu transportieren.

## Getting Started
Um das Spiel zu installieren macht man am besten folgendes:

1. dieses Repository herunterladen
2. trAInsportedWin3.zip auf dem Desktop oder Programmeordner entpacken
3. die .exe ein erstes mal ausführen
4. öffne im Dateiexplorer deinen Benutzerordner
5. gehe zu C:\Users\ __deinName__ \AppData\Roaming\LOVE\
6. ersetzte den Ordner `trAInsported` mit dem gleichnamigen aus dem Repository
7. die AI's befinden sich im Ordner AI


## Lua Überblick
Eine Übersicht über Arrays, Schleifen und Co. findest du in `Lua.lua` oder hier:

```lua
-- Variablen sind generell global
globalerText 	= 'ein spannender Text'
globalerInt 	= 1
globalerFloat 	= 1.234

-- Um Variablen lokal zu machen setzt man
-- einfach ein local davor
local lokalerText 	= 'ein spannender Text'
local lokalerInt 	= 1
local lokalerFloat 	= 1.234

-- Arrays und Dictionarys heißen Tabellen
table = {}
-- ACHTUNG: erster Eintrag bei 1
table[1] = 'text'
table[2] = 12

sameTable = {'text', 12}

dictionary = {}
dictionary['tier'] = 'Hund'
dictionary['alter'] = 2

sameDictionary = {'tier' = 'Hund', 'alter' = 2}

-- Unterscheidungen sind auch sehr eingängig
if something ~= somethingElse then
	-- mach was
end

-- Natürlich geht das auch mit else 
if someInt > otherInt then
	-- mach was
else if someInt == otherInt then
	-- mach was anderes
else
	-- mach was ganz anderes
end

-- Schleifen
-- for i = [start],[ende],[schritt]
for i=1,10,2 do
	print(i)
end

-- while
i = 1
while i  <= 5 do
	 print (i)
	 i = i + 1
end

-- foreach über ein Dictonary
for key,value in pairs(tabelle) do
	print(key,value)
end

-- foreach über ein Array
for i,value in ipairs(tabelle) do
	print(i,value)
end
```

## trAInsported Überblick

````
require '_utilities/utilities.lua'
require '_jumper/jumper.lua'
--
-- Der TaxiDriver Bot fährt zufällig auf der Karte herum, solange er keinen Fahrgast hat.
-- Sobald er an Fahrgästen vorbeifährt nimmt er den ersten und sucht den kürzesten Pfad
-- zum Ziel des Fahrgastes. 
--

railMap = {}

-- wird zu Beginn des Spieles gerufen. Hier sollte ein Zug gekauft werden!
function ai.init(map, money, maximumTrains)
    railMap = map2railMap(map)

    -- initialisiere die Pfadfinde-Bibliothek
    jumperMap = mapToJumperMap(map)
    local walkable = 1
    local Grid = Jumper.Grid  
    local Pathfinder = Jumper.Pathfinder 
    local grid = Grid(jumperMap) 
    myFinder = Pathfinder(grid, 'BFS', walkable) 

    buyTrain(random(map.width), random(map.height))
end

-- wird gerufen wenn der Zug auf der gleichen Kachel wie ein Fahrgast ist
function ai.foundPassengers( train, passengers )
    local p = nil 
    if train.passenger then
        -- Wenn der Zug voll ist, halte nicht für Fahrgäste am Straßenrand
        print('Ich bin schon voll!')
    else
        p = passengers[1]
    end  
    return p
end

-- wird gerufen wenn man eine Kachel vor einer Kreuzung ist.
-- ACHTUNG: es wird nicht gerufen wenn man AUF der Kreuzung ist sondern DAVOR
-- zurückgeben sollte man eine Richtung ("N", "S", "W", "E") aus dem parameter possibleDirections
function ai.chooseDirection(train, possibleDirections)    
    local dir chooseRandomDir(possibleDirections) 
    if train.passenger then
        -- berechne die beste Richtung
        local startx, starty = train.x ,train.y
        local endx, endy = train.passenger.destX, train.passenger.destY
        local path = myFinder:getPath(startx, starty, endx, endy)
        kreuzung = makeLoc( path[2].x, path[2].y, train.dir)
        nachKreuzung = makeLoc( path[3].x, path[3].y, train.dir )
        for d, bool in pairs(possibleDirections) do
          local test_loc = goDir( railMap, kreuzung, d )
          if test_loc.x == nachKreuzung.x and test_loc.y == nachKreuzung.y then
            dir = d 
            break 
          end
        end
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
````