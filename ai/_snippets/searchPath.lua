

function searchPath( level, railMap, location, target  )
	max_level = railMap.height * railMap.width / 2 -- this is a guess
	if max_level == level then
		return "TOOLONG"
	else
		print(level..": from "..dir2String(railMap,location).." "..(level+1).." to "..target.x.." "..target.y)

		if location.x == target.x and location.y == target.y then
			print(" arrived at target!")
			return {}
		else
			local dirs = getDirections( railMap, location )

			local path = {}
			local min = max_level+100
			for index, dir in pairs(dirs) do 
				local new_loc = goDir( railMap, location, dir )
				local res = searchPath( level+1, railMap, new_loc, target )
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