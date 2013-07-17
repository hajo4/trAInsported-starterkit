function createChallenge(name, map, options)
	table = readMap(map)

	version = options["version"] or 1
	maxTrains = options["maxTrains"] or 1
	startMoney = options["startMoney"] or 25

	header = "
		local ch = {} \n
		ch.name = \""..name.."\" \n
		ch.version = \""version"\" \n
		ch.maxTrains =  "maxTrains"\n
		ch.startMoney = "..startMoney.." \n
		ch.map = challenges.createEmptyMap("..#table[1]..","..#table..") \n
		\n \n
	"
	for x,row in ipairs(table) do
		for y,value in ipairs(row) do
			if value then
				str = str .. "ch.map[" .. x .. "][" .. y .. "] = \"" .. value .. "\" \n"
			end
		end
	end

	boilerplate = "
		local startTime = 0
		local passengersCreated = false
		local maxTime = 180
		local passengersRemaining = 4
		local startupMessage = "Welcome.."

		function ch.start()
			challenges.setMessage(startupMessage)
		end

		function ch.update(time)
			if time > 3 and not passengersCreated then
				passengersCreated = true
				passenger.new( 1, math.random(4) , 10, math.random(4) + 3 )
				passenger.new( 1, math.random(4) , 7, math.random(4) + 3 )
				
				passenger.new( 4, math.random(4) , 7, math.random(4) + 3 )
				passenger.new( 4, math.random(4) , 10, math.random(4) + 3 )
				passengersRemaining = 4
			end
			if time > maxTime then
				return \"lost\", \"No shopping today...\"
			end
			if passengersRemaining == 0 then
				return \"won\", \"The shopping can begin!\"
			end
			challenges.setStatus(math.floor(maxTime-time) .. \" seconds remaining.\n\" .. passengersRemaining ..\" passengers remaining.\")
		end

		function ch.passengerDroppedOff(tr, p)
			if tr.tileX == p.destX and tr.tileY == p.destY then		
				passengersRemaining = passengersRemaining - 1
			end
		end

		return ch
	"

	file = io.open("/challenge/"..name..".lua", "w")
	file:write(header)
	file:write(str)
	file:write(boilerplate)
	file:close()
end