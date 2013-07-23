local _map = {
  {1,1,1,1,1,0,0,0,0,0,0,},
  {1,3,1,3,1,0,0,0,0,0,0,},
  {1,1,1,1,1,0,1,1,1,1,1,},
  {1,2,1,4,1,0,1,2,1,3,1,},
  {1,1,1,1,1,1,1,1,1,1,1,},
  {0,0,0,0,0,0,1,4,1,2,1,},
  {0,0,0,0,0,0,1,1,1,1,1,},
}



local ch = {}

ch.name = "Herausforderung 1"
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
local maxTime = 60
local passengersRemaining = 1
local startupMessage = "Ein einfacher Start. Du hast eine Minute um den Fahrgast an Ziel zu bringen. \n Nützliche Tasten sind: 'm' und die 'Leertaste'." 

function ch.start()
  challenges.setMessage(startupMessage)
end

function ch.update(time)
  math.random()
  if time > 1 and not passengersCreated then
    passengersCreated = true
    passenger.new( 3, 3 , 10, 7)
    passengersRemaining = 1
  end
  if time <= 20 and time >= 10 then
    challenges.removeMessage()
  end
  if time > maxTime then
    return "lost", "Passagier ist nicht am Zielort angekommen"
  end
  if passengersRemaining == 0 then
    return "won", "Du hast diese Herausforderung gemeistert"
  end
  challenges.setStatus("Map by mxst\n" .. math.floor(maxTime-time) .. " Sekunden verbleiben.")
end

function ch.passengerDroppedOff(tr, p)
  if tr.tileX == p.destX and tr.tileY == p.destY then   
    passengersRemaining = 0
  end
end

return ch
