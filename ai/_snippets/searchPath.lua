function searchPath( value, dir, x, y, destX, destY, railMap )
	path = {}
	value = value + 1
	if dir == "N" then y = y-1 end
    if dir == "S" then y = y+1 end
    if dir == "E" then x = x+1 end
    if dir == "W" then x = x-1 end
    
    if x == destX and y == destY then
    	new_dir_tmp = dir
    else
		new_dirs = getDirections(railMap, x, y)
		min = nil
		new_dir_tmp = nil
		for new_dir in new_dirs do 
			path = searchPath( value, dir, x, y, destX, destY, railMap )
			if #path < min then
				min = #path
				new_dir_tmp = new_dir
			end
		end
	end
	prepend({new_dir_tmp}, path)
	return path
end
