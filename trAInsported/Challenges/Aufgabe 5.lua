local _map = {
  {1,1,4,1,2,1,1,2,2,1,4,},
  {1,2,3,1,1,2,1,1,1,1,1,},
  {1,1,1,1,2,1,1,3,2,1,2,},
  {1,2,1,2,1,2,1,4,2,3,2,},
  {2,2,1,1,1,1,1,1,1,1,2,},
  {1,1,2,2,1,2,2,1,2,1,1,},
  {2,1,2,2,1,2,1,1,1,2,1,},
  {1,1,1,1,1,1,2,1,2,2,1,},
}



local ch = {}

ch.name = "Herausforderung 4"
ch.version = "3"

ch.maxTrains = 1
ch.startMoney = 25

-- create a new:
ch.map = challenges.createEmptyMap(#_map[1], #_map)


local _mapAssoc = {}
  _mapAssoc[0] = nil
  _mapAssoc[1] = "C"
  _mapAssoc[2] = "H"
  _mapAssoc[3] = "S"
  _mapAssoc[4] = "STORE"

for i,row in ipairs(_map) do
  for j,value in ipairs(row) do
    if value > 0 then
      ch.map[j][i] = _mapAssoc[value]
    end
  end
end

local startTime = 0
local passengersCreated = false
local maxTime = 300
local passengersRemaining = 10
local startupMessage =  "Fast geschafft. \n \n Du hast in 10 Minuten mindestens 10 Fahrgäste ans Ziel zu bringen. \n Diese Fahrgäste werden zufällig Platziert. \n Nützliche Tasten bleiben: 'm' und die 'Leertaste'." 

function ch.start()
  challenges.setMessage(startupMessage)
end

function ch.update(time)
  math.random()
  if time > 2 and not passengersCreated then
    for i=1,10 do
      passenger.new()
    end
    passengersCreated = true
  end
  if time <= 20 and time >= 10 then
    challenges.removeMessage()
  end
  if time > maxTime then
    if passengersRemaining <= 0 then
      return "won", "Du hast diese Herausforderung gemeistert"
    end
    return "lost", "Passagiere sind nicht am Zielort angekommen"
  end
  challenges.setStatus("Map by mxst\n" .. math.floor(maxTime-time) .. " Sekunden verbleiben. \n Schon " .. 10 - passengersRemaining .. " Passagiere!")
end

function ch.passengerDroppedOff(tr, p)
  if tr.tileX == p.destX and tr.tileY == p.destY then   
    passengersRemaining = passengersRemaining - 1
    passenger.new()
  end
  passenger.new()
end

return ch
